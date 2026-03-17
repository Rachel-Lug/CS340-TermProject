#  University Course Registration System

## Link: http://classwork.engr.oregonstate.edu:12875

### This project is the term project for Group 50, consisting of Rachel Luginbill, Jennifer Ho, and Conrad Lalk. 

The goal of the project is to develop a database that stores course information, including associated terms, instructors, and departments. The system will allow students to register for courses while providing faculty with improved access to student course information.

## Students Page
Allows users to create new student records, update existing student information, and delete students from the database.
  Students: stores details of individual student records 

  studentID: int, auto_increment, unique, not NULL, PK 

  firstName: VARCHAR(50), not NULL 

  lastName: VARCHAR(50), not NULL 

  email: VARCHAR(50), unique, not NULL 

  major: VARCHAR(50), not NULL 

  Relationships:  

  A many-to-many (M:M) relationship between Students and CourseTerms is implemented with the StudentHasCourses intersection table. Students can enroll in       multiple/specific courses (CourseTerms), and each course can have many students enrolled. 

## Courses Page 

Allows users to create new courses, update course information, and remove courses from the system.

  Courses: records the information of each course 

  courseID: int, auto_increment, unique, not NULL, PK 

  courseCode: VARCHAR(50), not NULL 

  courseTitle: VARCHAR(50), not NULL 

  courseCredit: tinyint(6), not NULL 

  Relationships:  

  1:M relationship between Departments and Courses is implemented by storing departmentID as a FK inside the Course table. 

  M:M relationship between Course and AcademicTerms is implemented with the CourseTerms intersection table. This relationship represents individual course       offerings as each offering can occur in a specific term and is taught by exactly one instructor. 

## Instructors Page 

Allows users to add new instructors, update instructor details, and delete instructor records.

  Instructors: records instructor details such as the course offerings they teach per term 
  
  instructorID: int, auto_increment, unique, not NULL, PK 
  
  firstName: VARCHAR(50), not NULL 
  
  lastName: VARCHAR(50), not NULL 
  
  email: VARCHAR(50), unique, not NULL 
  
  departmentID: int, FK referencing Departments.departmentID 
  
  Relationships:  
  
  1:M relationship between Instructors and CourseTerms. Each course offering is taught by exactly one instructor, though an instructor can teach multiple       course offerings across different courses and terms. The relationship is implemented by storing instructorID as a FK in the CourseTerms table. 
  
  1:M relationship between Instructors and Departments is implemented with departmentID as a FK inside Instructors. An instructor can only belong to only        one department, but a department can have multiple instructors. 

## Departments Page 

Allows users to create new departments, update department names, and delete departments.

  Departments: records the academic departments in the school 
  
  departmentID: int, auto_increment, unique, not NULL, PK 
  
  departmentName: VARCHAR(50), unique, not NULL 
  
  Relationships:  
  
  1:M relationship between Department and Instructors is implemented with departmentID as a FK inside Instructors. As stated above, there can be several         instructors within a department but not several departments for one professor. 
  
  1:M relationship between Departments and Courses is implemented with departmentID as a FK inside Courses. All courses belong to one department, e.g. CS340     is within the CS department and not CSMTH department. 

## Academic Terms Page 

Allows users to view recent academic terms.

  AcademicTerms: records academic terms during which course offerings are available 
  
  academicTermID: int, auto_increment, unique, not NULL, PK 
  
  termName: VARCHAR(50), not NULL 
  
  startDate: DATE, not NULL 
  
  endDate: DATE, not NULL 
  
  year: INT, not NULL 
  
  Though not 3NF, we decided to keep this somewhat redundant year attribute so that filtering academic terms solely by year remains an option. 
  
  Relationships: 
  
  M:M relationship between AcademicTerms and Courses is implemented with the CourseTerms intersection table. The M:M relationship comes from many courses       that can be offered in many terms.  

## Course Offerings Page 

Allows users to create course offerings for specific terms, assign instructors, update offering details, and delete offerings.

  CourseTerms: supports the M:M relationship between Courses and AcademicTerms. This relationship will represent individual course offerings.  
  
  courseTermID: int, not null, FK 
  
  courseID: int, not null, FK 
  
  termID: int, not null, FK 
  
  instructorID: int, not null, FK 
  
  Relationships: 
  
  1:M relationship between Courses and CourseTerms: one course can have many offerings in different terms. 
  
  1:M relationship between AcademicTerms and CourseTerms: one term can have many offerings 
  
  1:M relationship between Instructors and CourseTerms: one instructor can teach multiple course offerings 
  
  M:M relationship between Courses and AcademicTerms through CourseTerms intersection table. 

## Student Courses Page 

Allows users to view current student enrollments and remove students from courses.

  StudentHasCourses: creates the M:M relationship between Students and Courses by recording student enrollment. 
  
  studentID: int, not null, FK 
  
  courseTermID: int, not null, FK 
  
  Relationships:  
  
  This table creates the M:N relationship between Students and CourseTerms by associating student enrollment with specific course offerings. Each student       can enroll in multiple course offerings, and each course offering can have many students enrolled. 
