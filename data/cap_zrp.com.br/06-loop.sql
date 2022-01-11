-- Fibonacci
do $$
declare
   n integer:= 10;
   fib integer := 0;
   counter integer := 0 ; 
   i integer := 0 ; 
   j integer := 1 ;
begin
	if (n < 1) then
		fib := 0 ;
	end if; 
	loop 
		exit when counter = n ; 
		counter := counter + 1 ; 
		select j, i + j into i,	j ;
	end loop; 
	fib := i;
    raise notice '%', fib; 
end; $$