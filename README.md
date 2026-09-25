# F1 Telemetry Analytics Platform

A production-grade data platform for Formula 1 race telemetry, built with modern cloud data stack tools.

## Project Overview

This project demonstrates a **cloud data platform** that ingests live Formula 1 race data, transforms it into analytics-ready models, and exposes insights through curated data marts.

### The Story
- **Provisioned** a MotherDuck analytics warehouse with infrastructure-as-code (Terraform)
- **Ingested** real F1 race data from public APIs into raw tables
- **Modeled** the data with dbt into clean, queryable analytics layers
- **Automated** the entire pipeline with GitHub Actions
- Built a **production-like system** that's still easy to understand and demo

## Technology Stack

| Component | Tool | Purpose |
|-----------|------|---------|
| **Infrastructure** | Terraform | Provision MotherDuck warehouse & resources |
| **Data Warehouse** | MotherDuck / DuckDB | OLAP analytics database |
| **Data Ingestion** | Python | Fetch F1 API data, load to raw tables |
| **Data Modeling** | dbt Core | Transform raw → staging → marts |
| **Orchestration** | GitHub Actions | Scheduled runs, CI/CD |
| **Dashboard** | Streamlit (optional) | Interactive analytics UI |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      F1 Open Data API                           │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Python Ingestion Job                          │
│  - Fetch API data (sessions, laps, drivers, circuits, standings)│
│  - Load to RAW layer in MotherDuck                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              MotherDuck Analytics Warehouse                     │
├──────────────────────────────────────────────────────────────────┤
│  RAW LAYER         │ STAGING LAYER      │ MART LAYER            │
│  ─────────────────   ──────────────      ──────────────         │
│  • raw_sessions    │ • stg_sessions     │ • fct_lap_times       │
│  • raw_laps        │ • stg_laps         │ • dim_drivers         │
│  • raw_drivers     │ • stg_drivers      │ • dim_circuits        │
│  • raw_circuits    │ • stg_circuits     │ • agg_performance     │
│  • raw_standings   │ • stg_standings    │                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Analytics & Dashboards                        │
│            (SQL queries, Streamlit app, BI tools)              │
└─────────────────────────────────────────────────────────────────┘
```

## Data Model Layers

### Raw Layer
- **Purpose**: Immutable source of truth
- **Strategy**: Keep original API payloads, capture metadata
- Tables: `raw_sessions`, `raw_laps`, `raw_drivers`, `raw_circuits`, `raw_standings`

### Staging Layer
- **Purpose**: Clean, normalize, deduplicate
- **Strategy**: Fix data types, standardize field names, remove nulls
- Tables: `stg_sessions`, `stg_laps`, `stg_drivers`, `stg_circuits`, `stg_standings`

### Mart Layer (Analytics-Ready)
- **Purpose**: Optimized for specific use cases
- **Fact Tables**:
  - `fct_lap_times` — Every lap: driver, circuit, session, time, telemetry
  - `fct_race_results` — Final standings per race
- **Dimension Tables**:
  - `dim_drivers` — Driver metadata, career stats
  - `dim_circuits` — Track info, location, records
  - `dim_sessions` — Race metadata, weather conditions
- **Aggregate Tables**:
  - `agg_driver_performance` — Career stats, consistency metrics
  - `agg_session_summary` — Race winner, pole, fastest lap, weather

## Project Structure

```
f1-telemetry-platform/
├── terraform/                   # IaC for MotherDuck warehouse
│   ├── main.tf                 # Database & provider config
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   ├── .terraform.lock.hcl      # Locked provider versions
│   └── .gitignore              # Exclude tfvars, state files
│
├── ingestion/                   # Python data pipeline
│   ├── api_client.py           # F1 API client wrapper
│   ├── requirements.txt         # Python dependencies
│   ├── jobs/
│   │   ├── ingest_sessions.py
│   │   ├── ingest_laps.py
│   │   ├── ingest_drivers.py
│   │   ├── ingest_circuits.py
│   │   └── ingest_standings.py
│   └── schemas/                # JSON schemas for validation
│
├── dbt/                         # Data transformations
│   ├── dbt_project.yml         # Project config
│   ├── packages.yml            # dbt dependencies
│   ├── profiles.yml            # MotherDuck connection
│   └── models/
│       ├── raw/                # Raw models (source)
│       ├── staging/            # Cleaned & normalized
│       └── marts/              # Analytics-ready tables
│           ├── facts/
│           ├── dimensions/
│           └── aggregates/
│
├── .github/
│   └── workflows/
│       ├── ingestion.yml       # Daily F1 data ingest
│       └── dbt_run.yml         # nightly transforms
│
├── README.md                   # This file
├── .gitignore                  # Git exclusions
└── LICENSE
```

## Getting Started

### Prerequisites
- Terraform >= 1.5.0
- Python >= 3.10
- MotherDuck account with API token
- dbt >= 1.5.0

### Setup

1. **Clone and setup environment**
   ```bash
   git clone https://github.com/triciaengel/f1-telemetry-platform.git
   cd f1-telemetry-platform
   export MOTHERDUCK_TOKEN="your_token_here"
   ```

2. **Provision the warehouse**
   ```bash
   cd terraform
   terraform init
   terraform apply
   cd ..
   ```

3. **Install Python dependencies**
   ```bash
   cd ingestion
   pip install -r requirements.txt
   cd ..
   ```

4. **Run initial data ingest**
   ```bash
   cd ingestion
   python jobs/ingest_sessions.py
   python jobs/ingest_laps.py
   python jobs/ingest_drivers.py
   python jobs/ingest_circuits.py
   python jobs/ingest_standings.py
   cd ..
   ```

5. **Run dbt transformations**
   ```bash
   cd dbt
   dbt deps
   dbt run
   dbt test
   cd ..
   ```

## Example Queries

Connect to MotherDuck and run analytics:

```sql
-- Top 5 drivers by average lap time
SELECT 
  driver_name,
  circuit_name,
  AVG(lap_time_ms) as avg_lap_ms,
  COUNT(*) as total_laps
FROM marts.fct_lap_times
GROUP BY driver_name, circuit_name
ORDER BY avg_lap_ms ASC
LIMIT 5;
```

## Next Steps / Roadmap

- [ ] Implement Python ingestion jobs for all data sources
- [ ] Build dbt transformation models (raw → staging → marts)
- [ ] Set up GitHub Actions for daily ingest & nightly transforms
- [ ] Add data quality tests in dbt
- [ ] Create Streamlit dashboard for race analysis
- [ ] Add telemetry visualization (lap-by-lap comparisons)
- [ ] Implement incremental loads for performance
- [ ] Add monitoring and alerting for pipeline health
- [ ] Deploy dashboard to cloud (Streamlit Cloud / Render)

## Why This Stack?

| Choice | Rationale |
|--------|-----------|
| **MotherDuck** | Lightweight, serverless, SQL-native analytics |
| **Terraform** | Reproducible infra, version control friendly |
| **dbt** | Standard data modeling language, test-driven transforms |
| **Python** | Simple ingestion, great API libraries |
| **GitHub Actions** | Free CI/CD, native to GitHub workflow |

## Future Enhancements

- Real-time telemetry streaming (instead of batch)
- Machine learning models for race prediction
- Driver performance anomaly detection
- Historical race comparisons
- Fan-friendly dashboards (fastest pit stops, overtakes, etc.)

---

**Built by:** [Your Name]  
**Last Updated:** September 2026  
**License:** MIT
