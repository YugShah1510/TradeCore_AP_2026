# PostgreSQL query timings

Execution times are PostgreSQL `EXPLAIN ANALYZE` execution times, in milliseconds. The six benchmark queries in [benchmark_queries.sql](benchmark_queries.sql) were run three times in sequence against the same local PostgreSQL 17 instance and synthetic dataset (1,000 users, 20 instruments, 40,000 orders, 20,000 trades, 20,000 positions). The plans in `plans/` are from Run 3. These are benchmark measurements for that query set and dataset, not production workload estimates. The repository's `04_queries.sql` catalog was added upstream after this benchmark commit and is not represented by these measurements.

| Query | Run 1 (ms) | Run 2 (ms) | Run 3 (ms) | Average (ms) | Plan |
|---|---:|---:|---:|---:|---|
| Q01 | 0.609 | 0.558 | 0.619 | 0.595 | [Q01.txt](plans/Q01.txt) |
| Q02 | 0.105 | 0.103 | 0.102 | 0.103 | [Q02.txt](plans/Q02.txt) |
| Q03 | 1.238 | 1.236 | 1.257 | 1.244 | [Q03.txt](plans/Q03.txt) |
| Q04 | 0.056 | 0.067 | 0.063 | 0.062 | [Q04.txt](plans/Q04.txt) |
| Q05 | 9.799 | 9.667 | 9.614 | 9.693 | [Q05.txt](plans/Q05.txt) |
| Q06 | 0.201 | 0.206 | 0.195 | 0.201 | [Q06.txt](plans/Q06.txt) |
