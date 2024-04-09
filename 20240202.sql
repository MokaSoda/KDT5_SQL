/*
 외래 키
 inner join 이 join 종류중 가장 많이 사용
 1) 데카르트의 곱 (cross join)
 - 무조건 모든 두 테이블의 행을 합쳐줌
 3행, 3행 >> 9행을 가지는 테이블이 생성됨
 cross 조인의 경우 on 같은 조건이 필요가 없음
 eg)
 select * from emp cross join dept;


******
 2) inner join
 - 조인 조건에 만족하는 행들만 결과로 출력
 - 불일치하는 조건은 제외됨
 on 다음 join의 조건이 들어감
 eg)
 select * from emp inner join dept on emp.deptno = dept.deptno;
 */
use sakila;

# inner 조인 예시
select c.first_name, c.last_name, a.address
from customer as c
         inner join address as a
                    on c.address_id = a.address_id;

# 위 결과의 갯수만 출력
select count(*)
from customer as c
         inner join address as a
                    on c.address_id = a.address_id;

/*
 이전 문법의 예제가 있을 수 있으니
 직접 찾을 경우 표준 문법을 준수하는 예제를 찾거나
 공식 다큐먼트를 사용함
 */

# inner join with where condition
select c.first_name, c.last_name, a.address, a.postal_code
from customer as c
         join sakila.address a on a.address_id = c.address_id
where a.postal_code = 52137;

# db 의 특정상 자체적인 알고리즘에 의해 자동으로 join해줌
# 따라서 from 에서의 순서는 크게 중요하지 않음
# 세 테이블을 동시에 inner join 진행해보기
select c.first_name, c.last_name, ct.city, a.address, a.district, a.postal_code
from customer as c
         inner join address as a
                    on c.address_id = a.address_id
         inner join city as ct
                    on a.city_id = ct.city_id;

# 위 쿼리에서 갯수만 출력
select count(*)
from customer as c
         inner join address as a
                    on c.address_id = a.address_id
         inner join city as ct
                    on a.city_id = ct.city_id;

/*
 서브 쿼리

 */

# 내부 쿼리를 view로 분리함
drop view if exists internal_query;
create view internal_query as
select a.address_id, a.address, ct.city, a.district
from address as a
         inner join city as ct
                    on a.city_id = ct.city_id
where a.district = 'California';


# 위 view를 사용하여 세 개 이상 테이블 조인
select c.first_name, c.last_name, addr.address, addr.city, addr.district
from customer as c
         inner join internal_query as addr
                    on c.address_id = addr.address_id;

# 테이블 재사용
# 여러테이블을 join 할 경우 두번 이상 join 가능
# join 테이블 fil, film_actor, actor 테이블
select f.title, a.first_name, a.last_name
from film as f
         inner join film_actor as fa
                    on f.film_id = fa.film_id
         inner join actor a
                    on fa.actor_id = a.actor_id
where (a.first_name = 'CATE' and a.last_name = 'MCQUEEN')
   or (a.first_name = 'CUBA' and a.last_name = 'BIRCH');


# 두 쿼리로 분리된 내용 작성1
select *
from film as f
         inner join film_actor as fa1
                    on f.film_id = fa1.film_id
         inner join actor a1
                    on fa1.actor_id = a1.actor_id
where (a1.first_name = 'CATE' and a1.last_name = 'MCQUEEN');

# 두 쿼리로 분리된 내용 작성2
select *
from film as f
         inner join film_actor as fa2
                    on f.film_id = fa2.film_id
         inner join actor as a2
                    on fa2.actor_id = a2.actor_id
where (a2.first_name = 'CUBA' and a2.last_name = 'BIRCH');

# 위 두 쿼리를 하나로 통합하여 AND 조건으로 조회
select *
from film as f
         inner join film_actor as fa1
                    on f.film_id = fa1.film_id
         inner join actor as a1
                    on fa1.actor_id = a1.actor_id
         inner join film_actor as fa2
                    on f.film_id = fa2.film_id
         inner join actor as a2
                    on fa2.actor_id = a2.actor_id
where (a1.first_name = 'CATE' and a1.last_name = 'MCQUEEN')
  and (a2.first_name = 'CUBA' and a2.last_name = 'BIRCH');

/*
 self join 사용하기
 */

use sqlclass_db;
drop table if exists customer;
create table customer
(
    customer_id smallint unsigned,
    first_name  varchar(20),
    last_name   varchar(20),
    birth_Date  date,
    spouse_id   smallint unsigned,
    constraint primary key (customer_id)
);

desc customer;

insert into customer (customer_id, first_name, last_name, birth_Date, spouse_id)
values (1, 'John', 'Mayer', '1983-05-12', 2),
       (2, 'Mary', 'Mayer', '1990-07-30', 1),
       (3, 'Lisa', 'Ross', '1989-04-15', 5),
       (4, 'Anna', 'Timothy', '1988-12-26', 6),
       (5, 'Tim', 'Ross', '1957-08-15', 3),
       (6, 'Steve', 'Donell', '1967-07-09', 4);


select cust.customer_id,
       cust.first_name,
       cust.last_name,
       cust.birth_Date,
       cust.spouse_id,
       spouse.first_name as spouse_firstname,
       spouse.last_name  as spouse_lastname
from customer as cust
         join customer as spouse
              on cust.spouse_id = spouse.customer_id;

use sakila;
select a1.address as addr2, a2.address as addr2, a1.city_id, a1.district
from sakila.address as a1
         inner join sakila.address as a2
where (a1.city_id = a2.city_id)
  and (a1.address_id != a2.address_id);


