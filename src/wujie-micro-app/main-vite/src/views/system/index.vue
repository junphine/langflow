<template>
  <div>
    <div class="print-wrapper" ref="printId">
      <html>
        <body>
          <div>6666</div>
        </body>
      </html>
    </div>
    <iframe
      class="printf"
      ref="printf"
      src=""
      width="0"
      height="0"
      frameborder="0"
    ></iframe>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, onMounted, getCurrentInstance } from "vue";
import { useRouter } from "vue-router";
const printId = ref<any>(null);
const printf = ref<HTMLElement | null>(null);
const increment = () => {
  console.log();
  let printhtml = printId.value.innerHTML;
  // 生成并打印iframe
  let iframe: any = printf.value;
  iframe.contentDocument.open();
  iframe.contentDocument.write(printhtml);
  iframe.contentDocument.close();
  setTimeout(() => {
    iframe.contentWindow.print();
  }, 10);
};
onMounted(() => {
  increment();
});
</script>
<style lang="scss" scoped></style>
