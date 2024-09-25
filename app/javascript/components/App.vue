<script setup>
import { ref } from "vue";

const message = ref("");
const data = ref(null);
const error = ref(null);
const loading = ref(false);

const getDeps = async () => {
    loading.value = true;
    await fetch("http://localhost:3000/deps_collector/fetch_deps_all", {
        method: "POST",
        headers: {
            "Content-Type": "application/json;charset=utf-8",
        },
        body: JSON.stringify({ name: message.value }),
    })
        .then(response => response.json())
        .then(json => ((data.value = json), (loading.value = false)))
        .catch(err => (error.value = err));
};
</script>

<template>
    <div class="flex flex-col items-center justify-start min-h-screen">
        <div
            class="bg-opacity-30 backdrop-blur-md bg-gradient-to-br from-gray-200 to-blue-300 border border-gray-300 p-8 rounded-lg shadow-lg w-full max-w-lg mt-20"
        >
            <h2 class="text-2xl font-bold mb-6 text-center">
                NPM Dependencies Fetcher
            </h2>
            <div class="mb-4">
                <input
                    type="text"
                    v-model="message"
                    placeholder="npm package name"
                    class="border border-gray-300 rounded-lg p-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-500 mb-2"
                />
            </div>
            <div class="flex justify-end">
                <button
                    class="w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600"
                    @click="getDeps"
                >
                    Получить
                </button>
            </div>
        </div>
        <div class="mt-8 w-full max-w-lg">
            <div v-if="error">Возникла ошибка: {{ error.message }}</div>
            <div v-else-if="data">
                <h3 class="text-lg font-semibold text-center">Зависимости:</h3>
                <ul
                    class="bg-white bg-opacity-50 p-4 rounded-lg shadow-md list-disc list-inside"
                    v-for="packages_name in data"
                >
                    <li v-for="(key, value) in packages_name">
                        <span>{{ value }}</span>
                        <ul
                            class="list-square list-inside ml-4"
                            v-for="sub_packages_name in key"
                        >
                            <li v-for="(k_sub, v_sub) in sub_packages_name">
                                {{ v_sub }}
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            <div v-else-if="loading">Загрузка...</div>
            <div v-else></div>
        </div>
    </div>
</template>
