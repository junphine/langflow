import { Dispatch, SetStateAction } from "react";
import { FlowType } from "../flow";
import { TabsContextType, TabsState } from "../tabs";

export type WorkflowsContextType = {
  saveFlow: (flow: FlowType) => Promise<void>;
  save: () => void;
  tabId: string;
  setTabId: (index: string) => void;
  flows: Array<FlowType>;
  removeFlow: (id: string) => void;
  addFlow: (flowData?: FlowType, newProject?: boolean) => Promise<String>;
  updateFlow: (newFlow: FlowType) => void;
  incrementNodeId: () => string;
  downloadFlow: (flow: FlowType) => void;
  downloadFlows: () => void;
  uploadFlows: () => void;
  uploadFlow: (newFlow?: boolean) => void;
  hardReset: () => void;  
  getNodeId: (nodeType: string) => string;
  tabsState: TabsState;
  setTabsState: (state: TabsState) => void;
};

export type WorkflowsState = {
  [key: string]: {
    isPending: boolean;
  };
};
