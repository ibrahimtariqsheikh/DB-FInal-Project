--Trigger to update the paintings availability

create or replace NONEDITIONABLE TRIGGER Update_painting_availability
BEFORE INSERT
ON RENTAL_REPORT  
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE 
BEGIN  

UPDATE PAINTINGS SET AVAILABLE='N' WHERE PAINTING_ID=:new.painting_id;

END; 

--Trigger to update the customers category

create or replace NONEDITIONABLE TRIGGER UPDATE_CATEGORY
AFTER INSERT
ON RENTAL_REPORT  
REFERENCING OLD AS old NEW AS new
FOR EACH ROW
DECLARE 
number_of_hires number;
BEGIN  

select count(customer_no) into number_of_hires from rental_report group by customer_no having customer_no=:new.customer_no;

IF number_of_hires>=5 AND number_of_hires<10 THEN
    UPDATE Customer set category_id='S' where customer_no=:new.customer_no;
ELSIF number_of_hires>=10 and number_of_hires<15 THEN
    UPDATE Customer set category_id='G' where customer_no=:new.customer_no;
ELSIF number_of_hires>15 THEN
    UPDATE Customer set category_id='P' where customer_no=:new.customer_no;
ELSE 
UPDATE Customer set category_id='B' where customer_no=:new.customer_no;
END IF;

END;

--Trigger to pay to the owner

create or replace NONEDITIONABLE TRIGGER pay_to_owner
AFTER INSERT ON rental_report
FOR EACH ROW
DECLARE
painting_price PAINTINGS.rental_price % type;
customer_discount CATEGORY.category_discount % type;
o_owner_id Owner.owner_id % type;
new_owner_payment owner.owner_fee % type;
old_owner_payment owner.owner_fee % type;
hire_date rental_report.hire_date % type;
return_back_date rental_report.due_date_back % type;
total_months int;

BEGIN
select RENTAL_PRICE INTO painting_price from PAINTINGS where painting_id = :NEW.painting_id;

select cat.category_discount INTO customer_discount from CUSTOMER c inner join CATEGORY cat ON cat.category_id = c.category_id
WHERE c.customer_no = :NEW.customer_no;

hire_date := :NEW.hire_date;
return_back_date := :NEW.due_date_back;
total_months := CEIL(months_between(return_back_date,hire_date));
dbms_output.put_line(total_months);

select o.owner_id,o.owner_fee into o_owner_id,old_owner_payment from paintings p inner join owner o on p.owner_id = o.owner_id where p.painting_id = :NEW.painting_id;

new_owner_payment := (painting_price - (painting_price * (customer_discount/100)) )/10;

new_owner_payment := (new_owner_payment * total_months) + old_owner_payment;

update owner set owner_fee=new_owner_payment where owner.owner_id=o_owner_id;

END;

--Trigger to maintin the paintings rental return table

create or replace NONEDITIONABLE TRIGGER bu_check_6_months_and_add_to_return_table
AFTER UPDATE
OF RETURN_STATUS
ON RENTAL_REPORT
DECLARE 
CURSOR c_cursor IS select p.painting_id as p_id,max(r.due_date_back) as return_date from paintings p inner join rental_report r on p.painting_id=r.painting_id where
months_between(sysdate,due_date_back)>6 group by p.painting_id;
CURSOR del_old_values_cursor IS SELECT * FROM PAINTINGS_RENTED;
CURSOR c_not_in_rental IS SELECT PAINTING_ID FROM PAINTINGS MINUS
SELECT PAINTING_ID FROM RENTAL_REPORT MINUS SELECT PAINTING_ID FROM PAINTINGS_RENTED;
insert_date PAINTINGS.DATE_ADDED%type;
BEGIN  

<< outer_loop >>
FOR rec_1 in c_cursor LOOP
<< inner_loop>>
FOR rec_2 in del_old_values_cursor LOOP
IF rec_1.p_id=rec_2.painting_id THEN
DELETE FROM PAINTINGS_RENTED WHERE painting_id=rec_2.painting_id;
END IF;
end loop inner_loop;
end loop outer_loop;


FOR rec_not_in_ren in c_not_in_rental LOOP

SELECT DATE_ADDED INTO INSERT_DATE FROM PAINTINGS WHERE PAINTING_ID=REC_NOT_IN_REN.PAINTING_ID;
IF (MONTHS_BETWEEN(SYSDATE,INSERT_DATE)>6) THEN
INSERT INTO PAINTINGS_RENTED VALUES (rec_not_in_ren.painting_id,SYSDATE);
UPDATE PAINTINGS SET AVAILABLE='N' WHERE painting_id=rec_not_in_ren.painting_id;
END IF;
END LOOP;

FOR rec in c_cursor loop
INSERT INTO PAINTINGS_RENTED VALUES (rec.p_id,rec.return_date);
UPDATE PAINTINGS SET AVAILABLE='N' WHERE painting_id=rec.p_id;
end loop;
END;