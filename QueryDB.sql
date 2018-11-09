-- ANS Q1.1
SELECT eName FROM Employee as emp INNER JOIN worksIn as workin ON emp.eId = workin.emp GROUP BY eName HAVING COUNT(dept) <=2;

-- ANS Q1.2
SELECT eName FROM Employee as emp INNER JOIN Payroll as pay ON emp.eId = pay.emp GROUP By eName HAVING COUNT(year) >= 3;

-- ANS Q1.3 (satisfies Null condition)
SELECT eName, SUM(amount) FROM Employee as emp LEFT OUTER JOIN Payroll as pay ON emp.eId = pay.emp AND pay.year = 2016 GROUP BY eName;

-- ANS Q1.4
SELECT Department.dId,t3.numEmp FROM (SELECT t1.dName, COUNT(emp) as numEmp FROM (SELECT dName, AVG(amount) as avgAmt FROM worksIn INNER JOIN Payroll ON worksIn.emp = Payroll.emp INNER JOIN Department ON did = dept GROUP BY dept) as t1 INNER JOIN (SELECT dName,(worksIn.emp), (amount) FROM Department INNER JOIN worksIn ON Department.did = worksIn.dept INNER JOIN Payroll ON worksIn.emp = Payroll.emp WHERE Payroll.year = 2016) as t2 ON t1.dName = t2.dName AND t1.avgAmt<= t2.amount GROUP BY dName); as t3 INNER JOIN Department ON t3.dName = Department.dName;

--ANS Q2.1

--I created two views one called
--direct_routes: which shows records of destinations direct from BUF
--alt_routes: which shows destinations with stops in between from BUF
--I created table t1 by Inner joining the two tabels above on condition direct_routes.destination = alt_routes.origin
--t1(destination,BuffTo_alt,alt_destination)
--this table showed the destination and the ticket price from buff to stop, and from stop to destination price
--t2(destination, price) in thsi table I added the two price columns from t1
--t3(destination, MIN(price)) : I unioned t2 and direct_routes and found the Min PRICE


-- Structure for view `alt_routes`
CREATE TABLE `alt_routes` (
`origin` varchar(10)
,`destination` varchar(20)
,`price` varchar(10)
);

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cse460_proj2q2`.`alt_routes`  AS  select `cse460_proj2q2`.`train`.`origin` AS `origin`,`cse460_proj2q2`.`train`.`destination` AS `destination`,`cse460_proj2q2`.`train`.`price` AS `price` from `cse460_proj2q2`.`train` where `cse460_proj2q2`.`train`.`origin` in (select `cse460_proj2q2`.`train`.`destination` from `cse460_proj2q2`.`train` where (`cse460_proj2q2`.`train`.`origin` = 'BUF')) ;
-- VIEW  `alt_routes`
-- Data: None
--
-- Structure for view `direct_routes`
CREATE TABLE `direct_routes` (
`origin` varchar(10)
,`destination` varchar(20)
,`price` varchar(10)
);

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cse460_proj2q2`.`direct_routes`  AS  select `cse460_proj2q2`.`train`.`origin` AS `origin`,`cse460_proj2q2`.`train`.`destination` AS `destination`,`cse460_proj2q2`.`train`.`price` AS `price` from `cse460_proj2q2`.`train` where (`cse460_proj2q2`.`train`.`origin` = 'BUF') ;
-- VIEW  `direct_routes`
-- Data: None

--FINAL QUERY ANS Q2.1
SELECT destination, MIN(price) as LeastCost FROM
(SELECT destination,price FROM
(SELECT t1.destination,t1.BuffTo_alt+ t1.alt_destination as price FROM (SELECT alt_routes.destination, direct_routes.price as BuffTo_alt, alt_routes.price AS alt_destination FROM direct_routes INNER JOIN alt_routes
ON direct_routes.destination = alt_routes.origin) as t1)
as t2
UNION SELECT destination,price FROM direct_routes) as t3
GROUP BY destination;

--ANS Q2.2
-- If I add cycles to my test DB for ex (BUF,NYC,600), (NYC, BUF, 10) AND run my query above then
-- in my t3 table which returns t3(destination, LeastCost) will also include 'BUF' has one of the destinations becuase my alt_routes table will include 'BUF' as a destination. Since my alt_routes tables returns routes for all origins which are NOT 'BUF'.
