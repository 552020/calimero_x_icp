import { ClientLogin } from "@calimero-network/calimero-client";
import { useNavigate } from "react-router-dom";
import { getApplicationId, getNodeUrl } from "@/utils/node";
import {
  clearApplicationIdFromLocalStorage,
  clearNodeUrlFromLocalStorage,
} from "@/utils/storage";
import ContentWrapper from "@/components/ContentWrapper";

export default function LoginPage() {
  const navigate = useNavigate();
  function onSetupClick() {
    clearNodeUrlFromLocalStorage();
    clearApplicationIdFromLocalStorage();
    navigate("/");
  }
  return (
    <ContentWrapper>
      <div className="relative flex h-screen w-full bg-gray-900">
        <div className="flex h-full w-full flex-col items-center justify-center">
          <div className="rounded-lg bg-gray-800 p-8">
            <div className="flex items-center justify-center gap-3 px-14">
              <div className="text-2xl font-bold text-white">App template</div>
            </div>

            <ClientLogin
              getNodeUrl={getNodeUrl}
              getApplicationId={getApplicationId}
              sucessRedirect={() => navigate("/home")}
            />
          </div>

          <button
            onClick={onSetupClick}
            className="mt-4 cursor-pointer p-4 text-white hover:text-gray-300"
          >
            Return to setup
          </button>
        </div>
      </div>
    </ContentWrapper>
  );
}
