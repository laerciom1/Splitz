import { HttpsError, onCall } from "firebase-functions/v2/https";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import { splitwiseRequest } from "../splitwise.repository";

export const getSplitwiseGroups = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const response = await splitwiseRequest(uid, "/get_groups");
    return await response.json();
});

export const getSplitwiseGroup = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const groupId = request.data?.groupId;

    if (typeof groupId !== "string" || groupId.length === 0) {
        throw new HttpsError("invalid-argument", "invalid groupId");
    }

    const response = await splitwiseRequest(uid, `/get_group/${encodeURIComponent(groupId)}`);
    return await response.json();
});
