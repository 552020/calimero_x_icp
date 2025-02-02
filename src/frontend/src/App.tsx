// For AccessTokenWrapper check https://calimero-network.github.io/developer-tools/SDK/client-sdk/client-ts-sdk/#2-token-management
import { AccessTokenWrapper } from "@calimero-network/calimero-client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import SetupPage from "./routes/SetupPage";
import AuthenticationPage from "./routes/LoginPage";
import HomePage from "./routes/HomePage";

import { getNodeUrl } from "./utils/node";

function App() {
  return (
    <AccessTokenWrapper getNodeUrl={getNodeUrl}>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<SetupPage />} />
          <Route path="/auth" element={<AuthenticationPage />} />
          <Route path="/home" element={<HomePage />} />
        </Routes>
      </BrowserRouter>
    </AccessTokenWrapper>
  );
}

export default App;
