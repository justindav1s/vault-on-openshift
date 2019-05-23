#!/usr/bin/env bash


psql << EOF
CREATE USER demouser SUPERUSER LOGIN PASSWORD 'changeme';
\du
\l
EOF

psql postgres demouser  << EOF
CREATE SEQUENCE demo_seq INCREMENT BY 1 MINVALUE 1000 MAXVALUE 999999 START WITH 1000 CYCLE;
CREATE TABLE persons(PersonID int,lastName varchar(255),firstName varchar(255),address varchar(255),city varchar(255), PRIMARY KEY (PersonID));
CREATE TABLE bookings (personID int,bookingId int,flightnum varchar(255),tickets int,cabin  varchar(255), PRIMARY KEY (bookingId));
CREATE TABLE flights(flightnum varchar(255),origin varchar(255),destination varchar(255),PRIMARY KEY (flightnum));
CREATE TABLE loyalty(PersonID int, tier varchar(255), points int);

INSERT INTO persons (PersonID, lastName, firstName, address, city) VALUES (1, 'Davis', 'Justin', 'The Stooop', 'Twickenham');
\d

SELECT * from persons;


EOF