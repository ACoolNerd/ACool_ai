# ACool Talent Management System - API Documentation

## Overview

The ACool Talent Management System is a comprehensive 10-component solution for managing talent, agencies, content, and production workflows. Built on Node.js/Express, PostgreSQL, Redis, and Docker.

## Base URL

- **Local**: `http://localhost:8080/api/v1`
- **Production**: `https://api.acool.ai/api/v1`

## API Endpoints

### 1. Talents

#### GET /talents
Retrieve all talents (paginated, max 100).
```bash
curl http://localhost:8080/api/v1/talents
```

Response:
```json
{
  "data": [
    {
      "id": 1,
      "name": "Jane Smith",
      "email": "jane@example.com",
      "phone": "+1234567890",
      "role": "Singer",
      "bio": "Professional vocalist",
      "agency_id": 1,
      "is_active": true,
      "created_at": "2025-06-16T10:00:00Z",
      "updated_at": "2025-06-16T10:00:00Z"
    }
  ],
  "count": 1
}
```

#### GET /talents/:id
Retrieve specific talent by ID.
```bash
curl http://localhost:8080/api/v1/talents/1
```

#### POST /talents
Create new talent.
```bash
curl -X POST http://localhost:8080/api/v1/talents \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Smith",
    "email": "jane@example.com",
    "phone": "+1234567890",
    "role": "Singer",
    "bio": "Professional vocalist",
    "agency_id": 1
  }'
```

#### PUT /talents/:id
Update talent.
```bash
curl -X PUT http://localhost:8080/api/v1/talents/1 \
  -H "Content-Type: application/json" \
  -d '{"role": "Lead Singer", "is_active": true}'
```

#### DELETE /talents/:id
Delete talent.
```bash
curl -X DELETE http://localhost:8080/api/v1/talents/1
```

---

### 2. Managers

#### GET /managers
Retrieve all managers.
```bash
curl http://localhost:8080/api/v1/managers
```

#### POST /managers
Create new manager.
```bash
curl -X POST http://localhost:8080/api/v1/managers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Keith",
    "email": "keith@acool.ai",
    "phone": "+1-818-794-9346",
    "company": "ACool Holdings"
  }'
```

---

### 3. Agencies

#### GET /agencies
Retrieve all agencies.

#### POST /agencies
Create new agency.
```bash
curl -X POST http://localhost:8080/api/v1/agencies \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Creative Agency X",
    "email": "contact@agencyx.com",
    "phone": "+1234567890",
    "location": "Los Angeles, CA",
    "website": "https://agencyx.com"
  }'
```

---

### 4. Producers

#### GET /producers
Retrieve all producers.

#### POST /producers
Create new producer.
```bash
curl -X POST http://localhost:8080/api/v1/producers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alex Producer",
    "email": "alex@producer.com",
    "phone": "+1234567890",
    "specialization": "Music Production"
  }'
```

---

### 5. Content

#### GET /content
Retrieve all content.

#### POST /content
Create new content.
```bash
curl -X POST http://localhost:8080/api/v1/content \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Jane Smith - Single Release",
    "description": "New single from Jane Smith",
    "type": "music",
    "talent_id": 1,
    "producer_id": 1,
    "status": "released",
    "url": "https://youtube.com/..."
  }'
```

---

### 6. Calendar Events

#### GET /calendar
Retrieve all calendar events.

#### POST /calendar
Create new event.
```bash
curl -X POST http://localhost:8080/api/v1/calendar \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Studio Recording Session",
    "description": "New album recording",
    "start_date": "2025-07-01T10:00:00Z",
    "end_date": "2025-07-01T14:00:00Z",
    "talent_id": 1,
    "event_type": "recording"
  }'
```

---

### 7. Masters (Contracts)

#### GET /masters
Retrieve all master documents/contracts.

#### POST /masters
Create new contract.
```bash
curl -X POST http://localhost:8080/api/v1/masters \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Smith - Recording Agreement",
    "document_type": "recording_contract",
    "talent_id": 1,
    "agency_id": 1,
    "content": "Contract terms...",
    "signed_date": "2025-06-16"
  }'
```

---

### 8. Workforce

#### GET /workforce
Retrieve all workforce assignments.

