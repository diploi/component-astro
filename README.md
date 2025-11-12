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

## Link

- [Adding Astro to a project](https://docs.diploi.com/building/components/astro)
- [Astro docs](https://docs.astro.build/en/getting-started/)
