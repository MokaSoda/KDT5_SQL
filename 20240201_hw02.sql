use sqlclass_db;

# 1) 1960년에 노벨상 물리학상 또는 노벨 평화상을 수상한 사람의 정보를 출력 출력 컬럼: year,	category,	fullname
select year, category, fullname
from nobel
where year = 1960 and (category = 'Physics' or category = 'Peace');

# 2) Albert	Einstein이 수상한 연도와 수상 분야(category),	출생대륙, 출생국가를 출력 출력 컬럼: year,	category,	birth_continent,	birth_count
select year, category, birth_continent, birth_country
from nobel
where fullname like 'Albert Einstein';

# 3) 1910년 부터 년까지 노벨 평화상 수상자 명단 출력 (연도 오름차순) - 출력 컬럼: year,	fullname,	birth_country
select year, fullname, birth_country
from nobel
where year between 1910 and 2010
and category = 'Peace'
order by year asc;
# 4) 전체 테이블에서 수상자 이름이 ‘John’으로 시작하는 수상자 모두 출력 - 출력 컬럼: category,	fullname
select category, fullname
from nobel
where fullname like 'John%';
# 5) 1964년 수상자 중에서 노벨화학상과 의학상(‘Physiology	or	Medicine’)을 제외한 수상자의 모든 정보를 수상자 이름을 기준으로 오름차순으로 정렬 후 출력
select year, category, prize_amount, fullname, gender, birth_continent, birth_country
from nobel
where year = 1964
and category not in ('Physiology or Medicine')
order by fullname asc;

# 6) 2000년부터 2019년까지 노벨 문학상 수상자 명단 출력
select year, fullname, gender, birth_country
from nobel
where year between 2000 and 2019 and category = 'Literature';

# 7) 각 분야별 역대 수상자의 수를 내림차순으로 정렬 후 출력(group	by,	order	by)
select category, count(*) as 역대수상자수
from nobel
group by category
order by 역대수상자수 desc;

# 8) 노벨 의학상이 없었던 연도를 모두 출력 (distinct)	사용
# create table which have year only 1901 to 2019
drop table if exists yearonly;
create table yearonly(year int);

# 전쟁 등 노벨상이 전혀 없던 년도도 있기 떄문에 이를 보완
# MySQL은 특별히 시리즈를 출력해주는 내장 함수 없음
INSERT INTO yearonly (year)
SELECT 1901 + t.i
FROM (
  SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
  SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
  SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
  SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
  SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL
  SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL
  SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL
  SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL
  SELECT 24 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL
  SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL
  SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL
  SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 UNION ALL
  SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL
  SELECT 39 UNION ALL SELECT 40 UNION ALL SELECT 41 UNION ALL
  SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44 UNION ALL
  SELECT 45 UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL
  SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50 UNION ALL
  SELECT 51 UNION ALL SELECT 52 UNION ALL SELECT 53 UNION ALL
  SELECT 54 UNION ALL SELECT 55 UNION ALL SELECT 56 UNION ALL
  SELECT 57 UNION ALL SELECT 58 UNION ALL SELECT 59 UNION ALL
  SELECT 60 UNION ALL SELECT 61 UNION ALL SELECT 62 UNION ALL
  SELECT 63 UNION ALL SELECT 64 UNION ALL SELECT 65 UNION ALL
  SELECT 66 UNION ALL SELECT 67 UNION ALL SELECT 68 UNION ALL
  SELECT 69 UNION ALL SELECT 70 UNION ALL SELECT 71 UNION ALL
  SELECT 72 UNION ALL SELECT 73 UNION ALL SELECT 74 UNION ALL
  SELECT 75 UNION ALL SELECT 76 UNION ALL SELECT 77 UNION ALL
  SELECT 78 UNION ALL SELECT 79 UNION ALL SELECT 80 UNION ALL
  SELECT 81 UNION ALL SELECT 82 UNION ALL SELECT 83 UNION ALL
  SELECT 84 UNION ALL SELECT 85 UNION ALL SELECT 86 UNION ALL
  SELECT 87 UNION ALL SELECT 88 UNION ALL SELECT 89 UNION ALL
  SELECT 90 UNION ALL SELECT 91 UNION ALL SELECT 92 UNION ALL
  SELECT 93 UNION ALL SELECT 94 UNION ALL SELECT 95 UNION ALL
  SELECT 96 UNION ALL SELECT 97 UNION ALL SELECT 98 UNION ALL
  SELECT 99
) AS t;
  -- Add additional rows for years 2000-2019
INSERT INTO yearonly (year)
SELECT 2000 + t.i
FROM (
    SELECT 0 AS i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
    SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
    SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL
    SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
    SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL
    SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL
    SELECT 18 UNION ALL SELECT 19
  ) AS t;

# create view which have year which have no medicine
select *
from yearonly;

drop view if exists notmedi;
create view notmedi as
    select distinct year
    from yearonly
    where year not in (select distinct year
                        from nobel
                        where category = 'Physiology or Medicine');
# (8) 최종 결과
select *
from notmedi;

# (8-1) 노벨 의학상이 있었던 년도
drop view if exists yesmedi;
create view yesmedi as
    select distinct year
    from nobel
    where category = 'Physiology or Medicine';

# 8-1) 최종결과
select *
from yesmedi;

# 9) 노벨 의학상이 없었던 연도의 총 회수를 출력
select count(year) as 횟수
from notmedi;

# 9-1) 노벨 의학상이 있었던 횟수
select count(*) as 횟수
from yesmedi;

# 10) 여성 노벨 수상자의 명단 출력
select fullname, category, birth_country
from nobel
where gender= 'Female';

# 11) 수상자들의 출생 국가별 횟수 출력
select birth_country, count(*) as 횟수
from nobel
group by birth_country
order by 횟수 desc;
# 12) 수상자의 출생 국가가 ‘Korea’인 정보 모두 출력
select *
from nobel
where birth_country = 'Korea';
# 13) 수상자의 출신 국가가 (‘Europe’,	‘North	America’,	공백)이 아닌 모든 정보 출력
select *
from nobel
where nobel.birth_continent not in ('Europe', 'North America', '');
# 14) 수상자의 출신 국가별로 그룹화를 해서 수상 횟수가 10회 이상인 국가의 모든 정보
select birth_country, count(*) as 수상횟수
from nobel
group by birth_country
having 수상횟수 >= 10
order by 수상횟수 desc;
# 15) 2회 이상 수상자 중에서 fullname이 공백이 아닌 경우를 출력하는데, fullname의
select fullname, count(*) as 횟수
from nobel
group by fullname
having 횟수 >= 2 and fullname is not null
order by 횟수 asc;