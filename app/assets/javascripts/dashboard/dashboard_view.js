HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'new', 'add', 'graph');
    this.collection = new HL.LinesCollection;
    this.collection.on('add', this.add);
    setTimeout(this.graph, 2000);
  },
  
  events: {
    'click #lines-new': 'new'
  },
  
  new: function() {
    var view = new HL.LineFormView({ collection: this.collection });
    $('#dashboard').prepend(view.render().el);
  },
  
  add: function(model) {
    this.$('#lines').append('<div class="line active">New Line</div>');
    
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
    console.log($('#graph'));
    
    Plotly.plot('#graph', [ { x: [0, 1, 2, 3, 4, 5], y: [1, 4, 3, 6, 4, 7] } ]);
    
    
  }
});