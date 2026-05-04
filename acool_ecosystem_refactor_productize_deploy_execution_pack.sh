#!/usr/bin/env bash

# ACoolECOSYSTEM Unified AI OS
# Refactor + Productize + Deploy Execution Pack
# Origin: Antigravity/Gemini scaffold
# Product Owner: ACoolECOSYSTEM

set -e

APP_ROOT="/Users/acoolnerd/.gemini/antigravity/scratch/acoolcollector"
cd "$APP_ROOT"

echo "Creating clean ACoolECOSYSTEM AI OS structure..."

# ─────────────────────────────────────────────
# 1. CREATE DIRECTORIES
# ─────────────────────────────────────────────

mkdir -p docs
mkdir -p src/pages
mkdir -p src/components/layout
mkdir -p src/components/gpt
mkdir -p src/components/documents
mkdir -p src/components/shared
mkdir -p src/data
mkdir -p src/utils
mkdir -p src/styles
mkdir -p src/config
mkdir -p exports

# ─────────────────────────────────────────────
# 2. DOCS
# ─────────────────────────────────────────────

cat > docs/00_ORIGIN.md <<'EOF'
# ACoolECOSYSTEM Unified AI OS — Origin

## Source Attribution

This project originated from an Antigravity/Gemini scaffold for the ACoolECOSYSTEM Unified AI OS.

## Contribution Layers

- Architecture + original scaffold: Antigravity / Gemini
- Product refinement + refactor structure: ACoolECOSYSTEM strategy layer
- UI/product system: ACoolECOSYSTEM Unified AI OS
- Ownership: ACoolECOSYSTEM

## Product Purpose

The ACoolECOSYSTEM Unified AI OS organizes the ecosystem into a usable operating system made of documents, GPTs, workflows, playbooks, command centers, and deployment paths.

## Version History

- v0.1 — Antigravity/Gemini scaffold
- v0.5 — Unified command center prototype
- v1.0 — Productized AI OS refactor
EOF

cat > docs/01_START_HERE_NAVIGATION_GUIDE.md <<'EOF'
# START HERE — ACoolECOSYSTEM Navigation Guide

Use this guide to understand where everything belongs.

## Core Documents

1. GPT Master Guide — all 22 GPTs
2. Unified AI OS Blueprint — architecture and tool flow
3. 30-Day Playbook — execution plan
4. GPT Command Center — interactive operating interface

## Recommended Reading Order

Leadership:
- Start Here
- Blueprint Executive Summary
- 30-Day Playbook Overview

Implementation Lead:
- Start Here
- Blueprint
- Playbook
- GPT Master Guide

AI Team:
- GPT Master Guide
- GPT Command Center
- Deployment Guide
EOF

cat > docs/02_GPT_MASTER_GUIDE.md <<'EOF'
# GPT Master Guide

This document contains the 22 ACoolECOSYSTEM GPTs across 7 clusters.

## Clusters

1. Trust & Holdings
2. Education
3. Collectibles
4. Consulting
5. Health
6. Content / Media
7. Tech / Infrastructure

## Deployment Priority

Phase 1: Core Operating GPTs
Phase 2: Revenue + Product GPTs
Phase 3: Education + Community GPTs
Phase 4: Specialized + Expansion GPTs
EOF

cat > docs/03_UNIFIED_AI_OS_BLUEPRINT.md <<'EOF'
# Unified AI OS Blueprint

The ACoolECOSYSTEM Unified AI OS connects GPTs, documents, workflows, communication, knowledge, storage, and execution into one operating system.

## Core Layers

1. Identity Layer
2. Knowledge Layer
3. Agent Layer
4. Workflow Layer
5. Communication Layer
6. Storage Layer
7. Governance Layer
8. Metrics Layer
9. Deployment Layer
10. Growth Layer
EOF

cat > docs/04_30_DAY_PLAYBOOK.md <<'EOF'
# 30-Day Playbook

## Phase 1 — Foundation
Days 1-5: documents, folders, source of truth, governance.

## Phase 2 — System Setup
Days 6-12: Notion, Drive, Slack, workflows, operating rhythm.

## Phase 3 — GPT Deployment
Days 13-20: deploy first GPTs, test prompts, train users.

## Phase 4 — Productization
Days 21-30: polish, verify, launch, report, demo.
EOF

cat > docs/05_DEPLOYMENT_GUIDE.md <<'EOF'
# Deployment Guide

## Local Dev

```bash
npm install
npm run dev
```

Open:

```text
http://localhost:5173
```

## Production Deployment — Vercel

1. Push repo to GitHub.
2. Import repo into Vercel.
3. Framework: Vite.
4. Build command: `npm run build`.
5. Output directory: `dist`.

Recommended domain:

```text
aios.acoolecosystem.com
```
EOF

cat > docs/06_PRODUCT_REQUIREMENTS_DOCUMENT.md <<'EOF'
# Product Requirements Document

## Product Name
ACoolECOSYSTEM Unified AI OS

## Product Type
AI operating system / command center / internal ecosystem platform.

## MVP Features

