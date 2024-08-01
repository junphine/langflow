import { useState } from "react";
import { HashRouter as Router, Route, Routes, NavLink, Navigate, useLocation, useNavigate } from "react-router-dom";

import NavbarSimple from "./Navigation";
import LayoutFlow from "./components/sections/LayoutFlow/LayoutFlow.jsx";
import WorkflowListOrDetail from "./components/sections/LayoutFlow/WorkflowListOrDetail.jsx";
import Triggers from "./components/sections/Triggers/Triggers";
import WorkflowLibraryOrDetail from "./components/sections/WorkflowLibrary/WorkflowLibraryOrDetail";
import NodeLibrary from "./components/sections/NodeLibrary/NodeLibrary";
import Logs from "./components/sections/Logs/Logs";
import Debug from "./components/sections/Debug/Debug";
// wujie-comp
import CollectionFlow from "./pages/langflow.jsx";

import WujieReact from "wujie-react";

const { bus } = WujieReact;

export default function App() {
  const [active, setActive] = useState("Workflows");
  // style: flex: "1 0 auto"
  return (
    <div style={{ display: "flex" }}>
     <Router>
      <NavbarSimple active={active} onChange={setActive} />
      <div style={{ width: '100%' }}>
        <Routes>          
          <Route path="/Workflows" element={<WorkflowListOrDetail />} />
          <Route path="/WorkflowTemplates" element={<WorkflowLibraryOrDetail />} />
          <Route path="/Workflows/:id" element={<WorkflowListOrDetail />} />
          <Route path="/WorkflowTemplates/:id" element={<WorkflowLibraryOrDetail />} />
          <Route path="/Triggers" element={<Triggers />} />
          <Route path="/NodeLibrary" element={<NodeLibrary />} />
          <Route path="/Collections" element={<CollectionFlow />} />
          <Route path="/Logs" element={<Logs />} />
          <Route path="/Debug" element={<Debug />} />
          <Route path="*" element={<Navigate to="/Workflows" replace />} />
        </Routes>
      </div>
      </Router>
    </div>
  );
}
