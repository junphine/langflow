<template>
  <div class="hello">
    <img alt="Vue logo" src="../../public/vite.svg" />
    <h2 class="vue-title">{{ msg }}</h2>
  </div>
</template>

<script lang="ts" setup>

withDefaults(
  defineProps<{ msg: (  string),  }>(),{
      msg: 'ss',
  }
);
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.hello {
  text-align: center;
  margin-bottom: 50px;
}
img {
  width: 200px;
  height: 200px;
}
.vue-title {
  color: var(--host-color);
}
</style>
