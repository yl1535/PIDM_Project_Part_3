DROP DATABASE IF EXISTS databaseProj;
CREATE DATABASE databaseProj;
USE databaseProj;

CREATE TABLE IF NOT EXISTS Users (
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Usr VARCHAR(30) PRIMARY KEY,
    Pwd VARCHAR(30) NOT NULL,
    UsrType ENUM('Passenger', 'Representative', 'Admin') NOT NULL
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

CREATE TABLE IF NOT EXISTS QuestionBox (
	Usr VARCHAR(30) NOT NULL,
    QTitle VARCHAR(20) NOT NULL,
    Question VARCHAR(200) NOT NULL,
    QCode INTEGER PRIMARY KEY,
    Reply VARCHAR(200),
    ReplyUsr VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS Train (
    TrainTid VARCHAR(50) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS TrainSchedule (
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    Linename VARCHAR(50) NOT NULL,
    TotalFare INT NOT NULL,
    PRIMARY KEY (TrainTid, ScheduleTid),
    FOREIGN KEY (TrainTid) REFERENCES Train(TrainTid)
);

CREATE TABLE IF NOT EXISTS Station (
    Sid VARCHAR(50) PRIMARY KEY,
    Stationname VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Stops (
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    Sid VARCHAR(50) NOT NULL,
    Deptime DATETIME,
    Arrtime DATETIME,
    PRIMARY KEY (TrainTid, ScheduleTid, Sid),
    FOREIGN KEY (TrainTid, ScheduleTid) REFERENCES TrainSchedule(TrainTid, ScheduleTid) ON UPDATE CASCADE,
    FOREIGN KEY (Sid) REFERENCES Station(Sid)
);

CREATE TABLE IF NOT EXISTS Reservations (
    RN INT NOT NULL,
    ReservateDate DATE NOT NULL,
    IfChild BOOLEAN NOT NULL,
    IfSenior BOOLEAN NOT NULL,
    IfDisabled BOOLEAN NOT NULL,
    IfRound BOOLEAN NOT NULL,
    Usr VARCHAR(30) NOT NULL,
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    PRIMARY KEY (Usr, RN, TrainTid, ScheduleTid),
    FOREIGN KEY (Usr) REFERENCES Passengers(Usr),
    FOREIGN KEY (TrainTid, ScheduleTid) REFERENCES TrainSchedule(TrainTid, ScheduleTid) ON UPDATE CASCADE
);

/* CREATE TABLE IF NOT EXISTS Pass (
    Usr VARCHAR(30) NOT NULL,
    RN INT NOT NULL,
    TrainTid VARCHAR(50) NOT NULL,
    ScheduleTid VARCHAR(50) NOT NULL,
    Sid VARCHAR(50) NOT NULL,
    IfStart BOOLEAN NOT NULL,
    PRIMARY KEY (Usr, RN, TrainTid, ScheduleTid, Sid),
    FOREIGN KEY (Usr, RN, TrainTid, ScheduleTid) REFERENCES Reservations(Usr, RN, TrainTid, ScheduleTid),
    FOREIGN KEY (Sid) REFERENCES Station(Sid)
); */ /*Not sure if this table is needed */

CREATE TABLE IF NOT EXISTS SearchResults (	/* This is a temporary storage use table, do not need to include in ER diagram */
	ScheduleTid VARCHAR(50) PRIMARY KEY,
    TrainTid VARCHAR(50) NOT NULL,
    Linename VARCHAR(50) NOT NULL, 
    OSid VARCHAR(50) NOT NULL,
    DSid VARCHAR(50) NOT NULL,
    Otime DATETIME NOT NULL,
    Dtime DATETIME NOT NULL,
    Fare INT NOT NULL
);

INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType)
VALUES ('Customer', 'Test', 'CuTest', 'CuPassword', 'Passenger');
INSERT INTO Passengers (Usr, Email)
VALUES ('CuTest', 'CuTest@rutgers.edu');

INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType)
VALUES ('Representative', 'Test', 'CRTest', 'CRPassword', 'Representative');
INSERT INTO Employees (Usr, SSN)
VALUES ('CRTest', '768312');

INSERT INTO Users (Firstname, Lastname, Usr, Pwd, UsrType)
VALUES ('Admin', 'Test', 'AdTest', 'AdPassword', 'Admin');
INSERT INTO Employees (Usr, SSN)
VALUES ('AdTest', '511231');

INSERT INTO QuestionBox (Usr, QTitle, Question, QCode, Reply, ReplyUsr)
VALUES ('CuTest', 'TestQuestion', 'This is a Test Question Message', 0, null, null),
('CuTest', 'AnsweredQuestion', 'This is a Test Answered Question', 1, 'This is Answer', 'CRTest'),
('AdTest', 'TestOnlyQuestion', 'This is a illegal Question', 2, 'This is Not Answer', 'AdTest');

INSERT INTO Train (TrainTid) VALUES ('T001');
INSERT INTO Train (TrainTid) VALUES ('T002');

INSERT INTO TrainSchedule (TrainTid, ScheduleTid, Linename, TotalFare) VALUES ('T001', 'S001', 'Blue Line', 140);
INSERT INTO TrainSchedule (TrainTid, ScheduleTid, Linename, TotalFare) VALUES ('T002', 'S002', 'Green Line', 120);
INSERT INTO TrainSchedule (TrainTid, ScheduleTid, Linename, TotalFare) VALUES ('T001', 'S003', 'Red Line', 100);
INSERT INTO TrainSchedule (TrainTid, ScheduleTid, Linename, TotalFare) VALUES ('T001', 'S004', 'Dead Line', 100);

INSERT INTO Station (Sid, Stationname, city, state) VALUES ('ST001', 'Central Station', 'New York', 'NY');
INSERT INTO Station (Sid, Stationname, city, state) VALUES ('ST002', 'West Station', 'Chicago', 'IL');

INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T001', 'S001', 'ST001', null, '2025-07-16 10:00:00');
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T001', 'S001', 'ST002', '2025-07-16 09:00:00', null);
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T002', 'S002', 'ST002', null, '2025-07-16 11:00:00');
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T002', 'S002', 'ST001', '2025-07-16 10:00:00', null);
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T001', 'S003', 'ST001', null, '2025-07-16 19:00:00');
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T001', 'S003', 'ST002', '2025-07-16 18:00:00', null);
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T001', 'S004', 'ST001', null, '2023-07-16 10:00:00');
INSERT INTO Stops (TrainTid, ScheduleTid, Sid, Deptime, Arrtime) VALUES ('T001', 'S004', 'ST002', '2023-07-16 09:00:00', null);

INSERT INTO Reservations (RN, ReservateDate, IfChild, IfSenior, IfDisabled, IfRound, Usr, TrainTid, ScheduleTid)
VALUES (1, '2022-07-16', false, false, false, false, 'CuTest', 'T001', 'S004');

