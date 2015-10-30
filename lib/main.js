// Object to be exported
Vue = this.Vue;
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

    // Default init without sync object
    this.__init(_.omit(option, 'sync'));

    // If option.sync exists
    if (option) {
        if(option.sync) {
            var self = this;

            // On every object use the $sync function to get the value
            _.each(option.sync, function(rxFunc, key) {
                self.$sync(key, rxFunc);
            });
        }
    }
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
                if (val.fetch != null && typeof val.fetch === 'function'){
                    return self.$set(key, val.fetch());
                } else {
                    return self.$set(key, val);
                }
            }
        });
    }
};

Vue.config.delimiters = ['[[', ']]'];
