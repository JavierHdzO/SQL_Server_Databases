/*
 * STORED PROCEDURES
 */

 USE BankApi;
 GO

 CREATE PROCEDURE user_client.usp_create_user_account
	@Email VARCHAR(50),
	@Password VARCHAR(50),
	@RoleId INT,
	@FirstName VARCHAR(50) ,
	@LastName VARCHAR(50),
	@Age SMALLINT,
	@Genre CHAR(1)
 AS
		BEGIN TRANSACTION transac_create_user_client
			BEGIN TRY
				SET NOCOUNT ON;
				INSERT INTO users.Usr(Email, Password, RoleId)
					VALUES(@Email, @Password, @RoleId);

				INSERT INTO accounts.Client(FirstName, LastName, Age, Genre, UserId)
					VALUES(
						@FirstName, @LastName, @Age, @Genre, 
						CONVERT(INT,(SELECT current_value FROM sys.sequences WHERE name = 'user_counter')));
			END TRY

			BEGIN CATCH

				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION transac_create_user_client

			END CATCH

			IF @@TRANCOUNT > 0
				COMMIT TRANSACTION transac_create_user_client;
GO

--Example execution
-- EXEC  user_client.usp_create_user_account 'fc0@hotma.com', 'FcoJavier990517', 0, 'Francisco', 'HdzO', 23, 'M';

