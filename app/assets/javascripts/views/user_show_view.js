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
      var user1 = BNUOJ.Utils.getCookie('username');
      var user2 = this.$(this._selectors.COMPARE_WITH).val();
      var compareInfoElement = this.$(this._selectors.COMPARE_INFO);
      var url = Routes.user_compare_path(user1, user2);
      $.getJSON(url).done(function(data) {
        compareInfoElement.html(JST[_template](_.extend({user1: user1,
            user2: user2}, data)));
      });
      compareInfoElement.collapse('show');
      this.$(this._selectors.COMPARE_HIDE).show();
    },

    hideCompare: function() {
      this.$(this._selectors.COMPARE_INFO).collapse('hide');
      this.$(this._selectors.COMPARE_HIDE).hide();
    },

    afterRenderPage: function() {
      this.$(this._selectors.COMPARE_HIDE).hide();

      var stat_table = this.$(this._selectors.STAT_TABLE).clone();
      stat_table.find("a").contents().unwrap();
      this.$(this._selectors.STAT_CHART).highcharts({
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
