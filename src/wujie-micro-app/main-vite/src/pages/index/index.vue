<template>
  <el-container class="main-container">
    <el-aside :class="collapse ? 'noaside' : 'aside'">
      <!-- <Suspense> -->
        <Header></Header>
      <!-- </Suspense> -->
      <NavLeft :isCollapse="collapse"></NavLeft>
    </el-aside>
    <el-main>
      <el-header ref="elheader">
        <el-button @click="showCollapse">
          <el-icon color="#409EFC" class="no-inherit">
            <Expand v-if="collapse" />
            <Fold v-else />
          </el-icon>
        </el-button>
      </el-header>
      <div class="tag" ref="tag">
        <Tag  ></Tag>
      </div>
      <div class="mian-router" :style="{height:mianHeight}">
         <router-view :key="currentPath" />
      </div>
    </el-main>
  </el-container>
</template>
<script lang="ts" setup>
import { reactive, ref, watch, defineAsyncComponent,onMounted } from "vue";
import { useRouter } from "vue-router";
import { useCommonStore } from "@/store/module/common";
const useCommon = useCommonStore();
const NavLeft = defineAsyncComponent(() => import("@/components/nav-left/main.vue"));
const Tag = defineAsyncComponent(()=>import("@/pages/index/tag.vue"))
const Header = defineAsyncComponent({
  loader: () => import("@/components/header/main.vue"),
  // 加载异步组件时使用的组件
  // loadingComponent: LoadingComponent,
  // // 加载失败时使用的组件
  // errorComponent: ErrorComponent,
  // 在显示加载组件之前延迟。默认值：200ms。
  delay: 1000,
  // 超过给定时间，则会显示错误组件。默认值：Infinity。
  timeout: 3000,
});

const router = useRouter();
const active = ref(false);
const collapse = ref(false);
let currentPath = ref(router.currentRoute.value.path);
const tag = ref<null|HTMLElement|any>(null)
const elheader = ref<null|HTMLElement|any>(null)
const mianHeight = ref('')
onMounted(()=>{
  setTimeout(()=>{
    let tagH = tag.value.offsetHeight  as unknown as number
    let elh  = elheader.value.$el.offsetHeight  as unknown as number
    console.log(tagH, elh )
    mianHeight.value = `calc( 100vh - ${elh+tagH+5+"px"} )`
  },500)
 
})
watch(
  () => router.currentRoute.value,
  (newVal, oldVal) => {
    currentPath.value = newVal.path;
  }
);
const showCollapse = () => {
  collapse.value = !collapse.value;
};
const close = () => {
  if (active.value) active.value = false;
};
</script>
<style scoped lang="scss" >
::v-deep(.el-main) {
  padding: 0 !important;
  border-left: 1px solid #e6e6e6;
}
::v-deep(.el-aside) {
  //  border-right: 1px solid #e6e6e6;
}
::v-deep(.el-header){
  line-height: 60px;
   border-bottom: 1px solid #e6e6e6;
}
.main-container {
  height: 100% !important;
 
}
.noaside {
  width: auto;
}
.aside {
  width: 200px;
}
.mian-router{
  padding: 0 10px;
  // background: var(--color);
}
</style>
