// For AccessTokenWrapper check https://calimero-network.github.io/developer-tools/SDK/client-sdk/client-ts-sdk/#2-token-management
import { AccessTokenWrapper } from "@calimero-network/calimero-client";
import { getNodeUrl } from "./utils/node";

function App() {
  return (
    <AccessTokenWrapper getNodeUrl={getNodeUrl}>
      <div>
        <h1>Hello BILLO!</h1>
      </div>
    </AccessTokenWrapper>
  );
}

export default App;
