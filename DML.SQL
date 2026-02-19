-- Database Manipulation Queries for our Course Registration database.
-- Variables that will eventually be supplied by the backend are denoted with @

-- STUDENTS

-- Get all students for the Browse Students page
SELECT studentID, firstName, lastName, email, major
FROM Students;

-- Get a single student's data for the Update Student form
SELECT studentID, firstName, lastName, email, major
FROM Students
WHERE studentID = @studentID_selected_from_browse_page;

-- Add a new student
INSERT INTO Students (firstName, lastName, email, major)
VALUES (@firstNameInput, @lastNameInput, @emailInput, @majorInput);

-- Update a student's data based on submission of the Update Student form
-- Names are immutable in this database design, but email (for now) and major can be updated
UPDATE Students
SET email = @emailInput, major = @majorInput
WHERE studentID = @studentID_from_update_form;

-- Delete a student
DELETE FROM Students
WHERE studentID = @studentID_selected_from_browse_page;

-- COURSES

-- Get all courses for the Browse Courses page (JOIN to get department name)
SELECT 
    c.courseID,
    c.courseCode,
    c.courseTitle,
    c.courseCredit,
    d.departmentName AS departmentName
FROM Courses c
JOIN Departments d ON c.departmentID = d.departmentID;

-- Get all departments for the dropdown menu in the Course form
SELECT departmentID, departmentName
FROM Departments;

-- Get a single course's data for the Update Course form
SELECT courseID, courseCode, courseTitle, courseCredit, departmentID
FROM Courses
WHERE courseID = @courseID_selected_from_browse_page;

-- Add a new course
INSERT INTO Courses (courseCode, courseTitle, courseCredit, departmentID)
VALUES (@courseCodeInput, @courseTitleInput, @courseCreditInput, @departmentIDInput);

-- Update a course
UPDATE Courses
SET courseCode = @courseCodeInput,
    courseTitle = @courseTitleInput,
    courseCredit = @courseCreditInput,
    departmentID = @departmentIDInput
WHERE courseID = @courseID_from_update_form;

-- Delete a course
DELETE FROM Courses
WHERE courseID = @courseID_selected_from_browse_page;

-- INSTRUCTORS

-- Get all instructors for the Browse Instructors page (JOIN to get department name)
SELECT 
    i.instructorID,
    i.firstName,
    i.lastName,
    i.email,
    d.departmentName AS departmentName
FROM Instructors i
JOIN Departments d ON i.departmentID = d.departmentID;

-- Get all departments for the dropdown menu in the Instructor form
SELECT departmentID, departmentName
FROM Departments;

-- Get a single instructor's data for the Update Instructor form
SELECT instructorID, firstName, lastName, email, departmentID
FROM Instructors
WHERE instructorID = @instructorID_selected_from_browse_page;

-- Add a new instructor
INSERT INTO Instructors (firstName, lastName, email, departmentID)
VALUES (@firstNameInput, @lastNameInput, @emailInput, @departmentIDInput);

-- Update an instructor
UPDATE Instructors
SET firstName = @firstNameInput,
    lastName = @lastNameInput,
    email = @emailInput,
    departmentID = @departmentIDInput
WHERE instructorID = @instructorID_from_update_form;

-- Delete an instructor
DELETE FROM Instructors
WHERE instructorID = @instructorID_selected_from_browse_page;

-- DEPARTMENTS

-- Get all departments for the Browse Departments page
SELECT departmentID, departmentName
FROM Departments;

-- Get a single department's data for the Update Department form
SELECT departmentID, departmentName
FROM Departments
WHERE departmentID = @departmentID_selected_from_browse_page;

-- Add a new department
INSERT INTO Departments (departmentName)
VALUES (@departmentNameInput);

-- Update a department
UPDATE Departments
SET departmentName = @departmentNameInput
WHERE departmentID = @departmentID_from_update_form;

-- Delete a department
DELETE FROM Departments
WHERE departmentID = @departmentID_selected_from_browse_page;

-- ACADEMIC TERMS

-- Get all academic terms for the Browse Academic Terms page
SELECT academicTermID, termName, startDate, endDate, year
FROM AcademicTerms;

-- Get a single academic term's data for the Update Academic Term form
SELECT academicTermID, termName, startDate, endDate, year
FROM AcademicTerms
WHERE academicTermID = @academicTermID_selected_from_browse_page;

-- Add a new academic term
INSERT INTO AcademicTerms (termName, startDate, endDate, year)
VALUES (@termNameInput, @startDateInput, @endDateInput, @yearInput);

-- Update an academic term
UPDATE AcademicTerms
SET termName = @termNameInput,
    startDate = @startDateInput,
    endDate = @endDateInput,
    year = @yearInput
WHERE academicTermID = @academicTermID_from_update_form;

-- Delete an academic term
DELETE FROM AcademicTerms
WHERE academicTermID = @academicTermID_selected_from_browse_page;

-- COURSE OFFERINGS (CourseTerms)

-- Get all course offerings for the Browse Course Offerings page (JOINs to make FKs user-friendly)
SELECT
    ct.courseTermID,
    c.courseCode || ' - ' || c.courseTitle AS courseName,
    CONCAT(i.firstName, ' ', i.lastName) AS instructorName,
    at.termName,
    at.startDate,
    at.endDate
FROM CourseTerms ct
JOIN Courses c 
    ON ct.courseID = c.courseID
JOIN Instructors i 
    ON ct.instructorID = i.instructorID
JOIN AcademicTerms at 
    ON ct.academicTermID = at.academicTermID;

-- Delete a course offering
DELETE FROM CourseTerms
WHERE courseTermID = @courseTermID_selected;

-- Update the instructor for a specific course offering
UPDATE CourseTerms
SET instructorID = @newInstructorID
WHERE courseTermID = @courseTermID_selected;

-- STUDENT ENROLLMENTS (StudentHasCourses)

-- Get all student enrollments for the Browse Enrollments page (JOINs to make FKs user-friendly)
SELECT
    shc.studentID,
    CONCAT(s.firstName, ' ', s.lastName) AS studentName,
    c.courseCode || ' - ' || c.courseTitle AS courseName,
    shc.courseTermID,
    at.termName
FROM StudentHasCourses shc
JOIN Students s 
    ON shc.studentID = s.studentID
JOIN CourseTerms ct 
    ON shc.courseTermID = ct.courseTermID
JOIN Courses c 
    ON ct.courseID = c.courseID
JOIN AcademicTerms at 
    ON ct.academicTermID = at.academicTermID;

-- Delete student's enrollment in a course
DELETE FROM StudentHasCourses
WHERE studentID = @studentID_selected
  AND courseTermID = @courseTermID_selected;
