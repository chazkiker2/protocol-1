FROM boymaas/rust-build:20210715 as planner
WORKDIR /source
COPY . .
RUN cargo chef prepare  --recipe-path recipe.json

# --- CACHER ---
FROM boymaas/rust-build:20210715 AS cacher
WORKDIR /source

COPY --from=planner /source/recipe.json recipe.json
RUN retry --max 10 --interval 15 -- cargo chef cook \
      --release \
      --recipe-path recipe.json 

# --- BUILDER ---
FROM boymaas/rust-build:20210715 AS builder
WORKDIR /source
# Now we copy code, not to influence previous
# caching layer
COPY . .

COPY --from=cacher /source/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo

RUN cargo build --release

# --- RUNTIME ---
FROM debian:buster AS runtime
WORKDIR /app
COPY --from=builder /source/target/release/node .
CMD ["/app/node"]