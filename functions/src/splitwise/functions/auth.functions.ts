import { HttpsError, onCall } from "firebase-functions/v2/https";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import {
    deleteSplitwiseCredentials,
    exchangeAuthorizationCode,
    getSplitwiseAccessToken,
} from "../splitwise-auth.repository";
import { swConsumerSecret } from "../config";

export const exchangeSplitwiseAuthorizationCode = onCall({ secrets: [swConsumerSecret] }, async (request) => {
    const uid = await validateAllowedUser(request);
    const code = request.data?.code;
    if (typeof code !== "string" || code.length === 0) {
        throw new HttpsError("invalid-argument", "invalid code");
    }
    await exchangeAuthorizationCode(uid, code);

    return { success: true };
});

export const checkSplitwiseSession = onCall(async (request) => {
    try {
        const uid = await validateAllowedUser(request);
        await getSplitwiseAccessToken(uid);
        return { signed_in: true };
    } catch {
        return { signed_in: false };
    }
});

export const deleteSplitwiseSession = onCall(async (request) => {
    try {
        const uid = await validateAllowedUser(request);
        await deleteSplitwiseCredentials(uid);
        return;
    } catch {
        throw new HttpsError("internal", "could not delete splitwise session");
    }
});
