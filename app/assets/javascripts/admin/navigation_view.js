HL.NavigationView = Backbone.View.extend({  
  events: {
    'click a': 'navigate'
  },
  
  navigate: function(ev) {
    ev.preventDefault();
    this.$('a').removeClass('selected');
    
    var href = $(ev.target).attr('href');
    Backbone.history.navigate(href, true);
  }  
});