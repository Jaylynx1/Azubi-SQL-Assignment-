-------------AZUBI GHANA DATASCIENCE SQL ASSIGNMENT by DAVID SELORM GEBE-----------------


--#1
--The COUNT method will be suitable to get the number of users
select COUNT(u_id) FROM users;

--#2
--Again the COUNT method will be suitable here to get the number of transfers
--Using the WHERE clause to find data entries with 'CFA' in the send_amount_currency field would also be needed here
select COUNT(transfer_id) FROM transfers WHERE send_amount_currency = 'CFA';

--#3
--Again the COUNT method should be able to get us the number of users
--Using SELECT DISTINCT should give only one instance of users who meet the condition
--WHERE condition is used to get the transfers which had their currency being CFA
select DISTINCT COUNT (u_id) FROM transfers WHERE send_amount_currency = 'CFA' ;

--#4(Had to collaborate with my peers with this question)
	--To display the months gotten from the query, to_char method is used to convert the dates to TEXT/STRING
Select to_char(to_date(Extract(MONTH FROM when_created)::text, 'MM'),'Month') AS transaction_month,
	--To get the COUNT of agent transactions in the year 2018
COUNT (atx_id) AS num_of_agent_transactions FROM agent_transactions WHERE EXTRACT(Year From when_created)=2018
	--To group the results by the months in 2018
Group by extract(month from when_created);
--#5
SELECT
	-- case to categorize NET DEPOSITORS and NET WITHDRAWERS:
    CASE WHEN net_value > 0 THEN 'NET WITHDRAWERS'
    ELSE 'NET DEPOSITORS'
    END,
	
	--to get the COUNT of agents who are either  NET DEPOSITORS or NET WITHDRAWERS:
    COUNT(agent_id) AS net_count FROM (SELECT agent_id, sum(amount) AS net_value FROM agent_transactions
    WHERE ((amount < 0) OR (amount > 0)) 
									   
	--1 week condition:
AND (agent_transactions.when_created BETWEEN 
NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER)
    GROUP BY agent_id
 	-- to group by the CASE created earlier:
    GROUP BY (net_value > 0);
									   
									   
--#6
	--To build the table, SELECT INTO is used:								   
SELECT City, Volume
INTO atx_volume_city_summary 
FROM ( Select agents.city AS City, count(agent_transactions.atx_id) AS Volume FROM agents 
	 --INNER JOIN is used her to get the matching records from agents and agent_transactions tables:
INNER JOIN agent_transactions 
ON agents.agent_id = agent_transactions.agent_id
	  -- to get the records from LAST WEEK:
WHERE (agent_transactions.when_created BETWEEN 
NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER)
	  --The data is grouped according to the respective Cities using  GROUP BY:
GROUP BY agents.city) as atx_volume_summary; 
									   
--#7
	--To build the table, SELECT INTO is used:	
SELECT City, Volume, Country
INTO atx_volume_city_summary_with_Country
FROM ( Select agents.city AS City, agents.country AS Country, count(agent_transactions.atx_id) AS Volume FROM agents 
	--INNER JOIN is used her to get the matching records from agents and agent_transactions tables:	
INNER JOIN agent_transactions 
ON agents.agent_id = agent_transactions.agent_id
	-- to get the records from LAST WEEK: 
WHERE (agent_transactions.when_created BETWEEN 
NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER)
	--The data is grouped according to the respective Countries first, then the Cities using  GROUP BY:
GROUP BY agents.country,agents.city) as atx_volume_summary_with_Country;	
									   
--#8
	--To build the table, SELECT INTO is used:									   
SELECT
INTO send_Volume_by_Country_and_Kind
FROM transfers.kind AS Kind, wallets.ledger_location AS Country, sum(transfers.send_amount_scalar) AS Volume FROM transfers 
	--INNER JOIN is used her to get the matching records from transfers and wallets tables:
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id
	-- to get the records from LAST WEEK: 
WHERE (transfers.when_created BETWEEN 
NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER)
	--The data is grouped according to the respective Countries first(ledger_location), then the transfer kind using  GROUP BY:								   
GROUP BY wallets.ledger_location, transfers.kind) as send_Volume_by_Country_and_Kind; 
									   
--#9
 --COUNT method is used here to get the number of transfers with DISTINCT method to get UNIQUE Senders
 SELECT COUNT(DISTINCT transfers.source_wallet_id) AS Unique_Senders,COUNT(transfer_id) AS Transaction_count, transfers.kind AS Transfer_Kind, wallets.ledger_location AS Country, 
 --SUM method is used here to get the total volume of the transfer amount
sum(transfers.send_amount_scalar) AS Volume 
FROM transfers 
 --INNER JOIN is used her to get the matching records from transfers and wallets tables:
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id
  -- to get the records from LAST WEEK: 
WHERE transfers.when_created BETWEEN 
NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 
AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER                                   
  --The data is grouped according to the respective Countries first(ledger_location), then the transfer kind using  GROUP BY:
GROUP BY wallets.ledger_location, transfers.kind; 		
									   
--#10
  --To get the relevant data needed (Senders, Amount Sent) from the transfers table
SELECT source_wallet_id, send_amount_scalar FROM transfers 
 -- to get the records which had send_amount_currency being 'CFA': 
WHERE send_amount_currency = 'CFA' 
 -- to get the records which had send_amount_scalar being greater than 10,000,000: 
AND (send_amount_scalar>10000000) 
 -- to get the records from LAST MONTH: 
AND (EXTRACT(MONTH FROM when_created) - EXTRACT(Month FROM NOW())-1);								   

								   
									   
 
