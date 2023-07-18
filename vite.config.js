import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

export default defineConfig({  
    css: {
        preprocessorOptions: {
            scss: {
                additionalData: `@use "/resources/css/element/index.scss" as *;`,
            },
        },
    },
    plugins: [
        laravel({
            input: 'resources/js/app.js',
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
        AutoImport({
            resolvers: [ElementPlusResolver()],
            imports:['vue'],
            dts:true
          }),
          Components({
            resolvers: [ElementPlusResolver({ importStyle: "sass"})],
            dts: 'src/components.d.ts',
          }),
    ],
   
});
