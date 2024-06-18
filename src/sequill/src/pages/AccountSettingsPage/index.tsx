import React, { useCallback, useState } from "react";
import { useNavigate } from "react-router-dom";
import { MockUser as User } from "firebase/auth";

import { faRightFromBracket } from "@fortawesome/free-solid-svg-icons";

import Page from "../Page";
import Button from "components/Button";
import ProfilePic from "components/ProfilePic";
import { auth } from "utils/firebase";
import styles from "./AccountSettingsPage.module.css";

interface Props {
  user: User;
}

const AccountSettingsPage: React.FC<Props> = ({ user }) => {
  if(!user)
    user = auth.currentUser;
  const [displayName, setDisplayName] = useState(user.displayName);
  const navigate = useNavigate();

  const logout = useCallback(() => {
    const goAhead = window.confirm("Are you sure you want to sign out?");
    if (goAhead) {
      auth.signOut();
      navigate("/", { replace: true });
    }
  }, [navigate]);

  return (
    <Page name={"Account Settings"}>
      <div className={styles.page}>
        <div className={styles.content}>
          <ProfilePic url={user.photoURL} className={styles.profilePic} />
          <div className={styles.fields}>
            <Field label="Pen name: ">
              <input
                value={displayName}
                onChange={(e) => setDisplayName(e.target.value)}
              ></input>
            </Field>
          </div>
          <Button
            className={styles.saveBtn}
            onClick={() => auth.updateUser(user.uid,{ displayName })}
          >
            保存修改
          </Button>
          <Button
            className={styles.signOutBtn}
            onClick={logout}
            icon={faRightFromBracket}
          >
            退出登录
          </Button>
        </div>
      </div>
    </Page>
  );
};

export default AccountSettingsPage;

const Field = ({ label, children }) => {
  return (
    <div className={styles.field}>
      <label htmlFor={label}>{label}</label>
      {children}
    </div>
  );
};
