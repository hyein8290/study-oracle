/*************************************************************************
*                               분석함수
*************************************************************************/

/*                              분석함수의 개념                           */
-- 집계함수와 분석함수
-- 집계함수
select deptno,
    sum(sal) s_sal
from emp
group by deptno;

-- 분석함수
select deptno,
    empno,
    sal,
    sum(sal) over(partition by deptno) s_sal
from emp;

-- 그룹내 순위 관련 함수
-- RANK
-- 특정 컬럼에 대한 순위를 구하는 함수
select job 직책,
    ename 성명,
    sal 급여,
    rank() over (order by sal desc) 전체순위,
    rank() over (partition by job order by sal desc) 직책내순위
from emp;

-- DENSE_RANK
-- RNAK()와 비슷하나, 동일한 순위를 하나의 건수로 취급하는 점이 다름
select studno, name, height,
    rank() over (order by height desc) as height_rank,
    dense_rank() over (order by height desc) as height_dense
from student;

select job 직책,
    ename 성명,
    sal 급여,
    rank() over (order by sal desc) rank,
    dense_rank() over (order by sal desc) dense_rank
from emp;

-- ROW_NUMBER
-- 분할 별로 정렬된 결과에 대해 순위를 부여하는 함수
select deptno, weight, name,
    rank() over (partition by deptno order by weight) weight_rank,
    dense_rank() over (partition by deptno order by weight) weight_dense,
    row_number() over (partition by deptno order by weight) weight_row
from student
order by deptno, weight, name;

select job 직책,
    ename 성명,
    sal 급여,
    rank() over (order by sal desc) rank,
    row_number() over (order by sal desc) row_no
from emp;

-- TOP-N 분석
-- 인라인 뷰로 top-n 분석 대상 칼럼을 정의
select studno, name, height, rank_value
from (select studno, name, height, 
            rank() over (order by height desc) as rank_value
      from student)
where rank_value <=3;

select studno, name, height,
    rank() over (order by height desc) as rank_value
from student;

-- NTILE
-- 출력 결과를 사용자가 지정한 그룹 수로 나누어 출력
select studno, name, birthdate,
    ntile(4) over (order by birthdate) class
from student;

select ename, sal,
    ntile(4) over (order by sal desc) as quarttile
from emp;

/*                              윈도우함수                            */
-- 윈도우 함수
/*
    윈도우 함수
    - 행과 행간의 관계를 쉽게 정의하기 위해 만든 함수
*/
select deptno, studno, weight,
    sum(weight) over (partition by deptno 
                        order by studno
                        rows 2 preceding) as weight_sum
from student
order by deptno, studno;

select studno, birthdate, height,
    avg(height) over (order by birthdate
                        range between interval '2' year preceding
                        and interval '2' year following) year2
from student
order by birthdate;

-- 일반 그룹 관련 함수
-- AVG
select mgr, ename ,hiredate, sal,
    avg(sal) over (partition by mgr order by hiredate rows between 1 preceding and 1 following) as c_mavg
from emp;

-- SUM
select mgr, ename ,hiredate, sal,
    sum(sal) over (partition by mgr order by sal range unbounded preceding) l_csum
from emp;

-- MAX
select mgr, ename, hiredate, sal,
    max(sal) over (partition by mgr) mgr_max
from emp;

select mgr, ename, sal
from (select mgr, ename, sal, max(sal) over(partition by mgr) as rmax_sal from emp)
where sal = rmax_sal;

-- MIN
select mgr, ename, hiredate, sal,
    min(sal) over (partition by mgr order by hiredate range unbounded preceding) p_cmin
from emp;

-- COUNT
select ename, sal,
    count(*) over (order by sal range between 50 preceding and 150 following) as mov_count
from emp;

-- FIRST_VALUE
-- 파티션 별 윈도우에서 가장 먼저 나온 값을 구함
select deptno, ename, sal,
    first_value(ename) over (PARTITION by deptno order by sal desc rows UNBOUNDED PRECEDING) as rich_emp
from emp;

select deptno, empno, ename, sal,
    first_value(ename) over (order by sal desc rows UNBOUNDED PRECEDING) as rich_emp
from (select * from emp where deptno=20 order by empno);

-- LAST_VALUE
-- 파티션 별 윈도우에서 가장 나중에 나온 값을 구함
select ename, sal, hiredate,
    last_value(hiredate) over (order by sal rows between current row and unbounded following) as lv
