import { setGlobalOptions } from "firebase-functions";

setGlobalOptions({ maxInstances: 10 });

// Splitwise functions
export * from "./splitwise/functions/auth.functions";
export * from "./splitwise/functions/categories.functions";
export * from "./splitwise/functions/expenses.functions";
export * from "./splitwise/functions/groups.functions";
export * from "./splitwise/functions/users.functions";

// Splitz functions
export * from "./splitz/functions/auth.functions";
export * from "./splitz/functions/groups.functions";

// GSheets functions
export * from "./gsheets/functions/sheets.functions";
