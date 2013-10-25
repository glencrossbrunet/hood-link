HL.FumeHoodFormView = Backbone.View.extend({
  tagName: 'form',
  className: 'fume-hood-form',
  template: 'fume_hood_form',
  
  events: {
    'submit': 'save'
  },
  
  save: function(ev) {
    ev.preventDefault();
    this.model.get('data').set(this.$el.jsonify());
    this.model.save();
  }
  
});

HL.FumeHoodView = Backbone.View.extend({
  tagName: 'li',
  className: 'fume-hood',
  template: 'fume_hood',
  
  initialize: function() {
    _.bindAll(this, 'render');
    this.model.on('change', this.render);
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
      this.$el.after(this.form.render().el);      
    }
  }
});