from (select * from emp where deptno=20 order by hiredate desc);

select studno, birthdate, height,
    avg(height) over (order by birthdate range between interval '2' year preceding and interval '2' year following) grade2,
    first_value(height) over (order by birthdate range between interval '2' year preceding and interval '2' year following) first_val,
    last_value(height) over (order by birthdate range between interval '2' year preceding and interval '2' year following) last_val
from student
order by birthdate;

-- LAG, LEAD
-- LAG: 파티션 별 윈도우에서 이전 몇 번째 행의 값을 가져올 수 있음
-- LEAD: 파티션 별 윈도우에서 이후 몇 번째 행의 값을 가져올 수 있음
select name, height,
    lead(height, 1) over (order by height) as next_height,
    lag(height, 1) over (order by height) as prev_height
from student
where deptno=101;

select ename, hiredate, sal,
    lag(sal) over (order by hiredate) as prev_sal
from emp
where job='SALESMAN';

select ename, hiredate, sal,
    lag(sal, 2, 0) over (order by hiredate) as prev_sal
from emp
where job='SALESMAN';

select ename, hiredate,
    lead(hiredate) over (order by hiredate) as "NextHired"
from emp;

-- PERCENT_RANK
-- 파티션 별 윈도우에서 제일 먼저 나오는 것을 0으로 제일 늦게 나오는 것을 1로 하여, 값이 아닌 행의 순서별 백분율을 구함
select deptno, ename, sal,
    percent_rank() over (partition by deptno order by sal desc) as pr
from emp;

-- CUME_DIST
-- 파티션 별 윈도우의 전체건수에서 현재 행보다 작거나 같은 건수에 대한 누적 백분율을 구함
select job, ename, sal,
    cume_dist() over(partition by job order by sal) as cume_dist
from emp
where job not in ('MANAGER', 'PRESIDENT');

-- RATIO_TO_REPORT
-- 파티션 내 전체 SUM(컬럼)에 대한 행별 칼럼값의 백분율을 소수점으로 구할 수 있음
select ename, sal,
    ratio_to_report(sal) over () AS rr
from emp
where job='SALESMAN';


/*************************************************************************
*                                  조인
*************************************************************************/

/*               컬럼 이름의 애매모호성, 테이블 별명, 조인조건식              */

-- 컬럼 이름의 애매모호성
select studno, name, deptno, dname
from student, department
where deptno = deptno;              --ORA-00918: 열의 정의가 애매합니다

select student.studno, student.name, student.deptno, department.dname
from student, department
where student.deptno = department.deptno;

-- 테이블 별명
select student.studno, s.name, s.deptno, d.dname
from student s, department d
where s.deptno = department.deptno;     -- ORA-00904: "DEPARTMENT"."DEPTNO": 부적합한 식별자

select s.studno, s.name, s.deptno, d.dname
from student s, department d
where s.deptno = d.deptno;

-- AND 연산자를 사용한 검색 조건 추가
select s.studno, s.name, s.deptno, d.dname
from student s, department d
where s.deptno = d.deptno 
    and s.name = '전인하';

select s.studno, s.name, s.deptno, d.dname
from student s, department d
where s.deptno = d.deptno 
    and s.weight >= 80;
    
/*                              조인의 종류                                */
-- 카티션 곱
select name, student.deptno, dname, loc
from student, department;

-- cross join
select name, student.deptno, dname, loc
from student cross join department;

-- EQUI JOIN
select s.studno, s.name, s.deptno, d.dname, d.loc
from student s, department d
where s.deptno = d.deptno;

-- EQUI JOIN - NATURAL JOIN
-- 조인 애트리뷰트에서 테이블 별명을 사용한 경우
select s.studno, s.name, s.deptno, d.dname
from student s 
    natural join department d; -- ORA-25155: NATURAL 조인에 사용된 열은 식별자를 가질 수 없음

-- 조인 애트리뷰트에서 테이블 별명을 사용하지 않은 경우
select s.studno, s.name, deptno, d.dname
from student s 
    natural join department d;

select studno, name, deptno, dname
from student
    natural join department;

select p.profno, p.name, deptno, d.dname
from professor p
    natural join department d;
    
