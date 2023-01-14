select date_format(t1.fecha_carga, '%Y') as years, t1.mes, t1.viaje, t1.km_total, t1.unidad, t1.empresa, t4.viajes_unidad, t5.viajes_empresa,
	   t1.facturado, t1.nomina, t1.combustible,
       t1.casetas, t1.gastos_extra, 
	   t2.gastos_unidad,
       t1.egresos_emp,
       t3.total_facturado,
       t1.km_total/t3.km_total as factor,
       t2.gastos_unidad* t1.km_total/t3.km_total as gastos_unidad_ponderada,
       t1.egresos_emp* t1.km_total/(t3.km_total*t3.num_unidades) as gastos_empres_ponderada,
       t1.facturado-t1.nomina-t1.combustible-t1.casetas-t1.gastos_extra-t2.gastos_unidad* t1.km_total/t3.km_total-t1.egresos_emp* t1.km_total/(t3.km_total*t3.num_unidades) as U_NETA
from
(
select totales.fecha_carga, totales.fecha as mes, totales.viaje, totales.km_total, totales.id_unidad, totales.unidad, totales.id_empresa, totales.empresa, 
	sum(totales.facturado) as facturado,
    sum(totales.nomina) as nomina,
    sum(totales.combustible) as combustible,
    sum(totales.casetas) as casetas,
    sum(totales.gastos_extra) as gastos_extra,
    gastos_emp.egresos_emp,cuenta_viajes.cuenta,
    gastos_emp.egresos_emp/cuenta_viajes.cuenta as gastos_empresa_prorrateados
FROM (    
select v.id, v.fecha_carga, date_format(v.fecha_carga, '%m-%Y') as fecha, v.nombre as viaje, v.km_total, u.id as id_unidad, u.nombre as unidad, e.id as id_empresa, e.nombre as empresa, f.total as facturado, 
	   v.nomina, c2.combustible, if(cst2.total_casetas IS NULL, 0, cst2.total_casetas) as casetas,
       if(eg2.gastos_extra IS NULL, 0, eg2.gastos_extra)  as gastos_extra
from viajes v
	 left outer join (select  cst.viaje_id, sum(total) as total_casetas from casetas cst group by cst.viaje_id) as cst2
     on v.id=cst2.viaje_id
     left outer join (select  eg.viaje_id, SUM(eg.cantidad) as gastos_extra from  egresos eg group by eg.viaje_id) as eg2
     on v.id=eg2.viaje_id
     left outer join (select  c.viaje_id, SUM(c.total) as combustible from  combustibles c group by c.viaje_id) as c2
     on v.id=c2.viaje_id
     , unidades u, empresas e, facturas f, combustibles c 
where
v.empresa_id=e.id
and
e.id IN (1,2)
and
v.unidad_id=u.id
and
f.viaje_id=v.id
and
c.viaje_id=v.id
Group by 
 v.id, v.fecha_carga, v.nombre, v.km_total, u.id, u.nombre, e.id, e.nombre, f.total, v.nomina , c2.combustible, cst2.total_casetas, eg2.gastos_extra
order by date_format(v.fecha_carga, '%m-%Y'), u.nombre asc
) as totales,
(
select date_format(fecha, '%m-%Y') as fecha, sum(cantidad) egresos_emp from egresos where unidad_id=0
and tipo_egreso_id = 1
group by date_format(fecha, '%m-%Y') 
) as gastos_emp,
(
select fecha, count(fecha) as cuenta from 
(
select date_format(v.fecha_carga, '%m-%Y') as fecha, v.unidad_id, v.empresa_id from viajes v
group by date_format(fecha_carga, '%m-%Y'), v.unidad_id, v.empresa_id
) as cuenta
group by fecha
) as cuenta_viajes
where
totales.fecha=gastos_emp.fecha
and
totales.fecha=cuenta_viajes.fecha
GROUP BY totales.fecha_carga, totales.fecha, totales.viaje, totales.km_total, totales.id_unidad, totales.unidad, totales.id_empresa, totales.empresa, cuenta_viajes.cuenta, gastos_emp.egresos_emp
) as t1
left join (
     select date_format(fecha, '%m-%Y') as fecha, unidad_id, sum(cantidad) gastos_unidad from egresos where unidad_id<>0
		group by date_format(fecha, '%m-%Y'), unidad_id																										
     ) as t2
     on t1.id_unidad=t2.unidad_id and t1.mes=t2.fecha
