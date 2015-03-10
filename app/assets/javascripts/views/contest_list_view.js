(function($) {
  // Contest list page.
  BNUOJ.Views.ContestListView = BNUOJ.Views.DatatableHistoryView.extend({
    events: _.extend({
      "click .type-btns .btn": "clickContestType",
      "click .access-btns .btn": "clickAccess",
      "click .virtual-btns .btn": "clickIsVirtual"

    }, BNUOJ.Views.DatatableHistoryView.prototype.events),

    _selectors: _.extend({
      DATATABLE: "#contestlist",
      SEARCH_INPUT: "#contestlist_filter input[type=search]",
      CONTEST_TYPE_BTNS: ".type-btns .btn",
      ACCESS_BTNS: ".access-btns .btn",
      IS_VIRTUAL_BTNS: ".virtual-btns .btn"
    }, BNUOJ.Views.DatatableHistoryView.prototype._selectors),

    activeNavbar: "#contest",

    withSearchBar: true,

    currentInfo: _.extend({
      contestType: null,
      access: null,
      isVirtual: null
    }, BNUOJ.Views.DatatableHistoryView.prototype.currentInfo),

    // Override.
    parseUrlParams: function(url) {
      url = url || window.location.href;
      this.currentInfo.contestType =
          BNUOJ.Utils.getUrlParam('type', url) || "-99";
      this.currentInfo.access =
          BNUOJ.Utils.getUrlParam('access', url) || "";
      this.currentInfo.isVirtual =
          BNUOJ.Utils.getUrlParam('virtual', url) || "0";
      return "";
    },

    // Override.
    filterStateInfo: function(info) {
      if (info.contestType != this.currentInfo.contestType) {
        $(this._selectors.CONTEST_TYPE_BTNS).filter(
            '[contest-type="' + info.contestType + '"]').click();
      }
      if (info.access != this.currentInfo.access) {
        $(this._selectors.ACCESS_BTNS).filter(
            '[access="' + info.access + '"]').click();
      }
      if (info.isVirtual != this.currentInfo.isVirtual) {
        $(this._selectors.IS_VIRTUAL_BTNS).filter(
            '[is-virtual="' + info.isVirtual + '"]').click();
      }
    },

    // Override.
    afterViewAll: function() {
      $(this._selectors.CONTEST_TYPE_BTNS).filter(
          '[contest-type="' + this.currentInfo.contestType + '"]').click();
      $(this._selectors.ACCESS_BTNS).filter(
          '[access="' + this.currentInfo.access + '"]').click();
      $(this._selectors.IS_VIRTUAL_BTNS).filter(
          '[is-virtual="' + this.currentInfo.isVirtual + '"]').click();
    },

    // Override.
    getCurrentTitle: function() {
      return I18n.t("contest.titles.list");
    },

    // Override.
    getViewUrl: function() {
      return (
          (this.currentInfo.contestType == "-99" ||
              this.currentInfo.contestType == null ?
                  "" : "&type=" +
                      encodeURIComponent(this.currentInfo.contestType)) +
          (this.currentInfo.access == "" ||
              this.currentInfo.access == null ?
                  "" : "&access=" +
                      encodeURIComponent(this.currentInfo.access)) +
          (this.currentInfo.isVirtual == "0" ||
              this.currentInfo.isVirtual == null ?
                  "" : "&virtual=" +
                      encodeURIComponent(this.currentInfo.isVirtual))
      );
    },

    // When user click contest type radio buttons to filter contests.
    clickContestType: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.contestType = $(evt.target).attr('contest-type');
      $(this._selectors.CONTEST_TYPE_BTNS).removeClass('active');
      $(evt.target).addClass('active');
      this.listTable.fnFilter(this.currentInfo.contestType, 7);
    },

    // When user click access type radio buttons to filter contests.
    clickAccess: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.access = $(evt.target).attr('access');
      $(this._selectors.ACCESS_BTNS).removeClass('active');
      $(evt.target).addClass('active');
      this.listTable.fnFilter(this.currentInfo.access, 4);
    },

    // When user click is-virtual type radio buttons to filter contests.
    clickIsVirtual: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.isVirtual = $(evt.target).attr('is-virtual');
      $(this._selectors.IS_VIRTUAL_BTNS).removeClass('active');
      $(evt.target).addClass('active');
      if (this.currentInfo.isVirtual == "0") {
        this.listTable.fnSetColumnVis( 6, false, false );
      } else {
        this.listTable.fnSetColumnVis( 6, true, false );
      }
      this.listTable.fnFilter(this.currentInfo.isVirtual, 6);
    },

    // Override. Nothing specific to do.
    renderView: function() {
    },

    // Override.
    setupTableOptions: function() {
      this.tableOptions = ({
        "sDom": '<"row"<"col-sm-4"f><"col-sm-8"p>r<"clearfix">' +
            '<"table-responsive"t><"col-sm-9"i><"col-sm-3"l>>',
        "oLanguage": {
          "sEmptyTable": I18n.t("contest.prompts.nonexist"),
          "sZeroRecords": I18n.t("contest.prompts.nonexist"),
          "sInfoEmpty": I18n.t("global.prompts.no_entry")
        },
        "sAjaxSource": basePath + "contests.json",
        "aaSorting": [ [2, 'desc'] ],
        "sPaginationType": "bs_full" ,
        "aLengthMenu": [[25, 50, 100, 150, 200], [25, 50, 100, 150, 200]] ,
        "iDisplayLength": globalConfig.limits.contests_per_page,
        "iDisplayStart":
            (this.currentInfo.page - 1) * globalConfig.limits.contests_per_page,
        "aoColumnDefs": [ 
          { "sWidth": "400px", "aTargets": [ 1 ] },
          { "sWidth": "180px", "aTargets": [ 2, 3 ] },
          { "bSortable": false, "aTargets": [ 4, 5 ] },
          { "bVisible": false, "aTargets": [ 6, 7, 8 ] },
          {
            "mRender": function ( data, type, full ) {
              // Enhance title column. Title maybe truncated, need tooltip.
              return (
                  "<a href='" + basePath + "contests/" + full[0] +"' title='" +
                  BNUOJ.Utils.escapeHtml(BNUOJ.Utils.stripTags(data)) + "'>" +
                  data + "</a>");
            },
            "aTargets": [ 1 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance cid column.
              return "<a href='" + basePath + "contests/" + data + "'>" + data +
                  "</a>";
            },
            "aTargets": [ 2 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance current status.
              if (data == "Passed") {
                return "<span class='passed'>" + 
                    I18n.t("contest.statuses.passed") + "</a>";
              } else if (data == "Scheduled") {
                return "<span class='scheduled'>" + 
                    I18n.t("contest.statuses.scheduled") + "</a>";
              } else {
                return "<span class='running'>" + 
                    I18n.t("contest.statuses.running") + "</a>";
              }
            },
            "aTargets": [ 4 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance access status.
              if (data == "Public") {
                return "<span class='public'>" + 
                    I18n.t("contest.statuses.public") + "</a>";
              } else {
                return "<span class='private'>" + 
                    I18n.t("contest.statuses.private") + "</a>";
              }
            },
            "aTargets": [ 5 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance owner status.
              if (!_.isEmpty(data)) {
                return "<a href='" + basePath + "users/" + data +
                    "' target='_blank'>" + data + "</a>";
              }
              else  {
                return "-";
              }
            },
            "aTargets": [ 6 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance begin time and end time columns.
              return BNUOJ.Utils.getLocalTime(data);
            },
            "aTargets": [ 2, 3 ]
          }
        ]
    });
    }
  });
}).call(this, jQuery);
