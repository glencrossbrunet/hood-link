HL.LineModel = Backbone.Model.extend({
  
  initialize: function() {
    this.on('change:fumeHoods', this.setData, this);
    
    this.on('change:filters', this.setFumeHoods, this);
    this.trigger('change:filters');
  },
  
  defaults: function() {
    return { 
      name: '',
      filters: {},
      fumeHoods: new Backbone.Collection,
      visible: false,
      data: []
    };
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
    var samples = _.invoke(this.get('fumeHoods'), 'get', 'samples');
    
    var times = _.first(samples).pluck('sampled_at');
    
    // YYYY-MM-DDTHH:MM:SS.SSSSZ -> MM-DD HH:MM:SS
    var xs = _.map(times, function(time) {
      return time.substring(6, 10) + ' ' + time.substring(12, 8);
    });
    
    var values = _.invoke(samples, 'pluck', 'value');
    var avgs = _.map(_.zip.apply(_, values), _.avg);
    var ys = _.compact(avgs);
    var data = { x: xs.slice(xs.length - ys.length), y: ys };
        
    this.set('data', data);
  },
  
  toggle: function() {
    this.set('visible', !this.get('visible'));
  }
  
  
});