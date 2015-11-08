Vue.config.delimiters = ['[[', ']]'];

Vue = Vue.extend({
    name: 'MeteorVue',
    sync: {},  
});
var p = Vue.prototype;

// Default _init backup
p.__init = p._init;

/**
 * "Overwrite" of the Vue _init function
 * @param Array option Vue options
 */
p._init = function(option) {
    // Dict
    this.$$syncDict = {};

    // Init data field to avoid warning
    option = option || {};
    option.data = option.data || {};
    option.sync = option.sync || {};

    var sync = _.extend({}, this.constructor.options.sync, option.sync);
    _.extend(option.data, sync);

    // Default init without sync object
    this.__init(_.omit(option, 'sync'));

    // If option.sync exists
    var self = this;

    // On every object use the $sync function to get the value
    _.each(sync, function(rxFunc, key) {
        self.$sync(key, rxFunc);
    });
};

// Stop the key from syncDict
p.$unsync = function(key) {
    var ref = this.$$syncDict[key];

    if (ref && typeof ref.stop === 'function'){
        ref.stop();
    }
};

// Sync key in syncDict with value = rxFunc
p.$sync = function(key, rxFunc) {
    this.$unsync(key);

    if (typeof rxFunc === 'function') {
        var self = this;

        this.$$syncDict[key] = Tracker.autorun(function(){
            var val;
            val = rxFunc.call(self);
            if (val) {
                if (typeof val.fetch === 'function'){
                    return self.$set(key, val.fetch());
                } else {
                    return self.$set(key, val);
                }
            }
        });
    }
};

