/** @type {import('tailwindcss').Config} */
export default {
    content: ["./app/views/**/*.*", "./app/javascript/**/*.*"],
    theme: {
        extend: {},
        listStyleType: {
            none: "none",
            disc: "disc",
            decimal: "decimal",
            square: "square",
            roman: "upper-roman",
        },
    },
    plugins: [],
};
