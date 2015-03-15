$(document).ready(function() {
  // Corresponding view controller for each path pattern.
  var viewRoutes = {
    "^$"                                : BNUOJ.Views.HomeView,
    "^problems(\/?)$"                   : BNUOJ.Views.ProblemListView,
    "^statuses(\/?)$"                   : BNUOJ.Views.StatusListView,
    "^statuses\/[0-9]+$"                : BNUOJ.Views.ShowSourceView,
    "^contests(\/?)$"                   : BNUOJ.Views.ContestListView,
    "^signin(\/?)$"                     : BNUOJ.Views.SignInView,
    "^problems\/[0-9]+$"                : BNUOJ.Views.ProblemShowView,
    "^users\/[a-zA-Z0-9_-]+$"           : BNUOJ.Views.UserShowView
  };

  // Find the first matching route.
  var viewClass = _.find(viewRoutes, function(viewClass, route) {
    return window.location.pathname.substr(basePath.length).match(route);
  });

  window.currentView = new viewClass;

  // Boot js env.
  currentView.render();

  // Initialize dialog service.
  BNUOJ.Dialogs.init();
});
