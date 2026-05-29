-- SQL script to initialize the database schema for the book collection application

-- Create custom ENUM types for book format, ownership status, and reading status
CREATE TYPE book_format AS ENUM ('hardcover', 'paperback', 'massmarket');

CREATE TYPE ownership_status AS ENUM ('owned', 'previously_owned', 'on_loan', 'wishlist');

CREATE TYPE reading_status AS ENUM ('unread', 'currently_reading', 'read', 'excluded', 'dnf');

-- Create tables for series, authors, borrowers, books, book_authors, reviews, and loans
CREATE TABLE series (
	series_id SERIAL PRIMARY KEY,
	series_name TEXT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AUTHORS (
	author_id SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BORROWERS (
	borrower_id SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BOOKS (
	isbn text PRIMARY KEY,
	title TEXT NOT NULL,
	page_count INTEGER,
	format book_format NOT NULL,
	series_id INTEGER REFERENCES series(series_id),
	series_order INTEGER,
	primary_genre TEXT NOT NULL,
	sub_genre TEXT,
	publisher TEXT NOT NULL,
	publication_date DATE,
	img_path TEXT,
	ownership_status ownership_status NOT NULL,
	reading_status reading_status NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BOOK_AUTHORS (
	isbn text REFERENCES BOOKS(isbn),
	author_id INTEGER REFERENCES AUTHORS(author_id),
	PRIMARY KEY (isbn, author_id),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE REVIEWS (
	review_id SERIAL PRIMARY KEY,
	isbn text REFERENCES BOOKS(isbn),
	read_date DATE,
	rating INTEGER CHECK (rating >= 1 AND rating <= 5),
	review_text TEXT,
	dnf BOOLEAN,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE LOANS (
	loan_id SERIAL PRIMARY KEY,
	isbn text REFERENCES BOOKS(isbn),
	borrower_id INTEGER REFERENCES BORROWERS(borrower_id),
	loan_date DATE,
	return_date DATE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a trigger function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_series
BEFORE UPDATE ON series
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_authors
BEFORE UPDATE ON authors
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_borrowers
BEFORE UPDATE ON borrowers
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_books
BEFORE UPDATE ON books
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_book_authors
BEFORE UPDATE ON book_authors
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_reviews
BEFORE UPDATE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_loans
BEFORE UPDATE ON loans
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();