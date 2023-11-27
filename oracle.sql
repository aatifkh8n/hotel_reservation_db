-- DROP DATABASE IF EXISTS salama_db;
-- CREATE DATABASE salama_db;
-- USE salama_db;

-----------------------------------------------------------
-- CREATING ALL TABLES
-----------------------------------------------------------

CREATE TABLE guests (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    name VARCHAR(20) NOT NULL, -- REQUIRED
    address VARCHAR(150) NOT NULL -- REQUIRED
);

CREATE TABLE reservations (
    num NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    guest_id NUMBER NOT NULL, -- REQUIRED
    approved NUMBER DEFAULT 0
);

CREATE TABLE ids (
    num NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    guest_id NUMBER NOT NULL UNIQUE -- ENSURE/VALIDATE THE ONE-TO-ONE RELAIONSHIP -- REQUIRED -- DUPLICATE NOT ALLOWED
);

CREATE TABLE feedbacks (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    guest_id NUMBER NOT NULL, -- REQUIRED
    reservation_num NUMBER NOT NULL, -- REQUIRED
    content VARCHAR(100),
    rating FLOAT,
    CHECK (rating >= 0 AND rating <= 5) -- CHECK CONSTRAINT
);

CREATE TABLE rooms (
    num NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    guest_id NUMBER NOT NULL, -- REQUIRED
    reservation_num NUMBER, 
    dimension VARCHAR(100),
    no_of_bed NUMBER
);

CREATE TABLE wishlists (
    id NUMBER PRIMARY KEY -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
);

CREATE TABLE hosts (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    name VARCHAR(50) NOT NULL, -- REQUIRED
    age FLOAT,
    CHECK (age >= 0 AND age <=200) -- CHECK CONSTRAINT
);

CREATE TABLE bookings (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    host_id NUMBER NOT NULL, -- REQUIRED
    details VARCHAR(300),
    review VARCHAR(200)
);

CREATE TABLE directions (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    orders VARCHAR(100),
    responsibilities VARCHAR(300)
);

CREATE TABLE lists (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    nightly_rate FLOAT DEFAULT 20.0
);

CREATE TABLE dashboards (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    options VARCHAR(300),
    privileges VARCHAR(300)
);

-----------------------------------------------------------
-- EXTRA NORMALIZED TABLES
-----------------------------------------------------------

CREATE TABLE items (
    id NUMBER PRIMARY KEY, -- REQUIRED -- DUPLICATE NOT ALLOWED -- PK
    name VARCHAR(50) NOT NULL -- REQUIRED
);

-----------------------------------------------------------
-- DEFINING FOREIGN KEY CONSTRAINTS
-- 
-- ONE-TO-MANY RELATIONSHIPS
-----------------------------------------------------------

-- FK(guest, reservations)
ALTER TABLE reservations ADD CONSTRAINT FK_guest_reservations FOREIGN KEY (guest_id) REFERENCES guests(id);

-- FK(guest, ids)
ALTER TABLE ids ADD CONSTRAINT FK_guest_ids FOREIGN KEY (guest_id) REFERENCES guests(id);

-- FK(guest, feedbacks)
ALTER TABLE feedbacks ADD CONSTRAINT FK_guest_feedbacks FOREIGN KEY (guest_id) REFERENCES guests(id);

-- FK(reservation, feedbacks)
ALTER TABLE feedbacks ADD CONSTRAINT FK_reservation_feedbacks FOREIGN KEY (reservation_num) REFERENCES reservations(num);

-- FK(guest, rooms)
ALTER TABLE rooms ADD CONSTRAINT FK_guest_rooms FOREIGN KEY (guest_id) REFERENCES guests(id);

-- FK(reservation, rooms)
ALTER TABLE rooms ADD CONSTRAINT FK_reservation_rooms FOREIGN KEY (reservation_num) REFERENCES reservations(num);

-- FK(host, bookings)
ALTER TABLE bookings ADD CONSTRAINT FK_host_bookings FOREIGN KEY (host_id) REFERENCES hosts(id);

---------------------------------------------------
-- DEFINING EXTRA TABLES
-- 
-- MANY-TO-MANY RELATIONSHIPS
-----------------------------------------------------------

