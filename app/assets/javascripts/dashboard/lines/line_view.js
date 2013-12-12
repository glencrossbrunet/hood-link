HL.LineView = Backbone.View.extend({
  className: 'line',
  template: 'line',
  
  initialize: function() {
    _.bindAll(this, 'close');
  },
  
  events: {
    'click': 'toggle',
    'click .destroy': 'destroy'
  },
  
  toggle: function(ev) {
    ev.preventDefault();
    this.model.toggle().save();
    this.render();
  },
  
  destroy: function(ev) {
    ev.preventDefault();
    console.log(this.model);
    this.model.destroy().done(this.close);
  }
});