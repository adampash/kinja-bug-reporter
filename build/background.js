/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	/* REACT HOT LOADER */ if (false) { (function () { var ReactHotAPI = require("/Users/aop/code/labs/active/KinjaBugReporter/node_modules/react-hot-loader/node_modules/react-hot-api/modules/index.js"), RootInstanceProvider = require("/Users/aop/code/labs/active/KinjaBugReporter/node_modules/react-hot-loader/RootInstanceProvider.js"), ReactMount = require("react/lib/ReactMount"), React = require("react"); module.makeHot = module.hot.data ? module.hot.data.makeHot : ReactHotAPI(function () { return RootInstanceProvider.getRootInstances(ReactMount); }, React); })(); } (function () {

	var capture, cropData, tab;

	console.log('load');

	tab = null;

	chrome.browserAction.onClicked.addListener(function(_tab) {
	  tab = _tab;
	  console.log('clicked');
	  return chrome.tabs.executeScript(tab.ib, {
	    file: 'reporter.js'
	  });
	});

	cropData = function(str, coords, callback) {
	  var img;
	  img = new Image();
	  img.onload = function() {
	    var canvas, ctx;
	    canvas = document.createElement('canvas');
	    canvas.width = coords.w;
	    canvas.height = coords.h;
	    ctx = canvas.getContext('2d');
	    ctx.drawImage(img, coords.x, coords.y, coords.w, coords.h, 0, 0, coords.w, coords.h);
	    callback({
	      dataUri: canvas.toDataURL()
	    });
	  };
	  return img.src = str;
	};

	capture = function(coords) {
	  return chrome.tabs.captureVisibleTab(null, {
	    "format": "png"
	  }, function(dataUrl) {
	    return cropData(dataUrl, coords, function(data) {
	      return chrome.tabs.sendMessage(tab.id, {
	        image: data.dataUri
	      });
	    });
	  });
	};

	chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
	  console.log('got message!');
	  if (request.type === "coords") {
	    return capture(request.coords);
	  }
	});


	/* REACT HOT LOADER */ }).call(this); if (false) { (function () { module.hot.dispose(function (data) { data.makeHot = module.makeHot; }); if (module.exports && module.makeHot) { var makeExportsHot = require("/Users/aop/code/labs/active/KinjaBugReporter/node_modules/react-hot-loader/makeExportsHot.js"), foundReactClasses = false; if (makeExportsHot(module, require("react"))) { foundReactClasses = true; } var shouldAcceptModule = true && foundReactClasses; if (shouldAcceptModule) { module.hot.accept(function (err) { if (err) { console.error("Cannot not apply hot update to " + "background.coffee" + ": " + err.message); } }); } } })(); }

/***/ }
/******/ ]);