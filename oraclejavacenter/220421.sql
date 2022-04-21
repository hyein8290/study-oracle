/*************************************************************************
*                                테이블 관리
*************************************************************************/
 
/*                        데이터베이스 응용 프로젝트 개발                    */
-- 테이블 생성 방법
create table address(
    id number(3),
    name varchar2(50),
    addr varchar2(100),
    phone varchar2(30),
    email varchar2(100)
);

-- 테이블 생성 확인
select * from tab;

-- 테이블 구조 확인
desc address;


-- 서브쿼리를 이용한 테이블 생성
insert into address
values(1, 'HGDONG', 'SEOUL', '123-4567', 'gdhong@cwnet.ac.kr');

commit;

select * from address;

create table addr_second(id, name, addr, phone, e_mail)
as select * from address;

desc addr_second;

create table addr_third
as select id, name from address;

desc addr_third;

select *
from addr_third;


-- 테이블 구조 복사
-- 서브쿼리의 where 조건절에 거짓이 되는 조건을 지정하여 출력 결과 집합이 생성되지 않도록 지정
create table addr_fourth
as select id, name from address
    where 1=2;
    
desc addr_fourth;


/*                              테이블 구조 변경                               */
-- 테이블 구조 변경
-- 테이블에 컬럼 추가
alter table address
add (birth date);

desc address;

alter table address
add (comments varchar2(200) default 'No comment');

desc address;

select * from address;


-- 테이블 컬럼 삭제
alter table address
drop column comments;

desc address;


-- 테이블 컬럼 변경
alter table address
modify phone varchar2(50);

desc address;

-- 변경 컬럼의 크기를 기존에 저장된 데이터 크기보다 작게 지정하면 오류가 발생
alter table address
modify phone varchar2(5);   --ORA-01441: 일부 값이 너무 커서 열 길이를 줄일 수 없음


-- 테이블 이름 변경
rename addr_second to client_address;

select * from tab;

select * from client_address;


-- 테이블 삭제
select * from tab;

drop table addr_third;

select * from tab
where tname = 'ADDR_THIRD';


-- TRUNCATE 명령문
/* 
    TRUNCATE
    - 테이블의 구조는 그대로 유지하고, 테이블의 데이터와 할당된 공간만 삭제
    - 테이블에 생성된 제약조건과 연관된 인덱스, 뷰, 동의어는 유지
    
    DELETE 명령문과 차이
    - delete : 기존 데이터만 삭제하는 명령, rollback 가능, where절을 이용하여 특정 행만 삭제 가능
    - truncate : 기존 데이터 삭제뿐만 아니라, 물리적인 저장 공간까지 반환, ddl문이므로 rollback 불가, 특정 행만 삭제 불가
*/

select * 
from client_address;

truncate table client_address;

select *
from client_address;

rollback;

select *
from client_address;    --rollback해도 데이터 복구 불가능


-- 주석 추가
comment on table address
is '고객 주소록을 관리하기 위한 테이블';

comment on column address.name
is '고객 이름';

all_col_comments;
select * from user_col_comments;


/*                                데이터 사전                                */

/*
    데이터 사전
    : 사용자와 DB 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블의 집합
    
    데이터 사전 종류
    : USER, ALL, DBA 접두어를 사용하여 분류
*/

-- USER_ 데이터 사전 뷰
-- : 일반 사용자와 가장 밀접하게 관련된 뷰
-- : 자신이 생성한 테이블, 인덱스, 뷰, 동의어 등의 객체나 해당 사용자에게 부여된 권한 정보 조회
select table_name from user_tables;

-- ALL_ 데이터 사전 뷰
-- : 데이터베이스 전체 사용자와 관련된 뷰
-- : 해당 객체의 소유자를 확인 가능 - owner 컬럼 존재
-- : 사용자는 all_ 사전 뷰를 이용하여 접근할 수 있는 모든 객체에 대한 정보 조회 가능
select owner, table_name from all_tables;

