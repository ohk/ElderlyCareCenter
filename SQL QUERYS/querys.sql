-- Get Rooms
SELECT * FROM room ORDER BY id

-- Get Elders
SELECT * FROM elder_view ORDER BY id

-- Get Visitors
SELECT * FROM visitor ORDER BY id

-- Get Visits //VİEW KULLANILDI
SELECT * FROM visit_view ORDER BY visit_id

-- Search Visits
SELECT * FROM visit_view WHERE elder_first_name LIKE '%?%' OR elder_last_name LIKE '%?%' OR visitor1_first_name LIKE '%?%' OR visitor1_last_name LIKE '%?%' OR visitor2_first_name LIKE '%?%' OR visitor2_last_name LIKE '%?%' ORDER BY visit_id

-- Insert Visit
INSERT INTO visit(first_visitor_id, second_visitor_id, elder_id) VALUES (?, ?, ?)

-- Insert Room //SEQUENCE KULLANILDI - room_number
INSERT INTO room(room_number) VALUES(nextval('room_number'))

-- Delete Room 
DELETE FROM room WHERE id=?

-- Insert Visitor
INSERT INTO visitor(first_name, last_name) VALUES (?, ?)

-- Update Visitor
UPDATE visitor SET first_name=?, last_name=? WHERE id=?

-- Delete Visitor
DELETE FROM visitor WHERE id=?

-- Insert Elder
INSERT INTO elder(first_name, last_name, date_of_birth, gender) VALUES (?, ?, ?, ?)

-- Update Elder
UPDATE elder SET first_name=?, last_name=?, date_of_birth=?, gender=? WHERE id=?

-- Delete Elder
DELETE FROM elder WHERE id=?