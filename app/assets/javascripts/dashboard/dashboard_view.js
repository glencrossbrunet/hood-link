HL.DashboardView = Backbone.View.extend({
  id: 'dashboard',
  template: 'dashboard',
  
  initialize: function() {
    _.bindAll(this, 'update', 'fetch', 'graph', 'datepicker', 'setPeriod');
    this.period = new Backbone.Model;
    this.listen();
  },
  
  events: {
    'click #lines-new': 'new',
    'render:after': 'renderCollection'
  },
  
  listen: function() {
    this.listenTo(this.period, 'change', this.fetch);
    this.listenTo(this.collection, 'add', this.prepend);
    this.listenTo(this.collection, 'change:visible', this.graph);
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
  
  renderCollection: function() {
    if (this.collection.length) {
      this.collection.each(this.prepend, this);
      setTimeout(this.datepicker, 50);
    } else {
      this.collection.fetch().done(this.datepicker);
    }
  },
  
  // graphing
  
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
  
  fetch: _.debounce(function() {
    $.get('/fume_hoods/samples', this.period.attributes).done(this.update);
  }, 1000, false),
  
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
  },
  
  // choose time period
  
  setPeriod: function() {
		var vals = $('#period').DatePickerGetDate(true);
    if (vals && vals.length) {
       this.period.set({ begin: vals[0], end: vals[1] });
    }
  },
  
  datepicker: function() {
  	var now = new Date;
  	var day = 1000 * 60 * 60 * 24;
  	var start = new Date(+now - day * 24);
  	var stop = new Date(+now - day);
    
    function showPeriod(array) {
  		var vals = $('#period').DatePickerGetDate(true) || [ '', '' ];
      start = vals[0];
      stop = vals[1];
  		$('#period-begin').text(start);
  		$('#period-end').text(stop);
    }
	
  	$('#period').DatePicker({ 
  		date: [ start, stop ], 
  		onChange: showPeriod,
      onHide: this.setPeriod,
  		onRender: function(date) {
  			return { disabled: (+date - now) / day > -1 };
  		},
  		calendars: 2,
  		mode: 'range',
  		starts: 0
  	});
    
    showPeriod();
  	this.setPeriod();
  }
});