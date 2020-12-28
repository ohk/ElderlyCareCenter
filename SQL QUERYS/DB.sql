CREATE SEQUENCE room_number START 101;

create table visitor(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    visit_count INT DEFAULT 0
);

create table room(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    room_number INT NOT NULL,
    isEmpty INT DEFAULT 1
);

create table elder(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL CHECK(date_of_birth <= (NOW() - interval '65 YEARS')),
    gender VARCHAR(6) CHECK(gender in ('Female', 'Male')),
    number_of_room BIGSERIAL REFERENCES room (id) ON DELETE RESTRICT,
    visit_count INT DEFAULT 0 CHECK( visit_count <= 100)
);
create table visit(
    id BIGSERIAL NOT NULL PRIMARY KEY,
    first_visitor_id BIGSERIAL NOT NULL REFERENCES visitor (id) ON DELETE CASCADE,
    second_visitor_id BIGSERIAL REFERENCES visitor (id) ,
    elder_id BIGSERIAL NOT NULL REFERENCES elder(id) ON DELETE CASCADE,
    visit_time DATE NOT NULL DEFAULT NOW()
);

CREATE FUNCTION update_visitCount() RETURNS trigger AS $update_visitCount$
    BEGIN
		UPDATE elder SET visit_count = visit_count + 1 WHERE new.elder_id = id;
        UPDATE visitor SET visit_count = visit_count + 1 WHERE new.first_visitor_id = id;
		UPDATE visitor SET visit_count = visit_count + 1 WHERE new.second_visitor_id = id;
		RETURN new;
	END;
$update_visitCount$ LANGUAGE plpgsql;

CREATE TRIGGER update_visitCount AFTER INSERT ON visit
    FOR EACH ROW EXECUTE PROCEDURE update_visitCount();

CREATE FUNCTION insert_elderRoom() RETURNS trigger AS $insert_elderRoom$
    BEGIN
		UPDATE elder SET number_of_room = (SELECT id FROM room WHERE isEmpty = 1 LIMIT 1) WHERE new.id = id;
        UPDATE room SET isEmpty = 0 WHERE id=(SELECT id FROM room WHERE isEmpty = 1 LIMIT 1);
		RETURN new;
	END;
$insert_elderRoom$ LANGUAGE plpgsql;

CREATE TRIGGER insert_elderRoom AFTER INSERT ON elder
    FOR EACH ROW EXECUTE PROCEDURE insert_elderRoom();

CREATE FUNCTION delete_elder() RETURNS trigger AS $delete_elder$
    BEGIN
        UPDATE room SET isEmpty = 1 WHERE id=new.id;
		RETURN new;
	END;
$delete_elder$ LANGUAGE plpgsql;

CREATE TRIGGER delete_elder AFTER DELETE ON elder
    FOR EACH ROW EXECUTE PROCEDURE delete_elder();

CREATE VIEW visit_view AS
SELECT v.id as visit_id, v.visit_time as visit_time,
e.id as elder_id,e.first_name as elder_first_name, e.last_name as elder_last_name,
v1.id as visitor1_id,v1.first_name as visitor1_first_name, v1.last_name as visitor1_last_name,
v2.id as visitor2_id,v2.first_name as visitor2_first_name, v2.last_name as visitor2_last_name
FROM elder e,visitor v1, visitor v2,visit v
WHERE e.id = v.elder_id AND v1.id = v.first_visitor_id AND v2.id = v.second_visitor_id;

CREATE VIEW elder_view AS
SELECT elder.id,first_name,last_name,date_of_birth,gender,number_of_room,room_number,visit_count
FROM elder,room
WHERE elder.number_of_room = room.id;