import { Hono } from "hono";
import { logger } from "hono/logger";
import { serveStatic } from "@hono/node-server/serve-static";

export const app = new Hono();

app.use("*", logger());
app.basePath("/api").get("/ex", (c) => {
  return c.json({ ok: true });
});

app.get("*", serveStatic({ root: "./frontend/dist" }));
app.get("*", serveStatic({ path: "./frontend/dist/index.html" }));
