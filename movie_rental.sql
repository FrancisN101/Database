CREATE TABLE IF NOT EXISTS Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    genre VARCHAR(100),
    director VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20)
);
CREATE TABLE IF NOT EXISTS Rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    movie_id INT REFERENCES Movies(movie_id) ON DELETE CASCADE,
    rental_date DATE NOT NULL,
    return_date DATE
);

INSERT INTO Movies (title, release_year, genre, director) VALUES
('Inception', 2010, 'Science Fiction', 'Christopher Nolan'),
('The Matrix', 1999, 'Action', 'Lana Wachowski'),
('Interstellar', 2014, 'Science Fiction', 'Christopher Nolan'),
('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
('Pulp Fiction', 1994, 'Crime', 'Quentin Tarantino');

INSERT INTO Customers (first_name, last_name, email, phone_number) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901'),
('Bob', 'Brown', 'bob.brown@example.com', '345-678-9012'),
('Alice', 'Johnson', 'alice.johnson@example.com', '456-789-0123'),
('Tom', 'Clark', 'tom.clark@example.com', '567-890-1234');

INSERT INTO Rentals (customer_id, movie_id, rental_date, return_date) VALUES
(1, 1, '2024-10-01', '2024-10-10'),
(2, 2, '2024-10-02', NULL),
(3, 3, '2024-10-03', '2024-10-08'),
(4, 4, '2024-10-04', NULL),
(5, 5, '2024-10-05', '2024-10-12'),
(1, 2, '2024-10-06', NULL),
(2, 3, '2024-10-07', '2024-10-14'),
(3, 4, '2024-10-08', NULL),
(4, 5, '2024-10-09', '2024-10-16'),
(5, 1, '2024-10-10', NULL);

-- Query 1: Find all movies rented by a specific customer (using email)
SELECT M.title, M.release_year, M.genre, M.director
FROM Rentals R
JOIN Movies M ON R.movie_id = M.movie_id
JOIN Customers C ON R.customer_id = C.customer_id
WHERE C.email = 'john.doe@example.com';

-- Query 2: List all customers who rented a specific movie
SELECT C.first_name, C.last_name, C.email, C.phone_number
FROM Rentals R
JOIN Customers C ON R.customer_id = C.customer_id
JOIN Movies M ON R.movie_id = M.movie_id
WHERE M.title = 'Inception';

-- Query 3: Retrieve the rental history for a specific movie
SELECT C.first_name, C.last_name, R.rental_date, R.return_date
FROM Rentals R
JOIN Customers C ON R.customer_id = C.customer_id
JOIN Movies M ON R.movie_id = M.movie_id
WHERE M.title = 'Inception'
ORDER BY R.rental_date;

-- Query 4: Retrieve all customers and movie titles for a specific director, with rental details
SELECT C.first_name, C.last_name, M.title, R.rental_date, R.return_date
FROM Rentals R
JOIN Customers C ON R.customer_id = C.customer_id
JOIN Movies M ON R.movie_id = M.movie_id
WHERE M.director = 'Christopher Nolan'
ORDER BY R.rental_date;

-- Query 5: List all currently rented movies (where the return date hasn’t been met)
SELECT M.title, C.first_name, C.last_name, R.rental_date
FROM Rentals R
JOIN Movies M ON R.movie_id = M.movie_id
JOIN Customers C ON R.customer_id = C.customer_id
WHERE R.return_date IS NULL;
