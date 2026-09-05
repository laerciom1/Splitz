import { defineSecret, defineString } from "firebase-functions/params";

export const swConsumerSecret = defineSecret("SW_CONSUMER_SECRET");
export const swConsumerKey = defineString("SW_CONSUMER_KEY");
export const swRedirectUrl = defineString("SW_REDIRECT_URL");
export const swTokenUrl = defineString("SW_TOKEN_URL");
export const swBaseUrl = defineString("SW_BASE_URL");
