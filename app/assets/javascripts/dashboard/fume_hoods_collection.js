HL.FumeHoodsCollection = Backbone.Collection.extend({
  url: '/fume_hoods',
  model: HL.FumeHoodModel,
  comparator: function(model) {
    var parts = model.get('external_id').split('-');
    return _.map(parts, function(part) {
      return isNaN(part) ? part : +part;
    });
  } 
});