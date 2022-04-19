/*************************************************************************
*                          조건절 검색 및 행의 정렬
*************************************************************************/

/*                         where 절을 이용한 조건 검색                    */

-- where 절을 이용한 조건 검색
SELECT studno, name, deptno
FROM student
WHERE grade = '1';

-- 비교 연산자를 사용한 조건 검색
SELECT studno, name, grade, deptno, weight
FROM student
WHERE weight <= 70;

-- AND 논리 연산자를 이용한 조건 검색
SELECT studno, name, weight, deptno
FROM student
WHERE grade = '1'
    AND weight >= 70;
    
-- OR 논리 연산자를 이용한 조건 검색
SELECT studno, name, weight, deptno
FROM student
WHERE grade = '1' 
    OR weight >= 70;

-- NOT 논리 연산자를 이용한 조건 검색
SELECT studno, name, weight, deptno
FROM student
WHERE NOT deptno = 101;

-- BETWEEN 연산자를 이용한 조건 검색
SELECT studno, name, weight
FROM student
WHERE weight BETWEEN 50 AND 70;

SELECT name, birthdate
FROM student
WHERE birthdate BETWEEN '81/01/01' AND '82/12/31';

-- IN 연산자를 이용한 조건 검색
SELECT name, grade, deptno
FROM student
WHERE deptno IN (102, 201);

-- LIKE 연산자를 이용한 조건 검색
SELECT name, grade, deptno
FROM student
WHERE name LIKE '김%';

SELECT name, grade, deptno
FROM student
WHERE name LIKE '김_영';

-- ESCAPE 옵션
INSERT INTO student (studno, name) VALUES (33333, '황보_정');
/*
SELECT name
FROM student
WHERE name like '황보\_%' escape '\';
*/
delete from student where studno = 33333;

-- NULL

SELECT nvl(NULL, 'B') FROM dual;        --B
SELECT nvl('c1', 'B') FROM dual;        --c1
SELECT nvl2(NULL, 'A', 'B') FROM dual;  --B
SELECT nvl2('c1', 'A', 'B') FROM dual;  --A

SELECT mgr FROM emp WHERE ename='SCOTT';                --7566
SELECT mgr FROM emp WHERE ename='KING';                 --null
SELECT nvl(mgr, 0) FROM emp WHERE ename='KING';         --0
SELECT mgr FROM emp WHERE ename='KANG';                 --공집합
SELECT nvl(mgr, 'X') FROM emp WHERE ename='KANG';       --공집합
SELECT max(mgr) FROM emp WHERE ename='KANG';            --null
SELECT nvl(max(mgr), 99) FROM emp WHERE ename='KANG';   --99

select name, position, comm
from professor;

-- NULL 연산자를 이용한 조건 검색
select name, position, comm
from professor
where comm=null;    -- comm 컬럼에 'null' 문자열이 있는지 비교 검색

select name, position, comm
from professor
where comm is null; -- comm 컬럼 값이 null인 행 검색

-- 산술식에서의 null 처리
select name, sal, comm, sal*comm sal_comm
from professor;

-- 연산자 우선순위
-- 1. 비교 연산자, SQL 연산자
-- 2. NOT 3. AND 4. OR
select name, grade, deptno
from student
where deptno = 102
    AND (grade = '4'
        OR grade = '1');
    
select name, grade, deptno
from student
where deptno = 102
    AND grade = '4'
    OR grade = '1';

/*                              집합 연산자                           */

-- 집합 연산자
CREATE TABLE stud_heavy
AS SELECT *
FROM student
WHERE weight >= 70 AND grade = '1';

CREATE TABLE stud_101
AS SELECT *
FROM student
WHERE deptno = 101 AND grade = '1';

-- UNION 연산을 실행하는 두 테이블이 합병 불가능한 경우
-- -> 컬럼 수가 다른 경우
select studno, name
from stud_heavy
union
select studno, name, grade
from stud_101;              --ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.

-- union, union all 연산 비교: 합집합
-- union: 중복X / union all: 중복O
select studno, name
from stud_heavy
union
select studno, name
from stud_101;

select studno, name
from stud_heavy
union all
select studno, name
from stud_101;

-- intersect 연산: 교집합
select name from stud_heavy
intersect
select name from stud_101;

-- minus 연산: 차집합
select studno 학번, name 이름
from stud_heavy
minus
select studno, name
from stud_101;                  -- stud_heavy - stud_101

select studno 학번, name 이름
from stud_101
minus
select studno, name
from stud_heavy;                -- stud_101 - stud_heavy


/*                                 정렬                            */

-- 단일 컬럼을 이용한 정렬 - 오름차순
select name, grade, tel
from student
order by name;

-- 단일 컬럼을 이용한 정렬 - 내림차순
select name, grade, tel
from student
order by grade desc;

-- 다중 열에 의한 정렬
SELECT ename, job, deptno, sal
FROM emp
ORDER BY deptno, sal DESC;

