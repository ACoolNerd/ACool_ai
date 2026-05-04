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
