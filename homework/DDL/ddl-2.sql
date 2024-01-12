-------------------------------
-- Parts of lectures summaries;
-------------------------------

CREATE SEQUENCE seq1;

SELECT nextval('seq1');
SELECT currval('seq1');

SELECT setval('seq1', 16, false);
SELECT currval('seq1');
SELECT nextval('seq1');

CREATE SEQUENCE IF NOT EXISTS seq2 INCREMENT 16;

SELECT nextval('seq2');
SELECT currval('seq2');
SELECT setval('seq2', 2);

CREATE SEQUENCE IF NOT EXISTS seq4
INCREMENT 10
MINVALUE 0
MAXVALUE 2000
START WITH 0;

SELECT nextval('seq4');

ALTER SEQUENCE seq3 RENAME TO seq4;

DROP SEQUENCE seq4;

--------------------------------------

DROP TABLE IF EXISTS book;

CREATE TABLE IF NOT EXISTS book (
	book_id serial NOT NULL,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);



SELECT * FROM book;

CREATE SEQUENCE IF NOT EXISTS book_book_id_seq
START WITH 0
INCREMENT 5
MINVALUE 0
OWNED BY book.book_id;

DROP SEQUENCE book_book_id_seq;

INSERT INTO book(title, isbn, publisher_id)
VALUES
('title', 'isbn', 5);

ALTER TABLE book
ALTER COLUMN book_id
SET DEFAULT nextval('book_book_id_seq');
-- SET DEFAULT 0;

TRUNCATE TABLE book RESTART IDENTITY;

-------------------------
-- новый синтаксис serial
-------------------------

CREATE TABLE IF NOT EXISTS book (
	book_id int GENERATED ALWAYS AS IDENTITY (
		START WITH 10
		INCREMENT 15
		MINVALUE 0
		MAXVALUE 1500
	) NOT NULL,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

-------------------------------
-- Home work (DDL-2);
-------------------------------

-- Как посмотреть ограничения таблицы?
SELECT constraint_name
FROM information_schema.key_column_usage
WHERE table_name = '<your_table_name>';

-- 1) Создать таблицу exam с полями:
--    - идентификатора экзамена - автоинкрементируемый,
--      уникальный, запрещает NULL;
-- 	  - наименования экзамена
--    - даты экзамена
CREATE TABLE IF NOT EXISTS exam (
	exam_id serial UNIQUE NOT NULL,
	exam_name varchar(32),
	exam_date date
);

-- 2) Удалить ограничение уникальности
--    с поля идентификатора
ALTER TABLE exam
DROP CONSTRAINT exam_exam_id_key;

-- 3) Добавить ограничение первичного
--    ключа на поле идентификатора
ALTER TABLE exam
ADD CONSTRAINT PK_exam_exam_id PRIMARY KEY(exam_id);

-- 4) Создать таблицу person с полями
--    - идентификатора личности (простой int, первичный ключ)
--    - имя
--    - фамилия
CREATE TABLE person (
	person_id int PRIMARY KEY,
	first_name varchar(32),
	last_name varchar(32)
);

-- 5) Создать таблицу паспорта с полями:
--    - идентификатора паспорта (простой int, первичный ключ)
--    - серийный номер (простой int, запрещает NULL)
--    - регистрация
--    - ссылка на идентификатор личности (внешний ключ)
CREATE TABLE passport (
	passport_id int PRIMARY KEY,
	serial_number int NOT NULL,
	reqistration text,
	person_id int REFERENCES person(person_id)
);

-- 6) Добавить колонку веса в таблицу book (создавали ранее)
--    с ограничением, проверяющим вес (больше 0 но меньше 100)
ALTER TABLE book
ADD COLUMN weight int CONSTRAINT CHK_book_weight CHECK (weight > 0 AND weight < 100);

-- 7) Убедиться в том, что ограничение на вес
--    работает (попробуйте вставить невалидное значение)
INSERT INTO book(title, isbn, publisher_id, weight)
VALUES (3, 1234567890, 5, 0); -- должен вернуть ошибку типа row for relation "book" violates check constraint "chk_book_weight"

-- 8) Создать таблицу student с полями:
--    - идентификатора (автоинкремент)
--    - полное имя
--    - курс (по умолчанию 1)
CREATE TABLE student (
	student_id serial,
	full_name varchar(256),
	education_year int DEFAULT 1
);

-- 9) Вставить запись в таблицу студентов и убедиться,
--    что ограничение на вставку значения по умолчанию работает
INSERT INTO student (full_name, education_year) VALUES ('Vova', 2);  -- year должен быть равен 2
INSERT INTO student (full_name) VALUES ('Repin Vladimir Eduardovichhh'); -- year должен быть равен 1

-- 10) Удалить ограничение "по умолчанию" из таблицы студентов
ALTER TABLE student
ALTER COLUMN education_year DROP DEFAULT;

-- 11) Подключиться к БД northwind и добавить ограничение на поле
--     unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products
ADD CONSTRAINT CHK_products_unit_price CHECK (unit_price > 0);

-- Проверка:
INSERT INTO products (product_id, product_name, discontinued, unit_price)
VALUES (100, 'name', 5, 0);

-- 12) "Навесить" автоинкрементируемый счётчик на поле product_id
--     таблицы products (БД northwind). Счётчик должен начинаться
--     с числа следующего за максимальным значением по этому столбцу.
SELECT MAX(product_id) FROM products;  -- = 77

CREATE SEQUENCE IF NOT EXISTS seq_max_plus_one START 77;

ALTER TABLE products
ALTER COLUMN product_id
SET DEFAULT nextval('seq_max_plus_one');

-- 13) Произвести вставку в products (не вставляя идентификатор явно)
--     и убедиться, что автоинкремент работает. Вставку сделать так,
--     чтобы в результате команды вернулось значение, сгенерированное
--     в качестве идентификатора.
INSERT INTO products (product_name, discontinued, unit_price)
VALUES ('name', 5, 179)
RETURNING product_id;