-- MANY-TO-MANY(guest, wishlist) -- wishlist of guest
CREATE TABLE guest_wishlist (
    guest_id NUMBER NOT NULL, -- REQUIRED
    wishlist_id NUMBER,
    CONSTRAINT FK_guest_wishlist_guest FOREIGN KEY (guest_id) REFERENCES guests(id),
    CONSTRAINT FK_guest_wishlist_wishlist FOREIGN KEY (wishlist_id) REFERENCES wishlists(id)
);

-- MANY-TO-MANY(host, guest) -- guest of host
CREATE TABLE host_guest (
    host_id NUMBER NOT NULL, -- REQUIRED
    guest_id NUMBER,
    CONSTRAINT FK_guest_host_host FOREIGN KEY (host_id) REFERENCES hosts(id),
    CONSTRAINT FK_guest_host_guest FOREIGN KEY (guest_id) REFERENCES guests(id)
);

-- MANY-TO-MANY(host, list) -- list of host
CREATE TABLE host_list (
    host_id NUMBER NOT NULL, -- REQUIRED
    list_id NUMBER,
    CONSTRAINT FK_list_host_host FOREIGN KEY (host_id) REFERENCES hosts(id),
    CONSTRAINT FK_list_host_list FOREIGN KEY (list_id) REFERENCES lists(id)
);

-- MANY-TO-MANY(host, dashboard) -- dashboard of host
CREATE TABLE host_dashboard (
    host_id NUMBER NOT NULL, -- REQUIRED
    dashboard_id NUMBER,
    CONSTRAINT FK_dashboard_host_host FOREIGN KEY (host_id) REFERENCES hosts(id),
    CONSTRAINT FK_dashboard_host_dashboard FOREIGN KEY (dashboard_id) REFERENCES dashboards(id)
);

-- EXTRA TABLE MANY-TO-MANY(list, item) RELATIONSHIPS -- item of list
CREATE TABLE list_item (
    list_id NUMBER NOT NULL, -- REQUIRED
    item_id NUMBER NOT NULL, -- REQUIRED
    CONSTRAINT FK_list_item_list FOREIGN KEY (list_id) REFERENCES lists(id),
    CONSTRAINT FK_list_item_item FOREIGN KEY (item_id) REFERENCES items(id)
);

-- EXTRA TABLE MANY-TO-MANY(wishlist, item) RELATIONSHIPS -- item of wishlist
CREATE TABLE wishlist_item (
    wishlist_id NUMBER NOT NULL, -- REQUIRED
    item_id NUMBER NOT NULL, -- REQUIRED
    CONSTRAINT FK_wishlist_item_wishlist FOREIGN KEY (wishlist_id) REFERENCES wishlists(id),
    CONSTRAINT FK_wishlist_item_item FOREIGN KEY (item_id) REFERENCES items(id)
);

-----------------------------------------------------------
-- DESCRIBING ALL TABLES
-----------------------------------------------------------

-- DESCRIBE guests;
-- DESCRIBE reservations;
-- DESCRIBE ids;
-- DESCRIBE feedbacks;
-- DESCRIBE rooms;
-- DESCRIBE wishlists;
-- DESCRIBE hosts;
-- DESCRIBE bookings;
-- DESCRIBE directions;
-- DESCRIBE lists;
-- DESCRIBE dashboards;

-- DESCRIBE guest_wishlist;
-- DESCRIBE host_guest;
-- DESCRIBE host_list;
-- DESCRIBE host_dashboard;

-----------------------------------------------------------
-- INSERTING RECORDS INTO TABLES
-----------------------------------------------------------

-- POPULATING GUESTS
INSERT INTO guests VALUES (1, 'guest1', 'UAE');
INSERT INTO guests VALUES (2, 'guest2', 'UAE');
INSERT INTO guests VALUES (3, 'guest3', 'UAE');
INSERT INTO guests VALUES (4, 'guest4', 'UAE');
INSERT INTO guests VALUES (5, 'guest5', 'UAE');
INSERT INTO guests VALUES (6, 'guest6', 'UAE');

-- POPULATING WISHLISTS
INSERT INTO wishlists VALUES (1);
INSERT INTO wishlists VALUES (2);
INSERT INTO wishlists VALUES (3);
INSERT INTO wishlists VALUES (4);

