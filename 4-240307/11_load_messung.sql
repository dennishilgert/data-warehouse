--select * from staging.sensordaten order by 3,2;
--select * from staging.sampling order by 1,2;

delete from staging.messung;

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000001",
   "zeit": 1698393624,
   "geschwindigkeit": 7,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:00:25', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000001",
   "zeit": 1698393724,
   "geschwindigkeit": 22,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:02:06', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000001",
   "zeit": 1698393794,
   "geschwindigkeit": 33,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:03:15', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000001",
   "zeit": 1698393734,
   "geschwindigkeit": 12,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:02:16', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000003",
   "zeit": 1698393734,
   "geschwindigkeit": 12,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:02:16', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000003",
   "zeit": 1698393934,
   "geschwindigkeit": 3,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:05:40', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000003",
   "zeit": 1698393994,
   "geschwindigkeit": 1,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:06:35', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000003",
   "zeit": 1698393994,
   "geschwindigkeit": 4,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:06:36', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000003",
   "zeit": 1698393999,
   "geschwindigkeit": 5,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:06:39', 'YYYY-MM-DD HH24:MI:SS')
);

insert into staging.messung (payload, empfangen)
values
(
   '{
   "fin": "F1000001",
   "zeit": 1698393997,
   "geschwindigkeit": 7,
   "ort": "Stuttgart"
   }',
   to_timestamp('2023-10-27 10:06:37', 'YYYY-MM-DD HH24:MI:SS')
);

