// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 12550;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine

app.engine('.hbs', engine({
    extname: '.hbs',
    helpers: {
        eq: (a, b) => a == b // helper for comparing values in templates
    }
}));

app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/Students', async function (req, res) {
    try {
        // Query to get all students
        const query = `
            SELECT studentID, firstName, lastName, email, major
            FROM Students;
        `;

        // Execute the query
        const [students] = await db.query(query);

        // Render the students.hbs file, passing the students data
        res.render('students', { students: students });
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).send(
            'An error occurred while executing the database query.'
        );
    }
});

app.get('/courses', async function (req, res) {
    try {
        // Query to get all courses
        const query = `
            SELECT courseID, courseCode, courseTitle, courseCredit, departmentID
            FROM Courses;
        `;

        const departmentsQuery = `
            SELECT departmentID, departmentName
            FROM Departments
            ORDER BY departmentID ASC;
        `;
        // Execute the queries
        const [courses] = await db.query(query);
        const [departments] = await db.query(departmentsQuery);

        // Render the courses.hbs file, passing the courses data
        res.render('courses', { courses: courses, departments: departments });
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).send(
            'An error occurred while executing the database query.'
        );
    }
});

app.get('/Departments', async function (req, res) {
    try {
        // Query to get all departments
        const query = `
            SELECT departmentID, departmentName
            FROM Departments;
        `;

        // Execute the query
        const [departments] = await db.query(query);

        // Render the departments.hbs file, passing the departments data
        res.render('departments', { departments: departments });
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).send(
            'An error occurred while executing the database query.'
        );
    }
});

app.get('/Instructors', async function (req, res) {
    try {
        // Query to get all instructors
        const query = `
            SELECT instructorID, firstName, lastName, email, departmentID
            FROM Instructors;
        `;

        const departmentsQuery = `
            SELECT departmentID, departmentName
            FROM Departments
            ORDER BY departmentID ASC;
        `;

        // Execute the queries
        const [instructors] = await db.query(query);
        const [departments] = await db.query(departmentsQuery);

        // Render the instructors.hbs file, passing the instructors data
        res.render('instructors', { instructors: instructors, departments: departments });
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).send(
            'An error occurred while executing the database query.'
        );
    }
});

app.get('/AcademicTerms', async function (req, res) {
    try {
        // Query to get all academic terms
        const query = `
            SELECT academicTermId, 
            termName, 
            DATE_FORMAT(startDate, '%Y-%m-%d') AS startDate,
            DATE_FORMAT(endDate, '%Y-%m-%d') AS endDate,
            year
            FROM AcademicTerms;
        `;

        // Execute the query
        const [academicTerms] = await db.query(query);

        // Render the academicTerms.hbs file, passing the academicTerms data
        res.render('academicTerms', { academicTerms: academicTerms });
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).send(
            'An error occurred while executing the database query.'
        );
    }
});

