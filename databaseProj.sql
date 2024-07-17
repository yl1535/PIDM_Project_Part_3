DROP DATABASE IF EXISTS databaseProj;
CREATE DATABASE databaseProj;
USE databaseProj;

CREATE TABLE IF NOT EXISTS Users (
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Usr VARCHAR(30) PRIMARY KEY,
    Pwd VARCHAR(30) NOT NULL,
    UsrType VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Employees (
    Usr VARCHAR(30) PRIMARY KEY,
    SSN CHAR(10) NOT NULL,
    FOREIGN KEY (Usr) REFERENCES Users(Usr)
);

CREATE TABLE IF NOT EXISTS Passengers (
    Usr VARCHAR(30) PRIMARY KEY,
    Email VARCHAR(30) NOT NULL,
    FOREIGN KEY (Usr) REFERENCES Users(Usr)
);

/* Above is fine, not garenteeing below */

CREATE TABLE IF NOT EXISTS UsrPassengers (
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Usr VARCHAR(30) PRIMARY KEY,
    Pwd VARCHAR(30) NOT NULL,
    Email VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS UsrEmployees (
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Usr VARCHAR(30) PRIMARY KEY,
    Pwd VARCHAR(30) NOT NULL,
    SSN CHAR(9) NOT NULL
);

CREATE TABLE IF NOT EXISTS UsrEmployCustomerRep (
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Usr VARCHAR(30) PRIMARY KEY,
    Pwd VARCHAR(30) NOT NULL,
    SSN CHAR(9) NOT NULL
);

CREATE TABLE IF NOT EXISTS UsrEmployAdmin (
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Usr VARCHAR(30) PRIMARY KEY,
    Pwd VARCHAR(30) NOT NULL,
    SSN CHAR(9) NOT NULL
);

CREATE TABLE IF NOT EXISTS Train (
    TrainTid VARCHAR(50) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Schedule (
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    Linename VARCHAR(50) NOT NULL,
    TotalFare INT NOT NULL,
    PRIMARY KEY (TrainTid, ScheduleTid),
    FOREIGN KEY (TrainTid) REFERENCES Train(TrainTid)
);

CREATE TABLE IF NOT EXISTS Station (
    Sid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Stops (
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    Sid VARCHAR(50) NOT NULL,
    Deptime DATETIME NOT NULL,
    Arrtime DATETIME NOT NULL,
    PRIMARY KEY (TrainTid, ScheduleTid, Sid),
    FOREIGN KEY (TrainTid, ScheduleTid) REFERENCES Schedule(TrainTid, ScheduleTid),
    FOREIGN KEY (Sid) REFERENCES Station(Sid)
);

CREATE TABLE IF NOT EXISTS Reservations (
    RN INT NOT NULL,
    Date DATE NOT NULL,
    IfChild BOOLEAN NOT NULL,
    IfSenior BOOLEAN NOT NULL,
    IfDisabled BOOLEAN NOT NULL,
    IfRound BOOLEAN NOT NULL,
    Usr VARCHAR(30) NOT NULL,
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    PRIMARY KEY (Usr, RN, TrainTid, ScheduleTid),
    FOREIGN KEY (Usr) REFERENCES Passengers(Usr),
    FOREIGN KEY (TrainTid, ScheduleTid) REFERENCES Schedule(TrainTid, ScheduleTid)
);

CREATE TABLE IF NOT EXISTS Pass (
    Usr VARCHAR(30) NOT NULL,
    RN INT NOT NULL,
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    Sid VARCHAR(50) NOT NULL,
    IfStart BOOLEAN NOT NULL,
    PRIMARY KEY (Usr, RN, TrainTid, ScheduleTid, Sid),
    FOREIGN KEY (Usr, RN, TrainTid, ScheduleTid) REFERENCES Reservations(Usr, RN, TrainTid, ScheduleTid),
    FOREIGN KEY (Sid) REFERENCES Station(Sid)
);

INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType)
VALUES ('Customer', 'Test', 'CuTest', 'CuPassword', 'Passenger');
INSERT INTO Passengers (Usr, Email)
VALUES ('CuTest', 'CuTest@rutgers.edu');

INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType)
VALUES ('Representative', 'Test', 'CRTest', 'CRPassword', 'Representative');
INSERT INTO Employees (Usr, SSN)
VALUES ('CuTest', '768312');

INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType)
VALUES ('Admin', 'Test', 'AdTest', 'AdPassword', 'Admin');
INSERT INTO Employees (Usr, SSN)
VALUES ('AdTest', '511231');


