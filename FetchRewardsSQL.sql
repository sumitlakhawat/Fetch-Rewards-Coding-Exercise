

# What are the top 5 brands by receipts scanned for most recent month?


SELECT i.brandCode AS brandCode, COUNT(r._id) AS receiptCount
FROM Items AS i
JOIN (SELECT _id 
      FROM Receipts 
      WHERE dateScanned >= DATE_TRUNC('month', CURRENT_DATE) -- Filter for the most recent month
) AS r ON i.receiptId = r._id
GROUP BY b._id, b.name
ORDER BY receipt_count DESC
LIMIT 5;



# When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT rewardsReceiptStatus, AVG(totalSpent) AS averageSpend
FROM Receipts
WHERE rewardsReceiptStatus =  (SELECT CASE
                              WHEN 
                              (SELECT avg(totalSpent) FROM Receipts WHERE rewardsReceiptStatus='REJECTED')
                              > 
                              (SELECT avg(totalSpent) FROM Receipts WHERE rewardsReceiptStatus='FINISHED')
                              THEN 'REJECTED'
                              ELSE 'FINISHED'
                              END AS statusHighestAvgSpent
                              )
GROUP BY rewardsReceiptStatus;



# Which brand has the most spend among users who were created within the past 6 months?


SELECT i.brandCode AS brandCode, SUM(r.totalSpent) AS total_spend
FROM Items AS i
JOIN Receipts AS r ON i.receiptId = r._id
JOIN (
   SELECT _id
   FROM Users
   WHERE createdDate >= (CURRENT_DATE - INTERVAL '6' MONTH) -- Filter for users created within the past 6 months
) AS u ON r.userId = u._id
GROUP BY b._id, b.name
ORDER BY total_spend DESC
LIMIT 1;



# Which brand has the most transactions among users who were created within the past 6 months?


SELECT i.brandCode AS brandCode, COUNT(r._id) AS transaction_count
FROM Items AS i
JOIN Receipts AS r ON i.receiptId = r._id
JOIN (
   SELECT _id
   FROM Users
   WHERE createdDate >= (CURRENT_DATE - INTERVAL '6' MONTH) -- Filter for users created within the past 6 months
) AS u ON r.userId = u._id
GROUP BY b._id, b.name
ORDER BY total_spend DESC
LIMIT 1;