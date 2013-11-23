_.extend(Backbone.View.prototype, {
  
  templateData: function() {
    return {};
  },
  
  render: function(optionalData) {
    if (this.children) {
      _.invoke(this.children, 'close');
      this.children = undefined;
    }
    if (this.template) {
      var data = _.result(this, 'templateData');
      if (this.model) { _.extend(data, this.model.toJSON()); }
      if (optionalData) { _.extend(data, optionalData); }
    
      this.$el.html( JST[this.template](data) );
      this.setElement(this.$el);
    }
    this._trigger([ 'hl:render' ]);
    return this;
  }
  
});