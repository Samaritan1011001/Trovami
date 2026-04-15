"use client";

import React, { createContext, useContext, useState, useEffect, useCallback } from "react";
import {
  ref,
  get,
  push,
  child,
} from "firebase/database";
import {
  GoogleAuthProvider,
  signInWithPopup,
  onAuthStateChanged,
} from "firebase/auth";
import { auth, database } from "./firebase";
import type { AuthUser, User } from "./types";

interface AuthContextType {
  user: AuthUser | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<string | null>;
  signUp: (name: string, email: string, password: string) => Promise<string | null>;
  signInWithGoogle: () => Promise<string | null>;
  signOut: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = sessionStorage.getItem("trovami_user");
    if (stored) {
      try {
        setUser(JSON.parse(stored));
      } catch {
        sessionStorage.removeItem("trovami_user");
      }
    }
    setLoading(false);
  }, []);

  const persistUser = useCallback((u: AuthUser | null) => {
    setUser(u);
    if (u) {
      sessionStorage.setItem("trovami_user", JSON.stringify(u));
    } else {
      sessionStorage.removeItem("trovami_user");
    }
  }, []);

  const signIn = useCallback(
    async (email: string, password: string): Promise<string | null> => {
      try {
        const usersRef = ref(database, "users");
        const snapshot = await get(usersRef);
        if (!snapshot.exists()) return "No users found";

        const users = snapshot.val() as Record<string, User>;
        for (const [key, u] of Object.entries(users)) {
          if (u.emailid === email && u.password === password) {
            persistUser({ emailid: u.emailid, name: u.name, firebaseKey: key });
            return null;
          }
        }
        return "Login EmailID or Password is incorrect. Please try again.";
      } catch (err) {
        return (err as Error).message;
      }
    },
    [persistUser]
  );

  const signUp = useCallback(
    async (name: string, email: string, password: string): Promise<string | null> => {
      try {
        const usersRef = ref(database, "users");
        const snapshot = await get(usersRef);

        if (snapshot.exists()) {
          const users = snapshot.val() as Record<string, User>;
          for (const u of Object.values(users)) {
            if (u.emailid === email) {
              return "User already exists";
            }
          }
        }

        const newUser: User = {
          name,
          emailid: email,
          password,
          locationShare: false,
          groupsIamin: [],
          location: null,
        };

        await push(usersRef, newUser);
        return null;
      } catch (err) {
        return (err as Error).message;
      }
    },
    []
  );

  const signInWithGoogleFn = useCallback(async (): Promise<string | null> => {
    try {
      const provider = new GoogleAuthProvider();
      const result = await signInWithPopup(auth, provider);
      const gUser = result.user;

      const usersRef = ref(database, "users");
      const snapshot = await get(usersRef);

      if (snapshot.exists()) {
        const users = snapshot.val() as Record<string, User>;
        for (const [key, u] of Object.entries(users)) {
          if (u.emailid === gUser.email) {
            persistUser({
              emailid: u.emailid,
              name: u.name,
              firebaseKey: key,
            });
            return null;
          }
        }
      }

      const newUser: User = {
        name: gUser.displayName || "Unknown",
        emailid: gUser.email || "",
        locationShare: false,
        groupsIamin: [],
        location: null,
      };

      const newRef = await push(usersRef, newUser);
      persistUser({
        emailid: newUser.emailid,
        name: newUser.name,
        firebaseKey: newRef.key!,
      });
      return null;
    } catch (err) {
      return (err as Error).message;
    }
  }, [persistUser]);

  const signOutFn = useCallback(() => {
    persistUser(null);
    auth.signOut().catch(() => {});
  }, [persistUser]);

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        signIn,
        signUp,
        signInWithGoogle: signInWithGoogleFn,
        signOut: signOutFn,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
