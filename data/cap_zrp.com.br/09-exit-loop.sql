do
$$
declare 
   i int = 0;
   j int = 0;
begin
  <<outer_loop>>
  loop 
     i = i + 1;
     exit when i > 3;
	 -- inner loop
	 j = 0;
     <<inner_loop>>
     loop 
		j = j + 1;
		exit outer_loop when j > 3;
		raise notice '(i,j): (%,%)', i, j;
	 end loop inner_loop;
  end loop outer_loop;
end;
$$