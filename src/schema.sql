-- Clip Studio Memory OS - CockroachDB Schema with Distributed Vector Indexing
-- Agentic Memory: never forget a clip, client, or viral moment

CREATE DATABASE IF NOT EXISTS memory;
USE memory;

-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Users / founders
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  handle STRING NOT NULL, -- @shamin_zmn
  jim_checkout_url STRING,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Long-form ingests (S3 raw source)
CREATE TABLE IF NOT EXISTS ingests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  s3_key STRING NOT NULL,
  s3_bucket STRING NOT NULL,
  source_url STRING,
  duration_seconds FLOAT,
  transcript TEXT,
  status STRING DEFAULT 'pending', -- pending, transcribed, embedded, clipped
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Clips - core memory with vector
CREATE TABLE IF NOT EXISTS clips (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ingest_id UUID REFERENCES ingests(id),
  start_sec FLOAT NOT NULL,
  end_sec FLOAT NOT NULL,
  transcript TEXT,
  virality_score FLOAT DEFAULT 0.0,
  caption_variant1 TEXT,
  caption_variant2 TEXT,
  caption_variant3 TEXT,
  s3_rendered_key STRING,
  audio_lufs FLOAT, -- Sound ON gate: must be > -60
  audio_codec STRING, -- must be aac
  width INT DEFAULT 1080,
  height INT DEFAULT 1920,
  vcodec STRING DEFAULT 'h264',
  embedding VECTOR(1536), -- Bedrock Titan v2
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Distributed Vector Index - semantic search across clips at scale
CREATE INDEX IF NOT EXISTS idx_clips_embedding ON clips USING ivfflat (embedding vector_l2_ops) WITH (lists = 100);

-- Viral moments - agent detections
CREATE TABLE IF NOT EXISTS viral_moments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clip_id UUID REFERENCES clips(id),
  hook TEXT, -- first 3 sec hook
  reason TEXT, -- why viral per Claude
  score FLOAT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Approvals - human in loop until $10k MRR
CREATE TABLE IF NOT EXISTS approvals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clip_id UUID REFERENCES clips(id),
  status STRING DEFAULT 'hold', -- hold, approved, rejected
  approved_at TIMESTAMPTZ,
  ig_media_id STRING,
  ig_permalink STRING,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Memory events - agent audit log
CREATE TABLE IF NOT EXISTS memory_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clip_id UUID,
  event_type STRING, -- ingest, embed, score, approve, publish, checkout
  payload JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Jim transactions - $9.99/$29 to Chime
CREATE TABLE IF NOT EXISTS jim_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  clip_id UUID,
  amount_cents INT, -- 999 or 2900
  checkout_url STRING,
  status STRING DEFAULT 'pending', -- pending, paid, settled_chime
  stripe_id STRING,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Semantic search helper view
CREATE VIEW IF NOT EXISTS v_clip_memory AS
SELECT c.id, c.transcript, c.virality_score, c.audio_lufs, c.s3_rendered_key,
       vm.hook, a.status as approval_status
FROM clips c
LEFT JOIN viral_moments vm ON vm.clip_id = c.id
LEFT JOIN approvals a ON a.clip_id = c.id
WHERE c.audio_lufs > -60 AND c.width=1080 AND c.height=1920;
