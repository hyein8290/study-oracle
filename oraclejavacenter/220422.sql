/*************************************************************************
*                                PL/SQL
*************************************************************************/

/*                               변수 선언                               */

-- Composite Type 변수
-- 1. Table Type
/*
declare
    type name_table_type is table of s_emp.name%type
    index by binary_integer;
name_table name_table_type;
*/

/*
declare
    type name_table_type is table of s_emp%rowtype
    index by binary_integer;
emp_table emp_table_type;
*/

-- 2. Record Type
/*
declare
    type emp_record_type is record
    (id number(7),
    name varchar2(25),
    start_date date not null:=sysdate);
emp_ record emp_record_type;
*/

-- HOST 변수
variable b_avg number
accept b_math prompt 'Input math value : '
accept b_eng prompt 'Input english value : '
declare
    v_math number(9,2) := &b_math;
    v_eng number(9,2) := &b_eng;
begin
    :b_avg := (v_math + v_eng) / 2;
end;

print b_avg;


/*                         PL/SQL에서 SQL문 사용                              */
-- DML 사용
-- update
create or replace procedure up_credit(
    v_id in s_customer.id%type,
    v_credit in s_customer.credit_rating%type)
is begin
    update s_customer
    set credit_rating = v_credit
    where id = v_id;
    commit;
end;

select id, name ,credit_rating from s_customer;

execute up_credit(215, '우수');

select id, name ,credit_rating 
from s_customer
where id=215;

-- delete
create or replace procedure del_ord(
    v_ord_id s_item.ord_id%type)
is
begin
    delete from s_item
    where ord_id = v_ord_id;
    commit;
end;

-- insert
create or replace procedure in_emp(
    v_name in s_emp.name%type,
    v_sal in s_emp.salary%type,
    v_title in s_emp.title%type)
is
begin
    insert into s_emp(id, name, salary, title, start_date)
    values(s_emp_id.nextval, v_name, v_sal, v_title, sysdate);
end;

execute in_emp('김희동', 900, '사원');

select * from s_emp;

-- select
create or replace procedure show_emp
(
    v_id in s_emp.id%type
)
is 
    v_salary s_emp.salary%type;
    v_start_date s_emp.start_date%type;
begin
    select salary, start_date
    into v_salary, v_start_date
    from s_emp
    where id=v_id;
    dbms_output.put_line('급여:' || to_char(v_salary, '9,999,999'));
    dbms_output.put_line('입사일:' || to_char(v_start_date));
end;

set serverout on;

execute show_emp(4);


create or replace function sum_dept
(
    v_dept_id in s_emp.dept_id%type
)
return s_emp.salary%type
is 
    v_sum_salary s_emp.salary%type;
begin
    select sum(salary)
    into v_sum_salary
    from s_emp
    where dept_id=v_dept_id;
    return(v_sum_salary);
end;

variable a number;

execute :a:=sum_dept(10);

print a;


create or replace procedure show_dept
(
    v_id in s_dept.dept_id%type
)
is 
    v_dept s_dept.rowtype;
begin
    select *
    into v_dept
    from s_dept
    where dept_id=v_id;
    dbms_output.put_line('부서명:' || to_char(v_dept.name));
    dbms_output.put_line('지역번호:' || to_char(v_dept.region_id));
end;

execute show_dept(10);



/*************************************************************************
*                           PL/SQL Programming
*************************************************************************/

/*                             제어문의 종류                              */
-- IF문
create or replace procedure up_emp
(
    v_id in s_emp.id%type
)
is 
    v_title s_emp.title%type;
    v_pct number(2);
begin
    select title
    into v_title
    from s_emp
    where id=v_id;
    if v_title like '%영업%' then v_pct:=10;
    else v_pct:=5;
    end if;
    update s_emp
    set salary = salary+salary*v_pct/100
    where id = v_id;
    commit;
end;

select * from
s_dept
where name like '%영업%';

select id, name, dept_id, salary
from s_emp
where id=4;

execute up_emp(4);

select id, name, dept_id, salary
from s_emp
where id=4;


create or replace function tax
(
    v_id in s_emp.id%type
)
return number
is
    v_salary s_emp.salary%type;
