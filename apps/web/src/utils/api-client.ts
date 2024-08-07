import ky from "ky";

export const api = ky.create({
  prefixUrl: `http://localhost:3000/api`,
  credentials: "include",
  retry: 0,
});
