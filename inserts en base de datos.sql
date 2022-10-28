use kalum_test
select * from Aspirante a
select * from ExamenAdmision ea
select * from CarreraTecnica ct
select * from Jornada j
-- creacion de carreras tecnicas
insert into CarreraTecnica (CarreraId,CarreraTecnica) values (NEWID(),'Desarrollo de aplicaciones empresariales con .NET core');
insert into CarreraTecnica (CarreraId,CarreraTecnica) values (NEWID(),'Desarrollo de aplicaciones empresariales con JAVA EE');
insert into CarreraTecnica (CarreraId,CarreraTecnica) values (NEWID(),'Desarrollo de aplicaciones Moviles');
-- creacion de examenes de admision
insert into ExamenAdmision(ExamenId,FechaExamen) values (NEWID(),'2022-04-30');
insert into ExamenAdmision(ExamenId,FechaExamen) values (NEWID(),'2022-05-30');
insert into ExamenAdmision(ExamenId,FechaExamen) values (NEWID(),'2022-06-20');
-- creacopm de jornadas
insert into Jornada(JornadaId,Jornada,Descripcion) values (NEWID(),'JM','Jornada Matutina');
insert into Jornada(JornadaId,Jornada,Descripcion) values (NEWID(),'JV','Jornada Verpertina');
-- creacion de aspirantes
insert into Aspirante (NoExpediente,Apellidos,Nombres,Direccion,Telefono,Email,CarreraId,ExamenId,JornadaId)
values (
'EXP-2022001',
'Perez Castro',
'Jorge Rubén',
'Guatemala',
'45699632',
'perezj@gmail.com',
'AA9A05F1-2D40-4328-ADCE-E9774AD15E0B',
'7B115714-8117-435F-8909-2FAA99ABEEC1',
'324DD04C-6C6E-459A-A52A-A635334A3248'
);
insert into Aspirante (NoExpediente,Apellidos,Nombres,Direccion,Telefono,Email,CarreraId,ExamenId,JornadaId)
values (
'EXP-2022002',
'Molina Paz',
'Oscar Emilio',
'Guatemala',
'78543698',
'pazemilio@gmail.com',
'AA9A05F1-2D40-4328-ADCE-E9774AD15E0B',
'7B115714-8117-435F-8909-2FAA99ABEEC1',
'324DD04C-6C6E-459A-A52A-A635334A3248'
);
insert into Aspirante (NoExpediente,Apellidos,Nombres,Direccion,Telefono,Email,CarreraId,ExamenId,JornadaId)
values (
'EXP-2022003',
'Muñoz Monzon',
'Karla Gabriela',
'Guatemala',
'78963214',
'kgmuñoz@gmail.com',
'CCECEE15-546E-4E68-9F08-23E83AC873D1',
'D0108FC6-83EB-4301-91A8-2EFA4B237191',
'B45741F7-9637-4561-B736-29BB230B470C'
)
insert into Aspirante (NoExpediente,Apellidos,Nombres,Direccion,Telefono,Email,CarreraId,ExamenId,JornadaId)
values (
'EXP-2022004',
'Gutierrez Gomez',
'Lester Javier',
'Guatemala',
'12456398',
'gglester@gmail.com',
'9630A349-2AEF-487E-BBF9-C6C2EDEB560B',
'E88443A3-1CAC-4ACD-9F59-D8D682364FB1',
'B45741F7-9637-4561-B736-29BB230B470C'
)

select NEWID()

--Consulta
-- 01 mostrar los aspirantes que se van a examinar el dia 30 de abril, se debe mostrar el expediente, apellidos, nombres, fecha examen, carrera tecnica y estatus

select 
NoExpediente,
Apellidos,
Nombres,
FechaExamen,
CarreraTecnica,
Estatus
from Aspirante a 
inner join ExamenAdmision ea on a.ExamenId = ea.ExamenId
inner join CarreraTecnica ct on a.CarreraId = ct.CarreraId
where ea.FechaExamen = '2022-04-30' order by a.Apellidos

--view (vistas)
create view vw_ListarAspirantesPorFechaExamen
as
select 
NoExpediente,
Apellidos,
Nombres,
FechaExamen,
CarreraTecnica,
Estatus
from Aspirante a 
inner join ExamenAdmision ea on a.ExamenId = ea.ExamenId
inner join CarreraTecnica ct on a.CarreraId = ct.CarreraId
go
select Apellidos, Nombres, Estatus from vw_ListarAspirantesPorFechaExamen where FechaExamen = '2022-04-30' order by Apellidos

select * from ResultadoExamenAdmision rea

-- trigger (Disparador)

create trigger tg_ActualizarEstadoAspirante on ResultadoExamenAdmision after insert
AS
BEGIN
declare @nota int = 0;
declare @Expediente varchar(128)
declare @Estatus varchar(64) = 'No Asignado'
set @nota = (select Nota from inserted)
set @Expediente = (select NoExpediente from inserted)
if @nota >= 70
begin
set @Estatus = 'Sigue Proceso de admision'
end
else
begin
set @Estatus = 'No sigue proceso de admision'
end
update Aspirante set Estatus = @Estatus where NoExpediente = @Expediente
END

insert into ResultadoExamenAdmision (NoExpediente,Anio,Descripcion,Nota) values ('EXP-2022001','2022','Resultado Examen', 71);
insert into ResultadoExamenAdmision (NoExpediente,Anio,Descripcion,Nota) values ('EXP-2022004','2022','Resultado Examen', 65);
select * from Alumno = 2022001;