- GPT Command Center
- Document Navigator
- Search and filter
- Copy GPT prompts
- Deployment guides
- Progress checklist
- Clean documentation system

## V1 Features

- Blueprint Viewer
- Playbook Tracker
- Export prompts
- Version history
- Admin-ready structure

## V2 Features

- Authentication
- Database-backed GPT library
- Team roles
- Editable GPTs
- Analytics
EOF

cat > docs/07_INVESTOR_DEMO_DAY_BRIEF.md <<'EOF'
# Investor Demo Day Brief

## One-Liner
ACoolECOSYSTEM Unified AI OS turns a fragmented multi-brand ecosystem into a coordinated AI-powered operating system.

## Problem
Growing ecosystems lose momentum because knowledge, workflows, people, documents, and AI tools are scattered.

## Solution
A command center that organizes documents, GPT agents, playbooks, and deployment workflows into one interface.

## Moat
- Proprietary 22-GPT ecosystem structure
- Multi-cluster operating model
- AI agent + playbook + document architecture
- Internal-first product with SaaS expansion path

## Launch Path
Internal MVP → Team OS → Partner Demo → SaaS workspace product.
EOF

# ─────────────────────────────────────────────
# 3. DATA LAYER
# ─────────────────────────────────────────────

cat > src/data/clusters.js <<'EOF'
export const CLUSTERS = [
  { id: "trust", name: "Trust & Holdings", color: "#6366f1", prefix: "01", desc: "Governance, asset management, fiduciary responsibility" },
  { id: "education", name: "Education", color: "#10b981", prefix: "02", desc: "Curriculum, training, AI learning, workforce development" },
  { id: "collectibles", name: "Collectibles", color: "#f59e0b", prefix: "03", desc: "Cards, authentication, portfolio, collecting community" },
  { id: "consulting", name: "Consulting", color: "#ef4444", prefix: "04", desc: "Business transformation and process optimization" },
  { id: "health", name: "Health", color: "#ec4899", prefix: "05", desc: "Healthcare innovation, wellness, clinical operations" },
  { id: "content", name: "Content / Media", color: "#8b5cf6", prefix: "06", desc: "Storytelling, brand, audience, digital presence" },
  { id: "tech", name: "Tech / Infrastructure", color: "#06b6d4", prefix: "07", desc: "Platforms, ecommerce, APIs, knowledge operations" },
];

export const getCluster = (id) => CLUSTERS.find((cluster) => cluster.id === id);
EOF

