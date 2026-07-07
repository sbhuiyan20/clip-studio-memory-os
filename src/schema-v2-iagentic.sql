-- Next-Gen iAgentic Memory Extensions
-- Adds episodic intent graph, reflection layer, procedural memory tracking

USE memory;

-- Intent graph (founder goals that never get lost)
CREATE TABLE IF NOT EXISTS intents (
  id STRING PRIMARY KEY,
  goal TEXT NOT NULL,
  priority INT DEFAULT 100,
  target_metric STRING,
  status STRING DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Seed founder intents
INSERT INTO intents (id, goal, priority, target_metric, status) VALUES
('i-10k', 'Hit $10k/mo MRR via reels-only CTAs $9.99/mo', 10, 'MRR', 'active'),
('i-anti-churn', 'Anti-churn: post daily, never ghost 10 days', 20, 'retention', 'active'),
('i-viral-story', 'Viral founder story: Queens Village DoorDash shifts origin', 30, 'virality', 'active')
ON CONFLICT (id) DO NOTHING;

-- Agent traces (ReAct thought-action-observation)
CREATE TABLE IF NOT EXISTS agent_traces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  intent_id STRING REFERENCES intents(id),
  query TEXT,
  step_num INT,
  thought TEXT,
  action STRING,
  action_input JSONB,
  observation TEXT,
  sql_query TEXT,
  latency_ms INT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_traces_intent ON agent_traces (intent_id, created_at DESC);

-- Reflections (self-improvement)
CREATE TABLE IF NOT EXISTS reflections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  what_worked TEXT,
  what_failed TEXT,
  improvement TEXT,
  metric_delta FLOAT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Procedural memory (how to clip correctly)
CREATE TABLE IF NOT EXISTS procedural_memory (
  id STRING PRIMARY KEY,
  skill TEXT NOT NULL,
  ffmpeg_cmd TEXT NOT NULL,
  success_rate FLOAT DEFAULT 0.95,
  last_used TIMESTAMPTZ DEFAULT now(),
  created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO procedural_memory (id, skill, ffmpeg_cmd, success_rate) VALUES
('proc-sound-on', 'Sound ON gate — never ship silent', 'ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,channels -of json {mp4}', 0.98),
('proc-clip', 'Clip 30s vertical with audio preservation -map 0:a:0', 'ffmpeg -i {input} -ss {start} -t {dur} -vf scale=1080:1920 -c:v libx264 -c:a aac -map 0:a:0 {output}', 0.96),
('proc-caption', 'Founder caption @shamin_zmn + Jim.com $9.99 CTA UTM', 'template', 1.0)
ON CONFLICT (id) DO NOTHING;

-- Memory graph edges (semantic similarity <0.3)
CREATE TABLE IF NOT EXISTS memory_edges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_clip_id UUID REFERENCES clips(id),
  target_clip_id UUID REFERENCES clips(id),
  distance FLOAT,
  reason STRING,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_edges_source ON memory_edges (source_clip_id);
CREATE INDEX IF NOT EXISTS idx_edges_distance ON memory_edges (distance);

-- View for next-gen dashboard
CREATE VIEW IF NOT EXISTS v_iagentic_memory AS
SELECT 
  c.id, c.transcript, c.virality_score, c.audio_lufs, 
  c.embedding <=> '[0,0,0]'::VECTOR AS dummy_distance,
  i.goal as intent_goal, i.priority as intent_priority,
  pm.skill as proc_skill
FROM clips c
LEFT JOIN intents i ON i.id='i-10k'
LEFT JOIN procedural_memory pm ON pm.id='proc-sound-on'
WHERE c.audio_lufs > -60 AND c.width=1080 AND c.height=1920
ORDER BY c.virality_score DESC;
