Package.describe({
    summary: "Vue for Meteor. It provides data-driven components with a simple and flexible API.",
    version: "1.0.3",
    git: "https://github.com/nerijunior/meteor-vue.git",
    name: "nerijunior:vue"
});

Package.onUse(function(api) {
    api.versionsFrom('1.0');
    api.use(['underscore@1.0.0']);
    api.addFiles('lib/vue/dist/vue.js', 'client');
    api.addFiles('lib/main.js', 'client');
    api.export('Vue', 'client');
});

Package.onTest(function(api) {
    api.use('mongo');
    api.use('tracker');
    api.use(['vue:vue', 'tinytest'], ['client']);
    api.addFiles('test-mrt:vue.js', ['client']);
});
