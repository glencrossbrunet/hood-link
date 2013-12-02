HL.FumeHoodView = Backbone.View.extend({
  tagName: 'li',
  className: 'fume-hood',
  template: 'fume_hood',
  
  templateData: function() {
    var data = this.model.toJSON();
    data.filters = router.filterKeys();
    return data;
  },
  
  initialize: function() {
    _.bindAll(this, 'render', 'close');
    this.listenTo(this.model, 'change', this.render);
  },
  
  events: {
    'click': 'toggle'
  },
  
  toggle: function(ev) {
    if (ev) ev.preventDefault();
    
    if (this.form) {
      this.form.close();
      this.form = null;
    } else {
      this.form = new HL.FumeHoodFormView({ model: this.model });
      this.$el.after(this.form.render({ filters: router.filterKeys() }).el);      
    }
  }
});