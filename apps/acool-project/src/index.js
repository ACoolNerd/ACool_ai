import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3100;
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
  res.status(200).json(healthPayload('ACoolPROJECT'));
});

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
      <head><title>ACoolPROJECT</title></head>
      <body>
        <h1>ACoolPROJECT</h1>
        <p>Project Management App</p>
      </body>
    </html>
  `);
});

app.listen(PORT, () => console.log(`✓ ACoolPROJECT running on port ${PORT}`));
