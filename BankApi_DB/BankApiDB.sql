
USE master;
GO

DROP DATABASE IF EXISTS BankApi;

CREATE DATABASE BankApi;
GO

USE BankApi;
GO

CREATE SCHEMA client;
GO

CREATE SCHEMA transactions;
GO

CREATE SCHEMA accounts;
GO

CREATE SCHEMA users;
GO

CREATE SCHEMA user_client;
GO

CREATE SEQUENCE client.role_counter
	AS INT
	START WITH 0
	INCREMENT BY 1;

CREATE SEQUENCE users.user_counter
	AS INT
	START WITH 0
	INCREMENT BY 1;

DROP TABLE IF EXISTS users.Roles;
DROP TABLE IF EXISTS client.AccountType;
DROP TABLE IF EXISTS transactions.TransactionType;
DROP TABLE IF EXISTS users.Usr;
DROP SCHEMA client;
DROP SCHEMA transactions;
DROP SCHEMA accounts;


/*
 *	Independet Tables
 */

CREATE TABLE users.Roles(
	RoleId INT PRIMARY KEY
			DEFAULT(NEXT VALUE FOR client.role_counter),
	Type VARCHAR(20),
	CreatedAt DATETIME 
			DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE users.Roles
 ALTER COLUMN Type VARCHAR(20) NOT NULL;


CREATE TABLE accounts.AccountType(
	AccountTypeId INT PRIMARY KEY IDENTITY,
	Name Varchar(50) NOT NULL,
	RegDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts.ExternalBank(
	ExternalBankId INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	RegDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

/*
ALTER TABLE accounts.ExternalBank
 ADD  ExternalBankId INT PRIMARY KEY IDENTITY;
*/

CREATE TABLE transactions.TransactionType(
	TransactionTypeId INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	RegDate DATETIME DEFAULT CURRENT_TIMESTAMP
	
);

/*
 * Dependent Tables
 */

 CREATE TABLE users.Usr(
	UserId INT PRIMARY KEY DEFAULT(NEXT VALUE FOR users.user_counter),
	Email VARCHAR(50) NOT NULL CHECK( LEN(Email) > 7 ),
	Password VARCHAR(50) NOT NULL CHECK( LEN(Password) > 8),
	Active BIT DEFAULT 1,
	RegDate DATETIME DEFAULT CURRENT_TIMESTAMP,
	RoleId INT,
	CONSTRAINT fk_role FOREIGN KEY(RoleId)
	REFERENCES users.Roles(RoleId)
 );


 CREATE TABLE accounts.Client(
	ClientId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(55) NOT NULL,
	LastName VARCHAR(55) NOT NULL,
	Age SMALLINT CHECK( Age > 18 ),
	Genre CHAR(1) CHECK ( Genre = 'F' OR Genre = 'M' ),
	Active BIT DEFAULT 1,
	RegDate DATETIME DEFAULT CURRENT_TIMESTAMP,
	UserId INT,
	CONSTRAINT fk_user FOREIGN KEY(UserId)
	REFERENCES users.Usr(UserId)
	ON UPDATE CASCADE
	ON DELETE CASCADE
 );


 CREATE TABLE accounts.Account(
	AccountId INT PRIMARY KEY IDENTITY,
	Balance MONEY CHECK( Balance > 0 ) ,
	RegDate DATETIME DEFAULT CURRENT_TIMESTAMP,
	ClientId INT,
	AccountTypeId INT,
	CONSTRAINT fk_client FOREIGN KEY(ClientId)
	REFERENCES accounts.Client(ClientId),
	CONSTRAINT fk_account_type FOREIGN KEY(AccountTypeId)
	REFERENCES accounts.AccountType(AccountTypeId)
 );

 ALTER TABLE accounts.Account
  ADD CardNumber VARCHAR(16) NOT NULL UNIQUE CHECK( LEN(CardNumber) = 16 ); 

 CREATE TABLE accounts.ExternalAccount(
	ExternalAccountId INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50),
	CardNumber VARCHAR(16) NOT NULL UNIQUE,
	ExternalBankId INT,
	CONSTRAINT fk_external_bank FOREIGN KEY(ExternalBankId)
	REFERENCES accounts.ExternalBank(ExternalBankId)
	ON UPDATE CASCADE
 );


 CREATE TABLE accounts.Transactions(
	TransactionId INT PRIMARY KEY IDENTITY,
	Amount MONEY NOT NULL CHECK( Amount > 0 ),
	AccountId INT,
	ExternalAccountId INT,
	TransactionTypeId INT,
	CONSTRAINT fk_external_account FOREIGN KEY(ExternalAccountId)
		REFERENCES accounts.ExternalAccount(ExternalAccountId),
	CONSTRAINT fk_account FOREIGN KEY(AccountId)
		REFERENCES accounts.Account(AccountId),
	CONSTRAINT fk_transaction_type FOREIGN KEY(TransactionTypeId)
		REFERENCES transactions.TransactionType(TransactionTypeId)
 );