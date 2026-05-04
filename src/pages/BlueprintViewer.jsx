export default function BlueprintViewer() {
  const layers = [
    "Identity Layer",
    "Knowledge Layer",
    "Agent Layer",
    "Workflow Layer",
    "Communication Layer",
    "Storage Layer",
    "Governance Layer",
    "Metrics Layer",
    "Deployment Layer",
    "Growth Layer"
  ];

  return (
    <section>
      <div className="section-header">
        <h2>Unified AI OS Blueprint</h2>
        <p>The 10-layer production architecture for ACoolECOSYSTEM.</p>
      </div>

      <div className="card-grid">
        {layers.map((layer, index) => (
          <div className="document-card" key={layer}>
            <h3>{index + 1}. {layer}</h3>
            <p>Architecture layer for system design, governance, and operations.</p>
          </div>
        ))}
      </div>
    </section>
  );
}
