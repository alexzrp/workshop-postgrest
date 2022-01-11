do $$ 
declare
   film_title film.title%type;
   featured_title film_title%type;
begin 
   -- get title of the film id 100
   select title
   from film
   into film_title
   where film_id = 100;
   
   -- show the film title
   raise notice 'Film title id 100: %s', film_title;
end; $$