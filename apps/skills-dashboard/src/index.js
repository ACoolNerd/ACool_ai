import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3500;
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
  res.status(200).json(healthPayload('ACoolECOSYSTEM Skills Dashboard'));
});

app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html><html><head><title>Skills Dashboard</title>
    <meta property="og:title" content="ACoolECOSYSTEM Skills Dashboard" />
    <meta property="og:description" content="Skills Dashboard — part of the ACoolECOSYSTEM" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://dashboard.acool.ai" />
    <meta property="og:site_name" content="ACoolECOSYSTEM" />
    <script type="application/ld+json">${JSON.stringify({
      '@context': 'https://schema.org',
      '@type': 'Organization',
      name: 'ACoolECOSYSTEM Skills Dashboard',
      url: 'https://dashboard.acool.ai',
      description: 'Skills Dashboard — part of the ACoolECOSYSTEM',
      slogan: GOVERNANCE,
      parentOrganization: { '@type': 'Organization', name: 'ACoolECOSYSTEM' }
    })}</script>
  </head><body><h1>Skills Dashboard</h1></body></html>`);
});

app.listen(PORT, () => console.log(`✓ Skills Dashboard running on port ${PORT}`));
