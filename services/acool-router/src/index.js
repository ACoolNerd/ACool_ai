import express from 'express';
import httpProxy from 'http-proxy';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3600;
const GOVERNANCE = 'Rights → Disclosure → Proof';
const proxy = httpProxy.createProxyServer({ changeOrigin: true });

function healthPayload(service) {
  return {
    ok: true,
    service,
    mode: 'production',
    governance: GOVERNANCE,
    timestamp: new Date().toISOString()
  };
}

function proxyTo(target) {
  return (req, res) => {
    req.url = req.originalUrl;
    proxy.web(req, res, { target }, (error) => {
      console.error('Router proxy error:', error.message);
      res.status(502).json({
        ok: false,
        service: 'ACool Router',
        error: 'Upstream service unavailable',
        governance: GOVERNANCE,
        timestamp: new Date().toISOString()
      });
    });
  };
}

app.use(cors());
app.use(morgan('json'));
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.status(200).json(healthPayload('ACool Router'));
});

// Route to main API
app.use('/api', proxyTo(process.env.API_URL || 'http://acool-ecosystem-api:8080'));

// Skills API routing
app.use('/skills', proxyTo(process.env.SKILLS_API_URL || 'http://acool-skills-api:3700'));

app.listen(PORT, () => {
  console.log(`✓ ACool Router running on port ${PORT}`);
});
