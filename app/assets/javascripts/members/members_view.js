HL.MembersView = Backbone.View.extend({
  id: 'members',
  template: 'members',
  
  initialize: function() {
    _.bindAll(this, 'prepend', 'create', 'renderRoles');
    this.collection.on('add', this.prepend);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-role': 'create',
    'render:after': 'renderRoles'
  },
  
  prepend: function(model) {
    return this.add(new HL.RoleView({ model: model }), 'prepend', '#roles');
  },
  
  create: function(ev) {
    ev.preventDefault();
    var data = $('#new-role').jsonify();
    this.collection.create(data, { wait: true });
  },
  
  renderRoles: function() {
    this.collection.each(this.prepend);
  }
  
});