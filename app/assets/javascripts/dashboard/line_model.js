HL.LineModel = Backbone.Model.extend({
  
  initialize: function() {
    this.on('change:filters', this.setFumeHoods, this);
    this.trigger('change:filters');
  },
  
  defaults: function() {
    return { 
      name: '',
      filters: {},
      fumeHoods: new Backbone.Collection,
      visible: false
    };
  },
  
  setFumeHoods: function() {
    var filters = this.get('filters');
    
    var fumeHoods = router.fumeHoods.select(function(fumeHood) {
      return fumeHood.test(filters);
    });
    return this.set('fumeHoods', fumeHoods);
  },
  
  toggle: function() {
    this.set('visible', !this.get('visible'));
  }
  
  
});