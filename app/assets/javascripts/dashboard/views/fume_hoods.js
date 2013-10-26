HL.FumeHoodsView = Backbone.View.extend({
  id: 'fume-hoods',
  template: 'fume_hoods',
  
  initialize: function() {
    _.bindAll(this, 'add', 'renderCollection');
    this.collection.on('add', this.add);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-fume-hood': 'create',
    'hl:render': 'renderCollection'
  },
  
  create: function(ev) {
    ev.preventDefault();
    var data = $('#new-fume-hood').jsonify();
    this.collection.create(data, { wait: true });
  },
  
  add: function(model) {
    var view = new HL.FumeHoodView({ model: model, parent: this });
    this.$('#fume-hoods-collection').prepend(view.render().el);
  },
  
  renderCollection: function() {
    this.collection.each(this.add);
  }
  
});