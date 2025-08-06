CREATE TABLE raw_price (
    e STRING,
    E BIGINT,
    s STRING,
    t BIGINT,
    p DOUBLE,
    q DOUBLE,
    T TIMESTAMP(3),
    WATERMARK FOR T AS T - INTERVAL '2' SECOND
) WITH (
    'connector' = 'kafka',
    'topic' = 'raw_price',
    'properties.bootstrap.servers' = 'kafka:9092',
    'properties.group.id' = 'flink-consumer',
    'format' = 'json',
    'scan.startup.mode' = 'latest-offset'
);

CREATE TABLE agg_price (
    window_start TIMESTAMP(3),
    window_end TIMESTAMP(3),
    symbol STRING,
    avg_price DOUBLE,
    total_volume DOUBLE
) WITH (
    'connector' = 'kafka',
    'topic' = 'agg_price',
    'properties.bootstrap.servers' = 'kafka:9092',
    'format' = 'json'
);

INSERT INTO agg_price
SELECT
    TUMBLE_START(T, INTERVAL '5' SECOND),
    TUMBLE_END(T, INTERVAL '5' SECOND),
    s,
    AVG(p) AS avg_price,
    SUM(q) AS total_volume
FROM raw_price
GROUP BY TUMBLE(T, INTERVAL '5' SECOND), s;