<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';

const props = defineProps({
        product: Object,
})
</script>

<template>
    <AuthenticatedLayout>
        <h1 class="font-bold text-2xl text-center py-3">{{ product.name }}</h1>
        <ElCard>
            <img :src="`/storage/${product.thumbnail}`"/>
                   <p class="loading-7 p-6">
                    {{ product.description }}
                   </p>

        </ElCard>
    </AuthenticatedLayout>
</template>

<style></style>