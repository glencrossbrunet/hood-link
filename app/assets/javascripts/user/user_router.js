HL.UserRouter = Backbone.Router.extend({
  
  initialize: function() {
    this.fumeHoods = new HL.FumeHoodsCollection();
    this.fumeHoods.fetch();
    
    var json = $('meta[name="filters"]').prop('content');
    this.filterKeys = JSON.parse(json);
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