import React from "react";
import { useNavigate } from "react-router-dom";

import { auth } from "utils/firebase";
import NavBar from "components/NavBar";
import ProfilePic from "components/ProfilePic";
import styles from "./Page.module.css";

const Page = ({ children, name = "" }) => {
  const navigate = useNavigate();
  let user = auth.currentUser;

  return (
    <div className={styles.page}>
      <NavBar pageName={name}>
        {user && <BarButton to="/library">我的创作库</BarButton>}
        <BarButton to="/learn">学习创作</BarButton>
        <BarButton to="/about">关于智序文坊</BarButton>
        {user && (
          <ProfilePic
            url={user.photoURL || ""}
            className={styles.profilePic}
            onClick={() => navigate("/settings")}
          />
        )}
      </NavBar>
      <div className={styles.content}> {children} </div>
    </div>
  );
};

export default Page;

const BarButton = ({ children, to }) => {
  const navigate = useNavigate();
  return (
    <button className={styles.barBtn} onClick={() => navigate(to)}>
      {children}
    </button>
  );
};
