"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { useParams, useRouter } from "next/navigation";
import { ref, get, set, onValue } from "firebase/database";
import { database } from "@/lib/firebase";
import { useAuth } from "@/lib/auth-context";
import ProtectedRoute from "@/components/ProtectedRoute";
import type { Group, GroupMember } from "@/lib/types";
import Link from "next/link";

export default function GroupStatusPage() {
  return (
    <ProtectedRoute>
      <GroupStatusContent />
    </ProtectedRoute>
  );
}

function GroupStatusContent() {
  const params = useParams();
  const router = useRouter();
  const { user } = useAuth();
  const groupName = decodeURIComponent(params.groupName as string);

  const [members, setMembers] = useState<GroupMember[]>([]);
  const [groupKey, setGroupKey] = useState<string | null>(null);
  const [myMemberIndex, setMyMemberIndex] = useState<number>(-1);
  const [locationSharing, setLocationSharing] = useState(false);
  const [loading, setLoading] = useState(true);
  const watchIdRef = useRef<number | null>(null);

  // Find the group and set up real-time listener
  useEffect(() => {
    if (!user) return;

    const groupsRef = ref(database, "groups");
    const unsubscribe = onValue(groupsRef, (snapshot) => {
      if (!snapshot.exists()) {
        setLoading(false);
        return;
      }

      const groups = snapshot.val() as Record<string, Group>;
      for (const [key, g] of Object.entries(groups)) {
        if (g.groupname === groupName) {
          setGroupKey(key);
          setMembers(g.members || []);

          const myIndex = (g.members || []).findIndex(
            (m) => m.emailid === user.emailid
          );
          setMyMemberIndex(myIndex);
          if (myIndex >= 0) {
            setLocationSharing(g.members[myIndex].locationShare || false);
          }
          break;
        }
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, [user, groupName]);

  // Cleanup geolocation watch on unmount
  useEffect(() => {
    return () => {
      if (watchIdRef.current !== null) {
        navigator.geolocation.clearWatch(watchIdRef.current);
      }
    };
  }, []);

  const updateLocation = useCallback(
    async (position: GeolocationPosition) => {
      if (!user || !groupKey || myMemberIndex < 0) return;

      const location = {
        latitude: position.coords.latitude,
        longitude: position.coords.longitude,
      };

      // Update user's location in users collection
      await set(ref(database, `users/${user.firebaseKey}/location`), location);

      // Update member's location in the group
      await set(
        ref(database, `groups/${groupKey}/members/${myMemberIndex}/location`),
        location
      );
    },
    [user, groupKey, myMemberIndex]
  );

  const toggleLocationSharing = useCallback(async () => {
    if (!user || !groupKey || myMemberIndex < 0) return;

    const newValue = !locationSharing;

    if (newValue) {
      // Start sharing location
      try {
        const position = await new Promise<GeolocationPosition>(
          (resolve, reject) => {
            navigator.geolocation.getCurrentPosition(resolve, reject);
          }
        );
        await updateLocation(position);

        const watchId = navigator.geolocation.watchPosition(
          (pos) => updateLocation(pos),
          (err) => console.error("Geolocation error:", err),
          { enableHighAccuracy: true }
        );
        watchIdRef.current = watchId;
      } catch (err) {
        console.error("Failed to get location:", err);
        return;
      }
    } else {
      // Stop sharing location
      if (watchIdRef.current !== null) {
        navigator.geolocation.clearWatch(watchIdRef.current);
        watchIdRef.current = null;
      }
    }

    // Update locationShare flag in the group
    await set(
      ref(database, `groups/${groupKey}/members/${myMemberIndex}/locationShare`),
      newValue
    );

    setLocationSharing(newValue);
  }, [user, groupKey, myMemberIndex, locationSharing, updateLocation]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <p className="text-gray-400">Loading group...</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-900">
      <header className="bg-gray-800 shadow">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <button
            onClick={() => router.push("/groups")}
            className="text-gray-400 hover:text-white transition-colors"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
          </button>
          <h1 className="text-xl font-bold text-white">Group Status</h1>
          <Link
            href={`/groups/${encodeURIComponent(groupName)}/map`}
            className="text-blue-400 hover:text-blue-300 font-medium transition-colors"
          >
            Show Map
          </Link>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 py-6 space-y-6">
        {/* Warning */}
        <div className="bg-red-900/50 border border-red-700 rounded-lg p-4 text-center">
          <p className="text-red-300 font-bold text-lg">
            DO NOT USE REAL LOCATION
          </p>
        </div>

        {/* Location sharing toggle */}
        <div className="flex items-center justify-between bg-gray-800 rounded-lg px-4 py-4">
          <span className="text-white text-lg">Share Live Location:</span>
          <button
            onClick={toggleLocationSharing}
            className={`relative inline-flex h-7 w-12 items-center rounded-full transition-colors ${
              locationSharing ? "bg-blue-600" : "bg-gray-600"
            }`}
            role="switch"
            aria-checked={locationSharing}
          >
            <span
              className={`inline-block h-5 w-5 transform rounded-full bg-white transition-transform ${
                locationSharing ? "translate-x-6" : "translate-x-1"
              }`}
            />
          </button>
        </div>

        {/* Group name */}
        <div className="flex items-center gap-4 bg-gray-800 rounded-lg px-4 py-4 border-b border-gray-700">
          <div className="w-10 h-10 bg-gray-600 rounded-full flex items-center justify-center">
            <svg className="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
          </div>
          <span className="text-white text-lg font-bold">
            Group Name: {groupName}
          </span>
        </div>

        {/* Members */}
        <div>
          <h3 className="text-white text-lg mb-3 px-2">Members:</h3>
          <div className="space-y-2">
            {members.map((member, index) => (
              <div
                key={`${member.emailid}-${index}`}
                className="flex items-center gap-4 bg-gray-800 rounded-lg px-4 py-3"
              >
                <div className="w-8 h-8 bg-gray-600 rounded-full flex items-center justify-center">
                  <svg className="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </div>
                <span className="text-white text-lg">{member.name}</span>
                {member.locationShare && (
                  <span className="ml-auto text-green-400 text-sm flex items-center gap-1">
                    <span className="w-2 h-2 bg-green-400 rounded-full animate-pulse" />
                    Sharing
                  </span>
                )}
              </div>
            ))}
          </div>
        </div>
      </main>
    </div>
  );
}
