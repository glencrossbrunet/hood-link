HL.FumeHoodModel = Backbone.Model.extend({
  defaults: function() {
    return { data: new Backbone.Model }
  },
  
  toJSON: function() {
    var attrs = _.clone(this.attributes);
    attrs.data = attrs.data.toJSON();
    return attrs;
  },
  
  parse: function(json, options) {
    var attributes = json;
    attributes.data = new Backbone.Model(json.data);
    return attributes;
  }
});