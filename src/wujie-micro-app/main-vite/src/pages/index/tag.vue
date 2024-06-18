<template>
  <div class="tagbox">
    <el-row>
        <el-col :span="22">
            <div class="tag-box">
                  <el-tabs
                        v-model.string="activeTag"
                        type="card"
                        class="demo-tabs"
                        closable
                        @tab-remove="removeTab"
                        @tab-click="handleClick"
                    >
                        <el-tab-pane
                        v-for="item in dynamicTags"
                        :key="item.title"
                        :label="item.title"
                        :name="item.title"
                        >
                        <!-- {{ item.title }} -->
                        </el-tab-pane>
                    </el-tabs>
            </div>
            
        </el-col>
        <el-col :span="2">
            <el-dropdown>
                <span class="el-dropdown-link">
                更多
                <el-icon class="el-icon--right">
                    <arrow-down />
                </el-icon>
                </span>
                <template #dropdown>
                <el-dropdown-menu>
                    <el-dropdown-item @click.native="closeOthersTags">关闭其他</el-dropdown-item>
                    <el-dropdown-item @click.native="closeAllTags">关闭全部</el-dropdown-item>
                </el-dropdown-menu>
                </template>
            </el-dropdown>
        </el-col>
    </el-row>
    
  </div>
</template>
<script lang="ts" setup>
import { reactive, ref, watch, onMounted,computed } from "vue";
import { routes } from "@/router/routes";
import WujieVue from "wujie-vue3";
import { useRouter } from "vue-router";
import { useCommonStore } from "@/store/module/common";
import {  ITag ,ICommon ,ITagList} from  "@/store/type-interface/common"


const useCommon = useCommonStore();
const router = useRouter();

const curPath = computed<ITag>(()=>{
    return useCommon.getCommonTagMenu as ITag
})
const dynamicTags =  computed<ITag[]>(()=>{
    return  useCommon.getCommonTagList   as unknown as ITag[]
}) 
const activeTag = computed<string>(()=>{
    return useCommon.getCommonTagMenu.title  as string
})
onMounted(()=>{
})
const handleClose = (tag)=>{
    let data =  dynamicTags.value.splice(dynamicTags.value.indexOf(tag), 1)
    useCommon.setCommonData("tagList", dynamicTags.value  as ITag); // 打开过的菜单
    if(dynamicTags.value.length>0){
        useCommon.setCommonData("tagMenu", dynamicTags.value[dynamicTags.value.length-1]); // 当前 菜单
        router.push({
            path: dynamicTags.value[dynamicTags.value.length-1].url  as string
        })
    }
}
const handleClick = (tag) =>{
    let data = dynamicTags.value.filter((item)=>item.title == tag.props.label)
    useCommon.setCommonData("tagMenu", data[0]); // 当前 菜单
    router.push({
        path: data[0].url  as string
    })
}
const removeTab = (tag) =>{
    let index = dynamicTags.value.findIndex((item)=>item.title ==tag)
    dynamicTags.value.splice(index, 1)
    useCommon.setCommonData("tagList", dynamicTags.value as ITag); // 打开过的菜单
     if(dynamicTags.value.length>0){
        useCommon.setCommonData("tagMenu", dynamicTags.value[dynamicTags.value.length-1]); // 当前 菜单
        router.push({
            path: dynamicTags.value[dynamicTags.value.length-1].url as string
        })
    }
}
const closeOthersTags = () =>{
    console.log(66666)
    useCommon.setCommonTag()
}
const closeAllTags = () =>{
    let arr:ITag[]  = [
        {
            url: "/home",
            title: "介绍",
        },
    ]
    useCommon.setCommonData("tagList", arr as ITag ); // 打开过的菜单
    useCommon.setCommonData("tagMenu", arr[arr.length-1]); // 当前 菜单
    router.push({
        path: arr[arr.length-1].url as string
    })
}
</script>
<style scoped lang="scss">
$tabH:50px;
.tagbox{
    height: $tabH;
    line-height: $tabH;
    border-bottom: 1px solid #e6e6e6;
    padding: 0 10px; 
}
// ::v-deep(.el-row){
//     height: 50px;
// }
// .tag-box{
//     overflow: hidden;
//     width: 100%;
//     height: 100%;
//     white-space:nowrap;
// }
::v-deep(.el-tabs){
    height: $tabH;
    line-height: $tabH;
}
::v-deep(.el-tabs--card>.el-tabs__header){
    border: none;
}
::v-deep(.el-tabs--card>.el-tabs__header .el-tabs__nav,
    .el-tabs--card>.el-tabs__header .el-tabs__item,
    .el-tabs--card>.el-tabs__header){
    border: none;
}
::v-deep(.el-tabs--card>.el-tabs__header .el-tabs__item){
    border: none;
    margin: 0 3px;
    height: 32px;
    line-height:32px;
    font-size: 13px;
    font-weight: normal;
    color: #777B96;
    border: 1px solid #E8E8EF;
    border-radius: 80px;
     &.is-active {
            // color: #409EFF;
            // border-bottom: 3px solid #409EFF;
            color: #fff;
            background: #3567E5;
        }
        &.is-active::before{
            content: "";
            background: #fff;
            display: inline-block;
            width: 9px;
            height: 9px;
            border-radius: 50%;
            position: relative;
            margin-right: 4px;
        }
}
::v-deep(.el-tabs__nav-next){
         width: 20px;
        // line-height: 34px;
        line-height: $tabH;
        font-size: 18px;
        text-align: center;
}
::v-deep(  .el-tabs__nav-prev){
         width: 20px;
        // line-height: 34px;
        line-height: $tabH;
        font-size: 18px;
        text-align: center;
}
::v-deep(.el-dropdown){
     line-height: $tabH;
}
.mx-1{
    margin-right:60px;
}
</style>
