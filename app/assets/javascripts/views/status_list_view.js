(function($) {
  BNUOJ.Views.StatusListView = BNUOJ.Views.DatatableHistoryView.extend({
    events: _.extend({
      "submit #status-filter": "submitStatusFilter",
      "click a.show-source": "showSourceCode"
    }, BNUOJ.Views.DatatableHistoryView.prototype.events),

    _selectors: _.extend({
      DATATABLE: "#statuslist",
      FILTER_FORM: "#status-filter",
      USER_FILTER: "#status-filter [name='showname']",
      PID_FILTER: "#status-filter [name='showpid']",
      RESULT_FILTER: "#status-filter [name='showres']",
      LANGUAGE_FILTER: "#status-filter [name='showlang']"
    }, BNUOJ.Views.DatatableHistoryView.prototype._selectors),

    activeNavbar: "#status",

    withSearchBar: false,

    currentInfo: _.extend({
      userShown: null,
      pidShown: null,
      resultShown: null,
      languageShown: null,
    }, BNUOJ.Views.DatatableHistoryView.prototype.currentInfo),

    parseUrlParams: function(url) {
      url = url || window.location.href;
      this.currentInfo.userShown = BNUOJ.Utils.getUrlParam('user', url) || "";
      this.currentInfo.pidShown = BNUOJ.Utils.getUrlParam('pid', url) || "";
      this.currentInfo.resultShown = BNUOJ.Utils.getUrlParam('result', url) || "";
      this.currentInfo.languageShown = BNUOJ.Utils.getUrlParam('language', url) || "";
    },

    filterStateInfo: function(info) {
      $(this._selectors.USER_FILTER).val(info.userShown);
      $(this._selectors.PID_FILTER).val(info.pidShown);
      $(this._selectors.RESULT_FILTER).val(info.resultShown);
      $(this._selectors.LANGUAGE_FILTER).val(info.languageShown);
      $(this._selectors.FILTER_FORM).submit();
    },

    submitStatusFilter: function() {
      if (this.currentInfo.userShown != $(this._selectors.USER_FILTER).val()) {
        this.currentInfo.userShown = $(this._selectors.USER_FILTER).val();
        this.listTable.fnFilter(this.currentInfo.userShown, 0);
      }
      if (this.currentInfo.pidShown != $(this._selectors.PID_FILTER).val()) {
        this.currentInfo.pidShown = $(this._selectors.PID_FILTER).val();
        this.listTable.fnFilter(this.currentInfo.pidShown, 2);
      }
      if (this.currentInfo.resultShown != $(this._selectors.RESULT_FILTER).val()) {
        this.currentInfo.resultShown = $(this._selectors.RESULT_FILTER).val();
        this.listTable.fnFilter(this.currentInfo.resultShown, 3);
      }
      if (this.currentInfo.languageShown != $(this._selectors.LANGUAGE_FILTER).val()) {
        this.currentInfo.languageShown = $(this._selectors.LANGUAGE_FILTER).val();
        this.listTable.fnFilter(this.currentInfo.languageShown, 4);
      }
    },

    afterViewAll: function() {
      if (this.currentInfo.userShown != "") {
        $(this._selectors.USER_FILTER).val(this.currentInfo.userShown);
        this.listTable.fnFilter(this.currentInfo.userShown, 0);
      }
      if (this.currentInfo.pidShown != "") {
        $(this._selectors.PID_FILTER).val(this.currentInfo.pidShown);
        this.listTable.fnFilter(this.currentInfo.pidShown, 2);
      }
      if (this.currentInfo.resultShown != "") {
        $(this._selectors.RESULT_FILTER).val(this.currentInfo.resultShown);
        this.listTable.fnFilter(this.currentInfo.resultShown, 3);
      }
      if (this.currentInfo.languageShown != "") {
        $(this._selectors.LANGUAGE_FILTER).val(this.currentInfo.languageShown);
        this.listTable.fnFilter(this.currentInfo.languageShown, 4);
      }
    },

    getCurrentTitle: function() {
      return "Status List";
    },

    getViewUrl: function() {
      return (this.currentInfo.userShown == "" ? "" : "&user=" + encodeURIComponent(this.currentInfo.userShown)) +
          (this.currentInfo.pidShown == "" ? "" : "&pid=" + encodeURIComponent(this.currentInfo.pidShown)) +
          (this.currentInfo.resultShown == "" ? "" : "&result=" + encodeURIComponent(this.currentInfo.resultShown)) +
          (this.currentInfo.languageShown == "" ? "" : "&language=" + encodeURIComponent(this.currentInfo.languageShown));
    },

    renderView: function() {
    },

    afterTableDrawn: function() {
    },

    showSourceCode: function(evt) {
      var runid = $(evt.target).attr('runid');
      BNUOJ.Dialogs.show("source_code_box", { ajaxUrl: basePath + "statuses/" + runid + ".json" } );
    },

    setupTableOptions: function() {
      this.tableOptions = ({
        "sDom": '<"row"<"col-sm-12"p>r<"table-responsive"t>>',
        "oLanguage": {
          "sEmptyTable": "No status found.",
          "sZeroRecords": "No status found.",
          "sInfoEmpty": "No status to show."
        },
        "sAjaxSource": basePath + "statuses.json",
        "bSort": false,
        "bLengthChange": false,
        "iDisplayLength": globalConfig.limits.status_per_page,
        "iDisplayStart": (this.currentInfo.page - 1) * globalConfig.limits.status_per_page,
        "aoColumnDefs": [
          { "sWidth": "170px", "aTargets": [ 8 ] },
          { "sWidth": "210px", "aTargets": [ 3 ] },
          { "bVisible": false, "aTargets": [ 9 ] },
          {
            "mRender": function ( data, type, full ) {
              return "<a target='_blank' href='" + basePath + "users/" + data + "'>" + data + "</a>";
            },
            "aTargets": [ 0 ]
          },
          {
            "mRender": function ( data, type, full ) {
              if (full[9] == false) {
                return data;
              }
              return "<a class='show-source' runid='" + full[1] + "' href='#'>" + data + "</a>";
            },
            "aTargets": [ 1, 4 ]
          },
          {
            "mRender": function ( data, type, full ) {
              return "<a href='" + basePath + "problems/" + data + "'>" + data + "</a>";
            },
            "aTargets": [ 2 ]
          },
          {
            "mRender": function ( data, type, full ) {
              if (!data || (data == "0" && full[6] == "0")) {
                return "";
              }
              return data + " ms";
            },
            "aTargets": [ 5 ]
          },
          {
            "mRender": function ( data, type, full ) {
              if (!data || data == "0") {
                return "";
              }
              return data + " KB";
            },
            "aTargets": [ 6 ]
          },
          {
            "mRender": function ( data, type, full ) {
              var display = data + " B";
              if (full[9] == false) {
                return display;
              }
              return "<a class='show-source' runid='" + full[1] + "' href='#'>" + display + "</a>";
            },
            "aTargets": [ 7 ]
          },
          {
            "mRender": function ( data, type, full ) {
              var tdata = "<span class='" + BNUOJ.Utils.getResultClass(data) + "'>" + data + "</span>";
              if (data.substr(0, 7) == "Compile") return "<a href='#' class='ceinfo' runid='" + full[1] + "'>" + tdata + "</a>";
              return tdata;
            },
            "aTargets": [ 3 ]
          },
          {
            "mRender": function ( data, type, full ) {
              return BNUOJ.Utils.getLocalTime(data);
            },
            "aTargets": [ 9 ]
          }
        ]
      });
    }
  });
}).call(this, jQuery);