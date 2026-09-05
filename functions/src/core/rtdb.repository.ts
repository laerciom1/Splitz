import { initializeApp } from "firebase-admin/app";
import { getDatabase, ServerValue } from "firebase-admin/database";

initializeApp();

const database = getDatabase();

// Authorization to use Splitz
export async function isAllowedUser(uid: string): Promise<boolean> {
    const snapshot = await database.ref(`authorized_users/${uid}`).get();
    return snapshot.val() === true;
}

// Groups
const groupsPath = "groups";

// Private info of groups
export async function getSpreadsheetId(groupId: string, uid: string): Promise<string> {
    const snapshot = await database.ref(`${groupsPath}/${groupId}/private/gSheetIds/${uid}`).get();
    const spreadsheetId = snapshot.val();
    return spreadsheetId || "";
}

export async function getGroupOwner(groupId: string): Promise<string> {
    const snapshot = await database.ref(`${groupsPath}/${groupId}/private/owner`).get();
    return snapshot.val() || "";
}

// Public info of groups
export async function getGroupConfig(groupId: string): Promise<unknown | null> {
    const snapshot = await database.ref(`${groupsPath}/${groupId}`).get();
    if (!snapshot.exists()) return null;
    const value = snapshot.val() as Record<string, unknown>;
    const publicConfig = { ...value };
    delete publicConfig.private;
    return publicConfig;
}

export async function updateGroupConfig(groupId: string, config: Record<string, unknown>): Promise<void> {
    const publicConfig = { ...config };
    delete publicConfig.private;
    await database.ref(`${groupsPath}/${groupId}`).update(publicConfig);
}

// Splitwise credentials
const credentialsPath = "private/splitwise_credentials";

export async function saveSplitwiseCredentials(uid: string, credentials: SplitwiseTokenResponse): Promise<void> {
    await database.ref(`${credentialsPath}/${uid}`).set({
        accessToken: credentials.access_token,
        tokenType: credentials.token_type,
        updatedAt: ServerValue.TIMESTAMP,
    });
}

export async function deleteSplitwiseCredentials(uid: string): Promise<void> {
    await database.ref(`${credentialsPath}/${uid}`).remove();
}

export async function getSplitwiseAccessToken(uid: string): Promise<string> {
    const snapshot = await database.ref(`${credentialsPath}/${uid}/accessToken`).get();
    return snapshot.val() || "";
}

// Types
export interface SplitwiseTokenResponse {
    access_token?: string;
    token_type?: string;
}
