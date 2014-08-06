(function($) {

  BNUOJ.Dialogs.LoginDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/login_box",

    events: {
      "correct #login_form": "onLoggedIn",
      "click .toregister": "onClickRegister"
    },

    onShown: function() {
      this.$("#username").focus();
    },

    onLoggedIn: function() {
      window.location.reload();
    },

    onClickRegister: function() {
      BNUOJ.Dialogs.show("register_box");
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

  BNUOJ.Dialogs.SourceCodeDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/source_code_box",
    _withAjax: true,

    events: {
      "click #rshare .btn": "onShareChange"
    },

    _selectors: {
      SOURCE_CODE: "pre",
      SHARE_BTNS: "#rshare .btn",
      RUNID: ".runid",
      SHARE_NOTE: "#sharenote"
    },

    onAjaxContentLoaded: function() {
      this.ajaxContent.displayResult = "<span class='" + BNUOJ.Utils.getResultClass(this.ajaxContent.result) + "'>" + this.ajaxContent.result + "</span>"
    },

    onShareChange: function(evt) {
      if (this.$(evt.target).hasClass("active")) {
        return;
      }
      var isshared = this.$(evt.target).attr("isshared");
      var runid = this.$(this._selectors.RUNID).text();
      var self = this;

      this.$(this._selectors.SHARE_BTNS).removeClass("active");
      this.$(evt.target).addClass("active");
      this.$(this._selectors.SHARE_NOTE).toggle();

      $.post(basePath + "statuses/" + runid + ".json", {
        _method: "PATCH",
        isshared: isshared,
        authenticity_token: BNUOJ.Utils.getCsrfToken()
      });
    },

    onFailed: function() {
      if (loggedIn) {
        BNUOJ.Dialogs.show("error_box", { errorMessage: "No permission to see this code." });
      } else {
        BNUOJ.Dialogs.show("login_box");
      }
    },

    afterRender: function() {
      this.$(this._selectors.SOURCE_CODE).each(function(idx, el) {
        el.innerHTML = prettyPrintOne(el.innerHTML);
      });
    }
  });

  BNUOJ.Dialogs.ErrorDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/error_box",
    errorTitle: "Error Occured",
    errorMessage: "Something is wrong."
  });

  BNUOJ.Dialogs.SubmitDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/submit_box",
    events: {
      "correct #problem_submit_form": "onSubmitted"
    },

    onSubmitted: function() {
      window.location.href = basePath + "statuses";
    }
  });

  BNUOJ.Dialogs.ModifyUserDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/modify_user_box",
    _withAjax: true
  });

  BNUOJ.Dialogs.CompileInfoDialog = BNUOJ.Dialogs.BaseDialog.extend({
    _template: "templates/dialogs/compile_info_box",
    _withAjax: true,

    onFailed: function() {
      if (loggedIn) {
        BNUOJ.Dialogs.show("error_box", { errorMessage: "No permission to see this code." });
      } else {
        BNUOJ.Dialogs.show("login_box");
      }
    }
  });

  BNUOJ.Dialogs.register("register_box", BNUOJ.Dialogs.RegisterDialog);
  BNUOJ.Dialogs.register("login_box", BNUOJ.Dialogs.LoginDialog);
  BNUOJ.Dialogs.register("news_box", BNUOJ.Dialogs.NewsDialog);
  BNUOJ.Dialogs.register("modify_user_box", BNUOJ.Dialogs.ModifyUserDialog);
  BNUOJ.Dialogs.register("source_code_box", BNUOJ.Dialogs.SourceCodeDialog);
  BNUOJ.Dialogs.register("error_box", BNUOJ.Dialogs.ErrorDialog);
  BNUOJ.Dialogs.register("submit_box", BNUOJ.Dialogs.SubmitDialog);
  BNUOJ.Dialogs.register("compile_info_box", BNUOJ.Dialogs.CompileInfoDialog);

}).call(this, jQuery);
