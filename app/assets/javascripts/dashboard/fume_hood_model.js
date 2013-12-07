HL.FumeHoodModel = Backbone.Model.extend({
  
  defaults: function() {
    return { 
      external_id: '',
      data: new Backbone.Model,
      samples: []
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
    return _.isEmpty(params) || _.all(params, this.testParam, this);
  },
  
  testParam: function(value, key) {
    var data = this.get('data');
    
    if (!value) return true;
    if (value === 'x' || value === 'X') return !data.get(key);
    if (value === '*') return !!data.get(key);
    return data.get(key) == value;
  }
});