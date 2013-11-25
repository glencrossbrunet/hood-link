HL.LinesCollection = Backbone.Collection.extend({
  
  xAxis: function() {
    return _.range(0, 10, 1);
  },
  
  toGraphData: function() {
    var x = this.xAxis();
    
    var y1 = _.map(x, function(v) { return Math.sin(v) * 10; });
    var y2 = _.map(x, function(v) { return Math.cos(v) * 10; });
    
    var data = [
      { x: x, y: y1 },
      { x: x, y: y2 }
    ];
    
    return data;
  }
  
});