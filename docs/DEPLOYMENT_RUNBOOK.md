# ACool Deployment & Operations Runbook

## Prerequisites

- Docker & Docker Compose installed
- macOS, Linux, or Windows (WSL2)
- 8GB+ RAM
- 50GB+ disk space for volumes

---

## Local Development Setup

### 1. Clone & Navigate
```bash
cd ~/acool-docker-universal-v5
```

### 2. Environment File
```bash
cp .env.prod .env
```

### 3. Generate SSL Certificates (Local Development)
```bash
mkdir -p nginx/ssl

# Self-signed cert for local testing
openssl req -x509 -newkey rsa:4096 -keyout nginx/ssl/acool.ai.key -out nginx/ssl/acool.ai.crt -days 365 -nodes \
  -subj "/C=US/ST=CA/L=Los Angeles/O=ACool/CN=acool.ai"
```

### 4. Start Full Stack
```bash
docker compose -f docker-compose.prod.yml --env-file .env up -d --build
```

### 5. Wait for Health Checks
```bash
sleep 30
docker ps
```

---

## Service Verification

### Health Checks
```bash
# Main API
curl http://localhost:8080/health

# Router
curl http://localhost:3600/health

# Skills API
curl http://localhost:3700/health

# Apps
curl http://localhost:3100  # Project
curl http://localhost:3200  # Academy
curl http://localhost:3300  # Portal
curl http://localhost:3400  # Prompt
curl http://localhost:3500  # Dashboard
```

### Test API Endpoints
```bash
# Get info
curl http://localhost:8080/api/v1/info

# Create manager
curl -X POST http://localhost:8080/api/v1/managers \
  -H "Content-Type: application/json" \
  -d '{"name":"Keith","email":"keith@acool.ai","phone":"+1-818-794-9346","company":"ACool"}'

# Get talents
curl http://localhost:8080/api/v1/talents
```

---

## Database Management

### Initialize Database
```bash
docker exec acool-postgres psql -U acool -d acool -c "
SELECT * FROM information_schema.tables WHERE table_schema='public';
"
```

### Backup Database
```bash
docker exec acool-postgres pg_dump -U acool acool > acool_backup_$(date +%Y%m%d).sql
```

### Restore Database
```bash
docker exec -i acool-postgres psql -U acool acool < acool_backup_20250616.sql
```

### Connect to PostgreSQL
```bash
docker exec -it acool-postgres psql -U acool -d acool
```

---

## Redis Cache Management

### Connect to Redis
```bash
docker exec -it acool-redis redis-cli -a "$REDIS_PASSWORD"
```

### Check Redis Health
```bash
docker exec acool-redis redis-cli -a "$REDIS_PASSWORD" PING
```

### Clear Cache
```bash
docker exec acool-redis redis-cli -a "$REDIS_PASSWORD" FLUSHALL
```

---

## MinIO S3 Storage

### Access MinIO Console
- URL: `http://localhost:9001`
- User: `acoolminio`
- Password: `<from .env>`

### CLI Access
```bash
docker exec acool-minio mc ls local
```

---

## Monitoring & Logs

### View Service Logs
```bash
# All services
docker compose -f docker-compose.prod.yml logs -f

# Specific service
docker compose -f docker-compose.prod.yml logs -f acool-ecosystem-api

# Recent logs only
docker compose -f docker-compose.prod.yml logs acool-ecosystem-api | tail -100
```

### Prometheus Metrics
```bash
curl http://localhost:9090/api/v1/query?query=up
```

### Grafana Dashboard
- URL: `http://localhost:3001`
- User: `admin`
- Password: `<from .env: GRAFANA_ADMIN_PASSWORD>`

---

## Scaling & Performance

### Increase Memory Allocation
Edit `docker-compose.prod.yml`:
```yaml
services:
  acool-ecosystem-api:
    # Add
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

### Horizontal Scaling (Multiple Replicas)
```yaml
services:
  acool-ecosystem-api:
    deploy:
      replicas: 3
