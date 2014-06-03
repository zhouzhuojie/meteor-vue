assert = require 'assert'

suite 'Meteor-Vue', ->

  test 'Environment Setup', (done, server, client) ->
    client.eval ->
      v = new Vue()
      emit 'isVueExist', v?
    client.once 'isVueExist', (isVueExist) ->
      assert.equal isVueExist, true
      done()

  test 'Methods ready', (done, server, client) ->
    client.eval ->
      v = new Vue()
      isVueMethodReady = _.any [
        v.$$syncDict?
        v.$sync?
        v.$unsync?
      ]
      emit 'isVueMethodReady', isVueMethodReady
    client.once 'isVueMethodReady', (isVueMethodReady) ->
      assert.equal isVueMethodReady, true
      done()

  test 'Sync findOne()', (done, server, client) ->
    server.eval ->
      Posts.insert
        _id: 'xxx'
        title: '1'
    client.eval ->
      waitForDOM '#post', ->
        window.v = new Vue
          el: '#post'
          sync:
            post: ->
              Posts.findOne 'xxx'
      Posts.find('xxx').observe
        added: (post) ->
          Meteor.setTimeout(
            ->
              expectTrue = _.any [
                not _.isArray window.v.post
                _.isEqual post, window.v.post
                $("div#post:contains('#{post._id}')").length
              ]
              emit 'client-get-post', expectTrue
            , 100
          )
    client.once 'client-get-post', (expectTrue) ->
      assert expectTrue
      done()

  test 'Sync find()', (done, server, client) ->
    server.eval ->
      Posts.insert
        _id: 'yyy'
        title: '2'
    client.eval ->
      waitForDOM '#posts', ->
        window.v = new Vue
          el: '#posts'
          sync:
            posts: ->
              Posts.find()
      Posts.find().observe
        added: (post) ->
          Meteor.setTimeout(
            ->
              p = _.findWhere window.v.posts, {_id: post._id}
              expectTrue = _.any [
                _.isArray window.v.posts
                _.isEqual post, p
                $("div#posts:contains('#{post._id}')").length
              ]
              emit 'client-get-posts', expectTrue
            , 100
          )
    client.once 'client-get-posts', (expectTrue) ->
      assert expectTrue
      done()

  test 'Sync find().fetch()', (done, server, client) ->
    server.eval ->
      Posts.insert
        _id: 'zzz'
        title: '3'
    client.eval ->
      waitForDOM '#postsFetch', ->
        window.v = new Vue
          el: '#postsFetch'
          sync:
            postsFetch: ->
              Posts.find().fetch()
      Posts.find().observe
        added: (post) ->
          Meteor.setTimeout(
            ->
              p = _.findWhere window.v.postsFetch, {_id: post._id}
              expectTrue = _.any [
                _.isArray window.v.postsFetch
                _.isEqual post, p
                $("div#postsFetch:contains('#{post._id}')").length
              ]
              emit 'client-get-postsFetch', expectTrue
            , 100
          )
    client.once 'client-get-postsFetch', (expectTrue) ->
      assert expectTrue
      done()

  test 'Unsync', (done, server, client) ->
    server.eval ->
      Posts.insert
        _id: 'bestPost'
        title: 'I am the best post'
    client.eval ->
      count = 0
      waitForDOM '#bestPost', ->
        window.v = new Vue
          el: '#bestPost'
          sync:
            bestPost: ->
              Posts.findOne 'bestPost'
      Posts.find('bestPost').observe
        added: (post) ->
          Meteor.setTimeout(
            ->
              expectTrue = _.any [
                not _.isArray window.v.bestPost
                _.isEqual post, window.v.bestPost
                $("div#bestPost:contains('#{post._id}')").length
              ]
              emit 'before-update', expectTrue
            , 100
          )
        changed: (newPost) ->
          if count is 0
            count = count + 1
            expectTrue = _.any [
              not window.v.$$syncDict['bestPost']?
              not _.isArray window.v.bestPost
              not _.isEqual newPost, window.v.bestPost
              $("div#bestPost:contains('#{newPost._id}')").length
            ]
            emit 'after-update', expectTrue
    client.once 'before-update', (expectTrue) ->
      assert expectTrue
      client.eval ->
        window.v.$unsync 'bestPost'
        Posts.update 'bestPost', {$set: {title: post.title + '!'}}
    client.once 'after-update', (expectTrue) ->
      assert expectTrue
      done()
