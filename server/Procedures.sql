-- adding in tables

create or replace NONEDITIONABLE PROCEDURE add_artist
(
no IN Artist.artist_id%type,
a_name IN Artist.artist_name%type,
a_country_of_birth IN Artist.country_of_birth%type,
a_year_of_birth IN Artist.year_of_birth%type,
a_year_of_death IN Artist.year_of_death%type
)
IS
BEGIN
   INSERT INTO Artist values(no,a_name,a_country_of_birth,a_year_of_birth,a_year_of_death);
END;

create or replace NONEDITIONABLE PROCEDURE add_customer
(
no IN customer.customer_no%type,
c_name IN customer.customer_name%type,
c_address IN customer.customer_address%type
)
IS
BEGIN
   INSERT INTO customer values(no,c_name,c_address,'B');
END;

create or replace NONEDITIONABLE PROCEDURE add_owner
(
no IN Owner.owner_id%type,
o_name IN Owner.owner_name%type,
o_address IN Owner.owner_adress%type,
o_tel IN Owner.owner_tel%type,
o_fee IN Owner.owner_fee%type DEFAULT 0
)
IS
BEGIN
   INSERT INTO Owner values(no,o_name,o_address,o_tel,o_fee);
END;

create or replace NONEDITIONABLE PROCEDURE add_painting
(
p_id IN Paintings.painting_id%type,
p_title IN Paintings.painting_title%type,
p_theme IN Paintings.theme%type,
p_rental_price IN Paintings.rental_price%type,
p_artist_id IN Paintings.artist_id%type,
p_owner_id IN Paintings.owner_id%type,
p_available IN Paintings.available%type DEFAULT 'Y',
p_date_added IN Paintings.date_added%type DEFAULT SYSDATE
)
IS
BEGIN
   INSERT INTO Paintings values(p_id ,
p_title,
p_theme,
p_rental_price,
p_artist_id,
p_owner_id,
p_available,
p_date_added
);
END;

create or replace NONEDITIONABLE PROCEDURE add_rental
(
customer_no IN Rental_report.customer_no%type,
painting_id IN Rental_report.painting_id%type,
due_date_back IN Rental_report.due_date_back%type
)
IS
p_available paintings.available%type;
BEGIN
INSERT INTO Rental_report values(customer_no ,
painting_id,
SYSDATE,
due_date_back,
'N');
END;

create or replace NONEDITIONABLE PROCEDURE add_to_rental_table IS
CURSOR c_cursor IS select p.painting_id as p_id from paintings p inner join rental_report r on p.painting_id=r.painting_id where
months_between(sysdate,due_date_back)>6 group by p.painting_id;
BEGIN  
FOR rec in c_cursor loop

INSERT INTO PAINTINGS_RENTED VALUES (rec.p_id,SYSDATE);
UPDATE PAINTINGS SET AVAILABLE='N' WHERE painting_id=rec.p_id;

end loop;
END; 

create or replace NONEDITIONABLE PROCEDURE get_artist_info
(
no IN Varchar2,
a_name OUT artist.artist_name%type,
a_country_of_birth OUT artist.country_of_birth%type,
a_year_of_birth OUT artist.year_of_birth%type,
a_year_of_death OUT artist.year_of_death%type
)
IS
BEGIN
select 
artist_name,
country_of_birth,
year_of_birth,
year_of_death
INTO
a_name,
a_country_of_birth,
a_year_of_birth,
a_year_of_death
FROM Artist where artist_id=no;
END;

create or replace NONEDITIONABLE PROCEDURE GET_ARTIST_REPORT(a_no IN Artist.artist_id%type)
IS
c1 SYS_REFCURSOR;
c2 SYS_REFCURSOR;
BEGIN
OPEN c1 FOR select * from artist WHERE artist_id=a_no;
OPEN c2 FOR select p.PAINTING_ID,p.PAINTING_TITLE,p.THEME,p.RENTAL_PRICE,o.OWNER_ID,o.OWNER_NAME,o.OWNER_TEL  from paintings p inner join owner o on o.owner_id=p.owner_id WHERE artist_id=a_no; 
DBMS_SQL.RETURN_RESULT(c1);
DBMS_SQL.RETURN_RESULT(c2); 
END;

create or replace NONEDITIONABLE PROCEDURE get_customer_info
(
no IN Varchar2,
c_name OUT customer.customer_name%type,
c_address OUT customer.customer_address%type,
c_category_id OUT customer.category_id%type,
c_category_description OUT category.category_description%type,
c_category_discount OUT category.category_discount%type
)
IS
BEGIN

select 
cus.customer_name,
cus.customer_address,
cat.category_id,
cat.category_description,
cat.category_discount
INTO
c_name,
c_address,
c_category_id,
c_category_description,
c_category_discount
from customer cus inner join category cat on cus.category_id = cat.category_id
where cus.customer_no=no;
END;

