(function($) {
  // Landing home page.
  BNUOJ.Views.HomeView = BNUOJ.Views.PageView.extend({
    events: _.extend({
    }, BNUOJ.Views.PageView.prototype.events),

    _selectors: _.extend({
    }, BNUOJ.Views.PageView.prototype._selectors)

  });
}).call(this, jQuery);