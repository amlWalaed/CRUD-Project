<script setup>
import { Plus, Trash2 } from 'lucide-vue-next';
const props = defineProps({
    url: String  ,
})

const emit = defineEmits(['addFile'])

const imgUrl = ref(props.url)
const inputUpload = ref(null)
const file = ref(null)

const upload = (e) => {
    file.value =e.target.files[0]
    const reader = new FileReader();
    reader.onload = (e) => {
        imgUrl.value = e.target.result;
    }
    reader.readAsDataURL(file.value)
    emit('addFile',file.value)
}
const fireInput = () => {
    inputUpload.value.click();
}
</script>

<template>
    <div class="flex items-center gap-3">
        <div v-if="imgUrl" class="rounded border border-gray-300 dark:border-gray-500 border-dashed shrink-0 h-[148px] w-[148px] flex">
            <img class="w-full m-auto object-fit" :src="imgUrl" alt="" />
        </div>
        <ElButton @click="fireInput" type="success">Select Photo Product</ElButton>
        <input type="file" ref="inputUpload" name="product-name" @change="upload" class="hidden"/>
    </div>
</template>

<style></style>