-- 실습
SELECT ename, deptno
FROM emp
WHERE deptno IN (10, 30)
ORDER BY ename;

SELECT ename, hiredate
FROM emp
WHERE hiredate LIKE '82%';

SELECT ename, sal, comm
FROM emp
WHERE comm IS NOT NULL and comm != 0
ORDER BY sal DESC, comm DESC;

SELECT ename, sal, comm
FROM emp
WHERE comm >= sal*0.2 
    AND deptno = 30;


/*************************************************************************
*                               SQL 함수
*************************************************************************/

/*                               문자 함수                               */

-- 대소문자 변환 함수 LOWER, UPPER 함수
select userid, lower(userid), upper(userid)
from student
where studno = 20101;

-- 문자열 길이 반환 함수 length, lengthb 함수
-- length: 문자열 길이 반환
-- lengthb: 문자의 바이트 수 반환
select dname, length(dname), lengthb(dname)
from department;

-- 문자조작 함수 
-- concat 함수
select concat(concat(name, '의 직책은 '), position)
from professor;

-- substr 함수
select name, idnum, substr(idnum, 1, 6) birth_date, substr(idnum, 3, 2) birth_mon
from student
where grade = '1';

-- instr 함수
select dname, instr(dname, '과')
from department;

select instr ('Welcome to Oralce 10g', 'o') from dual;
select instr ('Welcome to Oralce 10g', 'o', 3, 2) from dual;

-- LPAD, RPAD
select position,
    lpad(position, 10, '*') lpad_position,
    userid,
    rpad(userid, 12, '+') rpad_userid
from professor;

-- LTIRM, RTRIM
select ltrim('xyxXxyLAST WORD', 'xy') from dual;
select rtrim('TURNERyxXxy', 'xy') from dual;

select dname, rtrim(dname, '과') from department;

/*                                 숫자 함수                            */

-- round
select name,
    sal,
    sal/22,
    round(sal/22),
    round(sal/22, 2),
    round(sal/22, -1)
from professor
where deptno = 101;

-- trunc
SELECT name,
    sal,
    sal/22,
    TRUNC(sal/22),
    TRUNC(sal/22, 2),
    TRUNC(sal/22, -1)
FROM professor
WHERE deptno = 101;

-- mod
SELECT name, sal, comm, MOD(sal, comm)
FROM professor
WHERE deptno = 101;

-- ceil, floor
select ceil(19.7), floor(12.345)
from dual;


/*                                 날짜 함수                            */
-- 날짜 계산
select name, hiredate, hiredate+30, hiredate+60
from professor
where profno = 9908;

-- sysdate
select sysdate from dual;

-- months_between, add_months
select profno,
    hiredate,
    months_between(sysdate, hiredate) tenure,
    add_months(hiredate, 6) review
from professor
where months_between(sysdate, hiredate) < 300;

-- last_day, next_day
-- last_day: 해당 날짜가 속한 달의 마지막 날짜를 반환
-- next_day: 해당 일을 기준으로 명시된 요일의 다음 날짜를 반환
select sysdate, last_day(sysdate), next_day(sysdate, '일') from dual;
select sysdate, last_day(sysdate), next_day(sysdate, 1) from dual;

-- trunc, round
-- trunc: 날짜를 절삭, 시간정보와 상관없이 당일날을 출력
-- round: 날짜를 반올림, 정오를 넘으면 다음날 출력
select to_char(sysdate, 'YY/MM/DD HH24:MI:SS') normal,
    to_char(trunc(sysdate), 'YY/MM/DD HH24:MI:SS') trunc,
    to_char(round(sysdate), 'YY/MM/DD HH24:MI:SS') round
from dual;