begin
    select salary
    into v_salary
    from s_emp
    where id=v_id;
    if v_salary < 1000 then 
        return(v_salary*0.05);
    elsif v_salary < 2000 then 
        return(v_salary*0.07);
    elsif v_salary < 3000 then 
        return(v_salary*0.09);
    else
        return(v_salary*0.12);
    end if;
end;

variable a number;

execute :a :=tax(4)

print a

select id, name, salary, tax(id)
from s_emp;


-- LOOP문
declare
    v_count number(2):=1;
    v_star varchar2(10):=null;
begin
    loop
        v_star := v_star||'*';
        dbms_output.put_line(v_star);
        v_count:=v_count+1;
        exit when v_count > 10;
    end loop;
end;

-- FOR LOOP문
declare
    v_star varchar2(10):=null;
begin
    for i in 1..10 loop
        v_star := v_star||'*';
        dbms_output.put_line(v_star);
    end loop;
end;

-- WHILE LOOP문
declare
    v_count number(2):=1;
    v_star varchar2(10):=null;
begin
    while v_count <= 10 loop
        v_star := v_star||'*';
        dbms_output.put_line(v_star);
        v_count:=v_count+1;
    end loop;
end;


/*                               Exception                                 */

-- Exception 유형
-- 1. Predefined EXCEPTION

-- exception 처리 루틴 없는 경우
create or replace procedure show_emp
(
    v_salary in s_emp.salary%type
)
is
    v_name s_emp.name%type;
    v_sal s_emp.salary%type;
    v_title s_emp.title%type;
begin
    select name, salary, title
    into v_name, v_sal, v_title
    from s_emp
    where salary=v_salary;
    dbms_output.put_line(' 이 름 ' || ' 급 여 ' || ' 직 책 ');
    dbms_output.put_line('---------------------------------');
    dbms_output.put_line(v_name||v_sal||v_title);
end;

execute show_emp(5000);
execute show_emp(2400); --에러

-- exception 처리 루틴 있는 경우
create or replace procedure show_emp
(
    v_salary in s_emp.salary%type
)
is
    v_name s_emp.name%type;
    v_sal s_emp.salary%type;
    v_title s_emp.title%type;
begin
    select name, salary, title
    into v_name, v_sal, v_title
    from s_emp
    where salary=v_salary;
    dbms_output.put_line(' 이 름 ' || ' 급 여 ' || ' 직 책 ');
    dbms_output.put_line('---------------------------------');
    dbms_output.put_line(v_name||' ' || v_sal|| ' ' || v_title);
    exception
    when no_data_found then
        dbms_output.put_line('ERROR!! - 해당 급여를 받는 사원이 없습니다');
    when too_many_rows then
        dbms_output.put_line('ERROR!! - 해당 급여를 받는 사원이 너무 많습니다');
end;

execute show_emp(5000);
execute show_emp(2400);
execute show_emp(3000);


-- 2. Non-Predefined EXCEPTION
create or replace procedure del_product
(
    v_id in s_product.id%type
)
is
    fk_error exception;
    pragma exception_init(fk_error, -2292);
begin
    delete from s_product
    where id=v_id;
    commit;
exception
    when fk_error then
    rollback;
    dbms_output.put_line('참조되는 child record가 있으므로 삭제할 수 없습니다.');
end;

execute del_product(50530);

-- 3. User Predefined EXCEPTION
create or replace procedure in_emp
(
    v_name in s_emp.name%type,
    v_sal in s_emp.salary%type,
    v_title in s_emp.title%type,
    v_comm in s_emp.commission_pct%type
)
is
    v_id s_emp.id%type;
    lowsal_err EXCEPTION;
begin
    select max(id)+1
    into v_id
    from s_emp;
    if v_sal >= 600 then
        insert into s_emp(id, name, salary, title, commission_pct, start_date)
        values(v_id, v_name, v_sal, v_title, v_comm, sysdate);
    else
        raise lowsal_err;
    end if;
    exception
    when lowsal_err then
        dbms_output.put_line('ERROR!! - 지정한 급여가 너무 적습니다. 600이상으로 다시 입력하세요.');
end;

execute in_emp('김흥국', 500, '과장', 12.5);
execute in_emp('김흥국', 900, '과장', 12.5);


-- SQLCODE, SQLERRM
execute in_emp('이한이', 1200, '사원', 1500); --ORA-02290: 체크 제약조건(SCOTT.S_EMP_COMMISSION_PCT_CK)이 위배되었습니다

