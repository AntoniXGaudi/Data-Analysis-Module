




CREATE DATABASE LibDatabase;

Use LibDatabase;


--Create Two Schemas
CREATE SCHEMA Book;
---
CREATE SCHEMA Person;



--create Book.Author table

CREATE TABLE [Book].[Author]
(
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);




CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar](100) NULL DEFAULT ('Can')
	);


Alter table [Book].[Publisher]
ADD CONSTRAINT DEF_1 DEFAULT ('Can') FOR publisher_name



--create Book.Book table

CREATE TABLE [Book].[Book](
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar](50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL
	);


--create Person.Person table

CREATE TABLE [Person].[Person](
	[SSN] [bigint] PRIMARY KEY NOT NULL,
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);



--create Person.Loan table

CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])
	);


	--cretae Person.Person_Phone table

CREATE TABLE [Person].[Person_Phone](
	[Phone_Number] [bigint] PRIMARY KEY NOT NULL,
	[SSN] [bigint] NOT NULL	
	);


--cretae Person.Person_Mail table

CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY (1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL	
	);


---------///////////////////////////-------------



---Insert

SELECT *
FROM Person.Person

INSERT Person.Person (SSN, Person_FirstName, Person_LastName)
VALUES (88888888888, 'Zehra', 'Tekin')


INSERT Person.Person (Person_FirstName, SSN, Person_LastName)
VALUES ('Zeynep', 99999999999, 'Tekin')


INSERT Person.Person (SSN, Person_FirstName)
VALUES (77777777777, 'Metin')

INSERT Person.Person (SSN, Person_FirstName, Person_LastName)
VALUES (66666666666, 'Mehmet', null)


INSERT Person.Person
VALUES (55555555555, 'Ali', null)

INSERT Person.Person
VALUES (33333333333, 'Veli', 'Can')


INSERT Person.Person VALUES (22222222222, 'Kerem', 'Can')
INSERT Person.Person VALUES (44444444444, 'Hasan', 'Can')



INSERT INTO person.Person_Mail (Mail, SSN)
VALUES ('keremc@gmail.com', 111111111111)


INSERT INTO person.Person_Mail
VALUES ('velican@gmail.com', 33333333333),
		('hasancan@gmail.com', 44444444444)


----------------

---SELECT [column] INTO

SELECT *
INTO	person.person2
FROM	person.Person
WHERE	Person_LastName IS NOT NULL



INSERT	Person.person2  
SELECT	*
FROM	Person.Person
WHERE	Person_LastName IS NULL 


---insert with default values

INSERT Book.Publisher
DEFAULT VALUES


SELECT *
FROM Book.Publisher

---------

----UPDATE

UPDATE Person.person2
SET Person_LastName = 'Öz'



UPDATE Person.person2
SET Person_LastName = 'Yurt'
WHERE SSN = 55555555555


---Delete


DELETE FROM Person.person2 WHERE SSN = 55555555555


INSERT INTO Book.Publisher
VALUES ('Ýþ Bankasý Kültür Yayýncýlýk'), 
		('Can Yayýncýlýk'), 
		('Ýletiþim Yayýncýlýk')


DELETE FROM Book.Publisher


INSERT INTO Book.Publisher
VALUES ('Hashette')


--TRUNCATE

TRUNCATE TABLE Book.Publisher

INSERT INTO Book.Publisher
VALUES ('Hashette')



---DROP TABLE

DROP TABLE Person.person3

DROP TABLE IF EXISTS Person.person3


DROP TABLE Person.person2


----

TRUNCATE TABLE person.person_mail

TRUNCATE TABLE person.person

TRUNCATE TABLE book.publisher


----------------------

ALTER TABLE book.book 
ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)


ALTER TABLE Book.Author 
ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)


ALTER TABLE Book.Author 
ALTER COLUMN Author_ID INT NOT NULL



ALTER TABLE book.book 
ADD CONSTRAINT FK_publisher FOREIGN KEY (Publisher_ID) REFERENCES Book.Publisher (Publisher_ID)



----eiakyekm


/*
elmakiek
*/



ALTER TABLE person.loan
ADD CONSTRAINT FK_SSN1 FOREIGN KEY (SSN) REFERENCES person.person(SSN)


ALTER TABLE person.loan
ADD CONSTRAINT FK_Book1 FOREIGN KEY (SSN) REFERENCES person.person(SSN)

ALTER TABLE [Person].[Loan] DROP CONSTRAINT [FK_Book1]


ALTER TABLE person.loan
ADD CONSTRAINT FK_Book1 FOREIGN KEY (Book_ID) REFERENCES Book.Book(Book_ID)



ALTER TABLE person.person_mail
ADD CONSTRAINT FK_SSN2 FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)



ALTER TABLE person.person_phone
ADD CONSTRAINT FK_SSN3 FOREIGN KEY (SSN) REFERENCES Person.Person (SSN)


