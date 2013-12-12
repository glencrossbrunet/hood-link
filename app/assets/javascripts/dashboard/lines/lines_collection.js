HL.LinesCollection = Backbone.Collection.extend({
  url: '/lines',
  
  model: HL.LineModel,
  
  crunch: function() {
    this.invoke('crunch');
    this.trigger('period:crunch');
  },
  
  listen: function(fumeHoods) {
    this.listenTo(fumeHoods, 'period:process', this.crunch);
  }
});