import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = 3800;

app.use(cors());
app.use(express.json());

// LA28 Vendor Portal tracking data
const vendorPortals = {
  bbh_lemonade: {
    name: 'BBH Lemonade - LA28 Olympics',
    url: 'https://supplier.lacity.gov/bbhlemonade',
    status: 'not_registered',
    certifications_needed: ['Business License', 'Food Handler Certification', 'Insurance'],
    costs: {
      business_license: 475,
      food_handler: 150,
      insurance: 750,
    },
    total_cost: 1375,
    timeline_days: 28,
    deadline: '2025-08-15',
    description: 'Concession vendor pathway for LA28 Olympics. BBH (Bonnie Harris Beverages) lemonade product line.',
    portals: [
      'LA City Procurement',
      'LA County Supplier Database',
      'Olympics Supplier Network'
    ]
  },
  talent_management: {
    name: 'Talent/Entertainment Vendor Portal',
    url: 'https://la28.org/vendors',
    status: 'not_registered',
    certifications_needed: ['Entertainment License', 'Background Check', 'Contract Review'],
    costs: {
      entertainment_license: 250,
      background_check: 100,
    },
    total_cost: 350,
    timeline_days: 14,
    deadline: '2025-07-31',
  },
  la_county: {
    name: 'LA County Supplier Portal',
    url: 'https://lacountysuppliers.gov',
    status: 'not_registered',
    certifications_needed: ['W-9 Form', 'Insurance Certificate'],
    costs: {
      registration: 0,
    },
    total_cost: 0,
    timeline_days: 7,
    deadline: '2025-07-01',
  }
};

// Endpoints
app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.get('/la28/vendors', (req, res) => {
  res.json({
    portals: Object.entries(vendorPortals).map(([key, value]) => ({
      id: key,
      ...value
    })),
    total_cost: Object.values(vendorPortals).reduce((sum, v) => sum + (v.total_cost || 0), 0),
    deadline_soon: '2025-07-01'
  });
});

app.get('/la28/vendors/:id', (req, res) => {
  const vendor = vendorPortals[req.params.id];
  res.json(vendor || { error: 'Vendor not found' });
});

app.put('/la28/vendors/:id', (req, res) => {
  const { status } = req.body;
  if (vendorPortals[req.params.id]) {
    vendorPortals[req.params.id].status = status;
    res.json({ message: 'Updated', data: vendorPortals[req.params.id] });
  } else {
    res.status(404).json({ error: 'Vendor not found' });
  }
});

app.get('/la28/checklist', (req, res) => {
  res.json({
    checklist: [
      { task: 'Register for BBH Lemonade vendor portal', status: 'pending', url: 'https://supplier.lacity.gov/bbhlemonade' },
      { task: 'Obtain Business License', status: 'pending', cost: 475, deadline: '2025-07-01' },
      { task: 'Food Handler Certification', status: 'pending', cost: 150, deadline: '2025-07-05' },
      { task: 'Secure Insurance ($750)', status: 'pending', cost: 750, deadline: '2025-07-10' },
      { task: 'Submit to LA County Supplier Portal', status: 'pending', url: 'https://lacountysuppliers.gov', deadline: '2025-07-01' },
      { task: 'Background check (Entertainment)', status: 'pending', cost: 100, deadline: '2025-07-15' },
      { task: 'Sign vendor agreement', status: 'pending', deadline: '2025-08-01' },
    ],
    total_cost: 1375,
    timeline: '28 days',
    critical_date: '2025-08-15'
  });
});

app.listen(PORT, () => console.log(`✓ LA28 Vendor Tracking on port ${PORT}`));
