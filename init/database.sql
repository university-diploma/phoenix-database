-- CREATE DATABASE
CREATE DATABASE shop;
USE shop;

-- DROP TABLES
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS region;

-- CREATE TABLES

CREATE TABLE region (
  region_id INT          NOT NULL AUTO_INCREMENT,
  name      VARCHAR(200) NOT NULL UNIQUE,

  PRIMARY KEY (region_id)
);

CREATE TABLE city (
  city_id   INT          NOT NULL AUTO_INCREMENT,
  name      VARCHAR(200) NOT NULL UNIQUE,
  region_id INT          NOT NULL,

  PRIMARY KEY (city_id),
  FOREIGN KEY (region_id) REFERENCES region (region_id)
);

CREATE TABLE user (
  user_id    INT          NOT NULL  AUTO_INCREMENT,
  first_name VARCHAR(50)  NOT NULL,
  last_name  VARCHAR(50)  NOT NULL,
  email      VARCHAR(100) NOT NULL  UNIQUE,
  birthday   DATE         NOT NULL,
  password   VARCHAR(100) NOT NULL,
  photo      VARCHAR(300),
  city_id    INT          NOT NULL,
  gender     ENUM ('M', 'F'),

  PRIMARY KEY (user_id)
);

CREATE TABLE phone (
  phone_id     INT         NOT NULL AUTO_INCREMENT,
  phone_number VARCHAR(12) NOT NULL,
  user_id      INT         NOT NULL,

  PRIMARY KEY (phone_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
);

CREATE TABLE role (
  role_id   INT         NOT NULL AUTO_INCREMENT,
  role_name VARCHAR(50) NOT NULL UNIQUE,

  PRIMARY KEY (role_id)
);

CREATE TABLE user_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES user (user_id),
  FOREIGN KEY (role_id) REFERENCES role (role_id)
);


CREATE TABLE common_category (
  common_category_id INT          NOT NULL AUTO_INCREMENT,
  name               VARCHAR(100) NOT NULL UNIQUE,

  PRIMARY KEY (common_category_id)
);

CREATE TABLE category (
  category_id        INT          NOT NULL AUTO_INCREMENT,
  name               VARCHAR(100) NOT NULL UNIQUE,
  common_category_id INT          NOT NULL,

  PRIMARY KEY (category_id),
  FOREIGN KEY (common_category_id) REFERENCES common_category (common_category_id)
);

CREATE TABLE product (
  product_id  INT           NOT NULL AUTO_INCREMENT,
  name        VARCHAR(300)  NOT NULL,
  desciption  VARCHAR(1000) NOT NULL,
  rubles      INT           NOT NULL,
  pennies     INT           NOT NULL,
  category_id INT           NOT NULL,
  city_id     INT           NOT NULL,
  user_id     INT           NOT NULL,

  PRIMARY KEY (product_id),
  FOREIGN KEY (category_id) REFERENCES category (category_id),
  FOREIGN KEY (city_id) REFERENCES city (city_id),
  FOREIGN KEY (user_id) REFERENCES user (user_id)
);

CREATE TABLE photo (
  photo_id   INT          NOT NULL AUTO_INCREMENT,
  photo      VARCHAR(300) NOT NULL,
  product_id INT          NOT NULL,

  PRIMARY KEY (photo_id),
  FOREIGN KEY (product_id) REFERENCES product (product_id)
);

-- FUNCTIONS
DELIMITER $$
CREATE FUNCTION getRegionIdByName(region_name VARCHAR(200))
  RETURNS INT DETERMINISTIC
  BEGIN
    DECLARE phoneId INT;
    SELECT region_id
    INTO phoneId
    FROM region as r
    WHERE r.name = region_name;
    RETURN phoneId;
  END
$$

CREATE FUNCTION getRoleIdByName(role_name VARCHAR(200))
  RETURNS INT DETERMINISTIC
  BEGIN
    DECLARE phoneId INT;
    SELECT r.role_id
    INTO phoneId
    FROM role as r
    WHERE r.role_name = role_name;
    RETURN phoneId;
  END
$$

