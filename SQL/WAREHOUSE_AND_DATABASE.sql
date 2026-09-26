-- ============================================================
-- Warehouse Setup
-- ============================================================
CREATE OR REPLACE WAREHOUSE AURA_DEV_WH
  WAREHOUSE_SIZE = 'XSMALL'              -- Smallest size, cost‑efficient
  AUTO_SUSPEND = 300                     -- Suspend after 5 minutes idle
  AUTO_RESUME = TRUE                     -- Resume automatically when queried
  INITIALLY_SUSPENDED = TRUE             -- Start in suspended state
  MAX_CONCURRENCY_LEVEL = 8              -- Max queries running in parallel
  MIN_CLUSTER_COUNT = 1                  -- Minimum cluster count
  MAX_CLUSTER_COUNT = 3                  -- Scale up to 3 clusters if needed
  SCALING_POLICY = 'ECONOMY'             -- Cost‑optimized scaling
  STATEMENT_TIMEOUT_IN_SECONDS = 1800    -- Query timeout = 30 minutes
  COMMENT = 'warehouse for saas';
  -- ============================================================
-- Medallion Architecture DDL: Spotify Track Catalog Platform
-- Database: AURA_STREAMS_DB
-- ============================================================

CREATE DATABASE IF NOT EXISTS AURA_STREAMS_DB;

CREATE SCHEMA IF NOT EXISTS AURA_STREAMS_DB.RAW_SCHEMA;
CREATE SCHEMA IF NOT EXISTS AURA_STREAMS_DB.SILVER_SCHEMA;
CREATE SCHEMA IF NOT EXISTS AURA_STREAMS_DB.GOLD_SCHEMA;
CREATE SCHEMA IF NOT EXISTS AURA_STREAMS_DB.ANALYTICS_SCHEMA;