cat > src/data/gpts.js <<'EOF'
export const GPTS = [
  { id: 1, name: "ACoolECOSYSTEM Master", title: "Ecosystem Coordinator & Strategic Integrator", cluster: "consulting", phase: 1, status: "Production Ready", welcome: "I see the full ACoolECOSYSTEM. What do we need to coordinate?", prompt: "You are the Chief Ecosystem Coordinator for the full ACoolECOSYSTEM. Coordinate all entities, GPTs, documents, workflows, and execution plans into one unified operating system.", capabilities: ["Ecosystem coordination", "Strategic alignment", "Cross-cluster integration"] },
  { id: 2, name: "ACoolTRUST", title: "Trust Advisor & Governance Architect", cluster: "trust", phase: 1, status: "Production Ready", welcome: "I’ll help structure and manage trust governance.", prompt: "You are the Trust Advisor for a family trust holding company ecosystem. Help design governance, fiduciary responsibility, protection, and succession structures.", capabilities: ["Trust governance", "Asset protection", "Succession planning"] },
  { id: 3, name: "ACoolHOLDINGS", title: "Entity Operations & Strategic Asset Allocator", cluster: "trust", phase: 1, status: "Production Ready", welcome: "Let’s manage the holding company operating layer.", prompt: "You are the COO for ACoolHOLDINGS. Manage entity operations, subsidiaries, asset allocation, and cross-entity coordination.", capabilities: ["Entity operations", "Subsidiary management", "Resource allocation"] },
  { id: 4, name: "ProcessArc", title: "Operations Consultant & Process Architect", cluster: "consulting", phase: 1, status: "Production Ready", welcome: "Let’s map and optimize the process.", prompt: "You are the Managing Consultant at ProcessArc. Analyze workflows, identify inefficiencies, design better processes, and guide implementation.", capabilities: ["Process mapping", "Workflow redesign", "Operational improvement"] },
  { id: 5, name: "Notion/Discord Ops", title: "Knowledge Operations & Community Tech Lead", cluster: "tech", phase: 1, status: "Production Ready", welcome: "Let’s organize the knowledge and community systems.", prompt: "You are the Operations Director for Notion/Discord Ops. Manage knowledge systems, community platforms, collaboration, and communication infrastructure.", capabilities: ["Knowledge base", "Community operations", "Documentation systems"] },

  { id: 6, name: "ACoolCOLLECTOR.com", title: "Ecommerce Operations & Marketplace Manager", cluster: "tech", phase: 2, status: "Production Ready", welcome: "Let’s grow marketplace operations.", prompt: "You are the Ecommerce Director for ACoolCOLLECTOR.com. Manage marketplace operations, listings, payments, fulfillment, and customer experience.", capabilities: ["Marketplace operations", "Product listings", "Customer experience"] },
  { id: 7, name: "ACoolCARD", title: "Card Market Analyst & Portfolio Strategist", cluster: "collectibles", phase: 2, status: "Production Ready", welcome: "What card market or portfolio move are we analyzing?", prompt: "You are the Chief Market Analyst for ACoolCARD. Analyze trading card markets, portfolio strategy, values, and investment opportunities.", capabilities: ["Market analysis", "Portfolio strategy", "Price prediction"] },
  { id: 8, name: "ACoolCOLLECTION", title: "Collection Manager & Inventory Specialist", cluster: "collectibles", phase: 2, status: "Production Ready", welcome: "Let’s organize the collection.", prompt: "You are the Collection Manager for ACoolCOLLECTION. Help organize, catalog, protect, insure, and optimize collections.", capabilities: ["Inventory", "Cataloging", "Insurance coordination"] },
  { id: 9, name: "Break Vault™", title: "Pack Break Event Manager & Revenue Operator", cluster: "collectibles", phase: 2, status: "Production Ready", welcome: "Let’s plan or optimize a break.", prompt: "You are the Event Director for Break Vault. Design pack break events, pricing, participant engagement, and revenue operations.", capabilities: ["Event management", "Revenue operations", "Community engagement"] },
  { id: 10, name: "ACoolWEBSITE", title: "Web Strategy & Digital Brand Presence Lead", cluster: "content", phase: 2, status: "Production Ready", welcome: "Let’s build the digital presence.", prompt: "You are the Digital Director for ACoolWEBSITE. Manage web strategy, content, SEO, conversion, and brand presence.", capabilities: ["Web strategy", "SEO", "Conversion"] },
  { id: 11, name: "ACoolAPP", title: "Mobile/Web App Strategist & Product Lead", cluster: "content", phase: 2, status: "Production Ready", welcome: "Let’s plan the app product path.", prompt: "You are the Chief Product Officer for ACoolAPP. Lead mobile and web app strategy, UX, roadmap, and growth.", capabilities: ["Product strategy", "UX", "Roadmapping"] },

  { id: 12, name: "ACoolACADEMY", title: "Educational Platform Designer & Curriculum Architect", cluster: "education", phase: 3, status: "Production Ready", welcome: "What learning system are we building?", prompt: "You are the Chief Education Officer for ACoolACADEMY. Design curriculum, learning platforms, credentials, and education programs.", capabilities: ["Curriculum", "Learning design", "Credentialing"] },
  { id: 13, name: "ACoolPROMPT", title: "AI Learning Specialist & Prompt Engineer", cluster: "education", phase: 3, status: "Production Ready", welcome: "Let’s improve the prompt and AI workflow.", prompt: "You are the AI Learning Specialist for ACoolPROMPT. Teach prompt engineering, AI workflows, and knowledge synthesis.", capabilities: ["Prompt engineering", "AI literacy", "Workflow optimization"] },
  { id: 14, name: "Loe_NYC1", title: "Community Learning & Workforce Development Lead", cluster: "education", phase: 3, status: "Production Ready", welcome: "What community need are we solving?", prompt: "You are the Community Education Director for Loe_NYC1. Build workforce programs, community partnerships, and local learning initiatives.", capabilities: ["Workforce development", "Community partnerships", "Local education"] },
  { id: 15, name: "iAmACoolCOLLECTOR", title: "Collector's Guide & Community Host", cluster: "collectibles", phase: 3, status: "Production Ready", welcome: "Welcome to the collector community.", prompt: "You are the Community Host for iAmACoolCOLLECTOR. Build collector culture, peer learning, engagement, and community events.", capabilities: ["Community", "Peer learning", "Engagement"] },

  { id: 16, name: "ACoolNERD", title: "Collectibles Technologist & Platform Innovator", cluster: "collectibles", phase: 4, status: "Production Ready", welcome: "Let’s innovate the collectibles tech layer.", prompt: "You are the CTO for ACoolNERD. Build authentication, blockchain, digital collectibles, APIs, and platform infrastructure.", capabilities: ["Authentication", "Blockchain", "Platform infrastructure"] },
  { id: 17, name: "MEAP Platform", title: "Platform Architect & System Scalability Lead", cluster: "tech", phase: 4, status: "Production Ready", welcome: "Let’s design the scalable platform.", prompt: "You are the Chief Architect for the MEAP Platform. Design APIs, scalable infrastructure, system architecture, and technical roadmaps.", capabilities: ["Architecture", "APIs", "Scalability"] },
  { id: 18, name: "Élite Vitality", title: "Health Innovation Officer & Wellness Leader", cluster: "health", phase: 4, status: "Production Ready", welcome: "What health innovation are we designing?", prompt: "You are the Chief Health Innovation Officer for Élite Vitality. Design wellness programs, clinical integration, and health innovation projects.", capabilities: ["Wellness", "Clinical integration", "Health innovation"] },
  { id: 19, name: "AGNP Clinical", title: "Clinical Practice Manager & Care Coordinator", cluster: "health", phase: 4, status: "Production Ready", welcome: "Let’s improve clinical operations.", prompt: "You are the Clinical Director for AGNP Clinical. Coordinate care, manage patient workflows, develop protocols, and improve outcomes.", capabilities: ["Care coordination", "Protocols", "Patient workflows"] },
  { id: 20, name: "Practice Ops", title: "Healthcare Administrator & Operations Expert", cluster: "health", phase: 4, status: "Production Ready", welcome: "Let’s optimize practice operations.", prompt: "You are the Operations Director for Practice Ops. Manage billing, compliance, scheduling, staffing, and healthcare operations.", capabilities: ["Billing", "Compliance", "Scheduling"] },
  { id: 21, name: "NASCAR Card Content", title: "Motorsports Storyteller & Fan Engagement Lead", cluster: "content", phase: 4, status: "Production Ready", welcome: "Let’s tell the motorsports card story.", prompt: "You are the Content Director for NASCAR Card Content. Create motorsports storytelling, fan engagement, and NASCAR collectible narratives.", capabilities: ["Storytelling", "Fan engagement", "NASCAR collectibles"] },
  { id: 22, name: "Antigravity Prompt", title: "Creative Strategist & AI Narrative Innovator", cluster: "content", phase: 4, status: "Production Ready", welcome: "Ready to defy creative gravity?", prompt: "You are the Creative Director for Antigravity Prompt. Create AI-powered campaigns, narrative innovation, and creative strategy.", capabilities: ["Creative strategy", "AI storytelling", "Campaigns"] }
];
EOF

