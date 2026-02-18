// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 8245;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

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
            SELECT studentId, firstName, lastName, email, major
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
            SELECT courseId, courseCode, courseTitle, courseCredit, departmentId
            FROM Courses;
        `;

        // Execute the query
        const [courses] = await db.query(query);

        // Render the courses.hbs file, passing the courses data
        res.render('courses', { courses: courses });
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
            SELECT departmentId, departmentName
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
            SELECT instructorId, firstName, lastName, email, departmentId
            FROM Instructors;
        `;

        // Execute the query
        const [instructors] = await db.query(query);

        // Render the instructors.hbs file, passing the instructors data
        res.render('instructors', { instructors: instructors });
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
            SELECT academicTermId, termName, startDate, endDate, year
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
});
app.get('/courseTerms', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT 
                ct.courseTermID,
                c.courseTitle AS courseName,
                a.termName AS academicTerm,
                i.firstName AS instructorFirstName,
                i.lastName AS instructorLastName
            FROM CourseTerms ct
            JOIN Courses c
                ON ct.courseID = c.courseID
            JOIN AcademicTerms a
                ON ct.academicTermID = a.academicTermID
            JOIN Instructors i
                ON ct.instructorID = i.instructorID
            ORDER BY c.courseTitle, a.termName
        `);

        res.render('courseTerms', { courseTerms: rows });
    } catch (err) {
        console.error('SQL ERROR:', err);
        res.status(500).send('Failed to load course terms');
    }
});
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
        const { studentId, email, major } = req.body;

        await db.query(
            `UPDATE Students SET email = ?, major = ? WHERE studentId = ?`,
            [email, major, studentId]
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
        const { studentId } = req.body;

        await db.query(
            `DELETE FROM Students WHERE studentId = ?`,
            [studentId]
        );

        res.redirect('/Students');
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to delete student.');
    }
});

// =====================
// CREATE a instructor
// =====================
// =====================
// UPDATE a instructor
// =====================
// =====================
// DELETE a instructor
// =====================


// =====================
// CREATE a course
// =====================
// =====================
// UPDATE a course
// =====================
// =====================
// DELETE a course
// =====================


// =====================
// CREATE a department
// =====================
// =====================
// UPDATE a department
// =====================
// =====================
// DELETE a department
// =====================


// =====================
// CREATE a academic term
// =====================
// =====================
// UPDATE a academic term
// =====================
// =====================
// DELETE a academic term
// =====================



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
app.get('/courseTerms/add', async (req, res) => {
    try {
        res.render('add-courseterm'); // Render a form specifically for adding CourseTerms
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to load add course term page');
    }
});

app.post('/courseTerms/add', async (req, res) => {
    try {
        const { courseID, termName, startDate, endDate } = req.body;

        await db.query(
            `INSERT INTO CourseTerms (courseID, termName, startDate, endDate)
             VALUES (?, ?, ?, ?)`,
            [courseID, termName, startDate, endDate]
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

        await db.query(
            `DELETE FROM CourseTerms WHERE courseTermID = ?`,
            [courseTermID]
        );

        res.redirect('/courseTerms'); // Redirect to your CourseTerms list page
    } catch (err) {
        console.error(err);
        res.status(500).send('Failed to delete course term');
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