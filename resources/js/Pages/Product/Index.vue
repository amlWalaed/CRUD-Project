<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import _ from 'lodash';
import Modal from '@/Components/Modal.vue';
import ProductForm from './Partials/ProductForm.vue';
const props = defineProps({
  products: Object,
});
const form = useForm({
  search: route().params.search ?? null
});
const selectedProduct = ref();
const showProductForm = ref(false);
const search = () => {
  form.get(route('product.index', {
    _query: route().params
  }), {
    preserveScroll: true,
    preserveState: true,
  });
};
const debounceSearch = _.debounce(() => search(), 500);
const deleteProduct = (product) => {
  router.delete(route('product.destroy', product));
};
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
</script>

<template>
  <AuthenticatedLayout>

    <Head title="Products" />
    <ElCard>
      <div class="flex gap-1 mb-3">
        <ElInput type="search" placeholder="Search..." id="search-product" v-model="form.search"
          @input="debounceSearch" />
        <ElButton type="primary" @click="() => showProductForm = true">Create</ElButton>
      </div>
      <ElTable :data="products.data" @sort-change="sortBy" stripe border>
        <ElTableColumn label="Id" type="index" />
        <ElTableColumn label="Name" prop="name" sortable="custom" />
        <ElTableColumn label="Price" prop="price" sortable="custom" />
        <ElTableColumn label="Discount" prop="discount" sortable="custom" />
        <ElTableColumn label="">
          <template #default="{ row }">
            <Link :href="route('product.show', row)">
              <ElButton type="primary" link>view</ElButton>
            </Link>

            <ElButton type="success" link @click="openEditForm(row)">Edit</ElButton>

            <ElButton type="danger" link @click="deleteProduct(row)">Delete</ElButton>
          </template>
        </ElTableColumn>
      </ElTable>
      <div class="flex justify-center mt-6">
        <ElPagination layout="prev, pager, next" :pager-count="6"  
        :current-page="products.current_page"
        :total="products.total"  hide-on-single-page
        @current-change="(page)=>router.visit(route('product.index',{
          _query:{
            page
          }
        }))"
        />

      </div>
    </ElCard>
  </AuthenticatedLayout>
  <Modal :show="showProductForm" @close="closeProductForm">
    <ProductForm :product="selectedProduct" @close="closeProductForm" />
  </Modal>
</template>

<style></style>