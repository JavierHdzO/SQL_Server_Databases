/*
 * STORED PROCEDURES
 */

 USE BankApi;
 GO




 CREATE PROCEDURE user_client.usp_create_user_account
	@Email VARCHAR(50) NOT NULL,
	@Password VARCHAR(50) NOT NULL,
	@RoleId INT NOT NULL,
	@FirstName VARCHAR(50) NOT NULL,
	@LastName VARCHAR(50) NOT NULL,
	@Age SMALLINT NOT NULL,
	@Genre CHAR(1)
 AS
	 BEGIN 
		BEGIN TRANSACTION transac_create_user_client
			BEGIN TRY
				INSERT INTO users.Usr(Email, Password, RoleId)
					VALUES(@Email, @Password, @RoleId);

				INSERT INTO accounts.Client(FirstName, LastName, Age, Genre, UserId)
					VALUES(
						@FirstName, @LastName, @Age, @Genre, 
						(SELECT current_value FROM sys.sequences WHERE name = 'user_counter'));
			END TRY

			BEGIN CATCH

			END CATCH

	 END;
