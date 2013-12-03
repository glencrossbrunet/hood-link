HL.UserRouter = Backbone.Router.extend({
  
  initialize: function() {
    var json = $('meta[name="fumehoods"]').prop('content');
    this.fumeHoods = new HL.FumeHoodsCollection(JSON.parse(json));
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