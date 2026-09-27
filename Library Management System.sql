SELECT 'Library Management System' AS project
FROM dual;

CREATE TABLE books (
    book_id NUMBER GENERATED ALWAYS AS IDENTITY,
    title VARCHAR2(150) NOT NULL,
    author VARCHAR2(100) NOT NULL,
    isbn VARCHAR2(30) UNIQUE,
    category VARCHAR2(50),
    publisher VARCHAR2(100),
    edition VARCHAR2(30),
    publication_year NUMBER(4),
    language VARCHAR2(30),
    price NUMBER(10,2),

    CONSTRAINT pk_books PRIMARY KEY (book_id)
);

SELECT * FROM books;

CREATE TABLE book_copies (
    copy_id NUMBER GENERATED ALWAYS AS IDENTITY,
    book_id NUMBER NOT NULL,
    accession_no VARCHAR2(30) UNIQUE NOT NULL,
    status VARCHAR2(20) DEFAULT 'AVAILABLE' NOT NULL,
    shelf VARCHAR2(50),

    CONSTRAINT pk_book_copies PRIMARY KEY (copy_id),

    CONSTRAINT fk_copy_book
        FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    CONSTRAINT chk_copy_status
        CHECK (status IN ('AVAILABLE', 'ISSUED', 'DAMAGED', 'LOST'))
);

SELECT * FROM book_copies;

CREATE TABLE members (
    member_id NUMBER GENERATED ALWAYS AS IDENTITY,
    student_id VARCHAR2(30) UNIQUE NOT NULL,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(15),
    department VARCHAR2(50),
    year_of_study NUMBER(1),
    membership_date DATE DEFAULT SYSDATE,
    membership_status VARCHAR2(20) DEFAULT 'ACTIVE',

    CONSTRAINT pk_members PRIMARY KEY (member_id),

    CONSTRAINT chk_member_status
        CHECK (membership_status IN ('ACTIVE', 'SUSPENDED', 'EXPIRED'))
);

SELECT * FROM members;

CREATE TABLE librarians (
    librarian_id NUMBER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(15),

    CONSTRAINT pk_librarians PRIMARY KEY (librarian_id)
);

SELECT * FROM librarians;

CREATE TABLE suppliers (
    supplier_id NUMBER GENERATED ALWAYS AS IDENTITY,
    supplier_name VARCHAR2(100) NOT NULL,
    phone VARCHAR2(15),
    email VARCHAR2(100),
    address VARCHAR2(200),

    CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id)
);

SELECT * FROM suppliers;

CREATE TABLE acquisitions (
    acquisition_id NUMBER GENERATED ALWAYS AS IDENTITY,
    book_id NUMBER NOT NULL,
    supplier_id NUMBER,
    quantity NUMBER NOT NULL,
    order_date DATE DEFAULT SYSDATE,
    expected_date DATE,
    received_date DATE,
    status VARCHAR2(20) DEFAULT 'ORDERED',

    CONSTRAINT pk_acquisitions PRIMARY KEY (acquisition_id),

    CONSTRAINT fk_acq_book
        FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    CONSTRAINT fk_acq_supplier
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id),

    CONSTRAINT chk_acq_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_acq_status
        CHECK (status IN ('ORDERED', 'RECEIVED', 'CANCELLED'))
);

SELECT * FROM acquisitions;

CREATE TABLE issues (
    issue_id NUMBER GENERATED ALWAYS AS IDENTITY,
    copy_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    librarian_id NUMBER,
    issue_date DATE DEFAULT SYSDATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine NUMBER(10,2) DEFAULT 0,
    status VARCHAR2(20) DEFAULT 'ISSUED',

    CONSTRAINT pk_issues PRIMARY KEY (issue_id),

    CONSTRAINT fk_issue_copy
        FOREIGN KEY (copy_id)
        REFERENCES book_copies(copy_id),

    CONSTRAINT fk_issue_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id),

    CONSTRAINT fk_issue_librarian
        FOREIGN KEY (librarian_id)
        REFERENCES librarians(librarian_id),

    CONSTRAINT chk_issue_status
        CHECK (status IN ('ISSUED', 'RETURNED')),

    CONSTRAINT chk_issue_fine
        CHECK (fine >= 0),

    CONSTRAINT chk_issue_dates
        CHECK (due_date >= issue_date)
);

