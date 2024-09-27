<script setup>
import { ref, computed } from "vue";
import Spinner from "../components/Spinner.vue";
const message = ref("");
const data = ref(null);
const error = ref(null);
const loading = ref(false);
const hasError = ref(null);
const errorMessage = ref("");

const inputClass = computed(() => {
    return hasError.value ? "border-red-500 animate-shake" : "border-gray-300";
});

const updateDataValue = computed(() => {
    return message.value === "" ? (data.value = null) : "";
});

const handleSubmit = () => {
    if (!message.value.trim()) {
        hasError.value = true;
        errorMessage.value = "Поле не должно быть пустым";
    } else {
        getDeps();
        hasError.value = false;
        errorMessage.value = "";
    }
    if (hasError.value) {
        setTimeout(() => {
            hasError.value = false;
        }, 2000);
    }
};
const getDeps = async () => {
    loading.value = true;
    data.value = null;

    await fetch("deps_collector/fetch_deps_all", {
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
    <div class="flex flex-col items-center justify-start min-h-screen mb-10">
        <div
            class="bg-opacity-30 backdrop-blur-md bg-gradient-to-br from-gray-200 to-blue-300 border border-gray-300 p-8 rounded-lg shadow-lg w-full max-w-lg mt-20"
        >
            <h2 class="text-2xl font-bold mb-6 text-center">
                NPM Dependencies Fetcher
            </h2>
            <div class="relative mb-10">
                <input
                    type="text"
                    @input="updateDataValue"
                    :class="inputClass"
                    v-model="message"
                    placeholder="npm package name"
                    class="border border-gray-300 rounded-lg p-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
                <transition name="fade">
                    <p v-if="hasError" class="absolute text-red-500 top-full">
                        {{ errorMessage }}
                    </p>
                </transition>
            </div>
            <div class="flex justify-end">
                <button
                    class="w-full bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600"
                    @click="handleSubmit"
                    :disabled="loading ? true : false"
                >
                    Получить
                </button>
            </div>
        </div>
        <div class="mt-8 w-full max-w-lg">
            <div v-if="error">Возникла ошибка: {{ error.message }}</div>
            <div v-else-if="message.length === 0"></div>
            <div v-else-if="data">
                <div
                    v-if="data.length === 0"
                    class="flex items-center justify-center h-20 bg-gradient-to-r from-orange-200 to-yellow-200 opacity-75 rounded-lg shadow-md"
                >
                    <h3 class="text-2xl font-semibold text-center mb-2">
                        Зависимостей нет
                    </h3>
                </div>
                <div
                    v-else="data.length > 0"
                    class="flex items-center justify-center h-20 bg-gradient-to-br from-blue-200 to-blue-400 rounded-lg shadow-md mb-6 mt-3"
                >
                    <h3 class="text-2xl font-semibold text-center">
                        Зависимости
                    </h3>
                </div>
                <ul
                    class="bg-opacity-30 backdrop-blur-md bg-gradient-to-br from-green-300 to-green-200 bg-opacity-75 p-4 rounded-lg shadow-md list-disc list-inside mb-3"
                    v-for="package_name in data"
                >
                    <li>
                        {{ package_name }}
                    </li>
                </ul>
            </div>
            <Spinner v-else-if="loading" class="text-center"></Spinner>
        </div>
    </div>
</template>

<style>
@keyframes shake {
    0%,
    100% {
        transform: translateX(0);
    }
    25% {
        transform: translateX(-5px);
    }
    50% {
        transform: translateX(5px);
    }
    75% {
        transform: translateX(-5px);
    }
}

.animate-shake {
    animation: shake 0.5s ease forwards;
}
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.5s;
}
.fade-enter,
.fade-leave-to {
    opacity: 0;
}
</style>
