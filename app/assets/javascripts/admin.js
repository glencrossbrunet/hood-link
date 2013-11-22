// admin manifest
//
//= require framework/framework
//= require admin/navigation_view
//= require admin/admin_router
//= require dashboard/dashboard
//= require filters/filters
//= require fume_hoods/fume_hoods
//= require members/members
//= require_self

$(function() {
  new HL.NavigationView({ el: $('#navigation') });
  window.router = new HL.AdminRouter();
  Backbone.history.start();
});