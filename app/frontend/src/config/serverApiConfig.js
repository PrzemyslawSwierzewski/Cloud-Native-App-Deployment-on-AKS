console.log("process env REACT_APP_API_URL:", process.env.REACT_APP_API_URL);

// If REACT_APP_API_URL is set (e.g. in dev), use it.
// Otherwise default to '/api' so nginx will proxy correctly in AKS.
export const API_BASE_URL = process.env.REACT_APP_API_URL || "/api/";

export const ACCESS_TOKEN_NAME = "x-auth-token";
