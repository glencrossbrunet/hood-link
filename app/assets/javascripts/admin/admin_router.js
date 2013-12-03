HL.AdminRouter = Backbone.Router.extend({
  
  initialize: function() {
    this.filters = new HL.FiltersCollection();
    this.fumeHoods = new HL.FumeHoodsCollection();
    this.roles = new HL.RolesCollection();
    var json = $('meta[name="fumehoods"]').prop('content');
    this.fumeHoods.reset(JSON.parse(json), { parse: true });
  },
  
  routes: {
    '': 'redirect',
    'dashboard': 'dashboard',
    'filters': 'filters',
    'fume-hoods': 'fumeHoods',
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
    this.show(new HL.FiltersView({ collection: this.filters }));
  },
  
  fumeHoods: function() {
    console.log('route: fume-hoods');
    $('a[href="fume-hoods"]').addClass('selected');
    this.show(new HL.FumeHoodsView({ collection: this.fumeHoods }));
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
  },
  
  filterKeys: function() {
    if (this.filters.length) {
      return this.filters.pluck('key');
    } else {
      var json = $('meta[name="filters"]').prop('content');
      return JSON.parse(json);
    }
  }
  
});