import { HttpsError } from "firebase-functions/v2/https";
import * as rtdb from "../core/rtdb.repository";
import { gsheetsServiceAccount, gsheetsSheetTitle } from "./config";

interface GoogleServiceAccount {
    client_email: string;
    private_key: string;
}

async function getSpreadsheetId(groupId: string, uid: string): Promise<string> {
    const spreadsheetId = await rtdb.getSpreadsheetId(groupId, uid);
    if (typeof spreadsheetId !== "string" || spreadsheetId.length === 0) {
        throw new HttpsError("failed-precondition", "gsheets spreadsheet is not configured");
    }
    return spreadsheetId;
}

async function getSheetsClient() {
    const credentials = gsheetsServiceAccount.value() as GoogleServiceAccount;

    const { google } = await import("googleapis");
    const auth = new google.auth.GoogleAuth({
        credentials,
        scopes: ["https://www.googleapis.com/auth/spreadsheets"],
    });

    return google.sheets({ version: "v4", auth });
}

export async function recreateGoogleSheet(uid: string, groupId: string, rows: string[][]): Promise<void> {
    const spreadsheetId = await getSpreadsheetId(groupId, uid);
    const sheets = await getSheetsClient();
    const spreadsheet = await sheets.spreadsheets.get({ spreadsheetId });

    const existingSheet = spreadsheet.data.sheets?.find((sheet) => sheet.properties?.title === gsheetsSheetTitle);

    if (existingSheet == null) {
        await sheets.spreadsheets.batchUpdate({
            spreadsheetId,
            requestBody: {
                requests: [
                    {
                        addSheet: {
                            properties: {
                                title: gsheetsSheetTitle,
                            },
                        },
                    },
                ],
            },
        });
    }

    await sheets.spreadsheets.values.clear({
        spreadsheetId,
        range: `'${gsheetsSheetTitle}'`,
    });

    await sheets.spreadsheets.values.update({
        spreadsheetId,
        range: `'${gsheetsSheetTitle}'!A1`,
        valueInputOption: "RAW",
        requestBody: {
            values: rows,
        },
    });
}
