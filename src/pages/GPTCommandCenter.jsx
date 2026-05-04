export default function GPTCommandCenter() {
  const gpts = [
    "ACoolECOSYSTEM Master",
    "ACoolTRUST",
    "ACoolHOLDINGS",
    "ProcessArc",
    "Notion/Discord Ops",
    "ACoolCOLLECTOR.com",
    "ACoolCARD",
    "ACoolCOLLECTION",
    "Break Vault™",
    "ACoolWEBSITE",
    "ACoolAPP",
    "ACoolACADEMY",
    "ACoolPROMPT",
    "Loe_NYC1",
    "iAmACoolCOLLECTOR",
    "ACoolNERD",
    "MEAP Platform",
    "Élite Vitality",
    "AGNP Clinical",
    "Practice Ops",
    "NASCAR Card Content",
    "Antigravity Prompt"
  ];

  return (
    <section>
      <div className="section-header">
        <h2>GPT Command Center</h2>
        <p>Browse and deploy the 22 ACoolECOSYSTEM GPT agents.</p>
      </div>

      <div className="card-grid">
        {gpts.map((gpt, index) => (
          <div className="document-card" key={gpt}>
            <h3>{index + 1}. {gpt}</h3>
            <p>Production-ready GPT agent. Full prompt and deployment panel will be expanded in v1.1.</p>
          </div>
        ))}
      </div>
    </section>
  );
}
