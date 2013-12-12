HL.IntervalsModel = Backbone.Model.extend({
  idAttribute: 'date',
  
  defaults: {
    date: '',
    data: null
  },
  
  fetch: function() {
    var data = this.get('data');
    if (data) return data;
        
    var self = this;
    var promise = $.get('/samples', { date: this.get('date') });
    promise.done(function(data) { self.set('data', data); });
    return promise;
  }
});