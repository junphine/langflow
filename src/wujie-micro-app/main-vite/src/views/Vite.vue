<template>
  <!--单例模式，name相同则复用一个无界实例，改变url则子应用重新渲染实例到对应路由 -->
  <WujieVue
    width="100%"
    height="100%"
    name="vite"
    :alive="true"
    :url="viteUrl"
    :sync="true"
  ></WujieVue>
</template>

<script lang="ts" setup>
import hostMap from "@/wujie-config/hostMap";
import { reactive, ref, watch ,computed, onMounted} from "vue";
import { useRouter   } from "vue-router";
const router = useRouter();
const viteUrl = computed(()=>{
  return  hostMap("//localhost:8083/") +
        (router.currentRoute.value.params.path? `${router.currentRoute.value.params.path}` : "")
})
</script>

<style lang="scss" scoped></style>
