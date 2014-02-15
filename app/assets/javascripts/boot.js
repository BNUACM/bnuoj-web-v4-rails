$(document).ready(function() {
  var viewRoutes = {
    "^$"                                : BNUOJ.Views.HomeView,
    "^problems(\/?)$"                   : BNUOJ.Views.ProblemListView,
    "^statuses(\/?)$"               : BNUOJ.Views.StatusListView
  };

  // find first matching route
  var viewClass = _.find(viewRoutes, function(viewClass, route) {
    return window.location.pathname.substr(basePath.length).match(route);
  });

  currentView = new viewClass;
  currentView.render();
});