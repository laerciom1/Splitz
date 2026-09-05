import { HttpsError } from "firebase-functions/v2/https";
import * as rtdb from "../core/rtdb.repository";
import { swConsumerKey, swConsumerSecret, swRedirectUrl, swTokenUrl } from "./config";

export async function exchangeAuthorizationCode(uid: string, code: string): Promise<void> {
    const response = await fetch(swTokenUrl.value(), {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
            grant_type: "authorization_code",
            code,
            client_id: swConsumerKey.value(),
            client_secret: swConsumerSecret.value(),
            redirect_uri: swRedirectUrl.value(),
        }),
    });

    if (!response.ok) {
        console.error("Splitwise token exchange failed.", {
            status: response.status,
        });

        throw new HttpsError("internal", "could not authenticate with splitwise");
    }

    const tokenResponse = (await response.json()) as rtdb.SplitwiseTokenResponse;

    const accessToken = tokenResponse.access_token;

    if (typeof accessToken !== "string" || accessToken.length === 0) {
        throw new HttpsError("internal", "splitwise returned an invalid access token");
    }

    await saveSplitwiseCredentials(uid, tokenResponse);
}

export async function saveSplitwiseCredentials(uid: string, credentials: rtdb.SplitwiseTokenResponse): Promise<void> {
    await rtdb.saveSplitwiseCredentials(uid, credentials);
}

export async function deleteSplitwiseCredentials(uid: string): Promise<void> {
    await rtdb.deleteSplitwiseCredentials(uid);
}

export async function getSplitwiseAccessToken(uid: string): Promise<string> {
    const accessToken = await rtdb.getSplitwiseAccessToken(uid);

    if (typeof accessToken !== "string" || accessToken.length === 0) {
        throw new HttpsError("failed-precondition", "splitz dont have a valid access token for this user");
    }

    return accessToken;
}
