<template>
  <div>
    <div id="nav">
      <router-link to="/home">首页</router-link> | <router-link to="/dialog">弹窗</router-link> |
      <router-link to="/location">路由</router-link> | <router-link to="/contact">通信</router-link> |
      <!-- |
      <router-link to="/state">状态</router-link> -->
    </div>
    <router-view />
  </div>
</template>
<script lang="ts" setup>
import { reactive, ref, watch, defineAsyncComponent } from "vue";
import { useRouter } from "vue-router";
const router = useRouter()
let currentPath = ref(router.currentRoute.value.path);
watch(
  () => router.currentRoute.value,
  (newVal, oldVal) => {
    console.log(newVal)
    // console.log(window.location)
    // currentPath.value = newVal.path;
    if((window as any).$wujie){
      (window as any).$wujie.bus.$emit("onViteCHildren",newVal.path);
    }
    
  }
);
</script>
