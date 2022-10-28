select * from CarreraTecnica
select NoExpediente, Nombres, Apellidos, * from Aspirante
select Carne, Ciclo, FechaInscripcion,  * from Inscripcion


create view view_detalle_carrera
as
select ct.CarreraId, ct.Nombre, a.NoExpediente, a.Apellidos + ' ' + a.Nombres as NombreCompleto, i.Carne, i.Ciclo, i.FechaInscripcion
from CarreraTecnica ct
left join Aspirante a on ct.CarreraId = a.CarreraId
left join Inscripcion i on ct.CarreraId = i.CarreraId


select * from view_detalle_carrera