import React, { useState, useCallback } from "react";
import { Text } from "slate";

import useUpdateEffect from "hooks/useUpdateEffect";
import Node from "types/Node";
import Story from "types/Story";
import TextEditor from "components/TextEditor";
import Modal from "components/Modal";
import Button from "components/Button";
import gptChat from "utils/api/langflow";
import { parentTravel,parentTravelVariables } from "utils/compiler/graphBfs"

import "./NodeModal.css";

const getFirstText = (elements) => {
  const getFirstTextChild = (node) => {
    if (Text.isText(node)) {
      return node.text;
    } else {
      if (node.children) {
        let label = "";
        for (let i = 0; i < node.children.length; i++) {
          label = getFirstTextChild(node.children[i]);
          if (label !== "") return label;
        }
        return label;
      } else {
        return "";
      }
    }
  };

  let label = "";
  for (let i = 0; i < elements.length; i++) {
    label = getFirstTextChild(elements[i]);
    if (label !== "") return label;
  }
  return label;
};

interface Props {
  node: Node;  
  isValidID: (id: string) => boolean;
  onSave: (node: Node) => void;
  onCancel: () => void;
  variablesGet: () => Object;
  story: Story;
}

const NodeModal: React.FC<Props> = ({ node, isValidID, onSave, onCancel, story, variablesGet}) => {
  const cutoff = node.type === "input" ? 35 : 90;
  const [madeChanges, setMadeChanges] = useState(false);
  const [id, setId] = useState(node.id);
  const [label, setLabel] = useState(node.data.label);
  const [text, setText] = useState(node.data.text);
  const [ignoreCapitalisation, setIgnoreCapitalisation] = useState(
    node.data.ignoreCapitalisation
  );
  const [ignorePunctuation, setIgnorePunctuation] = useState(
    node.data.ignorePunctuation
  );
  const [ignoreArticles, setIgnoreArticles] = useState(
    node.data.ignoreArticles
  );
  const [useAI, setUseAI] = useState(
    node.data.useAI
  );
  const [validID, setValidID] = useState(true);  

  const onChangeId = useCallback(
    (e) => {
      const newId = e.target.value;
      setId(newId);
      setValidID(newId !== "" && (newId === node.id || isValidID(newId)));
    },
    [setId, setValidID, isValidID, node.id]
  );

  const onChangeLabel = useCallback(
    (e) => {
      const newLabel = e.target.value;      
      setLabel(newLabel);      
    },
    [setLabel, node.data.label]
  );

  useUpdateEffect(() => {
    setMadeChanges(true);
  }, [label, text, ignoreCapitalisation, ignorePunctuation, ignoreArticles]);

  const onAutoComplete = async (state) => {    
    node.data.text = state;
    const states = variablesGet();
    const result = await gptChat(story, node, states);
    return result.data
  };

  return (
    <Modal
      title="Edit Node Label and Content:"
      className="NodeModal"
      onSave={() =>
        validID &&
        onSave({
          ...node,          
          data: {
            ...node.data,
            label: label!='New node' && label || getFirstText(text).slice(0, cutoff) +  (text.length < cutoff ? "" : "...") || "Empty Node",
            text: text,
            ignoreCapitalisation: ignoreCapitalisation,
            ignorePunctuation: ignorePunctuation,
            ignoreArticles: ignoreArticles,
            useAI: useAI
          },
        })
      }
      onCancel={() => {
        if (madeChanges) {
          if (window.confirm("Are you sure you want to discard your changes?"))
            onCancel();
        } else {
          onCancel();
        }
      }}
    >
      <div className="section__id">
        <label className="label__id" htmlFor="id">          
        </label>
        <div className="section__input__id">
          <input
            className={"input__id" + (validID ? "" : " invalid")}
            id="label"
            value={label}
            onChange={onChangeLabel}
          />
          {!validID && (
            <div className="error_message">
              {id === ""
                ? "Please enter an ID."
                : "This ID already exists. Please choose a different ID."}
            </div>
          )}
        </div>
      </div>      
      <section className="textEditorSection">
        <TextEditor
          initialValue={node.data.text}
          onChange={(state) => setText(state)}
          onAutoComplete={onAutoComplete}
        />
      </section>
      {node.data.pathType === "text" && node.type !== "output" && (
        <>
          <h3>Text Path Options</h3>
          <section id="options">
            <div className="option">
              <input
                type="checkbox"
                id="capitalisation"
                name="capitalisation"
                value="capitalisation"
                checked={ignoreCapitalisation}
                onChange={() => setIgnoreCapitalisation(!ignoreCapitalisation)}
              />
              <label htmlFor="capitalisation"> 忽略单复数（Ignore capitalisation）</label>
            </div>
            <div className="option">
              <input
                type="checkbox"
                id="punctuation"
                name="punctuation"
                value="punctuation"
                checked={ignorePunctuation}
                onChange={() => setIgnorePunctuation(!ignorePunctuation)}
              />
              <label htmlFor="punctuation"> 忽略标点符号（Ignore punctuation）</label>
            </div>
            <div className="option">
              <input
                type="checkbox"
                id="articles"
                name="articles"
                value="articles"
                checked={ignoreArticles}
                onChange={() => setIgnoreArticles(!ignoreArticles)}
              />
              <label htmlFor="articles"> 忽略语气词，助词、冠词（Ignore articles the/a/an）</label>
            </div>
            <div className="option">
              <input
                type="checkbox"
                id="useAI"
                name="useAI"
                value="useAI"
                checked={useAI}
                onChange={() => setUseAI(!useAI)}
              />
              <label htmlFor="useAI"> 使用人工智能判断路径匹配（Use AI to determine path matching）</label>
            </div>
          </section>
        </>
      )}
    </Modal>
  );
};

export default NodeModal;
