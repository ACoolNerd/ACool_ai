import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { Pool } from 'pg';
import { createClient } from 'redis';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 8080;
const VERSION = '1.0.0';
const GOVERNANCE = 'Rights → Disclosure → Proof';
const BRANDS = [
  'ACoolECOSYSTEM',
  'ACoolNERD',
  'ACoolAI',
  'ACoolDASHBOARD',
  'ACoolACADEMY',
  'ACoolVAULT',
  'FashionbyKukanaana',
  'ACoolCITYHALLCONNECT',
  'Gardy Portal',
  'ACool Skills API',
  'ACool Router',
  'Prompt Runtime',
  'LA28 Vendor Tracker'
];

function healthPayload(service) {
  return {
    ok: true,
    service,
    mode: 'production',
    governance: GOVERNANCE,
    timestamp: new Date().toISOString()
  };
}

// ===== ACoolSCHEMA 7-field law — API-boundary normalization =====
// database/migrations/002 and 003 added entity/owner/type/status/metadata to
// every table, but 4 tables (content, calendar_events, raci_matrix, workforce)
// still store their human-readable label under a column other than `name`
// (title / task_name / project_name) — see docs/governance/ACoolSCHEMA_REGISTRY.md
// §3-4 step 3. Renaming those columns would break every existing query and
// app code path that references them; this map instead adds a normalized
// `name` field to API responses without touching the underlying column,
// schema, or stored data in any way.
const NAME_FIELD_BY_TABLE = {
  content: 'title',
  calendar_events: 'title',
  raci_matrix: 'task_name',
  workforce: 'project_name',
};

// Adds `name` (if missing) by reading the table's actual label column.
// Never overwrites an existing `name` value — purely additive.
function withNormalizedName(table, row) {
  if (!row || typeof row !== 'object') return row;
  if (row.name !== undefined && row.name !== null) return row;
  const sourceField = NAME_FIELD_BY_TABLE[table];
  if (!sourceField) return row;
  return { ...row, name: row[sourceField] ?? null };
}

function withNormalizedNames(table, rows) {
  return rows.map((row) => withNormalizedName(table, row));
}

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('json'));
app.use(express.json());

// Database
const pool = new Pool({
  host: process.env.POSTGRES_HOST,
  port: process.env.POSTGRES_PORT || 5432,
  database: process.env.POSTGRES_DB,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
});

// Redis
const redis = createClient({
  socket: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379'),
  },
  password: process.env.REDIS_PASSWORD || undefined,
});

redis.on('error', (err) => console.error('Redis error:', err));

// Health check
app.get('/health', (req, res) => {
  res.status(200).json(healthPayload('ACoolECOSYSTEM API'));
});

// ===== TALENT ENDPOINTS =====
app.get('/api/v1/talents', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM talents ORDER BY created_at DESC LIMIT 100');
    res.json({ data: result.rows, count: result.rows.length });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch talents' });
  }
});

app.get('/api/v1/talents/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM talents WHERE id = $1', [req.params.id]);
    res.json(result.rows[0] || {});
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch talent' });
  }
});

app.post('/api/v1/talents', async (req, res) => {
  try {
    const { name, email, phone, role, bio, agency_id } = req.body;
    const result = await pool.query(
      'INSERT INTO talents (name, email, phone, role, bio, agency_id) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [name, email, phone, role, bio, agency_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to create talent' });
  }
});

app.put('/api/v1/talents/:id', async (req, res) => {
  try {
    const { name, email, phone, role, bio, agency_id, is_active } = req.body;
    const result = await pool.query(
      'UPDATE talents SET name=$1, email=$2, phone=$3, role=$4, bio=$5, agency_id=$6, is_active=$7, updated_at=NOW() WHERE id=$8 RETURNING *',
      [name, email, phone, role, bio, agency_id, is_active, req.params.id]
    );
    res.json(result.rows[0] || {});
  } catch (error) {
    res.status(500).json({ error: 'Failed to update talent' });
  }
});

app.delete('/api/v1/talents/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM talents WHERE id = $1', [req.params.id]);
    res.json({ message: 'Talent deleted' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete talent' });
  }
});

// ===== MANAGER ENDPOINTS =====
app.get('/api/v1/managers', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM managers ORDER BY created_at DESC LIMIT 100');
    res.json({ data: result.rows, count: result.rows.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch managers' });
  }
});

app.post('/api/v1/managers', async (req, res) => {
  try {
    const { name, email, phone, company } = req.body;
    const result = await pool.query(
      'INSERT INTO managers (name, email, phone, company) VALUES ($1, $2, $3, $4) RETURNING *',
      [name, email, phone, company]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create manager' });
  }
});

// ===== AGENCY ENDPOINTS =====
app.get('/api/v1/agencies', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM agencies ORDER BY created_at DESC LIMIT 100');
    res.json({ data: result.rows, count: result.rows.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch agencies' });
  }
});

app.post('/api/v1/agencies', async (req, res) => {
  try {
    const { name, email, phone, location, website } = req.body;
    const result = await pool.query(
      'INSERT INTO agencies (name, email, phone, location, website) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [name, email, phone, location, website]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create agency' });
  }
});

