<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import Pagination from '@/Components/Pagination.vue';
import { ElTableColumn } from 'element-plus';
const props = defineProps({
    departments: Object,
});
</script>

<template>
    <AuthenticatedLayout>

        <Head title="Departments" />
        <ElCard>
            <ElTable :data="departments.data" border stripe>
                <ElTableColumn type="index" />
                <ElTableColumn label="Title" prop="title" />
                <ElTableColumn label="Description" prop="description" />
                <ElTableColumn>
                    <template #default="{ row }">
                        <Link :href="route('department.show', row)">
                        <ElButton type="primary" plain link>View</ElButton>
                        </Link>
                        <ElButton type="success" plain link>Edit</ElButton>

                    </template>
                </ElTableColumn>
            </ElTable>
            <Modal :show="showProductForm" @close="closeProductForm">
                <DepartmentForm :department="null" @close="closeProductForm" />
            </Modal>
            <Pagination :item="departments" />
        </ElCard>
    </AuthenticatedLayout>
</template>

<style></style>