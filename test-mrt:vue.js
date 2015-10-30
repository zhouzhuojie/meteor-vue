if(Meteor.isClient){
    Tinytest.add('Vue can be initalized', function (test) {
        test.isNotNull(Vue, 'Vue should exist');
        test.isTrue(typeof(Vue) === "function", 'vue should be a function');
        var vm = new Vue();
        test.isTrue(typeof(vm.$sync) === "function", 'nprogres sync should be a function');
        test.isTrue(typeof(vm.$unsync) === "function", 'nprogres unsync should be a function');
    });

    Tinytest.addAsync('Vue supports binding to the vm, `this` refer to the vm itself', function (test, next) {
        var vm = new Vue({
            data: {
                a: 'key'
            },
            computed: {
                c: function(){
                    return this.b;
                }
            },
            sync: {
                b: function(){
                    return Session.get(this.a);
                }
            }
        });

        Session.set('key', 'iamb');

        _.delay(function(){
            test.equal(Session.get('key'), vm.b);
            test.equal(Session.get('key'), vm.c);
            next();
        }, 0);
    });

    Tinytest.addAsync('Vue can be synced with Session', function (test, next) {
        var vm = new Vue({
            data: {
                a: 1
            },
            computed: {
                c: function(){
                    return this.b
                }
            },
            sync: {
                b: function(){
                    return Session.get('b');
                }
            }
        });
        Session.set('b', 'iamb');
        _.delay(function(){
            test.equal(Session.get('b'), vm.b);
            test.equal(Session.get('b'), vm.c);
            next();
        }, 0);
    });

    Tinytest.addAsync('Vue can be synced with Collections find()', function (test, next) {
        var C = new Mongo.Collection(null);
        var vm = new Vue({
            computed: {
                c: function(){
                    return this.b;
                }
            },
            sync: {
                b: function(){
                    return C.find('b');
                }
            }
        });

        C.insert({_id: 'b', title: 'B'}, function(){
            _.delay(function(){
                var d = C.find('b').fetch();
                test.equal(d[0], vm.b[0]);
                test.equal(d[0], vm.c[0]);
                C.update('b', {$set: {title: 'BB'}}, function(){
                    _.delay(function(){
                        var d = C.find('b').fetch();
                        test.equal(d[0], vm.b[0]);
                        test.equal(d[0], vm.c[0]);
                        next();
                    }, 0);
                });
            }, 0);
        });
    });

    Tinytest.addAsync('Vue can be synced with Collections findOne()', function (test, next) {
        var C = new Mongo.Collection(null);
        var vm = new Vue({
            computed: {
                c: function(){
                    return this.b;
                }
            },
            sync: {
                b: function(){
                    return C.findOne('b');
                }
            }
        });
        C.update('b', {$set: {title: 'ZZ'}}, function(){
            _.delay(function(){
                var d = C.findOne('b');
                test.equal(d, vm.b);
                test.equal(d, vm.c);
                next();
            }, 0);
        });
    });
}