// ===== PRODUCER ENDPOINTS =====
app.get('/api/v1/producers', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM producers ORDER BY created_at DESC LIMIT 100');
    res.json({ data: result.rows, count: result.rows.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch producers' });
  }
});

app.post('/api/v1/producers', async (req, res) => {
  try {
    const { name, email, phone, specialization } = req.body;
    const result = await pool.query(
      'INSERT INTO producers (name, email, phone, specialization) VALUES ($1, $2, $3, $4) RETURNING *',
      [name, email, phone, specialization]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create producer' });
  }
});

// ===== CONTENT ENDPOINTS =====
app.get('/api/v1/content', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM content ORDER BY created_at DESC LIMIT 100');
    const data = withNormalizedNames('content', result.rows);
    res.json({ data, count: data.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch content' });
  }
});

app.post('/api/v1/content', async (req, res) => {
  try {
    const { title, description, type, talent_id, producer_id, status, url } = req.body;
    const result = await pool.query(
      'INSERT INTO content (title, description, type, talent_id, producer_id, status, url) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [title, description, type, talent_id, producer_id, status, url]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create content' });
  }
});

// ===== CALENDAR ENDPOINTS =====
app.get('/api/v1/calendar', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM calendar_events ORDER BY start_date DESC');
    const data = withNormalizedNames('calendar_events', result.rows);
    res.json({ data, count: data.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch calendar events' });
  }
});

app.post('/api/v1/calendar', async (req, res) => {
  try {
    const { title, description, start_date, end_date, talent_id, event_type } = req.body;
    const result = await pool.query(
      'INSERT INTO calendar_events (title, description, start_date, end_date, talent_id, event_type) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [title, description, start_date, end_date, talent_id, event_type]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create calendar event' });
  }
});

// ===== MASTERS (CONTRACTS) ENDPOINTS =====
app.get('/api/v1/masters', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM masters ORDER BY created_at DESC LIMIT 100');
    res.json({ data: result.rows, count: result.rows.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch masters' });
  }
});

app.post('/api/v1/masters', async (req, res) => {
  try {
    const { name, document_type, talent_id, agency_id, content, signed_date } = req.body;
    const result = await pool.query(
      'INSERT INTO masters (name, document_type, talent_id, agency_id, content, signed_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [name, document_type, talent_id, agency_id, content, signed_date]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create master' });
  }
});

// ===== WORKFORCE ENDPOINTS =====
app.get('/api/v1/workforce', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM workforce ORDER BY created_at DESC LIMIT 100');
    const data = withNormalizedNames('workforce', result.rows);
    res.json({ data, count: data.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch workforce' });
  }
});

app.post('/api/v1/workforce', async (req, res) => {
  try {
    const { talent_id, project_name, role, start_date, end_date, status } = req.body;
    const result = await pool.query(
      'INSERT INTO workforce (talent_id, project_name, role, start_date, end_date, status) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [talent_id, project_name, role, start_date, end_date, status]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create workforce entry' });
  }
});

// ===== RACI MATRIX ENDPOINTS =====
app.get('/api/v1/raci', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM raci_matrix ORDER BY created_at DESC LIMIT 100');
    const data = withNormalizedNames('raci_matrix', result.rows);
    res.json({ data, count: data.length });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch RACI matrix' });
  }
});

app.post('/api/v1/raci', async (req, res) => {
  try {
    const { task_name, responsible_id, accountable_id, consulted_id, informed_id } = req.body;
    const result = await pool.query(
      'INSERT INTO raci_matrix (task_name, responsible_id, accountable_id, consulted_id, informed_id) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [task_name, responsible_id, accountable_id, consulted_id, informed_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create RACI entry' });
  }
});

// ===== API INFO =====
app.get('/api/v1/info', (req, res) => {
  res.json({
    app: 'ACoolECOSYSTEM',
    service: 'ACoolECOSYSTEM API',
    version: VERSION,
    operator: process.env.OPERATOR || 'ACoolNERD',
    meapPhase: process.env.MEAP_PHASE || 2,
    mode: 'production',
    governance: GOVERNANCE,
    status: 'ok',
    brands: BRANDS,
    components: [
      'Talents',
      'Managers',
      'Agencies',
      'Producers',
      'Content',
      'Calendar',
      'Masters',
      'Workforce',
      'RACI Matrix',
      'Skills',
      'LA28 Vendor Tracking'
    ],
    message: 'Made with LOVE by ACoolNERD with ACoolAI',
    timestamp: new Date().toISOString()
  });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error' });
});

// Startup
async function start() {
  try {
    await redis.connect();
    console.log(`✓ ACool Ecosystem API running on port ${PORT}`);
    console.log(`✓ PostgreSQL connected`);
    console.log(`✓ Redis connected`);
    console.log(`✓ 10 Talent Management Components loaded`);
  } catch (error) {
    console.error('Startup error:', error);
    process.exit(1);
  }
}

app.listen(PORT, start);
