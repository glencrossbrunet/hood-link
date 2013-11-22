HL.RoleModel = Backbone.Model.extend({
  idAttribute: 'email',
  defaults: {
    type: 'member',
    email: ''
  }
});