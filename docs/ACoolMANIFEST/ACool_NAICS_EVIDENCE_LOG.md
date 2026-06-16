# ACool NAICS Evidence Log

## Purpose

This log records local evidence references for ACoolBUSINESS NAICS case-study work. These PDFs are reference inputs only and are not copied into the repo.

## Source Records

### Human Capital Workforce Development Sample

- Path: `/Users/acoolnerd/iCloud Drive (Archive)/Documents/ACoolBUSINESS/ACoolBUSINESS - NAICS Case Study/ACoolBUSINESS - Human Capital Workforce Development Company SAMPLE - Deloitte.pdf`
- File size: approximately 662 KB.
- Page count extracted: 39.
- Publisher/company metadata: Deloitte.
- Evidence classification: human capital, workforce development, talent acquisition, talent development, workforce analytics.
- Extraction method: bundled Codex Python runtime with `pypdf`.
- Confidence: medium-high for text extraction, unverified for visual layout because Poppler tools are not installed.

### Information Technology Sample

- Path: `/Users/acoolnerd/iCloud Drive (Archive)/Documents/ACoolBUSINESS/ACoolBUSINESS - NAICS Case Study/ACoolBUSINESS - Information Technology Company SAMPLE - Deloitte.pdf`
- File size: approximately 637 KB.
- Page count extracted: 36.
- Publisher/company metadata: Deloitte.
- Evidence classification: information technology, cybersecurity services, health IT, professional IT services, identity/product-service components.
- Extraction method: bundled Codex Python runtime with `pypdf`.
- Confidence: medium-high for text extraction, unverified for visual layout because Poppler tools are not installed.

## Handling Rules

- Do not commit the PDFs into this repo.
- Do not republish long PDF text.
- Use the PDFs to inform ACoolBUSINESS NAICS modeling, not ACool runtime secrets or unrelated venture content.
- Keep ACoolBUSINESS evidence separate from ACoolECOSYSTEM infrastructure implementation.

## 7-Field Source Record Pattern

```json
{
  "id": "source-id",
  "entity": "ACoolBUSINESS",
  "type": "osint-source",
  "name": "source display name",
  "status": "referenced-local",
  "owner": "ACoolNERD",
  "updatedAt": "2026-06-16",
  "metadata": {
    "path": "local source path",
    "pageCount": 0,
    "confidence": "medium-high",
    "handling": "reference-only"
  }
}
```
