# Modern SQL Data Warehouse Project

A SQL Server data warehouse built on the **Medallion Architecture** (Bronze → Silver → Gold)

## Architecture
<img width="1118" height="553" alt="Screenshot 2026-08-31 at 5 52 06 PM" src="https://github.com/user-attachments/assets/3ba55724-5e68-41ae-823d-f10d4afd279e" />


| Layer  | Purpose                                                                 |
|--------|--------------------------------------------------------------------------|
| Bronze | Raw data ingested as-is from source systems (CRM, ERP), no transformations. |
| Silver | Cleansed, standardized, and conformed data (deduplicated, typed, joined keys). |
| Gold   | Business-ready star schema — dimension and fact **views** consumed by BI/reporting. |

```
Source Systems (CRM, ERP)
        │
        ▼
   Bronze Layer   (raw ingestion)
        │
        ▼
   Silver Layer   (cleansing & standardization)
        │
        ▼
   Gold Layer      (dimensional model: dim_customers, dim_products, fact_sales)
        │
        ▼
   BI / Reporting / Analytics
```

### Bronze Layer 
This is the first layer int he Medallion Architecure. Here the raw data is bulk loaded from multiple source systems like CSV, ERP, API, Sensor data etc. The data present here doesnt undergo any kind of transformation or cleaning. It acts as the source of truth for the data. 

### Silver Layer
The Silver layer sits between Bronze (raw, as-landed source data) and Gold (business-ready star schema). Its job is to turn messy source extracts from the CRM and ERP systems into **clean, standardized, conformed** tables that the Gold layer can safely join and model.

###  Gold Layer
The Gold layer exposes a simple star schema as SQL views, built from the Silver layer via the `gold.load_gold` stored procedure:
- **`gold.dim_customers`** — customer dimension (demographics, geography)
- **`gold.dim_products`** — product dimension (category, subcategory, cost, line)
- **`gold.fact_sales`** — sales fact table (linked to both dimensions via surrogate keys)

Full column-level definitions and descriptions are documented in [docs/data_catalog.md](docs/data_catalog.md).

## Data Flow 
<img width="860" height="429" alt="image" src="https://github.com/user-attachments/assets/85332699-a5d6-475c-8bd8-9525fb108e57" />

## Data Modeling 
<img width="874" height="570" alt="image" src="https://github.com/user-attachments/assets/13a6e38d-d55e-4338-a86d-29437dbf41c3" />

