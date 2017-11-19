## Pre
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-14-04
Follow this tutorial. Even it's writtet for Ubuntu 14.04 LTS, I suppose it's ok for every platform (with small differences like package manager)
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
thenin ordel do connect
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