select s.name, s.grade, s.deptno, d.dname
from student s, department d
where s.deptno = d.deptno
    and s.grade = '4';

select s.name, s.grade, deptno, d.dname
from student s
    natural join department d
where s.grade = '4';

-- EQUI JOIN - JOIN ~ USING
select s.studno, s.name, deptno, d.dname, d.loc
from student s join department d
    using (deptno);

select studno, name, deptno, dname, loc
from student join department
    using (deptno);
    
-- where절 사용
select name, dname, loc
from student s, department d
where s.deptno = d.deptno
    and name like '김%';

-- natural join절 사용
select s.name, d.dname, d.loc
from student s
    natural join department d
where name like '김%';

-- join ~ using절 사용
select name, dname, loc
from student join department
    using(deptno)
where name like '김%';

-- NON-EQUI JOIN
-- '=' 조건이 아닌 연산자 사용 (ex. >, between a and b)
select p.profno, p.name, p.sal, s.grade
from professor p, salgrade s
where p.sal between s.losal and s.hisal;

select p.profno, p.name, p.sal, s.grade
from professor p, salgrade s
where p.sal between s.losal and s.hisal
    and p.deptno = 101;
    
-- OUTER JOIN
select s.name, s.grade, p.name, p.position
from student s, professor p
where s.profno = p.profno(+)
order by p.profno;

select s.name, s.grade, p.name, p.position
from student s, professor p
where s.profno(+) = p.profno
order by p.profno;

-- LEFT OUTER JOIN
select studno, s.name, s.profno, p.name
from student s
    left outer join professor p
    on s.profno = p.profno;

select studno, s.name, s.profno, p.name
from student s, professor p
where s.profno = p.profno(+);

-- RIGHT OUTER JOIN
select studno, s.name, s.profno, p.name
from student s
    right outer join professor p
    on s.profno = p.profno;

select studno, s.name, s.profno, p.name
from student s, professor p
where s.profno(+) = p.profno;

-- FULL OUTER JOIN
select studno, s.name, s.profno, p.name
from student s
    full outer join professor p on s.profno = p.profno;
    
select s.name, s.grade, p.name, p.position
from student s, professor p
where s.profno(+) = p.profno(+);        --ORA-01468: outer-join된 테이블은 1개만 지정할 수 있습니다

select s.name, s.grade, p.name, p.position
from student s, professor p
where s.profno = p.profno(+)
union
select s.name, s.grade, p.name, p.position
from student s, professor p
where s.profno(+) = p.profno;

select s.name, s.grade, p.name, p.position
from student s full outer join professor p
    on s.profno = p.profno;
    
-- SELF JOIN
select c.deptno, c.dname, c.college, d.dname college_name
from department c, department d
where c.college = d.deptno;

select dept.dname || '의 소속은 ' || org.dname
from department dept, department org
where dept.college = org.deptno;

select dept.dname || '의 소속은 ' || org.dname
from department dept join department org
    on dept.college = org.deptno;
    
select dept.dname || '의 소속은 ' || org.dname
from department dept, department org
where dept.college = org.deptno
    and dept.deptno >= 201;

select dept.dname || '의 소속은 ' || org.dname
from department dept join department org
    on dept.college = org.deptno
where dept.deptno >= 201;


/*************************************************************************
*                               서브쿼리
*************************************************************************/

/*                              서브쿼리의 종류                            */
-- 단일행 서브쿼리
-- '=' 연산자를 이용한 단일행 서브쿼리
select studno, name, grade
from student
where grade = (select grade
                from student
                where userid = 'jun123');

-- '<' 연산자를 이용한 단일행 서브쿼리
select name, deptno, weight
from student
where weight < (select avg(weight)
                from student
                where deptno = 101)
order by deptno;

select name, grade, height
from student
where grade = (select grade
                from student
                where studno = 20101)
and height > (select height
                from student
                where studno = 20101);

-- 다중행 서브쿼리
-- IN 연산자를 이용한 다중행 서브쿼리
select name, grade, deptno
from student
where deptno in (select deptno
                from department 
                where college in (100,102));

select name, grade, deptno
from student
where deptno in (select deptno
                from department
                where college=100);
                
-- ANY 연산자를 이용한 다중행 서브쿼리
select studno, name, height
from student
where height > any (select height
                    from student
                    where grade = '4');

