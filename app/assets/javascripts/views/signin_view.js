(function($) {
  // Standalone sign-in page.
  BNUOJ.Views.SignInView = BNUOJ.Views.PageView.extend({
    events: _.extend({
      "correct #login_form": "onLoggedIn"
    }, BNUOJ.Views.PageView.prototype.events),

    _selectors: _.extend({
    }, BNUOJ.Views.PageView.prototype._selectors),

    // Redirect back.
    onLoggedIn: function() {
      var url = BNUOJ.Utils.getUrlParam("redirect_to");
      if (url) {
        url = decodeURIComponent(url);
      } else {
        url = basePath;
      }
      window.location.href = url;
    }

  });
}).call(this, jQuery);