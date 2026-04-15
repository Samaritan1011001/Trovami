"use client";

import { MapContainer, TileLayer, Marker, Popup, useMap } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import type { GroupMember } from "@/lib/types";
import { useEffect } from "react";

// Fix default marker icons for Leaflet in Next.js
const defaultIcon = L.icon({
  iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
  iconRetinaUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
  shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

L.Marker.prototype.options.icon = defaultIcon;

interface MapViewProps {
  members: GroupMember[];
}

function FitBounds({ members }: { members: GroupMember[] }) {
  const map = useMap();

  useEffect(() => {
    const sharingMembers = members.filter((m) => m.locationShare && m.location);
    if (sharingMembers.length > 0) {
      const bounds = L.latLngBounds(
        sharingMembers.map((m) => [m.location!.latitude, m.location!.longitude] as [number, number])
      );
      map.fitBounds(bounds, { padding: [50, 50], maxZoom: 15 });
    }
  }, [members, map]);

  return null;
}

export default function MapView({ members }: MapViewProps) {
  const sharingMembers = members.filter((m) => m.locationShare && m.location);

  if (sharingMembers.length === 0) {
    return (
      <div className="flex items-center justify-center h-full bg-gray-800 rounded-lg">
        <p className="text-gray-400 text-lg">
          No live location sharing users. Go back and try again.
        </p>
      </div>
    );
  }

  const center: [number, number] = [
    sharingMembers[0].location!.latitude,
    sharingMembers[0].location!.longitude,
  ];

  return (
    <MapContainer
      center={center}
      zoom={14}
      className="h-full w-full rounded-lg"
      style={{ minHeight: "400px" }}
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <FitBounds members={members} />
      {sharingMembers.map((member, index) => (
        <Marker
          key={`${member.emailid}-${index}`}
          position={[member.location!.latitude, member.location!.longitude]}
        >
          <Popup>
            <strong>{member.name}</strong>
            <br />
            {member.emailid}
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  );
}
