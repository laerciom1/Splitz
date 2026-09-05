import { HttpsError } from "firebase-functions/v2/https";
import { swBaseUrl } from "./config";
import { getSplitwiseAccessToken } from "./splitwise-auth.repository";

export async function splitwiseRequest(uid: string, path: string, options?: RequestInit): Promise<Response> {
    const accessToken = await getSplitwiseAccessToken(uid);

    const response = await fetch(`${swBaseUrl.value()}${path}`, {
        ...options,
        headers: {
            ...options?.headers,
            Authorization: `Bearer ${accessToken}`,
            "Content-Type": "application/json",
        },
    });

    if (!response.ok) {
        console.error("splitwise request failed.", {
            path,
            status: response.status,
        });

        throw new HttpsError("internal", "splitwise request failed");
    }

    return response;
}
