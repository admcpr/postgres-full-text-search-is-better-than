# Postgres Full Text Search is better than ...

This repo is a companion to the blog post [Postgres Full Text Search is better than ...](https://admcpr.com/postgres-full-text-search-is-better-than-part1). It contains the data and queries used in the blog post along with a docker-compose config that will spin up postgres and pgadmin so you can follow along.

## Getting started

### Clone this repo
```
git clone git@github.com:admcpr/postgres-full-text-search-is-better-than.git
```
### Use docker compose to spin up the containers
```
cd postgres-full-text-search-is-better-than
docker compose up
```
### Use the included pgAdmin to connect to Postgres
1. Open pgAdmin by navigating to `http://localhost:5050` and login with email: `admin@admin.com`, password: `root`.
1. From pgAdmin connect to PostgreSQL with:
   1. Host name/Address: `<your ip>`
   2. Username: `root`
   3. Password: `root`.

See the [docker-compose.yml](docker-compose.yml) file for more details on configuration. 

## FAQ
Q: Why?

A: Why not

## Database source
The movies data used in this repo is sourced from [themoviedb.org](https://www.themoviedb.org/).
