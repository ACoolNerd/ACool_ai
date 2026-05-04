import { NavLink } from "react-router-dom";

export default function Sidebar() {
  const links = [
    ["/", "Dashboard"],
    ["/doc-navigator", "Document Navigator"],
    ["/gpt-command-center", "GPT Command Center"],
    ["/blueprint", "Blueprint Viewer"],
    ["/playbook", "30-Day Playbook"],
    ["/productize", "Product Roadmap"],
    ["/deploy", "Deploy"],
  ];

  return (
    <aside className="sidebar">
      <div className="brand">
        <div className="brand-mark">A</div>
        <div>
          <strong>ACoolECOSYSTEM</strong>
          <span>Unified AI OS</span>
        </div>
      </div>

      <nav>
        <h4>AI OS</h4>
        {links.map(([to, label]) => (
          <NavLink key={to} to={to}>
            {label}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
