# ACool_ai

**ACool_ai** is the React + Vite frontend app for the ACoolAI operating system.

This repo should become the visual dashboard for ACoolAI, MEAP governance, ACoolSCHEM objects, ACoolOSINT briefs, and ACoolKnowledgeBase summaries.

---

## Relationship to ACoolAI

| Repo | Role |
|---|---|
| `ACoolNerd/ACoolAI` | AI OS command center: docs, prompts, schemas, governance architecture |
| `ACoolNerd/ACool_ai` | Frontend app: dashboard, UI, routes, visual operating layer |

Use `ACoolAI` for the brain. Use `ACool_ai` for the interface.

---

## Current Stack

- React
- Vite
- React Router
- ESLint

Package scripts:

```bash
npm install
npm run dev
npm run build
npm run preview
npm run lint
```

---

## Product Direction

The dashboard should expose the operating system in clear modules:

```text
ACool_ai
├── Dashboard Home
├── MEAP Governance
│   ├── Decisions
│   ├── Risks
│   ├── Tickets
│   └── Audit Events
├── ACoolSCHEM
│   ├── Entities
│   ├── Agents
│   ├── Schemas
│   └── Validation
├── ACoolOSINT
│   ├── Research Briefs
│   ├── Source Logs
│   ├── Opportunities
│   └── Confidence Scores
├── ACoolKnowledgeBase
│   ├── Public KB
│   ├── Internal KB Index
│   ├── Prompt Packs
│   └── Changelog
└── Deployment
    ├── Google AI Studio
    ├── ChatGPT
    ├── Claude Projects
    └── Notion
```

---

## Suggested Frontend Folder Structure

```text
src/
├── app/
│   ├── routes.jsx
│   └── layout.jsx
├── components/
│   ├── cards/
│   ├── layout/
│   ├── navigation/
│   └── tables/
├── data/
│   ├── entities.js
│   ├── clusters.js
│   ├── agents.js
│   └── mockAuditEvents.js
├── pages/
│   ├── Dashboard.jsx
│   ├── Governance.jsx
│   ├── Schemas.jsx
│   ├── OSINT.jsx
│   ├── KnowledgeBase.jsx
│   └── Deployment.jsx
├── styles/
└── utils/
```

---

## First Build Priorities

### Phase 1 — Dashboard Shell

- [ ] Replace starter Vite page
- [ ] Add ACoolAI navigation
- [ ] Add dashboard landing page
- [ ] Add Flame `#E8520F` brand accent
- [ ] Add module cards for MEAP, SCHEM, OSINT, KB, Deployment

### Phase 2 — Governance UI

- [ ] Decisions table
- [ ] Risks table
- [ ] Tickets table
- [ ] Audit Events table
- [ ] BLOCK / ADVISE / LOG badges

### Phase 3 — Knowledge UI

- [ ] Public KB index
- [ ] Prompt pack index
- [ ] Deployment checklist
- [ ] Changelog view

### Phase 4 — Future Integrations

- [ ] Notion database sync
- [ ] GitHub issue sync
- [ ] Schema validation view
- [ ] OSINT source log viewer
- [ ] AI Studio / GPT / Claude export helpers

---

## Data Safety Rules

Do not put these in the frontend repo:

- API keys
- `.env` secrets
- private investor terms
- cap table details
- legal/trust documents
- private health data
- customer data
- private system prompts
- non-public partner records

Only public-safe summaries or mock data should be committed to this public repo.

---

## Recommended Environment Variables

Use `.env.local` for local-only secrets. Do not commit it.

```bash
VITE_APP_NAME=ACoolAI
VITE_PUBLIC_BRAND_COLOR=#E8520F
```

---

## Deployment

Recommended deployment path:

1. Build locally.
2. Push to GitHub.
3. Connect `ACoolNerd/ACool_ai` to Vercel.
4. Set environment variables in Vercel.
5. Deploy preview.
6. Promote to production once dashboard pages render correctly.

---

## Operator Prompt for ACoolAI

Use this prompt when building this app with an AI coding assistant:

```text
You are building ACool_ai, the React/Vite dashboard for ACoolAI. Use ACoolAI as the system repo, ACoolSCHEM as the schema model, ACoolOSINT as the research module, and ACoolKnowledgeBase as the source-of-truth module. Build clean pages, components, data, utils, and docs. Do not include private investor, legal, health, customer, or credential data. Use public-safe mock data only.
```