select studno, name, height
from student
where height > (select min(height)
                from student
                where grade = '4');
                    
-- ALL 연산자를 이용한 다중행 서브쿼리
select studno, name, height
from student
where height > all (select height
                    from student
                    where grade = '4');
                    
select studno, name, height
from student
where height > (select max(height)
                from student
                where grade = '4');

-- EXISTS 연산자를 이용한 다중행 서브쿼리
select profno, name, sal, comm, sal+nvl(comm, 0)
from professor
where exists (select profno
                from professor
                where comm is not null);
                    
-- NOT EXISTS 연산자를 이용한 다중행 서브쿼리
select 1 userid_exist
from dual
where not exists (select userid
                    from student
                    where userid='goodstudent');
    
-- 다중 컬럼 서브쿼리
-- PAIRWISE 다중 컬럼 서브쿼리
select name, grade, weight
from student
where (grade, weight) in (select grade, min(weight)
                            from student
                            group by grade);
                            
-- UNPAIRWISE 다중 컬럼 서브쿼리
select name, grade, weight
from student
where grade in (select grade
                  from student
                  group by grade)
and weight in (select min(weight)
                from student
                group by grade);

-- 상호연관 서브쿼리
select name, deptno, height
from student s1
where height > (select avg(height)
                from student s2
                where s2.deptno = s1.deptno)
order by deptno;

                  
/*                    데이터베이스 실무에서 서브쿼리 사용시 주의사항                */
-- 단일행 서브쿼리에서 오류가 발생하는 경우
select name, grade, weight
from student
where weight = (select min(weight)
                from student
                group by grade);    --ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
                
-- 메인쿼리와 서브쿼리의 컬럼의 수가 일치하지 않는 경우
select name, position, sal
from professor
where sal = (select min(sal), comm
            from professor
            where deptno=101);  --ORA-00913: 값의 수가 너무 많습니다

select name, position, sal
from professor
where sal=(select min(sal)
            from professor
            where deptno=101);

-- order by절 사용
-- 서브쿼리 내에서 order by 절 사용하면 오류 발생
select profno, name
from professor
where sal > any (select sal 
                from professor
                where position='조교수'
                order by profno);   --ORA-00907: 누락된 우괄호

select profno, name
from professor
where sal > any (select sal 
                from professor
                where position='조교수');

-- 서브쿼리의 결과가 null인 경우
select profno, name, sal
from professor
where sal > (select avg(sal)
            from professor
            where to_char(hiredate, 'yyyy') = '2002');

-- 실습
select ename, hiredate
from emp
where deptno = (select deptno
                from emp
                where lower(ename) = 'blake');

select empno, ename, sal
from emp
where sal > (select avg(sal)
                from emp)
order by sal desc;

select ename, deptno, sal
from emp
where (deptno, sal) in (select deptno, sal
                        from emp
                        where comm is not null);

-- Scalar Subquery
-- 1) select list에서의 Scalar Subquery
select employee_id, last_name,
    (select department_name
    from departments d
    where e.department_id = d.department_id
    ) department_name
from employees e
order by department_id;

-- 2) where절에서의 Scalar Subquery
select employee_id, last_name
from employees e
where ((select location_id
        from departments d
        where e.department_id = d.department_id)
        =
        (select location_id
        from locations l
        where state_province = 'California')
        );

-- 3) order by 절에서의 Scalar Subquery
select employee_id, last_name
from employees e
order by (select department_name
            from departments d
            where e.department_id = d.department_id);
            
-- 4) case 수식에서의 Scalar Subquery
select employee_id, last_name,
    (case
        when department_id in
            (select department_id
            from departments
            where location_id = 1800)
        then 'Canada' else 'other'
    end) location
from employees;

-- 5) 함수에서의 Scalar Subquery
select last_name, substr((select department_name
                        from departments d
                        where d.department_id = e.department_id),
                        1, 10) department
from employees e;

/*************************************************************************
*                               데이터 조작어
*************************************************************************/

/*                              데이터 입력                              */
-- 단일 행 입력
-- 1. 데이터 입력 전 컬럼이름, 컬럼순서, 제약조건, 데이터 타입 확인
desc student;

-- 2. 입력
insert into student
values (10110, '홍길동', 'hong', '1', '8501011143098', '85/01/01', '041)630-3114', 170, 70, 101, 9903);

