// user manifest
//
//= require framework/framework
//= require filters/filters_collection
//= require fume_hoods/fume_hood_model
//= require fume_hoods/fume_hoods_collection
//= require user/user_router
//= require dashboard/dashboard
//= require_self

$(function() {  
  window.router = new HL.UserRouter();  
  Backbone.history.start();  
});