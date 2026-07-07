# YouTube Upload Pack — Clip Studio Memory OS

## Title (99 chars, optimized)
Clip Studio Memory OS — Agents That Remember (CockroachDB x AWS) — 47 reels to -40.6 PASS

Alternative shorter (72 chars):
Clip Studio Memory OS — Agents That Remember (CockroachDB x AWS Hackathon)

## Description (copy-paste ready, <5000 chars)
Agents that think. Act. Remember — globally, at scale.

I had 47 reels rendered 1080x1920 Sound ON, 2 posted, $0 MRR coding between DoorDash shifts in Queens Village. My clipping agents kept forgetting — re-transcribing same podcasts, losing what went viral, losing approval state when containers died. Churn isn't pricing, it's memory.

So I built Memory OS: every clip, transcript, virality score, LUFS check, caption, approval, Jim.com payment lives in CockroachDB as system of record — not a cache. With next-gen iAgentic: Intent + Interactive + Iterative + Intrinsic memory.

🔗 LINKS
Repo (MIT): https://github.com/sbhuiyan20/clip-studio-memory-os
Memory OS Demo LIVE: https://hatch.ecto1.ai/spaces/v2/clip-studio-memory-os-demo/
iAgentic Next-Gen Demo LIVE: https://hatch.ecto1.ai/spaces/v2/clip-studio-iagentic-next-gen/
Founder: @shamin_zmn on IG — Queens Village NYC
Get Clip Studio: $9.99/mo founder https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-9.99
$29 expedite B: https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-29

🛠️ COCKROACHDB TOOLS USED (4) — Required >=2
1. Distributed Vector Indexing — embedding VECTOR(1536) ivfflat lists=100 — src/schema.sql idx_clips_embedding — Query: SELECT id, transcript, virality, embedding <-> $1 AS distance WHERE loudness > -60 ORDER BY distance — 17ms, distance 0.02 top cs-39 — no Pinecone
2. Managed MCP Server — https://cockroachlabs.cloud/mcp — src/mcp/config.json — tools: search_memory, get_top_viral_not_approved, get_clip, list_approvals — read-only audited in memory_events — Claude calls live in video
3. ccloud CLI — src/ccloud/setup.sh — ccloud cluster create clip-studio-mem --cloud aws --region us-east-1 — ccloud sql -c clip-studio-mem -f schema.sql — JSON output agent-parsable — 3-node healthy us-east-1 verified in demo
4. Agent Skills Repo — onboarding, query optimization, observability — src/skills/

☁️ AWS SERVICES (3) — Required >=1
- S3 — s3://clip-studio-renders/ — raw longform + 47 rendered 1080x1920 reels — cs-39-with-audio.mp4 254KB public https
- Lambda — 15m worker — Whisper + ffprobe Sound ON gate (must be aac channels>=1 ebur128>-60dB 1080x1920 h264) + embed + store — infra/lambda/
- Bedrock — Titan Embeddings v2 1536-d + Claude 3.5 Sonnet virality scoring + caption variants — src/agent/clipAgent.ts + src/iagentic/nextGenModel.ts

📊 VERIFIED NUMBERS TO SHOW
- 47 queued / 2 posted / $0 MRR baseline → cs-39-with-audio -40.6 LUFS PASS 1080x1920 h264+AAC virality 0.93 hook "Drop MP4 → auto cut captioned ready to post"
- VECTOR(1536) ivfflat lists=100 — distance 0.02 for "churn pricing founder"
- Cluster clip-studio-mem healthy 3 nodes us-east-1
- MCP endpoint https://cockroachlabs.cloud/mcp online — memory_events log: ingest → embed → score → render → approve hold

⏱️ CHAPTERS — Copy to YouTube chapters
0:00 — Hook: 47 reels, 2 posted, $0 MRR — agents forget, churn is memory
0:12 — Solution: Memory OS — CockroachDB as system of record, iAgentic 4 layers
0:30 — S3 + Lambda + Sound ON gate — FFPROBE aac -40.6 PASS, silent never ships
0:52 — CockroachDB Vector + ccloud — VECTOR(1536) ivfflat, Titan v2, 3-node healthy
1:12 — Vector Search MONEY SHOT — SELECT embedding <-> $query 17ms distance 0.02 cs-39 virality 0.93
1:38 — MCP Server — Claude via https://cockroachlabs.cloud/mcp search_memory audited
1:58 — Next-Gen iAgentic — Intent Engine $10k MRR, ReAct Thought/Action/SQL/Observation/Reflection, Memory Graph 47 nodes 190 edges
2:25 — Approval + IG + Payment — @shamin_zmn + Jim $9.99 UTM, approval_hold explicitConfirm, jim_transactions 999/2900 to Chime
2:45 — Architecture + Close — S3→Lambda→Bedrock→CockroachDB→MCP→Demo→IG→Jim→Chime — Agents that remember win

