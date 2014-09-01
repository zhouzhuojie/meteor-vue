if(Meteor.isClient){
    Tinytest.add('Vue can be initalized', function (test) {
        test.isNotNull(Vue, 'Vue should exist');
        test.isTrue(typeof(Vue) === "function", 'vue should be a function');
        vm = new Vue();
        test.isTrue(typeof(vm.$sync) === "function", 'nprogres sync should be a function');
        test.isTrue(typeof(vm.$unsync) === "function", 'nprogres unsync should be a function');
    });
}
