/*-----------Lior Lugasi, 203962006-----------*/

alter session set nls_date_format='DD/MM/YY';

------------------q1-----------------
DROP TABLE Docking;
DROP TABLE Piers;
DROP TABLE Ships;

CREATE TABLE Piers 
(
    pid NUMBER(2) PRIMARY KEY,
    name VARCHAR2(2),
    capacity NUMBER(6) NOT NULL,
    type VARCHAR2(20) UNIQUE,
    total_ships NUMBER(6) DEFAULT 0
);




CREATE TABLE Ships 
(
    sid NUMBER(5) PRIMARY KEY,
    name VARCHAR2(4),
    country VARCHAR(20),
    cargoWeight NUMBER(6) NOT NULL
);


CREATE TABLE Docking 
(
    sid NUMBER(5),
    pid NUMBER(2),
    arrivalDate DATE,
    departureDate DATE,
    PRIMARY KEY(sid,pid),
    CONSTRAINT fk_sid FOREIGN KEY (sid) REFERENCES Ships(sid),
    CONSTRAINT fk_pid FOREIGN KEY (pid) REFERENCES Piers(pid)
);

/*-------------------q2-------------------*/
CREATE OR REPLACE TRIGGER trigger1
BEFORE INSERT ON Docking
FOR EACH ROW
DECLARE
    CARW SHIPS.CARGOWEIGHT%TYPE;        --For checking the cargo weight of the ship
    CAP PIERS.CAPACITY%TYPE;                    --For checking the capcity of the pier
    cnt1 NUMBER(6) DEFAULT 0;                       --For checking if the cargo weight of the ship smaller then the capcity of the pier
    cnt2 NUMBER(6) DEFAULT 0;                   --For checking if the departure date of the ship bigger then the arrival date
    exp1 EXCEPTION;
    exp2 EXCEPTION;
BEGIN
        SELECT SHIPS.CARGOWEIGHT INTO CARW
        FROM SHIPS
        WHERE :new.SID=SHIPS.SID;
        SELECT PIERS.CAPACITY INTO CAP
        FROM PIERS
        WHERE :new.PID=PIERS.PID;
        IF (CARW<=CAP) THEN     --For checking the cargo weight of the ship
            cnt1:=1;
            IF (:new.departureDate>=:new.arrivalDate) THEN    --For checking if the departure date of the ship bigger then the arrival date
                UPDATE Piers 
                SET TOTAL_SHIPS=TOTAL_SHIPS+1 
                WHERE PIERS.PID=:NEW.PID;
                cnt2:=1;
            END IF;
        END IF;   
    IF cnt1=0 THEN
        RAISE exp1;         --EXCEPTION
    END IF; 
    IF cnt2=0 THEN
        RAISE exp2;          --EXCEPTION
    END IF;
    EXCEPTION 
        WHEN exp1 THEN
        raise_application_error (-20001,'The cargoweight smallr then the capacity.');   --This statement can be used to pass error information back to a calling program
        WHEN exp2 THEN
        raise_application_error (-20001,'The departureDate smallr then the arrivalDate.');--This statement can be used to pass error information back to a calling program
END;
/

---------------------------------q3--------------------------
INSERT INTO Piers (pid, Name, capacity,type)
VALUES (1, 'A', 30000, 'agricultural exports');
INSERT INTO Piers (pid, Name, capacity,type)
VALUES (2, 'B', 30000, 'timber');
INSERT INTO Piers (pid, Name, capacity,type)
VALUES (3, 'C', 30000, 'metals');
INSERT INTO Piers (pid, Name, capacity,type)
VALUES (4, 'D', 30000, 'sling');
INSERT INTO Piers (pid, Name, capacity,type)
VALUES (5, 'E', 60000, 'Panamax');
INSERT INTO Piers (pid, Name, capacity,type)
VALUES (6, 'F', 30000, 'bulk');


INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (11, 's1', 'China', 30000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (22, 's2', 'Zimbabwe', 25000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (33, 's3', 'Guatemala', 15000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (44, 's4', 'China', 25000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (55, 's5', 'Marshall Islands', 20000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (66, 's6', 'Russia', 20000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (77, 's7', 'Malta', 45000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (88, 's8', 'Panama', 50000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (99, 's9', 'Malta', 15000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (1010, 's10', 'Marshall Islands', 20000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (1111, 's11', 'Liberia', 25000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (1212, 's12', 'Liberia', 15000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (1313, 's13', 'Zimbabwe', 20000);
INSERT INTO Ships (sid, name, country,cargoWeight)
VALUES (1414, 's14', 'Panama', 55000);


INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (88, 5, '15/08/17', '15/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (22, 1, '17/08/17', '18/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (1414, 5, '16/08/17', '16/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (1010, 3, '15/08/17', '19/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (99, 2, '16/08/17', '16/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (33, 2, '15/08/17', '15/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (66, 3, '17/08/17', '19/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (1111, 5, '16/08/17', '16/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (1212, 2, '15/08/17', '15/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (55, 4, '17/08/17', '20/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (77, 5, '16/08/17', '16/08/17');
INSERT INTO Docking (sid, pid, arrivalDate, departureDate)
VALUES (44, 1, '16/08/17', '17/08/17');


---------------------q4a----------------------------------
SET SERVEROUTPUT ON
DECLARE
MAX1 DOCKING%ROWTYPE;  --Table for the ships whose decomposition was longest, type like DOCKING table (same fields)
TEMP1 DOCKING%ROWTYPE;      --Temporary table for ships , type like DOCKING table  (same fields)
DELAY NUMBER (6) DEFAULT 0;
CNT NUMBER;
CURSOR C1CURSOR IS      --Use for recieving the data for the correct pier
SELECT SID, PID,arrivalDate, departureDate
FROM DOCKING
WHERE PID=&P_NUM;
BEGIN
    CNT:=0;
    OPEN C1CURSOR;      
    FETCH C1CURSOR INTO TEMP1;      --Getting the first line into the temporary table
    MAX1:=TEMP1;
    LOOP
        EXIT WHEN C1CURSOR%NOTFOUND;        --Stop when arriving to the end of the cursor
        CNT:=CNT+1;
        IF(TEMP1.departureDate-TEMP1.arrivalDate>MAX1.departureDate-MAX1.arrivalDate) THEN  --Ifthere is data with bigger delay time
            MAX1:=TEMP1;
        END IF;
        FETCH C1CURSOR INTO TEMP1;
    END LOOP;
    CLOSE C1CURSOR;
    IF CNT>0 THEN
        DBMS_OUTPUT.put_line('This report for pier: ' || MAX1.pid );
        OPEN C1CURSOR;
        FETCH C1CURSOR INTO TEMP1;
        LOOP                                                                                --This loop is For printing the correct data
            EXIT WHEN C1CURSOR%NOTFOUND;
            IF (TEMP1.departureDate-TEMP1.arrivalDate=MAX1.departureDate-MAX1.arrivalDate) THEN
                DELAY :=TEMP1.departureDate-TEMP1.arrivalDate;
                 DBMS_OUTPUT.put_line(TEMP1.SID || ' | ' ||TEMP1.arrivalDate || ' | ' || TEMP1.departureDate || ' | ' ||  DELAY || ' days');
           END IF;
             FETCH C1CURSOR INTO TEMP1;
        END LOOP;
        CLOSE C1CURSOR;
    ELSE
         DBMS_OUTPUT.put_line('THERE IS NO PIER WITH THAT NUMBER');
    END IF;
END;
/

---------------------q4b----------------------------------
SET SERVEROUTPUT ON
DECLARE
MAX2 DOCKING%ROWTYPE;       --Table for the ships whose decomposition was longest, type like DOCKING table (same fields)
DELAY1 NUMBER (6) DEFAULT 0;            --Variable that saves the days of the ships whose decomposition was longest 
cnt NUMBER(6) DEFAULT 0;
cnt2 NUMBER(6) DEFAULT 0;
CURSOR C2CURSOR IS                                                  --Use for recieving the data for the correct pier
SELECT SID, PID,arrivalDate, departureDate
FROM DOCKING
WHERE PID=&P_NUM;
BEGIN
    FOR rec IN C2CURSOR   --For loop, rec is a line 
    LOOP
        CNT2:=1;
        IF cnt=0 THEN           --For the first round in the loop
            MAX2:=rec;
            cnt:=1;
        END IF;
        IF(rec.departureDate-rec.arrivalDate>MAX2.departureDate-MAX2.arrivalDate) THEN
            MAX2:=rec;
        END IF;
    END LOOP;
    IF CNT2>0 THEN
        DBMS_OUTPUT.put_line('This report for pier: ' || MAX2.pid );
        FOR rec IN C2CURSOR                             --This loop is For printing the correct data
        LOOP
            IF (rec.departureDate-rec.arrivalDate=MAX2.departureDate-MAX2.arrivalDate) THEN
                DELAY1 :=rec.departureDate-rec.arrivalDate;
                 DBMS_OUTPUT.put_line(rec.SID || ' | ' ||rec.arrivalDate || ' | ' || rec.departureDate || ' | ' ||  DELAY1 || ' days');
           END IF;
        END LOOP;
    ELSE
        DBMS_OUTPUT.put_line('THERE IS NO PIER WITH THAT NUMBER');
    END IF;
END;
/

---------------------q5----------------------------------

SET SERVEROUTPUT ON

-----A block that will receive a date range from the user and call the function SHIPS_IN_PORT-----
DECLARE
NUM_OF_SHIPS NUMBER;                            --Ships in port
ARR DOCKING.ARRIVALDATE%TYPE;           --Arrival date
DER DOCKING.departureDate%TYPE;         --Departure date
BEGIN
    ARR:='&ARRIVAL';                --Input fromthe user
    DER:='&DEPARTURE';              --Input fromthe user
    NUM_OF_SHIPS:=SHIPS_IN_PORT(ARR,DER);   --Function call
    IF(NUM_OF_SHIPS=-2) THEN                --If there are no ships in the port
        DBMS_OUTPUT.put_line('NO SHIPS BETWEEN THE DATES YOU ENTERED');
    ELSE
        DBMS_OUTPUT.put_line('FROM ' || ARR || ' ' || ' TO ' || DER|| ' THERE WAS: ' || NUM_OF_SHIPS || ' SHIPS');
    END IF;
END;
/


--A function that receives a date period (date from and date to) and returns the number of ships that were in the port during this period
CREATE OR REPLACE FUNCTION SHIPS_IN_PORT(ARR DATE, DER DATE) 
RETURN NUMBER       --Type return
IS
NUM_SHIPS NUMBER;  --Number of ships in the port in that period
EXP3 EXCEPTION;
CURSOR C3CURSOR IS      --Recieving  data from Docking table
SELECT SID, PID,arrivalDate, departureDate
FROM DOCKING;
BEGIN 
    NUM_SHIPS :=0;          
    FOR REC IN C3CURSOR             --For loop, counting the number of ships in the period
    LOOP
        IF (REC.ARRIVALDATE<=ARR AND  REC.DEPARTUREDATE>=DER) THEN
            NUM_SHIPS:=NUM_SHIPS+1;
        END IF;
    END LOOP;
    IF NUM_SHIPS=0 THEN
        NUM_SHIPS:=-2;
        RAISE EXP3;
    ELSE
        PRINT_ALL(ARR, DER);
        RETURN NUM_SHIPS;
    END IF;
    EXCEPTION
        WHEN EXP3 THEN
            RETURN NUM_SHIPS;
END;
/

--An auxiliary procedure that receives a date range and prints a list of the anchored ship details that were anchored during this period
CREATE OR REPLACE PROCEDURE  PRINT_ALL(ARR DATE, DER DATE) 
IS
S_NAME SHIPS.NAME%TYPE;  --Ship name
P_NAME PIERS.NAME%TYPE;      --Pier name
CURSOR C4CURSOR IS     --Recieving  data from Docking table
SELECT SID,PID,arrivalDate, departureDate
FROM DOCKING;
BEGIN
    FOR REC IN C4CURSOR             --For loop, using for printing the correct data
    LOOP
        IF (REC.ARRIVALDATE<=ARR AND  REC.DEPARTUREDATE>=DER) THEN
            SELECT SHIPS.NAME INTO S_NAME FROM SHIPS WHERE REC.SID=SHIPS.SID;
            SELECT PIERS.NAME INTO P_NAME FROM PIERS WHERE REC.PID=PIERS.PID;
           DBMS_OUTPUT.put_line(S_NAME || ' | ' ||P_NAME || ' | ' || REC.arrivalDate || ' | ' ||  REC.departureDate);
        END IF;
    END LOOP;
END;
/



------------------q6-----------------

-----A block that will receive a country name from the user and call the function COUNTRY_DOCKING-----
SET SERVEROUTPUT ON

DECLARE 
C_N SHIPS.COUNTRY%TYPE;
BEGIN
    C_N:='&COUNTRY_NAME';   --Recieving country name
     COUNTRY_DOCKING(C_N);  --Function call
END;
/

--A procedure that will receive the name of the country and print out the shipyard details of the ships from that country
CREATE OR REPLACE PROCEDURE COUNTRY_DOCKING(COUNTRY_N VARCHAR)
IS
S_NUM NUMBER;   --Number of ships
C_AVG NUMBER;       --Average cargo weight of the ships 
EXP4 EXCEPTION;     --If there are no ships
COUNTRY_NAME VARCHAR(20);
CURSOR C5CURSOR IS          --Cursor for saving the docking of ships from the correct country
    SELECT SID,PID,ARRIVALDATE,DEPARTUREDATE
    FROM DOCKING
    WHERE SID IN
        (SELECT SID
        FROM SHIPS
        WHERE SHIPS.COUNTRY=COUNTRY_NAME);
BEGIN
    COUNTRY_NAME:=COUNTRY_N;
    S_NUM:=0;
    C_AVG :=0;
    FOR REC IN C5CURSOR   --For loop, counting the ships
    LOOP
        S_NUM:=S_NUM+1;
    END LOOP;
    IF(S_NUM>0) THEN        --If there are ships
        FOR REC1 IN C5CURSOR        --For loop for printing the correct data
        LOOP
            DBMS_OUTPUT.put_line(REC1.SID || ' | ' || REC1.PID || ' | ' || REC1.arrivalDate || ' | ' ||  REC1.departureDate);
        END LOOP;
        SELECT AVG(SHIPS.CARGOWEIGHT) INTO C_AVG        --Calculating the cargo weight average
        FROM SHIPS
        WHERE SHIPS.COUNTRY=COUNTRY_NAME;
        DBMS_OUTPUT.put_line(' Total ships: ' || S_NUM);
        DBMS_OUTPUT.put_line('Average weight: ' || C_AVG);
        ELSE        
            RAISE EXP4;
    END IF;
     EXCEPTION
        WHEN EXP4 THEN
            DBMS_OUTPUT.put_line('No ship anchored in the country');
END;
/


