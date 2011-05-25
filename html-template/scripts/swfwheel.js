/**
 * SWFWheel - remove dependencies of mouse wheel on each browser.
 *
 * Copyright (c) 2008 - 2009 Spark project (www.libspark.org)
 *
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 */
(function ()
{
    // do nothing if already defined `SWFWheel`.
    if (window.SWFWheel) return;

	//var count = 0;
	
    var win = window,
        doc = document,
        nav = navigator;

    var SWFWheel = window.SWFWheel = function (id)
    {
        this.setUp(id);
        if (SWFWheel.browser.msie)
            this.bind4msie();
        else
            this.bind();
    };

    SWFWheel.prototype = {
        setUp: function (id)
        {
            var el = SWFWheel.retrieveObject(id);
            if (el.nodeName.toLowerCase() == 'embed' || SWFWheel.browser.safari)
                el = el.parentNode;
            this.target = el;
            this.eventType = SWFWheel.browser.mozilla ? 'DOMMouseScroll' : 'mousewheel';
        },

        bind: function ()
        {
            this.target.addEventListener(this.eventType, function (evt)
            {
                var target,
                    name,
                    delta = 0;
                // retrieve real node from XPCNativeWrapper.
                if (/XPCNativeWrapper/.test(evt.toString()))
                {
                    // FIXME: embed element has no id attributes on `AC_RunContent`.
                    var k = evt.target.getAttribute('id') || evt.target.getAttribute('name');
                    if (!k) return;
                    target = SWFWheel.retrieveObject(k);
                }
                else
                {
                    target = evt.target;
                }
                name = target.nodeName.toLowerCase();
                // check target node.
                if (name != 'object' && name != 'embed') return;
                // kill process.
                if (!target.checkBrowserScroll())
                {
                    evt.preventDefault();
                    evt.returnValue = false;
                }
                // execute wheel event if exists.
                if (!target.triggerMouseEvent) return;
                // fix delta value.
                switch (true)
                {
                    case SWFWheel.browser.mozilla:
                        delta = -evt.detail;
                        break;

                    case SWFWheel.browser.opera:
                        delta = evt.wheelDelta / 40;
                        break;

                    default:
                        //  safari, stainless, opera and chrome.
                        delta = evt.wheelDelta / 80;
                        break;
                }
				//output((count ++) + ": delta: " + delta);
                target.triggerMouseEvent(delta);
            }, false);
        },

        bind4msie: function ()
        {
            var _wheel,
                _unload,
                target = this.target;

            _wheel = function ()
            {
                var evt = win.event,
                    delta = 0,
                    name = evt.srcElement.nodeName.toLowerCase();

                if (name != 'object' && name != 'embed') return;
                if (!target.checkBrowserScroll())
                    evt.returnValue = false;
                //  will trigger when wmode is `opaque` or `transparent`.
                if (!target.triggerMouseEvent) return;
                delta = evt.wheelDelta / 40;
                target.triggerMouseEvent(delta);
            };
            _unload = function ()
            {
                target.detachEvent('onmousewheel', _wheel);
                win.detachEvent('onunload', _unload);
            };
            target.attachEvent('onmousewheel', _wheel);
            win.attachEvent('onunload', _unload);
        }
    };

    //  utilities. ------------------------------------------------------------
    SWFWheel.browser = (function (ua)
    {
        return {
        	version: (ua.match(/.+(?:rv|it|ra|ie)[\/:\\s]([\\d.]+)/)||[0,'0'])[1],
            chrome: /chrome/.test(ua),
            stainless: /stainless/.test(ua),
            safari: /webkit/.test(ua) && !/(chrome|stainless)/.test(ua),
            opera: /opera/.test(ua),
            msie: /msie/.test(ua) && !/opera/.test(ua),
            mozilla: /mozilla/.test(ua) && !/(compatible|webkit)/.test(ua)
        }
    })(nav.userAgent.toLowerCase());

    SWFWheel.join = function (id)
    {
        var t = setInterval(function ()
        {
            if (SWFWheel.retrieveObject(id))
            {
                clearInterval(t);
                new SWFWheel(id);
            }
        }, 0);
    };

    SWFWheel.force = function (id)
    {
        if (SWFWheel.browser.safari||SWFWheel.browser.stainless) return true;

        var el = SWFWheel.retrieveObject(id),
            name = el.nodeName.toLowerCase();

        if (name == 'object')
        {
            var k, v,
                param,
                params = el.getElementsByTagName('param'),
                len = params.length;

            for (var i=0; i<len; i++)
            {
                param = params[i];
                //  FIXME: getElementsByTagName is broken on IE?
                if (param.parentNode != el) continue;

                k = param.getAttribute('name');
                v = param.getAttribute('value') || '';
                if (/wmode/i.test(k) && /(opaque|transparent)/i.test(v)) return true;
            }
        }
        else if (name == 'embed')
        {
            return /(opaque|transparent)/i.test(el.getAttribute('wmode'));
        }
        return false;
    };

    SWFWheel.retrieveObject = function (id)
    {
        var el = doc.getElementById(id);
        //  FIXME: fallback for `AC_FL_RunContent`.
        if (!el)
        {
            var nodes = doc.getElementsByTagName('embed'),
                len = nodes.length;

            for (var i=0; i<len; i++)
            {
                if (nodes[i].getAttribute('name') == id)
                {
                    el = nodes[i];
                    break;
                }
            }
        }
        return el;
    };

})();
