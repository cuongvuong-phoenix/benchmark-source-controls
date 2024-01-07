# Benchmark Source Control implementation between different web frameworks

## 📦 Requirements

- `wrk` to run benchmark and collect results (why? [see this](https://k6.io/blog/comparing-best-open-source-load-testing-tools))
- `postgresql` to store the results
- `docker` as anisolated running environment of each framework
- `jq` to process Docker metadata

## ⚒ Usage

1. The servers are programmed to listen on an endpoint with signature `/get_git_program/:root_path/:commit_id`. Therefore, you need to create/use a Git Repository and specify its absolute path inside [`bench.sh`](./bench.sh) (remember to escape `/` in the URL by using `%2F` instead). And then specify the commit SHA to fetch all files. For example:
    - Repo path: `/home/bimbal/Development/test-repo`
    - Commit SHA: `505130931b37ed91d80b32dfdd0f26b7de228c92`
    - Endpoint to benchmark: `http://0.0.0.0:3000/get_git_program/%2Fhome%2Fbimbal%2FDevelopment%2Ftest-repo/505130931b37ed91d80b32dfdd0f26b7de228c92`

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
  | Language   | Version         |
  | ---------- | --------------- |
  | Rust       | 1.75.0 (stable) |
  | JavaScript | 20.10.0 (LTS)   |
  | Ruby       | 3.3.0           |

> 🚩 Legends
>
> - 64, 256, 512, etc.: number of connections to keep open

### Request Per Second

| Language   | Framework             | Req/Sec (64) | Req/Sec (256) | Req/Sec (512) |
| ---------- | --------------------- | -----------: | ------------: | ------------: |
| Rust       | Axum                  |      9947.53 |      10257.90 |      10309.27 |
| Ruby       | Puma (multi)          |      5126.97 |       4874.02 |       4815.19 |
| JavaScript | Fastify (multi - pm2) |      2995.99 |       3181.48 |       3295.10 |
| JavaScript | Express (multi - pm2) |      2586.02 |       2821.25 |       3066.97 |
| JavaScript | Fastify               |      1231.40 |       1093.87 |       1089.53 |
| JavaScript | Express               |      1054.51 |        951.61 |        951.29 |
| Ruby       | Puma                  |       701.56 |        729.88 |        729.77 |

### Average Latency

| Language   | Framework             | Avg. Latency (64) | Avg. Latency (256) | Avg. Latency (512) |
| ---------- | --------------------- | ----------------: | -----------------: | -----------------: |
| Rust       | Axum                  |           6.49 ms |           25.10 ms |           50.39 ms |
| Ruby       | Puma (multi)          |          12.49 ms |          118.68 ms |          183.22 ms |
| JavaScript | Fastify (multi - pm2) |          21.78 ms |           79.91 ms |          154.16 ms |
| JavaScript | Express (multi - pm2) |          25.18 ms |           90.46 ms |          164.44 ms |
| JavaScript | Fastify               |          51.90 ms |          231.54 ms |          458.39 ms |
| JavaScript | Express               |          60.59 ms |          263.85 ms |          527.08 ms |
| Ruby       | Puma                  |         162.00 ms |            9.08 ms |            8.05 ms |
