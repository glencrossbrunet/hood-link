HL.FumeHoodFormView = Backbone.View.extend({
  tagName: 'form',
  className: 'fume-hood-form',
  template: 'fume_hood_form',
  
  events: {
    'submit': 'save',
    'click .update-display': 'updateDisplay'
  },
  
  save: function(ev) {
    ev.preventDefault();
    var data = this.$el.jsonify();
    this.model.get('data').set(data);
    this.model.save();
  },
  
  updateDisplay: function(ev) {
    var button = this.$('.update-display'), id = this.model.get('id');
    button.prop('disabled', true);
    $.get('/fume_hoods/' + id + '/display.json').done(function() {
      setTimeout(function() {
        button.prop('disabled', false);
      }, 500);
    });
  }
  
});