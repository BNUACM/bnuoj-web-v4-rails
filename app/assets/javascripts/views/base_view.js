(function($) {
  BNUOJ.Views.BaseView = BaseClass.extend({

    // following three params should be overwrited
    _container: null,
    events: {},

    _selectors: {
      AJAX_FORM_BTNS: "input:submit, button:submit, .btn",
      AJAX_FORM_MSG: "#msgbox"
    },

    ajaxLoadingHtml: '<img style="height:20px" src="' + basePath + 'assets/ajax-loader.gif" /> Loading....',

    $: function() {
      return this.$el.find.apply(this.$el, arguments);
    },

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

    /**
     * Bind delegated events
     * https://learn.jquery.com/events/event-delegation/
     */
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

    beforeAll: function() {
    },

    afterAll: function() {
    },

    // should be overwrite by inherited class
    beforeRender: function() {
    },

    // should be overwrite by inherited class
    renderInternal: function() {
    },

    // should be overwrite by inherited class
    afterRender: function() {
    },

    convertDisplayTime: function() {
      this.$(this._selectors.DISPLAY_TIME).each(function() {
        var time = $(this).text();
        $(this).text(BNUOJ.Utils.getLocalTime(time));
      });
    },

    // setup basic ajax forms
    setupAjaxForms: function() {
      var self = this;
      this.$("form.ajform").ajaxForm({
        dataType: 'json',
        data: { "authenticity_token": BNUOJ.Utils.getCsrfToken() },

        beforeSerialize: function(tform, options) {
          tform.trigger("preprocess");
        },
        beforeSubmit: function (formData, tform, options) {
          $(self._selectors.AJAX_FORM_BTNS, tform).attr("disabled", "disabled").addClass("disabled");
          $(self._selectors.AJAX_FORM_MSG, tform).removeClass().addClass('alert alert-info').html(self.ajaxLoadingHtml).fadeIn(500);
          return true;
        },
        success: function(responseJSON, statusText, xhr, form) {
          $(self._selectors.AJAX_FORM_MSG, form).fadeTo(100, 0.1, function() {
            $(this).html(responseJSON.msg).removeClass().addClass('alert alert-success').fadeTo(100, 1, function(){
              form.trigger("correct");
            });
          });
          $(self._selectors.AJAX_FORM_BTNS, form).removeAttr("disabled").removeClass("disabled");
        },

        error: function(response, statusText, xhr, form) {
          responseJSON = _.extend({msg: "Unknown error occured."}, response.responseJSON);
          $(self._selectors.AJAX_FORM_MSG, form).fadeTo(100, 0.1, function() {
            $(this).html(responseJSON.msg).removeClass().addClass('alert alert-danger').fadeTo(300, 1);
          });
          $(self._selectors.AJAX_FORM_BTNS, form).removeAttr("disabled").removeClass("disabled");
        }
      });
    }

  })
}).call(this, jQuery);
