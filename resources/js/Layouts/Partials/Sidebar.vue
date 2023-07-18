<script setup>
import ResponsiveNavLink from '@/Components/ResponsiveNavLink.vue';
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
const links = ref([
   { id: 0, routeName: 'product.index', label: 'Products' }
]);
</script>

<template>
   <el-aside width="200px" class="py-6 text-gray-900 dark:bg-gray-700 dark:text-white">
      <ApplicationLogo class="block w-auto h-16 mx-auto text-gray-800 fill-current dark:text-gray-200" />
      <div class="flex flex-col gap-4 mt-3">
         <template v-for="link in links">
            <ResponsiveNavLink :href="route(link.routeName)" :active="route().current(link.routeName)">{{ link.label }}
            </ResponsiveNavLink>
         </template>

      </div>
   </el-aside>
</template>

<style></style>