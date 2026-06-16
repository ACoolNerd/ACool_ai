# ACool RACI and Separation of Duties

## Purpose

This RACI keeps ACoolECOSYSTEM infrastructure, schemas, OSINT evidence, and AI runtime duties separate.

## RACI Matrix

| Lane | Responsible | Accountable | Consulted | Informed |
|---|---|---|---|---|
| ACoolDATABASE | ACoolNERD | Keith McPherson | ACoolAI | ACoolECOSYSTEM operators |
| ACoolSCHEMA | ACoolNERD | Keith McPherson | ACoolAI | ACoolECOSYSTEM operators |
| ACoolOSINT | ACoolNERD | Keith McPherson | ACoolAI | ACoolBUSINESS stakeholders |
| ACoolAI | ACoolNERD | Keith McPherson | ACoolSCHEMA | ACoolECOSYSTEM operators |
| Docker Production Stack | ACoolNERD | Keith McPherson | ACoolDATABASE | ACoolECOSYSTEM operators |

## Separation Rules

- Database reset authority is separate from source-evidence intake.
- OSINT evidence does not become production schema without ACoolSCHEMA review.
- ACoolAI can summarize and route, but schema changes require explicit manifest updates.
- Secrets remain local and must not appear in docs, commits, screenshots, or prompt examples.
- Publishing, pushing, deploying, or external sharing requires explicit Keith approval.

## Governance

Rights → Disclosure → Proof
