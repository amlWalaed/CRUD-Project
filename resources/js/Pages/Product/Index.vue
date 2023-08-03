<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import _ from 'lodash';
import Modal from '@/Components/Modal.vue';
import ProductForm from './Partials/ProductForm.vue';
import Pagination from '@/Components/Pagination.vue';
import ProductTable from './Partials/ProductTable.vue';

const props = defineProps({
  products: Object,
});

const showProductForm = ref(false);

const form = useForm({
  search: route().params.search ?? null
});

const search = () => {
  form.get(route('product.index', {
    _query: route().params
  }), {
    preserveScroll: true,
    preserveState: true,
  });
};
const debounceSearch = _.debounce(() => search(), 500);

const closeProductForm = () => {
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
      <ProductTable :products="products.data" />
      <Pagination :item="products" />
    </ElCard>
  </AuthenticatedLayout>
  <Modal :show="showProductForm" @close="closeProductForm">
    <ProductForm :product="null" @close="closeProductForm" />
  </Modal>
</template>

<style></style>