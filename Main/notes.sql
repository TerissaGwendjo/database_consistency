CREATE TABLE accounts (
                          account_id SERIAL PRIMARY KEY,
                          account_number VARCHAR(20) UNIQUE NOT NULL,
                          balance DECIMAL(15, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO accounts (account_number, balance) VALUES
                                                   ('987654321', 500.00),
                                                   ('543216789', 1500.50),
                                                   ('678954321', 750.25);


--So this is atomicity. If one fails, everything fails
--Also consistency brecause it is not possible that i am deducting and not adding it somewhere. So there should be a balance
--This basically using all the ACID concepts in one query
--and commiting ensures durability in that the changes are successfully stored even if the system crashes.
--Also if the system crashes after begin and before commit, the database will automatically roll back the
--transaction ensuring atomicity.

BEGIN; -- start Transaction
-- STep 1: check balance of the source account
SELECT balance INTO source_balance FROM accounts WHERE account_number = '543216789' FOR UPDATE;
-- Assuming sufficient balance exist, proceed to step 2 and 3
-- Step 2: Deducting the amount from the source account
UPDATE accounts SET balance = balance - 10 WHERE account_number = '543216789';

SELECT balance INTO source_balance FROM accounts WHERE account_number = '987654321' FOR UPDATE;
--Step 3: Adding the amount to the destination account
UPDATE accounts SET balance = balance + 10 WHERE account_number = '987654321' ;
COMMIT ; --Commit transaction
