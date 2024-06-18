import { useContext, useEffect } from "react";
import { Download, Upload, Plus, Home, Combine, ExternalLink } from "lucide-react";
import useWorkFlowsManagerStore from "../../stores/workflowsManagerStore";
import { downloadFlow,downloadFlows } from "../../utils/reactflowUtils";
import { Button } from "../../components/ui/button";
import { Link, useNavigate } from "react-router-dom";
import CollectionCardComponent from "../../components/cardComponent";
import { USER_WORKFLOWS_HEADER } from "../../constants/constants";

export default function WorkflowPage() {
  
  const { flows, uploadFlows, addFlow, removeFlow } =  useWorkFlowsManagerStore();

  const navigate = useNavigate();
  return (
    <div className="w-full h-full flex overflow-auto flex-col bg-muted px-16">
      <div className="w-full flex justify-between py-12 pb-2 px-6">
        <span className="text-2xl flex items-center justify-center gap-2 font-semibold">          
		  <Combine className="w-6" />
          {USER_WORKFLOWS_HEADER}
        </span>
        <div className="flex gap-2">
          <Button
            variant="primary"
            onClick={() => {
              downloadFlows();
            }}
          >
            <Download className="w-4 mr-2" />
            Download Workflow
          </Button>
          <Button
            variant="primary"
            onClick={() => {
              uploadFlows();
            }}
          >
            <Upload className="w-4 mr-2" />
            Upload Workflow
          </Button>
          <Button
            variant="primary"
            onClick={() => {
              addFlow(false, undefined, true).then((id) => {
                navigate("/#Workflows/" + id);
              });
            }}
          >
            <Plus className="w-4 mr-2" />
            New Workflow
          </Button>
        </div>
      </div>
      <span className="flex pb-14 px-6 text-muted-foreground w-[60%]">
        Manage your personal workflow. Download or upload your workflow.
      </span>
      <div className="w-full p-4 grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        {flows.map((flow, idx) => (
          <CollectionCardComponent
            key={idx}
            data={flow}
            //id={''+flow.id}
            button={
              <Link to={"/#Workflows/" + flow.id}>
                <Button
                  variant="outline"
                  size="sm"
                  className="whitespace-nowrap "
                >
                  <ExternalLink className="w-4 mr-2" />
                  Edit Flow
                </Button>
              </Link>
            }
            onDelete={() => {
              removeFlow(flow.id);
            }}
          />
        ))}
      </div>
    </div>
  );
}
