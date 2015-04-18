Package.describe({
  summary: "Vue for Meteor. It provides data-driven components with a simple and flexible API.",
  version: "0.11.6",
  git: "https://github.com/zhouzhuojie/meteor-vue.git",
  name: "mrt:vue"
});

Package.onUse(function (api) {
  api.versionsFrom('1.0');
  api.use(['underscore@1.0.0', 'coffeescript@1.0.2']);
  api.add_files('lib/vue/dist/vue.js', 'client');
  api.add_files('lib/main.coffee', 'client');
  api.export('Vue', 'client');
});

Package.onTest(function (api){
  api.use(['mrt:vue', 'tinytest'], ['client']);
  api.add_files('test-mrt:vue.js', ['client']);
});
