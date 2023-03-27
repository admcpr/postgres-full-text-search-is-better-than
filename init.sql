-- create the movies table
CREATE TABLE movies(
  id INT PRIMARY KEY,
  budget MONEY,
  genres JSONB,
  homepage TEXT,
  keywords JSONB,
  original_language TEXT,
  original_title TEXT,
  title TEXT,
  overview TEXT,
  popularity FLOAT,
  production_companies JSONB,
  production_countries JSONB,
  release_date DATE,
  revenue MONEY,
  runtime INT,
  spoken_languages JSONB,
  status TEXT,
  tagline TEXT,
  vote_average FLOAT,
  vote_count INT
);

SET datestyle TO DMY;

-- import the movies data
COPY movies(
  budget,
  genres,
  homepage,
  id,
  keywords,
  original_language,
  original_title,
  overview,
  popularity,
  production_companies,
  production_countries,
  release_date,
  revenue,
  runtime,
  spoken_languages,
  status,
  tagline,
  title,
  vote_average,
  vote_count
)
FROM '/docker-entrypoint-initdb.d/movies.csv'
DELIMITER ','
CSV HEADER;
