import {
  Avatar,
  Badge,
  Table,
  Group,
  Text,
  ActionIcon,
  Anchor,
  ScrollArea,
  useMantineTheme,
} from "@mantine/core";
import {
  IconPencil,
  IconTrash,
  IconList,
  IconArrowMoveRight,
} from "@tabler/icons";
import hostMap from "../../../wujie-config/hostMap";


export default function TriggersList({ data, onSelectNode }) {
  const theme = useMantineTheme();
  const api_base_url = hostMap('workflow-api')
  const rows = data.map((item) => (
    <tr key={item.name}>
      <td>
        <Group spacing="sm">
          <IconArrowMoveRight size="30" />
          <Text size="sm" weight={500}>
            {item.name}
          </Text>
        </Group>
      </td>

      <td>
        <Anchor size="sm" href={ "#/Workflows/"+ item.workflowId } onClick={(event) => event.preventDefault()}>
          {item.workflowId}
        </Anchor>
      </td>
      <td>
        <Text size="sm" color="dimmed">
          {api_base_url}/triggers/{item.shortcode}/
        </Text>
      </td>

      <td>
        <Group spacing={0} position="right">
          <ActionIcon onClick={() => onSelectNode(item.id)} >
            <IconPencil size={16} stroke={1.5} />
          </ActionIcon>
          <ActionIcon color="red">
            <IconTrash size={16} stroke={1.5} />
          </ActionIcon>
        </Group>
      </td>
    </tr>
  ));

  return (
    <ScrollArea>
      <Table sx={{ minWidth: 800 }} verticalSpacing="sm">
        <thead>
          <tr>
            <th>Name</th>
            <th>Workflow</th>
            <th>URL</th>
            <th />
          </tr>
        </thead>
        <tbody>{rows}</tbody>
      </Table>
    </ScrollArea>
  );
}
