<template>
<div>
  <HelloWorld msg="子应用保活"></HelloWorld>
  <div class="content">
    <p>设置保活模式，切换应用时，子应用的路由和state都可以得到保留</p>
    <h3>1、改动实例的状态，切换到react，点击按钮再回来看看</h3>
    <p class="number-content">
      <el-button @click="count -= 1">-</el-button>
      <span class="number">{{ count }}</span>
      <el-button @click="count += 1">+</el-button>
      <el-button style="margin-left: 20px" @click="handleClick">跳转react17</el-button>
    </p>
  </div>
  </div>
</template>

<script lang="ts" setup>
// @ is an alias to /src
import { reactive, ref, watch, defineAsyncComponent,onMounted } from "vue";

const HelloWorld = defineAsyncComponent(() => import("@/components/HelloWorld.vue"));
const count = ref(10)
onMounted(()=>{
  (window as any)?.$wujie?.bus.$on("add", () => (count.value += 1));
})
const handleClick =()=> {
    (window as any)?.$wujie.props.jump("react17");
  }
</script>

<style scoped>
.number {
  display: inline-block;
  margin: 0 20px;
  width: 100px;
  text-align: center;
  font-size: 50px;
  font-weight: bold;
  color: #0239d0;
}

.number-content {
  text-align: center;
  display: flex;
  align-items: center;
  justify-content: center;
}

p {
  margin: 0;
  padding: 30px 0;
}
</style>
