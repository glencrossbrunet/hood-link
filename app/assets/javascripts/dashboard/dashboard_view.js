HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'update', 'fetch', 'graph');
    this.listenTo(this.collection, 'add', this.prepend);
    this.listenTo(this.collection, 'change:visible', this.graph);
    this.listenTo(this.collection, 'change:data remove', this.maybeGraph);
    this.collection.fetch().done(this.fetch);
  },
  
  events: {
    'click #lines-new': 'new'
  },
  
  new: function(ev) {
    ev.preventDefault();
    var view = new HL.LineFormView({ collection: this.collection });
    $('#dashboard').prepend(view.render().el);
  },
  
  prepend: function(model) {
    var view = new HL.LineView({ model: model });
    this.add(view, '#lines');
  },
  
  update: function(data) {
    router.fumeHoods.each(function(fumeHood) {
      var externalId = fumeHood.get('external_id');
      var samples = data[externalId] || [];
      fumeHood.set('samples', samples);
    });
    this.collection.each(function(model) {
      setTimeout(model.setData, Math.round(Math.random() * 20));
    });
  },
  
  fetch: function() {
    $.get('/fume_hoods/samples').done(this.update);
  },
  
  graph: _.debounce(function() {    
    var $graph = $('#graph');
    var active = this.collection.where({ visible: true });
        
    var data = _.map(active, function(line) {
      var records = line.get('data');
      records.name = line.get('name');
      return records;
    });
    var layout = {
      xaxis: { tickangle: 45, nticks: 12 },
      yaxis: { zeroline: false}
    };
    $('.graph-area', $graph).fadeOut('fast', function() {
      $graph.find('.graph-area').remove();
      $graph.append('<div class="graph-area"></div>');
      Plotly.plot($graph.find('.graph-area')[0], data, layout);
    });
  }, 250, false),
  
  maybeGraph: function(model) {
    if (model.get('visible')) {
      this.graph();
    }
  }
});