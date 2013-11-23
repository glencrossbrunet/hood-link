HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'new', 'show');
    this.collection = new Backbone.Collection();
  },
  
  events: {
    'click #lines-new': 'new'
  },
  
  new: function() {
    var view = new HL.LineFormView();
    this.show(view);
  },
  
  add: function(model) {
    
    
  },
  
  show: function(view) {
    if (this.currentView) this.currentView.close();
    this.$('#graph').html(view.render().el);
    this.currentView = view;
  }
});