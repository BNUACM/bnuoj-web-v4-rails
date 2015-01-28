(function($) {
  BNUOJ.Utils = {
    // Renders server time in navigation bar.
    displayNavTime: function() {
      var padlength = function(what) {
        var output = (what.toString().length == 1) ? ("0" + what) : what;
        return output;
      };
      ++ timePassed;
      var displayTime = moment(currentServerTime, globalConfig.misc.datetime_format + ' Z').add(timePassed, 's').local();
      $("#servertime").text(displayTime.format(globalConfig.misc.datetime_format));
    },

    // Get current server time.
    getTime: function() {
      $.get(basePath + "server_time", {'r': Math.random()}).done(function(data){
        currentServerTime = data;
        timePassed = 0
      });
    },

    // Convert server time to local time.
    getLocalTime: function(servertime) {
      var displayTime = moment(servertime + ' ' + globalConfig.misc.server_timezone_offset , globalConfig.misc.datetime_format + ' Z').local();
      return displayTime.format(globalConfig.misc.datetime_format);
    },

    // Convert local time to server time.
    convertToServerTime: function(localtime) {
      var displayTime = moment(localtime);
      return displayTime.zone(globalConfig.misc.server_timezone_offset).format(globalConfig.misc.datetime_format);
    },

    // Get the result class for given status.
    // TODO(51isoft): Consider move this to proper place.
    getResultClass: function(res) {
      switch (res) {
        case "Compile Error":
          return "ce";
          break;
        case "Accepted":
          return "ac";
          break;
        case "Wrong Answer":
          return "wa";
          break;
        case "Runtime Error":
          return "re";
          break;
        case "Time Limit Exceed":
          return "tle";
          break;
        case "Memory Limit Exceed":
          return "mle";
          break;
        case "Output Limit Exceed":
          return "ole";
          break;
        case "Presentation Error":
          return "pe";
          break;
        case "Challenged":
          return "wa";
          break;
        case "Pretest Passed":
          return "ac";
          break;
        case "Restricted Function":
          return "rf";
          break;
        default:
          return "";
      }
    },

    // Strip html tags in the string.
    stripTags: function(html) {
      return html.replace(/(<([^>]+)>)/ig, "")
    },

    // Get param value for given url or current url if not set.
    getUrlParam: function(param, url) {
      url = url || window.location.href;
      return decodeURIComponent((RegExp("[?|&|#]" + param + "=" + "(.*?)(&|#|;|$)").exec(url) || [null, ""])[1].replace(/\+/g, "%20")) || null
    },

    // Escapes given string to HTML-safe content.
    escapeHtml: function(unsafe) {
      return String(unsafe)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&apos;");
    },

    // Get generated csrf token.
    getCsrfToken: function() {
      return $("meta[name=csrf-token]").attr('content');
    },

    // Get the cookie value of given name.
    getCookie: function(name) {
      return $.cookie(globalConfig.misc.cookie_prefix + name);
    }

  }

}).call(this, jQuery);
