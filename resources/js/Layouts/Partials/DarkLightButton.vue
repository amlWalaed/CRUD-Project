<script setup>
import { Moon,Sun } from 'lucide-vue-next';
const isDark = ref();
const changTheme = () => {
    localStorage.theme = localStorage.theme === 'dark' ? 'light':'dark'
    addDarkClass()
};
const addDarkClass = () => {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
        isDark.value = false;
    } else {
        document.documentElement.classList.remove('dark');
        isDark.value = true;
    }
}
onMounted(()=>{
    addDarkClass()
})
</script>

<template>
    <div>
        <el-switch v-model="isDark" @change="changTheme" inline-prompt :active-icon="Sun" :inactive-icon="Moon" />
    </div>
</template>

<style></style>