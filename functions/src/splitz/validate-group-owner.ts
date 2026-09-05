import { HttpsError } from "firebase-functions/v2/https";
import * as rtdb from "../core/rtdb.repository";

export async function validateGroupOwner(uid: string, groupId: string): Promise<void> {
    const groupOwner = await rtdb.getGroupOwner(groupId);
    if (!groupOwner) throw new HttpsError("failed-precondition", "group owner is not configured");
    if (groupOwner !== uid) throw new HttpsError("permission-denied", "user is not the owner of the group");
}
