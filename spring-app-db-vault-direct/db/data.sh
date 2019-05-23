#!/usr/bin/env bash


psql << EOF
CREATE USER demouser SUPERUSER LOGIN PASSWORD 'changeme';
\du
\l
EOF

psql postgres demouser  << EOF
CREATE TABLE person(PersonID int,lastName varchar(255),firstName varchar(255),address varchar(255),city varchar(255), PRIMARY KEY (PersonID));
CREATE TABLE booking (personID int,bookingId int,flightnum varchar(255),tickets int,cabin  varchar(255), PRIMARY KEY (bookingId));
CREATE TABLE flight(flightnum varchar(255),origin varchar(255),destination varchar(255),PRIMARY KEY (flightnum));

INSERT INTO person (PersonID, lastName, firstName, address, city) VALUES (1, 'Davis', 'Justin', 'The Stooop', 'Twickenham');
\d

SELECT * from person;


EOF