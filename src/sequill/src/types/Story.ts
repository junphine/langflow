import Themes from "constants/themes";
import Edge, { EdgeType } from "./Edge";
import Node, { NodeType } from "./Node";
import Variable from "./Variable";
import { v4 as uuidv4 } from "uuid";

export interface StorySettings {
  defaultPath: EdgeType.TEXT | EdgeType.BUTTON;
  ignoreCapitalisation: boolean;
  ignorePunctuation: boolean;
  ignoreArticles: boolean;
  useAI: boolean;
}

export interface Character {
  id: string;
  name: string;
  introduction: string;
  age?: number | undefined;  
  gender: string;
  avatar: string;
}

interface Story {
  authorID: string;
  title: string;
  blurb: string;
  coverImage: string;
  dateCreated: Date;
  dateUpdated: Date;
  cursor: string;
  replaceNode: boolean;
  errorMessages: string[];
  theme: string;
  graph: {
    characters: Character[];
    variables: Variable[];
    nodes: Node[];
    edges: Edge[];
  };  
  settings: StorySettings;
}

export default Story;

export const newStory = (): Story => ({
  authorID: "",
  title: "Untitled Story",
  blurb: "",
  coverImage: "",
  dateCreated: new Date(),
  dateUpdated: new Date(),
  cursor: ">",
  replaceNode: true,
  errorMessages: ["I'm not sure what you mean."],
  theme: Themes.Console,
  graph: {
    characters: [],
    variables: [],
    nodes: [
      {
        id: "start",
        type: NodeType.START,
        data: {
          label: "Once upon a time...",
          picture: "",
          text: [
            { type: "paragraph", children: [{ text: "Once upon a time..." }] },
          ],
          pathType: EdgeType.TEXT,
          ignoreCapitalisation: true,
          ignorePunctuation: true,
          ignoreArticles: true,
        },
        position: {
          x: 0,
          y: 0,
        },
      },
    ],
    edges: [],
  },  
  settings: {
    defaultPath: EdgeType.TEXT,
    ignoreCapitalisation: true,
    ignorePunctuation: true,
    ignoreArticles: true,
    useAI: false,
  },
});

export const newCharacter = (): Character => ({
  id: uuidv4(),
  name: "",
  introduction: "",
  gender: "未知",
  avatar: "/images/speakers/me.jpg"
});
