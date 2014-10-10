Package.describe({
  summary: "Vue for Meteor. It provides data-driven components with a simple and flexible API.",
  version: "0.2.0",
  git: "https://github.com/zhouzhuojie/meteor-vue.git",
  name: "mrt:vue"
});

Package.on_use(function (api) {
  api.use(['underscore@1.0.0', 'coffeescript@1.0.2']);
  api.add_files('lib/vue/dist/vue.min.js', 'client');
  api.add_files('lib/main.coffee', 'client');
  if (api.export){
    api.export('Vue', 'client');
  }
});

if (Package.on_test) {
  Package.on_test(function (api) {
    if (Package.onTest) {
      api.use(['mrt:vue@0.2.0', 'tinytest'], ['client']);
    } else {
      api.use(['vue', 'tinytest'], ['client']);
    }
    api.add_files('test-mrt:vue.js', ['client']);
  });
}
