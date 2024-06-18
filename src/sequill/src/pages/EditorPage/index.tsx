import React, { useCallback, useState, useEffect, useMemo } from "react";
import { useParams } from "react-router-dom";

import Page from "../Page";
import GraphEditor from "./GraphEditor";
import LoadingModal from "components/LoadingModal";
import { DEFAULT_STORY } from "constants/defaults";
import useUpdateEffect from "hooks/useUpdateEffect";
import { db } from "utils/firebase";
import downloadStory from "utils/compiler/downloadStory";
import Story from "types/Story";
import StoryModal from "./GraphEditor/Modals/StoryModal";
import HelpModal from "./GraphEditor/Modals/HelpModal";
import "./EditorPage.module.css";

const EditorPage: React.FC = () => {
  const { id } = useParams();  
  const [story, setStory] = useState<Story>(DEFAULT_STORY);
  const [storyLoaded, setStoryLoaded] = useState(false);
  const [timedSave, setTimedSave] = useState(null);
  const [settings, setSettings] = useState(false);
  const [help, setHelp] = useState(false);
  const [downloading, setDownloading] = useState(false);

  const [snapshot,setSnapshot] = useState(null);

  const snapshotStory = useMemo(()=>{
    return db.doc("stories/"+id).get().then((r)=>{
      setSnapshot(r);
      if (snapshot?.data()) {
        setStory({
          ...snapshot.data(),
          dateUpdated: new Date(),
          graph: JSON.parse(snapshot.data().graph),
        } as Story);
        setStoryLoaded(true);
      }
      return snapshot;
    })
  },[id]);

  useUpdateEffect(() => {
    if (snapshot?.data()) {
      setStory({
        ...snapshot.data(),
        dateUpdated: new Date(),
        graph: JSON.parse(snapshot.data().graph),
      } as Story);
      setStoryLoaded(true);
    }
  }, [snapshot]);

  const download = useCallback(async () => {
    setDownloading(true);
    await downloadStory(story);
    setDownloading(false);
  }, [story]);

  useEffect(() => {
    setTimedSave((oldTimedSave) => {
      clearTimeout(oldTimedSave);
      return setTimeout(async () => {
        if (snapshot) {
          try {            
            await snapshot.ref.update({
              ...story,
              coverImage:
                story.graph.nodes
                  .find((n) => n.type === "input")
                  ?.data.text.find((d) => d.type === "image")?.url || "",
              graph: JSON.stringify(story.graph),
            });
          } catch (e) {
            console.log(e);
          }
        }
      }, 1000);
    });
  }, [story, snapshot]);

  return (
    <Page name={story.title}>
      <div className={"EditorPage"} style={{ height: "100%", display: "flex" }}>
        {storyLoaded ? (
          <GraphEditor
            nodes={story.graph.nodes}
            edges={story.graph.edges}
            variables={story.graph.variables}
            settings={story.settings}
            story={story}
            applyChanges={(changes) =>
              setStory({ ...story, graph: { ...story.graph, ...changes } })
            }
            onSettings={() => setSettings(true)}
            onDownload={download}
            onHelp={() => setHelp(true)}
          >
            {settings && (
              <StoryModal
                story={story}
                onSave={(s) => {
                  setStory(s);
                  setSettings(false);
                }}
                onCancel={() => setSettings(false)}
              />
            )}
            {help && <HelpModal onClose={() => setHelp(false)} />}
            {downloading && <LoadingModal title="Downloading story" />}
          </GraphEditor>
        ) : (
          <LoadingModal title="Fetching your story" />
        )}
      </div>
    </Page>
  );
};

export default EditorPage;
