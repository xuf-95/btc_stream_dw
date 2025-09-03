# Real-time Crypto Price Pipeline

> 基于 Binance 实时加密货币价格流的实时数据仓库示例项目  
> 技术栈：Kafka + Flink SQL + ClickHouse + Grafana  
> 演示 BTC/USDT 实时成交均价和成交量的聚合计算与可视化

---

## 项目介绍

本项目通过接入 Binance WebSocket 实时交易流，使用 Kafka 做消息中间件，Flink SQL 完成实时计算，ClickHouse 作为时序分析数据库，Grafana 实现数据可视化。  
适合作为流式处理、实时数据仓库技术栈的学习和展示项目。

---

## 架构图

```mermaid
graph LR
    A["Binance WebSocket"] --> B["Kafka: raw_price"]
    B --> C["Flink SQL 实时计算"]
    C --> D["Kafka: agg_price"]
    D --> E["ClickHouse 实时存储"]
    E --> F["Grafana 可视化"]
```
## Source Table

```sql
window_start DateTime // 窗口开始时间
window_end DateTime // 窗口结束时间
symbol String // 标志
avg_price Float64 // 平均价格
total_volume Float64 // 交易总量
```
