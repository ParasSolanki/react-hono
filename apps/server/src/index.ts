import { serve } from "@hono/node-server";
import { app } from "./app";

const port = 3000;

serve(
  {
    fetch: app.fetch,
    port,
  },
  () => {
    const url =
      process.env.NODE_ENV === "production"
        ? process.env.RENDER_EXTERNAL_URL
        : `http://localhost:${port}`;
    console.log(`Server is running on port ${url}`);
  }
);
