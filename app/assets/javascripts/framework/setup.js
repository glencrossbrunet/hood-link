$(function() {
  
  // CSRF Protection
  
  var csrf = $('meta[name=csrf-token]').attr('content');

  $('body').on('ajaxSend', function(element, xhr, request) {
    if (request.type === 'POST') {
      xhr.setRequestHeader('X-CSRF-Token', csrf);
    }
  });
  
  // compile JST templates
  
  $('script[type="text/template"]').each(function() {
    var $template = $(this);
    JST[$template.attr('name')] = _.template($template.html());
  });
});