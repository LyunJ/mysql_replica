from datetime import datetime, timedelta
from textwrap import dedent

# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG

# Operators; we need this to operate!
from airflow.operators.bash import BashOperator

from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.mysql.operators.mysql import MySqlOperator

from airflow.decorators import task
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.mysql.hooks.mysql import MySqlHook

from pandas import DataFrame

DAG_ID="mysql_to_postgre_tutorial"

dag=DAG(
    dag_id=DAG_ID,
    start_date=datetime(2020, 2, 2),
    schedule="@once",
    catchup=False
)

preparing_order_table=PostgresOperator(
    task_id="preparing_order_table",
    postgres_conn_id="datawarehouse_postgre_conn",
    sql="sql/postgre_preparing_order_table.sql",
    dag=dag
)
create_postgre_order_table=PostgresOperator(
    task_id="create_postgre_order_table",
    postgres_conn_id="datawarehouse_postgre_conn",
    sql="sql/postgre_create_order_table.sql",
    dag=dag
)

check_mysql_book_order_exists_sql="""
SELECT EXISTS(SELECT * FROM book_order) AS checker;
"""

@task(task_id="check_mysql_book_order_exists")
def check_mysql_book_order_exists():
    mysql_hook : MySqlHook = MySqlHook(mysql_conn_id="datasource_mysql_conn")

    checker : int = mysql_hook.get_records(sql=check_mysql_book_order_exists_sql)
    
    if checker == 1 : 
        return 1
    elif checker == 0 :
        return 0
    else :
        return -1

@task.branch(task_id="book_order_branch")
def book_order_branch(ti):
    xcom_value = int(ti.xcom_pull(task_ids="check_mysql_book_order_exists"))
    if xcom_value == 1:
        return "get_order_data_from_mysql"
    elif xcom_value == 0:
        return "stop_task"
    else:
        return None

@task(task_id="book_order_bulk_insert")
def book_order_bulk_insert():
    mysql_hook : MySqlHook = MySqlHook(mysql_conn_id="datasource_mysql_conn")
    postgre_hook : PostgresHook = PostgresHook(postgres_conn_id="datawarehouse_postgre_conn")

    mysql_hook.bulk_dump(table="book_order",tmp_file='tmp/book_order')


mysql_get_order_sql="""
    SELECT bo.id AS order_id,
       bo.user_id AS user_id,
       bo.status AS order_status,
       u.name AS user_name,
       u.nick AS user_nick,
       ua.gis AS user_gis,
       bod.book_id AS book_id,
       b.title AS book_title,
       b.subtitle AS book_subtitle,
       bod.book_count AS book_order_count,
       bod.price AS book_order_price
FROM book_order bo
    LEFT JOIN user u on bo.user_id = u.id
    LEFT JOIN user_address ua on u.id = ua.user_id
    LEFT JOIN book_order_detail bod on bo.id = bod.book_order_id
    LEFT JOIN book b on bod.book_id = b.id
WHERE bo.create_dt > %(current_date)s
ORDER BY bo.id ASC
    """

@task(task_id="get_order_data_from_mysql")
def get_order_data_from_mysql():
    mysql_hook : MySqlHook = MySqlHook(mysql_conn_id="datasource_mysql_conn")
    postgre_hook : PostgresHook = PostgresHook(postgres_conn_id="datawarehouse_postgre_conn")

    records = mysql_hook.get_records(sql=mysql_get_order_sql, parameters={'current_date' : '2023-04-21', 'limit' : 10})
    postgre_hook.insert_rows(table="book_order", rows=records)

preparing_order_table >> create_postgre_order_table >> get_order_data_from_mysql()