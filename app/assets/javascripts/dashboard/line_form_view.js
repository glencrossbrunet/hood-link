HL.LineFormView = Backbone.View.extend({
  tagName: 'form',
  template: 'line_form',
  templateData: function() {
    return { 
      filters: router.filters.toJSON()
    };
  },
  
  events: {
    'submit': 'create'
  },
  
  create: function(ev) {
    ev.preventDefault();
    var json = this.$el.jsonify();
    console.log(json);
  }
  
  
});