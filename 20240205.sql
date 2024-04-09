# 다양한 시간, 날짜 관련 내장 함수들

select cast('2023-01-01' as date);

select cast('2023-01-01 12:00:00' as datetime) as result;

select cast(now() as signed);

select cast(pi() as decimal(10,2));

select cast('123.456' as decimal(10,2));

select cast(20250101232323 as datetime) as result;

select cast(utc_timestamp as date);

select str_to_date('2023-01-01 19:00:00', '%Y-%m-%d %H:%i:%s');

select str_to_date('Sep 17, 1999', '%M %d,%Y') as return_date;

select curdate(), curtime(), current_timestamp();

select date_add(current_date(), interval 31 day);

select extract(year from '2023-01-01 22:22:22');

select datediff('2023-01-01 22:22:22', '2022-01-01 00:00:00');

#
# create user 'KGL'@'%' identified by '1234Q1@';
# grant all privileges on *.* to 'KGL'@'%';
# grant grant option on *.* to 'KGL'@'%';


select customer_id, count(*)
from rental
group by customer_id
order by  2 desc ;

select customer_id, count(*)
from rental
group by customer_id
having customer_id > 500
order by count(*) desc ;

select customer_id, count(*)
from rental
group by customer_id
having count(*) >= 40;

select
    max(amount),
    min(amount),
    avg(amount),
    sum(amount),
    count(amount)
from payment;
# 명시적 그룸, 암시적 그룸

# 그냥 컬럼명만 지정할 경우 집계함수에 의해 에러가 발생
# group by 를 통해서 컬럼을 그룹화하면
# 집계함수를 통해서 집계함수가 실행됨
select customer_id,
    max(amount),
    min(amount),
    avg(amount),
    sum(amount),
    count(amount)
from payment
group by customer_id;

select customer_id,
       max(amount),
       min(amount),
       avg(amount),
       sum(amount),
       count(*) as total_payment_count
from payment
group by customer_id;

# 모든 권한 유저 생성
# create user 'KGL'@'%' identified by '1234Q1@';
# grant all privileges on *.* to 'KGL'@'%';
# grant grant option on *.* to 'KGL'@'%';

#단일 열
select actor_id, count(*)
from film_actor
group by actor_id;

#복수 열
select fa.actor_id, f.rating, count(*)
from film_actor as fa
inner join film as f
on fa.film_id = f.film_id
group by fa.actor_id, f.rating
order by  1,2;

select fa.actor_id, f.rating, count(*) as 합계
from film_actor as fa
inner join  film as f
on fa.film_id = f.film_id
group by fa.actor_id, f.rating
order by 1,2;


select extract(year from rental.rental_date) as year,
       count(*) as howmany
from rental
group by extract(year from rental.rental_date);

select actor_id, rating, count(*)
from film_actor as fa
inner join film as f
on fa.film_id = f.film_id
group by fa.actor_id, f.rating with rollup
order by  1,2;


select actor_id, rating, count(*) as 출현횟수
from film_actor as fa
inner join  film as f
on fa.film_id = f.film_id
group by actor_id, rating with rollup
order by 1,2;

select actor_id, rating, count(*)
from film_actor fa
inner join film f on fa.film_id = f.film_id
where rating in ('G', 'PG')
group by actor_id, rating
having count(*) > 9;