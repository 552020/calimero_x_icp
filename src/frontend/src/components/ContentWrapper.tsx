import { Footer } from "@/components/Footer";
import CalimeroLogo from "@/assets/calimero-logo.svg";

interface ContentWrapperProps {
  children: React.ReactNode;
}

export const ContentWrapper = ({ children }: ContentWrapperProps) => {
  return (
    <div className="h-screen w-full bg-gray-900">
      {/* Navigation Bar */}
      <nav className="flex justify-between px-24 py-4">
        <div className="relative flex items-center gap-2">
          <img
            src={CalimeroLogo}
            alt="Calimero Admin Dashboard Logo"
            className="h-[43.3px] w-[160px]"
          />
          <h4 className="absolute left-12 top-8 text-xs text-white">
            Calimero Network
          </h4>
        </div>
      </nav>

      {/* Main Content */}
      <div className="flex h-[calc(100vh-75.3px)] items-center justify-center text-white">
        <div className="flex flex-col justify-center">{children}</div>
        <Footer />
      </div>
    </div>
  );
};

export default ContentWrapper;
