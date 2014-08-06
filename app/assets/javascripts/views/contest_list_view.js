(function($) {
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

    parseUrlParams: function(url) {
      url = url || window.location.href;
      this.currentInfo.contestType = BNUOJ.Utils.getUrlParam('type', url) || "-99";
      this.currentInfo.access = BNUOJ.Utils.getUrlParam('access', url) || "";
      this.currentInfo.isVirtual = BNUOJ.Utils.getUrlParam('virtual', url) || "0";
      return "";
    },

    filterStateInfo: function(info) {
      if (info.contestType != this.currentInfo.contestType) {
        $(this._selectors.CONTEST_TYPE_BTNS).filter('[contest-type=' + info.contestType + ']').click();
      }
      if (info.access != this.currentInfo.access) {
        $(this._selectors.ACCESS_BTNS).filter('[access=' + info.access + ']').click();
      }
      if (info.isVirtual != this.currentInfo.isVirtual) {
        $(this._selectors.IS_VIRTUAL_BTNS).filter('[is-virtual=' + info.isVirtual + ']').click();
      }
    },

    afterViewAll: function() {
      $(this._selectors.CONTEST_TYPE_BTNS).filter('[contest-type=' + this.currentInfo.contestType + ']').click();
      $(this._selectors.ACCESS_BTNS).filter('[access=' + this.currentInfo.access + ']').click();
      $(this._selectors.IS_VIRTUAL_BTNS).filter('[is-virtual=' + this.currentInfo.isVirtual + ']').click();
    },

    getCurrentTitle: function() {
      return "Contest List";
    },

    getViewUrl: function() {
      return (this.currentInfo.contestType == "-99" || this.currentInfo.contestType == null ? "" : "&type=" + encodeURIComponent(this.currentInfo.contestType)) +
          (this.currentInfo.access == "" || this.currentInfo.access == null ? "" : "&access=" + encodeURIComponent(this.currentInfo.access)) +
          (this.currentInfo.isVirtual == "0" || this.currentInfo.isVirtual == null ? "" : "&virtual=" + encodeURIComponent(this.currentInfo.isVirtual));
    },

    clickContestType: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.contestType = $(evt.target).attr('contest-type');
      $(this._selectors.CONTEST_TYPE_BTNS).removeClass('active');
      $(evt.target).addClass('active');
      this.listTable.fnFilter(this.currentInfo.contestType, 7);
    },

    clickAccess: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.access = $(evt.target).attr('access');
      $(this._selectors.ACCESS_BTNS).removeClass('active');
      $(evt.target).addClass('active');
      this.listTable.fnFilter(this.currentInfo.access, 4);
    },

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

    renderView: function() {
    },

    afterTableDrawn: function() {
    },

    setupTableOptions: function() {
      this.tableOptions = ({
        "sDom": '<"row"<"col-sm-4"f><"col-sm-8"p>r<"table-responsive"t><"col-sm-9"i><"col-sm-3"l>>',
        "oLanguage": {
          "sEmptyTable": "No contests found.",
          "sZeroRecords": "No contests found.",
          "sInfoEmpty": "No entries to show"
        },
        "sAjaxSource": basePath + "contests.json",
        "aaSorting": [ [2, 'desc'] ],
        "sPaginationType": "bs_full" ,
        "aLengthMenu": [[25, 50, 100, 150, 200], [25, 50, 100, 150, 200]] ,
        "iDisplayLength": globalConfig.limits.contests_per_page,
        "iDisplayStart": (this.currentInfo.page - 1) * globalConfig.limits.contests_per_page,
        "aoColumnDefs": [ 
          { "sWidth": "400px", "aTargets": [ 1 ] },
          { "sWidth": "180px", "aTargets": [ 2, 3 ] },
          { "bSortable": false, "aTargets": [ 4, 5 ] },
          { "bVisible": false, "aTargets": [ 6, 7, 8 ] },
          {
            "mRender": function ( data, type, full ) {
              return "<a href='" + basePath + "contests/" + full[0] + "' title='" + BNUOJ.Utils.escapeHtml(BNUOJ.Utils.stripTags(data)) + "'>" + data + "</a>";
            },
            "aTargets": [ 1 ]
          },
          {
            "mRender": function ( data, type, full ) {
              return "<a href='" + basePath + "contests/" + data + "'>" + data + "</a>";
            },
            "aTargets": [ 0 ]
          },
          {
            "mRender": function ( data, type, full ) {
              if (data == "Passed") {
                return "<span class='passed'>" + data + "</a>";
              } else if (data == "Scheduled") {
                return "<span class='scheduled'>" + data + "</a>";
              } else {
                return "<span class='running'>" + data + "</a>";
              }
            },
            "aTargets": [ 4 ]
          },
          {
            "mRender": function ( data, type, full ) {
              if (data == "Public") {
                return "<span class='public'>" + data + "</a>";
              } else {
                return "<span class='private'>" + data + "</a>";
              }
            },
            "aTargets": [ 5 ]
          },
          {
            "mRender": function ( data, type, full ) {
              if (!_.isEmpty(data)) {
                return "<a href='" + basePath + "users/" + data + "' target='_blank'>" + data + "</a>";
              }
              else  {
                return "-";
              }
            },
            "aTargets": [ 6 ]
          },
          {
            "mRender": function ( data, type, full ) {
              return BNUOJ.Utils.getLocalTime(data);
            },
            "aTargets": [ 2, 3 ]
          }
        ]
    });
    }
  });
}).call(this, jQuery);