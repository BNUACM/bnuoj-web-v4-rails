(function($) {
  BNUOJ.Views.PageView = BNUOJ.Views.BaseView.extend({

    _container: "#page-content",

    // View events
    // format: "event selector": "handler"
    events: {
      "click .newslink": "onShowNews",
      "click #login-btn": "onClickLogin",
      "click #register-btn": "onClickRegister",
      "click #modify-my-info": "onClickModify"
    },

    _selectors: _.extend({
      DISPLAY_TIME: ".display_time",
      MAIN_NAVBAR: "#main_navbar"
    }, BNUOJ.Views.BaseView.prototype._selectors),

    activeNavbar: null,

    renderInternal: function() {
      this.tickNavTime();
      this.convertDisplayTime();
      this.setActiveNavbar();
      this.beforeRenderPage();
      this.renderPage();
      this.afterRenderPage();
    },

    setActiveNavbar: function() {
      if (!this.activeNavbar) return;
      this.$(this.activeNavbar, this._selectors.MAIN_NAVBAR).addClass("active");
    },

    // should be overwrite by inherited class
    beforeRenderPage: function() {
    },

    // should be overwrite by inherited class
    renderPage: function() {
    },

    // should be overwrite by inherited class
    afterRenderPage: function() {
    },

    tickNavTime: function() {
      setInterval("BNUOJ.Utils.displayNavTime()", 1000);
      setInterval("BNUOJ.Utils.getTime()", 180000);
    },

    onClickLogin: function() {
      BNUOJ.Dialogs.show("login_box");
    },

    onClickRegister: function() {
      BNUOJ.Dialogs.show("register_box");
    },

    onClickModify: function() {
      BNUOJ.Dialogs.show("modify_user_box", { ajaxUrl: basePath + "users/" + BNUOJ.Utils.getCookie('username') + ".json" } );
    },

    onShowNews: function(evt) {
      var newsid = $(evt.target).attr("name");
      BNUOJ.Dialogs.show("news_box", { ajaxUrl: basePath + "news/" + newsid + ".json" } );
    }

  })
}).call(this, jQuery);