-- DBA_ 데이터 사전 뷰
-- : 시스템 관리와 관련된 뷰
-- : DBA나 select ant table 시스템 권한을 가진 사용자
-- : 사용자 접근 권한, 데이터베이스 자원관리 목적
select owner, table_name from dba_tables;


-- 사용자 테이블 정보 조회
-- USER_TABLES
select table_name, tablespace_name, min_extents, max_extents
from user_tables
where table_name like 'ADDR%';

-- USER_OBJECT
select object_name, object_type, created
from user_objects
where object_name like 'ADDR%' and object_type = 'TABLE';

-- USER_CATALOG
desc user_catalog;

select * from user_catalog;


/*************************************************************************
*                               데이터 무결성
*************************************************************************/

/*                         무결성 제약조건의 생성 방법                      */
-- 무결성 제약조건 생성
create table subject(
    subno number(5) 
        constraint subject_no_pk primary key
        deferrable initially deferred,
--        using index tablespace indx,
    subname varchar2(20)
        constraint subject_name_nn not null,
    term varchar(1)
        constraint subject_term_ck check (term in ('1', '2')),
    type varchar2(1)
);

alter table student
add constraint stud_no_pk primary key(studno);

create table sugang(
    studno number(5)
        constraint sugang_studno_fk references student(studno),
    subno number(5)
        constraint sugang_subno_pk references subject(subno),
    regdate date,
    result number(3),
    constraint sugang_pk primary key(studno, subno)
);


-- 무결성 제약조건 조회
select constraint_name, constraint_type
from user_constraints
where table_name in ('SUBJECT', 'SUGANG');


-- 무결성 제약조건 추가
alter table student
add constraint stud_idnum_uk unique(idnum);

alter table student
modify (name constraint stud_name_nn not null);

-- 참조하려는 키에 기본키 또는 고유키 제약조건이 없으면 오류
alter table student add constraint stud_deptno_fk
foreign key(deptno) references department(deptno);  --ORA-02270: 이 열목록에 대해 일치하는 고유 또는 기본 키가 없습니다.

alter table department
add constraint dept_dpetno_pk primary key(deptno);

alter table department
modify (dname constraint dept_dname_nn not null);

alter table professor 
add constraint prof_profno_pk primary key(profno);

alter table professor 
modify (name constraint prof_name_nn not null);

alter table professor 
add constraint prof_deptno_fk foreign key(deptno) references department(deptno);


-- 무결성 제약조건에 의한 dml 명령문의 영향
-- 1. 즉시 제약조건에 위배되는 데이터 입력
insert into subject values(1, 'SQL', '1', '1');

insert into subject values(2, '', '2', '1'); --ORA-01400: NULL을 ("SCOTT"."SUBJECT"."SUBNAME") 안에 삽입할 수 없습니다

insert into subject values(3, 'JAVA', '3', '2'); --ORA-02290: 체크 제약조건(SCOTT.SUBJECT_TERM_CK)이 위배되었습니다

commit;

select * from subject;

-- 2. 지연 제약조건에 위배되는 데이터 입력
insert into subject values(4, '데이터베이스', '1', '1');

insert into subject values(4, '데이터모델링', '2', '2');

commit;

/*
    ORA-02091: 트랜잭션이 롤백되었습니다
    ORA-00001: 무결성 제약 조건(SCOTT.SUBJECT_NO_PK)에 위배됩니다
    
    제약조건이 defferable initially deffered로 지정된 경우,
    dml문 실행 시점에 무결성 제약조건 위반 여부를 확인하지 않고 
    트랜잭션 종료시 확인하여 위반되면 해당 트랜잭션을 롤백시킨다.
*/

select * from subject;

select constraint_name, constraint_type, deferrable, deferred 
from user_constraints
where table_name = 'SUBJECT';


-- 무결성 제약조건 삭제
select constraint_name, constraint_type
from user_constraints
where table_name='SUBJECT';

alter table subject
drop constraint subject_term_ck;

select constraint_name, constraint_type
from user_constraints
where table_name='SUBJECT';


