HL.LinesCollection = Backbone.Collection.extend({
  url: '/lines',
  model: HL.LineModel
});