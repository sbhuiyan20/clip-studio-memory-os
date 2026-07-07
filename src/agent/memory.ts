/**
 * Clip Studio Memory OS - CockroachDB Memory Layer
 * Uses Distributed Vector Indexing + MCP
 */
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.COCKROACHDB_URL, // ccloud generated
});

export async function storeClip(input: {
  ingest_id: string, start: number, end: number,
  transcript: string, embedding: number[],
  virality: number, lufs: number
}) {
  const res = await pool.query(
    `INSERT INTO clips (ingest_id, start_sec, end_sec, transcript, embedding, virality_score, audio_lufs, audio_codec, width, height, vcodec)
     VALUES ($1,$2,$3,$4,$5,$6,$7,'aac',1080,1920,'h264') RETURNING id`,
    [input.ingest_id, input.start, input.end, input.transcript, JSON.stringify(input.embedding), input.virality, input.lufs]
  );
  await pool.query(`INSERT INTO memory_events (clip_id, event_type, payload) VALUES ($1,'embed',$2)`, [res.rows[0].id, {virality: input.virality}]);
  return res.rows[0].id;
}

export async function searchMemory(queryEmbedding: number[], limit=5) {
  // Agentic Memory: semantic search via CockroachDB Vector Index - no separate vector store
  const res = await pool.query(
    `SELECT id, transcript, virality_score, s3_rendered_key,
            embedding <-> $1::VECTOR as distance
     FROM clips
     WHERE audio_lufs > -60
     ORDER BY distance ASC LIMIT $2`,
    [JSON.stringify(queryEmbedding), limit]
  );
  return res.rows;
}

export async function getTopViralNotApproved() {
  const res = await pool.query(
    `SELECT c.id, vm.hook, c.virality_score FROM clips c
     JOIN viral_moments vm ON vm.clip_id=c.id
     LEFT JOIN approvals a ON a.clip_id=c.id
     WHERE a.status IS NULL OR a.status='hold'
     ORDER BY c.virality_score DESC LIMIT 10`
  );
  return res.rows;
}
