import { onCall } from "firebase-functions/v2/https";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";

export const checkIsAllowedUser = onCall(async (request) => {
    try {
        await validateAllowedUser(request);
        return { allowed: true };
    } catch {
        return { allowed: false };
    }
});
