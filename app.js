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

app.get('/Courses', async function (req, res) {
    try {
        // Query to get all courses
        const query = `
            SELECT courseId, courseName, courseTitle, courseCredit, departmentId
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
// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});