cat > src/data/documents.js <<'EOF'
export const DOCUMENTS = [
  { id: "origin", name: "Origin File", pages: "1+", readTime: "5 min", audience: "Everyone", icon: "🧬", desc: "Attribution, source history, versioning, and ownership." },
  { id: "navigator", name: "START HERE Navigation Guide", pages: "10+", readTime: "15 min", audience: "Everyone", icon: "🗺", desc: "How to understand and navigate the ACoolECOSYSTEM AI OS." },
  { id: "master", name: "GPT Master Guide", pages: "60+", readTime: "1-2 hrs", audience: "AI Team", icon: "📖", desc: "All 22 GPT specs, prompts, clusters, welcomes, and deployment notes." },
  { id: "blueprint", name: "Unified AI OS Blueprint", pages: "80+", readTime: "2-3 hrs", audience: "Architects", icon: "🏗", desc: "Architecture, layers, tool sync, governance, and system logic." },
  { id: "playbook", name: "30-Day Playbook", pages: "40+", readTime: "1-2 hrs", audience: "Implementers", icon: "📋", desc: "Day-by-day tactical execution plan." },
  { id: "deploy", name: "Deployment Guide", pages: "5+", readTime: "20 min", audience: "Tech Team", icon: "🚀", desc: "Local, GitHub, Vercel, and production verification steps." },
  { id: "prd", name: "Product Requirements Document", pages: "10+", readTime: "30 min", audience: "Product", icon: "🧾", desc: "MVP, V1, V2, and SaaS product requirements." },
  { id: "investor", name: "Investor Demo Day Brief", pages: "5+", readTime: "15 min", audience: "Leadership", icon: "💎", desc: "Pitch-ready story, problem, solution, moat, and launch path." }
];
EOF

cat > src/data/scenarios.js <<'EOF'
export const SCENARIOS = [
  { id: 1, title: "Launch Internal MVP", timeline: "7 days", outcome: "Working internal AI OS with docs and GPT Command Center." },
  { id: 2, title: "Full 30-Day Implementation", timeline: "30 days", outcome: "Operational AI OS with docs, workflows, GPTs, and team training." },
  { id: 3, title: "GPTs First", timeline: "3-5 days", outcome: "Priority GPTs deployed before full operating system." },
  { id: 4, title: "Investor Demo Mode", timeline: "14 days", outcome: "Pitch-ready product demo for partners, investors, and demo day." }
];
EOF

cat > src/data/readingOrders.js <<'EOF'
export const READING_ORDERS = [
  { role: "Leadership", time: "2 hours", icon: "👔", docs: ["START HERE", "Investor Brief", "Blueprint Summary", "Playbook Overview"] },
  { role: "Implementation Lead", time: "6 hours", icon: "⚙️", docs: ["START HERE", "Blueprint", "Playbook", "Deployment Guide"] },
  { role: "Tech Team", time: "4 hours", icon: "💻", docs: ["Deployment Guide", "Blueprint", "Data Structure", "Routes"] },
  { role: "AI Team", time: "3 hours", icon: "🧠", docs: ["GPT Master Guide", "Command Center", "Deployment Priority"] }
];
EOF

# ─────────────────────────────────────────────
# 4. UTILS
# ─────────────────────────────────────────────

cat > src/utils/search.js <<'EOF'
export function filterGpts(gpts, search = "", activeCluster = null) {
  const query = search.toLowerCase().trim();

  return gpts.filter((gpt) => {
    const clusterMatch = !activeCluster || gpt.cluster === activeCluster;
    const searchMatch = !query || [
      gpt.name,
      gpt.title,
      gpt.cluster,
      gpt.status,
      ...(gpt.capabilities || [])
    ].join(" ").toLowerCase().includes(query);

    return clusterMatch && searchMatch;
  });
}
EOF

