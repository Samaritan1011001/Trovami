export interface UserLocation {
  latitude: number;
  longitude: number;
}

export interface User {
  name: string;
  emailid: string;
  password?: string;
  locationShare: boolean;
  groupsIamin: string[];
  location: UserLocation | null;
}

export interface GroupMember {
  emailid: string;
  name: string;
  locationShare: boolean;
  location: UserLocation | null;
}

export interface Group {
  groupname: string;
  members: GroupMember[];
}

export interface AuthUser {
  emailid: string;
  name: string;
  firebaseKey: string;
}
