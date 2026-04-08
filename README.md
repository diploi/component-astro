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

### Development

Will run `npm install` when component is first initialized, and `npm run dev` when deployment is started.

### Production

Will build a production ready image. Image runs `npm install` & `npm build` when being created. Once the image runs, `npm start` is called.

#### ENV

Since Vite embeds environment variables during the build step, we provide two ways to manage ENV values in production builds:

1. For values that are not deployment-dependent, define them in `diploi.yaml` using the [static import syntax](https://docs.diploi.com/reference/diploi-yaml#env). The values are exposed to the `Dockerfile` as `ARG` variables.
2. For values that depend on a specific deployment (such as variables imported from other components in `diploi.yaml`, or configured in the **Options** tab), enable the **runtime build** option.

#### Runtime Build

When runtime build is enabled, `npm run build` is executed again when the container starts. This ensures that environment variables from the running deployment are correctly applied, and that any data loaded from other components can use the internal network.

To enable runtime build, set `__VITE_RUNTIME_BUILD` to `true` in `diploi.yaml`:

```yaml
- name: Astro
  identifier: astro
  package: https://github.com/diploi/component-astro#v1.0.0
  env:
    include:
      - name: __VITE_RUNTIME_BUILD
        value: true
```

## Link

- [Adding Astro to a project](https://docs.diploi.com/building/components/astro)
- [Astro docs](https://docs.astro.build/en/getting-started/)