cat > src/utils/clipboard.js <<'EOF'
export async function copyToClipboard(text) {
  if (!navigator?.clipboard) {
    throw new Error("Clipboard API unavailable");
  }
  await navigator.clipboard.writeText(text);
}
EOF

cat > src/utils/storage.js <<'EOF'
export function getStoredJSON(key, fallback) {
  try {
    const value = localStorage.getItem(key);
    return value ? JSON.parse(value) : fallback;
  } catch {
    return fallback;
  }
}

export function setStoredJSON(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}
EOF

# ─────────────────────────────────────────────
# 5. SHARED COMPONENTS
# ─────────────────────────────────────────────

cat > src/components/shared/Badge.jsx <<'EOF'
export default function Badge({ children, color = "#f59e0b" }) {
  return (
    <span className="badge" style={{ borderColor: `${color}55`, color, background: `${color}18` }}>
      {children}
    </span>
  );
}
EOF

cat > src/components/shared/StatCard.jsx <<'EOF'
export default function StatCard({ label, value }) {
  return (
    <div className="stat-card">
      <strong>{value}</strong>
      <span>{label}</span>
    </div>
  );
}
EOF

cat > src/components/shared/SectionHeader.jsx <<'EOF'
export default function SectionHeader({ title, subtitle }) {
  return (
    <div className="section-header">
      <h2>{title}</h2>
      {subtitle && <p>{subtitle}</p>}
    </div>
  );
}
EOF

# ─────────────────────────────────────────────
# 6. LAYOUT
# ─────────────────────────────────────────────

cat > src/components/layout/Sidebar.jsx <<'EOF'
import { NavLink } from "react-router-dom";

const sections = [
  {
    title: "AI OS",
    links: [
      { to: "/", label: "Dashboard" },
      { to: "/doc-navigator", label: "Document Navigator" },
      { to: "/gpt-command-center", label: "GPT Command Center" },
      { to: "/blueprint", label: "Blueprint Viewer" },
      { to: "/playbook", label: "30-Day Playbook" }
    ]
  },
  {
    title: "Product",
    links: [
      { to: "/productize", label: "Product Roadmap" },
      { to: "/deploy", label: "Deploy" }
    ]
  }
];

export default function Sidebar() {
  return (
    <aside className="sidebar">
      <div className="brand">
        <div className="brand-mark">A</div>
        <div>
          <strong>ACoolECOSYSTEM</strong>
          <span>Unified AI OS</span>
        </div>
      </div>

      {sections.map((section) => (
        <nav key={section.title}>
          <h4>{section.title}</h4>
          {section.links.map((link) => (
            <NavLink key={link.to} to={link.to} className={({ isActive }) => isActive ? "active" : ""}>
              {link.label}
            </NavLink>
          ))}
        </nav>
      ))}
    </aside>
  );
}
EOF

cat > src/components/layout/PageShell.jsx <<'EOF'
import Sidebar from "./Sidebar";

export default function PageShell({ children }) {
  return (
    <div className="app-shell">
      <Sidebar />
      <main className="main-panel">{children}</main>
    </div>
  );
}
EOF

# ─────────────────────────────────────────────
# 7. GPT COMPONENTS
# ─────────────────────────────────────────────

cat > src/components/gpt/ClusterFilter.jsx <<'EOF'
export default function ClusterFilter({ clusters, activeCluster, onChange }) {
  return (
    <div className="filter-row">
      <button className={!activeCluster ? "selected" : ""} onClick={() => onChange(null)}>All</button>
      {clusters.map((cluster) => (
        <button
          key={cluster.id}
          className={activeCluster === cluster.id ? "selected" : ""}
          onClick={() => onChange(activeCluster === cluster.id ? null : cluster.id)}
          style={{ "--accent": cluster.color }}
        >
          {cluster.name}
        </button>
      ))}
    </div>
  );
}
EOF

cat > src/components/gpt/GPTCard.jsx <<'EOF'
import { useState } from "react";
import Badge from "../shared/Badge";
import { copyToClipboard } from "../../utils/clipboard";

