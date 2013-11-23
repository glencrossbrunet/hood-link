HL.UserRouter = Backbone.Router.extend({
  
  initialize: function() {
    this.filters = new HL.FiltersCollection();
    this.filters.fetch();
    // this.fumeHoods = new HL.FumeHoodsCollection();
    // this.roles = new HL.RolesCollection();
  },
  
  routes: {
    '': 'dashboard'
  },
  
  dashboard: function() {
    console.log('route: dashboard');
    var view = new HL.DashboardView();
    $('#hood-link').append(view.render().el);
  }
  
});