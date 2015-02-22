(function($) {
  // Problem list page.
  BNUOJ.Views.ProblemListView = BNUOJ.Views.DatatableHistoryView.extend({
    events: _.extend({
      "click #problist a.source_search": "clickSource",
      "click .unsolved-btns .btn": "changeUnsolved",
      "click .stat-btns .btn": "changeShownStat",
      "change #selectoj": "changeOJSelector"
    }, BNUOJ.Views.DatatableHistoryView.prototype.events),

    _selectors: _.extend({
      DATATABLE: "#problist",
      SEARCH_INPUT: "#problist_filter input[type=search]",
      OJ_SELECTOR: "#selectoj",
      UNSOLVED_BTNS: ".unsolved-btns .btn",
      STAT_BTNS: ".stat-btns .btn"
    }, BNUOJ.Views.DatatableHistoryView.prototype._selectors),

    activeNavbar: "#problem",

    withSearchBar: true,

    currentInfo: _.extend({
      OJ: null,
      shownStat: null,
      unsolveCheck: null,
    }, BNUOJ.Views.DatatableHistoryView.prototype.currentInfo),

    // Override.
    parseUrlParams: function(url) {
      url = url || window.location.href;
      this.currentInfo.unsolveCheck =
          BNUOJ.Utils.getUrlParam('unsolved', url) || "0";
      this.currentInfo.shownStat = BNUOJ.Utils.getUrlParam('stat', url) || "0";
      this.currentInfo.OJ = BNUOJ.Utils.getUrlParam('oj', url) || "";
    },

    // Override.
    filterStateInfo: function(info) {
      if (info.OJ != this.currentInfo.OJ) {
        $(this._selectors.OJ_SELECTOR).val(info.OJ).trigger('change');
      }

      if (info.shownStat != this.currentInfo.shownStat) {
        $(this._selectors.STAT_BTNS).filter(
            '[stat="' + info.shownStat + '"]').click();
      }

      if (info.unsolveCheck != this.currentInfo.unsolveCheck) {
        $(this._selectors.UNSOLVED_BTNS).filter(
            '[unsolved="' + info.unsolveCheck + '"]').click();
      }
    },

    // Override.
    afterViewAll: function() {
      if (this.currentInfo.OJ != "") {
        $(this._selectors.OJ_SELECTOR).val(this.currentInfo.OJ).
            trigger('change');
      }
      $(this._selectors.STAT_BTNS).filter(
          '[stat="' + this.currentInfo.shownStat + '"]').click();
      $(this._selectors.UNSOLVED_BTNS).filter(
          '[unsolved="' + this.currentInfo.unsolveCheck + '"]').
              addClass('active');
    },

    // Change the visibility of stats columns.
    changeShownStat: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.shownStat = $(evt.target).attr('stat');
      $(this._selectors.STAT_BTNS).removeClass('active');
      $(evt.target).addClass('active')

      if (this.currentInfo.shownStat == "0") {
        this.listTable.fnSetColumnVis( 6, false, false );
        this.listTable.fnSetColumnVis( 7, false, false );
        this.listTable.fnSetColumnVis( 8, false, false );
        this.listTable.fnSetColumnVis( 9, false, false );
        this.listTable.fnSetColumnVis( 4, true, false );
        this.listTable.fnSetColumnVis( 5, true, false );
      }
      else if (this.currentInfo.shownStat == "1") {
        this.listTable.fnSetColumnVis( 4, false, false );
        this.listTable.fnSetColumnVis( 5, false, false );
        this.listTable.fnSetColumnVis( 8, false, false );
        this.listTable.fnSetColumnVis( 9, false, false );
        this.listTable.fnSetColumnVis( 6, true, false );
        this.listTable.fnSetColumnVis( 7, true, false );
      }
      else if (this.currentInfo.shownStat == "2") {
        this.listTable.fnSetColumnVis( 6, false, false );
        this.listTable.fnSetColumnVis( 7, false, false );
        this.listTable.fnSetColumnVis( 4, false, false );
        this.listTable.fnSetColumnVis( 5, false, false );
        this.listTable.fnSetColumnVis( 8, true, false );
        this.listTable.fnSetColumnVis( 9, true, false );
      }

      // Since we aren't firing any ajax calls in this function,
      // we should check whether there is ongoing ajax to avoid conflict
      if (!this.isPoppingState) this.updateUrl();

    },

    // User clicked show unsolved problem button.
    changeUnsolved: function(evt) {
      if ($(evt.target).hasClass('active')) return;
      this.currentInfo.unsolveCheck = $(evt.target).attr('unsolved');
      $(this._selectors.UNSOLVED_BTNS).removeClass('active');
      $(evt.target).addClass('active');
      this.listTable.fnReloadAjax();
    },

    // User changed which OJ to display.
    changeOJSelector: function(evt) {
      this.currentInfo.OJ = $(evt.target).val();
      this.listTable.fnFilter(this.currentInfo.OJ, 9);
    },

    // User clicked source link of the problem.
    clickSource: function(evt) {
      this.currentInfo.searchString = $(evt.target).text();
      $(this._selectors.SEARCH_INPUT).val(this.currentInfo.searchString);
      this.listTable.fnFilter(this.currentInfo.searchString);
    },

    // Override.
    getCurrentTitle: function() {
      return "Problem List";
    },

    // Override.
    getViewUrl: function() {
      return (
          (this.currentInfo.OJ == "" || this.currentInfo.OJ == null ?
              "" : "&oj=" + encodeURIComponent(this.currentInfo.OJ)) +
          (this.currentInfo.unsolveCheck == "0" ||
              this.currentInfo.unsolveCheck == null ?
                  "" : "&unsolved=" +
                      encodeURIComponent(this.currentInfo.unsolveCheck)) +
          (this.currentInfo.shownStat == "0" ||
              this.currentInfo.shownStat == null ?
                  "" : "&stat=" +
                      encodeURIComponent(this.currentInfo.shownStat)));
    },

    // Override. Nothing specific to do.
    renderView: function() {
    },

    // Add ajax params for on going request.
    addAjaxParams: function(aoData) {
      // Unresolve is not an acutal column of the data table.
      aoData.push({
        "name" : 'unsolved',
        "value" : this.currentInfo.unsolveCheck
      });
    },

    // Override.
    setupTableOptions: function() {
      this.tableOptions = ({
        "sDom": '<"row"<"col-sm-4"f><"col-sm-8"p>r<"clearfix">' +
            '<"table-responsive"t><"col-sm-9"i><"col-sm-3"l>>',
        "oLanguage": {
          "sEmptyTable": "No problems found.",
          "sZeroRecords": "No problems found.",
          "sInfoEmpty": "No entries to show"
        },
        "sAjaxSource": basePath + "problems.json",
        "aaSorting": [ [ 0, 'asc'] ],
        "sPaginationType": "bs_full",
        "aLengthMenu": [[25, 50, 100, 150, 200], [25, 50, 100, 150, 200]] ,
        "iDisplayLength": globalConfig.limits.problems_per_page,
        "iDisplayStart":
            (this.currentInfo.page - 1) * globalConfig.limits.problems_per_page,
        "aoColumnDefs": [
          { "sWidth": "65px", "aTargets": [ 10 ] },
          { "sWidth": "55px", "aTargets": [ 0, 1, 4, 5, 6, 7, 8, 9, 11 ] },
          { "bSortable": false, "aTargets": [ 0, 10 ] },
          { "bVisible": false , "aTargets": [ 6, 7, 8, 9 ] },
          {
            "mRender": function ( data, type, full ) {
              // Enhance accpeted number column.
              return "<a href='" + basePath + "statuses?pid=" + full[1] +
                  "&result=Accepted'>" + full[4] + "</a>";
            },
            "aTargets": [ 4 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance total number column.
              return "<a href='" + basePath + "statuses?pid=" + full[1] + "'>"
                  + full[5] + "</a>";
            },
            "aTargets": [ 5 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance pid column.
              return "<a href='" + basePath + "problems/" + full[1] +
                  "' title='" + full[2] + "' >" + full[2] + "</a>";
            },
            "aTargets": [ 2 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance source column.
              return "<a class='source_search' href='#' title='" + data +
                  "'>" + data + "</a>";
            },
            "aTargets": [ 3 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance problem title column.
              return "<a href='" + basePath + "problems/" + data + "'>" + data +
                  "</a>";
            },
            "aTargets": [ 1 ]
          },
          {
            "mRender": function ( data, type, full ) {
              // Enhance solve flag column.
              // TODO(51isoft): I18n.
              data = $.trim(data);
              if (data == "Yes") return "<span class='ac'>" + data + "</span>";
              if (data == "No") return "<span class='wa'>" + data + "</span>";
              return data;
            },
            "aTargets": [ 0 ]
          }
        ]
      });
    }
  });
}).call(this, jQuery);