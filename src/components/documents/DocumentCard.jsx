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
