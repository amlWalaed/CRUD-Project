<script setup>
import ResponsiveNavLink from '@/Components/ResponsiveNavLink.vue';
import ApplicationLogo from '@/Components/ApplicationLogo.vue';
const links = ref([
   { id: 0, routeName: 'product.index', label: 'Products' , currentUrl: 'product.*'},
   { id: 1, routeName: 'department.index', label: 'Department' , currentUrl: 'department.*'},
]);
</script>

<template>
   <el-aside width="200px" class="py-6 text-gray-900 dark:bg-gray-700 dark:text-white">
      <ApplicationLogo class="block w-auto h-16 mx-auto text-gray-800 fill-current dark:text-gray-200" />
      <div class="flex flex-col mt-3">
         <template v-for="link in links">
            <ResponsiveNavLink :href="route(link.routeName)" :active="route().current(link.currentUrl)">{{ link.label }}
            </ResponsiveNavLink>
         </template>

      </div>
   </el-aside>
</template>

<style></style>