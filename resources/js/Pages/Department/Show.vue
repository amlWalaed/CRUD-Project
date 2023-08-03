<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head , Link} from '@inertiajs/vue3';
import ProductTable from '@/Pages/Product/Partials/ProductTable.vue';
    const props = defineProps({
        department: Object,
    })
</script>

<template>
    <AuthenticatedLayout>
        <head :title="department.title" />
       <ElCard>
        <div class="mb-6">
            <h1 class="text-xl font-bold capitalize">{{ department.title }}</h1>
            <p class="text-gray-600 dark:text-gray-400">{{ department.description }}</p>
        </div>
        <ProductTable :products="department.products"/>
       </ElCard>
    </AuthenticatedLayout>
</template>

<style></style>