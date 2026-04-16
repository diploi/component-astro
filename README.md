<img alt="icon" src=".diploi/icon.svg" width="32">

# Astro Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com/component/astro)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com/component/astro)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-astro)](https://diploi.com/component/astro)

Launch a trial, no registration needed
https://diploi.com/component/astro

Uses the official [node](https://hub.docker.com/_/node) Docker image.

Has the [@astrojs/ node](https://docs.astro.build/en/guides/integrations-guide/node/) adapter preconfigured.

## Operation

### Getting started

1. **Sign up** at `https://console.diploi.com/` using your GitHub account.
2. In your dashboard, click **Create Project +**
3. Under **Pick Components**, choose **Astro**  
   If you want to expand your Astro website with other tools, like a backend framework, here you can add them.
4. In **Pick Add-ons**, select any databases or tools supported on Diploi.
5. In **Repository**, choose **Create Repository** which will generate a new GitHub repo for you.
6. Click **Launch Stack**

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

Builds a production-ready image. Dependencies are installed and `npm run build` is run during the image build, using the detected package manager. When the container starts, it runs:

```sh
npm start
```

This can be changed with the `containerCommands.productionStart` field in `diploi.yaml`.

#### ENV

Since Vite embeds environment variables during the build step, we provide two ways to manage ENV values in production builds:

1. For values that are not deployment-dependent, define them in `diploi.yaml` using the [static import syntax](https://docs.diploi.com/reference/diploi-yaml#env). The values are exposed to the `Dockerfile` as `ARG` variables.
2. For values that depend on a specific deployment (such as variables imported from other components in `diploi.yaml`, or configured in the **Options** tab), enable the **runtime build** option.

#### Runtime Build

When runtime build is enabled (which it is by default), `npm run build` is executed again when the container starts. This ensures that environment variables from the running deployment are correctly applied, and that any data loaded from other components can use the internal network.

To disable runtime build, set `__VITE_RUNTIME_BUILD` to `false` in `diploi.yaml`:

```yaml
- name: Astro
  identifier: astro
  package: https://github.com/diploi/component-astro#v1.0.0
  env:
    include:
      - name: __VITE_RUNTIME_BUILD
        value: false
```

## Link

- [Adding Astro to a project](https://docs.diploi.com/building/components/astro)
- [Astro docs](https://docs.astro.build/en/getting-started/)
