<img alt="icon" src=".diploi/icon.svg" width="32">

# Astro Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com/component/astro)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com/component/astro)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-astro)](https://diploi.com/component/astro)

Launch a trial, no account needed
https://diploi.com/component/astro

Runs on Diploi's Node.js base image ([component-bases](https://github.com/diploi/component-bases)), which is built on the official [node](https://hub.docker.com/_/node) image.

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

Supports **Bun**, **Yarn**, **npm**, and **pnpm**. The package manager is the one `packageManager` in your `package.json` names, or else the one your lockfile belongs to (`bun.lock`, `pnpm-lock.yaml`, `yarn.lock` or `package-lock.json`). The install and build steps always use it, at the version `packageManager` names.

### Development

When the component is first initialized, dependencies are installed using the detected package manager. The development server is then started with:

```sh
npm run dev -- --host
```

This can be changed with the `containerCommands.developmentStart` field in `diploi.yaml`.

### Production

Staging and production build the deployment's commit on the deployment itself, with the deployment's environment variables: dependencies are installed with the detected package manager, then `npm run build` runs `astro build`, which writes the server to `dist/server/` and the files it serves to `dist/client/`. A commit is built once; a restart of the component reuses the build. A failed build leaves the previous version running, and its log is shown on the deployment page, where the commit can also be built again.

The component then runs `npm start`, which starts the standalone server:

```sh
node ./dist/server/entry.mjs
```

This can be changed with the `containerCommands.productionStart` field in `diploi.yaml`. See [Ports](#ports).

In staging and production the project folder is read-only while the server runs, so the server cannot write files next to its code. Keep data in a database or another component, and use `/tmp` for a file needed only during one request.

[Sessions](https://docs.astro.build/en/guides/sessions/) are kept in `/tmp` (`session.driver` in `astro.config.mjs`), so they last until the component's pod is replaced by a new version or a restart. To keep them longer, use a driver for a database such as Redis.

Astro only accepts a form post from the site's own address. `security.allowedDomains` in `astro.config.mjs` makes that work behind Diploi's proxy for the address in `APP_ENDPOINT`. If a form posts to a custom domain, add the domain to that list.

#### ENV

Astro reads [environment variables](https://docs.astro.build/en/guides/environment-variables/) at two different times:

1. **When the app is built.** `import.meta.env` values, and [`astro:env`](https://docs.astro.build/en/guides/environment-variables/#type-safe-environment-variables) variables with `access: "public"`, are replaced during the build step. Only variables with the `PUBLIC_` prefix, or `context: "client"` in `astro:env`, reach code that runs in the browser, and everything they contain is visible there. The build runs with every environment variable of the deployment, so such a variable can hold a deployment's value too, such as another component's public `<HOST>_ENDPOINT`, and prerendered pages can load data from other components over the internal network. A changed value builds the commit again.
2. **When the server runs.** Server code, such as pages, endpoints and middleware, can read `process.env` and `astro:env` variables with `access: "secret"` while the server runs. Use these for secrets.

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

#### System packages

The image has no packages beyond Node.js, Bun and pnpm. Install more with `initScript` in `diploi.yaml`, which runs as root when the component starts, or `preBuildScript`, which runs only before the build:

```yaml
- name: Astro
  identifier: astro
  package: https://github.com/diploi/component-astro#v7.3.5
  initScript: |
    apt-get update && apt-get install -y --no-install-recommends imagemagick
```

#### Ports

The component serves on port **4321** in every stage. To use another one, change the `port` of its `app` host in `diploi.yaml` (`hosts: [{ identifier: app, port: 8080 }]`). Diploi passes that port to the app as the `PORT` environment variable: the development server (`server.port` in `astro.config.mjs`) and the standalone server in staging and production listen on it.

A `containerCommands.productionStart` of your own should listen on `$PORT` too. Staging and production count a new version as ready once it accepts connections on that port: one that listens elsewhere never becomes ready, and the previous version keeps serving.

## Links

- [Adding Astro to a project](https://docs.diploi.com/building/components/astro)
- [Astro documentation](https://docs.astro.build/)
- [@astrojs/node documentation](https://docs.astro.build/en/guides/integrations-guide/node/)
