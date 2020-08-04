drop table booking;
drop table cruise_schedule;
drop table cruise;
drop table routes1;
drop table login_form;
drop table admin_login;
create table admin_login(
adminid varchar2(4) constraint adminpk primary key,
name varchar2(30));
create table login_form(
custid varchar2(4) constraint loginpk primary key,
password varchar2(30));
create table routes1(
routeid varchar2(4) constraint routes1pk primary key,
source varchar2(20),
destination varchar2(20));
create table cruise(
cruiseid varchar2(4) constraint cruisepk primary key,
routeid varchar2(4) constraint cruisefk references routes1(routeid),
no_of_tickets number(3),
no_of_rooms number(3));
create table cruise_schedule(
cruiseid varchar2(4),
departs date constraint np not null,
arrives date,
fare number(10),
dtime number(4),
atime number(4),
constraint schedulepk primary key(cruiseid,departs),
constraint schedulefk foreign key(cruiseid) references cruise);
create table booking(
custid varchar2(4) constraint bookpk primary key,
name varchar2(30),
no_of_tickets number(5),
phone number(10),
nationality varchar2(30),
routeid varchar2(4) constraint bookfk references routes1(routeid),
cruiseid varchar2(4) constraint bookfk2 references cruise(cruiseid),
from_date date,
total_fare number(10),
no_of_rooms number(10));
create or replace function calculate_fare(cid IN varchar2,rid IN varchar2,tickets IN number,cuid
varchar2)
return number
as
total number:=0;
begin
select s.fare into total from cruise_schedule s,cruise c,routes1 r where c.cruiseid=cid and
r.routeid=rid and c.cruiseid=s.cruiseid;
total:=total*tickets;
update booking set total_fare=total where custid=cuid;
return total;
end;
/
create or replace procedure decrease_tickets_and_rooms(cid varchar2,tic number,room
number)
IS
sub number;
subroom number;
begin
select no_of_tickets,no_of_rooms into sub,subroom from cruise where cruiseid=cid;
sub:=sub-tic;
subroom:=subroom-room;
update cruise set no_of_tickets=sub;
update cruise set no_of_rooms=subroom;
end;
/
create or replace function check_ticket_availability(cid IN varchar2,tickets IN number)
return number
as
flag number:=0;
begin
select no_of_tickets into flag from cruise where cruiseid=cid;
if(tickets<flag) then
flag:=0;
end if;
return flag;
end;
/
create or replace function check_rooms_availability(cid IN varchar2,rooms IN number)
return number
as
flag number:=0;
begin
select no_of_rooms into flag from cruise where cruiseid=cid;
if(rooms<flag) then
flag:=0;
end if;
return flag;
end;
/
create or replace function calculate_fare(cid IN varchar2,rid IN varchar2,tickets IN number,cuid
varchar2)
return number
as
total number:=0;
begin
select s.fare into total from cruise_schedule s,cruise c,routes1 r where c.cruiseid=cid and
r.routeid=rid and c.cruiseid=s.cruiseid;
total:=total*tickets;
update booking set total_fare=total where custid=cuid;
return total;
end;
/
create or replace procedure decrease_tickets_and_rooms(cid IN varchar2,tic IN number,room
IN number)
IS
sub number;
subroom number;
begin
select no_of_tickets,no_of_rooms into sub,subroom from cruise where cruiseid=cid;
sub:=sub-tic;
subroom:=subroom-room;
update cruise set no_of_tickets=sub where cruiseid=cid;
update cruise set no_of_rooms=subroom where cruiseid=cid;
end;
/
/*procedure for ticket cancellation*/
create or replace procedure cancel_ticket(ctid IN varchar2)
IS
add number;
addroom number;
temptic number;
temproom number;
cutID varchar2(4);
begin
select cruiseid,no_of_tickets,no_of_rooms into cutID,add,addroom from booking where
custid=ctid;
select no_of_tickets,no_of_rooms into temptic,temproom from cruise where cutID=cruiseid;
temptic:=temptic+add;
temproom:=temproom+addroom;
update cruise set no_of_tickets=temptic where cruiseid=cutID;
update cruise set no_of_rooms=temproom where cruiseid=cutID;
end;
/
create or replace function check_ticket_availability(cid IN varchar2,tickets IN number)
return number
as
flag number:=0;
begin
select no_of_tickets into flag from cruise where cruiseid=cid;
if(tickets<flag) then
flag:=0;
end if;
return flag;
end;
/
create or replace function check_rooms_availability(cid IN varchar2,rooms IN number)
return number
as
flag number:=0;
begin
select no_of_rooms into flag from cruise where cruiseid=cid;
if(rooms<flag) then
flag:=0;
end if;
return flag;
end;
/