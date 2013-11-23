HL.FumeHoodsView = Backbone.View.extend({
  id: 'fume-hoods',
  template: 'fume_hoods',
  
  initialize: function() {
    _.bindAll(this, 'add', 'renderCollection');
    this.collection.on('add', this.add);
    this.collection.fetch();
  },
  
  events: {
    'submit #new-fume-hood': 'create',
    'change #csv-upload': 'upload',
    'hl:render': 'renderCollection'
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
  
  add: function(model) {
    var view = new HL.FumeHoodView({ model: model, parent: this });
    this.$('#fume-hoods-collection').prepend(view.render().el);
  },
  
  renderCollection: function() {
    this.collection.each(this.add);
  }
  
});