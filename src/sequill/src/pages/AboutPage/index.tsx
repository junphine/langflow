import React from "react";

import Page from "../Page";
import styles from "./AboutPage.module.css";

const AboutPage: React.FC = () => {
  return (
    <Page name={"About"}>
      <div className={styles.page}>
        <div className={styles.content}>
          <h2>智序文坊是什么?</h2>
          <p>
          智序文坊是一个先进的交互式小说创作引擎。它可以被用来创造复杂的文本冒险游戏:
          </p>
          <ul>
            <li>带分支故事情节</li>
            <li>不同的交互输入法</li>
            <li>可定义的状态变量</li>
            <li>可包含文字，图片，视频，语音</li>
            <li>......更多</li>
          </ul>
          <p>
          无需编写任何代码!它是高度可定制的，并且您甚至可以在导出故事后继续自定义它。
          </p>
          <h2>智序文坊如何工作?</h2>
          <p>
          智序文坊将你的故事编译成简单的HTML和JavaScript，这意味着你可以直接在浏览器中播放你的故事。它还有以下一些高级优势:
          </p>
          <ul>
            <li>
            您对您的故事及其生成的文件拥有完全的所有权。
            </li>
            <br></br>
            <li>
            你可以把你的故事放在自己的网站上，或者上传到像stream这样的平台上。
            </li>
            <br></br>
            <li>
            您可以使用自定义HTML、JS或CSS进一步定制故事的显示风格，交互行为。
            </li>
          </ul>
          <h2>开放逻辑，你怎么想就怎么做</h2>
          <p>
          是的!智序文坊是一个充满激情的大项目。请成为它的一个用户{" "}
            <a href="/registry">
              <b>注册用户</b>
            </a>
            . 我们也欢迎有想法的同学加入我们!
          </p>
          <p>
          如果你想报告一个bug或者请求一个新特性，你可以这样做{" "}
            <a href="/bugs">
              <b>提示与建议</b>
            </a>
            .
          </p>
        </div>
      </div>
    </Page>
  );
};

export default AboutPage;
