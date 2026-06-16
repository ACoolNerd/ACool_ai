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
      <head>
        <title>ACoolPROJECT</title>
        <meta property="og:title" content="ACoolPROJECT" />
        <meta property="og:description" content="Project Management App — part of the ACoolECOSYSTEM" />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://acool.ai" />
        <meta property="og:site_name" content="ACoolECOSYSTEM" />
        <script type="application/ld+json">
        ${JSON.stringify({
          '@context': 'https://schema.org',
          '@type': 'Organization',
          name: 'ACoolPROJECT',
          url: 'https://acool.ai',
          description: 'Project Management App — part of the ACoolECOSYSTEM',
          slogan: GOVERNANCE,
          parentOrganization: { '@type': 'Organization', name: 'ACoolECOSYSTEM' }
        })}
        </script>
      </head>
      <body>
        <h1>ACoolPROJECT</h1>
        <p>Project Management App</p>
      </body>
    </html>
  `);
});

app.listen(PORT, () => console.log(`✓ ACoolPROJECT running on port ${PORT}`));
