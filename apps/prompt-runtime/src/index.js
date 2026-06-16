import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3400;
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
  res.status(200).json(healthPayload('Prompt Runtime'));
});

app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html><html><head><title>Prompt Runtime</title></head><body><h1>Prompt Runtime</h1></body></html>`);
});

app.listen(PORT, () => console.log(`✓ Prompt Runtime running on port ${PORT}`));