SELECT * FROM issues;

CREATE TABLE reservations (
    reservation_id NUMBER GENERATED ALWAYS AS IDENTITY,
    book_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    reservation_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'WAITING',

    CONSTRAINT pk_reservations PRIMARY KEY (reservation_id),

    CONSTRAINT fk_res_book
        FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    CONSTRAINT fk_res_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id),

    CONSTRAINT chk_res_status
        CHECK (status IN ('WAITING', 'FULFILLED', 'CANCELLED'))
);

SELECT * FROM reservations;

CREATE TABLE fines (
    fine_id NUMBER GENERATED ALWAYS AS IDENTITY,
    issue_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    fine_amount NUMBER(10,2) NOT NULL,
    paid_amount NUMBER(10,2) DEFAULT 0,
    fine_date DATE DEFAULT SYSDATE,
    payment_status VARCHAR2(20) DEFAULT 'PENDING',

    CONSTRAINT pk_fines PRIMARY KEY (fine_id),

    CONSTRAINT fk_fine_issue
        FOREIGN KEY (issue_id)
        REFERENCES issues(issue_id),

    CONSTRAINT fk_fine_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id),

    CONSTRAINT chk_fine_amount
        CHECK (fine_amount >= 0),

    CONSTRAINT chk_paid_amount
        CHECK (paid_amount >= 0),

    CONSTRAINT chk_payment_status
        CHECK (payment_status IN ('PENDING', 'PARTIAL', 'PAID'))
);

SELECT * FROM fines;

INSERT INTO books
(title, author, isbn, category, publisher, edition, publication_year, language, price)
VALUES
('Database System Concepts','Abraham Silberschatz','ISBN001','DBMS','McGraw Hill','7th',2020,'English',650);

INSERT INTO books
(title, author, isbn, category, publisher, edition, publication_year, language, price)
VALUES
('Java Programming','Herbert Schildt','ISBN002','Programming','McGraw Hill','11th',2021,'English',700);

INSERT INTO books
(title, author, isbn, category, publisher, edition, publication_year, language, price)
VALUES
('Operating System Concepts','Abraham Silberschatz','ISBN003','Operating Systems','Wiley','10th',2018,'English',600);

INSERT INTO books
(title, author, isbn, category, publisher, edition, publication_year, language, price)
VALUES
('Computer Networks','Andrew S. Tanenbaum','ISBN004','Networking','Pearson','6th',2021,'English',750);

INSERT INTO books
(title, author, isbn, category, publisher, edition, publication_year, language, price)
VALUES
('Python Crash Course','Eric Matthes','ISBN005','Programming','No Starch Press','3rd',2023,'English',550);

COMMIT;

