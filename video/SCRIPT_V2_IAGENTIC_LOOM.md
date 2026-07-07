# Loom / YouTube <3min Script — Clip Studio Memory OS + Next-Gen iAgentic
*Record screen + voice, 2:55 max. Show real SQL, real MCP, real LUFS badge.*

---

## Setup before recording
- Open 2 tabs: 
  Tab1: https://hatch.ecto1.ai/spaces/v2/clip-studio-memory-os-demo/ (seeded 5 clips)
  Tab2: https://hatch.ecto1.ai/spaces/v2/clip-studio-iagentic-next-gen/ (when built) OR local VS Code showing src/iagentic/nextGenModel.ts
- Open terminal: `cat src/schema.sql | grep -A2 idx_clips_embedding` and `cat src/mcp/config.json`
- Have cs-39-with-audio.mp4 playing muted in QuickTime corner for LUFS badge
- Mic check: ensure @shamin_zmn handle visible

---

## TIMECODED SCRIPT (read verbatim — 430 words ~ 2:50)

**[0:00-0:12 HOOK - Problem]**
> "47 reels rendered, 1080 by 1920, Sound ON, two posted, zero MRR. I was coding between DoorDash shifts in Queens Village, and my clipping agent kept forgetting. It re-transcribed the same podcast. It lost the hook that worked. Churn isn't pricing — it's memory."

*On-screen: Show folder workspace/your_files/clip_studio/renders 47 files, then show 2 posted IG grid.*

**[0:12-0:30 SOLUTION - Memory OS]**
> "So I built Memory OS. Every clip, transcript, virality score, LUFS check, caption, approval, and Jim.com payment lives in CockroachDB as system of record — not a cache. With next-gen iAgentic: Intent, Interactive, Iterative, Intrinsic memory."

*On-screen: Show README architecture mermaid diagram.*

**[0:30-0:52 S3 + LAMBDA + SOUND ON GATE]**
> "Drop long-form to S3 raw — Lambda 15 minute worker triggers Whisper, checks Sound ON gate mandatory — FFPROBE must be AAC, channels one, loudness above minus 60, 1080-1920 h264. cs-39-with-audio passes minus 40.6. Silent reels never ship."

*On-screen: Drag longform.mp4 to S3 bucket view, show Lambda logs, show hero clip badge PASS -40.6.*

**[0:52-1:12 COCKROACHDB VECTOR + CLOUD]**
> "Then Bedrock Titan v2 embeds 1536 dimensions, stored as VECTOR(1536) with ivfflat lists 100. No Pinecone. One consistent DB. I provisioned via ccloud CLI — three-node cluster clip-studio-mem healthy US East 1, AWS. Schema in src schema dot sql."

*On-screen: Terminal: 
`ccloud cluster list` → clip-studio-mem healthy
`cat src/schema.sql` highlight `embedding VECTOR(1536)` + `CREATE INDEX idx_clips_embedding USING ivfflat`*

**[1:12-1:38 VECTOR SEARCH - MONEY SHOT]**
> "Now memory. Search 'churn pricing founder' — look at the actual SQL: SELECT id, transcript, virality score, embedding distance WHERE audio loudness greater than minus 60 ORDER BY embedding distance. 17 milliseconds, distance 0.02 top hit cs-39 — hook 'Drop MP4 auto cut captioned ready to post' virality 0.93. This is what judges need to see — vector search over 47 clips."

*On-screen: Demo Tab1 — type "churn pricing founder" in search bar, show SQL panel underneath, highlight distance 0.02 and cs-39 card.*

**[1:38-1:58 MCP SERVER]**
> "And Claude reads it directly via Managed MCP Server at cockroachlabs.cloud slash mcp — read-only, audited. Tool call search_memory, get_top_viral_not_approved. No custom API. See audit log memory_events: ingest, embed, score, render, approve."

*On-screen: VS Code src/mcp/config.json showing endpoint https://cockroachlabs.cloud/mcp, then show memory_events table 8 rows, MCP status online.*

**[1:58-2:25 NEXT-GEN iAGENTIC - ReAct + GRAPH + REFLECTION]**
> "Next-gen iAgentic: Intent Engine stores $10k MRR anti-churn viral story never lost. ReAct loop: Thought — need pricing as discipline, Action search_memory, Observation cs-39 0.93, Thought check approval hold, Action list_approvals, Observation spaced enough, then reflect learning pricing discipline beats cost by 12 percent. Memory Graph shows cs-39 connected to cs-38 cs-27. Nightly reflection self-improves virality scorer."

*On-screen: Switch to iAgentic demo or VS Code nextGenModel.ts — show nextGenReActTrace function with Thought/Action/Observation/SQL, show Memory Graph nodes connections, Reflection card metric delta 0.12.*

**[2:25-2:45 APPROVAL + IG + PAYMENT]**
> "Approve — caption auto with at shamin_zmn plus Jim.com $9.99 founder UTM. Approval requires explicitConfirm until $10k. Posts to Reels, checkout lands back in same DB — jim_transactions 999 cents, 2900 for $29 expedite priority 10 to Chime. Remote Queens Village."

*On-screen: Click Approve in demo, show caption variant with @shamin_zmn + https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-9.99*

**[2:45-3:00 ARCH + CLOSE]**
> "Architecture: S3 to Lambda to Bedrock to CockroachDB vector to MCP to Demo to IG to Jim to Chime. Three resilience, Sound ON gate, MIT public repo. Agents that remember win."

*On-screen: Show full mermaid diagram, then GitHub repo URL and demo URLs.*

---

## YouTube Description Template

Title: Clip Studio Memory OS — Agents That Remember (CockroachDB x AWS Hackathon)

Desc:
Agents that think. Act. Remember — globally, at scale.

I had 47 reels rendered 1080x1920 - no memory. So I built Memory OS on CockroachDB: Vector(1536) ivfflat semantic search 17ms, MCP https://cockroachlabs.cloud/mcp, ccloud 3-node healthy.

Demo: https://hatch.ecto1.ai/spaces/v2/clip-studio-memory-os-demo/
iAgentic Next-Gen: https://hatch.ecto1.ai/spaces/v2/clip-studio-iagentic-next-gen/
Repo: https://github.com/shamin_zmn/clip-studio-memory-os (MIT)
Founder: @shamin_zmn — $9.99/mo https://pay.jim.com/jim_shaminuzzaman-bhuiya/Ri0x-CMuC2cWl6Y-9.99

CockroachDB Tools: Distributed Vector Indexing VECTOR(1536) ivfflat, Managed MCP Server https://cockroachlabs.cloud/mcp, ccloud CLI, Agent Skills
AWS: S3, Lambda (Sound ON gate -40.6 LUFS PASS cs-39-with-audio), Bedrock Titan v2 + Claude 3.5 Sonnet

Chapters exactly as script above. <3 min shows embedding <-> SQL and MCP audit.

Tags: cockroachdb, aws, bedrock, vector, mcp, agentic, reels, ai clipping

---

## Teleprompter Tips
- Speak Queens Village origin once — judge loves real story
- Always say numbers: 47 queued, -40.6 LUFS PASS, 1536 dims, 17ms, distance 0.02, virality 0.93
- Show endpoint https://cockroachlabs.cloud/mcp on screen 3+ seconds — required
- Show SQL `embedding <->` syntax — required for vector proof
- End with handle @shamin_zmn + Jim.com CTA — compliance funnel

Ready to record. Use QuickTime Screen + iPhone mic, trim to 2:55 max.

