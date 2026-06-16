import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3200;
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

app.get('/health', (req, res) => {
  res.status(200).json(healthPayload('ACoolACADEMY'));
});

app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html><html><head><title>ACoolACADEMY</title></head><body><h1>ACoolACADEMY</h1></body></html>`);
});

app.listen(PORT, () => console.log(`✓ ACoolACADEMY running on port ${PORT}`));
