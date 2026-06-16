# ACool Onboarding Guide

## For New Team Members

Welcome to ACool Ecosystem! This guide helps you get started with the platform.

---

## 1. Environment Setup (15 minutes)

### Install Requirements
- Docker Desktop (macOS/Windows) or Docker + Docker Compose (Linux)
- Git
- Node.js 20+ (for local development)
- PostgreSQL client (optional): `brew install postgresql`

### Clone Repository
```bash
git clone https://github.com/ACoolNerd/ACool_ai.git
cd acool-docker-universal-v5
```

### Set Up Environment
```bash
cp .env.prod .env
```

### Start Services
```bash
docker compose -f docker-compose.prod.yml up -d --build
sleep 30
docker ps
```

### Verify Services
```bash
curl http://localhost:8080/health     # Main API
curl http://localhost:3600/health     # Router
curl http://localhost:3700/health     # Skills API
curl http://localhost:3001            # Grafana (admin/password)
```

---

## 2. Understand the Architecture (30 minutes)

### 13-Service Ecosystem

**Infrastructure:**
- PostgreSQL (port 5432) - Relational database
- Redis (port 6379) - Cache & job queue
- MinIO (port 9000) - S3-compatible object storage

**Core APIs:**
- acool-ecosystem-api (port 8080) - Main business logic
- acool-router (port 3600) - API routing & composition
- acool-skills-api (port 3700) - Skills management

**Applications:**
- acool-project (port 3100) - Project management
- acool-academy (port 3200) - Learning platform
- gardy-portal (port 3300) - Concierge/portal
- prompt-runtime (port 3400) - AI prompt execution
- skills-dashboard (port 3500) - Team analytics

**Infrastructure:**
- Nginx (ports 80/443) - Reverse proxy & SSL termination
- Prometheus (port 9090) - Metrics collection
- Grafana (port 3001) - Dashboards & alerting

**Workers:**
- acool-worker - Background job processor

---

## 3. Core Concepts (20 minutes)

### Talent Management System (10 Components)

1. **Talents** - Performers, artists, team members
   - Create talent profiles with bio, contact, specialization
   - Track agency assignments
   - Monitor active status

2. **Managers** - Team leads, supervisors
   - Assign responsibilities (RACI matrix)
   - Track company assignments

3. **Agencies** - Representation agencies, companies
   - Partner agencies for talent representation
   - Track contact & location

4. **Producers** - Content/project producers
   - Music, film, event producers
   - Track specialization

5. **Content** - Deliverables, assets
   - Tracks produced content (music, video, documents)
   - Links talents to content
   - Manages content status

6. **Calendar** - Events & scheduling
   - Studio sessions, performances, meetings
   - Team calendar synchronization

7. **Masters** - Contracts & agreements
   - Recording contracts, endorsement deals
   - Document storage & signing

8. **Workforce** - Team assignments
   - Project assignments
   - Start/end dates & roles

9. **RACI Matrix** - Responsibility tracking
   - Responsible, Accountable, Consulted, Informed
   - Task-level clarity

10. **Skills** - Competency management
    - Singing, dancing, production, etc.
    - Talent skill mapping

---

## 4. Making Your First API Call (10 minutes)

### Create a Manager
```bash
curl -X POST http://localhost:8080/api/v1/managers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Your Name",
    "email": "you@acool.ai",
    "phone": "+1-818-794-9346",
    "company": "ACool"
  }'
```

### Create a Talent
```bash
curl -X POST http://localhost:8080/api/v1/talents \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Artist Name",
    "email": "artist@example.com",
    "role": "Singer",
    "bio": "Professional vocalist"
  }'
```

### List Talents
```bash
curl http://localhost:8080/api/v1/talents
```

Full API docs: `./docs/API_DOCUMENTATION.md`

---

## 5. Database Access (10 minutes)

### Connect to PostgreSQL
```bash
docker exec -it acool-postgres psql -U acool -d acool
```

### View Tables
```sql
\dt
SELECT * FROM talents LIMIT 5;
```

### Backup Database
```bash
docker exec acool-postgres pg_dump -U acool acool > acool_backup.sql
```

---

## 6. Monitoring & Logs (10 minutes)

### View Logs
```bash
# All services
docker compose -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.prod.yml logs -f acool-ecosystem-api
```

### Grafana Dashboard
- URL: http://localhost:3001
- Login: admin / (from .env)
- Explore metrics & alerts

### Check Health
```bash
# Get service info
curl http://localhost:8080/api/v1/info
```

---

## 7. Development Workflow

### Adding a New Endpoint

**1. Update Database Schema** (if needed)
```sql
-- In database/001_talent_schema.sql
ALTER TABLE talents ADD COLUMN new_column VARCHAR(255);
```

**2. Modify API** 
```javascript
// In services/acool-ecosystem-api/src/index.js
app.get('/api/v1/talents/:id', async (req, res) => {
  // Your endpoint logic
});
```

**3. Rebuild & Test**
```bash
docker compose -f docker-compose.prod.yml up -d --build
curl http://localhost:8080/api/v1/talents/1
```

### Hot Reload (Development)
```bash
cd services/acool-ecosystem-api
npm install
npm run dev   # Uses --watch flag for auto-reload
```

---

## 8. Common Commands

### Start/Stop
```bash
docker compose -f docker-compose.prod.yml up -d      # Start
docker compose -f docker-compose.prod.yml down       # Stop
docker compose -f docker-compose.prod.yml restart    # Restart
```

### View Status
```bash
docker ps                              # Running containers
docker compose -f docker-compose.prod.yml logs -f    # Live logs
docker stats                           # Resource usage
```

### Rebuild
```bash
docker compose -f docker-compose.prod.yml up -d --build
```

### Debug
```bash
docker exec -it acool-ecosystem-api /bin/sh          # Shell access
docker logs acool-ecosystem-api                      # Recent logs
docker inspect acool-ecosystem-api                   # Container details
```

---

## 9. Troubleshooting

### Container Won't Start?
```bash
# Check logs
docker logs acool-ecosystem-api

# Rebuild
docker compose -f docker-compose.prod.yml up -d --build --force-recreate
```

### Database Connection Error?
```bash
# Check if postgres is healthy
docker ps | grep postgres

# Test connection
docker exec acool-postgres pg_isready -U acool -d acool
```

### Port Already in Use?
```bash
# Find process
lsof -i :8080

# Kill process (if safe)
kill -9 <PID>
```

---

## 10. Next Steps

1. **Complete API Onboarding** - Familiarize yourself with all 10 components
2. **Read Full Docs** - `./docs/API_DOCUMENTATION.md`
3. **Set Up IDE** - VS Code, WebStorm with Docker extension
4. **Create a Feature Branch** - `git checkout -b feature/your-feature`
5. **Deploy to Dev** - Test in isolated environment
6. **Ask Questions** - Slack, GitHub Issues, or team meetings

---

## Resources

- **GitHub**: https://github.com/ACoolNerd/ACool_ai.git
- **API Docs**: `./docs/API_DOCUMENTATION.md`
- **Deployment**: `./docs/DEPLOYMENT_RUNBOOK.md`
- **Contact**: @ACoolNERD (Slack)

---

**Welcome aboard!** 🚀
