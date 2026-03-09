-- phpMyAdmin SQL Dump
-- version 5.2.3-1.el9.remi
-- https://www.phpmyadmin.net/
-- Host: localhost
-- Generation Time: Feb 04, 2026 at 11:37 AM
-- Server version: 10.11.15-MariaDB-log
-- PHP Version: 8.4.17
--
-- =====================
-- CREATE TABLES
-- =====================

CREATE TABLE Departments (
  departmentID INT NOT NULL AUTO_INCREMENT,
  departmentName VARCHAR(50) NOT NULL,
  PRIMARY KEY (departmentID),
  UNIQUE (departmentName)
) ENGINE=InnoDB;

CREATE TABLE AcademicTerms (
  academicTermID INT NOT NULL AUTO_INCREMENT,
  termName VARCHAR(50) NOT NULL,
  startDate DATE NOT NULL,
  endDate DATE NOT NULL,
  year INT(4) NOT NULL,
  PRIMARY KEY (academicTermID)
) ENGINE=InnoDB;

CREATE TABLE Students (
  studentID INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  major VARCHAR(50) NOT NULL,
  PRIMARY KEY (studentID),
  UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE Instructors (
  instructorID INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(50) NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  departmentID INT NOT NULL,
  PRIMARY KEY (instructorID),
  UNIQUE (email),
  FOREIGN KEY (departmentID)
    REFERENCES Departments(departmentID)
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Courses (
  courseID INT NOT NULL AUTO_INCREMENT,
  courseCode VARCHAR(50) NOT NULL,
  courseTitle VARCHAR(65) NOT NULL,
  courseCredit TINYINT NOT NULL,
  departmentID INT NOT NULL,
  PRIMARY KEY (courseID),
  FOREIGN KEY (departmentID)
    REFERENCES Departments(departmentID)
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE CourseTerms (
  courseTermID INT NOT NULL AUTO_INCREMENT,
  academicTermID INT NOT NULL,
  instructorID INT NOT NULL,
  courseID INT NOT NULL,
  PRIMARY KEY (courseTermID),
  UNIQUE (courseID, academicTermID, instructorID),
  FOREIGN KEY (academicTermID)
    REFERENCES AcademicTerms(academicTermID)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (courseID)
    REFERENCES Courses(courseID)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (instructorID)
    REFERENCES Instructors(instructorID)
    ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE StudentHasCourses (
  studentID INT NOT NULL,
  courseTermID INT NOT NULL,
  PRIMARY KEY (studentID, courseTermID),
  FOREIGN KEY (studentID)
    REFERENCES Students(studentID)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (courseTermID)
    REFERENCES CourseTerms(courseTermID)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================
-- INSERT DATA
-- =====================

INSERT INTO Departments VALUES
(4, 'Accounting'),
(1, 'Biology'),
(2, 'Computer Science'),
(5, 'Electrical Engineering'),
(3, 'Nursing'),
(6, 'Teaching');

INSERT INTO AcademicTerms VALUES
(1, 'Fall', '2025-09-24', '2025-12-05', 2025),
(2, 'Winter', '2026-01-05', '2026-03-13', 2026),
(3, 'Spring', '2026-03-30', '2026-06-05', 2026),
(4, 'Summer', '2026-06-22', '2026-08-14', 2026);

INSERT INTO Students VALUES
(1, 'Sarah', 'Doe', 'Does@oregonstate.edu', 'Accounting'),
(2, 'John', 'Miller', 'MillerJ@oregonstate.edu', 'Computer Science'),
(3, 'Jamie', 'James', 'JamesJ@gmail.com', 'Biology'),
(4, 'Heidi', 'Lee', 'LeeH@yahoo.com', 'Nursing');

INSERT INTO Instructors VALUES
(4, 'Melissa', 'Mossgrove', 'MossgroveM@oregonstate.edu', 1),
(5, 'Gina', 'Delacruz', 'DelacruzG@oregonstate.edu', 3),
(6, 'Michael', 'Curry', 'CurryM@oregonstate.edu', 2),
(7, 'Jacob', 'York', 'YorkJ@gmail.com', 4);

INSERT INTO Courses VALUES
(1, 'CS340', 'Intro to Databases', 4, 2),
(2, 'NUR423', 'Nursing Leadership', 4, 3),
(3, 'ED300', 'Transitions', 2, 6),
(4, 'ACTG317', 'External Reporting 1', 4, 4);

INSERT INTO CourseTerms VALUES
(1, 1, 6, 1),
(2, 2, 5, 2),
(3, 3, 4, 3),
(4, 4, 7, 4);

INSERT INTO StudentHasCourses VALUES
(1, 2),
(1, 4),
(3, 3),
(4, 1);
