HL.FiltersView = Backbone.View.extend({
  id: 'filters',
  template: 'filters',
  
  initialize: function() {
    _.bindAll(this, 'addFilter', 'newFilter');
    this.collection.on('add', this.addFilter);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-filter': 'newFilter',
    'hl:render': 'renderFilters'
  },
  
  addFilter: function(filter) {
    var view = new HL.FilterFieldView({ model: filter, parent: this });
    this.$('#new-filter')[0].reset();
    this.$('#filter-fields').prepend(view.render().el);
  },
  
  newFilter: function(ev) {
    ev.preventDefault();
    var data = this.$('#new-filter').jsonify();
    this.collection.create(data, { wait: true });
  },
  
  renderFilters: function() {
    this.collection.each(this.addFilter);
  }
});