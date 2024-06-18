<template>
    <div>
        <el-container>
            <el-header>
                <span class="name">{{name}}</span>
            </el-header>
        </el-container>
    </div>
</template>
<script lang="ts" setup>
import {  computed } from "vue";
import { useCommonStore } from "@/store/module/common";
const useCommon = useCommonStore();
const name = computed<string>(()=>{
    return useCommon.getCommonWebsite.subtitle  as string
})
</script>
<style lang="scss" scoped>
.name{
    display: block;
    text-align: center;
    font-size:24px;
    // line-height: 60px;
    // height: 100%;
}
::v-deep(.el-header){
    border-bottom: 1px solid #e6e6e6;
    line-height: 60px;
    padding:0!important;
}
</style>