// Templates
//
//= require_tree ./templates

Handlebars.registerHelper('basePath', function() {
  return basePath;
});

Handlebars.registerHelper('t', function(key, options) {
  return I18n.t(key, options.hash);
});

Handlebars.registerHelper('path_to', function(route) {
  var options = _.last(arguments);
  var args = _.toArray(arguments).slice(1, -1).concat(options.hash)
  return encodeURI(Routes[route].apply(this, args));
});

Handlebars.registerHelper('link_to', function(text, route) {
  var options = _.last(arguments);
  var args = _.toArray(arguments).slice(2, -1).concat(options.hash)
  return '<a href="' + encodeURI(Routes[route].apply(this, args)) + '">' + text + '</a>';
});
