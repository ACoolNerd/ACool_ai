export default function ScenarioCard({ scenario }) {
  return (
    <article className="scenario-card">
      <h3>{scenario.title}</h3>
      <p>{scenario.timeline}</p>
      <strong>{scenario.outcome}</strong>
    </article>
  );
}
