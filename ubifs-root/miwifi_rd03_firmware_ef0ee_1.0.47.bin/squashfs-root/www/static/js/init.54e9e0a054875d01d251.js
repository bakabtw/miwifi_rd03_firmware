webpackJsonp([36],{"47dl":function(e,t){},"6zzU":function(e,t,n){"use strict";var i=n("fZjL"),o=n.n(i),a=n("mvHQ"),r=n.n(a),s=n("Xxa5"),c=n.n(s),u=n("exGp"),p=n.n(u),l=n("W4G+"),f=n("Av7u"),d=n.n(f),m={RA72:"Xiaomi_",RA70:"Xiaomi_",RA50:"Redmi_",RA74:"Redmi_",RA80:"Xiaomi_",RA81:"Redmi_",RA82:"Xiaomi_",RA83:"Xiaomi_",RB01:"Xiaomi_",RB03:"Redmi_",RB06:"Redmi_",RA71:"Redmi_",RB08:"Xiaomi_",RC01:"Xiaomi_",RD04:"Xiaomi_",RD05:"Xiaomi_"},h=n("mtWM"),w=n.n(h);w.a.defaults.timeout=5e4;t.a={goBack:function(e){e.$router.back(-1)},detectDevice:function(){var e=function(){var e=navigator.userAgent;navigator.appVersion;return{trident:e.indexOf("Trident")>-1,presto:e.indexOf("Presto")>-1,webKit:e.indexOf("AppleWebKit")>-1,gecko:e.indexOf("Gecko")>-1&&-1==e.indexOf("KHTML"),mobile:!!e.match(/AppleWebKit.*Mobile.*/),ios:!!e.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/),android:e.indexOf("Android")>-1||e.indexOf("Linux")>-1,iPhone:e.indexOf("iPhone")>-1,iPad:e.indexOf("iPad")>-1,webApp:-1==e.indexOf("Safari")}}();(navigator.browserLanguage||navigator.language).toLowerCase();return e.mobile||e.ios||e.android||e.iPhone||e.iPad?e.ios?"ios":"android":"notmobile"},setInitLog:function(e){var t=this;return p()(c.a.mark(function n(){return c.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:return t.next=2,Object(l.b)(e);case 2:t.sent.data.code;case 4:case"end":return t.stop()}},n,t)}))()},setCookie:function(e,t,n){if(window.localStorage){if(null!=n&&0!=n){var i=null;try{i=JSON.parse(t)}catch(e){i={defaultname:t}}return"number"==typeof i&&(i={defaultname:t}),(o=new Date).setTime(o.getTime()+24*n*3600*1e3),i.expires=o.getTime(),void window.localStorage.setItem(e,r()(i))}window.localStorage.setItem(e,t)}else{var o;if(n<0)return(o=new Date).setTime(o.getTime()-1e3),void(document.cookie=e+"="+escape(t)+";expires="+o.toUTCString());if(n>0)(o=new Date).setTime(o.getTime()+24*n*3600*1e3),document.cookie=e+"="+escape(t)+";expires="+o.toUTCString()+";path=/";else document.cookie=e+"="+escape(t)+";path=/"}},getCookie:function(e){if(window.localStorage){var t=window.localStorage.getItem(e);if(null!=t&&""!=t)try{var n=JSON.parse(t),i=n.expires;if(null!=i&&""!=i)return(new Date).getTime()-i>0?(window.localStorage.removeItem(e),""):null==n.defaultname||""==n.defaultname?"":n.defaultname}catch(e){}return t}if(document.cookie.length>0){var o=document.cookie,a=o.indexOf(e);if(-1==a)return"";var r=o.indexOf(";",a);return(r=-1)&&(r=o.length),unescape(o.substring(a+e.length+1,r))}return""},Encrypt:{key:"a2ffa5c9be07488bbb04a3a47d3c5f6a",iv:"64175472480004614961023454661220",nonce:null,getCookie:function(){if(window.localStorage){var e=window.localStorage.getItem(name);if(null!=e&&""!=e)try{var t=JSON.parse(e),n=t.expires;if(null!=n&&""!=n)return(new Date).getTime()-n>0?(window.localStorage.removeItem(name),""):null==t.defaultname||""==t.defaultname?"":t.defaultname}catch(e){}return e}if(document.cookie.length>0){var i=document.cookie,o=i.indexOf(name);if(-1==o)return"";var a=i.indexOf(";",o);return(a=-1)&&(a=i.length),unescape(i.substring(o+name.length+1,a))}return""},init:function(){var e=this.nonceCreat();return this.nonce=e,this.nonce},nonceCreat:function(){return[0,this.getCookie("mac")||"",Math.floor((new Date).getTime()/1e3),Math.floor(1e4*Math.random())].join("_")},oldPwd:function(e){return 1==window.localStorage.getItem("newEncryptMode")?d.a.SHA256(this.nonce+d.a.SHA256(e+this.key).toString()).toString():d.a.SHA1(this.nonce+d.a.SHA1(e+this.key).toString()).toString()},newPwd:function(e,t){var n=d.a.SHA1(e+this.key).toString(),i=d.a.SHA1(t+this.key).toString();n=(n=d.a.enc.Hex.parse(n).toString()).substr(0,32),n=d.a.enc.Hex.parse(n);var o=d.a.enc.Hex.parse(this.iv);return d.a.AES.encrypt(i,n,{iv:o,mode:d.a.mode.CBC,padding:d.a.pad.Pkcs7}).toString()},newPwd256:function(e,t){var n=d.a.SHA256(e+this.key).toString(),i=d.a.SHA256(t+this.key).toString();n=(n=d.a.enc.Hex.parse(n).toString()).substr(0,32),n=d.a.enc.Hex.parse(n);var o=d.a.enc.Hex.parse(this.iv);return d.a.AES.encrypt(i,n,{iv:o,mode:d.a.mode.CBC,padding:d.a.pad.Pkcs7}).toString()}},formatSsidName:function(e,t){var n=void 0;if(-1!=e.indexOf("-")){var i=e.substring(e.length-4).toUpperCase(),o=(n=e.split("-")[2]).split("_")[0].toUpperCase();e=m[o]+i}else{if(3==(n=e.split("_")).length)if("Xiaomi"==n[0]||"Redmi"==n[0])parseInt("FFFF",16)-parseInt(n[1],16)==parseInt(n[2],16)&&(e=n[0]+"_"+n[1]);else if(t){e=t+"_"+e.split("_")[2].toUpperCase()}}return e},pint:function(e){return parseInt(e,10)},secondToHour:function(e){var t=this.pint(e/3600),n=this.pint(60*(parseFloat(e/3600)-t));return t+"小时"+n+"分"+(this.pint(e)-3600*t-60*n)+"秒"},secondToDate:function(e){var t,n=parseFloat(e);return null!==n&&""!==n&&(n>60&&n<3600?n=this.pint(n/60)+"分"+this.pint(60*(parseFloat(n/60)-this.pint(n/60,10)))+"秒":n>=3600&&n<86400?n=this.secondToHour(n):n>=86400?(n-=3600*(t=this.pint(n/86400))*24,n=t+"天"+this.secondToHour(n)):n=this.pint(n)+"秒"),n},setWifi:function(e,t,n,i){var o=this,a=new FormData;a=a.append("file",r()(s)),e.bsd=t.wifi.bsd;var s={locale:"家",name:"Xiaomi_1A1A",encryption:"mixed-psk",txpwr:1,update:t.wifi.update,bw160:t.wifi.bw160,bsd:t.wifi.bsd};0==e.bsd?(s.ssid=t.wifi.ssid,s.name=t.wifi.name,s.password=t.wifi.password,s.ssid5g=t.wifi.ssid5g,s.password5g=t.wifi.password5g,"open"==e.common.getCookie("5g2Flag")&&(s.ssid5g2=t.wifi.ssid5g2,s.password5g2=t.wifi.password5g2)):(s.ssid=t.wifi.ssid,s.password=t.wifi.password,s.name=t.wifi.name),s.nonce=e.common.Encrypt.init(),s.oldPwd=e.common.Encrypt.oldPwd("admin"),s.newPwd=e.common.Encrypt.newPwd("admin",t.routerPwd),s.newPwd256=e.common.Encrypt.newPwd256("admin",t.routerPwd),s.routerPwd=t.routerPwd;var c={info:"auto_upgrade="+t.wifi.update};w()({method:"post",url:"/api/misystem/vas_switch",headers:{"Content-Type":"application/x-www-form-urlencoded"},timeout:5e4,data:this.makeFormData(c)}).then(function(e){e.status});var u="";"wired"==n?(u="/api/misystem/set_router_lanap_init",s.initialize=1):u="/api/misystem/set_router_normal",w()({method:"post",url:u,timeout:5e4,headers:{"Content-Type":"application/x-www-form-urlencoded"},data:this.makeFormData(s)}).then(function(a){if(0==a.data.code){e.common.setInitLog({type:0,step:i});var r={ssid2g_ssid:s.ssid,ssid2g_passwd:s.password,lan_ip:a.data.ip,cac_time:void 0!=a.data.cac_time?a.data.cac_time:69};console.log(r.cac_time,"cac_time"),0==e.bsd?(r.ssid5g_ssid=s.ssid5g,r.ssid5g_passwd=s.password5g,"open"==e.common.getCookie("5g2Flag")&&(r.ssid5g2_ssid=s.ssid5g2,r.ssid5g2_passwd=s.password5g2)):(r.ssid5g_ssid=s.ssid,r.ssid5g_passwd=s.password,"open"==e.common.getCookie("5g2Flag")&&(r.ssid5g2_ssid=s.ssid,r.ssid5g2_passwd=s.passworord)),r.bw160=s.bw160,r.bsd=e.bsd,e.adminPassword=t.routerPwd,"wired"==n?e.step=3:"guide"==n?e.type=5:e.step=4,e.GLOBAL.adminPassword=t.routerPwd,e.result=r}else"guide"==n?(o.type=3,o.$refs.tip.showTips(a.data.msg||"发生未知错误，请稍后再试~")):e.$router.push({path:"/error2",query:{from:n,currentWan:e.$route.query.currentWan}})})},makeFormData:function(e){var t=new FormData;return o()(e).forEach(function(n){t.append(n,e[n])}),t}}},C6j0:function(e,t){},JzCU:function(e,t,n){"use strict";var i=n("C6j0"),o=n.n(i),a=n("VU/8")(o.a,null,!1,null,null,null);t.default=a.exports},R1Gk:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var i=n("7+uW"),o={render:function(){var e=this.$createElement,t=this._self._c||e;return t("div",{attrs:{id:"app"}},[t("router-view")],1)},staticRenderFns:[]};var a=n("VU/8")({name:"App"},o,!1,function(e){n("47dl")},null,null).exports,r=n("/ocq");i.a.use(r.a);var s=new r.a({routes:[{path:"/",redirect:"/home"},{path:"/dhcp",name:"timeTable",component:function(e){return n.e(0).then(function(){var t=[n("r9pp")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/cannot_find_mode",name:"cannot_find_mode",component:function(e){return n.e(13).then(function(){var t=[n("DdHY")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/wired",name:"wired",component:function(e){return n.e(4).then(function(){var t=[n("qbeB")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/wireless",name:"wireless",component:function(e){return n.e(6).then(function(){var t=[n("TUNY")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/wifi_complete",name:"wifi_complete",component:function(e){return n.e(33).then(function(){var t=[n("u/6M")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/static",name:"staic",component:function(e){return n.e(5).then(function(){var t=[n("Nc/T")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/error1",name:"error1",component:function(e){return n.e(10).then(function(){var t=[n("vQ0D")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/home",name:"home",component:function(e){return n.e(20).then(function(){var t=[n("fHeX")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/error2",name:"error2",component:function(e){return n.e(23).then(function(){var t=[n("kDQt")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/guide",name:"guide",component:function(e){return n.e(1).then(function(){var t=[n("DbKA")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/operators",name:"operators",component:function(e){return n.e(24).then(function(){var t=[n("M1eb")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/get_from_old_router",name:"get_from_old_router",component:function(e){return n.e(16).then(function(){var t=[n("Q74/")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/download",name:"download",component:function(e){return n.e(29).then(function(){var t=[n("mQzm")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/agreement",name:"agreement",component:function(e){return n.e(31).then(function(){var t=[n("RZoP")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/privacy",name:"privacy",component:function(e){return n.e(25).then(function(){var t=[n("91sm")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/gjSet_wifi",name:"gjSet_wifi",component:function(e){return n.e(3).then(function(){var t=[n("lgsZ")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/work_model",name:"work_model",component:function(e){return n.e(14).then(function(){var t=[n("Emxf")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/pinCode",name:"pinCode",component:function(e){return n.e(9).then(function(){var t=[n("5G/C")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/pinCodeCheck",name:"pinCodeCheck",component:function(e){return n.e(12).then(function(){var t=[n("qh25")];e.apply(null,t)}.bind(this)).catch(n.oe)}},{path:"/setRouter",name:"set_router",component:function(e){return n.e(21).then(function(){var t=[n("lBuc")];e.apply(null,t)}.bind(this)).catch(n.oe)}}]}),c=n("gfkZ"),u=n("6zzU"),p=n("JzCU"),l=(n("j1ja"),n("bw1o")),f=n.n(l);var d={validators:{ipaddr:function(e,t,n){return/^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$/.test(e)},wifipassword:function(e,t,n){var i=/^[\u0000-\u007F]+$/.test(e),o=function(e){for(var t=0;t<e.length;t++){var n=e.charCodeAt(t);if(55296<=n&&n<=56319){if(e.length>1){var i=1024*(n-55296)+(e.charCodeAt(t+1)-56320)+65536;if(118784<=i&&i<=128895)return!0}}else if(e.length>1){if(8419==e.charCodeAt(t+1))return!0}else{if(8448<=n&&n<=10239)return!0;if(11013<=n&&n<=11015)return!0;if(10548<=n&&n<=10549)return!0;if(12951<=n&&n<=12953)return!0;if(169==n||174==n||12349==n||12336==n||11093==n||11036==n||11035==n||11088==n)return!0}}}(e);return i&&!o},checklength:function(e,t,n){for(var i=0,o=t,a=0;a<e.length;a++)if(e.charCodeAt(a)>125||94==e.charCodeAt(a)?i+=3:i++,i>o)return e=e.substr(0,a),!1;return!0},filterspecialchar:function(e,t,n){return/^.{1,}$/.test(e)},spaceword:function(e,t,n){return!!e&&0!=e.trim().length}}};i.a.use(f.a,d),i.a.use(c.a),i.a.prototype.GLOBAL=p.default,i.a.config.productionTip=!1,i.a.prototype.common=u.a,console.log(i.a.prototype.axios),i.a.directive("focus",{inserted:function(e){e.focus()}}),i.a.directive("filterSpecialChar",{update:function(e,t,n){t.value;var i=t.modifiers;try{if(!e.value)return!1;e.value=e.value.replace(/[`;|$&\\{}]/g,""),e.dispatchEvent(new Event(i.lazy?"change":"input"))}catch(e){}}}),i.a.prototype.footerSty=function(){var e="notmobile"!=u.a.detectDevice(),t=document.getElementsByClassName("footer");if(e)for(var n=0;n<t.length;n++)t[n].classList.add("footerMobile"),t[n].parentElement.setAttribute("id","formMobile");else{for(var i=0;i<t.length;i++)t[i].classList.remove("footerMobile"),t[i].parentElement.removeAttribute("id");if(document.body.clientHeight<800)for(var o=0;o<t.length;o++)t[o].style="bottom:auto !important"}},new i.a({el:"#app",router:s,components:{App:a},template:"<App/>"}),s.beforeEach(function(e,t,n){i.a.prototype._cancels_.forEach(function(e){e()}),i.a.prototype._cancels_=[],n()})},"W4G+":function(e,t,n){"use strict";var i=n("//Fk"),o=n.n(i),a=n("mtWM"),r=n.n(a),s=n("mw3O"),c=n.n(s),u=n("7+uW"),p=n("6zzU");console.log("production");var l=window.location.protocol+"//"+window.location.host+"/cgi-bin/luci";function f(e,t){var n=e.split("/")[3];return new o.a(function(i,o){"login"==n&&(r.a.defaults.baseURL=l),p.a.getCookie("token")&&"login"!=n&&(r.a.defaults.baseURL=window.location.protocol+"//"+window.location.host+"/cgi-bin/luci/;stok="+p.a.getCookie("token")),r.a.get(e,{params:t}).then(function(e){i(e)}).catch(function(e){o(e)})})}function d(e,t){var n=e.split("/")[3];return"login"==n&&(r.a.defaults.baseURL=l),p.a.getCookie("token")&&"login"!=n&&(r.a.defaults.baseURL=window.location.protocol+"//"+window.location.host+"/cgi-bin/luci/;stok="+p.a.getCookie("token")),new o.a(function(n,i){r.a.post(e,c.a.stringify(t)).then(function(e){n(e)}).catch(function(e){i(e)})})}r.a.defaults.baseURL=l,r.a.defaults.timeout=5e4;var m=r.a.CancelToken;u.a.prototype._cancels_=[],r.a.interceptors.request.use(function(e){return console.log("request"),e.cancelToken=new m(function(e){u.a.prototype._cancels_.push(e)}),e},function(e){return setTimeout(function(){console.log("requst error")},3e3),o.a.reject(e)});var h=0;r.a.interceptors.response.use(function(e){var t=e.data,n=window.location.href.split("#");return 401==t.code&&"Invalid token"==t.msg&&++h<=1&&confirm("登录状态失效，请您重新登录")&&(window.location.href=n[0]),e},function(e){return o.a.reject(e)}),n.d(t,"b",function(){return w});var w=function(e){return f("/api/misystem/set_log",e)};t.a={get:f,post:d,getRouterInfo:function(e){return f("/api/misystem/router_info",e)},getLoginInfo:function(e){return f("/api/xqsystem/login",e)},getLoginDesp:function(e){return d("/api/xqsystem/login",e)},setPrivacy:function(e){return f("/api/xqsystem/set_privacy_new",e)},getWanType:function(e){return f("/api/xqnetwork/check_wan_type",e)},getPppoeStatus:function(e){return f("/api/misystem/pppoe_status",e)},setRouterNormal:function(e){return d("/api/misystem/set_router_normal",e)},getPppoeCatch:function(e){return f("/api/xqnetwork/pppoe_catch",e)},postRouterLanap:function(e){return d("/api/misystem/set_router_lanap_init",e)},getWifiList:function(e){return f("/api/xqnetwork/wifi_list",e)},setLog:w,postWireless:function(e){return d("/api/misystem/set_router_wifiap_init",e)},postWirelessSet:function(e){return d("/api/xqnetwork/set_wifi_ap",e)},getWanLink:function(e){return f("/api/xqnetwork/wan_link",e)},setDHCP:function(e){return d("/api/misystem/set_router_normal",e)},setWanNew:function(e){return d("/api/xqnetwork/set_wan_new",e)},getConfigResult:function(e){return f("/api/misystem/get_config_result",e)},getIPconflict:function(e){return d("/api/misystem/check_ip_conflict",e)},upgrade:function(e){return f("/api/misystem/vas_switch",e)},getIsAP:function(e){return f("/api/xqnetwork/get_is_ap",e)},getRouterStatus:function(e){return f("/api/misystem/status",e)},getNetPppoeStatus:function(e){return f("/api/xqnetwork/pppoe_status",e)},getNettb:function(e){return function(e){if(e.url)return new o.a(function(t,n){window._jsonCallBack=function(e){clearTimeout(i.timer),t(e)};var i=document.createElement("script");i.type="text/javascript",i.src=""+e.url,document.getElementsByTagName("head")[0].appendChild(i),i.timer=setTimeout(function(){document.getElementsByTagName("head")[0].removeChild(i),clearTimeout(i.timer),window._jsonCallBack=null,e.fail&&e.fail()},1e3)});console.error("Axios.JSONP 至少需要一个url参数!")}(e)},netDiagnoseStart:function(e){return f("/api/misystem/net_diagnose_start",e)},netDiagnoseResult:function(e){return f("/api/misystem/net_diagnose_result",e)},newDhcp:function(e){return d("/api/xqnetwork/set_wan",e)},wifiDetailAll:function(e){return f("/api/xqnetwork/wifi_detail_all",e)},postWifi:function(e){return d("/api/xqnetwork/set_wifi",e)},postWifiTwo:function(e){return d("/api/xqnetwork/set_all_wifi",e)},postWifiTwoTest:function(e){return d("/api/xqnetwork/wifi_detail_all_two",e)},getConflictIp:function(e){return f("/api/misystem/messages",e)},postConflictReq:function(e){return d("/api/misystem/r_ip_conflict",e)},getWifiStatus:function(e){return d("/api/misystem/get_netwan_mode",e)},getNetmod:function(e){return f("/api/xqnetwork/get_netmode",e)},getActiveApcliIndex:function(e){return f("/api/xqnetwork/get_active_apcli_index",e)},getWanLanPort:function(e){return f("/api/xqnetwork/get_wan_lan_port",e)},setWanLanPort:function(e){return d("/api/xqnetwork/set_wan_lan_port",e)},getNewEncryptMode:function(e){return f("/api/xqsystem/init_info",e)},getFeature_info:function(e){return f("/api/misystem/feature_info",e)},CheckSIMStatus:function(e){return f("/api/xqmobile/check_sim_status",e)},CheckSIMPin:function(e){return f("/api/xqmobile/check_sim_pin",e)},SetSIMPin:function(e){return f("/api/xqmobile/set_sim_pin",e)},CheckSIMPuk:function(e){return f("/api/xqmobile/check_sim_puk",e)},GetMobNetInfo:function(e){return f("/api/xqmobile/get_mobile_net_info",e)}}},gfkZ:function(e,t,n){"use strict";var i=n("HSQo"),o=n.n(i),a=n("W4G+");t.a=function e(t){e.installed||(e.installed=!0,o()(t.prototype,{axios:{get:function(){return a.a}}}))}}},["R1Gk"]);