import { getNodeUrlFromLocalStorage } from "./storage";

export const getNodeUrl = (): string => {
  // Get from environment variables
  const nodeUrl = getNodeUrlFromLocalStorage();

  if (!nodeUrl) {
    const nodeUrlFromEnv = import.meta.env.VITE_NODE_URL;
    console.warn(
      "Node URL not found in localStorage, using environment variable",
    );
    return nodeUrlFromEnv;
  }

  return nodeUrl;
};
