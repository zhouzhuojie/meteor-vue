Vue = @Vue

p = Vue.prototype

p.__init__ = p._init

p._init = (option) ->
    @$$syncDict = {}
    @__init__ _.omit option, 'sync'
    if option?.sync?
      _.each option.sync, (resFunc, key) =>
        @$sync key, resFunc

p.$unsync = (key) ->
    @$$syncDict[key]?.stop?()

p.$sync = (key, resFunc) ->
    @$unsync key
    if _.isFunction resFunc
      @$$syncDict[key] = Deps.autorun =>
        val = resFunc()
        if val?
          if val.fetch?
            @$set key, val.fetch()
          else
            @$set key, val

Vue.config.delimiters = ['[[', ']]']
