-- Creating the 'students' table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    enrollment_date DATE
);

-- Creating the 'professors' table
CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100)
);

-- Creating the 'courses' table
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT,
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professors(id)
);

-- Creating the 'enrollments' table
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Inserting data into the 'students' table
INSERT INTO students (first_name, last_name, email, enrollment_date)
VALUES 
    ('Alex', 'Johnson', 'alex.johnson@gmail.com', '2023-09-01'),
    ('Jane', 'Smith', 'jane.smith@gmail.com', '2023-09-02'),
    ('JessePinkman', 'White', 'jessepinkman.white@gmail.com', '2023-09-03'),
    ('WalterWhite', 'Wilson', 'walterwhite.wilson@gmail.com', '2023-09-04'),
    ('Peter', 'Parker', 'peter.parker@gmail.com', '2023-09-05'),
    ('Harry', 'Strawberry', 'harry.strawberry@gmail.com', '2023-09-06');

-- Inserting data into the 'professors' table
INSERT INTO professors (first_name, last_name, department)
VALUES 
    ('Jennifer', 'Doe', 'Physics'),
    ('MrDoc', 'Smith', 'Mathematics'),
    ('Maximus', 'Aurelius', 'Computer Science'),
    ('John', 'Wick', 'Chemistry'),
    ('Billie', 'Eilish', 'Music');

-- Inserting data into the 'courses' table
INSERT INTO courses (course_name, course_description, professor_id)
VALUES
    ('Physics 101', 'Introduction to Physics', 1),
    ('Calculus 101', 'Basic Calculus', 2),
    ('Programming 101', 'Introduction to Programming', 3);

-- Inserting data into the 'enrollments' table
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
    (1, 1, '2023-09-10'), -- Alex in Physics 101
    (2, 1, '2023-09-10'), -- Jane in Physics 101
    (3, 2, '2023-09-11'), -- JessePinkman in Calculus 101
    (4, 3, '2023-09-12'), -- WalterWhite in Programming 101
    (5, 1, '2023-09-13'), -- Peter in Physics 101
    (6, 3, '2023-09-14'); -- Harry in Programming 101

--1. Retrieve the full names of all students enrolled in "Physics 101"
SELECT students.first_name || ' ' || students.last_name AS full_name
FROM students
JOIN enrollments ON students.id = enrollments.student_id
JOIN courses ON enrollments.course_id = courses.id
WHERE courses.course_name = 'Physics 101';

--2. Retrieve a list of all courses along with the professor's full name who teaches each course
SELECT courses.course_name, professors.first_name || ' ' || professors.last_name AS professor_name
FROM courses
JOIN professors ON courses.professor_id = professors.id;

--3. Retrieve all courses that have students enrolled in them
SELECT DISTINCT courses.course_name
FROM courses
JOIN enrollments ON courses.id = enrollments.course_id;

-- Update one of the student's emails 
UPDATE students
SET email = 'jane.smith_updated@gmail.com'
WHERE first_name = 'Jane' AND last_name = 'Smith';

-- Remove a student from one of their courses 
DELETE FROM enrollments
WHERE student_id = (SELECT id FROM students WHERE first_name = 'Alex' AND last_name = 'Johnson')
AND course_id = (SELECT id FROM courses WHERE course_name = 'Physics 101');
