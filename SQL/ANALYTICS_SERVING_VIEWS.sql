-- ============================================================
-- Analytics Layer: Production-Grade Reporting Views
-- Database: AURA_STREAMS_DB | Schema: ANALYTICS_SCHEMA
-- ============================================================
use warehouse AURA_DEV_WH;
use database  AURA_STREAMS_DB;
-- 1. VW_GENRE_AUDIO_PROFILE
-- Industry Significance: Powers Content Strategy and A&R (Artist & Repertoire) dashboards. 
-- Record labels and streaming platforms use this aggregation to profile what acoustic parameters 
-- (energy, valence, danceability) define specific genres, helping curators optimize mood-based playlists.
CREATE OR REPLACE VIEW AURA_STREAMS_DB.ANALYTICS_SCHEMA.VW_GENRE_AUDIO_PROFILE AS
SELECT 
    g.GENRE_NAME,
    COUNT(f.TRACK_KEY) AS TOTAL_TRACKS,
    ROUND(AVG(f.POPULARITY_SCORE), 2) AS AVG_POPULARITY,
    ROUND(AVG(f.ENERGY), 3) AS AVG_ENERGY,
    ROUND(AVG(f.DANCEABILITY), 3) AS AVG_DANCEABILITY,
    ROUND(AVG(f.VALENCE), 3) AS AVG_VALENCE,
    ROUND(AVG(f.TEMPO), 2) AS AVG_TEMPO,
    ROUND(AVG(f.ACOUSTICNESS), 3) AS AVG_ACOUSTICNESS
FROM AURA_STREAMS_DB.GOLD_SCHEMA.FACT_TRACK_METRICS f
JOIN AURA_STREAMS_DB.GOLD_SCHEMA.DIM_GENRES g ON f.GENRE_KEY = g.GENRE_KEY
GROUP BY g.GENRE_NAME;

-- 2. VW_TOP_ARTISTS_CATALOG
-- Industry Significance: Essential for Talent Acquisition and Partnership management. 
-- It highlights high-impact artists based on catalog footprint and peak algorithmic popularity scores, 
-- giving business development teams quantifiable leverage during licensing negotiations.
CREATE OR REPLACE VIEW AURA_STREAMS_DB.ANALYTICS_SCHEMA.VW_TOP_ARTISTS_CATALOG AS
SELECT 
    a.ARTIST_NAME,
    COUNT(f.TRACK_KEY) AS TRACK_COUNT,
    ROUND(MAX(f.POPULARITY_SCORE), 2) AS PEAK_POPULARITY,
    ROUND(AVG(f.POPULARITY_SCORE), 2) AS AVG_POPULARITY,
    ROUND(AVG(f.DURATION_SECONDS), 2) AS AVG_TRACK_DURATION_SEC
FROM AURA_STREAMS_DB.GOLD_SCHEMA.FACT_TRACK_METRICS f
JOIN AURA_STREAMS_DB.GOLD_SCHEMA.DIM_ARTISTS a ON f.ARTIST_KEY = a.ARTIST_KEY
GROUP BY a.ARTIST_NAME;

-- 3. VW_TRACK_CHARACTERISTICS_DISTRIBUTION
-- Industry Significance: Used by Algorithm & Recommendation Engine teams. 
-- By evaluating feature distributions (such as explicit content ratios, speechiness, and instrumentalness), 
-- data scientists can monitor catalog diversity and fine-tune recommendation models to prevent filter bubbles.
CREATE OR REPLACE VIEW AURA_STREAMS_DB.ANALYTICS_SCHEMA.VW_TRACK_CHARACTERISTICS_DISTRIBUTION AS
SELECT 
    t.CONTENT_RATING,
    COUNT(f.TRACK_KEY) AS TOTAL_TRACKS,
    ROUND(AVG(f.SPEECHINESS), 3) AS AVG_SPEECHINESS,
    ROUND(AVG(f.INSTRUMENTALNESS), 3) AS AVG_INSTRUMENTALNESS,
    ROUND(AVG(f.LIVENESS), 3) AS AVG_LIVENESS,
    ROUND(AVG(f.LOUDNESS), 2) AS AVG_LOUDNESS_DB
FROM AURA_STREAMS_DB.GOLD_SCHEMA.FACT_TRACK_METRICS f
JOIN AURA_STREAMS_DB.GOLD_SCHEMA.DIM_TRACKS t ON f.TRACK_KEY = t.TRACK_KEY
GROUP BY t.CONTENT_RATING;