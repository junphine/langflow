
import { defineStore } from "pinia";
import website from  "@/const/website"
import {  ITag ,ICommon ,ITagList} from  "@/store/type-interface/common"
export const useCommonStore = defineStore({
    id: "common",
    state: ():ICommon=>({
        tagMenu: {}, // 当前 菜单
        tagList: [], // 打开过的菜单
        website: website,
    }),
    getters: {
        getCommonTagMenu:(state:ICommon)=>{
            return state.tagMenu;
        },
        getCommonTagList:(state:ICommon)=>{
            return state.tagList;
        },
        getCommonWebsite:(state:any)=>{
            return state.website
        }
    },
    actions: {
        setCommonData(name:string,data:ITag|ITagList){
            for(var i in this){
                if(i==name){
                    this[i] = data;
                }
            }
        },
        setCommonTag(){
            console.log(this)
            let data = this.tagMenu as ITag[]
            this.tagList = [data]
        }
    },
    persist:{
        enabled: true,  
        strategies: [
            {
                key: `${website.title}-common`,
                storage: sessionStorage,
                paths: ["tagMenu",'tagList',], // 写缓存
            },
            {
                key: `${website.title}-website`,
                storage: sessionStorage,
                paths: ["website"], // 写缓存
            }

        ]
    }
})