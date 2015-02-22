(function($) {
  // Base view for a page.
  BNUOJ.Views.PageView = BNUOJ.Views.BaseView.extend({

    _container: "#page-content",

    events: {
      "click .newslink": "onShowNews",
      "click #login-btn": "onClickLogin",
      "click #register-btn": "onClickRegister",
      "click #modify-my-info": "onClickModify"
    },

    _selectors: _.extend({
      // Navigation bar on the top.
      MAIN_NAVBAR: "#main_navbar"
    }, BNUOJ.Views.BaseView.prototype._selectors),

    // Current active item in navbar. Can be overrided.
    activeNavbar: null,

    renderInternal: function() {
      this.tickNavTime();
      this.convertDisplayTime();
      this.setActiveNavbar();
      this.beforeRenderPage();
      this.renderPage();
      this.afterRenderPage();
    },

    // Highlight active item in navbar.
    setActiveNavbar: function() {
      if (!this.activeNavbar) return;
      this.$(this.activeNavbar, this._selectors.MAIN_NAVBAR).addClass("active");
    },

    // Can be overrided.
    beforeRenderPage: function() {
    },

    // Should be overrided.
    renderPage: function() {
    },

    // Can be overrided.
    afterRenderPage: function() {
    },

    // Begins to tick the server time in navbar.
    tickNavTime: function() {
      setInterval("BNUOJ.Utils.displayNavTime()", 1000);
      setInterval("BNUOJ.Utils.getTime()", 180000);
    },

    // On click login button in navbar.
    onClickLogin: function() {
      BNUOJ.Dialogs.show("login_box");
    },

    // On click register button in navbar.
    onClickRegister: function() {
      BNUOJ.Dialogs.show("register_box");
    },

    // On click modify button in navbar.
    onClickModify: function() {
      BNUOJ.Dialogs.show("modify_user_box", {
        ajaxUrl:
            basePath + "users/" + BNUOJ.Utils.getCookie('username') + ".json"
      });
    },

    // On clicking a news link.
    onShowNews: function(evt) {
      var newsid = $(evt.target).attr("name");
      BNUOJ.Dialogs.show("news_box", {
        ajaxUrl: basePath + "news/" + newsid + ".json"
      });
    }

  })
}).call(this, jQuery);
