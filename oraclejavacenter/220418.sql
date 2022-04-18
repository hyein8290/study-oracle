/*************************************************************************
*                          SQL 사용법
*************************************************************************/
-- 테이블의 모든 데이터를 검색
select deptno, dname, college, loc from department;
select * from department;

-- 테이블의 특정 컬럼을 검색
select dname, deptno from department;

-- 중복행 출력 금지 -단일 컬럼
select distinct deptno from student;

-- 중복행 출력 금지 -복수 컬럼
select distinct deptno, grade from student;

-- 컬럼 별명 부여 -공백 or AS 사용
select dname dept_name, deptno as dn from department;
select dname "Department Name", deptno "부서번호#" from department;

-- 합성 연산자 
select studno || ' ' || name "Student" from student;

-- 산술 연산자
select name, weight, weight*2.2 as weight_pound from student;

/*************************************************************************
*                          데이터 타입
*************************************************************************/
-- 상수값, CHAR, VARCHAR2 비교
create table ex_type(
    c char(10),
    v varchar2(10)
);

insert into ex_type values('sql', 'sql');

select * from ex_type where c='sql';
select * from ex_type where v='sql';
select * from ex_type where c=v;    -- char와 varchar2의 길이가 다르므로 비교결과가 거짓