select to_char(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate,
    to_char(round(hiredate, 'dd'), 'YY/MM/DD') round_dd,
    to_char(round(hiredate, 'mm'), 'YY/MM/DD') round_mm,
    to_char(round(hiredate, 'yy'), 'YY/MM/DD') round_yy
from professor
where deptno=101;


/*                               데이터 타입의 변환                            */
-- to_char
select studno, to_char(birthdate, 'YY-MM') birthdate
from student
where name = '전인하';

select name, grade, to_char(birthdate, 'Day Month DD, YYYY') birthdate
from student
where deptno = 102;

-- 시간 표현 형식
select name, to_char(hiredate, 'MONTH DD, YYYY HH24:MI:SS PM') hiredate
from professor
where deptno=101;

-- 기타 날짜 표현 형식
select name, position, to_char(hiredate, 'Mon "the" DDTH "of" YYYY') hiredate
from professor
where deptno=101;

-- 숫자를 문자 형식으로 변환
select name, sal, comm, to_char((sal+comm)*12, '9,999') anual_sal
from professor
where comm is not null;

-- to_number
select to_number('1') num from dual;

-- to_date
SELECT name, hiredate
FROM professor
WHERE hiredate = TO_DATE('6월 01, 01', 'MONTH DD, YY');

-- 중첩 함수
select idnum from student;
select substr(idnum, 1, 6) birthdate from student;
select to_date(substr(idnum, 1, 6), 'YYMMDD') birthdate from student;
select to_char(to_date(substr(idnum, 1, 6), 'YYMMDD'), 'YY/MM/DD') birthdate from student;


/*                               일반 함수                                  */
-- NVL
select name, 
    position, 
    sal, 
    comm, 
    sal*comm, 
    sal*nvl(comm, 0) s1, 
    nvl(sal*comm, sal) s2
from professor
where deptno = 201;

-- NVL2
select name,
    position,
    sal,
    comm,
    nvl2(comm, sal*comm, sal) total
from professor
where deptno = 102;

select ename,
    sal,
    comm,
    sal+comm,
    nvl2(comm, sal+comm, sal),
    sal+nvl(comm, 0)
from emp;

-- NULLIF
select name,
    userid,
    lengthb(name),
    length(userid),
    nullif(lengthb(name), lengthb(userid)) nullif_result
from professor;

-- COALESCE
select name,
    comm,
    sal,
    coalesce(comm, sal, 0) co_result
from professor;

-- DECODE
select name,
    deptno,
    decode(deptno,
        101, '컴퓨터공학과',
        102, '멀티미디어학과',
        201, '전자공학과',
        '기계공학과') dname
from professor;

-- CASE
SELECT name,
    deptno,
    sal,
    CASE WHEN deptno = 101 then sal*0.1
        WHEN deptno = 102 then sal*0.2
        WHEN deptno = 201 then sal*0.3
        ELSE 0
    END bonus
FROM professor;


/*************************************************************************
*                               GROUP 함수
*************************************************************************/


/*                              그룹 함수의 종류                          */
-- COUNT
select count(comm)
from professor
where deptno = 101;

select count(*)
from professor
where deptno = 101 and comm is not null;

-- AVG, SUM
select avg(weight), sum(weight)
from student
where deptno=101;

-- MIN, MAX
select max(height), min(height)
from student
where deptno = 102;

select studno, name, height, deptno
from student
where deptno=102
order by height;

-- STDDEV, VARIANCE
select stddev(sal), variance(sal)
from professor;


/*                              데이터 그룹 생성                          */

-- GROUP BY
-- group by 절에 명시하지 않은 컬럼을 select 절에서 사용한 경우
select deptno, position, avg(sal)
from professor
group by deptno;        -- ORA-00979: GROUP BY 표현식이 아닙니다.

-- 단일 컬럼을 이용한 그룹핑
select deptno, count(*), count(comm)
from professor
group by deptno;

-- 다중 컬럼을 이용한 그룹핑
select deptno, avg(sal), min(sal), max(sal)
from professor
group by deptno;

select deptno, grade, count(*), round(avg(weight))
from student
group by deptno, grade;

-- ROLLUP, CUBE
select deptno, sum(sal)
from professor
group by rollup(deptno);

select deptno, position, count(*)
from professor
group by rollup(deptno, position);

select deptno, position, count(*)
from professor
group by cube(deptno, position);

-- GROUPING
-- rollup이나 cube 연산자로 생성된 그룹 조합에서 사용되었는지 여부를 조사
-- 사용하면 0, 아니면 1
select deptno, grade, count(*),
    grouping(deptno),
    grouping(grade) grp_grade
from student
group by rollup(deptno, grade);

-- GROUPING SETS
-- group by 절에서 그룹 조건을 여러 개 지정할 수 있는 함수
-- 각 그룹 조건에 대해 별도로 group by한 결과를 union all한 결과와 동일
select deptno, grade, to_char(birthdate, 'yyyy') birthdate, count(*)
from student
group by grouping sets((deptno, grade), (deptno, to_char(birthdate, 'yyyy')));

select deptno, grade, null, count(*)
from student
group by deptno, grade
union all
select deptno, null, to_char(birthdate, 'yyyy'), count(*)
from student
group by deptno, to_char(birthdate, 'yyyy');

/*                              HAVING 절                              */
-- HAVING 절
select grade,
    count(*),
    round(avg(height)) avg_height,
    round(avg(weight)) avg_weight
from student
group by grade
order by avg_height desc;

select grade,
    count(*),
    round(avg(height)) avg_height,
    round(avg(weight)) avg_weight
from student
group by grade
having count(*) > 4
order by avg_height desc;

-- HAVING절과 WHERE절의 성능 차이
-- where절이 having절보다 효율적
-- -> where절에 의해 그룹화 과정에 불필요한 행을 미리 제외한 후 group by절 실행하여 내부정렬에 필요한 행의 수를 줄여주므로
select deptno, avg(sal)
from professor
group by deptno
having deptno > 102;

select deptno, avg(sal)
from professor
where deptno > 102
group by deptno;

-- 함수의 중첩
select deptno, avg(weight)
from student
group by deptno;

select max(avg(weight)) max_weight
from student
group by deptno;

select max(count(studno)) max_cnt, min(count(studno)) min_cnt
from student
group by deptno;