create or replace NONEDITIONABLE PROCEDURE get_customer_rental(c_no IN Rental_report.customer_no%type)
IS
c1 SYS_REFCURSOR;
c2 SYS_REFCURSOR;
BEGIN
OPEN c1 FOR select cus.CUSTOMER_NO,cus.CUSTOMER_NAME,cus.CUSTOMER_ADDRESS,cus.CATEGORY_ID,cat.CATEGORY_DISCOUNT,cat.CATEGORY_DESCRIPTION from customer cus inner join category cat on cus.category_id = cat.category_id where cus.customer_no=c_no;
OPEN c2 FOR select p.PAINTING_ID,p.PAINTING_TITLE,p.THEME,r.HIRE_DATE,r.DUE_DATE_BACK,r.RETURN_STATUS,p.RENTAL_PRICE,p.ARTIST_ID,p.OWNER_ID  from customer c inner join rental_report r on c.customer_no=r.customer_no inner join paintings p on p.painting_id=r.painting_id where c.customer_no=c_no;
DBMS_SQL.RETURN_RESULT(c1);
DBMS_SQL.RETURN_RESULT(c2);  
END;

create or replace NONEDITIONABLE PROCEDURE get_owner_info
(
no IN varchar2,
o_name OUT Owner.owner_name%type,
o_address OUT Owner.owner_adress%type
)
IS
BEGIN
select 
owner_name,
owner_adress
INTO
o_name,
o_address
FROM Owner where owner_id=no;
END;

create or replace NONEDITIONABLE PROCEDURE get_painting_info
(
p_id IN Varchar2,
p_title OUT Paintings.painting_title%type,
p_theme OUT Paintings.theme%type,
p_rental_price OUT Paintings.rental_price%type,
p_artist_id OUT Paintings.artist_id%type,
p_owner_id OUT Paintings.owner_id%type
)
IS
BEGIN
select 
    painting_title,
    theme,
    rental_price,
    artist_id,
    owner_id
INTO
p_title,
p_theme,
p_rental_price,
p_artist_id,
p_owner_id
FROM Paintings where painting_id=p_id;
END;

create or replace NONEDITIONABLE PROCEDURE RETURN_PAINTING(
p_no IN RENTAL_REPORT.painting_id%type
)
IS 
BEGIN
UPDATE RENTAL_REPORT SET RETURN_STATUS='Y' where painting_id=p_no;
UPDATE PAINTINGS SET AVAILABLE = 'Y' where painting_id=p_no;
END;

create or replace NONEDITIONABLE PROCEDURE RETURN_TO_OWNER_REPORT(o_no IN Owner.owner_id%type)
IS
c1 SYS_REFCURSOR;
c2 SYS_REFCURSOR;
BEGIN
OPEN c1 FOR select * from owner WHERE owner_id=o_no;
OPEN c2 FOR select pr.painting_id,p.painting_title,pr.return_date from paintings_rented pr inner join paintings p on pr.painting_id=p.painting_id
where p.owner_id=o_no;
DBMS_SQL.RETURN_RESULT(c1);
DBMS_SQL.RETURN_RESULT(c2); 
END;

create or replace NONEDITIONABLE PROCEDURE UPDATE_ARTIST
(
a_no IN Artist.ARTIST_ID%type,
a_name IN Artist.ARTIST_NAME%type,
a_cob IN Artist.COUNTRY_OF_BIRTH%type,
a_yob IN Artist.COUNTRY_OF_BIRTH%type,
a_yod IN Artist.COUNTRY_OF_BIRTH%type
)
IS
BEGIN

UPDATE Artist SET ARTIST_NAME = a_name WHERE Artist_id=a_no;
UPDATE Artist SET COUNTRY_OF_BIRTH = a_cob WHERE Artist_id=a_no;
UPDATE Artist SET YEAR_OF_BIRTH = a_yob WHERE Artist_id=a_no;
UPDATE Artist SET YEAR_OF_DEATH = a_yod WHERE Artist_id=a_no;

END;

create or replace NONEDITIONABLE PROCEDURE UPDATE_CUSTOMER
(
c_no IN Customer.customer_no%type,
c_name IN Customer.customer_name%type,
c_address IN Customer.customer_address%type
)
IS
BEGIN

UPDATE CUSTOMER SET CUSTOMER_NAME = c_name WHERE CUSTOMER_NO=c_no;
UPDATE CUSTOMER SET CUSTOMER_ADDRESS = c_address WHERE CUSTOMER_NO=c_no;

END;

create or replace NONEDITIONABLE PROCEDURE UPDATE_OWNER
(
o_no IN OWNER.OWNER_ID%type,
o_name IN OWNER.OWNER_NAME%type,
o_address IN OWNER.OWNER_ADRESS%type,
o_tel IN OWNER.OWNER_TEL%type
)
IS
BEGIN

UPDATE OWNER SET OWNER_NAME = o_name WHERE OWNER_ID=o_no;
UPDATE OWNER SET OWNER_ADRESS = o_address WHERE OWNER_ID=o_no;
UPDATE OWNER SET OWNER_TEL = o_tel WHERE OWNER_ID=o_no;

END;

create or replace NONEDITIONABLE PROCEDURE UPDATE_PAINTING
(
p_no IN PAINTINGS.PAINTING_ID%type,
p_title IN PAINTINGS.PAINTING_TITLE%type,
p_theme IN PAINTINGS.THEME%type,
p_rental_price IN PAINTINGS.RENTAL_PRICE%type,
p_artist_id IN PAINTINGS.ARTIST_ID%type,
p_owner_id IN PAINTINGS.OWNER_ID%type
)
IS
BEGIN

create or replace PROCEDURE RESUBMIT_PAINTING(
p_no IN PAINTINGS_RENTED.painting_id%type
)
IS 
BEGIN
UPDATE PAINTINGS SET AVAILABLE='Y' where painting_id=p_no;
DELETE FROM PAINTINGS_RENTED WHERE PAINTING_ID=p_no;
END;