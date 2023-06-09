/* Naive title queries */
select title from movies where title like '%star wars%' -- :( No results

select title from movies where title like '%star%' or title like '%wars%' -- :( More results, but still not Star Wars ??

-- Oh no like is case sensitive
select title from movies where title ilike '%star%' or title ilike '%wars%' -- :( Even more results, and Star Wars but where is it?

-- Help me tsvector you are my only hope
select to_tsvector('I Am Altering The Deal. Pray I Don''t Alter It Any Further!');

-- Let's do that to some of our titles
select to_tsvector(title), title from movies limit 20;

-- So maybe we can query that with to_tsquery
select title 
from movies
where to_tsvector(title) @@ to_tsquery('Star') -- :| OK

-- And can we rank the results perhaps?
select title, ts_rank(to_tsvector(title), to_tsquery('Star')) as rank
from movies
where to_tsvector(title) @@ to_tsquery('star') -- :/ Interesting

-- So let's find star wars 🎉
select title, ts_rank(to_tsvector(title), to_tsquery('star wars')) as rank
from movies
where to_tsvector(title) @@ to_tsquery('star wars') -- :( Oh come on!

-- Better error messages would be nice but hey ...
select title, ts_rank(to_tsvector(title), plainto_tsquery('star wars')) as rank
from movies
where to_tsvector(title) @@ plainto_tsquery('star wars')
order by rank desc -- :) OK that's cool

-- I want to search like google though
select title, ts_rank(to_tsvector(title), websearch_to_tsquery('"star wars" -clone')) as rank
from movies
where to_tsvector(title) @@ websearch_to_tsquery('"star wars" -clone')
order by rank desc -- :) No more clone wars

-- What if you love clone wars ...
select title, ts_rank(to_tsvector(title), websearch_to_tsquery('"star wars" +clone')) as rank
from movies
where to_tsvector(title) @@ websearch_to_tsquery('"star wars" +clone')
order by rank desc -- :) Only clone wars

-- What if I need to query multiple columns? 
select to_tsvector(title), to_tsvector(original_title)
from movies -- :( I don't want to query them separately though

-- Let's concatenate them 
select to_tsvector(title) || ' ' || to_tsvector(original_title)
from movies -- :| Oops, just remembered I need to weight them

-- Set weights
select setweight(to_tsvector(title), 'A') || ' ' || setweight(to_tsvector(original_title), 'B')
from movies -- :\ Better, but how am I going to query this?

-- Well we could store the weighted vectors in a column
--
-- alter table movies add title_search tsvector;
-- update movies set title_search = 
-- 	setweight(to_tsvector(title), 'A') || ' ' || setweight(to_tsvector(original_title), 'B')
--
-- We're not going to though because running this would take too long and how do we keep the column
-- up to date ... with triggers? Yuck ... 🤢

-- Postgres is, once again, going to show how awesome it is now
-- alter table movies drop title_search;
alter table movies 
add title_search tsvector 
generated always as	(
	setweight(to_tsvector('simple', coalesce(title, '')), 'A') || ' ' || 
	setweight(to_tsvector('simple', coalesce(original_title, '')), 'B') :: tsvector
) stored; 

-- Does that mean I've got a new search column I can query that's always up to date
select title, original_title, ts_rank(title_search, websearch_to_tsquery('hero')) as rank
from movies
where title_search @@ websearch_to_tsquery('hero')
order by rank desc
-- :) Why yes it does, if only we could make this fast 

-- Like with some kind of special index optimised for vectors
create index idx_search on movies using GIN(title_search)

-- Is this fast enough?
-- Remember we're querying multiple columns with full text search, weighting and web search features
select title, ts_rank(title_search, websearch_to_tsquery('rush')) as rank
from movies
where title_search @@ websearch_to_tsquery('rush')
order by rank desc -- :)))))))

-- And now let's rank based on the length of the document (normalization yay https://www.postgresql.org/docs/current/textsearch-controls.html#TEXTSEARCH-RANKING)
select title, ts_rank(title_search, websearch_to_tsquery('rush'), 1) as rank
from movies
where title_search @@ websearch_to_tsquery('rush')
order by rank desc

-- THE END
