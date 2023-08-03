<script setup>
import Modal from '@/Components/Modal.vue';
import { Link, router } from '@inertiajs/vue3';
import ProductForm from './ProductForm.vue';

const props = defineProps({
    products: Object,
});
const selectedProduct = ref();
const showProductForm = ref(false);

const sortBy = ({ prop, order }) => {
    router.get(route('product.index', {
        _query: {
            ...route().params,
            sort: {
                col: prop,
                order
            }
        }
    }),);
};
const openEditForm = (product) => {
    selectedProduct.value = product;
    showProductForm.value = true;
};
const closeProductForm = () => {
    selectedProduct.value = null;
    showProductForm.value = false;
};
const deleteProduct = (product) => {
  router.delete(route('product.destroy', product));
};

</script>

<template>
    <ElTable :data="products" @sort-change="sortBy" stripe border>
        <ElTableColumn label="Id" type="index" />
        <ElTableColumn label="Image">
            <template #default="{ row }">
                <template v-if="row.thumbnail">
                    <img :src="`/storage/${row.thumbnail}`" class="w-8 mx-auto rounded-full" />
                </template>
                <div v-else
                    class="flex items-center justify-center w-8 mx-auto text-gray-900 uppercase bg-gray-100 rounded-full dark:bg-gray-400 aspect-square">
                    <span>
                        {{ row.name[0] }}
                    </span>
                </div>
            </template>
        </ElTableColumn>
        <ElTableColumn label="Name" prop="name" sortable="custom" />
        <ElTableColumn label="Price" prop="price" sortable="custom" />
        <ElTableColumn label="Discount" prop="discount" sortable="custom" />
        <ElTableColumn label="Amount" prop="amount" sortable="custom" />
        <ElTableColumn label="Department">
            <template #default="{ row }">
                <Link :href="route('department.show',row.department)">
                    <ElTag type="warning">{{ row.department.title }}</ElTag>
                </Link>
            </template>
        </ElTableColumn>
        <ElTableColumn label="Rating" prop="rating" sortable="custom" min-width="100">
            <template #default="{ row }">
                <ElRate v-model="row.rating" allow-half disabled />
            </template>
        </ElTableColumn>
        <ElTableColumn label="" min-width="100">
            <template #default="{ row }">
                <Link :href="route('product.show', row)">
                <ElButton type="primary" link>view</ElButton>
                </Link>

                <ElButton type="success" link @click="openEditForm(row)">Edit</ElButton>

                <ElButton type="danger" link @click="deleteProduct(row)" class="!m-0">Delete</ElButton>
            </template>
        </ElTableColumn>
    </ElTable>
    <Modal :show="showProductForm" @close="closeProductForm">
    <ProductForm :product="selectedProduct" @close="closeProductForm" />
  </Modal>
</template>

<style></style>