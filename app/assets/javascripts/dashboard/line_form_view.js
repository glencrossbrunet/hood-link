HL.LineFormView = Backbone.View.extend({
  id: 'lines-form',
  className: 'modal',
  tagName: 'form',
  template: 'line_form',
  templateData: function() {
    return { filters: router.filterKeys };
  },
  
  intialize: function() {
    _.bindAll(this, 'close');
    console.log(this.tepmateData());
  },
  
  events: {
    'submit': 'create',
    'click .close': 'close',
    'click': 'check'
  },
  
  create: function(ev) {
    ev.preventDefault();
    var json = this.$el.jsonify();
    this.collection.add({ filters: json });
    this.close();
  },
  
  check: function(ev) {
    if (ev.target == this.el) this.close(ev);
  }
  
  
});