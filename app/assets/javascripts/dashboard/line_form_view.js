HL.LineFormView = Backbone.View.extend({
  id: 'lines-form',
  className: 'modal',
  tagName: 'form',
  template: 'line_form',
  templateData: function() {
    return { filters: router.filters.toJSON() };
  },
  
  intialize: function() {
    _.bindAll(this, 'close');
  },
  
  events: {
    'submit': 'create',
    'click .close': 'close'
  },
  
  create: function(ev) {
    ev.preventDefault();
    var json = this.$el.jsonify();
    this.collection.add({ filters: json });
    this.close();
  }
  
  
});