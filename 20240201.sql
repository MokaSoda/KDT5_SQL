# group by 에 의해 그룹화된 내용을 having 으로 필터링 함

use sakila;
select *
from language;
select language.name
from language;

# § Select절에 추가할 수 있는 항목
# §숫자 또는 문자열
# §표현식
# §내장 함수 호출 및 사용자 정의 함수 호출
# 실제 테이블에는 없지만 추가적으로 내용을 삽입할 수 있다.
# 값을 조회 시 별도의 별칭을 통해 불러울 수 있음
# 특히 내장함수 eg) upper 등을 통하여 값을 변경 후  추가할 수 있다.

# language 테이블을 활용한 다양한 응용
select language_id,
       'COMMON'             language_usage,
       language_id * 3.14   lang_pi_val,
       upper(language.name) language_name
from language;

# AS 를 사용하여 보다 가독성을 높힐 수 있음
select language_id,
       'COMMON'             AS language_usage,
       language_id * 3.14   AS lang_pi_val,
       upper(language.name) AS language_name
from language;


# actor id를 조회하면 중복이 있음이 확인됨
select film_actor.actor_id
from film_actor
order by film_actor.actor_id;

# select 구문 바로 뒤에 distinct 를 통해 중복이 없는 데이터를 조회할 수 있다
select distinct film_actor.actor_id
from film_actor
order by film_actor.actor_id;


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
select concat(cust.last_name, ' ', cust.first_name) as full_name
from (select customer.first_name, customer.last_name
      from customer
      where first_name = 'JESSIE')
         as cust;

drop table if exists actors_j;
create temporary table actors_j
(
    actor_id   smallint(5),
    first_name varchar(45),
    last_name  varchar(45),
    constraint pk_actor_id
        primary key (actor_id)
);
describe actors_j;

insert into actors_j
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
select customer.first_name,
       customer.last_name,
       time(rental.rental_date) as rental_time
from customer
         inner join rental
                    on customer.customer_id = rental.customer_id #join 조건을 의미함
where date(rental_date) = '2005-06-14';

# 위 구문을 축약어로 대체하여 사용 가능
select c.first_name,
       c.last_name,
       time(r.rental_date) as rental_time
from customer as c
         inner join rental as r
                    on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-06-14';

# G rating 렌탈기간 7 이상
select film.title
from film
where rating = 'G'
  and rental_duration >= 7;

# 복수조건 사용하기
select title, rating, rental_duration
from film f
where (f.rating = 'G' and f.rental_duration >= 7)
   or (f.rating = 'PG-13' and f.rental_duration < 4);


# groupby 를 통해서 대여 횟수 조회하기
select customer.first_name, customer.last_name, count(*) as 랜탈횟수
from customer
         inner join rental
                    on customer.customer_id = rental.customer_id
group by customer.first_name, customer.last_name
having 랜탈횟수 >= 40
order by count(*) desc;


# 다중 컬럼 정렬시 왼쪽부터 조회후 같은 값일 경우
# 다음 컬럼을 조회한다
select c.first_name, c.last_name, time(r.rental_date) as rental_time
from customer as c
         inner join rental as r
                    on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-06-14'
order by c.last_name, c.first_name asc;


# db의 경우 인덱스가 1부터 시작됨
# 하지만 쿼리 파서의 경우 인덱스가 0부터 시작
# 따라서 인덱스를 1 부터 사용하는 경우 1을 더해
# 인덱스를 0 부터 사용하는 경우 1을 빼준다

# 복수 컬럼의 정렬
select actor.actor_id, actor.first_name, actor.last_name
from actor
order by last_name desc, first_name desc;

# Williams, davis 조건 검색하기
select actor.first_name, actor.last_name, actor.actor_id
from actor
where last_name in ('Williams', 'Davis');

# rental 테이블 2005년 7월 5일 영화 대여한 고객 id 조회
select distinct rental.customer_id
from rental
where date(rental.rental_date) = '2005-07-05';

