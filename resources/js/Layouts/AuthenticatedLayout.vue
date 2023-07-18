<script setup>
import Sidebar from '@/Layouts/Partials/Sidebar.vue';
import Navbar from '@/Layouts/Partials/Navbar.vue';
import {usePage} from '@inertiajs/vue3'

const flash = computed(() => {
    return usePage().props.flash;
});

watch(
    () => flash.value,
    (newFlash) => {
        console.log(usePage().props.flash)
        if (newFlash?.message) {
            ElNotification({
                message: newFlash.message.body,
                type: newFlash?.message.type ?? "info",
            });
        }
    },
    { deep: true, immediate: true }
);

</script>

<template>
    <el-container class="min-h-screen ">
        <Sidebar class="bg-white dark:bg-gray-800"/>
        <el-container>
            <Navbar/>
            <el-main class="bg-gray-100 dark:bg-gray-900">
                <main>
                <slot />
            </main>
            </el-main>
            <el-footer class="dark:bg-gray-800 bg-white text-gray-500 dark:text-gray-400">Footer</el-footer>

        </el-container>
    </el-container>
</template>
