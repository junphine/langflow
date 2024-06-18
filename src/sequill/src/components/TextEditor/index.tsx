import React, { useCallback, useMemo } from "react";
import imageExtensions from "image-extensions";
import isHotkey from "is-hotkey";
import isUrl from "is-url";
import Prism from 'prismjs'
import 'prismjs/components/prism-markdown'
import { css } from '@emotion/css'

import {
  Editable,
  withReact,
  ReactEditor,
  useSelected,
  useFocused,
  useSlate,
  Slate,
} from "slate-react";
import {
  Text,
  Editor,
  Transforms,
  createEditor,
  Element as SlateElement,
} from "slate";
import { withHistory } from "slate-history";
import {
  faBold,
  faItalic,
  faUnderline,
  faStrikethrough,
  faCode,
  faQuoteRight,
  faListUl,
  faListOl,
  faAlignLeft,
  faAlignRight,
  faAlignCenter,
  faAlignJustify,
  faImage,
  faTrashCan,
  faRandom,
  faMailReplyAll,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

import "./TextEditor.css";

const HOTKEYS = {
  "mod+b": "bold",
  "mod+i": "italic",
  "mod+u": "underline",
  "mod+`": "code",
  "mod+s": "strikethrough",
};

const LIST_TYPES = ["numbered-list", "bulleted-list"];
const TEXT_ALIGN_TYPES = ["left", "center", "right", "justify"];

const TextEditor = ({ initialValue, onChange, onAutoComplete }) => {
  const renderElement = useCallback((props) => <Element {...props} />, []);
  const renderLeaf = useCallback((props) => <Leaf {...props} />, []);
  const editor = useMemo(
    () => withImages(withHistory(withReact(createEditor() as ReactEditor))),
    []
  );

  const decorate = useCallback(([node, path]) => {
    const ranges = []

    if (!Text.isText(node)) {
      return ranges
    }

    const getLength = (token) => {
      if (typeof token === 'string') {
        return token.length
      } else if (typeof token.content === 'string') {
        return token.content.length
      } else {
        return token.content.reduce((l, t) => l + getLength(t), 0)
      }
    }

    const tokens = Prism.tokenize(node.text, Prism.languages.markdown)
    let start = 0

    for (const token of tokens) {
      const length = getLength(token)
      const end = start + length

      if (typeof token !== 'string') {
        ranges.push({
          [token.type]: true,
          anchor: { path, offset: start },
          focus: { path, offset: end },
        })
      }

      start = end
    }

    return ranges
  }, [])

  return (
    <div className="TextEditor">
      <Slate editor={editor} initialValue={initialValue} onChange={onChange}>
        <div className="toolbar">
          <MarkButton format="bold" icon={faBold} />
          <MarkButton format="italic" icon={faItalic} />
          <MarkButton format="underline" icon={faUnderline} />
          <MarkButton format="strikethrough" icon={faStrikethrough} />
          <MarkButton format="code" icon={faCode} />
          <BlockButton format="block-quote" icon={faQuoteRight} />
          <BlockButton format="bulleted-list" icon={faListUl} />
          <BlockButton format="numbered-list" icon={faListOl} />
          <BlockButton format="left" icon={faAlignLeft} />
          <BlockButton format="center" icon={faAlignCenter} />
          <BlockButton format="right" icon={faAlignRight} />
          <BlockButton format="justify" icon={faAlignJustify} />
          <ImageButton />
          <TextGenButton onAutoComplete={onAutoComplete} />
          <TextReGenButton />
        </div>
        <Editable
          className="editable"
          renderElement={renderElement}
          renderLeaf={renderLeaf}
          placeholder="Enter markdown text…"
          spellCheck
          autoFocus
          decorate={decorate}
          onKeyDown={(event) => {
            for (const hotkey in HOTKEYS) {
              if (isHotkey(hotkey, event)) {
                event.preventDefault();
                const mark = HOTKEYS[hotkey];
                toggleMark(editor, mark);
              }
            }
          }}
        />
      </Slate>
    </div>
  );
};

const withImages = (editor) => {
  const { insertData, isVoid } = editor;

  editor.isVoid = (element) => {
    return element.type === "image" ? true : isVoid(element);
  };

  editor.insertData = (data) => {
    const text = data.getData("text/plain");
    const { files } = data;

    if (files && files.length > 0) {
      for (const file of files) {
        const reader = new FileReader();
        const [mime] = file.type.split("/");

        if (mime === "image") {
          reader.addEventListener("load", () => {
            const url = reader.result;
            insertImage(editor, url);
          });

          reader.readAsDataURL(file);
        }
      }
    } else if (isImageUrl(text)) {
      insertImage(editor, text);
    } else {
      insertData(data);
    }
  };

  return editor;
};

const insertImage = (editor, url) => {
  const text = { text: "" };
  const image = { type: "image", url, children: [text] };
  const paragraph = { type: "paragraph", children: [text] };
  Transforms.insertNodes(editor, [image, paragraph]);
};

const insertGenerateText = (editor, author, completeText) => {
  const text = { text: completeText };
  author = author.replace('<','').replace('>','');
  if (author){
    const authorNode = { text: author };
    const url = '/images/speakers/' + author+'.jpg' || '';
    const image = { type: "image", url, attributes: { class: 'picture' }, children: [authorNode] };
    const paragraph = { type: "paragraph", children: [text] };
    Transforms.insertNodes(editor, [image,paragraph]);
  }
  else{
    const paragraph = { type: "paragraph", children: [text] };
    Transforms.insertNodes(editor, [paragraph]);
  }
  
};

const isImageUrl = (url) => {
  if (!url) return false;
  if (!isUrl(url)) return false;
  const ext = new URL(url).pathname.split(".").pop();
  return imageExtensions.includes(ext);
};

const toggleBlock = (editor, format) => {
  const isActive = isBlockActive(
    editor,
    format,
    TEXT_ALIGN_TYPES.includes(format) ? "align" : "type"
  );
  const isList = LIST_TYPES.includes(format);

  Transforms.unwrapNodes(editor, {
    match: (n) =>
      !Editor.isEditor(n) &&
      SlateElement.isElement(n) &&
      LIST_TYPES.includes((n as any).type) &&
      !TEXT_ALIGN_TYPES.includes(format),
    split: true,
  });
  let newProperties;
  if (TEXT_ALIGN_TYPES.includes(format)) {
    newProperties = {
      align: isActive ? undefined : format,
    };
  } else {
    newProperties = {
      type: isActive ? "paragraph" : isList ? "list-item" : format,
    };
  }
  Transforms.setNodes(editor, newProperties);

  if (!isActive && isList) {
    const block = { type: format, children: [] };
    Transforms.wrapNodes(editor, block);
  }
};

const toggleMark = (editor, format) => {
  const isActive = isMarkActive(editor, format);

  if (isActive) {
    Editor.removeMark(editor, format);
  } else {
    Editor.addMark(editor, format, true);
  }
};

const isBlockActive = (editor, format, blockType = "type") => {
  const { selection } = editor;
  if (!selection) return false;

  const [match] = Array.from(
    Editor.nodes(editor, {
      at: Editor.unhangRange(editor, selection),
      match: (n) =>
        !Editor.isEditor(n) &&
        SlateElement.isElement(n) &&
        n[blockType] === format,
    })
  );

  return !!match;
};

const isMarkActive = (editor, format) => {
  const marks = Editor.marks(editor);
  return marks ? marks[format] === true : false;
};

const Element = ({ attributes, children, element }) => {
  const style = { textAlign: element.align };
  switch (element.type) {
    case "block-quote":
      return (
        <blockquote style={style} {...attributes}>
          {children}
        </blockquote>
      );
    case "bulleted-list":
      return (
        <ul style={style} {...attributes}>
          {children}
        </ul>
      );
    case "heading-one":
      return (
        <h1 style={style} {...attributes}>
          {children}
        </h1>
      );
    case "heading-two":
      return (
        <h2 style={style} {...attributes}>
          {children}
        </h2>
      );
    case "list-item":
      return (
        <li style={style} {...attributes}>
          {children}
        </li>
      );
    case "numbered-list":
      return (
        <ol style={style} {...attributes}>
          {children}
        </ol>
      );
    case "image":
      return (
        <Image attributes={attributes} element={element}>
          {children}
        </Image>
      );
    default:
      return (
        <p style={style} {...attributes}>
          {children}
        </p>
      );
  }
};

const Image = ({ attributes, children, element }) => {
  const editor = useSlate();
  const path = ReactEditor.findPath(editor as ReactEditor, element);

  const selected = useSelected();
  const focused = useFocused();
  return (
    <div {...attributes}>
      <div contentEditable={false} style={{ position: "relative" }}>
        <img src={element.url} />
        <div
          className="deleteImage"
          style={{ display: selected && focused ? "inline" : "none" }}
          onClick={() => Transforms.removeNodes(editor, { at: path })}
        >
          <FontAwesomeIcon icon={faTrashCan} />
        </div>
      </div>
      {children}
    </div>
  );
};

const Leaf = ({ attributes, children, leaf }) => {
  if (leaf.bold) {
    children = <strong>{children}</strong>;
  }
  if (leaf.code) {
    children = <code>{children}</code>;
  }
  if (leaf.italic) {
    children = <em>{children}</em>;
  }
  if (leaf.underline) {
    children = <u>{children}</u>;
  }
  if (leaf.strikethrough) {
    children = (
      <span style={{ textDecoration: "line-through" }}>{children}</span>
    );
  }
  return (
    <span
      {...attributes}
      className={css`
        font-weight: ${leaf.bold && 'bold'};
        font-style: ${leaf.italic && 'italic'};
        text-decoration: ${leaf.underlined && 'underline'};
        ${leaf.title &&
        css`
          display: inline-block;
          font-weight: bold;
          font-size: 20px;
          margin: 20px 0 10px 0;
        `}
        ${leaf.list &&
        css`
          padding-left: 10px;
          font-size: 20px;
          line-height: 10px;
        `}
        ${leaf.hr &&
        css`
          display: block;
          text-align: center;
          border-bottom: 2px solid #ddd;
        `}
        ${leaf.blockquote &&
        css`
          display: inline-block;
          border-left: 2px solid #ddd;
          padding-left: 10px;
          color: #aaa;
          font-style: italic;
        `}
        ${leaf.code &&
        css`
          font-family: monospace;
          background-color: #eee;
          padding: 3px;
        `}
      `}
    >
      {children}
    </span>
  )
  return <span {...attributes}>{children}</span>;
};

const BlockButton = ({ format, icon }) => {
  const editor = useSlate();
  return (
    <div
      className={
        "button" +
        (isBlockActive(
          editor,
          format,
          TEXT_ALIGN_TYPES.includes(format) ? "align" : "type"
        )
          ? " active"
          : "")
      }
      onClick={(event) => {
        event.preventDefault();
        toggleBlock(editor, format);
      }}
    >
      <FontAwesomeIcon icon={icon} />
    </div>
  );
};

const MarkButton = ({ format, icon }) => {
  const editor = useSlate();
  return (
    <div
      className={"button" + (isMarkActive(editor, format) ? " active" : "")}
      onClick={(event) => {
        event.preventDefault();
        toggleMark(editor, format);
      }}
    >
      <FontAwesomeIcon icon={icon} />
    </div>
  );
};

const ImageButton = () => {
  const editor = useSlate();
  return (
    <div
      className={"button"}
      onClick={(event) => {
        event.preventDefault();
        const url = window.prompt("Enter the URL of the image:");
        if (url) {
          if (isImageUrl(url)) {
            insertImage(editor, url);
          } else {
            alert("URL is not an image");
          }
        }
      }}
    >
      <FontAwesomeIcon icon={faImage} />
    </div>
  );
};

const TextGenButton = ({onAutoComplete}) => {
  const editor = useSlate();
  return (
    <div
      className={"button"}
      onClick={(event) => {
        event.preventDefault();
        onAutoComplete(editor.children).then((result) => {
          if (result instanceof Array) {
            for(let sentence of result){
              if (sentence instanceof Array){
                insertGenerateText(editor, sentence[0], sentence[1]);
              }
              else{
                insertGenerateText(editor, '', sentence);
              }                
            }            
          } else if (result instanceof String) {
            insertGenerateText(editor, '', result);
          } else {
            alert("API URL is not alive");
          }
        })
      }}
    >
      <FontAwesomeIcon icon={faRandom} />
    </div>
  );
};

const TextReGenButton = () => {
  const editor = useSlate();
  return (
    <div
      className={"button"}
      onClick={(event) => {
        event.preventDefault();        
        if (editor.children && editor.children.length>0) {          
          Transforms.removeNodes(editor, {at: [editor.children.length-1]});
        }
      }}
    >
      <FontAwesomeIcon icon={faMailReplyAll} />
    </div>
  );
};

export default TextEditor;
