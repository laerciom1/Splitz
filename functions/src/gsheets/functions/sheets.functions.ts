import { HttpsError, onCall } from "firebase-functions/v2/https";
import { recreateGoogleSheet as recreateGoogleSheetRepository } from "../gsheets.repository";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import { gsheetsServiceAccount } from "../config";

export const recreateGoogleSheet = onCall({ secrets: [gsheetsServiceAccount] }, async (request) => {
    const uid = await validateAllowedUser(request);

    const groupId = request.data?.groupId;
    if (typeof groupId !== "string" || groupId.length === 0) {
        throw new HttpsError("invalid-argument", "invalid groupId");
    }
    const rows = request.data?.rows;

    const isArrayOfStringArrays =
        Array.isArray(rows) &&
        rows.every((row) => Array.isArray(row) && row.every((value) => typeof value === "string"));
    if (!isArrayOfStringArrays) {
        throw new HttpsError("invalid-argument", "invalid rows");
    }

    await recreateGoogleSheetRepository(uid, groupId, rows as string[][]);
    return;
});
