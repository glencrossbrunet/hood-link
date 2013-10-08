HL.MembersView = Backbone.View.extend({
  id: 'members',
  template: 'members',
  
  initialize: function() {
    _.bindAll(this, 'addRole');
    this.collection.on('add', this.addRole);
    this.collection.fetch();
  },
  
  addRole: function(role) {
    var view = new HL.RoleView({ model: role, parent: this });
    this.$('#roles').append(view.render().el);
  }
  
});