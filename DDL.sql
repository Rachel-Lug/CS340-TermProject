-- phpMyAdmin SQL Dump
-- version 5.2.3-1.el9.remi
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 04, 2026 at 11:37 AM
-- Server version: 10.11.15-MariaDB-log
-- PHP Version: 8.4.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_luginbir`
--

-- --------------------------------------------------------

--
-- Table structure for table `AcademicTerms`
--

CREATE TABLE `AcademicTerms` (
  `academicTermID` int(11) NOT NULL,
  `termName` varchar(50) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `year` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `AcademicTerms`
--

INSERT INTO `AcademicTerms` (`academicTermID`, `termName`, `startDate`, `endDate`, `year`) VALUES
(1, 'Fall', '2025-09-24', '2025-12-05', 2025),
(2, 'Winter', '2026-01-05', '2026-03-13', 2026),
(3, 'Spring', '2026-03-30', '2026-06-05', 2026),
(4, 'Summer', '2026-06-22', '2026-08-14', 2026);

-- --------------------------------------------------------

--
-- Table structure for table `Courses`
--

CREATE TABLE `Courses` (
  `courseID` int(11) NOT NULL,
  `courseCode` varchar(50) NOT NULL,
  `courseTitle` varchar(65) NOT NULL,
  `courseCredit` tinyint(6) NOT NULL,
  `departmentID` int(11) NOT NULL
) ;

--
-- Dumping data for table `Courses`
--

INSERT INTO `Courses` (`courseID`, `courseCode`, `courseTitle`, `courseCredit`, `departmentID`) VALUES
(1, 'CS340', 'Intro to Databases', 4, 2),
(2, 'NUR423', 'Nursing Leadership', 4, 3),
(3, 'ED300', 'Transitions', 2, 6),
(4, 'ACTG317', 'External Reporting 1', 4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `CourseTerms`
--

CREATE TABLE `CourseTerms` (
  `courseTermID` int(11) NOT NULL,
  `academicTermID` int(11) NOT NULL,
  `instructorID` int(11) NOT NULL,
  `courseID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `CourseTerms`
--

INSERT INTO `CourseTerms` (`courseTermID`, `academicTermID`, `instructorID`, `courseID`) VALUES
(1, 1, 6, 1),
(2, 2, 5, 2),
(3, 3, 4, 3),
(4, 4, 7, 4);

-- --------------------------------------------------------

--
-- Table structure for table `Departments`
--

