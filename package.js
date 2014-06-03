Package.describe({
  summary: "Vue"
});

Package.on_use(function (api) {
  api.use(['underscore', 'coffeescript']);
  api.add_files('lib/vue/dist/vue.min.js', 'client');
  api.add_files('lib/main.coffee', 'client');
  if (api.export){
    api.export('Vue', 'client');
  }
});

//Package.on_test(function (api) {
  //api.use('coffeescript', 'client');
  //api.use('underscore', 'client');
  //api.use('vue', 'client');
  //api.use(['tinytest', 'ui', 'spacebars', 'templating']);
  //api.add_files('tests/test.coffee', 'client');
  //api.add_files('tests/test.html', 'client');
//});