-- POPULATING HOSTS
INSERT INTO hosts VALUES (1, 'host1', 1);
INSERT INTO hosts VALUES (2, 'host2', 2);
INSERT INTO hosts VALUES (3, 'host3', 3);
INSERT INTO hosts VALUES (4, 'host4', 4);
INSERT INTO hosts VALUES (5, 'host5', 5);

-- POPULATING DIRECTIONS
INSERT INTO directions VALUES (1, 'Clean and Rearrange', 'Clean, Rearrange');
INSERT INTO directions VALUES (2, 'Repair door, Clean and Rearrange', 'Repair, Clean, Rearrange');
INSERT INTO directions VALUES (3, null, null);
INSERT INTO directions (id, responsibilities) VALUES (4, 'Repair, Rearrange');

-- POPULATING LISTS
INSERT INTO lists VALUES (1, 30);
INSERT INTO lists VALUES (2, 15);
INSERT INTO lists VALUES (3, 25);
INSERT INTO lists (id) VALUES (4);

-- POPULATING DASHBOARDS
INSERT INTO dashboards VALUES (1, 'Hosts, Guests, Bookings, Orders, Lists, Wishlists', 'Admin');
INSERT INTO dashboards VALUES (2, 'Bookings, Orders, Lists, Wishlists', 'Guest');
INSERT INTO dashboards VALUES (3, 'Hosts, Bookings, Orders, Lists, Wishlists', 'Host');
INSERT INTO dashboards (id, options) VALUES (4, 'Hosts, Bookings, Orders, Lists, Wishlists');
INSERT INTO dashboards (id, privileges) VALUES (5, 'Guest');

-- POPULATING EXTRA TABLES
-- POPULATING ITEMS
INSERT INTO items VALUES (1, 'item1');
INSERT INTO items VALUES (2, 'item2');
INSERT INTO items VALUES (3, 'item3');
INSERT INTO items VALUES (4, 'item4');
INSERT INTO items VALUES (5, 'item5');
INSERT INTO items VALUES (6, 'item6');
INSERT INTO items VALUES (7, 'item7');
INSERT INTO items VALUES (8, 'item8');
INSERT INTO items VALUES (9, 'item9');
INSERT INTO items VALUES (10, 'item10');

-- LINKING WISHLISTS TO GUESTS
INSERT INTO guest_wishlist VALUES (1, 4);
INSERT INTO guest_wishlist VALUES (2, 2);
INSERT INTO guest_wishlist VALUES (2, 3);
INSERT INTO guest_wishlist VALUES (2, 4);
INSERT INTO guest_wishlist VALUES (3, 1);
INSERT INTO guest_wishlist VALUES (4, 4);
INSERT INTO guest_wishlist VALUES (5, 1);
INSERT INTO guest_wishlist VALUES (5, 2);
INSERT INTO guest_wishlist VALUES (5, 4);
INSERT INTO guest_wishlist VALUES (6, 2);
INSERT INTO guest_wishlist VALUES (6, 3);
INSERT INTO guest_wishlist VALUES (6, 4);

-- LINKING GUESTS TO HOSTS
INSERT INTO host_guest VALUES (1, 2);
INSERT INTO host_guest VALUES (1, 3);
INSERT INTO host_guest VALUES (2, 3);
INSERT INTO host_guest VALUES (2, 5);
INSERT INTO host_guest VALUES (2, 6);
INSERT INTO host_guest VALUES (3, 1);
INSERT INTO host_guest VALUES (4, 1);
INSERT INTO host_guest VALUES (4, 4);
INSERT INTO host_guest VALUES (4, 5);
INSERT INTO host_guest VALUES (5, 6);

-- LINKING LISTS TO HOSTS
INSERT INTO host_list VALUES (1, 1);
INSERT INTO host_list VALUES (1, 3);
INSERT INTO host_list VALUES (1, 4);
INSERT INTO host_list VALUES (2, 2);
INSERT INTO host_list VALUES (2, 4);
INSERT INTO host_list VALUES (3, 1);
INSERT INTO host_list VALUES (4, 2);
INSERT INTO host_list VALUES (5, 1);
INSERT INTO host_list VALUES (5, 3);

-- LINKING EXTRA TABLES
-- LINKING ITEMS TO WISHLISTS
INSERT INTO wishlist_item VALUES (1, 1);
INSERT INTO wishlist_item VALUES (1, 3);
INSERT INTO wishlist_item VALUES (2, 5);
INSERT INTO wishlist_item VALUES (3, 2);
INSERT INTO wishlist_item VALUES (4, 3);