-- 무결성 제약조건의 비활성화
alter table sugang
disable constraint sugang_pk;

alter table sugang
disable constraint sugang_studno_fk;

select constraint_name, status
from user_constraints
where table_name in ('SUGANG', 'SUBJECT');


-- 무결성 제약조건의 활성화
alter table sugang
enable constraint sugang_pk;

alter table sugang
enable constraint sugang_studno_fk;

select constraint_name, status
from user_constraints
where table_name = 'SUGANG';


-- 무결성 제약조건 조회
select table_name, constraint_name, constraint_type, status
from user_constraints
where table_name in ('STUDENT', 'PROFESSOR', 'DEPARTMENT');

select table_name, column_name, constraint_name
from user_cons_columns
where table_name in ('STUDENT', 'PROFESSOR', 'DEPARTMENT');


/*************************************************************************
*                                인덱스 관리
*************************************************************************/

/*                         인덱스의 종류 및 생성 방법                      */

-- 고유 인덱스
-- : 유일한 값을 가지는 컬럼에 대해 생성하는 인덱스로 모든 인덱스 키는 테이블의 하나의 행과 연결
create unique index idx_dept_name
on department(dname);

-- 비고유 인덱스
-- : 중복된 값을 가지는 컬럼에 대해 생성하는 인텍스로 하나의 인덱스 키는 테이블의 여러 행과 연결 가능
create index idx_stud_birthdate
on student(birthdate);

-- 단일 인덱스
-- : 하나의 컬럼으로만 구성된 인덱스

-- 결합 인덱스
-- : 두 개 이상의 컬럼을 결합하여 생성하는 인덱스
create index idx_stud_dno_grade
on student(deptno, grade);

-- DESCENDING INDEX
-- : 컬럼별로 정렬 순서를 별도로 지정하여 결합 인덱스를 생성하기 위한 방법
create index fidx_stud_no_name
on student(deptno desc, name asc);

-- 함수 기반 인덱스(function based index)
-- : 컬럼에 대한 연산이나 함수의 계산 결과를 인덱스로 생성 가능
-- : insert, update 시에 새로운 값을 인덱스에 추가
create index uppercase_idx 
on emp(upper(ename));

select * from emp
where upper(ename) = 'KING';

create index idx_standard_weight
on student((height-100)*0.9);

-- 함수 기반 인덱스를 생성하기 위한 필요조건
connect system/manager;
grant query rewrite to scott;
connect scott/tiger;
alter session set querty_rewrite_enabled=true;
alter session set querty_rewrite_integrity=trusted;


/*                              인덱스 관리                                 */

-- 인덱스 정보 조회
-- user_indexes
-- : 인덱스 이름과 유일성 여부 등을 확인
select index_name, uniqueness
from user_indexes
where table_name='STUDENT';

-- user_ind_columns
-- : 인덱스 이름, 인덱스가 생성된 테이블 이름과 컬럼 이름 등을 확인
select index_name, column_name
from user_ind_columns
where table_name='STUDENT';


-- 인덱스 삭제
drop index fidx_stud_no_name;


-- 인덱스 재구성
alter index stud_no_pk rebuild;



/*************************************************************************
*                                인덱스 관리
*************************************************************************/

/*                               뷰의 관리                               */

-- 뷰 생성
-- 단순 뷰 생성
create view v_stud_dept101
as
select studno, name, deptno
from student
where deptno=101;       --ORA-01031: 권한이 불충분합니다

/*
    -- 권한 부여
    show user;
    connect as sysdba;
    grant create view to scott;
*/

create view v_stud_dept101
as
select studno, name, deptno
from student
where deptno=101;

select * from v_stud_dept101;

-- 복합 뷰 생성
create view v_stud_dept102
as
select s.studno, s.name, s.grade, d.dname
from student s, department d
where s.deptno = d.deptno
    and s.deptno =102;
    
select * from v_stud_dept102;

