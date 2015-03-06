(function($) {
  // Problem page shows a specific problem.
  BNUOJ.Views.ProblemShowView = BNUOJ.Views.PageView.extend({
    events: _.extend({
      "click #tags_toggle": "onClickTagsToggle",
      "click .submit-problem": "onSubmitProblem"
    }, BNUOJ.Views.PageView.prototype.events),

    _selectors: _.extend({
      PROBLEM_TAGS: "#problem_tags",
      PROBLEM_ID: ".problem-id"
    }, BNUOJ.Views.PageView.prototype._selectors),

    // Toggles the problem category visibility.
    onClickTagsToggle: function() {
      this.$(this._selectors.PROBLEM_TAGS).toggle();
    },

    // When user clicks submit box.
    onSubmitProblem: function() {
      if (!loggedIn) {
        BNUOJ.Dialogs.show("login_box");
        return;
      }
      var pid = this.$(this._selectors.PROBLEM_ID).text();
      BNUOJ.Dialogs.show("submit_box", {
        title: I18n.t("problem.titles.submit", {"pid": pid}),
        pid: pid,
        cid: 0
      });
    }

  });
}).call(this, jQuery);
