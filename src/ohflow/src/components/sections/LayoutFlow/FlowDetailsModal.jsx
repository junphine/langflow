import { useState } from "react";
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
  Notification,
} from "@mantine/core";

import { useSetState } from "@mantine/hooks";

import { IconLock, IconLockOpen } from "@tabler/icons";

import { useForm, Controller } from "react-hook-form";

import { nodeTypes } from "../../nodes/index.jsx";


function LockIcon({ isLocked, handleClick }) {
  return (
    <a onClick={handleClick}>{isLocked ? <IconLock /> : <IconLockOpen />}</a>
  );
}

export default function FlowDetailsModal({
  opened,
  activeNode,
  onClose,
  onDelete,
  onSubmit  
}) {
  const [title, setTitle] = useState(activeNode?.name);
  const [message, setMessage] = useState('');

  const id = activeNode?.id || "";

  const editTitle = (event) => {
    //console.log(event.target.value);
    setTitle(event.target.value);
  };

  const { control, register, handleSubmit } = useForm();

  const handleActiveNodeLockToggle = () => {
    const node = activeNode;
    if (node) {
      // as per https://reactflow.dev/docs/examples/nodes/update-node/ we must
      // create a new data object or the update doesn't get triggered
      node.isLocked = !node.isLocked;
      activeNode.isLocked = node.isLocked;
      //console.log(node);
      if(activeNode.isLocked){
        setTitle(node.name+'*');
      }
      else{
        node.name = node.name.replace(/(^\s*)|(\**$)/g,"")
        setTitle(node.name);
      }
      
    }
  };

  return (
    <>
      <Modal
        opened={opened}
        onClose={onClose}
        title={<Title order={3}>Edit & Save Flow</Title>}
      >
        <form onSubmit={handleSubmit(onSubmit)}>        
          <div key={'name'}>
            <Controller
              name={'name'}
              control={control}
              rules={{ required: true }}
              defaultValue={activeNode?.name || ""}
              render={({ field, fieldState }) => (
                <TextInput
                  {...field}
                  name="textinput"
                  label={'Name'}
                  error={
                    fieldState.error != undefined
                      ? fieldState.error.type
                      : false
                  }
                />
              )}
            />
            <Space h="md" />
          </div>
           <div key={'description'}>
             <Controller
               key={'description'}
               name={'description'}
               control={control}
               rules={{ required: true }}
               defaultValue={activeNode?.description || ""}
               render={({ field, fieldState }) => (
                 <Textarea
                   {...field}
                   name="textinput"
                   label={'Description'}
                   placeholder={ '流程介绍，功能，使用' }
                   autosize
                   minRows={3}
                   maxRows={8}
                   error={
                     fieldState.error != undefined
                       ? fieldState.error.type
                       : false
                   }
                 />
               )}
             />{" "}
             <Space h="md" />
           </div>
          { message && <Notification title="" closeButtonProps={{ 'aria-label': 'Hide notification' }} children={message} onClose={()=>{setMessage('')}}/> }
          <Space h="md" />
          <Group position="right">
            <LockIcon
              isLocked={activeNode?.isLocked}
              handleClick={handleActiveNodeLockToggle}
            />
            <Button color="red" onClick={ async (e)=> setMessage(await onDelete(activeNode)) }>
              Delete
            </Button>
            <Button type="submit">Save</Button>
          </Group>
        </form>
      </Modal>
    </>
  );
}
