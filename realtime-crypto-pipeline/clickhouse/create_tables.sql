CREATE TABLE agg_price (
    window_start DateTime,
    window_end DateTime,
    symbol String,
    avg_price Float64,
    total_volume Float64
) ENGINE = MergeTree()
ORDER BY window_start;

CREATE TABLE kafka_agg_price
(
    window_start DateTime,
    window_end DateTime,
    symbol String,
    avg_price Float64,
    total_volume Float64
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
         kafka_topic_list = 'agg_price',
         kafka_group_name = 'clickhouse_consumer',
         kafka_format = 'JSONEachRow';

CREATE MATERIALIZED VIEW mv_agg_price TO agg_price AS
SELECT * FROM kafka_agg_price;