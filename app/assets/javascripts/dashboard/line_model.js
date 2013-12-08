HL.LineModel = Backbone.Model.extend({
  initialize: function() {
    _.bindAll(this, 'setData');
    this.on('add', this.setFumeHoods, this);
  },
  
  defaults: function() {
    return { 
      name: '',
      filters: {},
      fumeHoods: [],
      visible: false,
      data: []
    };
  },
  
  toJSON: function() {
    return _.pick(this.attributes, 'name', 'filters', 'visible');
  },
  
  setFumeHoods: function() {
    var filters = this.get('filters');
    
    var fumeHoods = router.fumeHoods.select(function(fumeHood) {
      return fumeHood.test(filters);
    });
    return this.set('fumeHoods', fumeHoods);
  },
  
  /*
  data = [
    { x: [], y: [], opacity: 0.5, marker: { size: 12, symbol: 'circle' } },
    { x: [], y: [] }
  ]
  */
  
  setData: function() {
    var fumeHoods = this.get('fumeHoods');
    var allSamples = _.invoke(fumeHoods, 'get', 'samples');
    
    var times = _.pluck(allSamples[0], 'sampled_at');
    
    var xs = _.map(times, this.formatTime);
    
    var values = _.map(allSamples, function(samples) {
      return _.pluck(samples, 'value');
    });
    var avgs = _.map(_.zip.apply(_, values), _.avg);
    var ys = _.compact(avgs);
    var data = { x: xs.slice(xs.length - ys.length), y: ys };
    
    this.set('data', data);
  },
  
  // YYYY-MM-DDTHH:MM:SS.SSSSZ -> MM-DD HH:MM:SS
  formatTime: function(time) {
    return time.substring(6, 10) + ' ' + time.substring(12, 8);
  },
  
  toggle: function() {
    this.set('visible', !this.get('visible'));
    return this;
  }
  
  
});