/*
 6) 집합 연산자
 union, union all, intersect, except
 union 합집합
 union all 합집합 + 중복 허용
 intersect 교집합
 except 차집합
 */

# 같은 테이블에서 col을 다르게 지정 후 union all
select 'ACTR1' as type, first_name, last_name
from actor as a
union all
select 'ACTR2' as type, first_name, last_name
from actor as a;


# 두개의 다른 테이블에서부터 값을 union all
select first_name, last_name
from customer c
where first_name like 'J%'
  and last_name like 'D%'
union all
select first_name, last_name
from actor a
where first_name like 'J%'
  and last_name like 'D%';

# 중복을 허용하지 않는 경우 union
select first_name, last_name
from customer c
where first_name like 'J%'
  and last_name like 'D%'
union
select first_name, last_name
from actor a
where first_name like 'J%'
  and last_name like 'D%';


# 교집합을 통한 결과 도출
select first_name, last_name
from customer c
where first_name like 'J%'
  and last_name like 'D%'
intersect
select first_name, last_name
from actor a
where first_name like 'J%'
  and last_name like 'D%';


# 기존의 inner join을 통한 교집합 표현
select c.first_name, c.last_name
from customer as c
         inner join actor as a
                    on (c.first_name = a.first_name) and (c.last_name = a.last_name)
where a.first_name like 'J%'
  and a.last_name like 'D%';

# 기본적으로 위 아래로 실행됨
# intersect 연산자가 다른 연산자보다 우선순위가 높음

select first_name, last_name
from actor
where last_name like 'L%'
union
select first_name, last_name
from customer
where last_name like 'L%'
order by last_name;


/*
 7. 데이터의 생성과 조작
 char, varchar, text
 char(255), varchar(65536), text(4GByte)
 되도록이면 테이블에서 해결보도록
 */

use sqlclass_db;
drop table if exists string_tbl;
create table string_tbl
(
    char_fld  char(30),
    vchar_fld varchar(30),
    text_fld  text
);

insert into string_tbl (char_fld, vchar_fld, text_fld)
values ('this is char data',
        'this is varchar data',
        'this is text data');

desc string_tbl;

# too big to excute because of date type
update string_tbl
set vchar_fld = 'this is char datadkdkdkdkdkdkdkdd';

# 세션 명령어를 통해 문자가 잘리더라도 허용되는 변경
select @@session.sql_mode;
SET sql_mode = 'ansi';
select @@session.sql_mode;


# 작은 따움표 넣기
# 1) 두번 넣거나 2) 백슬래쉬 \ 문자를 추가

update string_tbl
set text_fld = 'This language isn''t that create';

select *
from string_tbl;

update string_tbl
set text_fld = 'I don\'t want to be there, but "it" does now.';

select *
from string_tbl;

# quote를 통해서 작음따움표를 자동으로 추가해준다. 복사시 유용
select quote(text_fld)
from string_tbl;

# 문자의 길이 측정시 char 이라고 하더라도 끝 공백의 갯수를 세지 않음
select length(text_fld) as text_len, length(vchar_fld) as vchar_length
from string_tbl;

/*
 SQL에서는 문자의 인덱스가 1에서 부터 시작
 position : 부분 문자의 시작 위치를 반환
 locate : 처음 검색된 위치, 시작 위치지정 가능
 */

# position을 사용해서 찾기
select position('is' in vchar_fld), vchar_fld
from string_tbl;

# locate 를 사용해서 찾기
select locate('is', vchar_fld, 4), vchar_fld
from string_tbl;

# 만약 없는 값의 경우 0을 리턴
select locate('dddd', vchar_fld, 1), vchar_fld
from string_tbl;
select position('333' in vchar_fld), vchar_fld
from string_tbl;

/*
 문자열의 비교 strcmp(앞, 뒤)
 앞 - 뒤 개념정도
 */

#테이블을 지우는 것이 아닌 내용 전체를 지우는 것 (not drop, delete)
delete
from string_tbl;

insert into string_tbl(vchar_fld)
values ('abcd'),
       ('xyz'),
       ('QRSTUV'),
       ('qrstuv'),
       ('12345');

select *
from string_tbl
order by vchar_fld asc;

# compare all string in vchar_fld using strcmp
# mysql에서 문자열은 대소문자를 구분하지 않음
select vchar_fld, strcmp(vchar_fld, 'qrstuv')
from string_tbl;


# regex ^ vs $ (시작 vs 끝)
# 만약 select 구문에 like or regexp 를 쓸 경우
# 결과의 참 거짓을 1, 0으로 반환함

use sakila;

select name, name like '%y' as ends_in_y
from category;

select name, name regexp 'y$' as ends_in_y
from category;

use sqlclass_db;
delete
from string_tbl
;

insert into string_tbl (text_fld)
values ('This string was 29 characters');

select *
from string_tbl;

update string_tbl
set text_fld = concat(text_fld, ' and now it is longer');

alter table string_tbl
    add column text_fld2 varchar(2550);

update string_tbl
set text_fld = replace(text_fld, '29', '29 chars');

use sakila;

# insert (문자열, 시작위치, 길이(대체할 문자열의 길이), 추가할 문자열)
SELECT INSERT('goodbye world', 9, 0, 'cruel ') as string;
SELECT INSERT('goodbye world', 1, 7, 'hello') as hello;

# replace 함수
# replace(문자열, 기존문자열, 새로운 문자열)
# 기존 문자열을 제거 후 새로운 문자열을 삽입
select replace('goodbye boy', 'boy', 'girl') as replaceex;

# substr() or substring() 함수
# 문자열에서 시작 위치에서 개수만큼 추출
#
# change mysql root password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234';

select substr('test for you', 6, 3) as test;
