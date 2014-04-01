$(document).ready(function() {
  var viewRoutes = {
    "^$"                                : BNUOJ.Views.HomeView,
    "^problems(\/?)$"                   : BNUOJ.Views.ProblemListView,
    "^statuses(\/?)$"                   : BNUOJ.Views.StatusListView,
    "^statuses\/[0-9]+$"                : BNUOJ.Views.ShowSourceView,
    "^contests(\/?)$"                   : BNUOJ.Views.ContestListView,
    "^signin(\/?)$"                     : BNUOJ.Views.SignInView,
    "^problems\/[0-9]+$"                : BNUOJ.Views.ProblemShowView
  };

  // find first matching route
  var viewClass = _.find(viewRoutes, function(viewClass, route) {
    return window.location.pathname.substr(basePath.length).match(route);
  });

  currentView = new viewClass;
  currentView.render();
  BNUOJ.Dialogs.init();
});