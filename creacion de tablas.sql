--create database kalum_test
--go
use kalum_test
go
create table ExamenAdmision
(
ExamenId varchar(128) primary key not null,
FechaExamen datetime not null
)
go
create table CarreraTecnica
(
CarreraId varchar(128) primary key not null,
CarreraTecnica varchar(128) not null
)
go 
create table Jornada
(
JornadaId varchar(128) primary key not null,
Jornada varchar (2) not null,
Descripcion varchar (128) not null
)
go
create table Aspirante
(
NoExpediente varchar(128) primary key not null,
Apellidos varchar (128) not null,
Nombres varchar (128) not null,
Direccion varchar (128) not null,
Telefono varchar (128) not null,
Email varchar (128) not null unique,
Estatus varchar (32) default 'No Asignado',
CarreraId varchar(128) not null,
ExamenId varchar(128) not null,
JornadaId varchar(128) not null,
constraint FK_ASPIRANTE_CARRERA_TECNICA foreign key (CarreraId) references CarreraTecnica(CarreraId),
constraint FK_ASPIRANTE_EXAMEN_ADMISION foreign key (ExamenId) references ExamenAdmision(ExamenId),
constraint FK_ASPIRANTE_JORNADA foreign key (JornadaId) references Jornada(JornadaId)
)
go
create table ResultadoExamenAdmision
(
NoExpediente varchar(128) not null,
Anio varchar (4) not null,
Descripcion varchar (128) not null,
Nota int default 0,
primary key(NoExpediente,Anio),
constraint FK_RESULTADO_EXAMEN_ADMISION_ASPIRANTE foreign key (NoExpediente) references Aspirante(NoExpediente)
)
go
create table IncripcionPago 
(
BoletaPago varchar(128) not null, 
NoExpediente varchar(128) not null, 
Anio varchar(4) not null, 
FechaPago datetime not null, 
Monto decimal(10,2) not null,  
primary key(BoletaPago,NoExpediente,Anio), 
constraint FK_INSCRIPCION_PAGO_ASPIRANTE foreign key (NoExpediente) references Aspirante(NoExpediente) 
)
go 
create table Alumno 
( 
Carne varchar(8) not null, 
Apellidos varchar(128) not null, 
Nombres varchar(128) not null, 
Direccion varchar(4) not null, 
Telefono  varchar(84) not null,  
Email varchar(64) not null unique, 
primary key(Carne)  
) 
create table Cargo 
( 
CargoId varchar(128) not null, 
Descripcion varchar(128) not null, 
Prefijo varchar(64) not null, 
Monto decimal(10,2) not null, 
GeneraMora  bit not null default 1,  
PorcentajeMora int default 0, 
primary key(CargoId)  
) 
go
create table Incripcion 
(  
IncripcionId varchar(128) not null, 
Carne varchar(8) not null, 
CarreraId varchar(128) not null, 
JornadaId varchar(128) not null, 
Ciclo varchar(4) not null, 
FechaInscripcion datetime not null,  
primary key(IncripcionId), 
constraint FK_INSCRIPCION_CARRERA_TECNICA foreign key (CarreraId) references CarreraTecnica(CarreraId), 
constraint FK_INSCRIPCION_JORNADA foreign key (JornadaId) references Jornada(JornadaId), 
constraint FK_INSCRIPCION_ALUMNO foreign key (Carne) references Alumno(Carne) 
)
go
create table CuentaporCobrar 
( 
 Cargo varchar(128) not null, 
 Anio varchar(4) not null,  
 Carne varchar(8) not null, 
 CargoId varchar(128) not null, 
 Descripcion varchar(128) not null, 
 FechaCargo datetime not null, 
 FechaAplica datetime not null,  
 Monto decimal(10,2) not null, 
 Mora decimal(10,2) not null, 
 Descuento decimal(10,2) not null, 
 primary key(Cargo), 
 constraint FK_CUENTA_POR_COBRAR_ALUMNO foreign key (Carne) references Alumno(Carne), 
 constraint FK_CUENTA_POR_COBRAR_CARGO foreign key (CargoId) references Cargo(CargoId) 
)
go
create table InversionCarreraTecnica 
( 
 InversionId varchar(128) not null, 
 CarreraId varchar(128) not null, 
 MontoInscripcion decimal(10,2) not null, 
 NumeroPagos int not null, 
 MontoPagos decimal(10,2) not null,  
 primary key(InversionId), 
 constraint FK_INVERSION_CARRERA_TECNICA_CARRERATECNICA foreign key (CarreraId) references CarreraTecnica(CarreraId) 
)