-- 함수를 사용하여 생성
create view v_prof_avg_sal
as
select deptno, sum(sal), avg(sal)
from professor
group by deptno;            --ORA-00998: 이 식은 열의 별명과 함께 지정해야 합니다
-- -> 함수를 사용하여 뷰를 생성하는 경우, 컬럼 별명을 사용하지 않으면 오류 발생

create view v_prof_avg_sal
as
select deptno, sum(sal) sum_sal, avg(sal) avg_sal
from professor
group by deptno; 


-- 인라인 뷰
select dname, avg_height, avg_weight
from (select deptno, avg(height) avg_height, avg(weight) avg_weight
        from student
        group by deptno) s, department d
where s.deptno = d.deptno;


-- 뷰 조회
select view_name, text
from user_views;


-- 뷰 변경
create or replace view v_stud_dept101
as 
select studno, name, deptno, grade
from student
where deptno=101;


-- 뷰의 삭제
drop view v_stud_dept101;
drop view v_stud_dept102;



/*************************************************************************
*                               사용자 권한 제어
*************************************************************************/

/*                                 권한                                 */

-- 시스템 권한 부여
connect system/oraclejava;
grant query rewrite to scott;
grant query rewrite to public;
connect scott/tiger;

select * from user_sys_privs;


-- 현재 세션에 부여된 시스템 권한 조회
-- : SESSION_PRIVS
select * from session_privs;


-- 시스템 권한 철회
revoke query rewrite from scott;


-- 객체 권한 부여 - select 권한
create user tiger identified by tiger123
default tablespace users
temporary tablespace temp;

grant connect, resource to tiger;

connect scott/tiger;

grant select on scott.student to tiger;

connect tiger/tiger123;

select * from scott.student;

-- 객체 권한 부여 - update
connect tiger/tiger123;

update scott.student
set height=180, weight=80
where deptno=101;       -- ORA-01031: 권한이 불충분합니다

connect scott/tiger

grant update(height, weight) on student to tiger;

connect tiger/tiger123;

update scott.student
set height=180, weight=80
where deptno=101; 


-- 객체 권한 조회
connect tiger/tiger123;

-- 다른 사용자에게 부여한 객체권한 조회
select *
from user_tab_privs_made;

-- 자신에게 부여된 객체권한 조회
select *
from user_tab_privs_recd;

-- 다른 사용자에게 부여한 컬럼에 대한 객체권한 조회 & 컬럼이름 조회
select *
from user_col_privs_made;

-- 자신에게 부여된 컬럼에 대한 객체권한 조회 & 컬럼이름 조회
select *
from user_col_privs_recd;


-- 객체 권한 철회
connect scott/tiger;

revoke update on student from tiger;

revoke select on student from tiger;

connect tiger/tiger123;

select * from scott.student;


/*                                 롤                                 */

-- 롤 생성
connect system/oraclejava;

create role hr_clerk; -- 암호 지정 X

create role hr_mgr
identified by manager; -- 암호 지정 O


-- 롤에 권한 부여
grant create session to hr_mgr;

grant select, insert, delete on student to hr_clerk;


-- 롤 부여
grant hr_clerk to hr_mgr;

grant hr_clerk to tiger;


-- 롤 조회
select * from role_sys_privs;

select * from role_tab_privs;

select * from user_role_privs;



/*                                동의어                                  */

-- 전용 동의어 생성
connect system/oraclejava;

create table project(
    project_id number(5) constraint pro_id_pk primary key,
    project_name varchar2(100),
    studno number(5),
    profno number(5)
);

insert into project values(12345, 'portfolio', 10101, 9901);

select * from project;

grant select on project to scott;

connect scott/tiger;

select * from project;  --ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

select * from system.project;

connect system/oraclejava;
create synonym my_project for system.project;

connect scott/tiger;
select * from my_project;



/*************************************************************************
*                               계층적 질의문
*************************************************************************/

/*                              계층적 질의문                            */

-- 계층적 질의문 - top-down 방식
select deptno, dname, college
from department
start with deptno = 10
connect by prior deptno = college;

