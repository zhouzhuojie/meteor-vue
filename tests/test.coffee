Posts = new Meteor.Collection('_test_posts')

if Meteor.isServer
  Meteor.startup ->
    Posts.remove({})

if Meteor.isClient

  v = new Vue
    sync:
      'post': ->
        Posts.findOne 'xxx'
      'posts': ->
        Posts.find()
      'postsFetch': ->
        Posts.find().fetch()

  Tinytest.add 'Vue - test environment', (test) ->
    test.isTrue Vue?

  Tinytest.add 'Vue - test all methods existence', (test) ->
    pass = _.any [
      v.$sync?
      v.$unsync?
      v.$$syncDict?
    ]
    test.isTrue pass

  Tinytest.addAsync 'Vue - test findOne', (test, next) ->
    post = {_id: 'xxx', title: 1}
    Posts.insert post, (err, res) ->
      test.isFalse _.isArray v.post
      p = v.post
      test.equal p, post
      next()

  Tinytest.addAsync 'Vue - test find', (test, next) ->
    post = {_id: 'xxx', title: 1}
    Posts.insert post, (err, res) ->
      test.isTrue _.isArray v.posts
      p = _.findWhere v.posts, {_id: 'xxx'}
      test.equal p, post
      next()

  Tinytest.addAsync 'Vue - test find and fetch', (test, next) ->
    post = {_id: 'xxx', title: 1}
    Posts.insert post, (err, res) ->
      test.isTrue _.isArray v.postsFetch
      p = _.findWhere v.postsFetch, {_id: 'xxx'}
      test.equal p, post
      next()

  Tinytest.addAsync 'Vue - test $sync function', (test, next) ->
    v.$sync 'bestPost', ->
      Posts.findOne 'bestPost'
    post = {_id: 'bestPost', title: 'I am the best post.'}
    Posts.insert post, (err, res) ->
      test.isFalse _.isArray v.bestPost
      test.equal v.bestPost, post
      next()

  Tinytest.addAsync 'Vue - test $unsync function', (test, next) ->
    v.$unsync 'bestPost'
    post = {_id: 'bestPost', title: 'I am the best post, and I changed!'}
    Posts.update 'bestPost', {$set: {title: post.title}}, (err, res) ->
      test.isFalse _.isArray v.bestPost
      test.notEqual v.bestPost, post
      next()
