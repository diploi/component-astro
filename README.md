<img alt="icon" src=".diploi/icon.svg" width="32">

# Astro Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com/component/astro)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com/component/astro)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-astro)](https://diploi.com/component/astro)

Launch a trial, no account needed
https://diploi.com/component/astro

Uses the official [node](https://hub.docker.com/_/node) Docker image.

Has the [@astrojs/node](https://docs.astro.build/en/guides/integrations-guide/node/) adapter preconfigured in standalone mode. The project uses `output: 'server'`, so pages are rendered on demand, unless a page opts into [prerendering](https://docs.astro.build/en/guides/on-demand-rendering/) with `export const prerender = true`.

## Operation

### Getting started

1. In the Dashboard, click **Create Project +**
2. Under **Pick Components**, choose **Astro**

   You can add other frameworks from this page if you want to build a monorepo application, eg, Astro for the frontend and Hono for the backend.
3. In **Pick Add-ons**, select any databases or extra tools you need.
4. Choose **Create Repository** so Diploi generates a new GitHub repo for your project.
5. Click **Launch Stack**

Prefer the full guide? Check https://diploi.com/blog/hosting_astro_apps

### Package managers

Supports **Bun**, **Yarn**, **npm**, and **pnpm**. The package manager is auto-detected from your lockfile (`bun.lock`, `yarn.lock`, `package-lock.json`, or `pnpm-lock.yaml`). The install and build steps always use the detected package manager.

### Development

When the component is first initialized, dependencies are installed using the detected package manager. The development server is then started with:

```sh
npm run dev -- --host
```

This can be changed with the `containerCommands.developmentStart` field in `diploi.yaml`.

### Production

Builds a production-ready image. Image runs `npm install` & `npm run build` when being created, using the detected package manager. `astro build` writes the server to `dist/server/` and the files it serves to `dist/client/`.

Once the image runs, `npm start` is called, which starts the standalone server:

```sh
node ./dist/server/entry.mjs
```

This can be changed with the `containerCommands.productionStart` field in `diploi.yaml`.

#### ENV

Astro reads [environment variables](https://docs.astro.build/en/guides/environment-variables/) at two different times:

1. **When the app is built.** `import.meta.env` values, and [`astro:env`](https://docs.astro.build/en/guides/environment-variables/#type-safe-environment-variables) variables with `access: "public"`, are replaced during the build step. Only variables with the `PUBLIC_` prefix, or `context: "client"` in `astro:env`, reach code that runs in the browser, and everything they contain is visible there.
2. **When the server runs.** Server code, such as pages, endpoints and middleware, can read `process.env` and `astro:env` variables with `access: "secret"` while the server runs. Use these for secrets.

We provide two ways to manage the values that are replaced during the build step in production builds:

1. For values that are not deployment-dependent, define them in `diploi.yaml` using the [static import syntax](https://docs.diploi.com/reference/diploi-yaml#env). The values are exposed to the `Dockerfile` as `ARG` variables.
2. For values that depend on a specific deployment (such as variables imported from other components in `diploi.yaml`, or configured in the **Environment** tab), enable the **runtime build** option.

To use a variable from another component in your code, import it in `diploi.yaml`. For example, to call a backend with the `api` identifier from server code:

```yaml
- name: Astro
  identifier: astro
  package: https://github.com/diploi/component-astro#v7.3.5
  env:
    include:
      - api.APP_INTERNAL_ENDPOINT:API_URL
```

Server code can use the `<HOST>_INTERNAL_ENDPOINT` address of a component, which stays inside the deployment. Code that runs in the browser needs the public `<HOST>_ENDPOINT` address, imported under a name with the `PUBLIC_` prefix.

#### Runtime Build

When runtime build is enabled (which it is by default), `npm run build` is executed again when the container starts. This ensures that environment variables from the running deployment are correctly applied, and that any data loaded from other components by prerendered pages can use the internal network.

If your code only reads deployment-dependent values while the server runs, you can disable runtime build by setting `__VITE_RUNTIME_BUILD` to `false` in `diploi.yaml`:

```yaml
- name: Astro
  identifier: astro
  package: https://github.com/diploi/component-astro#v7.3.5
  env:
    include:
      - name: __VITE_RUNTIME_BUILD
        value: false
```

#### Ports

The component serves on port **4321** in both development and production. If you change it, update all of these so they stay in sync:

- `hosts[].port` in `diploi.yaml`
- `EXPOSE` and `ENV PORT` in `Dockerfile` and `Dockerfile.dev`. The production server reads `PORT`
- `server.port` in `astro.config.mjs`, which the development server uses. It is not set, because 4321 is the Astro default

## Links

- [Adding Astro to a project](https://docs.diploi.com/building/components/astro)
- [Astro documentation](https://docs.astro.build/)
- [@astrojs/node documentation](https://docs.astro.build/en/guides/integrations-guide/node/)
