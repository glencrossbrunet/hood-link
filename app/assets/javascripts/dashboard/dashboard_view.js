HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'update', 'fetch', 'graph');
    this.listen();
    setTimeout(this.fetch, 100);
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
  
  listen: function() {
    this.listenTo(this.collection, 'add', this.prepend);
    this.listenTo(this.collection, 'change remove', this.graph);
  },
  
  update: function(data) {
    router.fumeHoods.each(function(fumeHood) {
      var externalId = fumeHood.get('external_id');
      var samples = data[externalId] || [];
      fumeHood.set('samples', samples);
    });
    this.graph();
  },
  
  fetch: function() {
    var self = this;
    $.get('/fume_hoods/samples').done(this.update);
  },
  
  graph: function() {
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
        
  }
});