#!/bin/bash
# Clip Studio Memory OS - ccloud CLI provisioning (Agent-Ready, JSON output)
set -e

# Install ccloud CLI if missing
# curl https://binaries.cockroachdb.com/ccloud/install.sh | bash

echo "Creating CockroachDB cluster..."
ccloud cluster create clip-studio-mem --cloud aws --region us-east-1 --serverless --output json | tee cluster.json

echo "Creating database..."
ccloud sql --cluster clip-studio-mem --execute "CREATE DATABASE IF NOT EXISTS memory;" --output json

echo "Applying schema with Distributed Vector Indexing..."
ccloud sql --cluster clip-studio-mem --database memory --file src/schema.sql --output json

echo "Creating service account for agent..."
ccloud service-account create clip-agent --output json | tee sa.json

echo "Fetching connection string..."
ccloud cluster connection-string create clip-studio-mem --os startup --output json

echo "✅ Memory OS ready - Cluster: clip-studio-mem, DB: memory"
