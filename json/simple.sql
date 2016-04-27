create table simple(
    id         serial,
    title      text,
    t_array    text[],
    i_array    int[],
    created_at timestamptz
);

insert into simple (title, t_array, i_array, created_at) 
    values 
        ('t 1', '{a,b,c}', '{1,2,3}', current_timestamp),
        ('t 2', '{d,e,f}', '{4,5,6}', current_timestamp),
        ('t 3', '{g,h,l}', '{7,8,9}', current_timestamp);


select to_json(t.*) from (select * from simple where id = 1) t;

select to_json(array_agg(t.*)) from (select * from simple) t;

select * from json_populate_record(null::simple, '{"id":1,"title":"t 1","t_array":["a","b","c"],"i_array":[1,2,3],"created_at":"2016-04-27T10:26:12.74609+03:00"}');

select * from json_populate_recordset(null::simple, '[{"id":1,"title":"t 1","t_array":["a","b","c"],"i_array":[1,2,3],"created_at":"2016-04-27T10:26:12.74609+03:00"},{"id":2,"title":"t 2","t_array":["d","e","f"],"i_array":[4,5,6],"created_at":"2016-04-27T10:26:12.74609+03:00"},{"id":3,"title":"t 3","t_array":["g","h","l"],"i_array":[7,8,9],"created_at":"2016-04-27T10:26:12.74609+03:00"}]');

