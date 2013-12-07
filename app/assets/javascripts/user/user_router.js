HL.UserRouter = Backbone.Router.extend({
  
  initialize: function() {
    this.lines = new HL.LinesCollection();
    this.fumeHoods = new HL.FumeHoodsCollection();
    var json = $('meta[name="fumehoods"]').prop('content');
    this.fumeHoods.reset(JSON.parse(json), { parse: true });
  },
  
  routes: {
    '': 'dashboard'
  },
  
  dashboard: function() {
    console.log('route: dashboard');
    var view = new HL.DashboardView({ collection: this.lines });
    $('#hood-link').append(view.render().el);
  },
  
  filterKeys: function() {
    var json = $('meta[name="filters"]').prop('content');
    return JSON.parse(json);
  }
  
});