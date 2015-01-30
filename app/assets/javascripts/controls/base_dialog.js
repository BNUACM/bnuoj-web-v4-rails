(function($) {
  // Dialog service.
  BNUOJ.Dialogs = {
    // Dialog name mapping to corresponding class.
    _nameClass: {},
    // Current showing dialog.
    _currentDialog: null,
    // DOM container dialog needs to be rendered in.
    _container: ".bnuoj-dialog",

    init: function() {
      var self = this;
      $(this._container).on("hide.bs.modal", function() {
        if (self._currentDialog) {
          self._currentDialog.onClose();
        }
      });
      $(this._container).on("hidden.bs.modal", function() {
        // Destroy current dialog.
        self._currentDialog = null;
        $(self._container).off("shown.bs.modal");
        $(self._container).attr("id", "");
        $(self._container).trigger("bnuoj.dialog.hidden");
      });
    },

    // Register dialogClass with given name.
    register: function(name, dialogClass) {
      if (!this._nameClass[name]) {
        this._nameClass[name] = dialogClass;
      }
    },

    // Show dialog associated with given name, with options.
    show: function(name, options) {
      if (this._currentDialog) {
        // Hide current dialog.
        this.hide();
        // Unbind existing queued dialog.
        $(this._container).off("bnuoj.dialog.hidden");
        var self = this;
        // Show new dialog after current one closed.
        $(this._container).one("bnuoj.dialog.hidden", function() {
          self.show(name, options);
        });
        return;
      }
      // Create new dialog with options.
      this._currentDialog = _.extend(new this._nameClass[name](), options);
      $(this._container).attr("id", name);
      this._currentDialog.render();
      var self = this;
      $(this._container).on("shown.bs.modal", function() {
        // When dialog is fully visible.
        self._currentDialog.onShown.apply(self._currentDialog, arguments)
      });
      $(this._container).modal("show");
    },

    hide: function() {
      $(this._container).modal("hide");
    }
  };

  // Base class of the dialog.
  BNUOJ.Dialogs.BaseDialog = BNUOJ.Views.BaseView.extend({
    // DOM container dialog is in.
    _container: ".bnuoj-dialog #dialog-content",
    // Handlebar template path.
    _template: null,
    // Whether it will fire an ajax request upon loading.
    _withAjax: false,

    // Will be true when ajax loading finishes.
    ajaxContentLoaded: false,
    // Ajax loading url.
    ajaxUrl: null,
    // Ajax loading result.
    ajaxContent: null,

    onLoaded: function(content) {
      this.ajaxContent = content;
      this.ajaxContentLoaded = true;
      this.onAjaxContentLoaded();
      // Render will call bind events, so should unbind existing events first.
      this.unBindEvents();
      this.render();
    },

    // Can be overrided.
    onFailed: function() {
    },

    // Renders the dialog view.
    renderInternal: function() {
      $(this._container).html(JST[this._template](this));
      if (this._withAjax && !this.ajaxContentLoaded) {
        var self = this;
        $.get(this.ajaxUrl, {r: Math.random()}).done(function() {
          self.onLoaded.apply(self, arguments);
        }).fail(function() {
          self.onFailed.apply(self, arguments);
        })
      }
    },

    // Should be overrided.
    onShown: function() {
    },

    // Should be overrided when _withAjax is true.
    onAjaxContentLoaded: function() {
    },

    onClose: function() {
      this.unBindEvents();
    }
  })

}).call(this, jQuery);
