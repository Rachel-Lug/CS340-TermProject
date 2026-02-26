DROP PROCEDURE IF EXISTS sp_load_classdb;
DROP PROCEDURE IF EXISTS delete_John_Miller;

DELIMITER //

CREATE PROCEDURE sp_load_classdb()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    DROP TABLE IF EXISTS StudentHasCourses;
    DROP TABLE IF EXISTS CourseTerms;
    DROP TABLE IF EXISTS Courses;
    DROP TABLE IF EXISTS Instructors;
    DROP TABLE IF EXISTS Students;
    DROP TABLE IF EXISTS AcademicTerms;
    DROP TABLE IF EXISTS Departments;

    -- -----------------------------------------------------
    -- Table `Departments`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Departments (
        departmentID INT(11) NOT NULL AUTO_INCREMENT,
        departmentName VARCHAR(50) NOT NULL,
        PRIMARY KEY (departmentID),
        UNIQUE KEY (departmentName)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO Departments (departmentID, departmentName) VALUES
        (4, 'Accounting'),
        (1, 'Biology'),
        (2, 'Computer Science'),
        (5, 'Electrical Engineering'),
        (3, 'Nursing'),
        (6, 'Teaching');

    -- -----------------------------------------------------
    -- Table `AcademicTerms`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS AcademicTerms (
        academicTermID INT(11) NOT NULL AUTO_INCREMENT,
        termName VARCHAR(50) NOT NULL,
        startDate DATE NOT NULL,
        endDate DATE NOT NULL,
        year INT(4) NOT NULL,
        PRIMARY KEY (academicTermID),
        UNIQUE KEY (academicTermID)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO AcademicTerms (academicTermID, termName, startDate, endDate, year) VALUES
        (1, 'Fall',   '2025-09-24', '2025-12-05', 2025),
        (2, 'Winter', '2026-01-05', '2026-03-13', 2026),
        (3, 'Spring', '2026-03-30', '2026-06-05', 2026),
        (4, 'Summer', '2026-06-22', '2026-08-14', 2026);

    -- -----------------------------------------------------
    -- Table `Students`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Students (
        studentID INT(11) NOT NULL AUTO_INCREMENT,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        major VARCHAR(50) NOT NULL,
        PRIMARY KEY (studentID),
        UNIQUE KEY (studentID),
        UNIQUE KEY (email)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO Students (studentID, firstName, lastName, email, major) VALUES
        (1, 'Sarah', 'Doe',    'Does@oregonstate.edu',    'Accounting'),
        (2, 'John',  'Miller', 'MillerJ@oregonstate.edu', 'Computer Science'),
        (3, 'Jamie', 'James',  'JamesJ@gmail.com',        'Biology'),
        (4, 'Heidi', 'Lee',    'LeeH@yahoo.com',          'Nursing');

    -- -----------------------------------------------------
    -- Table `Instructors`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Instructors (
        instructorID INT(11) NOT NULL AUTO_INCREMENT,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        departmentID INT(11) NOT NULL,
        PRIMARY KEY (instructorID),
        UNIQUE KEY (instructorID),
        UNIQUE KEY (email),
        KEY fk_instructors_departments (departmentID),
        CONSTRAINT fk_instructors_departments
            FOREIGN KEY (departmentID)
            REFERENCES Departments (departmentID)
            ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO Instructors (instructorID, firstName, lastName, email, departmentID) VALUES
        (4, 'Melissa', 'Mossgrove', 'MossgroveM@oregonstate.edu', 1),
        (5, 'Gina',    'Delacruz',  'DelacruzG@oregonstate.edu',  3),
        (6, 'Michael', 'Curry',     'CurryM@oregonstate.edu',     2),
        (7, 'Jacob',   'York',      'YorkJ@gmail.com',            4);

    -- -----------------------------------------------------
    -- Table `Courses`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS Courses (
        courseID INT(11) NOT NULL AUTO_INCREMENT,
        courseCode VARCHAR(50) NOT NULL,
        courseTitle VARCHAR(65) NOT NULL,
        courseCredit TINYINT(6) NOT NULL,
        departmentID INT(11) NOT NULL,
        PRIMARY KEY (courseID),
        KEY fk_courses_departments (departmentID),
        CONSTRAINT fk_courses_departments
            FOREIGN KEY (departmentID)
            REFERENCES Departments (departmentID)
            ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO Courses (courseID, courseCode, courseTitle, courseCredit, departmentID) VALUES
        (1, 'CS340',   'Intro to Databases',    4, 2),
        (2, 'NUR423',  'Nursing Leadership',    4, 3),
        (3, 'ED300',   'Transitions',           2, 6),
        (4, 'ACTG317', 'External Reporting 1',  4, 4);

    -- -----------------------------------------------------
    -- Table `CourseTerms`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS CourseTerms (
        courseTermID INT(11) NOT NULL AUTO_INCREMENT,
        academicTermID INT(11) NOT NULL,
        instructorID INT(11) NOT NULL,
        courseID INT(11) NOT NULL,
        PRIMARY KEY (courseTermID),
        UNIQUE KEY (courseTermID),
        UNIQUE KEY (courseID, academicTermID, instructorID),
        KEY fk_courseterms_academicterms (academicTermID),
        KEY fk_courseterms_instructors (instructorID),
        CONSTRAINT fk_courseterms_academicterms
            FOREIGN KEY (academicTermID)
            REFERENCES AcademicTerms (academicTermID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        CONSTRAINT fk_courseterms_courses
            FOREIGN KEY (courseID)
            REFERENCES Courses (courseID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        CONSTRAINT fk_courseterms_instructors
            FOREIGN KEY (instructorID)
            REFERENCES Instructors (instructorID)
            ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO CourseTerms (courseTermID, academicTermID, instructorID, courseID) VALUES
        (1, 1, 6, 1),
        (2, 2, 5, 2),
        (3, 3, 4, 3),
        (4, 4, 7, 4);

    -- -----------------------------------------------------
    -- Table `StudentHasCourses`
    -- -----------------------------------------------------
    CREATE TABLE IF NOT EXISTS StudentHasCourses (
        studentID INT(11) NOT NULL,
        courseTermID INT(11) NOT NULL,
        PRIMARY KEY (studentID, courseTermID),
        KEY fk_shc_courseterms (courseTermID),
        CONSTRAINT fk_shc_students
            FOREIGN KEY (studentID)
            REFERENCES Students (studentID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        CONSTRAINT fk_shc_courseterms
            FOREIGN KEY (courseTermID)
            REFERENCES CourseTerms (courseTermID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    INSERT INTO StudentHasCourses (studentID, courseTermID) VALUES
        (1, 2),
        (1, 4),
        (3, 3),
        (4, 1);

    SET FOREIGN_KEY_CHECKS = 1;
END//

-- -----------------------------------------------------
-- Demo CUD delete procedure to show RESET works
-- Deletes John Miller from the Students table
-- -----------------------------------------------------
CREATE PROCEDURE delete_John_Miller()
BEGIN
    DELETE FROM Students WHERE email = 'MillerJ@oregonstate.edu';
END//

DELIMITER ;