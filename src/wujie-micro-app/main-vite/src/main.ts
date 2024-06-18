import { createApp } from "vue";
import router from './router'
import WujieVue from "wujie-vue3";
import hostMap from "./wujie-config/hostMap";
import credentialsFetch from "./wujie-config/fetch";
import lifecycles from "./wujie-config/lifecycle";
import plugins from "./wujie-config/plugin";
import "./style.css";
import App from "./App.vue";
import store from "./store";
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

const app = createApp(App);
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
const isProduction = process.env.NODE_ENV === "production";
const { setupApp,preloadApp,bus } = WujieVue;
bus.$on("onvitecall", (val:any)=>{
  console.log('onvitecall',val)
});
app.use(WujieVue).use(router).use(store).use(ElementPlus);

const degrade =
  window.localStorage.getItem("degrade") === "true" ||
  !window.Proxy ||
  !window.CustomElementRegistry;
const props = {
  jump: (name:any) => {
    router.push({ name });
  },
};
/*
  https://wujie-micro.github.io/doc/api/setupApp.html
*/
setupApp({
  name: "vite",
  url: hostMap("//localhost:5100/"),
  attrs: isProduction ? { src: hostMap("//localhost:5100/") } : {},

  // url: hostMap("//localhost:8000/"),
  // attrs: isProduction ? { src: hostMap("//localhost:8000/") } : {},
  
  exec: true,
  // alive: true,
  props,
  fetch: credentialsFetch,
  degrade,
  ...lifecycles,
});

if (window.localStorage.getItem("preload") !== "false") {
  preloadApp({
    name: "vite",
    url: hostMap("//localhost:5100/")
  });
}
app.mount("#app");
