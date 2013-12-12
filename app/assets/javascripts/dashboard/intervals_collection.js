HL.IntervalsCollection = Backbone.Collection.extend({
  model: HL.IntervalsModel,

  ensure: function(date) {
    date = this.formatDate(date);
    if (!this.get(date)) {
      this.add(new this.model({ date: date }));
    }
    return this.get(date);
  },
  
  range: function(start, stop) {
  	var day = 1000 * 60 * 60 * 24;
    var nums = _.range(+start, +stop + day, day);
    this.reset();
    return _.map(nums, this.ensure, this);
  },
  
  formatDate: function(num) {
    var date = new Date(num);
    return [ date.getFullYear(), date.getMonth() + 1, date.getDate() ].join('-');
  },
  
  fetch: function() {
    var promise = $.when.apply($, this.invoke('fetch'));
    var self = this;
    promise.done(function() { 
      self.trigger('period:fetch'); 
    });
    return promise;
  }
});