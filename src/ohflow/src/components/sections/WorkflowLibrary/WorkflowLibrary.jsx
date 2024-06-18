import { useState, useEffect } from "react";
import {
  MantineProvider,
  Container,
  SimpleGrid,
  Card,
  Group,
  Text,
  Button,
  ActionIcon,
  Image,
  Paper,
  Space,
} from "@mantine/core";
import { IconHeart } from "@tabler/icons";
import LayoutFlow from "../LayoutFlow/LayoutFlow.jsx";

import { LoremIpsum } from "react-lorem-ipsum";
import hostMap from "../../../wujie-config/hostMap";

export default function WorkflowLibrary({ onSelect,onUpvote,isTemplate=false }) {
  const [workflows, setWorkflows] = useState([]);
  const api_base_url = hostMap('langflow-api');
  //Load nodes from API
  useEffect(() => {
    fetch(api_base_url+"/workflows/"+(isTemplate?'template':''))
      .then((res) => res.json())
      .then((json) => {
        // const names = json.map((x) => x);
        setWorkflows(json);
      });
  }, []);

  function WorkflowList({ rows }) {
    return rows.map(({name,id,description}) => (
      <Card withBorder radius="md" p="md" key={name} style={{ padding: 40 }}>
        <Card.Section style={{ height: 180 }}>
          <LayoutFlow displayOnly="true" flowId={id} />
        </Card.Section>

        <Card.Section mt="md">
          <Group position="apart">
            <Text size="lg" weight={500}>
              {name}
            </Text>
          </Group>
          <Text size="sm" mt="xs">
           { description? description: <LoremIpsum p={1} avgSentencesPerParagraph={2} /> }
          </Text>
        </Card.Section>

        <Card.Section mt="md">
          <Group mt="xs">
            <Button radius="md" style={{ flex: 1,padding: 2 }} onClick={() => onSelect(id)} >
              Show details
            </Button>
            <ActionIcon variant="default" radius="md" size={36} onClick={() => onUpvote(id)} >
              <IconHeart size={18} stroke={1.5} />
            </ActionIcon>
          </Group>
        </Card.Section>
      </Card>
    ));
  }

  return (
    <Container style={{ padding: 20 }}>
      <Group position="right">
        <Button onClick={() => onSelect(1)} >New Workflow</Button>
      </Group>
      <Space h="md" />
      <SimpleGrid cols={4}>
        <WorkflowList rows={workflows} />
      </SimpleGrid>
    </Container>
  );
}