app.get('/studentcourses', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT
                CONCAT(s.firstName, ' ', s.lastName) AS studentName,
                c.courseTitle AS courseName,
                shc.studentID,
                shc.courseTermID
            FROM StudentHasCourses shc
            JOIN Students s
                ON shc.studentID = s.studentID
            JOIN CourseTerms ct
                ON shc.courseTermID = ct.courseTermID
            JOIN Courses c
                ON ct.courseID = c.courseID
            ORDER BY c.courseTitle, s.lastName
        `);

        res.render('studentcourses', { studentcourses: rows });
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to load student courses');
    }
});
//
//------------------------------------------------------------------------------------------
//Below is the CRUD for all sections
// =====================
// CREATE a Student
// =====================
app.post('/students/create', async (req, res) => {
    try {
        const { firstName, lastName, email, major } = req.body;

        await db.query(
            `INSERT INTO Students (firstName, lastName, email, major) VALUES (?, ?, ?, ?)`,
            [firstName, lastName, email, major]
        );

        res.redirect('/Students');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to create student.');
    }
});
// =====================
// UPDATE a Student
// =====================
app.post('/students/update', async (req, res) => {
    try {
        const { studentID, email, major } = req.body;

        await db.query(
            `UPDATE Students SET email = ?, major = ? WHERE studentID = ?`,
            [email, major, studentID]
        );

        res.redirect('/Students');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to update student.');
    }
});
// =====================
// DELETE a Student
// =====================
app.post('/students/delete', async (req, res) => {
    try {
        const { studentID } = req.body;

        await db.query(
            `DELETE FROM Students WHERE studentID = ?`,
            [studentID]
        );

        res.redirect('/students');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to delete student.');
    }
});

// =====================
// CREATE a instructor
// =====================
app.post('/instructors/create', async (req, res) => {
    try {
        const { firstName, lastName, email, departmentID } = req.body;

        await db.query(
            `INSERT INTO Instructors (firstName, lastName, email, departmentID) VALUES (?, ?, ?, ?)`,
            [firstName, lastName, email, departmentID]
        );

        res.redirect('/instructors');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to create instructor.');
    }
});

// =====================
// UPDATE a instructor
// =====================
app.post('/instructors/update', async (req, res) => {
    try {
        const { instructorID, email, departmentID } = req.body;

        await db.query(
            `UPDATE Instructors SET email = ?, departmentID = ? WHERE instructorID = ?`,
            [email, departmentID, instructorID]
        );

        res.redirect('/instructors');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to update instructor.');
    }
});

    
// =====================
// DELETE a instructor
// =====================
app.post('/instructors/delete', async (req, res) => {
    try {
        const { instructorID } = req.body;

        await db.query(
            `DELETE FROM Instructors WHERE instructorID = ?`,
            [instructorID]
        );

        res.redirect('/instructors');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to update instructor.');
    }
});


// =====================
// CREATE a course
// =====================
app.post('/courses/create', async (req, res) => {
    try {
        const { courseCode, courseTitle, courseCredit, departmentID } = req.body;

        await db.query(
            `INSERT INTO Courses (courseCode, courseTitle, courseCredit, departmentID) VALUES (?, ?, ?, ?)`,
            [courseCode, courseTitle, courseCredit, departmentID]
        );

        res.redirect('/courses');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to create course.');
    }
});

// =====================
// UPDATE a course
// =====================
app.post('/courses/update', async (req, res) => {
    try {
        const { courseID, courseCode, courseTitle, courseCredit, departmentID } = req.body;

        await db.query(
            `UPDATE Courses 
             SET courseCode = ?, courseTitle = ?, courseCredit = ?, departmentID = ?
             WHERE courseID = ?`,
            [courseCode, courseTitle, courseCredit, departmentID, courseID]
        );

        res.redirect('/courses');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to update course.');
    }
});

// =====================
// DELETE a course
// =====================
app.post('/courses/delete', async (req, res) => {
    try {
        const { courseID } = req.body;

        await db.query(
            `DELETE FROM Courses WHERE courseID = ?`,
            [courseID]
        );

        res.redirect('/courses');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to delete course.');
    }
});

// =====================
// CREATE a department
// =====================
app.post('/departments/create', async (req, res) => {
    try {
        const { departmentName } = req.body;
        await db.query(
            `INSERT INTO Departments (departmentName) VALUES (?)`,
            [departmentName]
        );
        res.redirect('/departments');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to create department.');
    }
});

// =====================
// UPDATE a department
// =====================
app.post('/departments/update', async (req, res) => {
    try {
        const { departmentID, departmentName } = req.body;
        await db.query(
            `UPDATE Departments SET departmentName = ? WHERE departmentID = ?`,
            [departmentName, departmentID]
        );
        res.redirect('/departments');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to update department.');
    }
});

// =====================
// DELETE a department
// =====================
app.post('/departments/delete', async (req, res) => {
    try {
        const { departmentID } = req.body;
        await db.query(
            `DELETE FROM Departments WHERE departmentID = ?`,
            [departmentID]
        );
        res.redirect('/departments');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to delete department.');
    }
});

//========================
// CREATE students courses 
//========================
app.get('/studentcourses/add', async (req, res) => {
    const [students] = await db.query(`
        SELECT studentID, firstName, lastName
        FROM Students
    `);

    const [courseTerms] = await db.query(`
        SELECT courseTermID, termName
        FROM CourseTerms
    `);

    res.render('add-studentcourse', {
        students,
        courseTerms
    });
});
app.post('/studentcourses/add', async (req, res) => {
    const { studentID, courseTermID } = req.body;

    await db.query(
        `INSERT INTO StudentHasCourses (studentID, courseTermID)
         VALUES (?, ?)`,
        [studentID, courseTermID]
    );

    res.redirect('/studentcourses');
});
//========================
// DELETE students courses
//========================
app.post('/studentcourses/delete', async (req, res) => {
    const { studentID, courseTermID } = req.body;

    await db.query(
        `DELETE FROM StudentHasCourses
         WHERE studentID = ? AND courseTermID = ?`,
        [studentID, courseTermID]
    );

    res.redirect('/studentcourses');
});
//========================
// CREATE Course Terms
//========================
app.get('/courseTerms', async (req, res) => {
    try {
        const [courseTerms] = await db.query(`
            SELECT 
                ct.courseTermID,
                c.courseTitle AS courseName,
                at.termName,
                ct.instructorID,
                CONCAT(i.firstName, ' ', i.lastName) AS instructorName,
                DATE_FORMAT(at.startDate, '%Y-%m-%d') AS startDate,
                DATE_FORMAT(at.endDate, '%Y-%m-%d') AS endDate
            FROM CourseTerms ct
            JOIN Courses c 
                ON ct.courseID = c.courseID
            JOIN AcademicTerms at 
                ON ct.academicTermID = at.academicTermID
            LEFT JOIN Instructors i
                ON ct.instructorID = i.instructorID
            ORDER BY c.courseTitle, at.termName
        `);

        const [instructors] = await db.query(`
            SELECT instructorID, firstName, lastName
            FROM Instructors
            ORDER BY lastName, firstName
        `);

        const [courses] = await db.query(`
            SELECT courseID, courseTitle AS courseName
            FROM Courses
            ORDER BY courseTitle;
        `);

        const [academicTerms] = await db.query(`
            SELECT academicTermID, termName
            FROM AcademicTerms
            ORDER BY termName;
        `);

        res.render('courseTerms', { 
            courseTerms, 
            instructors,
            courses,
            academicTerms,
        });
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to load course terms');
    }
});

app.post('/courseTerms/add', async (req, res) => {
    try {
        const { courseID, academicTermID, instructorID } = req.body;

        // Call the stored procedure instead of direct query
        await db.query(
            `CALL sp_courseTerm_insert(?, ?, ?)`,
            [courseID, academicTermID, instructorID]
        );

        res.redirect('/courseTerms'); // Redirect to your CourseTerms list page
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to add course term');
    }
});

//========================
// DELETE Course Terms
//========================
app.post('/courseTerms/delete', async (req, res) => {
    try {
        const { courseTermID } = req.body;

        // Call the stored procedure instead of direct query
        await db.query(
            `CALL sp_courseTerm_delete(?)`,
            [courseTermID]
        );

        res.redirect('/courseTerms'); // Redirect to your CourseTerms list page
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to delete course term');
    }
});
//========================
// UPDATE Course Terms
//========================
app.post('/courseTerms/update', async (req, res) => {
    try {
        const { courseTermID, newInstructorID } = req.body;

        // Call the stored procedure instead of direct query
        await db.query(
            `CALL sp_courseTerm_update(?, ?)`,
            [courseTermID, newInstructorID]
        );

        res.redirect('/courseTerms');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to update instructor for course term');
    }
});

//=============================
// BACKEND FOR RESET
//=============================
app.post('/reset', async (req, res) => {
    try {
        await db.query('CALL sp_load_classdb();');
        res.redirect('/');
    } catch (error) {
        console.error("RESET ERROR:", error);
        res.send(error.message);   // <-- show real error
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});
