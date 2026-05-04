import { Routes, Route } from "react-router-dom";
import PageShell from "./components/layout/PageShell";
import Dashboard from "./pages/Dashboard";
import GPTCommandCenter from "./pages/GPTCommandCenter";
import DocumentNavigator from "./pages/DocumentNavigator";
import BlueprintViewer from "./pages/BlueprintViewer";
import PlaybookTracker from "./pages/PlaybookTracker";
import Productize from "./pages/Productize";
import Deploy from "./pages/Deploy";
import "./styles/globals.css";

export default function App() {
  return (
    <PageShell>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/gpt-command-center" element={<GPTCommandCenter />} />
        <Route path="/doc-navigator" element={<DocumentNavigator />} />
        <Route path="/blueprint" element={<BlueprintViewer />} />
        <Route path="/playbook" element={<PlaybookTracker />} />
        <Route path="/productize" element={<Productize />} />
        <Route path="/deploy" element={<Deploy />} />
      </Routes>
    </PageShell>
  );
}