-- LINKING ITEMS TO LISTS
INSERT INTO list_item VALUES (1, 10);
INSERT INTO list_item VALUES (1, 8);
INSERT INTO list_item VALUES (2, 5);
INSERT INTO list_item VALUES (3, 6);
INSERT INTO list_item VALUES (4, 3);

-- CREATING BOOKINGS FOR HOST
INSERT INTO bookings VALUES (1, 2, 'first booking', 'mid');
INSERT INTO bookings VALUES (2, 1, null, null);
INSERT INTO bookings VALUES (3, 1, 'booking', 'N/A');
INSERT INTO bookings VALUES (4, 3, 'rooms with a kitchen', 'positive');
INSERT INTO bookings VALUES (5, 4, 'top floor', null);

-- CREATING RESERVATIONS FOR GUEST
INSERT INTO reservations (num, guest_id) VALUES (1, 2);
INSERT INTO reservations (num, guest_id) VALUES (2, 2);
INSERT INTO reservations (num, guest_id) VALUES (3, 1);
INSERT INTO reservations (num, guest_id) VALUES (4, 2);
INSERT INTO reservations VALUES (5, 3, 1);
INSERT INTO reservations (num, guest_id) VALUES (6, 5);
INSERT INTO reservations VALUES (7, 4, 0);
INSERT INTO reservations (num, guest_id) VALUES (8, 3);
INSERT INTO reservations VALUES (9, 1, 1);
INSERT INTO reservations VALUES (10, 2, 1);

-- CREATING IDS FOR GUEST
INSERT INTO ids VALUES (1, 1);
INSERT INTO ids VALUES (2, 2);
INSERT INTO ids VALUES (3, 3);
INSERT INTO ids VALUES (4, 4);
INSERT INTO ids VALUES (5, 5);

-- CREATING FEEDBACKS FOR GUEST
INSERT INTO feedbacks VALUES (1, 2, 1, 'feedback1', 4.0);
INSERT INTO feedbacks VALUES (2, 2, 3, 'feedback2', 4.8);
INSERT INTO feedbacks (id, guest_id, reservation_num) VALUES (3, 1, 3);
INSERT INTO feedbacks VALUES (4, 2, 3, 'feedback4', 4.0);
INSERT INTO feedbacks VALUES (5, 3, 2, 'feedback5', 4.5);
INSERT INTO feedbacks VALUES (6, 5, 4, 'feedback6', 3.9);

-- CREATING ROOMS FOR GUEST
INSERT INTO rooms (num, guest_id)   VALUES (1, 2);
INSERT INTO rooms                   VALUES (2, 2, 1, '100x80 ft', 4);
INSERT INTO rooms (num, guest_id)   VALUES (3, 1);
INSERT INTO rooms                   VALUES (4, 2, 3, '80x60 ft', 2);
INSERT INTO rooms (num, guest_id)   VALUES (5, 3);

-----------------------------------------------------------
-- DISPLAYING RECORD OF ALL TABLES
-----------------------------------------------------------

-- SELECT * FROM guests;
-- SELECT * FROM reservations;
-- SELECT * FROM ids;
-- SELECT * FROM feedbacks;
-- SELECT * FROM rooms;
-- SELECT * FROM wishlists;
-- SELECT * FROM hosts;
-- SELECT * FROM bookings;
-- SELECT * FROM directions;
-- SELECT * FROM lists;
-- SELECT * FROM dashboards;

-- SELECT * FROM guest_wishlist;
-- SELECT * FROM host_guest;
-- SELECT * FROM host_list;
-- SELECT * FROM host_dashboard;


-----------------------------------------------------------
-------------------- Q U E S T I O N S --------------------
-----------------------------------------------------------


-----------------------------------------------------------
-- Q # 1
-- 
-- How many listings are made by all homeowners?
-----------------------------------------------------------

-- calculate the total number of listings made by all homeowners
-- SELECT COUNT(*)
-- AS total_listings_by_homeowners
-- FROM host_list;

SELECT host_id, COUNT(list_id)
AS no_of_listings
FROM host_list
GROUP BY host_id;

-----------------------------------------------------------
-- Q # 2
-- 
-- How many bookings are made by all customers?
-----------------------------------------------------------

