# pact-postgrest-provider
Spike to work out ways to implement Pact providerState using PostgREST

## Overview
Implementing Pact providerState is one of the key challenges for using Pact for anything non-trivial. As far as possible, we want to avoid the need to make provider-side code changes, and to try to leverage the Pact contract itself to both define providerState requirements AND to implement them.

## PostgREST
PostgREST (https://postgrest.org) is a project whose purpose is to put a REST interface on top of the Postgres client/server protocol. This gives us a mechanism that could be used to implement database stubs without an underlying database - essentially create stubs that "look like" a PostgREST REST interface to a database, and test against those stubs.

## Quick start
### Database setup
Use `$ docker-compose up` to spin up a Postgres database instance, plus a PostgREST interface to that database, plus a Swagger server to document those PostgREST interfaces for development work. At this point you're dealing with an empty database. The database will be accessible at TCP/5432, the PostgREST interface to the database will be accessible at TCP/3000, and the Swagger server will be accessible at TCP/80

`$ ./init-data.sh` will create a set of tables within that database, and populate data into those tables. The tables are `city`, `country` and ...

`$ PGPASSWORD=password psql -h localhost -p 5432 -d app_db -U app_user` can be used to give you a PSQL session to the database. From there you can `\dt` to display the tables, `SELECT COUNT(*) FROM city` to show how many cities are within the database and so on. Once you're finished, use `\q` to exit PSQL

### Accessing database via PostgREST
`$ curl http://localhost:3000/city?id=eq.1` will return the first record from the `city` table, as a JSON payload. It's equivalent to the SQL command `SELECT * FROM city WHERE id=1;`

`$ curl -H 'Content-Type: application/json' -X PUT -d '{"id": 1, "name": "Gotham City", "countrycode": "USA", "district": "New Jersey", "population": 10000}' http://localhost:3000/city?id=eq.1` would update that record. It's equivalent to the SQL command `UPDATE city SET name='Gotham City', countrycode='USA', district='New Jersey', population=10000 WHERE id=1`

## Maintaining provider-side state via PostgREST
It's currently not clear to me what options exist for doing this - for now, I've created a description of the above PUT statement within the file `sample-pact-v2.json`. The relevant code section is under interactions.providerState.

In principle, it should be fairly straightforward to have a script extract this section of the Pact, and execute the PUT against a provider-side database. If there were multiple database interactions required, this approach could be easily extended.

## Defining PostgREST stub from providerState
Rather than using PostgREST to inject providerState data into the database, an easier option could be to create a stub to mimic the behaviour of PostgREST, and have the provider reference that stub in place of an actual database. This would remove the requirement to stand up provider-side database/s for contract testing, and more importantly remove the requirement to manage e.g. reference data to support those contract tests.

Code to turn a Pact into an executable Karate stub already exists in PoC format at https://github.com/monch1962/pact-to-karate, and we could also implement a solution for other tools such as Wiremock or Hoverfly
