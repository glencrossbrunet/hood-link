HL.RoleView = Backbone.View.extend({
  template: 'role',
  
  intialize: function() {
    _.bindAll(this, 'destroy');
  },
    
  events: {
    'click [data-action="destroy"]': 'destroy'
  },
  
  destroy: function(ev) {
    ev.preventDefault();
    this.model.destroy().done(this.close.bind(this));
  }
});