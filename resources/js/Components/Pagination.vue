<script setup>
import {  router } from '@inertiajs/vue3';
const props = defineProps({
    item: Object,
});
</script>

<template>
    <div class="flex justify-center mt-6">
        <ElPagination layout="prev, pager, next"  :current-page="item.current_page" :total="item.total"
            hide-on-single-page @current-change="(page) => router.visit(route(route().current(), {
                _query: {
                    ...route().params,
                    page
                }
            }))" />

    </div>
</template>

<style></style>