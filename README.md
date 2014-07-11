Meteor-Vue [![Build Status](https://travis-ci.org/zhouzhuojie/meteor-vue.svg?branch=master)](https://travis-ci.org/zhouzhuojie/meteor-vue)
===============

Get Started
-----------

Installation. Make sure you have Meteor and Meteorite installed.
```
mrt add vue
```


Meteor-Vue is the bridge between [Vue.js [yyx990803/vue]](https://github.com/yyx990803/vue) and Meteor. Vue.js is very a very sleek and fast framework that works with descriptive bidirectional html data-binding. It also offers some animation and transition to your app. `Meteor-Vue` combines them by offering the data-sync option. 


Usage
-------

First you need to instantiate `var vm = new Vue({})` with option 
```
sync: {
    'some-key': function(){}
}
```
The function should contain some reactive sources from Meteor, and it can be any kind of reactive sources. For example,

```javascript
var vm = new Vue({
        el: '#vue-demo',
        data: {
            'data1': 'data1',
            'data2': [1, 2, 3]
        },
        sync: {
            'data3': function() {
                return Posts.find();
            },
            'data4': function() {
                return Posts.find().fetch();
            },
            'data5': function() {
                return Posts.findOne();
            },
            'data6': function() {
                return Session.get('DOM-title')
            }
        }
});
```

After the instantiation of `vm`, the `sync` property automatically map all its functions' return into `vm` and `vm.$data`, which means one can access these data like:
```javascript
var data3 = vm.data3 // or vm.$data.data3, vue.js automatically take care of this.
var data4 = vm.data4

// or some HTML
<div v-repeat="post: data3">
    [[post.title]]
</div>
``` 


----
#### A full example with html and collection definition here.

`model.js`
```javascript
Posts = new Meteor.Collection('posts');

```

`client/home.js`
```javascript
Template.home.rendered = function() {
    var vm = new Vue({
        el: '#vue-demo',
        data: {
            'data1': 'data1',
            'data2': [1, 2, 3]
        },
        sync: {
            'data3': function() {
                return Posts.find();
            }
        }
    });
}
```

`client/home.html`, note that `[[...]]` are used here instead of ``{{...}}`` to avoid the syntax conflicts.
```html
<div id="vue-demo">

My name is [[data1]]

<ul>
    <li v-repeat="data2">
        numbers, [[$data]]
    </li>
</ul>

<ul>
    <li v-repeat="post: data3">
        [[post.tiltle]], [[post.content]]
    </li>
</ul>
</div>
```

API
------
If you want to dynamically bind more reactive data source, use the following api:

```javascript
vm.$sync(key, func); // The function should return something like Posts.find() or Posts.findOne()
vm.$unsync(key);
```


LICENSE
-------
MIT
