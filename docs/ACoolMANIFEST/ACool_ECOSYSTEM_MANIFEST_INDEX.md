# ACoolECOSYSTEM Manifest Index

## Package

This package manifests ACoolDATABASE, ACoolSCHEMA, ACoolOSINT, and ACoolAI as governed lanes inside the Docker-first ACoolECOSYSTEM production workspace.

## Folder Map

```text
ACoolMANIFEST.md
ACoolDATABASE/
  README.md
ACoolSCHEMA/
  README.md
  acool_object_registry.json
ACoolOSINT/
  README.md
ACoolAI/
  README.md
docs/ACoolMANIFEST/
  ACool_ECOSYSTEM_MANIFEST_INDEX.md
  ACool_NAICS_EVIDENCE_LOG.md
  ACool_RACI_SEPARATION_OF_DUTIES.md
  ACool_DELIVERY_MANIFEST.md
```

## Live Stack Connection

The manifest is tied to the production Docker stack defined in `docker-compose.prod.yml`. The stack uses Nginx routing for local production testing and exposes governed health responses through Host-header routes.

## Source of Truth

- Runtime truth: Docker compose, service source files, Nginx config, smoke script.
- Schema truth: `database/` SQL files and `ACoolSCHEMA/acool_object_registry.json`.
- Evidence truth: referenced local PDFs and extraction notes in the NAICS evidence log.
- Governance truth: Rights → Disclosure → Proof, 7-field schema law, separation of duties.
