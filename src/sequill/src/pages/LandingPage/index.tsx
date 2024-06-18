import React, { useCallback } from "react";
import { useParams,Link } from "react-router-dom";
import ReactFlow, { Background } from "reactflow";
import { faAccessibleIcon, faGoogle, faAmazon } from "@fortawesome/free-brands-svg-icons";

import { auth } from "utils/firebase";
import Button from "components/Button";

import "./LandingPage.css";
import Page from "../Page";

const LandingPage: React.FC = () => {
  const {user, password} = useParams();
  
  return (
    <Page>
      <div className="LandingPage">
        <div className="mainContent__landing">
          <div className="mainContent_wrapper">
            <h1 className="title__landing">
              Take your readers on an adventure.
            </h1>
            <div className="subtitle__landing">
            智序文坊是一个先进的交互式小说创作引擎，它基于高度可定制的节点的编辑器。
            无论您是否正在创建文字冒险还是视觉小说，你都可以用智序文坊把故事描绘出来，你将喜欢上用智序文坊写东西。.
            </div>
            <Link
              to={{
                  pathname: '/library',                  
              }}
              >
              <Button icon={faAccessibleIcon} onClick={async () => await auth.signInWithEmailAndPassword("admin@test.com","123456")} >
                Sign in with Email account
              </Button>
            </Link>
            <br/>
            <Button icon={faGoogle} onClick={async () => await auth.signInWithEmailAndPassword("junphine@126.com","332584185")} >
              Sign in with Google account
            </Button>
            <br/>
            <Button icon={faAmazon} onClick={async () => await auth.signInWithCredential({email:"demo@demo.com",password:"demo"})} >
              Sign in with Ignite console account
            </Button>
          </div>
        </div>
        <div className="secondaryContent__landing">
          <ReactFlow
            nodes={[
              {
                id: "landing1",
                type: "input",
                data: { label: "你在一个房间里醒来。" },
                position: { x: 0, y: 0 },
              },
              {
                id: "landing2",
                type: "default",
                data: { label: "周围一片漆黑。" },
                position: { x: -150, y: 200 },
              },
              {
                id: "landing3",
                type: "default",
                data: {
                  label:
                    "你什么也看不见!你失去平衡，跌倒在地。",
                },
                position: { x: 50, y: 400 },
              },
            ]}
            edges={[
              {
                id: "landing1",
                source: "landing1",
                target: "landing2",
                label: "看了看周围",
                data: { type: "button" },
              },
              {
                id: "landing2",
                source: "landing1",
                target: "landing3",
                label: "爬起来",
                data: { type: "button" },
              },
              {
                id: "landing3",
                source: "landing2",
                target: "landing3",
                label: "爬起来",
                data: { type: "button" },
              },
            ]}
            fitView
          >
            <Background color="#aaa" gap={16} />
          </ReactFlow>
        </div>
      </div>
    </Page>
  );
};

export default LandingPage;
