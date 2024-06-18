import { RouteRecordRaw } from "vue-router";
// import IndexPage from "@/pages/index/index.vue";
const Vite = () => import("@/views/Vite.vue");
const Home = () => import("@/views/home/index.vue");
const IndexPage = () => import("@/pages/index/index.vue");
const ViteSub = () => import("@/views/Vite-sub.vue");
const System = () => import(`@/views/system/index.vue`);
const Admin = () => import(`@/views/admin/user/index.vue`);
const Log = () => import(`@/views/admin/log/index.vue`);
const Role = () => import(`@/views/admin/role/index.vue`);
const Menu = () => import(`@/views/admin/menu/index.vue`);
const Dict = () => import(`@/views/admin/dict/index.vue`);
import { defineAsyncComponent } from "vue";
const _import2 = (name: string) => defineAsyncComponent(() => import(`@/views/${name}/index.vue`));

export const routes: Array<RouteRecordRaw> = [
  {
    path: "/login",
    name: "login",
    component: _import2("Login"),
  },
  {
    path: "/",
    redirect: "/login",
  },
  {
    path: "/home",
    name: "home",
    component: Home,
    meta: {},
  },
  {
    path: "/main",
    name: "子应用",
    redirect: "/home",
    component: IndexPage,
    meta: {},
    children: [
      {
        path: "/home",
        name: "home",
        component: Home,
        meta: {},
      },
      {
        path: "/vite",
        name: "vite",
        component: Vite,
        meta: {},
      },
      {
        path: "/vite-sub/:path",
        name: "vite-sub",
        component: ViteSub,
        meta: {},
        children: [],
      },
    ],
  },
  {
    path: "/system",
    name: "系统管理",
    component: IndexPage,
    meta: {},
    children: [
      {
        path: "/system",
        name: "system",
        // component: _import2("system"),
        component: System,
        // component:(()=> _import(`../views/system/index.vue`)),
        // component: (()=> _import(`@/views/system/index.vue`)),
        meta: {},
      },
      {
        path: "/admin",
        name: "admin",
        component: Admin,
        meta: {},
      },
      {
        path: "/log",
        name: "log",
        component: Log,
        meta: {},
      },
      {
        path: "/role",
        name: "role",
        component: Role,
        meta: {},
      },
      {
        path: "/menu",
        name: "menu",
        component: Menu,
        meta: {},
      },
      {
        path: "/dict",
        name: "dict",
        component: Dict,
        meta: {},
      }
    ],
  },
];
