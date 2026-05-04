export default function Badge({ children, color = "#f59e0b" }) {
  return (
    <span className="badge" style={{ borderColor: `${color}55`, color, background: `${color}18` }}>
      {children}
    </span>
  );
}
