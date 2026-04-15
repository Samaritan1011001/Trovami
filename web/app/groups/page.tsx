"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { ref, onValue } from "firebase/database";
import { database } from "@/lib/firebase";
import { useAuth } from "@/lib/auth-context";
import ProtectedRoute from "@/components/ProtectedRoute";

export default function GroupsPage() {
  return (
    <ProtectedRoute>
      <GroupsContent />
    </ProtectedRoute>
  );
}

function GroupsContent() {
  const { user, signOut } = useAuth();
  const [groups, setGroups] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;

    const groupsRef = ref(database, `users/${user.firebaseKey}/groupsIamin`);
    const unsubscribe = onValue(groupsRef, (snapshot) => {
      if (snapshot.exists()) {
        const data = snapshot.val();
        const groupList = Array.isArray(data) ? data.filter(Boolean) : Object.values(data);
        setGroups(groupList as string[]);
      } else {
        setGroups([]);
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, [user]);

  return (
    <div className="min-h-screen bg-gray-900">
      <header className="bg-gray-800 shadow">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <h1 className="text-xl font-bold text-white">Groups</h1>
          <div className="flex items-center gap-3">
            <Link
              href="/groups/new"
              className="p-2 text-white hover:bg-gray-700 rounded-lg transition-colors"
              title="Create Group"
            >
              <svg className="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
            </Link>
            <button
              onClick={signOut}
              className="text-gray-400 hover:text-white text-sm transition-colors"
            >
              Sign Out
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 py-6">
        {loading ? (
          <p className="text-gray-400 text-center">Loading groups...</p>
        ) : groups.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-400 mb-4">You are not in any groups yet.</p>
            <Link
              href="/groups/new"
              className="inline-block bg-blue-600 hover:bg-blue-500 text-white px-6 py-2 rounded-lg transition-colors"
            >
              Create a Group
            </Link>
          </div>
        ) : (
          <ul className="space-y-2">
            {groups.map((groupName, index) => (
              <li key={`${groupName}-${index}`}>
                <Link
                  href={`/groups/${encodeURIComponent(groupName)}`}
                  className="flex items-center gap-4 p-4 bg-gray-800 hover:bg-gray-700 rounded-lg transition-colors"
                >
                  <div className="w-10 h-10 bg-gray-600 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  <span className="text-white text-lg">{groupName}</span>
                </Link>
              </li>
            ))}
          </ul>
        )}
      </main>
    </div>
  );
}
