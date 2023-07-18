<script setup>
import { useForm } from '@inertiajs/vue3';
import UploadInput from '@/Components/UploadInput.vue';

const props = defineProps({
    product: Object,
});

const emit = defineEmits(['close']);

const form = useForm({
    thumbnail: props?.product?.thumbnail ?? [],
    name: props?.product?.name ?? null,
    excerpt: props?.product?.excerpt ?? null,
    description: props?.product?.description ?? null,
    price: props?.product?.price ?? 0,
    amount: props?.product?.amount ?? 0,
    discount: props?.product?.discount ?? 0,
});
const addProduct = () => {
    if (Boolean(props.product))
        form.post(route('product.update', props.product), {
            preserveState: true,
            preserveScroll: true,
            onSuccess: () => emit('close')
        });
    else
        form.post(route('product.store'), {
            preserveState: true,
            preserveScroll: true,
            onSuccess: () => emit('close')
        });
};

</script>
 
<template>
    <ElForm label-position="left" label-width="150px" class="p-6" @submit="addProduct">
        <ElFormItem label="Product Photo" :error="form.errors.thumbnail">
            <UploadInput :url="product?.thumbnail ?'/storage/'+product?.thumbnail : false" @addFile="(file)=> form.thumbnail = file"/>
        </ElFormItem>

        <ElFormItem label="Product Name" :error="form.errors.name">
            <ElInput type="text" v-model="form.name" required />
        </ElFormItem>

        <ElFormItem label="Product Excerpt" :error="form.errors.excerpt">
            <ElInput type="text" v-model="form.excerpt" required />
        </ElFormItem>

        <ElFormItem label="Product Description" :error="form.errors.description">
            <ElInput type="textarea" v-model="form.description" required />
        </ElFormItem>

        <ElFormItem label="Product Price" :error="form.errors.price">
            <ElInput type="text" v-model.number="form.price" required />
        </ElFormItem>

        <ElFormItem label="Product Discount" :error="form.errors.discount">
            <ElInput type="number" v-model.number="form.discount" required :max="100" />
        </ElFormItem>

        <ElFormItem label="Product Amount" :error="form.errors.amount">
            <ElInput type="number" v-model.number="form.amount" required />
        </ElFormItem>
        <div class="flex justify-end gap-2">

            <ElButton plain @click="$emit('close')"> Cancel</ElButton>
            <ElButton type="primary" :loading="form.processing" @click="addProduct"> Add</ElButton>
        </div>
    </ElForm>
</template>
 
<style></style>