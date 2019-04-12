CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.random_events_tmp;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_events_tmp
(product_name string, product_price double, product_category string, ip_address string, purchase_date string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://ip-10-0-0-207.us-west-1.compute.internal:8020/user/jsobyra/events/19/04/10/';

DROP TABLE IF EXISTS jsobyra.random_events;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_events
(product_name string, product_price double, product_category string, ip_address string)
PARTITIONED BY (purchase_date string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://ip-10-0-0-207.us-west-1.compute.internal:8020/user/jsobyra/events/19/04/10/';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-01')
SELECT product_name, product_price, product_category, ip_address FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-01';