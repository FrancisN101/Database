const { Pool } = require("pg");

// PostgreSQL connection configuration
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  const createMoviesTable = `
    CREATE TABLE IF NOT EXISTS Movies (
      movie_id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      release_year INT,
      genre VARCHAR(100),
      director VARCHAR(255)
    );
  `;

  const createCustomersTable = `
    CREATE TABLE IF NOT EXISTS Customers (
      customer_id SERIAL PRIMARY KEY,
      first_name VARCHAR(100) NOT NULL,
      last_name VARCHAR(100) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      phone_number VARCHAR(20)
    );
  `;

  const createRentalsTable = `
    CREATE TABLE IF NOT EXISTS Rentals (
      rental_id SERIAL PRIMARY KEY,
      customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
      movie_id INT REFERENCES Movies(movie_id) ON DELETE CASCADE,
      rental_date DATE NOT NULL,
      return_date DATE
    );
  `;

  try {
    await pool.query(createMoviesTable);
    await pool.query(createCustomersTable);
    await pool.query(createRentalsTable);
    console.log("Tables created successfully.");
  } catch (error) {
    console.error("Error creating tables:", error);
  }
}

/**
 * Inserts a new movie into the Movies table.
 *
 * @param {string} title Title of the movie
 * @param {number} year Year the movie was released
 * @param {string} genre Genre of the movie
 * @param {string} director Director of the movie
 */
async function insertMovie(title, year, genre, director) {
  const query = `
    INSERT INTO Movies (title, release_year, genre, director)
    VALUES ($1, $2, $3, $4)
    RETURNING *;
  `;
  try {
    const result = await pool.query(query, [title, year, genre, director]);
    console.log("Movie inserted:", result.rows[0]);
  } catch (error) {
    console.error("Error inserting movie:", error);
  }
}

/**
 * Prints all movies in the database to the console.
 */
async function displayMovies() {
  const query = `SELECT * FROM Movies;`;
  try {
    const result = await pool.query(query);
    result.rows.forEach((movie) => console.log(movie));
  } catch (error) {
    console.error("Error displaying movies:", error);
  }
}

/**
 * Updates a customer's email address.
 *
 * @param {number} customerId ID of the customer
 * @param {string} newEmail New email address of the customer
 */
async function updateCustomerEmail(customerId, newEmail) {
  const query = `
    UPDATE Customers SET email = $1 WHERE customer_id = $2 RETURNING *;
  `;
  try {
    const result = await pool.query(query, [newEmail, customerId]);
    if (result.rows.length === 0) {
      console.log("No customer found with the specified ID.");
    } else {
      console.log("Customer email updated:", result.rows[0]);
    }
  } catch (error) {
    console.error("Error updating customer email:", error);
  }
}

/**
 * Removes a customer from the database along with their rental history.
 *
 * @param {number} customerId ID of the customer to remove
 */
async function removeCustomer(customerId) {
  const query = `
    DELETE FROM Customers WHERE customer_id = $1 RETURNING *;
  `;
  try {
    const result = await pool.query(query, [customerId]);
    if (result.rows.length === 0) {
      console.log("No customer found with the specified ID.");
    } else {
      console.log("Customer and rental history removed:", result.rows[0]);
    }
  } catch (error) {
    console.error("Error removing customer:", error);
  }
}

/**
 * Prints a help message to the console.
 */
function printHelp() {
  console.log("Usage:");
  console.log("  insert <title> <year> <genre> <director> - Insert a movie");
  console.log("  show - Show all movies");
  console.log("  update <customer_id> <new_email> - Update a customer's email");
  console.log("  remove <customer_id> - Remove a customer from the database");
}

/**
 * Runs our CLI app to manage the movie rentals database.
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case "insert":
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case "show":
      await displayMovies();
      break;
    case "update":
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case "remove":
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
}

runCLI();
