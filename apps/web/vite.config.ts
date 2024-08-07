import { fileURLToPath } from "node:url";
import { TanStackRouterVite } from "@tanstack/router-vite-plugin";
import react from "@vitejs/plugin-react-swc";
import { FontaineTransform } from "fontaine";
import million from "million/compiler";
import { defineConfig } from "vite";

const options = {
  fallbacks: ["ui-sans-serif", "Segoe UI", "Arial"],
  resolvePath: (id: string) => new URL("./public" + id, import.meta.url),
};

// https://vitejs.dev/config/
export default defineConfig((params) => {
  return {
    plugins: [
      million.vite({ auto: false }),
      react(),
      TanStackRouterVite(),
      FontaineTransform.vite(options),
    ],
    resolve: {
      alias: {
        "~": fileURLToPath(new URL("./src", import.meta.url)),
      },
    },
    server: {
      // proxy: {
      //   "/api": {
      //     target: parsedEnv.VITE_PUBLIC_API_URL,
      //     changeOrigin: true,
      //     secure: false,
      //   },
      // },
    },
  };
});