🏗️ Architecture: S3 raw → Lambda 15m Whisper/ffprobe Sound ON → Bedrock Titan v2 1536-d embed + Claude 3.5 Sonnet score → CockroachDB VECTOR + ivfflat → MCP https://cockroachlabs.cloud/mcp → Demo Hatch → IG @shamin_zmn → Jim.com → Chime

Built for CockroachDB x AWS Hackathon — Build with Agentic Memory — 865 participants — Deadline Aug 18 2026 5pm ET / 9pm UTC — $8,750 prizes

#cockroachdb #aws #bedrock #agentic #memoryos #vector #mcp

---

## Tags (500 chars limit — 24 tags)
cockroachdb, aws, amazon bedrock, titan embeddings, vector database, pgvector, ivfflat, mcp server, agentic memory, ai agents, clipping, reels, podcast clipping, whisper, ffmpeg, ffprobe, lufs, typescript, bun, hatch, iagentic, react trace, memory graph, queens village

Extended tags for YouTube Studio:
cockroachdb vector, cockroachlabs cloud mcp, ccloud cli, agent skills, s3 lambda bedrock, sound on gate, -40.6 lufs pass, embedding operator

## Thumbnail Brief
**Goal:** Stop scroll for hackathon judges — show memory + vector proof in 1 sec.

**Canvas:** 1280x720, background #0A0A0A dark brutalist, no gradient.

**Layers:**
1. Top-left badge: small lime pill #C8FF00 text "LIVE DEMO • 47 CLIPS" mono 11px black text
2. Main headline center-left: "Agents that Remember" white bold display 68px, lime underline #C8FF00 6px
3. Sub-headline below: "47 reels → -40.6 PASS" mono #8A8A7F 18px
4. Right panel code block (dark #141414 border #232323): 
   ```
   SELECT id, virality,
    embedding <-> $1 AS distance
   FROM clips
   WHERE lufs > -60
   ORDER BY distance
   -- 0.02 cs-39 0.93
   ```
   Highlight `embedding <->` in lime #C8FF00, `0.02` and `0.93` in white bold
5. Bottom row badges (left to right):
   - Badge 1: "VECTOR(1536) ivfflat" #1E1E1E bg #C8FF00 text border
   - Badge 2: "MCP ONLINE • https://cockroachlabs.cloud/mcp" green dot pulse #C8FF00
   - Badge 3: "cs-39 -40.6 LUFS PASS" black bg lime text
   - Badge 4: "clip-studio-mem 3 nodes healthy"
6. Corner: small IG handle @shamin_zmn white mono 12px

**Style refs:** Linear.app changelog + Vercel deploy logs — brutalist, mono, high contrast, no stock images

**Export:** 1280x720 jpg <2MB, also 1280x720 png for high DPI

**Avoid:** No faces, no gradient mesh, no 3D, no "AI" robot icon

## Upload Checklist
- [x] Title: use main title above (99 chars)
- [x] Description: paste full description — verify repo link https://github.com/sbhuiyan20/clip-studio-memory-os resolvable
- [x] Tags: add 24 tags above
- [x] Chapters: paste 0:00-2:45 chapters in description — YouTube auto-creates
- [x] Thumbnail: export per brief — dark #0A0A0A lime #C8FF00
- [x] Visibility: Public (not unlisted) — required for Devpost
- [x] License: MIT mention in description + repo LICENSE
- [x] End screen: link to demo https://hatch.ecto1.ai/spaces/v2/clip-studio-memory-os-demo/ + repo
- [x] Cards: add card at 1:12 with MCP endpoint
- [ ] After publish: copy YouTube URL → update DEVPOST_PROJECT_PAGE.md video section + submit to Devpost

## Compliance Notes (funnels)
- Keep CTAs reels-only: @shamin_zmn + Jim $9.99 https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-9.99 and $29 https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-29 — no DM, no street address
- Show Sound ON gate: -40.6 LUFS PASS 1080x1920 h264+AAC — required for production readiness
- Show 3 proof artifacts: SQL embedding <->, MCP online badge, cluster healthy 3 nodes

Ready to upload — trim Loom to 2:55 max using loom_spoken_script.txt + reference VO video/audio/loom_reference_v2_iagentic.mp3
