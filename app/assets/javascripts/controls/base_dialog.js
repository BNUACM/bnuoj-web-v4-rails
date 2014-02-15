(function($) {
  BNUOJ.Dialogs = {
    _nameClass: {},
    _currentDialog: null,
    _container: "#bnuoj-dialog",

    register: function(name, dialogClass) {
      if (!this._nameClass[name]) {
        this._nameClass[name] = dialogClass;
      }
    },

    show: function(name, options) {
      if (this._currentDialog) {
        this.hide();
      }
      this._currentDialog = _.extend(new this._nameClass[name](), options);
      this._currentDialog.render();
      var self = this;
      $(this._container).on("shown.bs.modal", function() {
        self._currentDialog.onShown.apply(self._currentDialog, arguments)
      });
      $(this._container).modal("show");
    },

    hide: function() {
      $(this._container).modal("hide");
      $(this._container).off("shown.bs.modal");
    }
  };

  BNUOJ.Dialogs.BaseDialog = BNUOJ.Views.BaseView.extend({
    _container: "#bnuoj-dialog",
    _template: null,

    _withAjax: false,
    ajaxContentLoaded: false,
    ajaxUrl: null,
    ajaxContent: null,

    onLoaded: function(content) {
      this.ajaxContent = content;
      this.ajaxContentLoaded = true;
      this.render();
    },

    renderInternal: function() {
      $(this._container).html(JST[this._template](this));
      if (this._withAjax && !this.ajaxContentLoaded) {
        var self = this;
        $.get(this.ajaxUrl, {r: Math.random()}).done(function() {
          self.onLoaded.apply(self, arguments);
        })
      }
    },

    // Should be overrided
    onShown: function() {
    }
  })

}).call(this, jQuery);