CREATE FUNCTION getUserIdByEmail(email VARCHAR(200))
  RETURNS INT DETERMINISTIC
  BEGIN
    DECLARE phoneId INT;
    SELECT u.user_id
    INTO phoneId
    FROM user as u
    WHERE u.email = email;
    RETURN phoneId;
  END
$$

CREATE FUNCTION getCommonCategoryIdByName(category_name VARCHAR(200))
  RETURNS INT DETERMINISTIC
  BEGIN
    DECLARE phoneId INT;
    SELECT common_category_id
    INTO phoneId
    FROM common_category
    WHERE name = category_name;
    RETURN phoneId;
  END
$$

CREATE FUNCTION getCityIdByName(city_name VARCHAR(200))
  RETURNS INT DETERMINISTIC
  BEGIN
    DECLARE phoneId INT;
    SELECT city_id
    INTO phoneId
    FROM city
    WHERE name = city_name;
    RETURN phoneId;
  END
$$

CREATE FUNCTION getCategoryIdByName(name VARCHAR(200))
  RETURNS INT DETERMINISTIC
  BEGIN
    DECLARE phoneId INT;
    SELECT c.category_id
    INTO phoneId
    FROM category as c
    WHERE c.name = name;
    RETURN phoneId;
  END
$$
DELIMITER ;
-- POPULATE VALUES

INSERT INTO region (name)
VALUES
  ('Brest Region'),
  ('Gomel Region'),
  ('Grodno Region'),
  ('Mogilev Region'),
  ('Vitebsk Region'),
  ('Minsk Region');

INSERT INTO city (name, region_id)
VALUES
  ('Brest', getRegionIdByName('Brest Region')),
  ('Baranovichi', getRegionIdByName('Brest Region')),
  ('Pinsk', getRegionIdByName('Brest Region')),
  ('Kobryn', getRegionIdByName('Brest Region')),
  ('Biaroza', getRegionIdByName('Brest Region')),
  ('Stolin', getRegionIdByName('Brest Region')),
  ('Gomel', getRegionIdByName('Gomel Region')),
  ('Mazyr', getRegionIdByName('Gomel Region'));


INSERT INTO user (first_name, last_name, email, birthday, password, photo, city_id, gender)
VALUES
  ('Siarhei', 'Blashuk', 'bloshuk74@gmail.com', '1996-7-18',
   '$2a$10$/CtHaeqRzguwG72Ssz.eNuyiRZQiOuHoRYiNa.RcyVq92EBYfzcmS',
   'https://avatars0.githubusercontent.com/u/22153744?s=400&u=4b7d4a59f0c4b230433682fc6544ecdf02ce88b3&v=4',
   getCityIdByName('Brest'), 'M');

INSERT INTO role (role_name) VALUES ('USER'), ('ADMIN');

INSERT INTO user_roles (user_id, role_id)
VALUES
  (getUserIdByEmail('bloshuk74@gmail.com'), getRoleIdByName('ADMIN')),
  (getUserIdByEmail('bloshuk74@gmail.com'), getRoleIdByName('USER'));


INSERT INTO common_category (name) VALUES ('Electronic devices');
INSERT INTO category (name, common_category_id)
VALUES
  ('Computer', getCommonCategoryIdByName('Electronic devices')),
  ('Keyboard', getCommonCategoryIdByName('Electronic devices')),
  ('Printer', getCommonCategoryIdByName('Electronic devices')),
  ('Smartphone', getCommonCategoryIdByName('Electronic devices'));

INSERT INTO phone (phone_number, user_id)
VALUES
  ('375292023292', getUserIdByEmail('bloshuk74@gmail.com')),
  ('375332023292', getUserIdByEmail('bloshuk74@gmail.com'));


INSERT INTO product (name, desciption, rubles, pennies, category_id, city_id, user_id)
VALUES
  ('test name', 'test description', 10, 60, getCategoryIdByName('Smartphone'), getCityIdByName('Brest'),
   getUserIdByEmail('bloshuk74@gmail.com'));

INSERT INTO photo (photo, product_id)
VALUES
  ('https://test.jpg', 1),
  ('https://test2.jpg', 1);
