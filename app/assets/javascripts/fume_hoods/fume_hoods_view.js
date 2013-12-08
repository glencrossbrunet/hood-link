HL.FumeHoodsView = Backbone.View.extend({
  id: 'fume-hoods',
  template: 'fume_hoods',
  
  initialize: function() {
    _.bindAll(this, 'append', 'renderCollection');
    this.listenTo(this.collection, 'add', this.append);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-fume-hood': 'create',
    'change #csv-upload': 'upload',
    'render:after': 'renderCollection'
  },
  
  create: function(ev) {
    ev.preventDefault();
    var data = $('#new-fume-hood').jsonify();
    this.collection.create(data, { wait: true });
  },
  
  upload: function(ev) {
    var $field, file, reader, collection = this.collection;
    
    $field = $('#csv-upload');
    file = $field.prop('files')[0];
    reader = new FileReader();
    reader.onload = function() {
      var xhr = $.post('/fume_hoods/upload', { csv: reader.result });
      xhr.done(function() {
        collection.fetch().done(function() {
          $field.parent('form').trigger('reset');
        });
      });
    };
    reader.readAsText(file);
  },
  
  append: function(model) {
    var view = new HL.FumeHoodView({ model: model });
    return this.add(view, 'append', '#fume-hoods-collection');
  },
  
  renderCollection: function() {
    this.collection.each(this.append);
  }
  
});