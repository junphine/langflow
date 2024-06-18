import { useState, useEffect } from "react";
import { Container, Group, Button, Space } from "@mantine/core";

import TriggersList from "./TriggersList";
import TriggersDetailsModal from "./TriggersDetailsModal";
import hostMap from "../../../wujie-config/hostMap";


export default function Triggers() {
  const [triggers, setTriggers] = useState([]);
  const [activeNode, setActiveNode] = useState(null);

  const api_base_url = hostMap('workflow-api')
  //Load Triggers from API
  useEffect(() => {
    fetch(api_base_url+"/triggers/")
      .then((res) => res.json())
      .then((json) => {
        setTriggers(json);
      });
  }, []);

  const [workflows, setWorkflows] = useState([]);
  //Load workflows from API
  useEffect(() => {
    fetch(api_base_url+"/workflows/")
      .then((res) => res.json())
      .then((json) => {
        const names = json.map((x) => { return { value: x.uuid , label: x.name }});
        setWorkflows(names);
      });
  }, []);

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
    let foundNode = triggers.find((element) => element.id == node);
    setActiveNode(foundNode);
  };

  const newNode = () => {
    console.log("new");
    setActiveNode({});
  };

  const saveToAPI= (node) => {
    let nodesToSave = node;

    //We will use this array to store the nodes in a format that we can save
    if(activeNode.id){
      fetch(api_base_url+"/triggers/"+ activeNode.id, {
          method: "PATCH",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
          },
          body: JSON.stringify(nodesToSave),
        });
    }
    else{
      fetch(api_base_url+"/triggers/", {
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
      <TriggersList data={triggers} onSelectNode={onSelectNode} />
      {activeNode ? (
        <TriggersDetailsModal
          opened={activeNode != null}
          activeNode={activeNode}
          onClose={onModalClose}
          onDelete={onNodeDelete}
          onSubmit={onEditActiveNode}
          nodeLibrary={triggers}
          workflows={workflows}
        />
      ) : null}
      <Space h="lg" />

      <Group position="right">
        <Button onClick={newNode}>New Trigger</Button>
      </Group>
    </Container>
  );
}
