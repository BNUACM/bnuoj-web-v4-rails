(function($) {
  // User page
  BNUOJ.Views.UserShowView = BNUOJ.Views.PageView.extend({
    events: _.extend({
      "submit #compare": "compareUser",
      "click #hide_compare": "hideCompare"
    }, BNUOJ.Views.PageView.prototype.events),

    _selectors: _.extend({
      COMPARE_WITH: "#compare_with",
      COMPARE_INFO: "#compare_info",
      COMPARE_HIDE: "#hide_compare",
      STAT_TABLE: "#user_stat",
      STAT_CHART: "#user_stat_pie"
    }, BNUOJ.Views.PageView.prototype._selectors),

    compareUser: function() {
      var _template = "templates/partials/user_compare";
      var compare_with = $(this._selectors.COMPARE_WITH).val();
      var $compare_info = $(this._selectors.COMPARE_INFO);
      var url = Routes.user_compare_path(
                    BNUOJ.Utils.getCookie('username'), compare_with);
      $.get(url).done(function(html) {
        $compare_info.html(html);
      });
      $compare_info.collapse('show');
      $(this._selectors.COMPARE_HIDE).show();
    },

    hideCompare: function() {
      $(this._selectors.COMPARE_INFO).collapse('hide');
      $(this._selectors.COMPARE_HIDE).hide();
    },

    afterRenderPage: function() {
      $(this._selectors.COMPARE_HIDE).hide();

      stat_table = $(this._selectors.STAT_TABLE).clone();
      stat_table.find("a").contents().unwrap();
      $(this._selectors.STAT_CHART).highcharts({
        chart: {
          type: 'pie',
          backgroundColor: null
        },
        data: {
          table: stat_table[0],
          startRow: 1
        },
        title: {
          text: I18n.t('user.show.stat')
        },
        plotOptions: {
          pie: {
            dataLabels: {
              enabled: false
            }
          }
        }
      });
    }
  });
}).call(this, jQuery);
