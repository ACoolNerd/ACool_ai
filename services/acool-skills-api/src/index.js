import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3700;
const GOVERNANCE = 'Rights → Disclosure → Proof';

function healthPayload(service) {
  return {
    ok: true,
    service,
    mode: 'production',
    governance: GOVERNANCE,
    timestamp: new Date().toISOString()
  };
}

app.use(cors());
app.use(morgan('json'));
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.status(200).json(healthPayload('ACool Skills API'));
});

// Skills endpoints
app.get('/skills', (req, res) => {
  res.json({
    skills: [
      { id: 1, name: 'Singing', category: 'performance' },
      { id: 2, name: 'Dancing', category: 'performance' },
      { id: 3, name: 'Acting', category: 'performance' },
      { id: 4, name: 'Production', category: 'technical' },
      { id: 5, name: 'Sound Engineering', category: 'technical' },
    ]
  });
});

app.get('/skills/:id', (req, res) => {
  res.json({ id: req.params.id, name: 'Skill', category: 'performance' });
});

app.listen(PORT, () => {
  console.log(`✓ ACool Skills API running on port ${PORT}`);
});
