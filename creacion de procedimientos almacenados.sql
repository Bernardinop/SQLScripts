use kalum_test
create function RPAD
(
	@string varchar(MAX), --cadena inicial
	@length int, -- tamaño del string
	@pad char -- caracter que se utilizara para el reemplazo
)
returns varchar(MAX)
as
begin
	return @string + replicate(@pad, @length- len(@string))
end

create function LPAD
(
	@string varchar(MAX),
	@length int,
	@pad char
)
returns varchar(MAX)
as
begin
	return replicate(@pad, @length- len(@string)) + @string
end

select concat ('2022', dbo.LPAD('1001',4,'0'))

-- creacion de procedimientos almacenados

select * from Aspirante a
select * from Aspirante a where a.NoExpediente = 'EXP-2022001'
select * from CarreraTecnica ct
select * from InversionCarreraTecnica ict

insert into InversionCarreraTecnica values(NEWID(), 'AA9A05F1-2D40-4328-ADCE-E9774AD15E0B', 1200, 5, 750)
insert into InversionCarreraTecnica values(NEWID(), 'CCECEE15-546E-4E68-9F08-23E83AC873D1', 1200, 6, 850)
insert into InversionCarreraTecnica values(NEWID(), '9630A349-2AEF-487E-BBF9-C6C2EDEB560B', 1000, 5, 600)

select * from Cargo c

insert into Cargo values (NEWID(), 'Pago inscripcion de carrera tecnica plan fin de semana', 'INSCT', 1200, 0, 0)
insert into Cargo values (NEWID(), 'Pago Mensual carrera tecnica', 'PGMCT', 850, 0, 0)
insert into Cargo values (NEWID(), 'Carné', 'CARNE', 30, 0, 0)

-- Procedimiento almacenado para el proceso de incripcion

