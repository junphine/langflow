<template>
  <div>
    <el-menu
      :default-active="activeIndex"
      class="el-menu-vertical-demo"
      :collapse="isCollapse"
      router
      @open="handleOpen"
      @select="selectMenu"
    >
      <template v-for="(item, index) in menuArr">
        <el-menu-item :index="item.url" v-if="!item.children" :key="item.url">
          <el-icon><location /></el-icon>
          <template #title>{{ item.title }}</template>
        </el-menu-item>
        <el-sub-menu :index="item.url" v-if="item.children" :key="item.title">
          <template #title>
            <el-icon><location /></el-icon>
            <span>{{ item.title }}</span>
          </template>
          <el-menu-item-group>
            <el-menu-item :index="second.url" v-for="second in item.children" :key="second.url">{{
              second.title
            }}</el-menu-item>
          </el-menu-item-group>
        </el-sub-menu>
      </template>
    </el-menu>
  </div>
</template>
<script lang="ts" setup>
import { reactive, ref, watch, onMounted } from "vue";
import { routes } from "@/router/routes";
import WujieVue from "wujie-vue3";
import { useRouter } from "vue-router";
import { useCommonStore } from "@/store/module/common";
import {  ITag} from  "@/store/type-interface/common"

const useCommon = useCommonStore();
const router = useRouter();
const menuArr = ref([
  {
    url: "/home",
    title: "介绍",
  },
  {
    url: "vite",
    title: "vite子应用",
    children: [
      {
        url: "/vite-sub/home",
        title: "home",
      },
      {
        url: "/vite-sub/dialog",
        title: "dialog",
      },
      {
        url: "/vite-sub/location",
        title: "location",
      },
      {
        url: "/vite-sub/contact",
        title: "contact",
      },
    ],
  },
  {
    url: "2",
    title: "系统设置",
    children: [
      {
        url: "/system",
        title: "system",
      },
      {
        url: "/admin",
        title: "admin",
      },
      {
        url: "/log",
        title: "log",
      },
      {
        url: "/role",
        title: "role",
      },
      {
        url: "/menu",
        title: "menu",
      },
      {
        url: '/dict',
        title: 'dict'
      }
    ],
  },
]);
const menuArr2 = ref(routes);
const activeIndex = ref("/home");
const { bus } = WujieVue;
bus.$on("onViteCHildren", (val: any) => {
  // 跳转 主应用页面 路由-重新刷新 地址栏
  if (location.hash.indexOf("vite-sub") > -1) {
    router.push({
      path: "/" + location.hash.split("/")[1] + val,
    });
    let arr:any = []
    let tagList:any  = useCommon.getCommonTagList    ; // 获取 打开过的菜单
    menuArr.value.map((item)=>{
        if(item.url.indexOf('vite')>-1){
            item.children? arr = item.children : arr.push(item)
        }
    })
    let curRo = arr.filter((item)=>{
      return item.url.indexOf(val)>-1
    })
    if(curRo.length>0){
      useCommon.setCommonData("tagMenu",  curRo[0]); // 当前 菜单
      let hasTag =  tagList.filter((item)=> item.title ==curRo[0].title ) 
      if(hasTag.length==0){
        tagList.push(curRo[0])
        useCommon.setCommonData("tagList", tagList); // 打开过的菜单
      }
    }
  }
  // activeIndex.value = '/'+ location.hash.split('/')[1]+val // 页面加载时默认激活菜单的 index
});

withDefaults(defineProps<{ isCollapse: boolean }>(), {
  isCollapse: false,
});
watch(
  () => router.currentRoute.value,
  (newVal, oldVal) => {
    console.log(6666)
    activeIndex.value = newVal.path;
  }
);
onMounted(() => {
  /*
    页面刷新防止 菜单 activeIndex 丢失
  */
  let initHash = activeIndex.value.split("/");
  let curHash = location.hash.split("/");
  if (curHash[curHash.length - 1] != initHash[initHash.length - 1]) {
    router.push({
      path: location.hash.split("#")[1],
    });
    activeIndex.value = location.hash.split("#")[1];
  } else {
    // router.push({
    //   path: useCommon.getCommonTagMenu.url
    // });
  }
});
const handleOpen = (key: string, keyPath: string[]) => {
  // console.log(location);
  // console.log(key, keyPath);
};
// 选择菜单
const selectMenu = (index: string, indexPath: any, item: any, routeResult: any) => {
  let curItem;
  menuArr.value.map((item) => {
    if (item.url == indexPath[0]) {
      console.log(item);
      curItem = item.children ? item.children :[item] ;
    }
  });
  let curIndexPath = indexPath.length>1 ? indexPath[1] : indexPath[0]
  let data = curItem.filter((item) => item.url == curIndexPath);
  useCommon.setCommonData("tagMenu", data[0]); // 当前 菜单
  let tagList:any  = useCommon.getCommonTagList    ; // 获取 打开过的菜单
  let hasTag =  tagList.filter((item)=> item.url ==data[0].url ) 
  if(hasTag.length==0){
    tagList.push(data[0])
  }
  useCommon.setCommonData("tagList", tagList); // 打开过的菜单
};
</script>
<style scoped lang="scss">
::v-deep(.el-menu) {
  border: none;
}
</style>
