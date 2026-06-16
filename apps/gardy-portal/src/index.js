import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3300;
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
  res.status(200).json(healthPayload('Gardy Portal'));
});

app.get('/', (req, res) => {
  res.send(`<!DOCTYPE html><html><head><title>Gardy Portal</title>
    <meta property="og:title" content="Gardy Portal" />
    <meta property="og:description" content="Gardy Portal — part of the ACoolECOSYSTEM" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://gardy.acool.ai" />
    <meta property="og:site_name" content="ACoolECOSYSTEM" />
    <script type="application/ld+json">${JSON.stringify({
      '@context': 'https://schema.org',
      '@type': 'Organization',
      name: 'Gardy Portal',
      url: 'https://gardy.acool.ai',
      description: 'Gardy Portal — part of the ACoolECOSYSTEM',
      slogan: GOVERNANCE,
      parentOrganization: { '@type': 'Organization', name: 'ACoolECOSYSTEM' }
    })}</script>
  </head><body><h1>Gardy Portal</h1></body></html>`);
});

app.listen(PORT, () => console.log(`✓ Gardy Portal running on port ${PORT}`));
