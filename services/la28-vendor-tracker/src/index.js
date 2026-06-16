import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3800;
const GOVERNANCE = 'Rights → Disclosure → Proof';
const ENTITY = 'ACoolCITYHALLCONNECT'; // civic/government lane — see Entity Firewall Protocol

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

// ===== LA28 Vendor Portal tracking data =====
// Built to the ACoolSCHEMA 7-field law from the start — this is a new
// service, so there's no retrofit needed the way there was for the talent
// tables (see docs/governance/ACoolSCHEMA_REGISTRY.md). Domain-specific
// vendor details live under `metadata`.
// KNOWN GAP, stated plainly: this is in-memory only. Restarting the
// container loses any status updates made via PUT. Moving this to Postgres
// (a `civic_vendor_portals` table, same migration pattern as 000-003) is
// the obvious next step before this is relied on for real tracking — not
// done in this pass because no one asked for persistence yet and adding a
// table nobody's confirmed they want would be the same mistake as guessing
// at the Meta Wearable API scope.
const vendorPortals = {
  bbh_lemonade: {
    id: 'bbh_lemonade',
    entity: ENTITY,
    type: 'vendor-portal',
    name: 'BBH Lemonade - LA28 Olympics',
    status: 'not_registered',
    owner: 'ACoolNERD',
    updatedAt: new Date().toISOString(),
    metadata: {
      url: 'https://supplier.lacity.gov/bbhlemonade',
      certifications_needed: ['Business License', 'Food Handler Certification', 'Insurance'],
      costs: { business_license: 475, food_handler: 150, insurance: 750 },
      total_cost: 1375,
      timeline_days: 28,
      deadline: '2025-08-15',
      description: 'Concession vendor pathway for LA28 Olympics. BBH (Bonnie Harris Beverages) lemonade product line.',
      portals: ['LA City Procurement', 'LA County Supplier Database', 'Olympics Supplier Network']
    }
  },
  talent_management: {
    id: 'talent_management',
    entity: ENTITY,
    type: 'vendor-portal',
    name: 'Talent/Entertainment Vendor Portal',
    status: 'not_registered',
    owner: 'ACoolNERD',
    updatedAt: new Date().toISOString(),
    metadata: {
      url: 'https://la28.org/vendors',
      certifications_needed: ['Entertainment License', 'Background Check', 'Contract Review'],
      costs: { entertainment_license: 250, background_check: 100 },
      total_cost: 350,
      timeline_days: 14,
      deadline: '2025-07-31'
    }
  },
  la_county: {
    id: 'la_county',
    entity: ENTITY,
    type: 'vendor-portal',
    name: 'LA County Supplier Portal',
    status: 'not_registered',
    owner: 'ACoolNERD',
    updatedAt: new Date().toISOString(),
    metadata: {
      url: 'https://lacountysuppliers.gov',
      certifications_needed: ['W-9 Form', 'Insurance Certificate'],
      costs: { registration: 0 },
      total_cost: 0,
      timeline_days: 7,
      deadline: '2025-07-01'
    }
  }
};

app.get('/health', (req, res) => {
  res.status(200).json(healthPayload('LA28 Vendor Tracker'));
});

app.get('/api/v1/la28/vendors', (req, res) => {
  const data = Object.values(vendorPortals);
  res.json({
    data,
    count: data.length,
    total_cost: data.reduce((sum, v) => sum + (v.metadata.total_cost || 0), 0),
    deadline_soon: '2025-07-01'
  });
});

app.get('/api/v1/la28/vendors/:id', (req, res) => {
  const vendor = vendorPortals[req.params.id];
  if (!vendor) return res.status(404).json({ error: 'Vendor not found' });
  res.json(vendor);
});

app.put('/api/v1/la28/vendors/:id', (req, res) => {
  const { status } = req.body;
  const vendor = vendorPortals[req.params.id];
  if (!vendor) return res.status(404).json({ error: 'Vendor not found' });
  if (!status) return res.status(400).json({ error: 'status is required' });
  vendor.status = status;
  vendor.updatedAt = new Date().toISOString();
  res.json({ message: 'Updated', data: vendor });
});

app.get('/api/v1/la28/checklist', (req, res) => {
  res.json({
    data: [
      { task: 'Register for BBH Lemonade vendor portal', status: 'pending', url: 'https://supplier.lacity.gov/bbhlemonade' },
      { task: 'Obtain Business License', status: 'pending', cost: 475, deadline: '2025-07-01' },
      { task: 'Food Handler Certification', status: 'pending', cost: 150, deadline: '2025-07-05' },
      { task: 'Secure Insurance ($750)', status: 'pending', cost: 750, deadline: '2025-07-10' },
      { task: 'Submit to LA County Supplier Portal', status: 'pending', url: 'https://lacountysuppliers.gov', deadline: '2025-07-01' },
      { task: 'Background check (Entertainment)', status: 'pending', cost: 100, deadline: '2025-07-15' },
      { task: 'Sign vendor agreement', status: 'pending', deadline: '2025-08-01' }
    ],
    total_cost: 1375,
    timeline: '28 days',
    critical_date: '2025-08-15'
  });
});

app.listen(PORT, () => console.log(`✓ LA28 Vendor Tracker running on port ${PORT}`));
