## Pre
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-14-04
Follow this tutorial. Even though it's written for Ubuntu 14.04 LTS, I suppose it's ok for every platform (with small differences like package manager).
Let us suppose that you can type
```bash
sudo -i -u postres
```
And without any error enter `PSQL` by typing
```bash
psql
```
# Create database
Well, In first order you need to create database. In fact, you could name it as you wish, but I suppose it would be reasonable to name it `PBD` as I did.
Type:
```bash
create database PBD;
```
Do not forget about semicolon. It could be tricky.
```bash
\l
```
to list databases on your host. If there's one labeled `pbd` it's fine :)

# Migrate
Let us suppose that you have `.sql` file with create table commands.
type
```bash
\q
```
to leave `psql` and then go to folder with `PBD_create.sql` file. It's a default name from vertabello
```bash
psql pbd < PBD_create.sql
```
then in order do connect
```bash
psql
\c pbd
\d
```
I believe that everything went fine amd now you see 14 tables owned by mysterious `postgres` :)
https://www.postgresql.org/docs/9.0/static/sql-select.html
Here's postegres syntax. That's easy
Check if everything is fine by:
```bash
select * from clients;
```
(semicolon!)

# Populate
TBD.
We's rather have to populate in proper order. It would be great if will make FK only to already existing fields :).
Made example:
```bash
psql pbd < populate.sql
```
We can make long populaton script. But I think that we could also make it using DataGrip. Just populate it and then make a `bump` of database. And then we could run it on every machine.  

Oooor, we can use elixir and be fancy and functonal

# Elixir
Given toy followed tutorial http://elixir-lang.github.io/install.html, let us make it runnable.  
In order to get deps
```bash
mix deps.get
```
And run interactive mode
```bash
iex -S mix
```
The you could type
```bash
{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "pbd")
Postgrex.query!(pid, "SELECT * FROM conferences", [])
```
Looks fine. meh? :)  
You could do it from file as well
```
iex -S mix
PBD.hello
```
world! Look in `lib/pbd.ex`/ It's so easy
```
PBD.example
```
Ok, but if we really wish to compile all this this every time? Maybe some script? `ctr+c` twice
```
mix run lib/population
```
This file will great some day :') and that's essential
