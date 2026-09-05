import { onCall } from "firebase-functions/v2/https";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import { splitwiseRequest } from "../splitwise.repository";

export const getSplitwiseCategories = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const response = await splitwiseRequest(uid, "/get_categories");
    return await response.json();
});
