import { defineJsonSecret } from "firebase-functions/params";

export const gsheetsServiceAccount = defineJsonSecret("GSHEETS_SERVICE_ACCOUNT");

export const gsheetsSheetTitle = "SplitzExport";
