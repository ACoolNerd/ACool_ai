export default function DocumentNavigator() {
  const docs = [
    "00_ORIGIN.md",
    "01_START_HERE_NAVIGATION_GUIDE.md",
    "02_GPT_MASTER_GUIDE.md",
    "03_UNIFIED_AI_OS_BLUEPRINT.md",
    "04_30_DAY_PLAYBOOK.md",
    "05_DEPLOYMENT_GUIDE.md",
    "06_PRODUCT_REQUIREMENTS_DOCUMENT.md",
    "07_INVESTOR_DEMO_DAY_BRIEF.md"
  ];

  return (
    <section>
      <div className="section-header">
        <h2>Document Navigator</h2>
        <p>Start here to understand the ACoolECOSYSTEM documents, deployment path, and reading order.</p>
      </div>

      <div className="card-grid">
        {docs.map((doc) => (
          <div className="document-card" key={doc}>
            <h3>{doc}</h3>
            <p>Core production document for the ACoolECOSYSTEM Unified AI OS.</p>
          </div>
        ))}
      </div>
    </section>
  );
}
