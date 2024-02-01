# group by 에 의해 그룹화된 내용을 having 으로 필터링 함

use sakila;

select *
from language;

select language.name from language;

# § Select절에 추가할 수 있는 항목
# §숫자 또는 문자열
# §표현식
# §내장 함수 호출 및 사용자 정의 함수 호출
# 실제 테이블에는 없지만 추가적으로 내용을 삽입할 수 있다.
# 값을 조회 시 별도의 별칭을 통해 불러울 수 있음
# 특히 내장함수 eg) upper 등을 통하여 값을 변경 후  추가할 수 있다.

# language 테이블을 활용한 다양한 응용
select language_id,
       'COMMON' language_usage,
       language_id * 3.14 lang_pi_val,
       upper(language.name) language_name
from language;

# AS 를 사용하여 보다 가독성을 높힐 수 있음
select language_id,
       'COMMON' AS language_usage,
       language_id * 3.14 AS lang_pi_val,
       upper(language.name) AS language_name
from language;


# actor id를 조회하면 중복이 있음이 확인됨
select film_actor.actor_id from film_actor order by film_actor.actor_id;

# select 구문 바로 뒤에 distinct 를 통해 중복이 없는 데이터를 조회할 수 있다
select distinct film_actor.actor_id from film_actor order by film_actor.actor_id;


/*
 from 의 경우 쿼리에 사용되는 테이블을 명시해줌
 테이블을 연결해주는 수단이 될 수 있음

테이블의 경우 4가지 종류가 있음
 영구 테이블 >> create table문으로 생성도닌 테이블, 실제 존제하는 테이블
 임시 테이블 >> create temporary table문으로 생성된 테이블, 임시 테이블은
 세션이 종료되면 자동 삭제됨
 뷰(가상 테이블) >> create view문으로 생성된 테이블, 뷰는 실제 존재하는 테이블이 아님
 인라인 뷰 >> from 절에 테이블을 명시하지 않고 테이블을 생�성하는 방법
 파생테이블
 */

# cust 로 파생 테이블을 지정한 다음
# 이름이 JESSIE 인 사람과 끝 이름을 부르기
select concat(cust.last_name, ' ' , cust.first_name)as full_name
from (
    select customer.first_name, customer.last_name
    from customer
    where first_name = 'JESSIE'
     )
as cust;

drop table if exists actors_j;
create temporary table actors_j
(
    actor_id smallint(5),
    first_name varchar(45),
    last_name varchar(45),
    constraint pk_actor_id
        primary key (actor_id)
);
describe actors_j;

insert into  actors_j
    select actor_id, first_name, last_name
    from actor
    where last_name like 'J%';
# %를 사용하여 필터링 가능함
#  이름이 J로 시작하는 사람을 조회

select *
from actors_j;

DROP VIEW if exists cust_vw;
CREATE VIEW cust_vw as
    select customer.customer_id, customer.first_name, customer.last_name, customer.active
    from customer;


select *
from cust_vw;

# Join 을 활용하여 테이블을 ON에 명시된 조건에 의해서 효율적으로 결합가능
select customer.first_name, customer.last_name,
    time(rental.rental_date) as rental_time
from customer inner join rental
    on customer.customer_id = rental.customer_id #join 조건을 의미함
where date(rental_date) = '2005-06-14';

# 위 구문을 축약어로 대체하여 사용 가능
select c.first_name, c.last_name,
    time(r.rental_date) as rental_time
from customer as c inner join rental as r
    on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-06-14';

# G rating 렌탈기간 7 이상
select film.title
from film
where rating = 'G' and rental_duration >= 7;

# 복수조건 사용하기
select title, rating, rental_duration
from film f
where (f.rating = 'G' and f.rental_duration >= 7)
   or (f.rating = 'PG-13' and f.rental_duration < 4);
