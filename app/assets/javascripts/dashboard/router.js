HL.Router = Backbone.Router.extend({
  
  initialize: function() {
    this.roles = new HL.RolesCollection();
  },
  
  routes: {
    '': 'redirect',
    'dashboard': 'dashboard',
    'filters': 'filters',
    'members': 'members'
  },
  
  redirect: function() {
    Backbone.history.navigate('dashboard', true);
  },
  
  dashboard: function() {
    console.log('route: dashboard');
    $('a[href="dashboard"]').addClass('selected');
    this.show(new HL.DashboardView());
  },
  
  
  filters: function() {
    console.log('route: filters');
    $('a[href="filters"]').addClass('selected');
    this.show(new HL.FiltersView());
  },
  
  members: function() {
    console.log('route: members');
    $('a[href="members"]').addClass('selected');
    this.show(new HL.MembersView({ collection: this.roles }));
  },

  
  // helper methods
  
  show: function(view) {
    if (this.currentView) this.currentView.close();
    $('#hood-link').append(view.render().el);
    this.currentView = view;
  }
  
});