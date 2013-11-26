HL.RoleView = Backbone.View.extend({
  template: 'role',
  tagName: 'li',
  
  initialize: function() {
    _.bindAll(this, 'destroy');
    this.listenTo(this.model, 'remove', this.close);
  },
    
  events: {
    'click [data-action="destroy"]': 'destroy'
  },
  
  destroy: function(ev) {
    ev.preventDefault();
    this.model.destroy();
  }
});