-- 3. 확인
select studno, name
from student
where studno = 10110;

-- 4. 커밋
commit;

-- NULL의 입력
-- 묵시적으로 null을 입력하는 예
insert into department(deptno, dname)
values (300, '생명공학부');

commit;

select *
from department
where deptno = 300;

-- 명시적으로 null을 입력하는 예
insert into department
values (301, '환경보건학과', '', '');

commit;

select *
from department
where deptno = 301;

-- 날짜 형식 입력
insert into professor(profno, name, position, hiredate, deptno)
values (9920, '최윤식', '조교수', to_date('2006/01/01', 'yyyy/mm/dd'), 102);

commit;

select *
from professor
where profno = 9920;

-- sysdate 함수를 이용한 현재 날짜 입력
insert into professor
values (9910, '백미선', 'white', '전임강사', 200, sysdate, 10, 101);

commit;

select *
from professor
where profno = 9910;

-- 다중 행 입력
-- 단일 테이블에 다중 행 입력
-- 테이블의 데이터를 복사할 경우
create table t_student
as select * from student
where 1=0;

insert into t_student
select * from student;

-- 다중행 입력 - INSERT ALL
create table height_info(
studno number(5),
name varchar2(10),
height number(5,2));

create table weight_info(
studno number(5),
name varchar2(10),
weight number(5,2));

insert all
into height_info values (studno, name, height)
into weight_info values (studno, name, weight)
select studno, name, height, weight
from student
where grade >= '2';

commit;

select * from height_info;
select * from weight_info;

-- 다중행 입력 - Conditional INSERT ALL
delete from height_info;
delete from weight_info;
commit;
select * from height_info;
select * from weight_info;

insert all
when height > 170 then
    into height_info values (studno, name, height)
when weight > 70 then
    into weight_info values (studno, name, weight)
select studno, name, height, weight
from student
where grade >= '2';

select * from height_info;
select * from weight_info;

-- 다중행 입력 - Conditional-First INSERT ALL
delete from height_info;
delete from weight_info;
commit;
select * from height_info;
select * from weight_info;

insert first
when height > 170 then
    into height_info values (studno, name, height)
when weight > 70 then
    into weight_info values (studno, name, weight)
select studno, name, height, weight
from student
where grade >= '2';

select * from height_info;
select * from weight_info;

-- 다중행 입력 - PIVOTING INSERT
create table sales (
sales_no number(4),
week_no number(2),
sales_mon number(7, 2),
sales_tue number(7, 2),
sales_wed number(7, 2),
sales_thu number(7, 2),
sales_fri number(7, 2));

insert into sales values(1101, 4, 100, 150, 80, 60, 120);
insert into sales values(1102, 5, 300, 300, 230, 120, 150);

create table sales_data(
sales_no number(4),
week_no number(2),
day_no number(2),
sales number(7, 2));

insert all
into sales_data values(sales_no, week_no, '1', sales_mon)
into sales_data values(sales_no, week_no, '2', sales_tue)
into sales_data values(sales_no, week_no, '3', sales_wed)
into sales_data values(sales_no, week_no, '4', sales_thu)
into sales_data values(sales_no, week_no, '5', sales_fri)
select sales_no, week_no, sales_mon, sales_tue, sales_wed, sales_thu, sales_fri
from sales;

select * from sales;

select * from sales_data
order by sales_no;

/*                              데이터 수정                              */
-- 데이터 수정
select profno, name, position
from professor
where profno = 9903;

update professor
set position = '부교수'
where profno = 9903;

commit;

select profno, name, position
from professor
where profno = 9903;

-- 서브쿼리를 이용한 데이터 수정
select studno, grade, deptno
from student
where studno = 10201;

select studno, grade, deptno
from student
where studno = 10103;

update student
set (grade, deptno) = (select grade, deptno
                        from student
                        where studno = 10103)
where studno=10201;

commit; 

select studno, grade, deptno
from student
where studno = 10201;


/*                              데이터 삭제                              */
-- 단일 행 삭제
delete
from student
where studno = 20103;

commit;

select *
from student
where studno = 20103;

-- 서브쿼리를 이용한 데이터 삭제
delete from student
where deptno = (select deptno
                from department
                where dname='컴퓨터공학과');

select *
from student
where deptno = (select deptno
                from department
                where dname='컴퓨터공학과');

rollback;
