window.JST = {};
window.HL = window.HoodLink = {};


_.mixin({
  
  sum: function(collection) {
    return _.reduce(collection, function(a, b) { return a + b; }, 0);
  },
  
  avg: function(collection) {
    var values = _.compact(collection);
    var size = _.size(values);
    if (size <= 0) return null;
    return _.sum(collection) / size;
  }
  
});