# 2005년 6월 14일 영화 대여한 고객 id 조회 이후 반납 날짜를
# 기준으로 내림차순 정렬
select c.store_id, c.email, r.rental_date, r.return_date
from customer as c
         inner join rental as r
                    on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-06-14'
order by return_date desc;


/*
sql에서는 괄호를 통해 보다 명확한 의도를 표현함

not 의 경우 not 을 그대로 써서 부정을 표현하거나
<> 를  사용하여 부정을 표현
드모르간 법칙
not ( A or B)
not A  and not B
sql 쿼리문에서는 동등 조건 = 만 사용


시간 정보 검색시 범위설정시 같거나 작음의 의미는 다음과 같다
'2005-06-16' 을 기준을 잡았을 떄 00:00:00 타임만을 포함함
만약 date 전체를 포함하고 싶을 경우 date 함수를 사용해야함
 */

# between 구문
# between 의 경우 상한값, 하한값 모두 포함함
# between 을 사용할 경우 반드시 앞은 하한값, 뒤는 상한값
select customer_id, rental_date
from rental
where date(rental_date)
          between '2005-06-15' and '2005-06-16';

# and 구문만 사용
select customer_id, rental_date
from rental
where date(rental_date) >= '2005-06-15'
  and date(rental_date) <= '2005-06-16';
#between 연산자 사용해보기
select customer_id, rental_date
from rental
where date(rental_date) between '2005-06-15' and '2005-06-16';

#숫자 범위에서도 between 사용 가능
select customer_id, amount, payment_date
from payment
where amount between 10.0 and 11.99;

# 문자 범위에서도 between 사용 가능
# 문자열 자체적으로 순서를 계산하여 만족하는 조건을 출력해줄 수 있음
# 따라서 첫글자 일부만 적어도 사용 가능
select customer_id, first_name, last_name
from customer
where last_name between 'FA' AND 'FRB'
ORDER BY first_name desc;

# or in 연산자
select title, rating
from film
where rating = 'G'
   or rating = 'PG';

# 위 구문을 in 연산자로 대체
select title, rating
from film
where rating in ('G', 'PG');


# 서브 쿼리의 사용
# 서브 쿼리는 반드시 () 로 묶어줘야함
# 서브쿼리 내용
select distinct rating
from film
where title like '%PET%';

# 서브쿼리의 내용을 바탕으로 영화 선택
select title, rating
from film
where rating in (select distinct rating
                 from film
                 where title like '%PET%')
order by rating desc, title desc;

# not in 을 사용하면 반대로 걸러내야할 영화를 제외해 쿼리함
# pg13 r nc17 는 제외함
select title, rating
from film
where rating not in ('PG-13', 'R', 'NC-17')
order by rating, title desc;

/*
 와일드 카드
 _ : 정확히 한 문자
 '%' : 개수에 상관없이 모든 문자 포함
 예시)
 'A%' : A로 시작하는 문자열
 '%A' : A로 끝나는 문자열
 '%A%' : A를 포함하는 문자열
 'A%A' : A로 시작하고 A로 끝나는 문자열
 */

# 두번째가 A, 4번째가 T, 이후 S로 마치는 last_name
select last_name, first_name
from customer
where last_name like '_A_T%S';

# Q나 Y로 시작하는 last_name
select last_name, first_name
from customer
where last_name like 'Q%'
   or last_name like 'Y%';

# 정규표현식을 활용하여 위 구문 표현
select last_name, first_name
from customer
where last_name regexp '^[QY]+[A-Z]';


# NULL 값 확인하기
# is null // is not null
# null 과 조건 조합 하기
# 이름이 없는 고객 찾기
# 두가지 조건(null or 날짜범위아님)
select rental_id, customer_id, return_date
from rental
where (return_date is null)
   or (date(return_date) not between '2005-05-01' and '2005-09-01');


