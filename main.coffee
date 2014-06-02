if typeof Package isnt "undefined"
  Vue = @Vue


class MeteorVue extends Vue

  constructor: (option) ->
    self = this
    self.$$syncDict = {}
    super _.omit option, 'sync'
    if option?.sync?
      _.each option.sync, (resFunc, key) ->
        self.$sync key, resFunc

  $sync: (key, resFunc) ->
    self = this
    self.$unsync key
    if _.isFunction resFunc
      self.$$syncDict[key] = Deps.autorun ->
        val = resFunc()
        if val?
          if val.fetch?
            self.$set key, val.fetch()
          else
            self.$set key, val
    return

  $unsync: (key) ->
    self = this
    self.$$syncDict[key]?.stop?()
    return


MeteorVue.config 'delimiters', ['[', ']']

Vue = MeteorVue
