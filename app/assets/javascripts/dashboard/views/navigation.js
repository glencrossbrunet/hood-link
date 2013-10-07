HL.NavigationView = Backbone.View.extend({  
  events: {
    'click a': 'navigate'
  },
  
  navigate: function(ev) {
    ev && ev.preventDefault && ev.preventDefault();
    var href = $(ev.target).attr('href');
    Backbone.history.navigate(href, true);
  }  
});