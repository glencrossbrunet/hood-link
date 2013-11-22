HL.RolesCollection = Backbone.Collection.extend({
  model: HL.RoleModel,
  url: '/roles'  
});