CREATE SCHEMA IF NOT EXISTS jsobyra;
DROP TABLE IF EXISTS jsobyra.random_events;
CREATE EXTERNAL TABLE IF NOT EXISTS jsobyra.random_events
(product_name string, product_price double, product_category string, ip_address string, purchase_date date)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://ip-10-0-0-207.us-west-1.compute.internal:8020/user/jsobyra/events/19/04/10/';



public RandomEvent(String productName, Double productPrice, LocalDate purchaseDate,
                       String productCategory, String ipAddress) {