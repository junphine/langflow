<template>
  <div>
    <el-button @click="handleAdd">点击插入body</el-button>
    <el-button @click="handleRemove">点击删除body</el-button>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch, defineAsyncComponent,onMounted } from "vue";
const dialog = ref<any>(null)
const handleAdd = ()=> {
      fetch("./about");
      if (dialog.value) return;
      let ele = document.createElement("div");
      ele.innerHTML = "body中插入position为fixed元素";
      ele.style.cssText =
        "position: fixed; z-index: 100; top: 0; left: 0; width: 400px; text-align: center; height: 100px; line-height: 100px; background-color: #41b883";
      document.body.appendChild(ele);
      dialog.value = ele;
    }
 const   handleRemove= ()=>  {
      if (dialog.value) document.body.removeChild(dialog.value);
      dialog.value = null;
    }
</script>

<style lang="scss" scoped></style>
