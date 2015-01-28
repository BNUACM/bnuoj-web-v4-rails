(function($) {
  // Base class for the view that contains a single datatable.
  BNUOJ.Views.DatatableHistoryView = BNUOJ.Views.PageView.extend({
    events: _.extend({
    }, BNUOJ.Views.PageView.prototype.events),

    // Should contain DATATABLE and SEARCH_INPUT in inherited class.
    _selectors: _.extend({
    }, BNUOJ.Views.PageView.prototype._selectors),

    activeNavbar: null,

    isPoppingState: false,
    isPushingState: false,

    // Current list table.
    listTable: null,
    // Whether the datatable is searchable.
    withSearchBar: false,
    // Current state of the datatable.
    currentInfo: {
      page: 1,
      searchString: ""
    },
    // Initital state of the datatable.
    initialInfo: null,
    // Render options of the datatable.
    tableOptions: null,

    // Parse url params.
    parseBaseUrlParams: function(url) {
      url = url || window.location.href;
      this.currentInfo.page = parseInt(BNUOJ.Utils.getUrlParam('page', url) || "1");
      if (_.isNaN(this.currentInfo.page)) this.currentInfo.page = 1;
      this.currentInfo.searchString = BNUOJ.Utils.getUrlParam('searchstr', url) || "";
    },

    // Parse view specific params, should be overrided.
    parseUrlParams: function() {

    },

    // Can be overrided.
    beforeRenderView: function() {
    },

    // Should be overrided.
    setupTableOptions: function() {
    },

    // Setup initial configs.
    beforeRender: function() {
      this.parseBaseUrlParams();
      this.parseUrlParams();
      // Store landing page info for history.js
      History.replaceState(_.clone(this.currentInfo), this.getCurrentTitle(), window.location.href);

      this.isPoppingState = true;
      this.beforeRenderView();
      this.setupTableOptions();
    },

    // Filter view specific columns. Can be overrided.
    filterStateInfo: function(info) {
    },

    // Change the state when datatable navigates.
    changeState: function() {
      var state = History.getState();
      var info = state.data;

      // Filters search string.
      if (this.withSearchBar && info.searchString != this.currentInfo.searchString) {
        $(this._selectors.SEARCH_INPUT).val(info.searchString);
        this.listTable.fnFilter(info.searchString);
      }
      this.filterStateInfo(info);

      // Paging.
      if (info.page != this.currentInfo.page) {
        this.listTable.fnPageChange(info.page - 1);
      }

      // Store current data.
      this.currentInfo = _.clone(info);
    },

    // Can be overrided.
    afterRenderView: function() {
    },

    afterAll: function(evt) {
      var self = this;
      History.Adapter.bind(window, 'statechange', function(){
        // Update state boolean.
        if (!self.isPushingState) {
          self.isPoppingState = true;
          self.changeState();
        }
      });
      this.afterViewAll();
    },

    // Should be overrided.
    updateCurrentInfo: function() {
    },

    // Should be overrided.
    getViewUrl: function() {
    },

    // Should be overrided.
    getCurrentTitle: function() {
    },

    // Updates the url for current state.
    updateUrl: function() {
      if (!this.listTable) {
        return;
      }

      this.currentInfo.page = this.listTable.fnPagingInfo().iPage + 1;
      if (this.withSearchBar) {
        this.currentInfo.searchString = $(this._selectors.SEARCH_INPUT).val();
      }
      this.updateCurrentInfo();

      var url = this.getViewUrl();
      // Avoid push empty string to history。
      url += ("&page=" + this.currentInfo.page);
      if (this.withSearchBar) {
        url += (this.currentInfo.searchString == "" || this.currentInfo.searchString == null) ? 
          "" : "&searchstr=" + encodeURIComponent(this.currentInfo.searchString);
      }
      if (url != "") {
        url = "?" + url.substr(1);
      }
      this.isPushingState = true;
      History.pushState(_.clone(this.currentInfo), this.getCurrentTitle(), url);
      this.isPushingState = false;
    },

    // Should be overrided.
    renderView: function() {
    },

    renderPage: function() {
      this.generateListTable();
      this.renderView();
    },

    // Add ajax params for datatables. Can be overrided.
    addAjaxParams: function(aoData) {
    },

    // When table was completely drawn. Can be overrided.
    afterTableDrawn: function() {
    },

    // Produces the datatable.
    generateListTable: function() {
      var self = this;
      var options = {
        "bProcessing": true,
        "bServerSide": true,
        "fnServerParams": function(aoData) {
          // Stop ongoing ajax.
          if (this.fnSettings().jqXHR) this.fnSettings().jqXHR.abort();
          self['addAjaxParams'].call(self, aoData);
        },
        "oSearch": {"sSearch": self.currentInfo.searchString},
        "fnDrawCallback": function() {
          if (!self.isPoppingState) self.updateUrl();
          self.afterTableDrawn();
          self.isPoppingState = false;
        }
      };
      _.extend(options, this.tableOptions)
      if (this.withSearchBar) {
        // We should delay the response when user is typing.
        this.listTable = $(this._selectors.DATATABLE).dataTable(options).fnSetFilteringDelay();
      } else {
        this.listTable = $(this._selectors.DATATABLE).dataTable(options);
      }
    }
    
  });
}).call(this, jQuery);