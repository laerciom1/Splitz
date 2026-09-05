import { HttpsError, onCall } from "firebase-functions/v2/https";
import { getGroupConfig, updateGroupConfig } from "../splitz.repository";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import { validateGroupOwner } from "../validate-group-owner";

export const getSplitzGroupConfig = onCall(async (request) => {
    await validateAllowedUser(request);

    const groupId = request.data?.groupId;

    if (typeof groupId !== "string" || groupId.length === 0) {
        throw new HttpsError("invalid-argument", "groupId is required");
    }

    const config = await getGroupConfig(groupId);

    return { config };
});

export const updateSplitzGroupConfig = onCall(async (request) => {
    const uid = await validateAllowedUser(request);

    const groupId = request.data?.groupId;

    if (typeof groupId !== "string" || groupId.length === 0) {
        throw new HttpsError("invalid-argument", "groupId is required");
    }

    await validateGroupOwner(uid, groupId);

    const config = request.data?.config;

    if (typeof config !== "object" || config === null || Array.isArray(config)) {
        throw new HttpsError("invalid-argument", "config is required");
    }

    await updateGroupConfig(groupId, config as Record<string, unknown>);

    return { config };
});
