# Benchmark Source Control operations served by different web frameworks

Currently, this repo benchmark the following operations:

- List all blobs inside a Git repository at a specified commit.

## 📦 Requirements

- `libgit2`: most Source Control libraries are just bindings of this
- `wrk`: to run benchmark and collect results (why? [see this](https://k6.io/blog/comparing-best-open-source-load-testing-tools))

## 🚀 Usage

1. In `.env`, set your repository absolute path and commit SHA to benchmark. For example:

   ```bash
   # .env
   REPO_PATH=/home/bimbal/Development/test-repo
   COMMIT_SHA=505130931b37ed91d80b32dfdd0f26b7de228c92
   ```

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
  | Language | Version | Using `libgit2`? | Reason |
  | ---------- | --------------- | :--: | -- |
  | Rust | 1.75.0 (stable) | ✅ | |
  | JavaScript | 20.10.0 (LTS) | ✅ | |
  | Ruby | 3.3.0 | ✅ | |
  | Go | 1.21.5 | ❌ | [`git2go`](https://github.com/libgit2/git2go) hasn't had any update since _Oct 2022_ and it's not even compatible with the latest version of `libgit2` now. Therefore, [`go-git`](https://github.com/go-git/go-git) is used instead. |

🗄 Repository specs:

- **No. files**: 23
- **Size**: 47.8 KB

> 🚩 Legends
>
> - 64, 256, 512, etc.: number of connections to keep open
> - Latency _timed out_: there are some requests that exceeds over 5s latency

### Requests Per Second

| Language   | Framework             | Req/Sec (64) | Req/Sec (256) | Req/Sec (512) |
| ---------- | --------------------- | -----------: | ------------: | ------------: |
| Rust       | Axum                  |     11852.28 |      11560.11 |      11452.11 |
| Ruby       | Puma (multi)          |      5629.66 |       5487.81 |       5473.44 |
| Go         | Gorilla - Mux         |      4706.81 |       5663.41 |       5871.46 |
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
| Go         | Gorilla - Mux         |          17.66 ms |           92.94 ms |          157.58 ms |
| JavaScript | Fastify (multi - pm2) |          19.45 ms |           72.32 ms |          140.95 ms |
| JavaScript | Express (multi - pm2) |          19.50 ms |           72.22 ms |          140.05 ms |
| Ruby       | Puma                  |          27.76 ms |           23.66 ms |           24.80 ms |
| JavaScript | Fastify               |          46.56 ms |          213.71 ms |          435.53 ms |
| JavaScript | Express               |          55.42 ms |          242.21 ms |          497.15 ms |

## Research

TBD

## Conclusion

TBD
