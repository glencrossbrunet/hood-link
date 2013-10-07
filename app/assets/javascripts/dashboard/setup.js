// compile JST templates

$(function() {
  $('script[type="text/template"]').each(function() {
    var $template = $(this);
    JST[$template.attr('name')] = _.template($template.html());
  });
  
  new HL.NavigationView({ el: $('#navigation') });
  
  new HL.Router();
  Backbone.history.start();
});