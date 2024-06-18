import * as LoadedNode from "./LoadedNode.jsx";
import hostMap from "../../wujie-config/hostMap";

export const nodeTypes = {
  decision: LoadedNode.default,
  comment: LoadedNode.default,
  default: LoadedNode.default,
  notification: LoadedNode.default,
};

var loadedNodes = [];

var loadedNodesTable = [];

const api_base_url = hostMap('workflow-api')

//Globally load all the nodes. I am not sure the best way to do this :(
//Maybe I should set this as a context for React. Otherwise I can't
//pass this into the CustomNode
fetch(api_base_url+"/nodes/")
  .then((res) => res.json())
  .then((json) => {
    //console.log(json);
    loadedNodes = json;

    // console.log(json);

    json.forEach((value) => {
      loadedNodesTable[value.name] = value;
    });
    // console.log(loadedNodesTable);

    //Note: this will get called twice in dev if React.Strict mode is turned on
    console.log("Loading nodes from API {api_base_url}/tenant/1/nodes");
  });

export var loadedNodes;
export var loadedNodesTable;

export default nodeTypes;
