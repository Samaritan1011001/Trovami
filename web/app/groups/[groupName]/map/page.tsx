"use client";

import { useState, useEffect } from "react";
import { useParams, useRouter } from "next/navigation";
import { ref, onValue } from "firebase/database";
import { database } from "@/lib/firebase";
import { useAuth } from "@/lib/auth-context";
import ProtectedRoute from "@/components/ProtectedRoute";
import type { Group, GroupMember } from "@/lib/types";
import dynamic from "next/dynamic";

const MapView = dynamic(() => import("@/components/MapView"), {
  ssr: false,
  loading: () => (
    <div className="flex items-center justify-center h-full">
      <p className="text-gray-400">Loading map...</p>
    </div>
  ),
});

export default function MapPage() {
  return (
    <ProtectedRoute>
      <MapContent />
    </ProtectedRoute>
  );
}

function MapContent() {
  const params = useParams();
  const router = useRouter();
  const { user } = useAuth();
  const groupName = decodeURIComponent(params.groupName as string);

  const [members, setMembers] = useState<GroupMember[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;

    const groupsRef = ref(database, "groups");
    const unsubscribe = onValue(groupsRef, (snapshot) => {
      if (!snapshot.exists()) {
        setLoading(false);
        return;
      }

      const groups = snapshot.val() as Record<string, Group>;
      for (const g of Object.values(groups)) {
        if (g.groupname === groupName) {
          setMembers(g.members || []);
          break;
        }
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, [user, groupName]);

  return (
    <div className="min-h-screen bg-gray-900 flex flex-col">
      <header className="bg-gray-800 shadow">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <button
            onClick={() => router.push(`/groups/${encodeURIComponent(groupName)}`)}
            className="text-gray-400 hover:text-white transition-colors"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
          </button>
          <h1 className="text-xl font-bold text-white">
            {groupName} - Map
          </h1>
          <div className="w-6" />
        </div>
      </header>

      <main className="flex-1 p-4">
        {loading ? (
          <div className="flex items-center justify-center h-96">
            <p className="text-gray-400">Loading map data...</p>
          </div>
        ) : (
          <div className="h-[calc(100vh-120px)]">
            <MapView members={members} />
          </div>
        )}
      </main>
    </div>
  );
}
