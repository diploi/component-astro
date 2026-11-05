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
  adapter: node({
    mode: 'standalone',
  }),
});