-- If we want to get the number of bookings for each individual customer, we can use the following query:
-- SELECT guest_id, COUNT(*)
-- AS total_bookings
-- FROM reservations
-- GROUP BY guest_id;

-- If we want to sum up the total number of bookings made by all customers (guests), we can aggregate the counts for all customers:
-- SELECT SUM(total_bookings)
-- AS total_bookings_by_customers
-- FROM (
--     SELECT guest_id, COUNT(*)
--     AS total_bookings
--     FROM reservations
--     GROUP BY guest_id
-- ) AS bookings_per_customer;

SELECT host_id, COUNT(id)
AS no_of_bookings
FROM bookings
GROUP BY host_id;

-----------------------------------------------------------
-- Q # 3
-- 
-- What is the highest nightly rate set by homeowners for their listings?
-----------------------------------------------------------

-- query to fetch the highest nightly rate set by homeowners
-- SELECT MAX(nightly_rate)
-- AS highest_nightly_rate
-- FROM lists;

SELECT a.host_id, MAX(b.nightly_rate)
AS highest_nightly_rate
FROM host_list a
LEFT JOIN lists b
ON a.list_id = b.id
GROUP BY a.host_id;

-----------------------------------------------------------
-- Q # 4
-- 
-- What is the lowest nightly rate set by homeowners for their listings?
-----------------------------------------------------------

-- retrieve the minimum value from the nightly_rate column in the lists table
-- SELECT MIN(nightly_rate)
-- AS lowest_nightly_rate
-- FROM lists;

SELECT a.host_id, MIN(b.nightly_rate)
AS lowest_nightly_rate
FROM host_list a
LEFT JOIN lists b
ON a.list_id = b.id
GROUP BY a.host_id;

-----------------------------------------------------------
-- Q # 5
-- 
-- How many unique customers have booked the listings of each homeowner?
-----------------------------------------------------------

SELECT a.host_id, COUNT(DISTINCT b.guest_id)
AS no_of_unique_customers_who_did_bookings
FROM host_guest a
LEFT JOIN reservations b
ON a.guest_id = b.guest_id
GROUP BY a.host_id;

-----------------------------------------------------------
-- Q # 6
-- 
-- Which listings have received the most number of booking requests?
-- number of Booking requests = number of Wish Lists by all Guests
-----------------------------------------------------------

-- query to find the listings that have received the most booking requests
SELECT guest_id, MAX(booking_requests) AS max_booking_requests
FROM (
    SELECT guest_id, COUNT(*) AS booking_requests
    FROM rooms
    WHERE reservation_num IS NOT NULL
    GROUP BY guest_id
) booking_requests_table
GROUP BY guest_id;

-----------------------------------------------------------
-- Q # 7
-- 
-- Which listings have the most number of reviews?
-----------------------------------------------------------

-- query to identify the listings with the most reviews
SELECT guest_id, MAX(review_count) AS most_review
FROM (
    SELECT guest_id, COUNT(*) AS review_count
    FROM feedbacks
    WHERE guest_id IS NOT NULL
    GROUP BY guest_id
) review_count_table
GROUP BY guest_id;
-----------------------------------------------------------
-- Q # 8
-- 
-- Which listings have the least number of reviews?
-----------------------------------------------------------

-- query to identify the listings with the least reviews
SELECT guest_id, MIN(review_count) AS lowest_review
FROM (
    SELECT guest_id, COUNT(*) AS review_count
    FROM feedbacks
    WHERE guest_id IS NOT NULL
    GROUP BY guest_id
) review_count_table
GROUP BY guest_id;

-----------------------------------------------------------
-- Q # 9
-- 
-- What is the most common rating received by homeowners from customers?
-----------------------------------------------------------

-- query to identify the most common rating received by homeowners

SELECT rating, MAX(rating_count) AS highest_rating
FROM (
    SELECT fb.rating AS rating, COUNT(*) AS rating_count
    FROM feedbacks fb
    JOIN rooms r ON fb.guest_id = r.guest_id AND fb.reservation_num = r.reservation_num
    GROUP BY fb.rating
) rating_count_table
GROUP BY rating;

-----------------------------------------------------------
-- Q # 10
-- 
-- How many unique hosts' listings have customers booked?
-----------------------------------------------------------

