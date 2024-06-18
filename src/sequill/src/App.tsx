import React,{useState} from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";

import { auth } from "./utils/firebase";
import LandingPage from "./pages/LandingPage";
import LearnPage from "./pages/LearnPage";
import AboutPage from "./pages/AboutPage";
import LibraryPage from "./pages/LibraryPage";
import EditorPage from "./pages/EditorPage";
import AccountSettingsPage from "./pages/AccountSettingsPage";
import LoadingPage from "./pages/LoadingPage";

const App: React.FC = () => {
  let loading = false;
  let [user, setUser] = useState(auth.currentUser);
  if (!user){    
    //- loading = true;    
    user = { displayName: '游客', photoURL:'/public/android-chrome-192x192.png', uid: "" };
    auth.onAuthStateChanged(
      (data) => { 
        setUser(data);
      },
      (error) => { 
        console.error(error); 
      }
    );
  }
  

  return loading ? (
    <LoadingPage />
  ) : (
    <BrowserRouter>
      <Routes>
        <Route
          path="/"
          element={user.uid ? <LibraryPage user={user} /> : <LandingPage />}
        />
        <Route
          path="/library"
          element={<LibraryPage user={user} />}
        />
        <Route path="/learn" element={<LearnPage />} />
        <Route path="/about" element={<AboutPage />} />
        {user.uid && (
          <>
            <Route
              path="/settings"
              element={<AccountSettingsPage user={user} />}
            />
            <Route path="/edit/:id" element={<EditorPage />} />
          </>
        )}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
