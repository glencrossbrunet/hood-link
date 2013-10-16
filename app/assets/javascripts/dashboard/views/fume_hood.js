HL.FumeHoodView = Backbone.View.extend({
  tagName: 'li',
  className: 'fume-hood',
  template: 'fume_hood',
  
  initialize: function() {
    _.bindAll(this, 'render');
    this.model.on('change', this.render);
  }
});