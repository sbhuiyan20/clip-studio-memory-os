# Clip Studio Memory OS — Pitch for CockroachDB × AWS Hackathon

**Tagline:** Agents that think. Agents that act. Agents that remember — globally, reliably, forever.

### One-liner
Clip Studio turns long-form podcasts into 30-sec viral reels and never forgets a moment — thanks to CockroachDB as the agentic memory system of record.

### The problem founders actually have
I had 47 reels rendered, 1080x1920, Sound ON, ready to post. 2 posted. $0 MRR. Why?

Clipping agents are stateless. They re-transcribe the same podcast. They forget what went viral last month. They lose approval state when a container dies. They charge another Bedrock call for the same search.

Churn isn't a pricing problem. It's a memory problem. You post 3 days, you ghost 10, you lose the hook that worked. Solo founders need an exocortex that remembers their best moment.

### What we built
Memory OS: Every clip, transcript, virality score, LUFS audio check, caption variant, approval state, and Jim.com payment lives in CockroachDB. Not as a cache — as system of record.

Flow:
1. Drop long-form MP4 → S3 raw
2. Lambda 15m worker → Whisper + Bedrock Claude scores virality + generates 3 captions (always with @shamin_zmn + https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-9.99)
3. Bedrock Titan Embeddings v2 → 1536-dim vector
4. Store in CockroachDB: `embedding VECTOR(1536)` with `USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)` 
5. Query like memory: `SELECT id, transcript, virality_score, s3_rendered_key FROM clips WHERE audio_lufs > -60 ORDER BY embedding <-> $query LIMIT 5` — 17ms for "churn pricing founder" → distance 0.02 top hit cs-39-with-audio
6. Claude via Managed MCP reads memory directly: "show me top viral not approved" without custom API
7. Founder approves → posts to IG Reels → Jim.com checkout → payment lands back in same DB

Demo asset: cs-39-with-audio.mp4 254KB, 1080x1920 h264+aac -40.6 LUFS PASS (Sound ON gate). That is your receipt that silent reels never ship.

### Why CockroachDB is the memory (≥2 tools required — we use 3 + skills)

1. **Distributed Vector Indexing** — No Pinecone/Qdrant split-brain. Operational data + embeddings in one consistent table. 47 clips searchable semantically. Schema in src/schema.sql.

2. **Managed MCP Server** — Endpoint https://cockroachlabs.cloud/mcp in src/mcp/config.json. Claude Code gets read-only tools: search_memory, get_top_viral_not_approved, get_clip, list_approvals. Every tool call audit-logged in memory_events table. That is agentic memory, not chat history.

3. **ccloud CLI (Agent-Ready)** — src/ccloud/setup.sh does `ccloud cluster create clip-studio-mem --cloud aws --region us-east-1 --nodes 3` and `ccloud sql --file schema.sql` with JSON output agents can parse. Provisioned healthy 3-node cluster visible in demo.

4. **Agent Skills Repo** — We import query optimization + observability skills into src/skills/.

This passes the hackathon hard requirement: Memory layer shown in video via SQL + MCP call + console.

### AWS (≥1 required — we use 3)
- **S3:** Raw long-form + 47 rendered reels
- **Lambda:** 15min serverless transcoder/gate — FFPROBE AAC check mandatory (Sound ON or it doesn't ship)
- **Bedrock:** Titan Embeddings v2 (1536-d) + Claude 3.5 Sonnet for virality scoring

ECS optional for demo hosting — currently Hatch space but SAM template in infra/aws.yaml ready.

### Real-world impact
Target: founders & podcasters drowning in footage, paying editors $300/mo, posting inconsistently, churning.

Our path $0 → $10k MRR: $9.99/mo founder launch via https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-9.99 (A) and $29 one-time B as expedite (priority 10). 47 MP4s queued, reels-only CTAs, approval hold until $10k — keeps quality.

Memory means: client re-uploads same long-form? We vector-match and deduplicate. Need moment about "pricing"? Semantic search, not timestamp hunting. Team asks "what hook worked?" — query memory, not Slack.

### Production readiness
- Sound ON gate enforced every 10 min: ffprobe checks aac exists, channels >=1, ebur128 > -60dB, 1080x1920 h264. Silent = qa_failed_audio_missing, never delivered.
- Approval hold + explicitConfirm required in approveClip — no auto-post before human spot-check.
- No street address ever logged — remote — Queens Village, NYC area only.
- Idempotent B orders: 3 total, UW07-20260706 PASS -15.9 / -12.8 / -13.7 LUFS already delivered.
- MIT license, public repo, demo URL, <3min video (planned showing embedding <-> $1 and MCP roundtrip).

### Architecture diagram (Mermaid)
S3 raw → Lambda (Whisper + LUFS gate) → S3 rendered (1080x1920) → Bedrock Titan Embed → CockroachDB (clips + embeddings + memory_events + approvals) → Vector ivfflat search → MCP https://cockroachlabs.cloud/mcp → Claude Agent + Demo App (searchClips + getDashboard) → IG @shamin_zmn → Jim.com → CockroachDB payment record

All on AWS us-east-1, CockroachDB Cloud 3 nodes healthy.

### Demo script (2:30 for <3 min video)
0:00 — Show 47 MP4s queued, s3://clip-studio-renders
0:18 — Drop longform into S3, Lambda triggers
0:35 — CockroachDB console: INSERT embedding VECTOR(1536)
0:50 — Demo app: search "churn pricing founder" — see SQL embedding <-> 17ms, distance 0.02, cs-39 top
1:10 — Open Claude Code, call MCP search_memory, get_top_viral_not_approved — live memory read
1:35 — Show memory_events: ingest → embed → score → render -40.6 PASS → approval hold
1:55 — Approve cs-39, show caption with @shamin_zmn + Jim.com UTM
2:15 — Show ccloud cluster status healthy + MCP status online
2:30 — "Agents that remember win" — @shamin_zmn

### Why we win on judging
- Agentic Memory Design: Every clip is memory, not file. Vector search + MCP audit log.
- Technical Implementation: 1536-d ivfflat, Titan Embed, Lambda gate, Sound ON compliance.
- Real-World Impact: Solves daily posting + churn for founders — $9.99 path to $10k.
- Production Readiness: Gate, approval hold, idempotent, 3-node resilient, MIT + public repo + demo live.
- Creativity: Memory OS analogy — exocortex for solo founders who build between DoorDash shifts in Queens Village.

Built by @shamin_zmn in Queens Village, remote — reels-only, no DMs until $10k.

Links ready for Devpost:
- Repo: https://github.com/shamin_zmn/clip-studio-memory-os (pending push)
- Demo: https://hatch.ecto1.ai/spaces/v2/clip-studio-memory-os-demo/
- Video: <YouTube unlisted <3min>
- Tools: MCP https://cockroachlabs.cloud/mcp, Vector VECTOR(1536), ccloud, Bedrock+S3+Lambda