export default function GPTCard({ gpt, cluster }) {
  const [open, setOpen] = useState(false);
  const [deployOpen, setDeployOpen] = useState(false);
  const [copied, setCopied] = useState(false);

  async function handleCopy() {
    await copyToClipboard(gpt.prompt);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  }

  return (
    <article className="gpt-card" style={{ borderLeftColor: cluster?.color || "#f59e0b" }}>
      <button className="gpt-card-header" onClick={() => setOpen(!open)}>
        <div>
          <div className="gpt-title-row">
            <h3>{gpt.name}</h3>
            <Badge color={cluster?.color}>{cluster?.name}</Badge>
            <Badge color="#10b981">Phase {gpt.phase}</Badge>
          </div>
          <p>{gpt.title}</p>
        </div>
        <span>{open ? "▲" : "▼"}</span>
      </button>

      {open && (
        <div className="gpt-detail">
          <h4>System Prompt</h4>
          <pre>{gpt.prompt}</pre>

          <h4>Welcome Message</h4>
          <blockquote>{gpt.welcome}</blockquote>

          <h4>Capabilities</h4>
          <div className="capability-row">
            {gpt.capabilities.map((capability) => <span key={capability}>{capability}</span>)}
          </div>

          <div className="action-row">
            <button onClick={handleCopy}>{copied ? "Copied ✓" : "Copy Prompt"}</button>
            <button className="secondary" onClick={() => setDeployOpen(!deployOpen)}>
              {deployOpen ? "Hide Deploy Guide" : "Deploy to ChatGPT"}
            </button>
          </div>

          {deployOpen && (
            <div className="deploy-box">
              <strong>Deploy {gpt.name}</strong>
              <ol>
                <li>Open ChatGPT → Explore GPTs → Create.</li>
                <li>Paste the system prompt into Instructions.</li>
                <li>Set name to {gpt.name}.</li>
                <li>Add related docs from Notion/Drive.</li>
                <li>Publish to workspace.</li>
              </ol>
            </div>
          )}
        </div>
      )}
    </article>
  );
}
EOF

# ─────────────────────────────────────────────
# 8. DOCUMENT COMPONENTS
# ─────────────────────────────────────────────

cat > src/components/documents/DocumentCard.jsx <<'EOF'
export default function DocumentCard({ doc }) {
  return (
    <article className="document-card">
      <div className="doc-icon">{doc.icon}</div>
      <h3>{doc.name}</h3>
      <p>{doc.desc}</p>
      <div className="meta-row">
        <span>{doc.pages}</span>
        <span>{doc.readTime}</span>
        <span>{doc.audience}</span>
      </div>
    </article>
  );
}
EOF

cat > src/components/documents/ScenarioCard.jsx <<'EOF'
export default function ScenarioCard({ scenario }) {
  return (
    <article className="scenario-card">
      <h3>{scenario.title}</h3>
      <p>{scenario.timeline}</p>
      <strong>{scenario.outcome}</strong>
    </article>
  );
}
EOF

# ─────────────────────────────────────────────
# 9. PAGES
# ─────────────────────────────────────────────

cat > src/pages/Dashboard.jsx <<'EOF'
import SectionHeader from "../components/shared/SectionHeader";
import StatCard from "../components/shared/StatCard";

export default function Dashboard() {
  return (
    <section>
      <SectionHeader
        title="ACoolECOSYSTEM Unified AI OS"
        subtitle="A productized command center for documents, GPTs, workflows, playbooks, and ecosystem execution."
      />
      <div className="stat-grid">
        <StatCard value="22" label="GPT Agents" />
        <StatCard value="7" label="Clusters" />
        <StatCard value="8" label="Core Docs" />
        <StatCard value="4" label="Deployment Phases" />
      </div>
    </section>
  );
}
EOF

cat > src/pages/GPTCommandCenter.jsx <<'EOF'
import { useMemo, useState } from "react";
import { GPTS } from "../data/gpts";
import { CLUSTERS, getCluster } from "../data/clusters";
import { filterGpts } from "../utils/search";
import SectionHeader from "../components/shared/SectionHeader";
import ClusterFilter from "../components/gpt/ClusterFilter";
import GPTCard from "../components/gpt/GPTCard";

export default function GPTCommandCenter() {
  const [search, setSearch] = useState("");
  const [activeCluster, setActiveCluster] = useState(null);

  const filtered = useMemo(() => filterGpts(GPTS, search, activeCluster), [search, activeCluster]);

  return (
    <section>
      <SectionHeader
        title="GPT Command Center"
        subtitle="Browse, search, copy, and deploy all 22 ACoolECOSYSTEM GPTs."
      />

      <input
        className="search-input"
        value={search}
        onChange={(event) => setSearch(event.target.value)}
        placeholder="Search by GPT name, title, cluster, or capability..."
      />

      <ClusterFilter clusters={CLUSTERS} activeCluster={activeCluster} onChange={setActiveCluster} />

      <p className="results-line">Showing {filtered.length} of {GPTS.length} GPTs</p>

      <div className="card-list">
        {filtered.map((gpt) => (
          <GPTCard key={gpt.id} gpt={gpt} cluster={getCluster(gpt.cluster)} />
        ))}
      </div>
    </section>
  );
}
EOF

cat > src/pages/DocumentNavigator.jsx <<'EOF'
import { DOCUMENTS } from "../data/documents";
import { SCENARIOS } from "../data/scenarios";
import { READING_ORDERS } from "../data/readingOrders";
import SectionHeader from "../components/shared/SectionHeader";
import DocumentCard from "../components/documents/DocumentCard";
import ScenarioCard from "../components/documents/ScenarioCard";

