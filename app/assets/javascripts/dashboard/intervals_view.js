HL.IntervalsView = Backbone.View.extend({
  id: 'intervals',
  className: 'row',
  template: 'intervals',
  
  initialize: function() {
    _.bindAll(this, 'setPeriod', 'datepicker', 'process');
    setTimeout(this.datepicker, 50);
  },
  
  events: {
    'period:reset': 'fetch'
  },
  
  fetch: function(begin, end) {
    this.collection.range(begin, end);
    
    var count = 0, total = this.collection.length,
      $progress = this.$('#progress'), 
      $text = this.$('#progress-text').show().text('');
    $progress.prop({ value: count, max: total });
    function progress() { 
      $progress.prop('value', ++count );
      $text.text([ count, '/', total ].join(' '));
    }
    this.listenTo(this.collection, 'fetch', progress);    
    
    this.collection.fetch().done(function() {
      $text.delay(1000).fadeOut('fast');
    });
  },
  
  process: function(dates) {
    this.trigger('period:process');
  },
  
  // choose time period
  
  setPeriod: function() {
  	var vals = $('#period').DatePickerGetDate(true);
    if (vals && vals.length) {
      this.trigger('period:reset', new Date(vals[0]), new Date(vals[1]));
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