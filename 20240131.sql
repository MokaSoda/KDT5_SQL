use sqlclass_db;

DROP TABLE IF EXISTS person;
CREATE TABLE person(
    person_id SMALLINT UNSIGNED,
    fname  VARCHAR(20),
    lname  VARCHAR(20),
    eye_color ENUM('BR', 'BL', 'GR'),
    birth_date  DATE,
    street  VARCHAR(30),
    city  VARCHAR(20),
    state  varchar(20),
    country VARCHAR(20),
    postal_code  VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

DESC person;

DROP TABLE  IF EXISTS favorite_food;
CREATE TABLE favorite_food(
    person_id SMALLINT UNSIGNED,
    food  VARCHAR(20),
    CONSTRAINT  pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) references person(person_id)
);

DESC favorite_food;

# 제약조건 비활성화 활성화 단계
set foreign_key_checks = 0;
alter table person modify person_id SMALLINT UNSIGNED auto_increment;
set foreign_key_checks = 1;

desc person;

INSERT INTO person (person_id, fname, lname, eye_color, birth_date)
VALUES
(null, 'Tony', 'Stark', 'BR', '1970-05-29'),
(null, 'Peter', 'Parker', 'BL', '1980-06-23'),
(null, 'Natasha', 'Romanoff', 'BR', '1984-03-18'),
(null, 'Logan', 'Howlett', 'GR', '1974-11-07'),
(null, 'Bruce', 'Wayne', 'GR', '1940-03-15');

# auto incremental 속성이 있을 경우 자동 숫자 증가 때문에 null 로 지정해줌

INSERT INTO person (person_id, fname, lname, eye_color, birth_date)
VALUES
(null ,'Steve', 'Rogers', 'BL', '1918-07-04');

select *
from person;

select *
from person where fname = 'Tony';

delete
from favorite_food
where person_id < 2000;

INSERT INTO favorite_food (person_id,food)
Values
(1014, 'cookies'),
(1014, 'pizza');

select food
from favorite_food
where person_id = 1014 order by food;

insert into person
(person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
values
(10, 'Bruce', 'Wayne', 'BR', '1939-05-15', '3600 bloor st', 'toronto', 'ON', 'canada', 'm6g2h7');

select * from  person where person_id = 10;

alter table  person
add email varchar(100);

update person
set street = '검열됨',
    city = '검열됨'
where person_id > 1000;

select *
from favorite_food;

insert into person
(person_id, fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
values
(11, 'Tony', 'Stark', 'BR', '1970-05-29', '검열���', '검열���', '검열���', '검열���', '검열���');


insert into favorite_food
(person_id, food)
values
(11, '사탕');

update person
set  street = '검열됨', city = '검열됨', state = '검열됨', country = '검열됨', postal_code = '검열됨'
where person_id = 11;


#그냥 문자로 날짜를 보낼 줄 수 없음
#문자를 날짜로 변경해주는 것이 필요함

update person
set birth_date = str_to_date('2021-DEC-29', '%Y-%b-%d')
where person_id = 11;