export default function DocumentNavigator() {
  return (
    <section>
      <SectionHeader
        title="Document Navigator"
        subtitle="Start here to understand what to read, what to build, and what to deploy."
      />

      <h3>Core Documents</h3>
      <div className="card-grid">
        {DOCUMENTS.map((doc) => <DocumentCard key={doc.id} doc={doc} />)}
      </div>

      <h3>Deployment Scenarios</h3>
      <div className="card-grid">
        {SCENARIOS.map((scenario) => <ScenarioCard key={scenario.id} scenario={scenario} />)}
      </div>

      <h3>Reading Orders</h3>
      <div className="card-grid">
        {READING_ORDERS.map((order) => (
          <article className="document-card" key={order.role}>
            <div className="doc-icon">{order.icon}</div>
            <h3>{order.role}</h3>
            <p>{order.time}</p>
            <ul>{order.docs.map((doc) => <li key={doc}>{doc}</li>)}</ul>
          </article>
        ))}
      </div>
    </section>
  );
}
EOF

cat > src/pages/BlueprintViewer.jsx <<'EOF'
import SectionHeader from "../components/shared/SectionHeader";

const layers = ["Identity", "Knowledge", "Agent", "Workflow", "Communication", "Storage", "Governance", "Metrics", "Deployment", "Growth"];

export default function BlueprintViewer() {
  return (
    <section>
      <SectionHeader title="Blueprint Viewer" subtitle="The 10-layer architecture of the ACoolECOSYSTEM Unified AI OS." />
      <div className="card-grid">
        {layers.map((layer, index) => (
          <article className="document-card" key={layer}>
            <h3>{index + 1}. {layer} Layer</h3>
            <p>System architecture module for {layer.toLowerCase()} operations.</p>
          </article>
        ))}
      </div>
    </section>
  );
}
EOF

cat > src/pages/PlaybookTracker.jsx <<'EOF'
import SectionHeader from "../components/shared/SectionHeader";

const phases = [
  "Days 1-5: Foundation",
  "Days 6-12: System Setup",
  "Days 13-20: GPT Deployment",
  "Days 21-30: Productization"
];

export default function PlaybookTracker() {
  return (
    <section>
      <SectionHeader title="30-Day Playbook" subtitle="Track the implementation from foundation to launch." />
      <div className="card-grid">
        {phases.map((phase) => (
          <article className="document-card" key={phase}>
            <h3>{phase}</h3>
            <p>Execution checklist and owner assignment can be added here in V1.</p>
          </article>
        ))}
      </div>
    </section>
  );
}
EOF

cat > src/pages/Productize.jsx <<'EOF'
import SectionHeader from "../components/shared/SectionHeader";

export default function Productize() {
  return (
    <section>
      <SectionHeader title="Product Roadmap" subtitle="Internal MVP → Team OS → SaaS / Demo Day product." />
      <div className="card-grid">
        <article className="document-card"><h3>MVP</h3><p>Command Center, Navigator, docs, static data, Vercel deployment.</p></article>
        <article className="document-card"><h3>Team OS</h3><p>Authentication, teams, editable prompts, progress tracking.</p></article>
        <article className="document-card"><h3>SaaS</h3><p>Public demo, workspaces, billing, analytics, integrations.</p></article>
      </div>
    </section>
  );
}
EOF

cat > src/pages/Deploy.jsx <<'EOF'
import SectionHeader from "../components/shared/SectionHeader";

export default function Deploy() {
  return (
    <section>
      <SectionHeader title="Deploy" subtitle="GitHub + Vercel deployment path." />
      <div className="document-card">
        <h3>Commands</h3>
        <pre>{`npm install
npm run dev
npm run build
git add .
git commit -m "Productize ACoolECOSYSTEM Unified AI OS"
git push -u origin main`}</pre>
      </div>
    </section>
  );
}
EOF

# ─────────────────────────────────────────────
# 10. APP + STYLES
# ─────────────────────────────────────────────

cat > src/App.jsx <<'EOF'
import { Routes, Route } from "react-router-dom";
import PageShell from "./components/layout/PageShell";
import Dashboard from "./pages/Dashboard";
import GPTCommandCenter from "./pages/GPTCommandCenter";
import DocumentNavigator from "./pages/DocumentNavigator";
import BlueprintViewer from "./pages/BlueprintViewer";
import PlaybookTracker from "./pages/PlaybookTracker";
import Productize from "./pages/Productize";
import Deploy from "./pages/Deploy";
import "./styles/globals.css";

export default function App() {
  return (
    <PageShell>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/gpt-command-center" element={<GPTCommandCenter />} />
        <Route path="/doc-navigator" element={<DocumentNavigator />} />
        <Route path="/blueprint" element={<BlueprintViewer />} />
        <Route path="/playbook" element={<PlaybookTracker />} />
        <Route path="/productize" element={<Productize />} />
        <Route path="/deploy" element={<Deploy />} />
      </Routes>
    </PageShell>
  );
}
EOF

cat > src/styles/globals.css <<'EOF'
:root {
  color-scheme: dark;
  --bg: #08080d;
  --panel: #11111a;
  --panel-2: #171724;
  --text: #f4f4f6;
  --muted: #9ca3af;
  --line: rgba(255,255,255,0.08);
  --accent: #f59e0b;
}

