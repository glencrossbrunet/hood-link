HL.FiltersView = Backbone.View.extend({
  id: 'filters',
  template: 'filters',
  
  initialize: function() {
    _.bindAll(this, 'prepend', 'create');
    this.listenTo(this.collection, 'add', this.prepend);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-filter': 'newFilter',
    'render:after': 'renderFilters'
  },
  
  prepend: function(model) {
    var view = new HL.FilterFieldView({ model: model });
    this.$('#new-filter')[0].reset();
    return this.add(view, 'prepend', '#filter-fields');
  },
  
  create: function(ev) {
    ev.preventDefault();
    var data = this.$('#new-filter').jsonify();
    this.collection.create(data, { wait: true });
  },
  
  renderFilters: function() {
    this.collection.each(this.prepend);
  }
});