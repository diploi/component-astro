// @ts-check
import { defineConfig, sessionDrivers } from 'astro/config';

import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
  output: 'server',
  // Diploi sets PORT to the port of the component's host in diploi.yaml
  server: { port: Number(process.env.PORT) || 4321 },
  // The adapter would keep sessions in node_modules, which is read-only in staging and production
  session: { driver: sessionDrivers.fsLite({ base: '/tmp/astro-sessions' }) },
  // Astro sees http behind the proxy, so form posts fail its origin check until it trusts the proxy's headers for this host
  security: {
    allowedDomains: process.env.APP_ENDPOINT ? [{ hostname: new URL(process.env.APP_ENDPOINT).hostname, protocol: 'https' }] : [],
  },
  adapter: node({
    mode: 'standalone',
  }),
});
