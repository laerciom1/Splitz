import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { validateAllowedUser } from "../../core/auth/validate-allowed-user";
import { splitwiseRequest } from "../splitwise.repository";

export const createSplitwiseExpense = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const expense = request.data?.expense;

    if (typeof expense !== "object" || expense === null || Array.isArray(expense)) {
        throw new HttpsError("invalid-argument", "invalid expense");
    }

    const response = await splitwiseRequest(uid, "/create_expense", {
        method: "POST",
        body: JSON.stringify(expense),
    });
    return await response.json();
});

export const getSplitwiseExpenses = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const groupId = request.data?.groupId;

    if (typeof groupId !== "string" || groupId.length === 0) {
        throw new HttpsError("invalid-argument", "invalid groupId");
    }

    const now = new Date();
    const monthsAgo = 2;
    const firstDayOfNMonthsAgo = new Date(now.getFullYear(), now.getMonth() - monthsAgo, 1);
    const queryParams = new URLSearchParams({
        group_id: groupId,
        dated_after: firstDayOfNMonthsAgo.toISOString(),
        limit: "200",
    });

    const response = await splitwiseRequest(uid, `/get_expenses?${queryParams.toString()}`);
    return await response.json();
});

export const getSplitwiseExportExpenses = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const groupId = request.data?.groupId;
    const year = request.data?.year;
    const month = request.data?.month;

    if (typeof groupId !== "string" || groupId.length === 0) {
        throw new HttpsError("invalid-argument", "invalid groupId");
    }

    if (!Number.isInteger(year)) {
        throw new HttpsError("invalid-argument", "invalid year");
    }

    if (!Number.isInteger(month) || month < 1 || month > 12) {
        throw new HttpsError("invalid-argument", "invalid month");
    }

    const firstDay = new Date(Date.UTC(year, month - 1, 1) - 1);
    const lastDay = new Date(Date.UTC(year, month, 1) - 1);
    const queryParams = new URLSearchParams({
        group_id: groupId,
        dated_after: firstDay.toISOString(),
        dated_before: lastDay.toISOString(),
        limit: "100",
    });

    const response = await splitwiseRequest(uid, `/get_expenses?${queryParams.toString()}`);
    return await response.json();
});

export const updateSplitwiseExpense = onCall(async (request) => {
    const uid = await validateAllowedUser(request);
    const expenseId = request.data?.expenseId;
    const expense = request.data?.expense;

    if (typeof expenseId !== "number" || !Number.isInteger(expenseId)) {
        throw new HttpsError("invalid-argument", "invalid expenseId");
    }

    if (typeof expense !== "object" || expense === null || Array.isArray(expense)) {
        throw new HttpsError("invalid-argument", "invalid expense");
    }

    const response = await splitwiseRequest(uid, `/update_expense/${expenseId}`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(expense),
    });
    return await response.json();
});

export const deleteSplitwiseExpense = onCall(async (request) => await handleSplitwiseDeleteOperation(request, false));

export const undeleteSplitwiseExpense = onCall(async (request) => await handleSplitwiseDeleteOperation(request, true));

async function handleSplitwiseDeleteOperation(request: CallableRequest, undelete: boolean): Promise<unknown> {
    const uid = await validateAllowedUser(request);
    const expenseId = request.data?.expenseId;

    if (typeof expenseId !== "number" || !Number.isInteger(expenseId)) {
        throw new HttpsError("invalid-argument", "invalid expenseId");
    }

    const response = await splitwiseRequest(uid, `/${undelete ? "un" : ""}delete_expense/${expenseId}`, {
        method: "POST",
    });
    return await response.json();
}
