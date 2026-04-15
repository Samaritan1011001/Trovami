import { initializeApp, getApps } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getDatabase } from "firebase/database";

const firebaseConfig = {
  apiKey: "AIzaSyD_qeqzyzsy9pJbWfi19zA5DQsygzRDWIA",
  authDomain: "trovami-bcd81.firebaseapp.com",
  databaseURL: "https://trovami-bcd81.firebaseio.com",
  projectId: "trovami-bcd81",
  storageBucket: "trovami-bcd81.appspot.com",
  messagingSenderId: "1099202702902",
  appId: "1:1099202702902:android:a7fa1916e557a6e1877297",
};

const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];

export const auth = getAuth(app);
export const database = getDatabase(app);
export default app;
