import { EdgeType } from "types/Edge";
import Story from "types/Story";
import Themes from "./themes";

export const DEFAULT_STORY: Story = {
  authorID: "",
  title: "",
  blurb: "",
  coverImage: "",
  dateCreated: new Date(),
  dateUpdated: new Date(),
  cursor: ">",
  replaceNode: true,
  errorMessages: ["抱歉！我不太理解你的回答,请重新回复。"],
  graph: {
    characters: [],
    variables: [],
    nodes: [],
    edges: [],
  },
  theme: Themes.Console,  
  settings: {
    defaultPath: EdgeType.BUTTON,
    ignoreCapitalisation: true,
    ignorePunctuation: true,
    ignoreArticles: true,
    useAI: false,
  },
};
