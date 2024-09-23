<script setup>
import { ref } from "vue";

const message = ref("");
const data = ref(null);
const error = ref(null);
const loading = ref(false);

const getDeps = async () => {
    loading.value = true;
    await fetch("http://localhost:3000/npm_deps/fetch", {
        method: "POST",
        headers: {
            "Content-Type": "application/json;charset=utf-8",
        },
        body: JSON.stringify({ name: message.value }),
    })
        .then(response => response.json())
        .then(
            json => ((data.value = json.dependencies), (loading.value = false))
        )
        .catch(err => (error.value = err));
};
</script>
<template>
    <div>
        <h1>NPM Dependencies Fetcher</h1>
        <div class="form">
            <p>https://registry.npmjs.org/webpack/latest</p>
            <p>https://registry.npmjs.org/{{ message }}/latest</p>
            <input v-model="message" placeholder="npm package name" />

            <button @click="getDeps">Submit</button>
        </div>
        <div v-if="error">Возникла ошибка: {{ error.message }}</div>
        <div v-else-if="data">
            <h3>Dependencies:</h3>
            <ul>
                <li v-for="(value, key) in data">
                    {{ key }}
                </li>
            </ul>
        </div>
        <div v-else-if="loading">Загрузка...</div>
        <div v-else></div>
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
