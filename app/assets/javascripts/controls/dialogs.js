(function($) {

  BNUOJ.Dialogs.LoginDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/login_box",

    events: {
      "correct #login_form": "onLoggedIn"
    },

    onShown: function() {
      this.$("#username").focus();
    },

    onLoggedIn: function() {
      window.location.reload();
    }
  });

  BNUOJ.Dialogs.NewsDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/news_box",
    _withAjax: true    

  });

  BNUOJ.Dialogs.RegisterDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/register_box",

    events: {
      "correct #reg_form": "onRegistered"
    },

    onShown: function() {
      this.$("#username").focus();
    },

    onRegistered: function() {
      window.location.reload();
    }
  });

  BNUOJ.Dialogs.ModifyUserDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/modify_user_box",
    _withAjax: true    

  });

  BNUOJ.Dialogs.register("register_box", BNUOJ.Dialogs.RegisterDialog);
  BNUOJ.Dialogs.register("login_box", BNUOJ.Dialogs.LoginDialog);
  BNUOJ.Dialogs.register("news_box", BNUOJ.Dialogs.NewsDialog);
  BNUOJ.Dialogs.register("modify_user_box", BNUOJ.Dialogs.ModifyUserDialog);

}).call(this, jQuery);
