HL.FumeHoodModel = Backbone.Model.extend({
  defaults: function() {
    return { 
      external_id: '',
      data: new Backbone.Model
    }
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
  },
  
  test: function(params) {
    var data = this.get('data');
    return _.isEmpty(params) || _.all(params, function(value, key) {
      if (!value) return true;
      if (value === '*' && data.get(key)) return true;
      return data.get(key) == value;
    });
  }
});