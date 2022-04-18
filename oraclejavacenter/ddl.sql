
rem  실습 스크립트
rem  CONNECT SCOTT/TIGER

DROP TABLE EMP;
DROP TABLE DEPT;
DROP TABLE BONUS;
DROP TABLE SALGRADE;

CREATE TABLE DEPT
        (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
         DNAME VARCHAR2(14),
	 LOC   VARCHAR2(13) ) ;
CREATE TABLE EMP
        (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	 ENAME VARCHAR2(10),
 	 JOB   VARCHAR2(9),
	 MGR   NUMBER(4),
	 HIREDATE DATE,
	 SAL   NUMBER(7,2),
	 COMM  NUMBER(7,2),
	 DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);
CREATE TABLE BONUS
	(ENAME VARCHAR2(10),
	 JOB   VARCHAR2(9),
	 SAL   NUMBER,
	 COMM  NUMBER) ;
CREATE TABLE SALGRADE
        (GRADE NUMBER,
	 LOSAL NUMBER,
	 HISAL NUMBER );

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',    7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',  7698,to_date('22-2-1981', 'dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',  7839,to_date('2-4-1981',  'dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981', 'dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',  7839,to_date('1-5-1981',  'dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',  7839,to_date('9-6-1981',  'dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',  7566,to_date('13-07-1987', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981',  'dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',    7788,to_date('13-07-1987', 'dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',    7698,to_date('3-12-1981', 'dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',   7566,to_date('3-12-1981', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',   7782,to_date('23-1-1982', 'dd-mm-yyyy'),1300,NULL,10);

INSERT INTO SALGRADE VALUES (1, 700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

COMMIT;
rem EXIT




alter session set nls_language='AMERICAN'; 

/*************************************************************************
* 기존에 저장되 있는 STUDENT, PROFESSOR, DEPARTMENT, SALGRADE 테이블 삭제
*************************************************************************/

DROP TABLE STUDENT;
DROP TABLE PROFESSOR;
DROP TABLE DEPARTMENT;
DROP TABLE SALGRADE;


/*************************************************************************
*                         STUDNET 테이블 생성
*************************************************************************/
CREATE TABLE STUDENT
        (STUDNO NUMBER(5),
         NAME VARCHAR2(10),
         USERID varchar2(10),
         GRADE VARCHAR2(1),
         IDNUM VARCHAR2(13),
         BIRTHDATE DATE,
         TEL VARCHAR2(13),
         HEIGHT NUMBER(5,2),
         WEIGHT NUMBER(5,2),
         DEPTNO NUMBER(4),
         PROFNO NUMBER(4));


/*************************************************************************
*                        STUDNET 테이블 데이터 입력
*************************************************************************/
INSERT INTO STUDENT VALUES
        (10101, '전인하', 'jun123', '4', '7907021369824',
        TO_DATE('02-JUL-1979','DD-MON-YYYY'), '051)781-2158', 176, 72, '101',9903);

INSERT INTO STUDENT VALUES
        (20101, '이동훈', 'Dals', '1', '8312101128467',
         TO_DATE('10-DEC-1983','DD-MON-YYYY'), '055)426-1752', 172, 64, '201',NULL);

INSERT INTO STUDENT VALUES
        (10102, '박미경', 'ansel414', '1', '8405162123648',
        TO_DATE('16-MAY-1984','DD-MON-YYYY'), '055)261-8947', 168, 52, '101',NULL);

INSERT INTO STUDENT VALUES
        (10103, '김영균', 'mandu', '3', '8103211063421',
        TO_DATE('11-JAN-1981','DD-MON-YYYY'), '051)824-9637', 170, 88 ,'101',9906);

INSERT INTO STUDENT VALUES
        (20102, '박동진', 'Ping2', '1', '8511241639826',
        TO_DATE('24-NOV-1985','DD-MON-YYYY'), '051)742-6384', 182, 70, '201',NULL);

INSERT INTO STUDENT VALUES
        (10201, '김진영', 'simply', '2', '8206062186327',
        TO_DATE('06-JUN-1982','DD-MON-YYYY'), '055)419-6328', 164, 48, '102',9905);
INSERT INTO STUDENT VALUES
        (10104, '지은경', 'Gomo00', '2', '8004122298371',
        TO_DATE('12-APR-1980','DD-MON-YYYY'), '055)418-9627', 161, 42, '101',9907);

INSERT INTO STUDENT VALUES
        (10202, '오유석', 'yousuk', '4', '7709121128379',
        TO_DATE('12-OCT-1977','DD-MON-YYYY'), '051)724-9618', 177, 92, '102',9905);

INSERT INTO STUDENT VALUES
        (10203, '하나리', 'hanal', '1', '8501092378641',
        TO_DATE('18-DEC-1984','DD-MON-YYYY'), '055)296-3784', 160, 68, '102',NULL);

INSERT INTO STUDENT VALUES
        (10105, '임유진', 'YouJin12', '2', '8301212196482',
        TO_DATE('21-JAN-1983','DD-MON-YYYY'), '02)312-9838', 171, 54, '101',9907);

INSERT INTO STUDENT VALUES
        (10106, '서재진', 'seolly', '1', '8511291186273',
        TO_DATE('29-NOV-1985','DD-MON-YYYY'), '051)239-4861', 186, 72, '101',NULL);

INSERT INTO STUDENT VALUES
        (10204, '윤진욱', 'Samba7', '3', '7904021358671',
        TO_DATE('02-APR-1979','DD-MON-YYYY'), '053)487-2698', 171, 70, '102',9905);
 
INSERT INTO STUDENT VALUES
        (10107, '이광훈', 'huriky', '4', '8109131276431',
        TO_DATE('13-OCT-1981','DD-MON-YYYY'), '055)736-4981', 175, 92, '101',9903);

INSERT INTO STUDENT VALUES
        (20103, '김진경', 'lovely', '2', '8302282169387',
        TO_DATE('28-FEB-1983','DD-MON-YYYY'), '052)175-3941', 166, 51, '201',9902);

INSERT INTO STUDENT VALUES
        (20104, '조명훈', 'Rader214', '1', '8412141254963',
        TO_DATE('16-SEP-1984','DD-MON-YYYY'), '02)785-6984', 184, 62, '201',NULL);

INSERT INTO STUDENT VALUES
        (10108, '류민정', 'cleanSky', '2', '8108192157498',
        TO_DATE('19-AUG-1981','DD-MON-YYYY'), '055)248-3679', 162, 72, '101',9907);

 

/*************************************************************************
*                         PROFESSOR 테이블 생성
*************************************************************************/
CREATE TABLE PROFESSOR
        (PROFNO NUMBER(4),
         NAME VARCHAR2(10),
         USERID VARCHAR2(10),
         POSITION VARCHAR2(20),
         SAL NUMBER(10),
         HIREDATE DATE,
         COMM NUMBER(2),
         DEPTNO NUMBER(4));


/*************************************************************************
*                        ROFESSOR 테이블 데이터 입력
*************************************************************************/
INSERT INTO PROFESSOR VALUES
        (9901, '김도훈', 'capool', '교수', 500,
        TO_DATE('24-JUN-1982','DD-MON-YYYY'), 20, 101);

INSERT INTO PROFESSOR VALUES
        (9902, '이재우', 'sweat413', '조교수', 320,
        TO_DATE('12-APR-1995','DD-MON-YYYY'), NULL, 201);

INSERT INTO PROFESSOR VALUES
        (9903, '성연희', 'Pascal', '조교수', 360,
        TO_DATE('17-MAY-1993','DD-MON-YYYY'), 15, 101);

INSERT INTO PROFESSOR VALUES
        (9904, '염일웅', 'Blue77', '전임강사', 240,
        TO_DATE('02-DEC-1998','DD-MON-YYYY'), NULL, 102);

INSERT INTO PROFESSOR VALUES
        (9905, '권혁일', 'refresh', '교수', 450,
        TO_DATE('08-JAN-1986','DD-MON-YYYY'), 25, 102);

INSERT INTO PROFESSOR VALUES
        (9906, '이만식', 'Pocari', '부교수', 420,
        TO_DATE('13-SEP-1988','DD-MON-YYYY'), NULL, 101);

INSERT INTO PROFESSOR VALUES
        (9907, '전은지', 'totoro', '전임강사', 210,
        TO_DATE('01-JUN-2001','DD-MON-YYYY'), NULL, 101);

INSERT INTO PROFESSOR VALUES
        (9908, '남은혁', 'Bird13', '부교수', 400,
        TO_DATE('18-NOV-1990','DD-MON-YYYY'), 17, 202);


/*************************************************************************
*                          DEPARTMENT 테이블 생성
*************************************************************************/
CREATE TABLE DEPARTMENT
        (DEPTNO NUMBER(4),
         DNAME VARCHAR2(24),
         COLLEGE NUMBER(4),
         LOC VARCHAR2(10));

/*************************************************************************
*                        DEPARTMENT 테이블 데이터 입력
*************************************************************************/
INSERT INTO DEPARTMENT VALUES
        (101, '컴퓨터공학과', 100, '1호관');

INSERT INTO DEPARTMENT VALUES
        (102, '멀티미디어학과', 100, '2호관');

INSERT INTO DEPARTMENT VALUES
        (201, '전자공학과', 200, '3호관');

INSERT INTO DEPARTMENT VALUES
        (202, '기계공학과', 200, '4호관');

INSERT INTO DEPARTMENT VALUES
        (100, '정보미디어학부', 10, NULL);

INSERT INTO DEPARTMENT VALUES
        (200, '메카트로닉스학부', 10, NULL);

INSERT INTO DEPARTMENT VALUES
        (10, '공과대학', NULL, NULL);


/*************************************************************************
*                          SALGRADE 테이블 생성
*************************************************************************/
CREATE TABLE SALGRADE
        (GRADE NUMBER(2),
         LOSAL NUMBER(5),
         HISAL NUMBER(5));

/*************************************************************************
*                         SALGRADE 테이블 데이터 입력
*************************************************************************/
INSERT INTO SALGRADE VALUES (1, 100, 300);
INSERT INTO SALGRADE VALUES (2, 301, 400);
INSERT INTO SALGRADE VALUES (3, 401, 500);

COMMIT;



