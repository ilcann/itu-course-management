import AppHeader from "@/components/common/app-header"
import { Spotlight } from "@/components/ui/spotlight-new"
import { Outlet } from "react-router"

export default function MainLayout() {
  return (
    <>
        <AppHeader />
        {import.meta.env.VITE_DEMO_MODE === "true" && (
          <aside role="note" className="border-b bg-muted px-4 py-3 text-center text-sm">
            Portfolio demo · Örnek veriler · Salt okunur / Read-only
          </aside>
        )}
        <Outlet />
        <Spotlight />
    </>
  )
}