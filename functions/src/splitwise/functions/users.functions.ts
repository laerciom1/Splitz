import { onCall } from "firebase-functions/v2/https";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import { splitwiseRequest } from "../splitwise.repository";

export const getSplitwiseCurrentUser = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const response = await splitwiseRequest(uid, "/get_current_user");
    return await response.json();
});
