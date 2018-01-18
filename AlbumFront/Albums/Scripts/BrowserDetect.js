var tmpInit = null;
var isIEBrowser, isNNBrowser, isOperaBrowser;
//var _initBrows = initBrows();

(function initBrows()
{
  isIEBrowser = navigator.appName.indexOf( "Microsoft" ) != -1;
  isOperaBrowser = navigator.userAgent.indexOf( "Opera" ) != -1;
  isNNBrowser = navigator.appName.indexOf( "Netscape" ) != -1;  
  //isOperaBrowser can be TRUE with IE or NN at one time: Opera is working in emulation mode and can be switched
})();

function reportBrowser()
{
	alert( "IE=" + isIEBrowser.toString() + "; NN=" + isNNBrowser + "; OP=" + isOperaBrowser );
}
