HL.Router = Backbone.Router.extend({
  
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
  },
  
  filters: function() {
    console.log('route: filters');
  }
  
});