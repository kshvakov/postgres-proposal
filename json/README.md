**Проблема**

На данный момент Постгрес позволяет "собирать" любой результат в json 

пример 

```sql
with items (id, params) as (
    values
        (1, '{bad,sad}'::text[]),
        (2, '{bad2,sad2}'::text[])
)
select to_json(array_agg(items.*)) from items 
```

->

```json
[{"id":1,"params":["bad","sad"]},{"id":2,"params":["bad2","sad2"]}]
```

однако, стандартные функции json_populate_record/json_populate_recordset не могут работать (ERROR:  22P02: malformed array literal) если базовый тип содержит композитные типы (массивы, пользовательские типы, etc) и в json определены данные для него. 

из-за чего приходиться делать разбор json подобным образом  

```sql
do $$
declare 
    _rawjson json;
    _item    record;
    _id      int;
    _param   text;
begin
    for _rawjson in select * from json_array_elements('[{"id":1,"params":["bad","sad"]},{"id":2,"params":["bad2","sad2"]}]'::json) loop 
            _item = (select j from json_to_record(_rawjson) AS j (
                    id     int, 
                    params json
                )
            );

        for _id, _param in select _item.id, _p from json_array_elements_text(_item.params) as _p  loop 
            raise info 'id: %, param: %', _id, _param;
        end loop;   
    end loop;
end $$;
```

что несколько не удобно и не эффективно

**Хочется**

Корректной работы функций json_populate_record/json_populate_recordset )

В файлах simple/custom_type приведено ожидаемое поведение работы функций 