CREATE TABLE `Departments` (
  `departmentID` int(11) NOT NULL,
  `departmentName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Departments`
--

INSERT INTO `Departments` (`departmentID`, `departmentName`) VALUES
(4, 'Accounting'),
(1, 'Biology'),
(2, 'Computer Science'),
(5, 'Electrical Engineering'),
(3, 'Nursing'),
(6, 'Teaching');

-- --------------------------------------------------------

--
-- Table structure for table `Instructors`
--

CREATE TABLE `Instructors` (
  `instructorID` int(11) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `departmentID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Instructors`
--

INSERT INTO `Instructors` (`instructorID`, `firstName`, `lastName`, `email`, `departmentID`) VALUES
(4, 'Melissa', 'Mossgrove', 'MossgroveM@oregonstate.edu', 1),
(5, 'Gina', 'Delacruz', 'DelacruzG@oregonstate.edu', 3),
(6, 'Michael', 'Curry', 'CurryM@oregonstate.edu', 2),
(7, 'Jacob', 'York', 'YorkJ@gmail.com', 4);

-- --------------------------------------------------------

--
-- Table structure for table `StudentHasCourses`
--

CREATE TABLE `StudentHasCourses` (
  `studentID` int(11) NOT NULL,
  `courseTermID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `StudentHasCourses`
--

INSERT INTO `StudentHasCourses` (`studentID`, `courseTermID`) VALUES
(1, 2),
(1, 4),
(3, 3),
(4, 1);

-- --------------------------------------------------------

--
-- Table structure for table `Students`
--

CREATE TABLE `Students` (
  `studentID` int(11) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `major` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Students`
--

INSERT INTO `Students` (`studentID`, `firstName`, `lastName`, `email`, `major`) VALUES
(1, 'Sarah', 'Doe', 'Does@oregonstate.edu', 'Accounting'),
(2, 'John', 'Miller', 'MillerJ@oregonstate.edu', 'Computer Science'),
(3, 'Jamie', 'James', 'JamesJ@gmail.com', 'Biology'),
(4, 'Heidi', 'Lee', 'LeeH@yahoo.com', 'Nursing');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `AcademicTerms`
--
ALTER TABLE `AcademicTerms`
  ADD PRIMARY KEY (`academicTermID`),
  ADD UNIQUE KEY `academicTermID` (`academicTermID`);

--
-- Indexes for table `Courses`
--
ALTER TABLE `Courses`
  ADD PRIMARY KEY (`courseID`),
  ADD KEY `fk_courses_departments` (`departmentID`);

--
-- Indexes for table `CourseTerms`
--
ALTER TABLE `CourseTerms`
  ADD PRIMARY KEY (`courseTermID`),
  ADD UNIQUE KEY `courseTermID` (`courseTermID`),
  ADD UNIQUE KEY `courseID` (`courseID`,`academicTermID`,`instructorID`),
  ADD KEY `fk_courseterms_academicterms` (`academicTermID`),
  ADD KEY `fk_courseterms_instructors` (`instructorID`);

--
-- Indexes for table `Departments`
--
ALTER TABLE `Departments`
  ADD PRIMARY KEY (`departmentID`),
  ADD UNIQUE KEY `departmentName` (`departmentName`);

--
-- Indexes for table `Instructors`
--
ALTER TABLE `Instructors`
  ADD PRIMARY KEY (`instructorID`),
  ADD UNIQUE KEY `instructorID` (`instructorID`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_instructors_departments` (`departmentID`);

--
-- Indexes for table `StudentHasCourses`
--
ALTER TABLE `StudentHasCourses`
  ADD PRIMARY KEY (`studentID`,`courseTermID`),
  ADD KEY `fk_shc_courseterms` (`courseTermID`);

--
-- Indexes for table `Students`
--
ALTER TABLE `Students`
  ADD PRIMARY KEY (`studentID`),
  ADD UNIQUE KEY `studentID` (`studentID`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `AcademicTerms`
--
ALTER TABLE `AcademicTerms`
  MODIFY `academicTermID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Courses`
--
ALTER TABLE `Courses`
  MODIFY `courseID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `CourseTerms`
--
ALTER TABLE `CourseTerms`
  MODIFY `courseTermID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Departments`
--
ALTER TABLE `Departments`
  MODIFY `departmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Instructors`
--
ALTER TABLE `Instructors`
  MODIFY `instructorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Students`
--
ALTER TABLE `Students`
  MODIFY `studentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Courses`
--
ALTER TABLE `Courses`
  ADD CONSTRAINT `fk_courses_departments` FOREIGN KEY (`departmentID`) REFERENCES `Departments` (`departmentID`) ON UPDATE CASCADE;

--
-- Constraints for table `CourseTerms`
--
ALTER TABLE `CourseTerms`
  ADD CONSTRAINT `fk_courseterms_academicterms` FOREIGN KEY (`academicTermID`) REFERENCES `AcademicTerms` (`academicTermID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_courseterms_courses` FOREIGN KEY (`courseID`) REFERENCES `Courses` (`courseID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_courseterms_instructors` FOREIGN KEY (`instructorID`) REFERENCES `Instructors` (`instructorID`) ON UPDATE CASCADE;

--
-- Constraints for table `Instructors`
--
ALTER TABLE `Instructors`
  ADD CONSTRAINT `fk_instructors_departments` FOREIGN KEY (`departmentID`) REFERENCES `Departments` (`departmentID`) ON UPDATE CASCADE;

--
-- Constraints for table `StudentHasCourses`
--
ALTER TABLE `StudentHasCourses`
  ADD CONSTRAINT `fk_shc_courseterms` FOREIGN KEY (`courseTermID`) REFERENCES `CourseTerms` (`courseTermID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_shc_students` FOREIGN KEY (`studentID`) REFERENCES `Students` (`studentID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
