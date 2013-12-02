HL.LineView = Backbone.View.extend({
  className: 'line',
  template: 'line',
  
  events: {
    'click': 'toggle',
    'click .destroy': 'destroy'
  },
  
  toggle: function(ev) {
    ev.preventDefault();
    this.model.toggle();
    this.render();
  },
  
  destroy: function(ev) {
    ev.preventDefault();
    this.model.destroy();
    this.close(ev);
  }
});