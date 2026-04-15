"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { ref, get, push, set } from "firebase/database";
import { database } from "@/lib/firebase";
import { useAuth } from "@/lib/auth-context";
import ProtectedRoute from "@/components/ProtectedRoute";
import type { User } from "@/lib/types";

interface UserWithKey {
  key: string;
  name: string;
  emailid: string;
}

export default function NewGroupPage() {
  return (
    <ProtectedRoute>
      <NewGroupContent />
    </ProtectedRoute>
  );
}

function NewGroupContent() {
  const { user } = useAuth();
  const router = useRouter();
  const [groupName, setGroupName] = useState("");
  const [allUsers, setAllUsers] = useState<UserWithKey[]>([]);
  const [selectedMembers, setSelectedMembers] = useState<UserWithKey[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchUsers() {
      const usersRef = ref(database, "users");
      const snapshot = await get(usersRef);
      if (snapshot.exists()) {
        const data = snapshot.val() as Record<string, User>;
        const userList: UserWithKey[] = [];
        for (const [key, u] of Object.entries(data)) {
          if (u.emailid !== user?.emailid) {
            userList.push({ key, name: u.name, emailid: u.emailid });
          }
        }
        setAllUsers(userList);
      }
      setLoading(false);
    }
    fetchUsers();
  }, [user]);

  const toggleMember = (u: UserWithKey) => {
    setSelectedMembers((prev) => {
      const exists = prev.find((m) => m.emailid === u.emailid);
      if (exists) {
        return prev.filter((m) => m.emailid !== u.emailid);
      }
      return [...prev, u];
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!groupName.trim()) {
      setError("Group name must not be empty");
      return;
    }
    if (!user) return;

    setSubmitting(true);
    setError(null);

    try {
      const members = [
        ...selectedMembers.map((m) => ({
          emailid: m.emailid,
          name: m.name,
          locationShare: false,
          location: null,
        })),
        {
          emailid: user.emailid,
          name: user.name,
          locationShare: false,
          location: null,
        },
      ];

      // Create the group
      const groupsRef = ref(database, "groups");
      await push(groupsRef, {
        groupname: groupName,
        members,
      });

      // Update groupsIamin for each member (including current user)
      const usersRef = ref(database, "users");
      const usersSnapshot = await get(usersRef);
      if (usersSnapshot.exists()) {
        const usersData = usersSnapshot.val() as Record<string, User>;
        const allMemberEmails = [...selectedMembers.map((m) => m.emailid), user.emailid];

        for (const [key, u] of Object.entries(usersData)) {
          if (allMemberEmails.includes(u.emailid)) {
            const currentGroups = u.groupsIamin || [];
            const updatedGroups = [...currentGroups, groupName];
            await set(ref(database, `users/${key}/groupsIamin`), updatedGroups);
          }
        }
      }

      router.push("/groups");
    } catch (err) {
      setError((err as Error).message);
      setSubmitting(false);
    }
  };

  const availableUsers = allUsers.filter(
    (u) => !selectedMembers.find((m) => m.emailid === u.emailid)
  );

  return (
    <div className="min-h-screen bg-gray-900">
      <header className="bg-gray-800 shadow">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <h1 className="text-xl font-bold text-white">Add a Group</h1>
          <button
            onClick={() => router.push("/groups")}
            className="text-gray-400 hover:text-white transition-colors"
          >
            Cancel
          </button>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 py-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <div className="flex items-center bg-gray-800 rounded-lg px-4 py-3">
              <svg className="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <input
                type="text"
                placeholder="Group Name"
                value={groupName}
                onChange={(e) => setGroupName(e.target.value)}
                className="bg-transparent text-white placeholder-gray-400 w-full outline-none"
                required
              />
            </div>
          </div>

          {/* Selected members */}
          {selectedMembers.length > 0 && (
            <div>
              <h3 className="text-gray-400 text-sm mb-2">Selected Members:</h3>
              <div className="space-y-2">
                {selectedMembers.map((m) => (
                  <div
                    key={m.emailid}
                    className="flex items-center justify-between bg-gray-800 rounded-lg px-4 py-3"
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 bg-gray-600 rounded-full flex items-center justify-center">
                        <svg className="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                      </div>
                      <span className="text-white">{m.name}</span>
                    </div>
                    <button
                      type="button"
                      onClick={() => toggleMember(m)}
                      className="text-red-400 hover:text-red-300 text-sm"
                    >
                      Remove
                    </button>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Add members */}
          <div>
            <h3 className="text-gray-400 text-sm mb-2">Add Members:</h3>
            {loading ? (
              <p className="text-gray-500">Loading users...</p>
            ) : availableUsers.length === 0 ? (
              <p className="text-gray-500">No more users to add.</p>
            ) : (
              <div className="space-y-1 max-h-64 overflow-y-auto">
                {availableUsers.map((u) => (
                  <button
                    key={u.emailid}
                    type="button"
                    onClick={() => toggleMember(u)}
                    className="w-full flex items-center gap-3 px-4 py-3 bg-gray-800 hover:bg-gray-700 rounded-lg transition-colors text-left"
                  >
                    <div className="w-8 h-8 bg-gray-600 rounded-full flex items-center justify-center">
                      <svg className="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                      </svg>
                    </div>
                    <span className="text-white">{u.name}</span>
                    <span className="text-gray-500 text-sm ml-auto">{u.emailid}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {error && (
            <p className="text-red-400 text-sm text-center">{error}</p>
          )}

          <div className="flex gap-4 justify-center pt-4">
            <button
              type="submit"
              disabled={submitting}
              className="px-8 py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-lg font-medium transition-colors disabled:opacity-50"
            >
              {submitting ? "Creating..." : "Create Group"}
            </button>
            <button
              type="button"
              onClick={() => router.push("/groups")}
              className="px-8 py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-medium transition-colors"
            >
              Cancel
            </button>
          </div>
        </form>
      </main>
    </div>
  );
}
