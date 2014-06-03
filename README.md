Meteor-Vue [![Build Status](https://travis-ci.org/zhouzhuojie/meteor-vue.svg?branch=master)](https://travis-ci.org/zhouzhuojie/meteor-vue)
===============

Usage
-------
```javascript

Posts = new Meteor.Collection('posts');

var vm = new Vue({
  el: '#element-id',
  data: {
    'data1': 'data1',
    'data2': [1, 2, 3]
  }
  sync: {
    'data3': function() {
      return Posts.find();
    }
  }
});

```

API
------
```javascript
vm.$sync(key, func); // The function should return something like Posts.find() or Posts.findOne()
vm.$unsync(key);
```


LICENSE
-------
MIT
