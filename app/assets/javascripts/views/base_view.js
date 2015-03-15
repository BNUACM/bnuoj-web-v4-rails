(function($) {
  // Base class for every view.
  BNUOJ.Views.BaseView = BaseClass.extend({

    // Should be overrided, the dom container of this view.
    _container: null,

    // Events binded to this view.
    events: {},

    // Common selectors, good for reuse.
    _selectors: {
      AJAX_FORM_BTNS: "input:submit, button:submit, .btn",
      AJAX_FORM_MSG: "#msgbox",
      DISPLAY_TIME: ".display_time"
    },

    // Standard ajax loading html, can be overrided.
    ajaxLoadingHtml: '<img style="height:20px" src="' + basePath +
        'assets/ajax-loader.gif" /> ' + I18n.t("global.prompts.loading"),

    // jQuery selector inside the view dom.
    $: function() {
      return this.$el.find.apply(this.$el, arguments);
    },

    // Acutally renders the view.
    render: function() {
      this.$el = $(this._container);
      this.beforeAll();
      this.beforeRender();
      this.renderInternal();
      this.afterRender();
      this.setupAjaxForms();
      this.convertDisplayTime();
      this.bindEvents();
      this.afterAll();
    },

    // Bind events using delegation, so it will also work on elements created
    // after initialization.
    // https://learn.jquery.com/events/event-delegation/
    bindEvents: function() {
      var self = this;
      _.each(this.events, function(func, evt) {
        var result = evt.match(/([^ ]*) (.*)/);
        self.$el.on(result[1], result[2], function(evt) {
          self[func].apply(self, arguments);
          evt.preventDefault();
        });
      })
    },

    // Unbinds all events.
    unBindEvents: function() {
      var self = this;
      _.each(this.events, function(func, evt) {
        var result = evt.match(/([^ ]*) (.*)/);
        self.$el.off(result[1], result[2]);
      })
    },

    // Can be overrided.
    beforeAll: function() {
    },

    // Can be overrided.
    afterAll: function() {
    },

    // Can be overrided.
    beforeRender: function() {
    },

    // Should be overrided.
    renderInternal: function() {
    },

    // Can be overrided.
    afterRender: function() {
    },

    // Convert server time to local time.
    convertDisplayTime: function() {
      this.$(this._selectors.DISPLAY_TIME).each(function() {
        var time = $(this).text();
        $(this).text(BNUOJ.Utils.getLocalTime(time));
      });
    },

    // Setup ajax forms with standard behaviors.
    // TODO(51isoft): Consider move this to a proper place.
    setupAjaxForms: function() {
      var self = this;
      this.$("form.ajform").ajaxForm({
        dataType: 'json',
        data: { "authenticity_token": BNUOJ.Utils.getCsrfToken() },

        beforeSerialize: function(tform, options) {
          tform.trigger("preprocess");
        },
        beforeSubmit: function (formData, tform, options) {
          $(self._selectors.AJAX_FORM_BTNS, tform).attr("disabled", "disabled").
              addClass("disabled");
          $(self._selectors.AJAX_FORM_MSG, tform).removeClass().
              addClass('alert alert-info').html(self.ajaxLoadingHtml).
              fadeIn(500);
          return true;
        },
        success: function(responseJSON, statusText, xhr, form) {
          $(self._selectors.AJAX_FORM_MSG, form).fadeTo(100, 0.1, function() {
            $(this).html(responseJSON.msg).removeClass().
                addClass('alert alert-success').fadeTo(100, 1, function(){
              form.trigger("correct");
            });
          });
          $(self._selectors.AJAX_FORM_BTNS, form).removeAttr("disabled").
              removeClass("disabled");
        },

        error: function(response, statusText, xhr, form) {
          responseJSON = _.extend({msg: I18n.t("global.prompts.error")},
              response.responseJSON);
          $(self._selectors.AJAX_FORM_MSG, form).fadeTo(100, 0.1, function() {
            $(this).html(responseJSON.msg).removeClass().
                addClass('alert alert-danger').fadeTo(300, 1);
          });
          $(self._selectors.AJAX_FORM_BTNS, form).removeAttr("disabled").
              removeClass("disabled");
        }
      });
    },

    renderTemplate: function(targetElement, template, context) {
      targetElement.html(JST[template](context));
    }

  })
}).call(this, jQuery);
