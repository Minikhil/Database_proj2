--PART 1:
--
-- Database: `CSE460_Proj2`
--

-- --------------------------------------------------------

--
-- Table structure for table `Department`
--

CREATE TABLE `Department` (
  `dId` varchar(5) NOT NULL,
  `dName` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Department`
--

INSERT INTO `Department` (`dId`, `dName`) VALUES
('3', 'ASL'),
('1', 'CSE'),
('4', 'EAS'),
('2', 'EE'),
('5', 'SOC');

-- --------------------------------------------------------

--
-- Table structure for table `Employee`
--

CREATE TABLE `Employee` (
  `eId` varchar(10) NOT NULL,
  `eName` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Employee`
--

INSERT INTO `Employee` (`eId`, `eName`) VALUES
('1', 'Nikhil'),
('2', 'Sai'),
('3', 'Toby'),
('4', 'Tenzin'),
('5', 'Sharon'),
('6', 'Alex'),
('7', 'Steven'),
('8', 'Denny');

-- --------------------------------------------------------

--
-- Stand-in structure for view `employee_numdept`
-- (See below for the actual view)
--
CREATE TABLE `employee_numdept` (
`eName` varchar(20)
,`numDept` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `Payroll`
--

CREATE TABLE `Payroll` (
  `checkNumber` varchar(30) NOT NULL,
  `emp` varchar(10) NOT NULL,
  `year` char(4) NOT NULL,
  `amount` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Payroll`
--

INSERT INTO `Payroll` (`checkNumber`, `emp`, `year`, `amount`) VALUES
('1', '1', '2006', '92000'),
('10', '4', '2009', '90000'),
('11', '5', '2010', '90000'),
('12', '6', '2011', '90000'),
('13', '7', '2012', '90000'),
('2', '1', '2006', '100000'),
('3', '1', '2002', '150000'),
('4', '2', '2003', '90000'),
('5', '2', '2004', '90000'),
('6', '2', '2006', '90000'),
('7', '2', '2006', '90000'),
('8', '3', '2007', '90000'),
('9', '3', '2008', '90000');

-- --------------------------------------------------------

--
-- Table structure for table `worksIn`
--

CREATE TABLE `worksIn` (
  `emp` varchar(10) NOT NULL DEFAULT '',
  `dept` varchar(5) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `worksIn`
--

INSERT INTO `worksIn` (`emp`, `dept`) VALUES
('1', '1'),
('1', '2'),
('1', '3'),
('2', '1'),
('2', '2'),
('3', '1'),
('3', '3'),
('4', '4'),
('5', '5'),
('6', '1'),
('7', '2'),
('8', 'NULL');

-- --------------------------------------------------------

--
-- Structure for view `employee_numdept`
--
DROP TABLE IF EXISTS `employee_numdept`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cse460_proj2`.`employee_numdept`  AS  select `emp`.`eName` AS `eName`,count(`workin`.`dept`) AS `numDept` from (`cse460_proj2`.`employee` `emp` join `cse460_proj2`.`worksin` `workin` on((`emp`.`eId` = `workin`.`emp`))) group by `emp`.`eName` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Department`
--
ALTER TABLE `Department`
  ADD PRIMARY KEY (`dId`),
  ADD UNIQUE KEY `dName` (`dName`);

--
-- Indexes for table `Employee`
--
ALTER TABLE `Employee`
  ADD PRIMARY KEY (`eId`),
  ADD UNIQUE KEY `eId` (`eId`);

--
-- Indexes for table `Payroll`
--
ALTER TABLE `Payroll`
  ADD PRIMARY KEY (`checkNumber`),
  ADD KEY `emp` (`emp`);

--
-- Indexes for table `worksIn`
--
ALTER TABLE `worksIn`
  ADD PRIMARY KEY (`emp`,`dept`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Payroll`
--
ALTER TABLE `Payroll`
  ADD CONSTRAINT `payroll_ibfk_1` FOREIGN KEY (`emp`) REFERENCES `Employee` (`eId`);

--PART 2:
  -- Database: `CSE460_Proj2Q2`
  --

  -- --------------------------------------------------------

  --
  -- Stand-in structure for view `alt_routes`
  -- (See below for the actual view)
  --
  CREATE TABLE `alt_routes` (
  `origin` varchar(10)
  ,`destination` varchar(20)
  ,`price` varchar(10)
  );

  -- --------------------------------------------------------

  --
  -- Stand-in structure for view `direct_routes`
  -- (See below for the actual view)
  --
  CREATE TABLE `direct_routes` (
  `origin` varchar(10)
  ,`destination` varchar(20)
  ,`price` varchar(10)
  );

  -- --------------------------------------------------------

  --
  -- Table structure for table `Train`
  --

  CREATE TABLE `Train` (
    `origin` varchar(10) NOT NULL,
    `destination` varchar(20) NOT NULL,
    `price` varchar(10) NOT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

  --
  -- Dumping data for table `Train`
  --

  INSERT INTO `Train` (`origin`, `destination`, `price`) VALUES
  ('BUF', 'BOS', '100'),
  ('BUF', 'LAX', '200'),
  ('BUF', 'NYC', '600'),
  ('BUF', 'ORD', '100'),
  ('LAX', 'NYC', '200'),
  ('NYC', 'BUF', '10'),
  ('NYC', 'ORD', '200'),
  ('ORD', 'BOS', '100'),
  ('ORD', 'LAX', '50');

  -- --------------------------------------------------------

  --
  -- Structure for view `alt_routes`
  --
  DROP TABLE IF EXISTS `alt_routes`;

  CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cse460_proj2q2`.`alt_routes`  AS  select `cse460_proj2q2`.`train`.`origin` AS `origin`,`cse460_proj2q2`.`train`.`destination` AS `destination`,`cse460_proj2q2`.`train`.`price` AS `price` from `cse460_proj2q2`.`train` where `cse460_proj2q2`.`train`.`origin` in (select `cse460_proj2q2`.`train`.`destination` from `cse460_proj2q2`.`train` where (`cse460_proj2q2`.`train`.`origin` = 'BUF')) ;

  -- --------------------------------------------------------

  --
  -- Structure for view `direct_routes`
  --
  DROP TABLE IF EXISTS `direct_routes`;

  CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cse460_proj2q2`.`direct_routes`  AS  select `cse460_proj2q2`.`train`.`origin` AS `origin`,`cse460_proj2q2`.`train`.`destination` AS `destination`,`cse460_proj2q2`.`train`.`price` AS `price` from `cse460_proj2q2`.`train` where (`cse460_proj2q2`.`train`.`origin` = 'BUF') ;

  --
  -- Indexes for dumped tables
  --

  --
  -- Indexes for table `Train`
  --
  ALTER TABLE `Train`
    ADD PRIMARY KEY (`origin`,`destination`);
