(function($) {
  BNUOJ.Views.DatatableHistoryView = BNUOJ.Views.PageView.extend({
    events: _.extend({
    }, BNUOJ.Views.PageView.prototype.events),

    // should contain DATATABLE and SEARCH_INPUT in inherited class
    _selectors: _.extend({
    }, BNUOJ.Views.PageView.prototype._selectors),

    activeNavbar: null,

    isPoppingState: false,
    isPushingState: false,

    listTable: null,
    withSearchBar: false,
    currentInfo: {
      page: 1,
      searchString: ""
    },
    initialInfo: null,
    tableOptions: null,

    parseBaseUrlParams: function(url) {
      url = url || window.location.href;
      this.currentInfo.page = parseInt(BNUOJ.Utils.getUrlParam('page', url) || "1");
      if (_.isNaN(this.currentInfo.page)) this.currentInfo.page = 1;
      this.currentInfo.searchString = BNUOJ.Utils.getUrlParam('searchstr', url) || "";
    },

    // parse view specific params
    // should be overwrited
    parseUrlParams: function() {

    },

    // should be overwrited
    beforeRenderView: function() {

    },

    // should be overwrited
    setupTableOptions: function() {

    },

    beforeRender: function() {
      this.parseBaseUrlParams();
      this.parseUrlParams();
      // store info for landing page
      this.initialInfo = _.clone(this.currentInfo);
      this.isPoppingState = true;
      this.beforeRenderView();
      this.setupTableOptions();
    },

    // filter view specific columns
    // should be overwrited
    filterStateInfo: function(info) {

    },

    changeState: function() {
      var state = History.getState();
      var info = state.data;
      // for landing page, we should use inital info
      if (_.isEmpty(info)) info = this.initialInfo;

      // filter search
      if (this.withSearchBar && info.searchString != this.currentInfo.searchString) {
        $(this._selectors.SEARCH_INPUT).val(info.searchString);
        this.listTable.fnFilter(info.searchString);
      }

      this.filterStateInfo(info);

      // paging
      if (info.page != this.currentInfo.page) {
        this.listTable.fnPageChange(info.page - 1);
        
      }

      // store current data
      this.currentInfo = _.clone(info);
    },

    // should be overwrited
    afterRenderView: function() {
    },

    afterAll: function(evt) {
      var self = this;
      History.Adapter.bind(window, 'statechange', function(){
        if (!self.isPushingState) {
          self.isPoppingState = true;
          self.changeState();
        }
      });
      this.afterViewAll();
    },

    // should be overwrited
    updateCurrentInfo: function() {
    },

    // should be overwrited
    getViewUrl: function() {
    },

    // should be overwrited
    getCurrentTitle: function() {
    },

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

      // avoid push empty string to history
      url += ("&page=" + this.currentInfo.page);
      if (this.withSearchBar) {
        url += (this.currentInfo.searchString == "" || this.currentInfo.searchString == null ? "" : "&searchstr=" + encodeURIComponent(this.currentInfo.searchString));
      }

      if (url != "") {
        url = "?" + url.substr(1);
      }
      this.isPushingState = true;
      History.pushState(_.clone(this.currentInfo), this.getCurrentTitle(), url);
      this.isPushingState = false;
    },

    // should be overwrited
    renderView: function() {
    },

    renderPage: function() {
      this.generateListTable();
      this.renderView();
    },

    // add ajax params for datatables
    // should be overwrited
    addAjaxParams: function(aoData) {
    },

    // should be overwrited
    afterTableDrawn: function() {
    },

    generateListTable: function() {
      var self = this;
      var options = {
        "bProcessing": true,
        "bServerSide": true,
        "fnServerParams": function(aoData) {
          // stop previous ajax, a little bit hacky
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
        this.listTable = $(this._selectors.DATATABLE).dataTable(options).fnSetFilteringDelay();
      } else {
        this.listTable = $(this._selectors.DATATABLE).dataTable(options);
      }
    }
    
  });
}).call(this, jQuery);