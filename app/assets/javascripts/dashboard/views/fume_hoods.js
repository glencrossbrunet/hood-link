HL.FumeHoodsView = Backbone.View.extend({
  id: 'fume-hoods',
  template: 'fume_hoods',
  
  initialize: function() {
    _.bindAll(this, 'add', 'renderCollection');
    this.collection.on('add', this.add);
    this.collection.fetch();
  },
  
  events: {
    'hl:render': 'renderCollection'
  },
  
  add: function(model) {
    var view = new HL.FumeHoodView({ model: model, parent: this });
    console.log(view);
    this.$('#fume-hoods-collection').prepend(view.render().el);
  },
  
  renderCollection: function() {
    this.collection.each(this.add);
  }
  
});