#### POST /workforce
Create workforce assignment.
```bash
curl -X POST http://localhost:8080/api/v1/workforce \
  -H "Content-Type: application/json" \
  -d '{
    "talent_id": 1,
    "project_name": "Summer Tour 2025",
    "role": "Lead Performer",
    "start_date": "2025-07-01",
    "end_date": "2025-08-31",
    "status": "active"
  }'
```

---

### 9. RACI Matrix

#### GET /raci
Retrieve RACI matrix entries (Responsible, Accountable, Consulted, Informed).

#### POST /raci
Create RACI entry.
```bash
curl -X POST http://localhost:8080/api/v1/raci \
  -H "Content-Type: application/json" \
  -d '{
    "task_name": "Album Release Strategy",
    "responsible_id": 1,
    "accountable_id": 2,
    "consulted_id": 3,
    "informed_id": 4
  }'
```

---

### 10. API Info

#### GET /api/v1/info
Retrieve API metadata.
```bash
curl http://localhost:8080/api/v1/info
```

Response:
```json
{
  "service": "acool-ecosystem-api",
  "version": "1.0.0",
  "operator": "ACoolNERD",
  "meapPhase": 2,
  "components": [
    "Talents",
    "Managers",
    "Agencies",
    "Producers",
    "Content",
    "Calendar",
    "Masters",
    "Workforce",
    "RACI Matrix",
    "Skills"
  ]
}
```

---

## Data Models

### Talent
```
id: Integer (PK)
name: String
email: String (Unique)
phone: String
role: String
bio: Text
agency_id: Integer (FK → Agencies)
is_active: Boolean
created_at: Timestamp
updated_at: Timestamp
```

### Manager
```
id: Integer (PK)
name: String
email: String (Unique)
phone: String
company: String
created_at: Timestamp
updated_at: Timestamp
```

### Agency
```
id: Integer (PK)
name: String
email: String
phone: String
location: String
website: String
created_at: Timestamp
updated_at: Timestamp
```

### Producer
```
id: Integer (PK)
name: String
email: String (Unique)
phone: String
specialization: String
created_at: Timestamp
updated_at: Timestamp
```

### Content
```
id: Integer (PK)
title: String
description: Text
type: String
talent_id: Integer (FK → Talents)
producer_id: Integer (FK → Producers)
status: String
url: String
created_at: Timestamp
updated_at: Timestamp
```

### Calendar Event
```
id: Integer (PK)
title: String
description: Text
start_date: Timestamp
end_date: Timestamp
talent_id: Integer (FK → Talents)
event_type: String
created_at: Timestamp
updated_at: Timestamp
```

### Master (Contract)
```
id: Integer (PK)
name: String
document_type: String
talent_id: Integer (FK → Talents)
agency_id: Integer (FK → Agencies)
content: Text
signed_date: Timestamp
created_at: Timestamp
updated_at: Timestamp
```

### Workforce
```
id: Integer (PK)
talent_id: Integer (FK → Talents)
project_name: String
role: String
start_date: Timestamp
end_date: Timestamp
status: String
created_at: Timestamp
updated_at: Timestamp
```

### RACI Matrix
```
id: Integer (PK)
task_name: String
responsible_id: Integer (FK → Managers)
accountable_id: Integer (FK → Managers)
consulted_id: Integer (FK → Managers)
informed_id: Integer (FK → Managers)
created_at: Timestamp
updated_at: Timestamp
```

---

## Environment Variables

```env
NODE_ENV=production
PORT=8080
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=acool
POSTGRES_USER=acool
POSTGRES_PASSWORD=<secure-password>
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=<secure-password>
JWT_SECRET=<jwt-secret>
SESSION_SECRET=<session-secret>
```

---

## Authentication

All endpoints require the `X-API-Key` header or JWT token in future versions. Currently open for development.

---

## Error Handling

All errors return JSON with structure:
```json
{
  "error": "Error description"
}
```

HTTP Status Codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `404` - Not Found
- `500` - Server Error

---

## Rate Limiting

Currently unlimited. Production should implement Redis-based rate limiting.

---

## Support

For API issues, check logs:
```bash
docker logs acool-ecosystem-api
```