SELECT a.host_id, COUNT(DISTINCT b.list_id)
AS no_of_unique_customers_who_did_bookings
FROM host_guest a
LEFT JOIN host_list b
ON a.host_id = b.host_id
GROUP BY a.host_id;

-----------------------------------------------------------
-- Q # 11
-- 
-- What are the lowest price paid by customers for a booking?
-----------------------------------------------------------

SELECT host_id, MIN(lowest_price) AS lowest_price_by_customer
FROM (
    SELECT hl.host_id AS host_id, MIN(l.nightly_rate) AS lowest_price
    FROM lists l
    JOIN host_list hl ON l.id = hl.list_id
    GROUP BY hl.host_id
) lowest_price_table
GROUP BY host_id;

-----------------------------------------------------------
-- Q # 12
-- 
-- How many listings have customers reviewed and rated?
-----------------------------------------------------------

SELECT COUNT(DISTINCT guest_id)
AS no_of_listings_reviewed_and_rated
FROM feedbacks
WHERE (content IS NOT NULL AND rating IS NOT NULL);

-----------------------------------------------------------
-- Q # 13
-- 
-- What is the most common rating given by customers to hosts?
-----------------------------------------------------------

SELECT rating, COUNT(*) AS rating_count
FROM feedbacks
GROUP BY rating
ORDER BY rating_count DESC;

-----------------------------------------------------------
-- Q # 14
-- 
-- How many wish lists have customers created and how many listings are in each wish list?
-----------------------------------------------------------

-- query to find the number of wish lists created by customers and the count of listings within each wish list
-- SELECT wl.wishlist_id, COUNT(wi.item_id) AS number_of_listings
-- FROM wishlist_item wi
-- INNER JOIN wishlists wl ON wi.wishlist_id = wl.id
-- GROUP BY wl.wishlist_id;

SELECT guest_id, COUNT(wishlist_id)
AS no_of_wish_lists_per_guest
FROM guest_wishlist
GROUP BY guest_id;

SELECT wishlist_id, COUNT(item_id)
AS no_of_listings_per_wish_list
FROM wishlist_item
GROUP BY wishlist_id;

-----------------------------------------------------------
-- Q # 15
-- 
-- How many times have customers cancelled?
-----------------------------------------------------------

SELECT COUNT(*) AS cancelled_count
FROM reservations
WHERE approved = 0;

-----------------------------------------------------------
-- Q # 16
-- 
-- Which homeowners have the most number of listings?
-----------------------------------------------------------

-- SELECT host_id, COUNT(list_id) AS number_of_listings
-- FROM host_list
-- GROUP BY host_id
-- ORDER BY COUNT(list_id) DESC
-- LIMIT 1;

SELECT id, name, MAX(no_of_listings) AS most_no_of_listings
FROM (
    SELECT a.id AS id, a.name AS name, COUNT(b.list_id) AS no_of_listings
    FROM hosts a
    LEFT JOIN host_list b
    ON a.id = b.host_id
    GROUP BY a.id, a.name
) no_of_listings_table
GROUP BY id, name;

-----------------------------------------------------------
-- Q # 17
-- 
-- What is the average number of bookings made by customers?
-----------------------------------------------------------

SELECT guest_id, AVG(booking_count) AS average_bookings_per_customer
FROM (
    SELECT guest_id, COUNT(num) AS booking_count
    FROM reservations
    GROUP BY guest_id
) bookings_per_customer
GROUP BY guest_id;

-----------------------------------------------------------
-- Q # 18
-- 
-- Which homeowner has the least number of bookings?
-----------------------------------------------------------

SELECT host_id, MIN(booking_count) AS least_bookings
FROM (
    SELECT host_id, COUNT(id) AS booking_count
    FROM bookings
    GROUP BY host_id
) booking_count_table
GROUP BY host_id;

-----------------------------------------------------------
-- Q # 19
-- 
-- How many times have homeowners accepted booking requests?
-----------------------------------------------------------

SELECT COUNT(*) AS accepted_count
FROM reservations
WHERE approved = 1;

-----------------------------------------------------------
-- Q # 20
-- 
-- How many listings have customers not reviewed or rated?
-----------------------------------------------------------

SELECT COUNT(id)
AS no_of_listings_not_reviewed_or_rated
FROM feedbacks
WHERE (content IS NULL OR rating IS NULL);