/**
 * Created by lume on 2017/9/15.
 */
;(function(w) {
  var _config = w.comConfig,
    comFuc = {
      init: function(){
        var self = this;
        self.configRem();
      },
      configRem: function(){
        if(_config && !_config.hideRem){
          fixRem();
          window.addEventListener('resize', fixRem, false);
        }
      },
      fixRem: function(){
        var windowWidth =  document.documentElement.clientWidth || window.innerWidth || document.body.clientWidth;
        var rootSize = 28 * ( windowWidth / 375);
        var htmlNode = document.getElementsByTagName("html")[0];
        htmlNode.style.fontSize = rootSize+'px';
      }
    };

  //通过window width 修改html font-size
  function fixRem(){
    var windowWidth =  document.documentElement.clientWidth || window.innerWidth || document.body.clientWidth;
    var rootSize = 28 * ( windowWidth / 375);
    var htmlNode = document.getElementsByTagName("html")[0];
    htmlNode.style.fontSize = rootSize+'px';
  }
  fixRem();

  comFuc.init();

})(window);
