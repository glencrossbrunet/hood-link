HL.MembersView = Backbone.View.extend({
  id: 'members',
  template: 'members',
  
  initialize: function() {
    _.bindAll(this, 'addRole', 'newRole');
    this.collection.on('add', this.addRole);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-role': 'newRole'
  },
  
  addRole: function(role) {
    var view = new HL.RoleView({ model: role, parent: this });
    this.$('#roles').prepend(view.render().el);
  },
  
  newRole: function(ev) {
    ev.preventDefault();
    var data = $('#new-role').jsonify();
    this.collection.create(data, { wait: true });
  }
  
});