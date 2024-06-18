<template>
  <el-form ref="ruleFormRef" :model="ruleForm" status-icon :rules="rules" class="demo-ruleForm">
    <el-form-item label="帐号" prop="account">
      <el-input v-model="ruleForm.account" type="text" autocomplete="off" />
    </el-form-item>
    <el-form-item label="密码" prop="password">
      <el-input v-model="ruleForm.password" type="password" autocomplete="off" />
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="submitForm(ruleFormRef)">登录</el-button>
    </el-form-item>
  </el-form>
</template>

<script lang="ts" setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import website from  "@/const/website"
import type { FormInstance } from "element-plus";
const router = useRouter()
const ruleForm = reactive({
  password: "",
  account: "",
});
const ruleFormRef = ref<FormInstance>();
const pass = (rule: any, value: any, callback: any) => {
  if (value === "") {
    callback(new Error("请输入密码"));
  } else {
    callback();
  }
};
const account = (rule: any, value: any, callback: any) => {
  if (value === "") {
    callback(new Error("请输入帐号名称"));
  } else {
    callback();
  }
};
const rules = reactive({
  password: [{ validator: pass, trigger: "blur" }],
  account: [{ validator: account, trigger: "blur" }],
});
const submitForm = (formEl: FormInstance | undefined) => {
  console.log(formEl);
  if (!formEl) return;
  formEl.validate((valid) => {
    
    if (valid) {
      console.log(router);
      
      router.push({
          path:'/home'
      });
    } else {
      console.log("error submit!");
      return false;
    }
  });
};
</script>
<style lang="scss" scoped>
.demo-ruleForm {
  position: fixed;
  top: 50%;
  left: 50%;
  border: 1px solid #e6e6e6;
  background: #a040ff;
  width: 400px;
  // height: 200px;
  border-radius: 25px;
  -webkit-transform: translateX(-50%) translateY(-50%);
  padding: 60px;
}
::v-deep(.el-form-item__label) {
  color: #fff;
}
::v-deep(.el-button) {
  width: 100%;
}
</style>
