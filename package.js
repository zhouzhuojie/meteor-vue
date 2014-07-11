Package.describe({
  summary: "Vue for Meteor, Vue.js is a library for building interactive web interfaces. It provides data-driven components with a simple and flexible API.",
  version: "0.0.1"
});

Package.on_use(function (api) {
  api.use(['underscore', 'coffeescript']);
  api.add_files('lib/vue/dist/vue.min.js', 'client');
  api.add_files('lib/main.coffee', 'client');
  if (api.export){
    api.export('Vue', 'client');
  }
});
