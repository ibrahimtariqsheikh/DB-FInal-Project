--Creating Tables

CREATE TABLE Category (
    category_id CHAR PRIMARY KEY CHECK(category_id='S' OR category_id='B' OR category_id='G' OR category_id='P'),
    category_discount INT,
    category_description VARCHAR2(255)
)


CREATE TABLE Customer (
    customer_no VARCHAR2(255) PRIMARY KEY,
    customer_name VARCHAR2(255) NOT NULL,
    customer_address VARCHAR2(255),
    category_id CHAR,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
)

CREATE TABLE Artist (
    artist_id VARCHAR2(255) PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    country_of_birth VARCHAR(255),
    year_of_birth int,
    year_of_death int
)


CREATE TABLE Owner (
    owner_id VARCHAR2(255) PRIMARY KEY,
    owner_name VARCHAR2(255) NOT NULL,
    owner_adress VARCHAR2(255),
    owner_tel INT
)

CREATE TABLE Paintings(
    painting_id VARCHAR2(255) PRIMARY KEY,
    painting_title VARCHAR2(255) NOT NULL,
    theme VARCHAR2(255) NOT NULL,
    rental_price INT,
    artist_id VARCHAR2(255),
    owner_id VARCHAR2(255),
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id),
    FOREIGN KEY (owner_id) REFERENCES Owner(owner_id)
)


CREATE TABLE Rental_report (
    customer_no VARCHAR2(255),
    painting_id VARCHAR2(255),
    hire_date DATE,
    due_date_back DATE,
    return_status CHAR CHECK (return_status='Y' OR return_status='N'),
    FOREIGN KEY (customer_no) REFERENCES Customer(customer_no),
    FOREIGN KEY (painting_id) REFERENCES Paintings(painting_id),
    PRIMARY KEY (customer_no,painting_id)
)

--Inserting Dummy Values

INSERT INTO CATEGORY VALUES (
    'B',0,'Bronze Category'
);
INSERT INTO CATEGORY VALUES (
    'S',5,'Silver Category'
);
INSERT INTO CATEGORY VALUES (
    'G',10,'Gold Category'
);
INSERT INTO CATEGORY VALUES (
    'P',15,'Platinum Category'
);



INSERT INTO Customer VALUES (
    '1','Ibrahim Sheikh','Gulshan','B'
);
INSERT INTO Customer VALUES (
    '2','Ahmed Tariq','Gulshan','S'
);
INSERT INTO Customer VALUES (
    '3','Vishal Das','Saddar','G'
);
INSERT INTO Customer VALUES (
    '4','Hussain Murtaza','Saddar','P'
);
INSERT INTO Customer VALUES (
    '5','Sabrina Sheikh','Defense','B'
);
INSERT INTO Customer VALUES (
    '6','Ismail Sheikh','Defense','B'
);
INSERT INTO Customer VALUES (
    '7','Alina Sheikh','Defense','B'
);



INSERT INTO ARTIST VALUES (
    '1','Artist One','Pakistan',1970,NULL
);
INSERT INTO ARTIST VALUES (
    '2','Artist Two','Pakistan',1999,NULL
);
INSERT INTO ARTIST VALUES (
    '3','Artist Three','Pakistan',2000,NULL
);
INSERT INTO ARTIST VALUES (
    '4','Artist Four','Canada',1997,NULL
);
INSERT INTO ARTIST VALUES (
    '5','Artist Five','UK',2001,NULL
);
INSERT INTO ARTIST VALUES (
    '6','Artist Six','USA',2003,NULL
);


INSERT INTO Owner VALUES (
    '1','Owner one','defense',90076801
);
INSERT INTO Owner VALUES (
    '2','Owner two','defense',90076801
);
INSERT INTO Owner VALUES (
    '3','Owner three','defense',90076801
);
INSERT INTO Owner VALUES (
    '4','Owner four','defense',90076801
);
INSERT INTO Owner VALUES (
    '5','Owner five','defense',90076801
);
INSERT INTO Owner VALUES (
    '75fa2b09-9c21-4d31-83ac-987789cf781d','Owner six','Toronto',1010110
);



INSERT INTO Paintings VALUES (
    '1','Mona Lisa','face',200000,'1','1'
);
INSERT INTO Paintings VALUES (
    '2','Squid Game','game',15000,'2','1'
);
INSERT INTO Paintings VALUES (
    '3','Handsome Squidward','face',1000000,'3','3'
);
INSERT INTO Paintings VALUES (
    '4','Bear in forest','Animal',120000,'4','75fa2b09-9c21-4d31-83ac-987789cf781d'
);
INSERT INTO Paintings VALUES (
    '5','Askari Park','Landscape',4205000,'4','1'
);
INSERT INTO Paintings VALUES (
    '6','Mellow','Seascape',91000000,'2','3'
);
INSERT INTO Paintings VALUES (
    '7','Navy','Naval',1234000,'5','75fa2b09-9c21-4d31-83ac-987789cf781d'
);
INSERT INTO Paintings VALUES (
    '71f56d1e-1ebd-4d35-bbc4-7198c8829943','Mr Beast','Free Stuff',20202200,'2','2'
);
INSERT INTO Paintings VALUES (
    '8','Antique','Still-life',9871000,'6','4'
);




INSERT INTO rental_report VALUES (
    '1','1',TO_DATE('2021/12/26', 'yyyy/mm/dd'),TO_DATE('2022/01/09', 'yyyy/mm/dd'),'N'
);
INSERT INTO rental_report VALUES (
    '1','2',TO_DATE('2022/12/26', 'yyyy/mm/dd'),TO_DATE('2024/07/19', 'yyyy/mm/dd'),'N'
);
INSERT INTO rental_report VALUES (
    '1','3',TO_DATE('2022/12/25', 'yyyy/mm/dd'),TO_DATE('2024/02/12', 'yyyy/mm/dd'),'Y'
);
INSERT INTO rental_report VALUES (
    '2','6',TO_DATE('2022/02/10', 'yyyy/mm/dd'),TO_DATE('2022/12/20', 'yyyy/mm/dd'),'Y'
);
INSERT INTO rental_report VALUES (
    '3','4',TO_DATE('2021/02/21', 'yyyy/mm/dd'),TO_DATE('2022/01/22', 'yyyy/mm/dd'),'Y'
);
INSERT INTO rental_report VALUES (
    '4','5',TO_DATE('2019/01/21', 'yyyy/mm/dd'),TO_DATE('2021/12/21', 'yyyy/mm/dd'),'Y'
);