HL.RoleView = Backbone.View.extend({
  template: 'role',
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