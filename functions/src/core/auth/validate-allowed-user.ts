import { CallableRequest, HttpsError } from "firebase-functions/v2/https";
import * as rtdb from "../rtdb.repository";

export async function validateAllowedUser(request: CallableRequest): Promise<string> {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError("unauthenticated", "authentication is required");
    const isAllowed = await rtdb.isAllowedUser(uid);
    if (!isAllowed) throw new HttpsError("permission-denied", "user is not allowed to use splitz");
    return uid;
}