```

### Load Testing
```bash
docker run --rm --network acool-network \
  loadimpact/k6 run --vus 100 --duration 30s \
  http://acool-ecosystem-api:8080/api/v1/talents
```

---

## Troubleshooting

### Container Won't Start
```bash
# Check logs
docker compose -f docker-compose.prod.yml logs acool-ecosystem-api

# Rebuild
docker compose -f docker-compose.prod.yml up -d --build --force-recreate
```

### Database Connection Issues
```bash
# Test connection
docker exec acool-postgres pg_isready -U acool -d acool

# Check network
docker network ls
docker network inspect acool-network
```

### Port Already in Use
```bash
# Find process using port 8080
lsof -i :8080

# Kill process
kill -9 <PID>
```

### Out of Memory
```bash
# Check memory usage
docker stats

# Prune unused resources
docker system prune -a --volumes
```

---

## Production Deployment

### Pre-Deployment Checklist
- [ ] SSL certificates installed
- [ ] Environment secrets secured
- [ ] Backups configured
- [ ] Monitoring alerts set
- [ ] Database replicas ready
- [ ] Load balancer configured

### Deploy to Production
```bash
# On production server
cd /opt/acool-docker-universal-v5

# Pull latest
git pull origin main

# Deploy
docker compose -f docker-compose.prod.yml \
  --env-file .env.production \
  up -d --build

# Verify
docker ps
curl https://api.acool.ai/health
```

### Blue-Green Deployment
```bash
# Tag images
docker tag acool-ecosystem-api:latest acool-ecosystem-api:v1.0

# Run parallel stack
docker compose -f docker-compose.blue.yml up -d

# Test blue stack
curl http://localhost:9080/health

# Switch traffic (nginx)
# Update nginx upstream to point to blue stack
# docker exec acool-nginx nginx -s reload

# Take down green stack
docker compose -f docker-compose.green.yml down
```

---

## Backup & Disaster Recovery

### Daily Backups
```bash
#!/bin/bash
DATE=$(date +%Y%m%d)
docker exec acool-postgres pg_dump -U acool acool > /backups/acool_$DATE.sql
docker exec acool-minio mc cp local/acool-assets /backups/minio_$DATE.tar
```

### Restore from Backup
```bash
# Stop services
docker compose -f docker-compose.prod.yml down

# Restore data
docker exec -i acool-postgres psql -U acool acool < /backups/acool_20250616.sql

# Restart
docker compose -f docker-compose.prod.yml up -d
```

---

## Security

### SSL/TLS Certificate Renewal
```bash
# Using Let's Encrypt
docker run --rm -it \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/www/certbot:/var/www/certbot \
  certbot/certbot certonly --standalone \
  -d acool.ai -d *.acool.ai
```

### Secrets Management
```bash
# Use environment file
export $(cat .env.production | xargs)

# Never commit secrets
echo ".env*" >> .gitignore
```

### Network Security
```bash
# Restrict Postgres to internal network only
# Edit docker-compose.prod.yml - remove postgres ports exposure
```

---

## Maintenance

### Health Check Status
```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

### Update Services
```bash
# Pull latest images
docker compose -f docker-compose.prod.yml pull

# Rebuild services
docker compose -f docker-compose.prod.yml up -d --build
```

### Clean Up
```bash
# Remove stopped containers
docker compose -f docker-compose.prod.yml rm

# Remove dangling images
docker image prune -f

# Remove unused volumes
docker volume prune -f
```

---

## Support & Documentation

- API Docs: `./docs/API_DOCUMENTATION.md`
- GitHub: `https://github.com/ACoolNerd/ACool_ai.git`
- Issues: Create GitHub issues for bugs/features

---

**Last Updated**: June 16, 2025
**Operator**: ACoolNERD
**Phase**: MEAP Phase 2
