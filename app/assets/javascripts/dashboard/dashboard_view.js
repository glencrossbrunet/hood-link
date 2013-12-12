HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'update', 'graph', 'listen');
  },
  
  events: {
    'click #lines-new': 'new',
    'render:after': 'renderChildren'
  },
  
  listen: function() {
    this.add(new HL.IntervalsView({ collection: router.intervals }), 'prepend', '#graph');
    this.listenTo(this.collection, 'period:crunch change:visible', this.graph);
    this.listenTo(this.collection, 'change:data remove', this.maybeGraph);
  },
  
  // managing lines
  
  new: function(ev) {
    ev.preventDefault();
    var view = new HL.LineFormView({ collection: this.collection });
    $('#dashboard').prepend(view.render().el);
  },
  
  prepend: function(model) {
    var view = new HL.LineView({ model: model });
    this.add(view, '#lines');
  },
  
  renderChildren: function() {
    this.listenTo(this.collection, 'add', this.prepend);
    this.collection.each(this.prepend, this);
    if (this.collection.length == 0) {
      this.collection.fetch().done(this.listen);
    } else {
      this.listen();
    }    
  },
  
  // graphing
  
  update: function() {
    this.collection.each(function(model) {
      setTimeout(model.setData, Math.round(Math.random() * 20));
    });
    this.graph();
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
    $('.graph-area', $graph).fadeOut('slow', function() {
      $graph.find('.graph-area').remove();
      $graph.append('<div class="graph-area"></div>');
      Plotly.plot($graph.find('.graph-area')[0], data, layout);
    });
  }, 250, false),
  
  maybeGraph: function(model) {
    if (model.get('visible')) { this.graph(); }
  }
  
});