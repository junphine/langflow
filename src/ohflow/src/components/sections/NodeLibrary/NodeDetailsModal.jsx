import { useState, useEffect } from "react";
import {
  Modal,
  Button,
  Group,
  TextInput,
  Textarea,
  Space,
  Text,
  TextArea,
  Checkbox,
  Title,
  JsonInput
} from "@mantine/core";
import { useSetState } from "@mantine/hooks";

import { useForm, Controller } from "react-hook-form";

export default function NodeDetailsModal({
  opened,
  activeNode,
  onClose,
  onDelete,
  onSubmit,
  nodeLibrary,
}) {
  const id = activeNode.id || "";

  const { control, register, handleSubmit } = useForm();

  return (
    <>
      <Modal
        opened={opened}
        onClose={onClose}
        size="lg"
        title={<Title order={3}>Edit Node</Title>}
      >
        {/* {JSON.stringify(activeNode)} */}
        <form onSubmit={handleSubmit(onSubmit)}>
          <input name="id" type="hidden" value={activeNode.id} readOnly />
          <Controller
            name="name"
            control={control}
            rules={{ required: true }}
            defaultValue={activeNode.name || "New Node"}
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
            name="description"
            control={control}
            rules={{ required: false }}
            defaultValue={activeNode.description || ""}
            render={({ field, fieldState }) => (
              <TextInput
                {...field}
                name="description"
                label="Description"
                error={
                  fieldState.error != undefined ? fieldState.error.type : false
                }
              />
            )}
          />
          <Space h="md" />
          <Controller
            name="code"
            control={control}
            rules={{ required: true }}
            defaultValue={activeNode.code || ""}
            render={({ field, fieldState }) => (
              <Textarea
                {...field}
                name="code"
                label="Code"
                placeholder="e.g. Processing Node"
                description="Python code that must return dict(obj=obj, outputNode=0). Use triple brackes { ... } to include a snipet from an editable field below."
                autosize
                minRows={3}
                maxRows={8}
                error={
                  fieldState.error != undefined ? fieldState.error.type : false
                }
              />
            )}
          />
          <Space h="md" />
          <Controller
            name="outputNodes"
            control={control}
            rules={{ required: true }}
            defaultValue={JSON.stringify(activeNode.outputNodes) || '["out_0"]'}
            render={({ field, fieldState }) => (
              <TextInput
                {...field}
                name="outputNodes"
                label="Output Handles"
                placeholder='["True","False"]'
                error={
                  fieldState.error != undefined ? fieldState.error.type : false
                }
              />
            )}
          />
          <Space h="md" />

          <Controller
            name="editableFields"
            control={control}
            rules={{ required: true }}
            defaultValue={JSON.stringify(activeNode.editableFields,null,2) || ""}
            render={({ field, fieldState }) => (
              <JsonInput
                {...field}
                name="editableFields"
                label="Editable Fields"
                autosize
                minRows={5}
                maxRows={16}
                description="Array of JSON objects with id, label, type. These get added to the data parameter of the final node, and are passed to the code as template variables."
                placeholder='[{
                  id: "code",
                  label: "Conditional Logic",
                  type: "textarea",
                  defaultValue: "dict(obj=obj, outputPort=0)",
                  description:
                    "Python code that returns an object and output port dict(obj=obj, outputPort=0)",
                  placeHolder: "outputPort = 0;\ndict(obj=obj, outputPort=outputPort)",
                },{
                  id: "ifstatement",
                  label: "If Statement",
                  type: "input",
                  defaultValue: "",
                  placeHolder: "obj.value == \"apple\"",
                }]'
                error={
                  fieldState.error != undefined ? fieldState.error.type : false
                }
              />
            )}
          />
          <Space h="md" />

          <Controller
            name="css"
            control={control}
            rules={{ required: true }}
            defaultValue={activeNode.css || ""}
            render={({ field, fieldState }) => (
              <>
                <Textarea
                  {...field}
                  name="css"
                  label="Style (React-style CSS)"
                  placeholder='{ backgroundColor: "red", color: "blue" }'
                  autosize
                  minRows={2}
                  maxRows={5}
                  error={
                    fieldState.error != undefined
                      ? fieldState.error.type
                      : false
                  }
                />
                {/* we could render a fake node here! <div style={JSON.parse(field.value}>Node</div> */}
              </>
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
