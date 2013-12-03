HL.UserRouter = Backbone.Router.extend({
  
  initialize: function() {
    this.fumeHoods = new HL.FumeHoodsCollection();
    this.fumeHoods.fetch();    
  },
  
  routes: {
    '': 'dashboard'
  },
  
  dashboard: function() {
    console.log('route: dashboard');
    var view = new HL.DashboardView();
    $('#hood-link').append(view.render().el);
  },
  
  filterKeys: function() {
    var json = $('meta[name="filters"]').prop('content');
    return JSON.parse(json);
  }
  
});