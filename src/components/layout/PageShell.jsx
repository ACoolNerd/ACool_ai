import Sidebar from "./Sidebar";

export default function PageShell({ children }) {
  return (
    <div className="app-shell">
      <Sidebar />
      <main className="main-panel">{children}</main>
    </div>
  );
}
