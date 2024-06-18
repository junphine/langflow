
<template>
  <div class="hello">
    <!-- <el-form ref="form" :model="form" inline>
      <el-form-item label="虚拟列表-活动名称">
        <el-select
          v-model="form.value1"
          placeholder="请选择"
          @visible-change="handleVisibleChange"
          filterable
          v-select="{ ...selectAttrs, data: sourceData }"
        >
          <el-option
            v-for="item in optionsData"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          >
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="非虚拟列表-活动名称2">
        <el-select v-model="form.value2" placeholder="请选择">
          <el-option
            v-for="item in sourceData"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          >
          </el-option>
        </el-select>
      </el-form-item>
    </el-form> -->
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
const form = ref<any>({
  value1: "",
  value2: "",
});
const sourceData = ref<any>([]);
const optionsData = ref<any>([]);
const selectAttrs = ref<any>({
  viewHeight: 220, // 可视区域的高度
  rowHeight: 30, // 当前行的默认高度
  startIndex: 0,
  endIndex: 0,
  // callback: updateOptions,
  scrollView: null, // 滚动容器
  filterable: true,
});
const updateOptions = ({ startIndex, scrollView }) => {
  selectAttrs.value.startIndex = startIndex;
  selectAttrs.value.scrollView = scrollView;
  renderOptions();
};
const renderOptions = () => {
  const total = sourceData.value.length;
  // 可视区域的条数
  const limit = Math.ceil(
    selectAttrs.value.viewHeight / selectAttrs.value.rowHeight
  );
  // 设置末位索引
  let endIndex = Math.min(selectAttrs.value.startIndex + limit, total);
  selectAttrs.value.endIndex = endIndex;
  optionsData.value = sourceData.slice(
    selectAttrs.value.startIndex,
    selectAttrs.value.endIndex
  );
};
const handleVisibleChange = () => {
  // 当打开下拉框时，重置scrollView的paadingTop,避免白屏
  if (selectAttrs.value.scrollView) {
    selectAttrs.value.scrollView.style.paddingTop = "0px";
  }
  renderOptions();
};
var arr = new Array(100).fill(1);
    arr.forEach((v, index) => {
      sourceData.value.push({
        value: index,
        label: `test_${index}`,
      });
    });
</script>
<style lang="scss" scoped>
</style>
