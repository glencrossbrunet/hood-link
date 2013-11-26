HL.LineModel = Backbone.Model.extend({
  
  fumeHoods: function() {
    var filters = this.get('filters');
    
    var fumeHoods = router.fumeHoods.filter(function(hood) {
      var data = hood.get('data');
      return _.every(filters, function(value, key) {
        return data.get(key) === value;
      });
    });
    
    return fumeHoods;
  }
  
});