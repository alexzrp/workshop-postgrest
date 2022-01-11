do $$ 
<<outer_block>>
declare
  counter integer := 0;
begin
   counter := counter + 1;
   raise notice 'The current value of the counter is %', counter;

   declare
       counter integer := 0;
   begin
       counter := counter + 10;
       raise notice 'Counter in the subblock is %', counter;
       raise notice 'Counter in the outer block is %', outer_block.counter;
   end;

   raise notice 'Counter in the outer block is %', counter;
   
end outer_block $$;