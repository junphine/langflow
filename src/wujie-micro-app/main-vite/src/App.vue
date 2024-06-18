<template>
  <!-- <div v-if="!currentMeta.isAuth">
      <router-view   />
  </div>
  <IndexPage v-else ></IndexPage> -->
    <router-view   />
 
</template>

<script lang="ts" setup>
import IndexPage from '@/pages/index/index.vue'
import { reactive, ref , watch } from 'vue'
import { useRouter } from "vue-router";
const router = useRouter();
const active = ref(false)
// let currentMeta=ref(router.currentRoute.value.meta)

// watch(()=>router.currentRoute.value,(newVal,oldVal)=>{
//   currentMeta.value = newVal.meta
// })

</script>

<style>
html,
body {
  margin: 0;
  padding: 0;
  height: 100%;
}
#app{
  height: 100%;
}
iframe{
  border:none;
}

</style>
