HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'new', 'graph');
    this.collection = new HL.LinesCollection;
    this.listenTo(this.collection, 'add', this.prepend);
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
  
  graph: function() {
    /*
    var data = this.collection.toGraphData();
    
    var layout = {
      showlegend: false,
      xaxis: { zeroline: false },
      yaxis: { zeroline: false }
    };
    
    Plotly.plot('#graph', data, layout);
    */    
    // Plotly.plot($('#graph .graph-area')[0], [ { x: [0, 1, 2, 3, 4, 5], y: [1, 4, 3, 6, 4, 7] } ]);
    
    
  }
});