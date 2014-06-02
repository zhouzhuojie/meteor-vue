Package.describe({
  summary: "Vue"
});

Package.on_use(function (api) {
  api.use('underscore', 'client');
  api.use('coffeescript', 'client');
  api.add_files('vue/dist/vue.min.js', 'client');
  api.add_files('main.coffee', 'client');
  if (api.export){
    api.export('Vue', 'client');
  }
});

Package.on_test(function (api) {
  api.use('coffeescript', 'client');
  api.use('underscore', 'client');
  api.use('vue', 'client');
  api.use('tinytest');
  api.add_files('tests/test.coffee', 'client');
});
