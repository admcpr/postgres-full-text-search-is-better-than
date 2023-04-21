# Postgres Full Text Search is better than ...

This repo is a companion to the blog post [Postgres Full Text Search is better than ...](https://admcpr.com/postgres-full-text-search-is-better-than-part1). It contains the data and queries used in the blog post along with a docker-compose config that will spin up postgres and pgadmin so you can follow along.

## Getting started
```
docker compose up
```

Open pgAdmin by navigating to http://localhost:5050 and login with email: `admin@admin.com`, password: `root`.

From pgAdmin connect to PostgreSQL with Host name/Address: `<your ip>`, Username: `root`, Password: `root`.

See the [docker-compose.yml](docker-compose.yml) file for more details on configuration. 

## FAQ
Q: Why?

A: Why not

## Database source
The movies data used in this repo is sourced from [themoviedb.org](https://www.themoviedb.org/).



