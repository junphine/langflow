import { useState, useEffect } from "react";
import {
  Modal,
  Button,
  Group,
  TextInput,
  Textarea,
  Space,
  Text,
  Checkbox,
  Title,
  Select,
  JsonInput
} from "@mantine/core";
import { useSetState } from "@mantine/hooks";

import { useForm, Controller } from "react-hook-form";

export default function TriggersDetailsModal({
  opened,
  activeNode,
  onClose,
  onDelete,
  onSubmit,
  nodeLibrary,
  workflows
}) {
  const id = activeNode.id || "";

  const { control, register, handleSubmit } = useForm();

  return (
    <>
      <Modal
        opened={opened}
        onClose={onClose}
        size="lg"
        title={<Title order={3}>Edit Trigger</Title>}
      >
        <form onSubmit={handleSubmit(onSubmit)}>
          <input name="id" type="hidden" value={activeNode.id} readOnly />
          <Controller
            name="name"
            control={control}
            rules={{ required: true }}
            defaultValue={activeNode.name || "New Trigger"}
            render={({ field, fieldState }) => (
              <TextInput
                {...field}
                name="name"
                label="Title"
                placeholder="e.g. Processing Node"
                error={
                  fieldState.error != undefined ? fieldState.error.type : false
                }
              />
            )}
          />
          <Space h="md" />
          <Controller
            name="shortcode"
            control={control}
            rules={{ required: true }}
            defaultValue={activeNode.shortcode || ""}
            render={({ field, fieldState }) => (
              <TextInput
                {...field}
                name="shortcode"
                label="Shortcode"
                error={
                  fieldState.error != undefined ? fieldState.error.type : false
                }
              />
            )}
          />
          <Space h="md" />
          <Controller
            name="workflowId"
            control={control}
            rules={{ required: true }}
            defaultValue={activeNode.workflowId || ""}
            render={({ field, fieldState }) => (
              <Select label='Select Workflow'  {...field}  data={workflows} />
            )}
          />


          <Space h="md" />

          <Group position="right">
            <Button color="red" onClick={onDelete}>
              Delete
            </Button>
            <Button type="submit">Save</Button>
          </Group>
        </form>
      </Modal>
    </>
  );
}
