# Benchmark Source Control implementation between different web frameworks

## 📦 Requirements

- `wrk` to run benchmark and collect results (why? [see this](https://k6.io/blog/comparing-best-open-source-load-testing-tools))
- `postgresql` to store the results
- `docker` as anisolated running environment of each framework
- `jq` to process Docker metadata

## ⚒ Usage

1. The servers are programmed to listen on an endpoint with signature `/get_git_program` alongside `root_path` and `commit_id` query params. Therefore, you need to create/use a Git Repository and specify its absolute path inside [`bench.sh`](./bench.sh) and then specify the commit SHA to fetch all files. For example:

   - Repo path: `/home/bimbal/Development/test-repo`
   - Commit SHA: `505130931b37ed91d80b32dfdd0f26b7de228c92`
   - Endpoint to benchmark: `http://0.0.0.0:3000/get_git_program?root_path=/home/bimbal/Development/test-repo&commit_id=505130931b37ed91d80b32dfdd0f26b7de228c92`

2. Run the framework of your choice (e.g: Rust Axum):

   ```bash
   cd rust-axum
   cargo run --release
   ```

3. Open a new terminal to benchmark!

   ```bash
   ./bench.sh
   ```

## 📈 Results

💻 Machine specs:

- **CPU**: AMD Ryzen 9 6900HS Creator Edition (16) @ 3.300GHz
- **Memory**: 32 GB (6400 Mhz)
- **OS**: EndeavourOS Linux x86_64
- **Kernel**: 6.1.71-1-lts
- **Environments**:
  | Language | Version |
  | ---------- | --------------- |
  | Rust | 1.75.0 (stable) |
  | JavaScript | 20.10.0 (LTS) |
  | Ruby | 3.3.0 |

> 🚩 Legends
>
> - 64, 256, 512, etc.: number of connections to keep open

### Request Per Second

| Language   | Framework             | Req/Sec (64) | Req/Sec (256) | Req/Sec (512) |
| ---------- | --------------------- | -----------: | ------------: | ------------: |
| Rust       | Axum                  |     11852.28 |      11560.11 |      11452.11 |
| Ruby       | Puma (multi)          |      5629.66 |       5487.81 |       5473.44 |
| JavaScript | Fastify (multi - pm2) |      3321.60 |       3520.78 |       3596.18 |
| JavaScript | Express (multi - pm2) |      3314.32 |       3517.49 |       3630.15 |
| JavaScript | Fastify               |      1374.95 |       1182.23 |       1154.17 |
| JavaScript | Express               |      1153.97 |       1046.26 |       1016.96 |
| Ruby       | Puma                  |       649.61 |        614.39 |        591.86 |

### Average Latency

| Language   | Framework             | Avg. Latency (64) | Avg. Latency (256) | Avg. Latency (512) |
| ---------- | --------------------- | ----------------: | -----------------: | -----------------: |
| Rust       | Axum                  |           5.42 ms |           22.15 ms |           45.26 ms |
| Ruby       | Puma (multi)          |          11.37 ms |          105.59 ms |          244.38 ms |
| JavaScript | Fastify (multi - pm2) |          19.45 ms |           72.32 ms |          140.95 ms |
| JavaScript | Express (multi - pm2) |          19.50 ms |           72.22 ms |          140.05 ms |
| JavaScript | Fastify               |          46.56 ms |          213.71 ms |          435.53 ms |
| JavaScript | Express               |          55.42 ms |          242.21 ms |          497.15 ms |
| Ruby       | Puma                  |          27.76 ms |           23.66 ms |           24.80 ms |
