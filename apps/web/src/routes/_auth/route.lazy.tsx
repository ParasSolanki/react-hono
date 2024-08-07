import { createLazyFileRoute, Outlet } from "@tanstack/react-router";
import { Button } from "~/components/ui/button";
import { ScrollArea } from "~/components/ui/scroll-area";
import { Separator } from "~/components/ui/separator";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "~/components/ui/sheet";
import { cn } from "~/lib/utils";
import { format } from "date-fns";
import { motion } from "framer-motion";
import { MenuIcon } from "lucide-react";
import * as React from "react";

export const Route = createLazyFileRoute("/_auth")({
  component: AuthLayout,
});

function AuthLayout() {
  return (
    <main>
      <div className="md:flex">
        <Sidebar />
        <div className="relative mb-8 min-w-0 flex-grow space-y-4 px-4">
          <div className="flex items-center justify-between pt-3">
            <time className="text-muted-foreground">
              {format(new Date(), "PPPP")}
            </time>
          </div>
          <Outlet />
        </div>
      </div>
    </main>
  );
}

function Sidebar() {
  const [isOpen, setIsOpen] = React.useState(false);

  return (
    <div className="px-4 pt-4 md:px-0 md:pt-0">
      <motion.aside
        data-state={isOpen ? "open" : "closed"}
        initial={{
          width: 64,
        }}
        animate={{
          width: isOpen ? 240 : 64,
        }}
        className={cn(
          "group sticky top-0 hidden h-screen flex-shrink-0 space-y-4 overflow-x-hidden bg-muted py-2 md:block",
        )}
      >
        <ScrollArea className="h-full">
          <div className="group-data-[state='open']:px-2">
            <Button
              variant="ghost"
              className="flex w-full items-center justify-start px-2 group-data-[state='closed']:justify-center"
              onClick={() => setIsOpen((open) => !open)}
            >
              <MenuIcon className="size-5 flex-shrink-0 group-data-[state='open']:mr-2" />
              <div className="whitespace-pre group-data-[state='closed']:w-0 group-data-[state='closed']:overflow-visible group-data-[state='closed']:opacity-0">
                <p className="text-2xl">tetoy</p>
              </div>
            </Button>
          </div>
          <Separator className="my-2 dark:bg-primary-foreground" />
        </ScrollArea>
      </motion.aside>

      <Sheet>
        <SheetTrigger asChild>
          <Button
            type="button"
            variant="outline"
            size="icon"
            className="md:hidden"
          >
            <MenuIcon className="size-4" />
            <span className="sr-only">Open menu</span>
          </Button>
        </SheetTrigger>
        <SheetContent side="left" className="group w-[250px]">
          <SheetHeader className="mb-2">
            <SheetTitle className="text-xl">Tetoy</SheetTitle>
          </SheetHeader>
        </SheetContent>
      </Sheet>
    </div>
  );
}