* { box-sizing: border-box; }
body { margin: 0; background: var(--bg); color: var(--text); font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; }
a { color: inherit; text-decoration: none; }
button, input { font: inherit; }

.app-shell { display: grid; grid-template-columns: 280px 1fr; min-height: 100vh; }
.sidebar { background: #0d0d14; border-right: 1px solid var(--line); padding: 24px; position: sticky; top: 0; height: 100vh; }
.brand { display: flex; gap: 12px; align-items: center; margin-bottom: 32px; }
.brand-mark { width: 42px; height: 42px; border-radius: 14px; background: linear-gradient(135deg, #f59e0b, #ef4444); display: grid; place-items: center; font-weight: 900; }
.brand span { display: block; color: var(--muted); font-size: 12px; margin-top: 2px; }
.sidebar nav { margin-bottom: 28px; }
.sidebar h4 { color: #666; text-transform: uppercase; letter-spacing: .08em; font-size: 11px; margin: 0 0 10px; }
.sidebar a { display: block; padding: 10px 12px; color: var(--muted); border-radius: 10px; margin-bottom: 4px; }
.sidebar a.active, .sidebar a:hover { background: rgba(245,158,11,.12); color: var(--accent); }
.main-panel { padding: 36px; max-width: 1220px; width: 100%; }
.section-header { margin-bottom: 24px; }
.section-header h2 { font-size: 32px; line-height: 1.05; margin: 0 0 8px; letter-spacing: -0.04em; }
.section-header p { margin: 0; color: var(--muted); font-size: 15px; max-width: 760px; }
.stat-grid, .card-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 28px; }
.stat-card, .document-card, .scenario-card, .gpt-card { background: var(--panel); border: 1px solid var(--line); border-radius: 18px; padding: 18px; }
.stat-card strong { font-size: 36px; color: var(--accent); display: block; }
.stat-card span { color: var(--muted); }
.search-input { width: 100%; padding: 14px 16px; border-radius: 14px; border: 1px solid var(--line); background: var(--panel); color: var(--text); margin-bottom: 14px; }
.filter-row { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 12px; }
.filter-row button { border: 1px solid var(--line); background: transparent; color: var(--muted); padding: 8px 12px; border-radius: 999px; cursor: pointer; }
.filter-row button.selected, .filter-row button:hover { color: var(--accent); border-color: var(--accent); background: rgba(245,158,11,.1); }
.results-line { color: var(--muted); font-size: 13px; }
.card-list { display: grid; gap: 12px; }
.gpt-card { border-left: 4px solid var(--accent); padding: 0; overflow: hidden; }
.gpt-card-header { width: 100%; text-align: left; background: transparent; color: var(--text); border: 0; padding: 18px; display: flex; align-items: center; justify-content: space-between; cursor: pointer; }
.gpt-title-row { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.gpt-title-row h3 { margin: 0; }
.gpt-card-header p { color: var(--muted); margin: 4px 0 0; }
.badge { display: inline-flex; align-items: center; border: 1px solid; border-radius: 999px; padding: 3px 8px; font-size: 11px; font-weight: 700; }
.gpt-detail { border-top: 1px solid var(--line); padding: 18px; }
.gpt-detail h4 { margin: 16px 0 8px; color: var(--muted); font-size: 12px; text-transform: uppercase; letter-spacing: .08em; }
pre { white-space: pre-wrap; overflow-x: auto; background: #08080d; border: 1px solid var(--line); border-radius: 14px; padding: 14px; color: #d1d5db; }
blockquote { color: var(--muted); border-left: 3px solid var(--accent); padding-left: 14px; margin-left: 0; }
.capability-row { display: flex; flex-wrap: wrap; gap: 6px; }
.capability-row span, .meta-row span { background: rgba(255,255,255,.05); color: var(--muted); border-radius: 999px; padding: 5px 8px; font-size: 12px; }
.action-row { display: flex; gap: 10px; margin-top: 16px; }
.action-row button { background: var(--accent); color: #111; border: 0; padding: 10px 14px; border-radius: 10px; font-weight: 800; cursor: pointer; }
.action-row button.secondary { background: transparent; color: var(--muted); border: 1px solid var(--line); }
.deploy-box { margin-top: 16px; background: rgba(245,158,11,.08); border: 1px solid rgba(245,158,11,.2); border-radius: 14px; padding: 14px; }
.doc-icon { font-size: 28px; }
.document-card h3, .scenario-card h3 { margin: 8px 0; }
.document-card p, .scenario-card p { color: var(--muted); }
.meta-row { display: flex; gap: 6px; flex-wrap: wrap; }

@media (max-width: 860px) {
  .app-shell { grid-template-columns: 1fr; }
  .sidebar { position: relative; height: auto; }
  .main-panel { padding: 22px; }
}
EOF

# ─────────────────────────────────────────────
# 11. VERIFY
# ─────────────────────────────────────────────

echo "Running build check..."
npm run build

echo "Refactor complete. Next commands:"
echo "npm run dev"
echo "git add ."
echo "git commit -m 'Productize ACoolECOSYSTEM Unified AI OS'"
echo "git push -u origin main"