select constraint_name, constraint_type, search_condition
from user_constraints
where table_name='S_EMP';

create or replace procedure in_emp
(
    v_name in s_emp.name%type,
    v_sal in s_emp.salary%type,
    v_title in s_emp.title%type,
    v_comm in s_emp.commission_pct%type
)
is
    v_id s_emp.id%type;
    lowsal_err EXCEPTION;
    v_code number;
    v_message varchar2(100);
begin
    select max(id)+1
    into v_id
    from s_emp;
    if v_sal >= 600 then
        insert into s_emp(id, name, salary, title, commission_pct, start_date)
        values(v_id, v_name, v_sal, v_title, v_comm, sysdate);
    else
        raise lowsal_err;
    end if;
    exception
    when lowsal_err then
        dbms_output.put_line('ERROR!! - 지정한 급여가 너무 적습니다. 600이상으로 다시 입력하세요.');
    when others then
        v_code := SQLCODE;
        v_message := SQLERRM;
    dbms_output.put_line('에러코드 =>'||v_code);
    dbms_output.put_line('에러메시지 =>'||v_message);
end;

execute in_emp('이한이', 1200, '사원', 1500);



/*                                Cursor                                  */

-- Implicit CURSOR
create or replace procedure del_ord
(
    v_ord_id s_item.ord_id%type
)
is
begin
    delete from s_item
    where ord_id = v_ord_id;
    if sql%found then
        dbms_output.put_line(to_char(sql%rowcount, '9,999') || '개의 행이 삭제되었습니다.');
    else
        dbms_output.put_line('해당되는 주문번호의 주문내역이 없습니다.');
    end if;
end;

execute del_ord(110);

-- Explicit CURSOR
create or replace procedure show_ordtotal
(   
    v_ord_id in s_item.ord_id%type
)
is
    v_product_id s_item.product_id%type;
    v_item_total number(11,2);
    v_total number(11,2) := 0;
cursor ordtotal_cursor is
    select product_id, price*quantity
    from s_item
    where ord_id = v_ord_id;
begin
    open ordtotal_cursor;
    loop
        fetch ordtotal_cursor into v_product_id, v_item_total;
        exit when ordtotal_cursor%notfound;
        dbms_output.put_line(to_char(v_product_id, '9999999') || ' ' || to_char(v_item_total, '9,999,999'));
        v_total:=v_total+v_item_total;
    end loop;
    dbms_output.put_line('총금액:' || to_char(v_total, '999,999,999.99'));
    close ordtotal_cursor;
end;

execute show_ordtotal(109);


create or replace procedure show_emp
is
cursor emp_cursor is
    select name, salary, title
    from s_emp;
v_name s_emp.name%type;
v_title s_emp.title%type;
v_sal s_emp.salary%type;
begin
    open emp_cursor;
    dbms_output.put_line(' 이 름 ' || ' 급 여 ' || ' 직 책 ');
    dbms_output.put_line('---------------------------------');
    loop
        fetch emp_cursor into v_name, v_sal, v_title;
        exit when emp_cursor%notfound;
        dbms_output.put_line(v_name||' ' || v_sal|| ' ' || v_title);
    end loop;
    dbms_output.put_line(emp_cursor%rowcount || '개의 행이 선택되었습니다');
    close emp_cursor;
end;

execute show_emp;

-- cursor for loop
create or replace procedure show_emp
is
cursor emp_cursor is
    select name, salary, title
    from s_emp;
begin
    dbms_output.put_line(' 이 름 ' || ' 급 여 ' || ' 직 책 ');
    dbms_output.put_line('---------------------------------');
    for emp_record in emp_cursor loop
        dbms_output.put_line(emp_record.name||' ' || emp_record.salary|| ' ' || emp_record.title);
    end loop;
end;

execute show_emp;


create or replace procedure show_emp
is
begin
    dbms_output.put_line(' 이 름 ' || ' 급 여 ' || ' 직 책 ');
    dbms_output.put_line('---------------------------------');
    for emp_record in (select name, salary, title from s_emp) loop
        dbms_output.put_line(emp_record.name||' ' || emp_record.salary|| ' ' || emp_record.title);
    end loop;
end;
