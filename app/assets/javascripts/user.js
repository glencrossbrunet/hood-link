// user manifest
//
//= require framework/framework
//= require user/user_router
//= require dashboard/dashboard
//= require_self

$(function() {  
  window.router = new HL.UserRouter();  
  Backbone.history.start();  
});