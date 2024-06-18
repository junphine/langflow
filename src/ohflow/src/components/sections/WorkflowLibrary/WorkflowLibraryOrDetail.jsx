import { useState } from "react";
import { useNavigate, useLocation, useParams } from "react-router-dom";
import LayoutFlow from "../LayoutFlow/LayoutFlow.jsx";
import WorkflowLibrary from "./WorkflowLibrary";
//TODO make this zoom into a single workflow to support detail
export default function WorkflowLibraryOrDetail(props) {
  let params = useParams();
  const [active, setActive] = useState(params.id);

  const onSelectFlow = (flow_id) => {
    setActive(flow_id)
  };

  const onUpvoteFlow = (flow_id) => {
    setActive(flow_id)
  };

  return (
    <>
      {active ? <LayoutFlow flowId={active} setActive={setActive} /> : null}
      {!active ? <WorkflowLibrary onSelect={onSelectFlow} onUpvote={onUpvoteFlow} isTemplate="true"/> : null}
    </>
  );
}
