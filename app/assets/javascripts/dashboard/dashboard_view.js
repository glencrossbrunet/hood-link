HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'new', 'graph');
    this.collection = new HL.LinesCollection;
    this.once('ready', this.listen, this);
    
    var self = this;
    function getSamples() {
      var samples = router.fumeHoods.invoke('get', 'samples');
      if (samples.length == 0) {
        setTimeout(getSamples, 100);
        return;
      }
      var promises = _.invoke(samples, 'fetch');
      $.when.apply($, promises).done(function() { self.trigger('ready'); });
    }
    
    setTimeout(getSamples, 100);
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
    $('#graph .loading').html('ready!');
    this.listenTo(this.collection, 'add', this.prepend);
    this.listenTo(this.collection, 'change remove', this.graph);
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