SELECT book_id, title, isbn
FROM books
ORDER BY book_id;

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (9, 'DBMS001', 'AVAILABLE', 'SHELF-A1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (9, 'DBMS002', 'AVAILABLE', 'SHELF-A1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (9, 'DBMS003', 'AVAILABLE', 'SHELF-A1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (10, 'JAVA001', 'AVAILABLE', 'SHELF-B1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (10, 'JAVA002', 'AVAILABLE', 'SHELF-B1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (10, 'JAVA003', 'AVAILABLE', 'SHELF-B1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (11, 'OS001', 'AVAILABLE', 'SHELF-C1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (11, 'OS002', 'AVAILABLE', 'SHELF-C1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (11, 'OS003', 'AVAILABLE', 'SHELF-C1');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (12, 'NET001', 'AVAILABLE', 'SHELF-C2');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (12, 'NET002', 'AVAILABLE', 'SHELF-C2');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (12, 'NET003', 'AVAILABLE', 'SHELF-C2');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (13, 'PY001', 'AVAILABLE', 'SHELF-B2');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (13, 'PY002', 'AVAILABLE', 'SHELF-B2');

INSERT INTO book_copies (book_id, accession_no, status, shelf)
VALUES (13, 'PY003', 'AVAILABLE', 'SHELF-B2');

COMMIT;

SELECT copy_id, book_id, accession_no, status, shelf
FROM book_copies
ORDER BY copy_id;

INSERT INTO members
(student_id, name, email, phone, department, year_of_study, membership_status)
VALUES
('STU001', 'Ravi Kumar', 'ravi@gmail.com', '9876543210', 'CSE', 3, 'ACTIVE');

INSERT INTO members
(student_id, name, email, phone, department, year_of_study, membership_status)
VALUES
('STU002', 'Kiran Kumar', 'kiran@gmail.com', '9876543211', 'CSE', 2, 'ACTIVE');

INSERT INTO members
(student_id, name, email, phone, department, year_of_study, membership_status)
VALUES
('STU003', 'Suresh Kumar', 'suresh@gmail.com', '9876543212', 'ECE', 3, 'ACTIVE');

COMMIT;

SELECT member_id, student_id, name, department, year_of_study, membership_status
FROM members
ORDER BY member_id;

INSERT INTO librarians
(name, email, phone)
VALUES
('Anil Kumar', 'anil@library.com', '9876543220');

COMMIT;

SELECT librarian_id, name, email, phone
FROM librarians;

INSERT INTO suppliers
(supplier_name, phone, email, address)
VALUES
('ABC Book Suppliers',
 '9876543230',
 'abcbooks@gmail.com',
 'Kakinada, Andhra Pradesh');

COMMIT;

SELECT supplier_id, supplier_name, phone, email, address
FROM suppliers;

INSERT INTO acquisitions
(book_id, supplier_id, quantity, order_date, expected_date, status)
VALUES
(10, 1, 5, SYSDATE, DATE '2026-10-15', 'ORDERED');

COMMIT;

SELECT acquisition_id,
       book_id,
       supplier_id,
       quantity,
       order_date,
       expected_date,
       status
FROM acquisitions;

INSERT INTO issues
(copy_id, member_id, librarian_id, issue_date, due_date, status)
VALUES
(13, 1, 1, SYSDATE, SYSDATE + 14, 'ISSUED');

COMMIT;

UPDATE book_copies
SET status = 'ISSUED'
WHERE copy_id = 13;

COMMIT;

SELECT issue_id,
       copy_id,
       member_id,
       librarian_id,
       issue_date,
       due_date,
       return_date,
       fine,
       status
FROM issues;

SELECT copy_id, accession_no, status
FROM book_copies
WHERE copy_id = 13;

INSERT INTO reservations
(book_id, member_id, reservation_date, status)
VALUES
(10, 2, SYSDATE, 'WAITING');

COMMIT;

SELECT reservation_id,
       book_id,
       member_id,
       reservation_date,
       status
FROM reservations;

SELECT issue_id, copy_id, member_id, due_date, status
FROM issues
ORDER BY issue_id;

DELETE FROM issues
WHERE issue_id IN (1, 2);

COMMIT;

UPDATE book_copies
SET status = 'AVAILABLE'
WHERE copy_id = 13;

COMMIT;

SELECT issue_id, copy_id, member_id, due_date, status
FROM issues;

SELECT copy_id, accession_no, status
FROM book_copies
WHERE copy_id = 13;

INSERT INTO issues
(copy_id, member_id, librarian_id, issue_date, due_date, status)
VALUES
(13, 1, 1, SYSDATE, SYSDATE + 14, 'ISSUED');

COMMIT;

UPDATE book_copies
SET status = 'ISSUED'
WHERE copy_id = 13;

COMMIT;

SELECT issue_id, copy_id, member_id, issue_date, due_date, status
FROM issues;

INSERT INTO fines
(issue_id, member_id, fine_amount, paid_amount, payment_status)
VALUES
(3, 1, 0, 0, 'PAID');

COMMIT;

SELECT fine_id,
       issue_id,
       member_id,
       fine_amount,
       paid_amount,
       fine_date,
       payment_status
FROM fines;

SELECT COUNT(*) AS total_books
FROM books;

SELECT COUNT(*) AS total_copies
FROM book_copies;

SELECT COUNT(*) AS available_copies
FROM book_copies
WHERE status = 'AVAILABLE';

SELECT COUNT(*) AS issued_copies
FROM book_copies
WHERE status = 'ISSUED';

SELECT
    i.issue_id,
    b.title,
    bc.accession_no,
    m.name AS member_name,
    i.issue_date,
    i.due_date,
    i.status
FROM issues i
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
JOIN members m
    ON i.member_id = m.member_id
WHERE i.status = 'ISSUED';

SELECT
    i.issue_id,
    b.title,
    m.name AS member_name,
    i.issue_date,
    i.due_date,
    TRUNC(SYSDATE) - TRUNC(i.due_date) AS days_overdue
FROM issues i
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
JOIN members m
    ON i.member_id = m.member_id
WHERE i.status = 'ISSUED'
  AND i.due_date < SYSDATE;
  
  SELECT
    i.issue_id,
    b.title,
    m.name AS member_name,
    i.due_date,
    TRUNC(SYSDATE) - TRUNC(i.due_date) AS days_overdue,
    (TRUNC(SYSDATE) - TRUNC(i.due_date)) * 5 AS calculated_fine
FROM issues i
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
JOIN members m
    ON i.member_id = m.member_id
WHERE i.status = 'ISSUED'
  AND i.due_date < SYSDATE;
  
  UPDATE issues
SET return_date = SYSDATE,
    status = 'RETURNED'
WHERE issue_id = 3;

COMMIT;

UPDATE book_copies
SET status = 'AVAILABLE'
WHERE copy_id = 13;

COMMIT;

SELECT
    i.issue_id,
    b.title,
    bc.accession_no,
    m.name AS member_name,
    i.issue_date,
    i.due_date,
    i.return_date,
    i.status,
    bc.status AS copy_status
FROM issues i
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
JOIN members m
    ON i.member_id = m.member_id
WHERE i.issue_id = 3;

SELECT
    m.name AS member_name,
    b.title,
    bc.accession_no,
    i.issue_date,
    i.due_date,
    i.return_date,
    i.status,
    i.fine
FROM members m
JOIN issues i
    ON m.member_id = i.member_id
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
WHERE m.member_id = 1
ORDER BY i.issue_date DESC;

SELECT
    b.title,
    COUNT(bc.copy_id) AS total_copies,
    SUM(CASE WHEN bc.status = 'AVAILABLE' THEN 1 ELSE 0 END) AS available_copies,
    SUM(CASE WHEN bc.status = 'ISSUED' THEN 1 ELSE 0 END) AS issued_copies
FROM books b
LEFT JOIN book_copies bc
    ON b.book_id = bc.book_id
GROUP BY b.book_id, b.title
ORDER BY b.title;

SELECT
    r.reservation_id,
    b.title,
    m.name AS member_name,
    r.reservation_date,
    r.status
FROM reservations r
JOIN books b
    ON r.book_id = b.book_id
JOIN members m
    ON r.member_id = m.member_id
WHERE r.status = 'WAITING'
ORDER BY r.reservation_date;

SELECT
    a.acquisition_id,
    b.title,
    s.supplier_name,
    a.quantity,
    a.order_date,
    a.expected_date,
    a.status
FROM acquisitions a
JOIN books b
    ON a.book_id = b.book_id
LEFT JOIN suppliers s
    ON a.supplier_id = s.supplier_id
ORDER BY a.expected_date;

INSERT INTO issues
(copy_id, member_id, librarian_id, issue_date, due_date, status)
VALUES
(13, 1, 1, DATE '2026-09-10', DATE '2026-09-20', 'ISSUED');

COMMIT;

UPDATE book_copies
SET status = 'ISSUED'
WHERE copy_id = 13;

COMMIT;

SELECT
    issue_id,
    copy_id,
    member_id,
    issue_date,
    due_date,
    status
FROM issues
WHERE status = 'ISSUED';

INSERT INTO fines
(issue_id, member_id, fine_amount, paid_amount, payment_status)
VALUES
(4, 1, 35, 0, 'PENDING');

COMMIT;

SELECT
    fine_id,
    issue_id,
    member_id,
    fine_amount,
    paid_amount,
    fine_date,
    payment_status
FROM fines
ORDER BY fine_id;

UPDATE fines
SET paid_amount = 35,
    payment_status = 'PAID'
WHERE fine_id = 2;

COMMIT;

SELECT
    fine_id,
    issue_id,
    member_id,
    fine_amount,
    paid_amount,
    payment_status
FROM fines
ORDER BY fine_id;

CREATE OR REPLACE VIEW available_books AS
SELECT
    b.book_id,
    b.title,
    b.author,
    bc.copy_id,
    bc.accession_no,
    bc.shelf
FROM books b
JOIN book_copies bc
    ON b.book_id = bc.book_id
WHERE bc.status = 'AVAILABLE';

SELECT *
FROM available_books
ORDER BY title, copy_id;

CREATE OR REPLACE VIEW current_issues AS
SELECT
    i.issue_id,
    b.title,
    bc.accession_no,
    m.name AS member_name,
    l.name AS librarian_name,
    i.issue_date,
    i.due_date,
    i.status
FROM issues i
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
JOIN members m
    ON i.member_id = m.member_id
LEFT JOIN librarians l
    ON i.librarian_id = l.librarian_id
WHERE i.status = 'ISSUED';

SELECT *
FROM current_issues
ORDER BY due_date;

CREATE OR REPLACE VIEW overdue_books AS
SELECT
    i.issue_id,
    b.title,
    bc.accession_no,
    m.name AS member_name,
    i.due_date,
    TRUNC(SYSDATE) - TRUNC(i.due_date) AS days_overdue,
    (TRUNC(SYSDATE) - TRUNC(i.due_date)) * 5 AS calculated_fine
FROM issues i
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id
JOIN members m
    ON i.member_id = m.member_id
WHERE i.status = 'ISSUED'
  AND i.due_date < SYSDATE;
  
  SELECT *
FROM overdue_books
ORDER BY days_overdue DESC;

CREATE OR REPLACE VIEW member_history AS
SELECT
    m.member_id,
    m.name AS member_name,
    b.title,
    bc.accession_no,
    i.issue_date,
    i.due_date,
    i.return_date,
    i.status,
    i.fine
FROM members m
JOIN issues i
    ON m.member_id = i.member_id
JOIN book_copies bc
    ON i.copy_id = bc.copy_id
JOIN books b
    ON bc.book_id = b.book_id;
    
    SELECT *
FROM member_history
ORDER BY member_id, issue_date DESC;

CREATE OR REPLACE VIEW upcoming_acquisitions AS
SELECT
    a.acquisition_id,
    b.title,
    s.supplier_name,
    a.quantity,
    a.order_date,
    a.expected_date,
    a.status
FROM acquisitions a
JOIN books b
    ON a.book_id = b.book_id
LEFT JOIN suppliers s
    ON a.supplier_id = s.supplier_id
WHERE a.status = 'ORDERED'
ORDER BY a.expected_date;

SELECT *
FROM upcoming_acquisitions;

SELECT
    (SELECT COUNT(*) FROM books) AS total_books,
    (SELECT COUNT(*) FROM book_copies) AS total_copies,
    (SELECT COUNT(*) FROM book_copies WHERE status = 'AVAILABLE') AS available_copies,
    (SELECT COUNT(*) FROM book_copies WHERE status = 'ISSUED') AS issued_copies,
    (SELECT COUNT(*) FROM members) AS total_members,
    (SELECT COUNT(*) FROM suppliers) AS total_suppliers
FROM dual;

SELECT
    m.name AS member_name,
    COUNT(f.fine_id) AS total_fines,
    NVL(SUM(f.fine_amount), 0) AS total_fine_amount,
    NVL(SUM(f.paid_amount), 0) AS total_paid,
    NVL(SUM(f.fine_amount - f.paid_amount), 0) AS outstanding_amount
FROM members m
LEFT JOIN fines f
    ON m.member_id = f.member_id
GROUP BY m.member_id, m.name
ORDER BY m.name;

SELECT
    b.title,
    COUNT(i.issue_id) AS times_borrowed
FROM books b
JOIN book_copies bc
    ON b.book_id = bc.book_id
JOIN issues i
    ON bc.copy_id = i.copy_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC;

SELECT
    category,
    COUNT(*) AS number_of_books,
    SUM(price) AS total_book_value
FROM books
GROUP BY category
ORDER BY category;

SELECT
    shelf,
    COUNT(*) AS total_copies,
    SUM(CASE WHEN status = 'AVAILABLE' THEN 1 ELSE 0 END) AS available_copies,
    SUM(CASE WHEN status = 'ISSUED' THEN 1 ELSE 0 END) AS issued_copies
FROM book_copies
GROUP BY shelf
ORDER BY shelf;