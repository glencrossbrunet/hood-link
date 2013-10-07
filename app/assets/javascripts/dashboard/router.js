HL.Router = Backbone.Router.extend({
  
  initialize: function() {
    this.roles = new HL.RolesCollection();
  },
  
  routes: {
    '': 'redirect',
    'dashboard': 'dashboard',
    'members': 'members',
    'filters': 'filters'
  },
  
  redirect: function() {
    Backbone.history.navigate('dashboard', true);
  },
  
  dashboard: function() {
    console.log('route: dashboard');
  },
  
  members: function() {
    console.log('route: members');
    this.show(new HL.MembersView({ collection: this.roles }));
  },
  
  filters: function() {
    console.log('route: filters');
  },
  
  // helper methods
  
  show: function(view) {
    if (this.currentView) this.currentView.close();
    $('#dashboard').append(view.render().el);
    this.currentView = view;
  }
  
});