create type custom_type as (
    title      text,
    t_array    text[],
    i_array    int[]
);

create table custom (
    id          serial,
    custom_type custom_type,
    created_at  timestamptz
);

insert into custom (custom_type, created_at)
    values 
        (('t 1', '{a,b,c}', '{1,2,3}')::custom_type, current_timestamp),
        (('t 2', '{d,e,f}', '{4,5,6}')::custom_type, current_timestamp),
        (('t 3', '{g,h,l}', '{7,8,9}')::custom_type, current_timestamp);

select to_json(t.*) from (select * from custom where id = 1) t;

select to_json(array_agg(t.*)) from (select * from custom) t;

select * from json_populate_record(null::custom, '{"id":1,"custom_type":{"title":"t 1","t_array":["a","b","c"],"i_array":[1,2,3]},"created_at":"2016-04-27T10:47:01.938524+03:00"}');

select * from json_populate_recordset(null::custom, '[{"id":1,"custom_type":{"title":"t 1","t_array":["a","b","c"],"i_array":[1,2,3]},"created_at":"2016-04-27T10:47:01.938524+03:00"},{"id":2,"custom_type":{"title":"t 2","t_array":["d","e","f"],"i_array":[4,5,6]},"created_at":"2016-04-27T10:47:01.938524+03:00"},{"id":3,"custom_type":{"title":"t 3","t_array":["g","h","l"],"i_array":[7,8,9]},"created_at":"2016-04-27T10:47:01.938524+03:00"}]');

