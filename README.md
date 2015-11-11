Meteor-Vue [![Build Status](https://travis-ci.org/zhouzhuojie/meteor-vue.svg?branch=master)](https://travis-ci.org/zhouzhuojie/meteor-vue)
===============

Get Started
-----------

Meteor-Vue is the bridge between [Vue.js [vuejs/vue]](https://github.com/vuejs/vue) and Meteor. Vue.js is a very sleek and fast framework that works with descriptive bidirectional html data-binding. It also offers animation and transition to your app. `Meteor-Vue` combines them by offering the data-sync option.

Installation. For Meteor@1.0 or later,
```
meteor add vue:vue
```

Usage
-------

First you need to instantiate `var vm = new Vue({})` with option `sync`, which is linked with any reactive source from Meteor:

```
sync: {
    'some-key': function(){
        // It should return a reactive source
    }
}
```

The function should contain any kind of reactive sources from Meteor. For example,

```javascript
var vm = new Vue({
        el: '#vue-demo',
        data: {
            'data1': 'data1',
            'data2': [1, 2, 3]
        },
        sync: {
            'data3': function() {
                return Posts.find()
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

After the instantiation of `vm`, the `sync` property automatically maps all its functions' return value into `vm` and `vm.$data`, which means one can access these data like:
```javascript
var data3 = vm.data3
var data4 = vm.data4

// or some HTML
<div v-for="post in data3">
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
            'name': 'Neil Armstrong',
            'arrayOfNumbers': [1, 2, 3]
        },
        sync: {
            'posts': function() {
                return Posts.find();
            }
        }
    });
}
```

`client/home.html`, note that `[[...]]` are used here instead of ``{{...}}`` to avoid the syntax conflicts.
```html
<div id="vue-demo">

My name is [[name]]

<ul>
    <li v-for="number in arrayOfNumbers">
        Number: [[number]]
    </li>
</ul>

<ul>
    <li v-for="post in posts">
        [[post.tiltle]], [[post.content]]
    </li>
</ul>
</div>
```

API
------
If you want to dynamically bind more reactive data source, use the following api:

```javascript
vm.$sync(key, func);
vm.$unsync(key);
```

Meteor-Vue Components
---------------------

Define your component with `<script type="text/x-template">` template:
```html
<body>
    {{> home}}
</body>

<template name="home">

    <script type="text/x-template" id="hi-template">
        Hi, [[name]]

        <h2>Posts Summary</h2>
        <ul>
            <li v-for="post in posts" :post="post">[[post.title]]</li>
        </ul>
    </script>

    <div id="app">
        <hi></hi>
    </div>

</template>
```

Register your component with `Vue.component()` and then initialize your Vue view model.
```javascript
if (Meteor.isClient) {
    Template.home.onRendered(function(){
        Vue.component('hi', {
            template: '#hi-template',
            data: function(){
                return {
                    name: 'Meteor-Vue'
                }
            },
            sync: {
                posts: function () {
                    return Posts.find({});
                }
            },
        })
        var vm = new Vue({
            el: '#app'
        })
    })
}
```

LICENSE
-------
MIT
