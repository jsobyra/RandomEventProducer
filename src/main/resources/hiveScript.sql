add jar /IpParser.jar;
add file /ips.csv;
DROP FUNCTION IF EXISTS in_range;
create function in_range as 'udf.Test';

CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.random_locations;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_locations
(geoname_id string, locale_code string, continent_code string, continent_name string, country_iso_code string,
country_name string, subdivision_1_iso_code string, subdivision_1_name string, subdivision_2_iso_code string,
subdivision_2_name string, city_name string, metro_code string, time_zone string, is_in_european_union string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/locations/';

CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.random_ips;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_ips
(network string, geoname_id string, registered_country_geoname_id string, represented_country_geoname_id string,
is_anonymous_proxy string, is_satellite_provider string, postal_code string, latitude string, longitude string,
accuracy_radius string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/ips/';

CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.random_events_tmp;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_events_tmp
(product_name string, product_price double, product_category string, ip_address string, purchase_date string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/events/19/06/11/';

DROP TABLE IF EXISTS jsobyra.random_events;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_events
(product_name string, product_price double, product_category string, ip_address string, network string)
PARTITIONED BY (purchase_date string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/events/19/06/11/';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-01')
SELECT product_name, product_price, product_category, ip_address, in_range(ip_address, './ips.csv') FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-01';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-02')
SELECT product_name, product_price, product_category, ip_address, in_range(ip_address, './ips.csv') FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-02';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-03')
SELECT product_name, product_price, product_category, ip_address, in_range(ip_address, './ips.csv') FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-03';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-04')
SELECT product_name, product_price, product_category, ip_address, in_range(ip_address, './ips.csv') FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-04';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-05')
SELECT product_name, product_price, product_category, ip_address, in_range(ip_address, './ips.csv') FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-05';

INSERT INTO TABLE jsobyra.random_events partition (purchase_date = '2019-10-06')
SELECT product_name, product_price, product_category, ip_address, in_range(ip_address, './ips.csv') FROM jsobyra.random_events_tmp WHERE purchase_date = '2019-10-06';

CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.result1;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.result1
(product_category string, counter int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/result1/';

CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.result2;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.result2
(product_category string, product_name string, counter int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/result2/';

CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.result3;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.result3
(country_iso_code string, sum int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://172.17.0.2:8020/user/cloudera/result3/';

INSERT INTO TABLE jsobyra.result1
SELECT product_category, COUNT(product_category) AS frequence
FROM jsobyra.random_events
GROUP BY product_category
ORDER BY frequence DESC
LIMIT 10;

INSERT INTO TABLE jsobyra.result2
SELECT product_category, product_name, COUNT(*) AS frequence
FROM jsobyra.random_events
GROUP BY product_category, product_name
ORDER BY frequence DESC
LIMIT 10;

INSERT INTO TABLE jsobyra.result3
SELECT l.country_iso_code, sum(e.product_price) AS sum
FROM jsobyra.random_events e
JOIN jsobyra.random_ips i ON e.network = i.network
JOIN jsobyra.random_locations l ON l.geoname_id = i.geoname_id
GROUP BY country_iso_code
ORDER BY sum DESC
LIMIT 10;


CREATE DATABASE IF NOT EXISTS results;
DROP TABLE results.result1;
CREATE TABLE results.result1
(
    product_category varchar(50) not null,
    frequence int not null
);
DROP TABLE results.result2;
CREATE TABLE results.result2
(
    product_category varchar(50) not null,
    product_name varchar(50) not null,
    frequence int not null
);
DROP TABLE results.result3;
CREATE TABLE results.result3
(
    country_iso_code varchar(50) not null,
    sum int not null
);
