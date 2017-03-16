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
/******/ ({

/***/ 0:
/***/ function(module, exports, __webpack_require__) {

	var __weex_template__ = __webpack_require__(258)
	var __weex_style__ = __webpack_require__(259)
	var __weex_script__ = __webpack_require__(260)

	__weex_define__('@weex-component/f1edaa994f4c5a505cfb7f32ca9ee569', [], function(__weex_require__, __weex_exports__, __weex_module__) {

	    __weex_script__(__weex_module__, __weex_exports__, __weex_require__)
	    if (__weex_exports__.__esModule && __weex_exports__.default) {
	      __weex_module__.exports = __weex_exports__.default
	    }

	    __weex_module__.exports.template = __weex_template__

	    __weex_module__.exports.style = __weex_style__

	})

	__weex_bootstrap__('@weex-component/f1edaa994f4c5a505cfb7f32ca9ee569',undefined,undefined)

/***/ },

/***/ 258:
/***/ function(module, exports) {

	module.exports = {
	  "type": "div",
	  "classList": [
	    "container"
	  ],
	  "children": [
	    {
	      "type": "list",
	      "classList": [
	        "list"
	      ],
	      "attr": {
	        "loadmore": "loadmore",
	        "loadmoreoffset": "500"
	      },
	      "children": [
	        {
	          "type": "cell",
	          "append": "tree",
	          "repeat": {
	            "expression": function () {return this.rows},
	            "value": "row"
	          },
	          "children": [
	            {
	              "type": "div",
	              "classList": [
	                "item"
	              ],
	              "children": [
	                {
	                  "type": "text",
	                  "classList": [
	                    "item-title"
	                  ],
	                  "style": {
	                    "textAlign": function () {return this.row.align},
	                    "backgroundColor": function () {return this.row.bg}
	                  },
	                  "attr": {
	                    "value": function () {return this.row.message}
	                  }
	                }
	              ]
	            }
	          ]
	        }
	      ]
	    },
	    {
	      "type": "input",
	      "attr": {
	        "type": "text",
	        "placeholder": "请输入聊天信息",
	        "autofocus": "false",
	        "value": ""
	      },
	      "classList": [
	        "input"
	      ],
	      "events": {
	        "change": "onchange",
	        "input": "oninput"
	      },
	      "id": "input"
	    },
	    {
	      "type": "div",
	      "style": {
	        "flexDirection": "row",
	        "justifyContent": "center"
	      },
	      "children": [
	        {
	          "type": "text",
	          "classList": [
	            "button"
	          ],
	          "events": {
	            "click": "connect"
	          },
	          "attr": {
	            "value": "connect"
	          }
	        },
	        {
	          "type": "text",
	          "classList": [
	            "button"
	          ],
	          "events": {
	            "click": "send"
	          },
	          "attr": {
	            "value": "send"
	          }
	        },
	        {
	          "type": "text",
	          "classList": [
	            "button"
	          ],
	          "events": {
	            "click": "close"
	          },
	          "attr": {
	            "value": "close"
	          }
	        }
	      ]
	    },
	    {
	      "type": "text",
	      "style": {
	        "color": "#000000",
	        "height": 80
	      },
	      "attr": {
	        "value": function () {return this.info}
	      }
	    }
	  ]
	}

/***/ },

/***/ 259:
/***/ function(module, exports) {

	module.exports = {
	  "input": {
	    "fontSize": 40,
	    "height": 80,
	    "width": 600,
	    "marginBottom": 40
	  },
	  "button": {
	    "fontSize": 36,
	    "width": 150,
	    "color": "#41B883",
	    "textAlign": "center",
	    "paddingTop": 10,
	    "paddingBottom": 10,
	    "borderWidth": 2,
	    "borderStyle": "solid",
	    "marginRight": 20,
	    "marginBottom": 20,
	    "borderColor": "rgb(162,217,192)",
	    "backgroundColor": "rgba(162,217,192,0.2)"
	  },
	  "container": {
	    "flex": 1,
	    "justifyContent": "center",
	    "alignItems": "center",
	    "flexDirection": "column",
	    "borderTopStyle": "solid",
	    "borderTopWidth": 2,
	    "borderTopColor": "#DFDFDF"
	  },
	  "list": {
	    "flex": 1,
	    "width": 750,
	    "justifyContent": "center",
	    "alignItems": "center",
	    "flexDirection": "column",
	    "borderTopStyle": "solid",
	    "borderTopWidth": 2,
	    "borderTopColor": "#DFDFDF"
	  },
	  "item": {
	    "justifyContent": "center",
	    "height": 100,
	    "padding": 20
	  },
	  "item-title": {
	    "fontSize": 30
	  }
	}

/***/ },

/***/ 260:
/***/ function(module, exports) {

	module.exports = function(module, exports, __weex_require__){'use strict';

	var dom = __weex_require__('@weex-module/dom');
	var websocket = __weex_require__('@weex-module/webSocket');
	module.exports = {
	  data: function () {return {
	    rows: [],
	    connectinfo: '',
	    sendinfo: '',
	    onopeninfo: '',
	    onmessage: '',
	    oncloseinfo: '',
	    onerrorinfo: '',
	    closeinfo: '',
	    txtInput: '',
	    info: '',
	    message: '',
	    align: 'left',
	    bg: 'white'
	  }},
	  methods: {
	    insert: function insert(e) {
	      this.rows.push({ id: 999 });
	      dom.scrollToElement(this.$el('foot'), { offset: 0 });
	    },
	    connect: function connect() {
	      websocket.WebSocket('ws://115.29.193.48:8088', '');
	      var self = this;
	      self.info = 'connecting...';
	      websocket.onopen = function (e) {
	        self.info = 'websocket open';
	      };
	      websocket.onmessage = function (e) {
	        self.onmessage = e.data;

	        self.align = 'left';
	        self.bg = 'white';
	        if (self.sendinfo == self.onmessage) {
	          self.align = 'right';
	          self.bg = '#00CD00';
	        }
	        self.rows.push({ message: e.data, align: self.align, bg: self.bg });
	      };
	      websocket.onerror = function (e) {
	        self.onerrorinfo = e.data;
	      };
	      websocket.onclose = function (e) {
	        self.onopeninfo = '';
	        self.onerrorinfo = e.code;
	      };
	    },
	    send: function send(e) {
	      var input = this.$el('input');
	      input.blur();
	      websocket.send(this.txtInput);
	      this.sendinfo = this.txtInput;
	    },
	    oninput: function oninput(event) {
	      this.txtInput = event.value;
	    },
	    close: function close(e) {
	      websocket.close();
	    }
	  }
	};}
	/* generated by weex-loader */


/***/ }

/******/ });