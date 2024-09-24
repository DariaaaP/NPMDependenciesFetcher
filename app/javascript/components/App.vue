<script setup>
import { ref } from "vue";

const message = ref("");
const error = ref(null);
const loading = ref(false);
const deps = ref([]);
const items = ref([]);

async function fetchData(url, valueName, depth) {
    loading.value = true;
    error.value = null;
    items.value = [];
    try {
        items.value = await fetchRecursive(url, valueName, depth);
    } catch (err) {
        error.value = err.message;
    } finally {
        loading.value = false;
    }
}
async function fetchRecursive(url, valueName, currentDepth) {
    if (currentDepth) {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json;charset=utf-8",
            },
            body: JSON.stringify({ name: valueName }),
        });

        if (!response.ok) {
            throw new Error("Ошибка сети");
        }
        const data = await response.json();
        const results = [];

        if (data.dependencies) {
            for (const [key, value] of Object.entries(data.dependencies)) {
                if (!key.includes("@")) {
                    const item = { name: key };

                    item.children = await fetchRecursive(
                        url,
                        key,
                        currentDepth - 1
                    );

                    results.push(item);
                }
            }
        }
        return results;
    }
}
</script>
<template>
    <div>
        <h1>NPM Dependencies Fetcher</h1>
        <div class="form">
            <p>https://registry.npmjs.org/webpack/latest</p>
            <p>https://registry.npmjs.org/{{ message }}/latest</p>
            <input v-model="message" placeholder="npm package name" />

            <button
                @click="
                    () =>
                        fetchData(
                            'http://localhost:3000/npm_deps/fetch',
                            message,
                            2
                        )
                "
            >
                Submit
            </button>
        </div>
        <div v-if="error">Возникла ошибка: {{ error.message }}</div>

        <ul v-if="!loading && !error">
            <li v-for="(item, index) in items" :key="index">
                <span>{{ item.name }}</span>
                <ul v-if="item.children && item.children.length">
                    <li
                        v-for="(child, childIndex) in item.children"
                        :key="childIndex"
                    >
                        <span>{{ child.name }}</span>
                    </li>
                </ul>
            </li>
        </ul>

        <div v-if="loading">Загрузка...</div>
    </div>
</template>
<style scoped>
div {
    width: 80%;
    display: flex;
    flex-direction: column;
    margin: 0 auto;
}
.form {
    width: 100%;
}
button {
    margin: 10px;
}
h1 {
    text-align: center;
}
label {
    display: block;
    width: 80px;
    padding: 5px;
}
label:hover {
    cursor: pointer;
    background-color: rgb(211, 244, 211);
    border-radius: 5px;
}
</style>
