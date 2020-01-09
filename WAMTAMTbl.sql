use embshist
go
drop   table WAMTAM
go
create table WAMTAM (
SecMnem char(20),
EffDt   smalldatetime,
Agency  char(3),
PoolNr  char(7),
Cusip   char(9),
Prefix  char(2),
WAMTAM  real,
UpdDt   smalldatetime)
go
grant select on WAMTAM to public
go
use embs
go
create view WAMTAM
as
select * from embshist..WAMTAM
go
grant select on WAMTAM to public
go
