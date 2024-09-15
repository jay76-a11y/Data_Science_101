USE screening_test_schoters;
SHOW TABLES;
SELECT * FROM campaign;
SELECT * FROM customer;
SELECT * FROM transaksi;

/*

-- to change column name

ALTER TABLE campaign
RENAME COLUMN ï»¿Name TO Name;

ALTER TABLE customer
RENAME COLUMN ï»¿Name TO Name;

-- if this doesn't work, just alter it directly from the schemas
ALTER TABLE transaksi
RENAME COLUMN "ï»¿Tanggal Transaksi" TO Tanggal;
*/

-- dropna
delete from transaksi where Harga = '';
select*from transaksi;

-- Get total transaction happen
select count(Customer) from transaksi;

-- change from Rp to numeric value
alter table transaksi add HargaBaru int;
update transaksi set HargaBaru = replace(replace(Harga, 'Rp', ''),'.00', '');
alter table transaksi drop column Harga;
alter table transaksi rename column HargaBaru to Harga;
select*from transaksi;

-- check total transaction happen
select sum(Harga) from transaksi;

-- check each individus total transactions
select Customer, sum(Harga) from transaksi group by Customer;

-- to see total transaction in each city, we have to join the data first
create table new_transaksi as select  transaksi.*, customer.Domisili from customer join transaksi on transaksi.Customer = customer.Name;

-- now we can check total transaction in each area
select Domisili, sum(Harga) from new_transaksi group by Domisili;

-- check out the new data
select*from transaksi



