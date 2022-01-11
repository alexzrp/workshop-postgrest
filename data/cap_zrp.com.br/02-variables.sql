do $$ 
declare
   counter    integer := 1;
   first_name varchar(50) := 'John';
   last_name  varchar(50) := 'Doe';
   payment    numeric(11,2) := 20.5;
begin 
   raise notice '% % % has been paid % USD', 
       counter, 
	   first_name, 
	   last_name, 
	   payment;
end $$;