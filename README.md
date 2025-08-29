<img alt="icon" src=".diploi/icon.svg" width="32">

# Astro Component for Diploi

Launch a trial, no registration needed
https://diploi.com/component/astro

Uses the official [node](https://hub.docker.com/_/node) Docker image.

Has the [@astrojs/ node](https://docs.astro.build/en/guides/integrations-guide/node/) adapter preconfigured.

## Operation

### Getting started

1. Open your Astro Project’s dashboard:
   `https://console.diploi.com/<YOUR_USERNAME>/project/<YOUR_PROJECT_ID>`
2. Click **Create Deployment +**
3. Select **Production** as the deployment stage
4. Choose the **cluster size** depending on your needs
5. Pick the **source branch** you want to deploy, such as `main`
6. Customize any necessary **environment variables**
7. Click **Create Deployment +**

Prefer the full guide? Check https://diploi.com/blog/hosting_astro_apps

### Development

Will run `npm install` when component is first initialized, and `npm run dev` when deployment is started.

### Production

Will build a production ready image. Image runs `npm install` & `npm build` when being created. Once the image runs, `npm start` is called.
