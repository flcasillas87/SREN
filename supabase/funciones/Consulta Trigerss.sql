-- Esta consulta te muestra el mapa completo de triggers en tu esquema public
select 
    event_object_table as tabla,
    trigger_name as nombre_trigger,
    event_manipulation as evento, -- INSERT, UPDATE, DELETE
    action_timing as momento,      -- BEFORE, AFTER
    action_statement as funcion_disparada
from information_schema.triggers
where event_object_schema = 'public'
order by event_object_table;
