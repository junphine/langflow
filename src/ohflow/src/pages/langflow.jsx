import React from "react";
import WujieReact from "wujie-react";
import hostMap from "../wujie-config/hostMap";

import { useNavigate, useLocation } from "react-router-dom";

export default function CollectionFlow() {

 // const navigation = useNavigate();
  const react17Url = hostMap("langflow");
  //const location = useLocation();
  //const path = location.pathname
  // 告诉子应用要跳转哪个路由
  //path && WujieReact.bus.$emit("react-router-change", path);
  const props = {
    jump: (name) => {
      //navigation(`/${name}`);
    },
  };
  return (
    // 保活模式，name相同则复用一个子应用实例，改变url无效，必须采用通信的方式告知路由变化
    <WujieReact
      width="100%"
      height="100%"
      name="langflow"
      url={react17Url}
      sync="false"
     // props={props}
    ></WujieReact>
  );
}