-- 계층적 질의문 - bottom up
select deptno, dname, college
from department
start with deptno=102
connect by prior college = deptno;

-- 계층적 질의문 - 레벨별 구분
select level,
        lpad(' ', (level-1)*2) || dname 조직도
from department
start with dname = '공과대학'
connect by prior deptno=college;


-- 계층구조에서 가지 제거 방법
select deptno, dname, college, loc
from department
where dname != '정보미디어학부'
start with college is null
connect by prior deptno = college;

select deptno, college, dname, loc
from department
start with college is null
connect by prior deptno = college
    and dname != '정보미디어학부';


-- 계층적 질의문 응용 - connect_by_root
select lpad(' ', 4*(level-1)) || ename 사원명,
    empno 사번,
    connect_by_root empno 최상위사번,
    level
from emp
start with job=upper('President')
connect by prior empno=mgr;

-- 계층적 질의문 응용 - connect_by_itleaf
select lpad(' ', 4*(level-1)) || ename 사원명,
    empno 사번,
    connect_by_isleaf Leaf_YN,
    level
from emp
start with job=upper('President')
connect by nocycle prior empno=mgr;

-- 계층적 질의문 응용 - sys_connect_by_path
select lpad(' ', 4*(level-1)) || ename 사원명,
    empno 사번,
    sys_connect_by_path(ename,'/') PATH,
    level
from emp
start with job=upper('President')
connect by nocycle prior empno=mgr;

select level,
    sys_connect_by_path(ename,'/') PATH
from emp
where connect_by_isleaf = 1
start with mgr is null
connect by prior empno=mgr;

-- 계층적 질의문 응용 - order siblings by
select lpad(' ', 4*(level-1)) || ename 사원명,
    ename ename2,
    empno 사번,
    level
from emp
start with job=upper('President')
connect by nocycle prior empno=mgr
order siblings by ename;

select lpad(' ', 4*(level-1)) || ename 사원명,
    ename ename2,
    empno 사번,
    level
from emp
start with job=upper('President')
connect by nocycle prior empno=mgr
order by ename;


/*************************************************************************
*                                PL/SQL
*************************************************************************/

/*                            PL/SQL의 개요                              */

-- parameter 타입 및 선언방법
create or replace function tax
(v_num in number)
return number
is
    v_tax number;
begin
    v_tax := v_num * 0.07;
    return(v_tax);
end;

create or replace procedure p_tax
(v_num in number,
v_tax out number)
is
begin
    v_tax := v_num * 0.07;
end;

-- PL/SQL 프로그램 실행
variable a number;
execute :a := tax(100);
print a;

CREATE TABLE S_EMP(
    id NUMBER(4) CONSTRAINT SEMP_EMP_PK PRIMARY KEY,
    name VARCHAR2(10),
    title   VARCHAR2(9),
    manager_id   NUMBER(4),
    start_date DATE,
    salary   NUMBER(7,2),
    commission_pct  NUMBER(7,2),
    dept_id NUMBER(2) CONSTRAINT SEMP_DEPTNO_FK REFERENCES DEPT
);

create sequence s_emp_id;

select name, salary, tax(salary)
from s_emp;

-- PL/SQL로 작성한 프로그램 예

create or replace procedure hire_emp
(v_name in s_emp.name%type,
v_title in s_emp.title%type,
v_manager_id in s_emp.manager_id%type,
v_salary in s_emp.salary%type)
is
    v_commission_pct s_emp.commission_pct%type;
    v_dept_id s_emp.dept_id%type;
begin
    if v_title like '%영업%' then
        v_commission_pct :=10;
    else
        v_commission_pct :=null;
    end if;
    select dept_id
    into v_dept_id
    from s_emp
    where id=v_manager_id;
    insert into s_emp(id, name, title, manager_id, start_date, salary, commission_pct, dept_id)
    values (s_emp_id.nextval, v_name, v_title, v_manager_id, sysdate, v_salary, v_commission_pct, v_dept_id);
    commit;
end;

