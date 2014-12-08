Package.describe({
  summary: "Vue for Meteor. It provides data-driven components with a simple and flexible API.",
  version: "0.2.2",
  git: "https://github.com/zhouzhuojie/meteor-vue.git",
  name: "mrt:vue"
});

Package.onUse(function (api) {
  api.versionsFrom('0.9.0');
  api.use(['underscore@1.0.0', 'coffeescript@1.0.2']);
  api.add_files('lib/vue/dist/vue.min.js', 'client');
  api.add_files('lib/main.coffee', 'client');
  if (api.export){
    api.export('Vue', 'client');
  }
});

Package.onTest(function (api){
  api.use(['mrt:vue@0.2.2', 'tinytest'], ['client']);
  api.add_files('test-mrt:vue.js', ['client']);
});
