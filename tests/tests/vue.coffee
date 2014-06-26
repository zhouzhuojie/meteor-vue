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
      isVueMethodReady = _.every [
        v.$$syncDict?
        v.$sync?
        v.$unsync?
      ]
      emit 'isVueMethodReady', isVueMethodReady
    client.once 'isVueMethodReady', (isVueMethodReady) ->
      assert.equal isVueMethodReady, true
      done()

  test 'Sync Session reactive', (done, server, client) ->
    client.eval ->
      Session.set 'sessionPost', '1'
      waitForDOM '#post', ->
        window.v = new Vue
          sync:
            sessionPost: ->
              Session.get 'sessionPost'
      Session.set 'sessionPost', '2'
      Deps.flush()
      Deps.afterFlush ->
        expectTrue = _.isEqual window.v.sessionPost, Session.get('sessionPost')
        emit 'client-get-sessionPost', expectTrue
    client.once 'client-get-sessionPost', (expectTrue) ->
      assert expectTrue
      done()

  test 'Sync findOne()', (done, server, client) ->
    server.eval ->
      Posts.insert
        _id: 'xxx'
        title: '1'
    client.eval ->
      emitPost = (post) ->
        waitForDOM '#post', ->
          window.v = new Vue
            el: '#post'
            sync:
              post: ->
                Posts.findOne 'xxx'
            computed:
              postTitleWordCount: ->
                @.post?.title?.length
        Deps.flush()
        Deps.afterFlush ->
          expectTrue = _.every [
            not _.isArray window.v.post
            _.isEqual post, window.v.post
            $("div#post:contains('#{post._id}')").length
            _.isEqual window.v.postTitleWordCount, post.title.length
          ]
          emit 'client-get-post', expectTrue
      xxx = Posts.findOne('xxx')
      if xxx?
        emitPost(xxx)
      else
        Posts.find('xxx').observe
          added: emitPost
    client.once 'client-get-post', (expectTrue) ->
      assert expectTrue
      done()
