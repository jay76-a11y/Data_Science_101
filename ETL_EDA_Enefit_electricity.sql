-- in here we follow the starter given by the competition
-- dataset can be reached by this link ==> https://www.kaggle.com/competitions/predict-energy-behavior-of-prosumers

use etl_enefit;
show tables;

-- data cleaning for base_model data
select * from base_model limit 100; 
alter table base_model drop column row_id;
select * from base_model limit 100; 

-- data cleaning for county
select * from county limit 50;
-- to make this applicable, we need

-- data cleaning for electricity_prices
select * from electricity_prices limit 50;
alter table electricity_prices rename column data_block_id to data_block_id_electricity;
alter table electricity_prices rename column data_block_id to data_block_id_electricity;
alter table electricity_prices rename column euros_per_mwh to euros_per_mwh_electricity;
UPDATE electricity_prices SET forecast_date = forecast_date + INTERVAL '1' DAY;
select * from electricity_prices limit 50;

-- data cleaning for gas_prices
select * from gas_prices limit 100;
-- add mean of price
alter table gas_prices add column mean_price float;
update gas_prices set mean_price =  (lowest_price_per_mwh + highest_price_per_mwh)/2;
select * from gas_prices limit 100;
alter table gas_prices rename column data_block_id to data_block_id_gas;
alter table gas_prices rename column forecast_date to forecast_date_gas;
alter table gas_prices rename column origin_date to origin_date_gas;
alter table gas_prices rename column mean_price to mean_price_gas;
alter table gas_prices rename column highest_price_per_mwh to highest_price_per_mwh_gas;
alter table gas_prices rename column lowest_price_per_mwh to lowest_price_per_mwh_gas;
select * from gas_prices limit 100;

-- data cleaning client data
select * from client limit 100;
-- change name to easier drop
alter table client rename column product_type to product_type_client;
alter table client rename column county to county_client;
 alter table client rename column is_business to is_business_client;
alter table client rename column data_block_id to data_block_id_client;
select * from client limit 100;

----------------------------------------------------------------------------------------------------------------------------------------
-- combine data
CREATE TABLE combine_1 AS
SELECT base_model.*, client.eic_count, client.installed_capacity
FROM base_model
LEFT JOIN client ON 
    client.county_client = base_model.county
    AND client.is_business_client = base_model.is_business
    AND client.product_type_client = base_model.product_type
    AND client.data_block_id_client = base_model.data_block_id;
    
CREATE TABLE combine_2 AS
SELECT combine_1.*, electricity_prices.euros_per_mwh_electricity
FROM combine_1
LEFT JOIN electricity_prices ON 
    electricity_prices.forecast_date = combine_1.datetime
    AND electricity_prices.data_block_id_electricity = combine_1.data_block_id;

CREATE TABLE combined AS
SELECT combine_2.*, gas_prices.lowest_price_per_mwh_gas, gas_prices.highest_price_per_mwh_gas, gas_prices.mean_price_gas
FROM combine_2
LEFT JOIN gas_prices ON 
    gas_prices.data_block_id_gas = combine_2.data_block_id;

-- check on combined data
select*from combined limit 100;

-------------------------------------------------------------------------------------------------------------------------------------
-- simple EDA
-- check which county has the most installed capacity
select county, sum(installed_capacity) from combined group by county order by sum(installed_capacity) desc;

-- check which county has the most mean gas prices
select county, sum(mean_price_gas) from combined group by county order by sum(mean_price_gas) desc;

-- check which county has the most electricity prices
select county, sum(euros_per_mwh_electricity) from combined group by county order by sum(euros_per_mwh_electricity) desc;