left join (
		select date_format(v.fecha_carga, '%m-%Y') as fecha, u.id as unidad_id, SUM(f.total) as total_facturado, SUM(v.km_total) as km_total, num_unidades from
		facturas f, unidades u, viajes v,
		(
		select count(id) as num_unidades from unidades
		) as count_u
		where
		f.viaje_id=v.id
		and
		v.unidad_id=u.id
		group by date_format(v.fecha_carga, '%m-%Y'), u.id, num_unidades
     ) as t3
     on t1.id_unidad=t3.unidad_id and t1.mes=t3.fecha   
left join (
	select date_format(v.fecha_carga, '%m-%Y') as mes, v.unidad_id, count(v.unidad_id) as viajes_unidad from viajes v
	group by date_format(fecha_carga, '%m-%Y'), v.unidad_id
) as t4
	on t1.id_unidad=t4.unidad_id and t1.mes=t4.mes
left join (
    select date_format(v.fecha_carga, '%m-%Y') as mes, v.empresa_id, count(v.empresa_id) as viajes_empresa from viajes v
	group by date_format(fecha_carga, '%m-%Y'), v.empresa_id
) as t5
	on t1.id_empresa=t5.empresa_id and t1.mes=t5.mes    
;


-- totales
select v.id, v.fecha_carga, date_format(v.fecha_carga, '%m-%Y') as fecha, v.nombre as viaje, v.km_total, u.id as id_unidad, u.nombre as unidad, e.id as id_empresa, e.nombre as empresa, 
	   v.nomina, c2.combustible, if(cst2.total_casetas IS NULL, 0, cst2.total_casetas) as casetas,
       if(eg2.gastos_extra IS NULL, 0, eg2.gastos_extra)  as gastos_extra
from viajes v
	 left outer join (select  cst.viaje_id, sum(total) as total_casetas from casetas cst group by cst.viaje_id) as cst2
     on v.id=cst2.viaje_id
     left outer join (select  eg.viaje_id, SUM(eg.cantidad) as gastos_extra from  egresos eg group by eg.viaje_id) as eg2
     on v.id=eg2.viaje_id
     left outer join (select  c.viaje_id, SUM(c.total) as combustible from  combustibles c group by c.viaje_id) as c2
     on v.id=c2.viaje_id
     , unidades u, empresas e-- ,  combustibles c 
where
v.empresa_id=e.id
and
e.id IN (1,2)
and
v.unidad_id=u.id
-- and
-- c.viaje_id=v.id
Group by 
 v.id, v.fecha_carga, v.nombre, v.km_total, u.id, u.nombre, e.id, e.nombre, v.nomina , c2.combustible, cst2.total_casetas, eg2.gastos_extra
order by date_format(v.fecha_carga, '%m-%Y'), u.nombre asc
;

-- viajes
select 
	v.id, v.fecha_carga, date_format(v.fecha_carga, '%m-%Y') as fecha, v.nombre as viaje, v.km_total, v.nomina as sueldo  -- datos de viaje
	,u.id as id_unidad, u.nombre as unidad -- datos de unidad
    ,e.id as id_empresa, e.nombre as empresa -- datos de empresa
    -- ,f.total as facturado -- datos de facturas
	,if(c2.combustible IS NULL, 0, c2.combustible) as combustible -- datos de combustible
    ,if(cst2.total_casetas IS NULL, 0, cst2.total_casetas) as casetas -- datos de casetas 
    ,if(eg2.gastos_extra IS NULL, 0, eg2.gastos_extra)  as gastos_extra -- datos gastos extra
from 
	empresas e
	, unidades u
    -- , facturas f
	, viajes v
left outer join (select  cst.viaje_id, sum(total) as total_casetas from casetas cst group by cst.viaje_id) as cst2 -- gastos de caseta por viaje
	on v.id=cst2.viaje_id
left outer join (select  eg.viaje_id, SUM(eg.cantidad) as gastos_extra from  egresos eg group by eg.viaje_id) as eg2 -- gastos extra por viaje
     on v.id=eg2.viaje_id
left outer join (select  c.viaje_id, SUM(c.total) as combustible from  combustibles c group by c.viaje_id) as c2 -- gastos de combustible por viaje
     on v.id=c2.viaje_id  
where
v.empresa_id=e.id
and
e.id IN (1,2) -- solo de Grupak y Covintec
and
v.unidad_id=u.id
-- and
-- v.id=f.viaje_id
;