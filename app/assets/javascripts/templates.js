// Templates
//
//= require_tree ./templates

Handlebars.registerHelper('basePath', function() {
  return basePath;
});

Handlebars.registerHelper('t', function(key, options) {
  return I18n.t(key, options.hash);
});
