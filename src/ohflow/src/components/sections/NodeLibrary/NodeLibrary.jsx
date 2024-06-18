import { useState, useEffect } from "react";
import { Container, Group, Button, Space } from "@mantine/core";
import { IconHeart } from "@tabler/icons";
import NodeList from "./NodeList";

import { LoremIpsum } from "react-lorem-ipsum";
import NodeDetailsModal from "./NodeDetailsModal";
import hostMap from "../../../wujie-config/hostMap";

export default function NodeLibrary() {
  const [nodeLibrary, setNodeLibrary] = useState([]);

  const [activeNode, setActiveNode] = useState(null);

  const onModalClose = () => {
    setActiveNode(null);
  };

  const onNodeDelete = (params) => {
    console.log("delete TODO");
    console.log(params.id);
    onModalClose();
  };

  const onEditActiveNode = (params) => {
    console.log("save node");
    console.log(params);
    saveToAPI(params)
    onModalClose();
  };

  const onSelectNode = (node) => {
    console.log(nodeLibrary);
    let foundNode = nodeLibrary.find((element) => element.name == node);
    setActiveNode(foundNode);
  };

  const newNode = () => {
    console.log("new");
    setActiveNode({});
  };
  const api_base_url = hostMap('workflow-api')
  //Load nodes from API
  useEffect(() => {
    fetch(api_base_url+"/nodes/")
      .then((res) => res.json())
      .then((json) => {
        //const names = json.map((x) => x.name);
        setNodeLibrary(json);
      });
  }, []);


  const saveToAPI= (node) => {
    let nodesToSave = node;
    nodesToSave.outputNodes = JSON.parse(node.outputNodes)
    nodesToSave.editableFields = JSON.parse(node.editableFields)
    //We will use this array to store the nodes in a format that we can save
    if(activeNode.id){
      fetch(api_base_url+"/nodes/"+ activeNode.id, {
          method: "PATCH",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(nodesToSave),
        });
    }
    else{
      fetch(api_base_url+"/nodes/", {
          method: "POST",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(nodesToSave),
        });
    }
  }

  return (
    <Container style={{ padding: 20 }}>
      <Space h="md" />
      <NodeList data={nodeLibrary} onSelectNode={onSelectNode} />
      {activeNode ? (
        <NodeDetailsModal
          opened={activeNode != null}
          activeNode={activeNode}
          onClose={onModalClose}
          onDelete={onNodeDelete}
          onSubmit={onEditActiveNode}
          nodeLibrary={nodeLibrary}
        />
      ) : null}
      <Space h="lg" />

      <Group position="right">
        <Button onClick={newNode}>New Node</Button>
      </Group>
    </Container>
  );
}
