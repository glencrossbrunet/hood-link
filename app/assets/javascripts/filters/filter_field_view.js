HL.FilterFieldView = Backbone.View.extend({
  template: 'filter_field',
  tagName: 'li',
  
  initialize: function() {
    _.bindAll(this, 'destroy', 'close');
    this.model.on('remove', this.close);
  },
  
  events: {
    'click [data-action="destroy"]': 'destroy'
  },
  
  destroy: function(ev) {
    ev.preventDefault();
    this.model.destroy();
  }
});