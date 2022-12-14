--1
--a
create function inc(a integer)
    returns integer as $$
begin
    return a + 1;
end; $$
language plpgsql;

select inc(3);


--b
create function sum(a integer, b integer)
    returns integer as $$
begin
    return a + b;
end; $$
language plpgsql;

select sum(4,6);


--c
create function is_even(a int)
    returns boolean as $$
begin
    if a % 2 = 0 then return true;
    else return false;
    end if;
end; $$
language plpgsql;

select is_even(4);


--d
create function password(s varchar)
    returns boolean as $$
declare
    pass varchar := 'password123';
begin
    return case
        when pass = s then false
        else true
    end;
end;
$$
language plpgsql;

select password('123456789');


--e
create function powers(a integer, out sqr integer, out cube integer) as $$
begin
    sqr = a * a;
    cube = a * a * a;
end; $$
language plpgsql;

select powers(5);






--2
create table task_a(

);
create table task_b(

);
create table task_c(

);
create table task_d(

);
create table task_e(

);

--a
create function current_time()
    returns trigger as $$
begin
    raise notice '%', now();
    return new;
end; $$
language plpgsql;

create trigger current before insert on task_a
    for each row execute procedure current_time();


--b
create function age()
    returns trigger as $$
begin
    raise notice '%', age(now(),new.t);
    return new;
end; $$
language plpgsql;

create trigger age_t before insert on task_b
    for each row execute procedure age();


--c
create function tax()
    returns trigger as $$
begin
    new.n_tax = new.n_tax * 1.12;
    return new;
end; $$
language plpgsql;

create trigger tax_t before insert on task_c
    for each row execute procedure tax();


--d
create function prevent_d()
    returns trigger as $$
begin
    raise exception 'Delition is not possible';
end; $$
language plpgsql;

create trigger prevent_t before delete on task_d
    execute procedure prevent_d();

--e
create function launch()
    returns trigger as $$
begin
    raise notice '%', password(new.s);
    raise notice '%', powers(new.a);
    return new;
end; $$
language plpgsql;

create trigger launch_t before insert on task_e
    for each row execute procedure launch();



--3
create table work(
    id int,
    name varchar,
    date_of_birth date,
    age int,
    salary numeric,
    workexperience int,
    discount numeric
);

--a
create function
    a(id int, name varchar, date_of_birth date, age int,
    inout salary numeric, workexperience int, out discount numeric) as $$
declare
    count int;
begin
    discount = 10;
    count = workexperience/2;
    for step in 1..count loop
        salary = salary * 1.1;
    end loop;
    count = workexperience/5;
    for step in 1..count loop
        discount = discount * 1.01;
    end loop;
    insert into work values(id, name, date_of_birth, age, salary, workexperience, discount);
end; $$
language plpgsql;

select * from a(4, 'Alina', '2002-06-28', 20, 800, 4);


--b
create or replace function
    b(id int, name varchar, date_of_birth date, age int,
    inout salary numeric, workexperience int, out discount numeric) as $$
declare
    count int;
begin
    if age >= 40 then salary = salary * 1.15;
    end if;
    discount = 10;
    count = workexperience/2;
    for step in 1..count loop
        salary = salary * 1.1;
    end loop;
    count = workexperience/5;
    for step in 1..count loop
        discount = discount * 1.01;
    end loop;
    if workexperience > 8 then salary = salary * 1.15;
    end if;
    if workexperience > 8 then discount = 20;
    end if;
    insert into work values(id, name, date_of_birth, age, salary, workexperience, discount);
end; $$
language plpgsql;

select * from b(2, 'Dina', '2001-10-05', 21, 1000, 5);