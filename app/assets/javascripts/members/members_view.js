HL.MembersView = Backbone.View.extend({
  id: 'members',
  template: 'members',
  
  initialize: function() {
    _.bindAll(this, 'addRole', 'newRole', 'renderRoles');
    this.collection.on('add', this.addRole);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-role': 'newRole',
    'hl:render': 'renderRoles'
  },
  
  addRole: function(role) {
    var view = new HL.RoleView({ model: role, parent: this });
    this.$('#roles').prepend(view.render().el);
  },
  
  newRole: function(ev) {
    ev.preventDefault();
    var data = $('#new-role').jsonify();
    this.collection.create(data, { wait: true });
  },
  
  renderRoles: function() {
    this.collection.each(this.addRole);
  }
  
});