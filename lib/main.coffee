Vue = @Vue

p = Vue.prototype

p.__init = p._init

p._init = (option) ->
  @$$syncDict = {}
  @__init _.omit option, 'sync'
  if option?.sync?
    _.each option.sync, (rxFunc, key) =>
      @$sync key, rxFunc

p.$unsync = (key) ->
  @$$syncDict[key]?.stop?()

p.$sync = (key, rxFunc) ->
  @$unsync key
  if _.isFunction rxFunc
    @$$syncDict[key] = Tracker.autorun =>
      val = rxFunc()
      if val?
        if val.fetch?
          @$set key, val.fetch()
        else
          @$set key, val

Vue.config.delimiters = ['[[', ']]']