alter procedure sp_EnrollmentProcess @NoExpediente varchar(12), @Ciclo varchar(4), @MesInicioPago int, @CarreraId varchar(128)
as
begin
	-- variables para informacion de aspirantes
	declare @Apellidos varchar(128)
	declare @Nombres varchar(128)
	declare @Direccion varchar(128)
	declare @Telefono varchar(64)
	declare @Email varchar(64)
	declare @JornadaId varchar(128)
	-- variables para generar numero de carne
	declare @Exists int
	declare @Carne varchar(12)
	-- variables para el proceso de pago
	declare @MontoInscripcion numeric (10,2)
	declare @NumeroPagos int
	declare @MontoPago numeric (10,2) -- 100000.00
	declare @Descripcion varchar(128)
	declare @Prefijo varchar(6)
	declare @CargoId varchar(128)
	declare @Monto numeric(10,2)
	declare @CorrelativoPagos int
	begin transaction
	begin try
		select @Apellidos = apellidos, @Nombres = Nombres, @Direccion = Direccion, @Telefono = Telefono, @Email = Email, @JornadaId = JornadaId
			from Aspirante where NoExpediente = @NoExpediente
		set @Exists = (select top 1 a.Carne from Alumno a where SUBSTRING(a.Carne,1,4) = @Ciclo order by a.Carne DESC)
		if @Exists is NULL
		begin
			set @Carne = (@Ciclo * 10000) + 1
		end
		else
		begin
			set @Carne = (select top 1 a.Carne from Alumno a where SUBSTRING(a.Carne,1,4) = @Ciclo order by a.Carne DESC) + 1
		end
		-- proceso de inscripcion
		insert into Alumno values (@Carne,@Apellidos,@Nombres,@Direccion,@Telefono,CONCAT(@Carne,@Email))
		insert into Inscripcion values(NEWID(),@Carne,@CarreraId,@JornadaId,@Ciclo,GETDATE())
		update Aspirante set Estatus = 'Inscrito Ciclo ' + @Ciclo where NoExpediente = @NoExpediente
		--proceso de cargos
		select @MontoInscripcion = MontoInscripcion, @NumeroPagos = NumeroPagos, @MontoPago = MontoPagos
			from InversionCarreraTecnica ict where ict.CarreraId = @CarreraId
		select @CargoId = CargoId, @Descripcion = Descripcion, @Prefijo = Prefijo
			from Cargo c2 where c2.CargoId = 'AE79B933-8236-4280-8038-9237EC582A0A'
		insert into CuentaporCobrar
			values(CONCAT(@Prefijo,SUBSTRING(@Ciclo,3,2),dbo.LPAD('1','2','0')),@Ciclo,@Carne,@CargoId,@Descripcion,GETDATE(),GETDATE(),@MontoInscripcion,0,0)
		-- cargo de pago de carne
		select @CargoId = CargoId, @Descripcion = Descripcion, @Prefijo = Prefijo, @Monto= Monto
			from Cargo c2 where c2.CargoId = 'A970BA40-9845-43E5-860D-793285581B30'
		insert into CuentaporCobrar
			values(CONCAT(@Prefijo,SUBSTRING(@Ciclo,3,2),dbo.LPAD('1','2','0')),@Ciclo,@Carne,@CargoId,@Descripcion,GETDATE(),GETDATE(),@Monto,0,0)
		-- cargos mensuales	
		set @CorrelativoPagos = 1
		select @CargoId = CargoId, @Descripcion = Descripcion, @Prefijo = Prefijo from Cargo c2  where c2.CargoId = '0B678EFF-C27F-450D-8D2D-0F7AA1A15CFE'
		while(@CorrelativoPagos <= @NumeroPagos)
		begin
		insert into CuentaporCobrar
			values(CONCAT(@Prefijo,SUBSTRING(@Ciclo,3,2),dbo.LPAD(@CorrelativoPagos,'2','0')),@Ciclo,@Carne,@CargoId,@Descripcion,GETDATE(),CONCAT(@Ciclo,'-',dbo.LPAD(@MesInicioPago,2,0),'-',05),@MontoPago,0,0)
			set @CorrelativoPagos = @CorrelativoPagos +1
			set @MesInicioPago = @MesInicioPago + 1
		end

		commit transaction
		select 'Transaction Success' as status, @Carne as carne
	end try
	begin catch
		/*SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_SEVERITY() AS ErrorSeverity
            ,ERROR_STATE() AS ErrorState
            ,ERROR_PROCEDURE() AS ErrorProcedure
            ,ERROR_LINE() AS ErrorLine
            ,ERROR_MESSAGE() AS ErrorMessage;*/
		rollback transaction
		select 'Transaction Error' as status, 0 as carne
	end catch
end

select name from sys.key_constraints where type = 'PK' and OBJECT_NAME(parent_object_id) = N'CuentaporCobrar'
go
alter table CuentaporCobrar drop constraint PK__Cuentapo__C693DEA4A91190AA
go
alter table CuentaporCobrar add primary key (Cargo,Anio,Carne)

select Concat('INSC',SUBSTRING('2022',3,2),.dbo.LPAD('1','2','0'))

select * from InversionCarreraTecnica ict where ict.CarreraId = 'AA9A05F1-2D40-4328-ADCE-E9774AD15E0B'

execute sp_EnrollmentProcess 'EXP-2022002','2022', 2 , 'AA9A05F1-2D40-4328-ADCE-E9774AD15E0B'



select top 1 * from Aspirante a order by NoExpediente DESC

select SUBSTRING ('Guatemala',6,4)

alter table Alumno alter column Direccion varchar(128) not null;
alter table Jornada alter column NombreCorto varchar(5) not null;

select * from Alumno
select * from Inscripcion
select * from IncripcionPago
select * from CuentaporCobrar
select * from CarreraTecnica
select * from InversionCarreraTecnica
select * from CuentaporCobrar where Carne = 20220005
select * from Aspirante
select * from Cargo
select * from ExamenAdmision
select * from ResultadoExamenAdmision
select * from Jornada

update Aspirante set Estatus = 'Sigue Proceso de Admision' where NoExpediente = 'EXP-2022002'

delete from Inscripcion where Carne > 0
delete from CuentaporCobrar where Carne > 0
delete from Alumno where Carne > 0
execute sp_rename 'CarreraTecnica.CarreraTecnica', 'Nombre', 'COLUMN'

