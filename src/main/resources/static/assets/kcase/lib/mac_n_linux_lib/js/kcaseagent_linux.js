var K_OSName = "Linux";

if (typeof JSON !== 'object') {
    JSON = {};
}

(function () {
    'use strict';

    var rx_one = /^[\],:{}\s]*$/,
        rx_two = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,
        rx_three = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
        rx_four = /(?:^|:|,)(?:\s*\[)+/g,
        rx_escapable = /[\\\"\u0000-\u001f\u007f-\u009f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        rx_dangerous = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;

    function f(n) {
        // Format integers to have at least two digits.
        return n < 10
            ? '0' + n
            : n;
    }

    function this_value() {
        return this.valueOf();
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function () {

            return isFinite(this.valueOf())
                ? this.getUTCFullYear() + '-' +
            f(this.getUTCMonth() + 1) + '-' +
            f(this.getUTCDate()) + 'T' +
            f(this.getUTCHours()) + ':' +
            f(this.getUTCMinutes()) + ':' +
            f(this.getUTCSeconds()) + 'Z'
                : null;
        };

        Boolean.prototype.toJSON = this_value;
        Number.prototype.toJSON = this_value;
        String.prototype.toJSON = this_value;
    }

    var gap,
        indent,
        meta,
        rep;


    function quote(string) {

// If the string contains no control characters, no quote characters, and no
// backslash characters, then we can safely slap some quotes around it.
// Otherwise we must also replace the offending characters with safe escape
// sequences.

        rx_escapable.lastIndex = 0;
        return rx_escapable.test(string)
            ? '"' + string.replace(rx_escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"'
            : '"' + string + '"';
    }


    function str(key, holder) {

// Produce a string from holder[key].

        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

// If the value has a toJSON method, call it to obtain a replacement value.

        if (value && typeof value === 'object' &&
            typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

// If we were called with a replacer function, then call the replacer to
// obtain a replacement value.

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

// What happens next depends on the value's type.

        switch (typeof value) {
            case 'string':
                return quote(value);

            case 'number':

// JSON numbers must be finite. Encode non-finite numbers as null.

                return isFinite(value)
                    ? String(value)
                    : 'null';

            case 'boolean':
            case 'null':

// If the value is a boolean or null, convert it to a string. Note:
// typeof null does not produce 'null'. The case is included here in
// the remote chance that this gets fixed someday.

                return String(value);

// If the type is 'object', we might be dealing with an object or an array or
// null.

            case 'object':

// Due to a specification blunder in ECMAScript, typeof null is 'object',
// so watch out for that case.

                if (!value) {
                    return 'null';
                }

// Make an array to hold the partial results of stringifying this object value.

                gap += indent;
                partial = [];

// Is the value an array?

                if (Object.prototype.toString.apply(value) === '[object Array]') {

// The value is an array. Stringify every element. Use null as a placeholder
// for non-JSON values.

                    length = value.length;
                    for (i = 0; i < length; i += 1) {
                        partial[i] = str(i, value) || 'null';
                    }

// Join all of the elements together, separated with commas, and wrap them in
// brackets.

                    v = partial.length === 0
                        ? '[]'
                        : gap
                        ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                        : '[' + partial.join(',') + ']';
                    gap = mind;
                    return v;
                }

// If the replacer is an array, use it to select the members to be stringified.

                if (rep && typeof rep === 'object') {
                    length = rep.length;
                    for (i = 0; i < length; i += 1) {
                        if (typeof rep[i] === 'string') {
                            k = rep[i];
                            v = str(k, value);
                            if (v) {
                                partial.push(quote(k) + (
                                        gap
                                            ? ': '
                                            : ':'
                                    ) + v);
                            }
                        }
                    }
                } else {

// Otherwise, iterate through all of the keys in the object.

                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = str(k, value);
                            if (v) {
                                partial.push(quote(k) + (
                                        gap
                                            ? ': '
                                            : ':'
                                    ) + v);
                            }
                        }
                    }
                }

// Join all of the member texts together, separated with commas,
// and wrap them in braces.

                v = partial.length === 0
                    ? '{}'
                    : gap
                    ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                    : '{' + partial.join(',') + '}';
                gap = mind;
                return v;
        }
    }

// If the JSON object does not yet have a stringify method, give it one.

    if (typeof JSON.stringify !== 'function') {
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"': '\\"',
            '\\': '\\\\'
        };
        JSON.stringify = function (value, replacer, space) {

// The stringify method takes a value and an optional replacer, and an optional
// space parameter, and returns a JSON text. The replacer can be a function
// that can replace values, or an array of strings that will select the keys.
// A default replacer method can be provided. Use of the space parameter can
// produce text that is more easily readable.

            var i;
            gap = '';
            indent = '';

// If the space parameter is a number, make an indent string containing that
// many spaces.

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

// If the space parameter is a string, it will be used as the indent string.

            } else if (typeof space === 'string') {
                indent = space;
            }

// If there is a replacer, it must be a function or an array.
// Otherwise, throw an error.

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                (typeof replacer !== 'object' ||
                typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

// Make a fake root object containing our value under the key of ''.
// Return the result of stringifying the value.

            return str('', {'': value});
        };
    }


// If the JSON object does not yet have a parse method, give it one.

    if (typeof JSON.parse !== 'function') {
        JSON.parse = function (text, reviver) {

// The parse method takes a text and an optional reviver function, and returns
// a JavaScript value if the text is a valid JSON text.

            var j;

            function walk(holder, key) {

// The walk method is used to recursively walk the resulting structure so
// that modifications can be made.

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }


// Parsing happens in four stages. In the first stage, we replace certain
// Unicode characters with escape sequences. JavaScript handles many characters
// incorrectly, either silently deleting them, or treating them as line endings.

            text = String(text);
            rx_dangerous.lastIndex = 0;
            if (rx_dangerous.test(text)) {
                text = text.replace(rx_dangerous, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

// In the second stage, we run the text against regular expressions that look
// for non-JSON patterns. We are especially concerned with '()' and 'new'
// because they can cause invocation, and '=' because it can cause mutation.
// But just to be safe, we want to reject all unexpected forms.

// We split the second stage into 4 regexp operations in order to work around
// crippling inefficiencies in IE's and Safari's regexp engines. First we
// replace the JSON backslash pairs with '@' (a non-JSON character). Second, we
// replace all simple value tokens with ']' characters. Third, we delete all
// open brackets that follow a colon or comma or that begin the text. Finally,
// we look to see that the remaining characters are only whitespace or ']' or
// ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

            if (
                rx_one.test(
                    text
                        .replace(rx_two, '@')
                        .replace(rx_three, ']')
                        .replace(rx_four, '')
                )
            ) {

// In the third stage we use the eval function to compile the text into a
// JavaScript structure. The '{' operator is subject to a syntactic ambiguity
// in JavaScript: it can begin a block or an object literal. We wrap the text
// in parens to eliminate the ambiguity.

                j = eval('(' + text + ')');

// In the optional fourth stage, we recursively walk the new structure, passing
// each name/value pair to a reviver function for possible transformation.

                return typeof reviver === 'function'
                    ? walk({'': j}, '')
                    : j;
            }

// If the text is not JSON parseable, then a SyntaxError is thrown.

            throw new SyntaxError('JSON.parse');
        };
    }
}());

(function ($, window, document, undefined) {
    // Create the defaults once
    var pluginName = "isLoading",
        defaults = {
            'position': "right",        // right | inside | overlay
            'text': "",                 // Text to display next to the loader
            'class': "icon-refresh",    // loader CSS class
            'tpl': '<span class="isloading-wrapper %wrapper%">%text%<span class="loading"><span></span><span></span><span></span><span></span><span></span></span></span>',    // loader base Tag
            'disableSource': true,      // true | false
            'disableOthers': []
        };

    // The actual plugin constructor
    function Plugin(element, options) {
        this.element = element;

        // Merge user options with default ones
        this.options = $.extend({}, defaults, options);

        this._defaults = defaults;
        this._name = pluginName;
        this._loader = null;                // Contain the loading tag element
        this.init();
    }

    // Contructor function for the plugin (only once on page load)
    function contruct() {
        if (!$[pluginName]) {
            $.isLoading = function (opts) {
                $("body").isLoading(opts);
            };
        }
    }

    Plugin.prototype = {
        init: function () {

            if ($(this.element).is("body")) {
                this.options.position = "overlay";
            }
            this.show();
        },

        show: function () {

            var self = this,
                tpl = self.options.tpl.replace('%wrapper%', ' isloading-show ' + ' isloading-' + self.options.position);
            tpl = tpl.replace('%class%', self.options['class']);
            tpl = tpl.replace('%text%', (self.options.text !== "") ? self.options.text + ' ' : '');
            self._loader = $(tpl);

            // Disable the element
            if ($(self.element).is("input, textarea") && true === self.options.disableSource) {
                $(self.element).attr("disabled", "disabled");
            }
            else if (true === self.options.disableSource) {
                $(self.element).addClass("disabled");
            }

            // Set position
            switch (self.options.position) {
                case "inside":
                    $(self.element).html(self._loader);
                    break;
                case "overlay":
                    var $wrapperTpl = null;

                    if ($(self.element).is("body")) {
                        $wrapperTpl = $('<div class="isloading-overlay" style="position:fixed; left:0; top:0; z-index: 10000; width: 100%; height: ' + $(window).height() + 'px;" />');
                        $("body").prepend($wrapperTpl);

                        $(window).on('resize', function () {
                            $wrapperTpl.height($(window).height() + 'px');
                            self._loader.css({top: ($(window).height() / 2 - self._loader.outerHeight() / 2) + 'px'});
                        });
                    } else {
                        var cssPosition = $(self.element).css('position'),
                            pos = {},
                            height = $(self.element).outerHeight() + 'px',
                            width = '100%'; // $( self.element ).outerWidth() + 'px;

                        if ('relative' === cssPosition || 'absolute' === cssPosition) {
                            pos = {'top': 0, 'left': 0};
                        } else {
                            pos = $(self.element).position();
                        }
                        $wrapperTpl = $('<div class="isloading-overlay" style="position:absolute; top: ' + pos.top + 'px; left: ' + pos.left + 'px; z-index: 10000; width: ' + width + '; height: ' + height + ';" />');
                        $(self.element).prepend($wrapperTpl);

                        $(window).on('resize', function () {
                            $wrapperTpl.height($(self.element).outerHeight() + 'px');
                            self._loader.css({top: ($wrapperTpl.outerHeight() / 2 - self._loader.outerHeight() / 2) + 'px'});
                        });
                    }
                    $wrapperTpl.html(self._loader);
                    self._loader.css({top: ($wrapperTpl.outerHeight() / 2 - self._loader.outerHeight() / 2) + 'px'});
                    break;
                default:
                    $(self.element).after(self._loader);
                    break;
            }

            self.disableOthers();
        },

        hide: function () {

            if ("overlay" === this.options.position) {

                $(this.element).find(".isloading-overlay").first().remove();

            } else {

                $(this._loader).remove();
                $(this.element).text($(this.element).attr("data-isloading-label"));

            }

            $(this.element).removeAttr("disabled").removeClass("disabled");

            this.enableOthers();
        },

        disableOthers: function () {
            $.each(this.options.disableOthers, function (i, e) {
                var elt = $(e);
                if (elt.is("button, input, textarea")) {
                    elt.attr("disabled", "disabled");
                }
                else {
                    elt.addClass("disabled");
                }
            });
        },

        enableOthers: function () {
            $.each(this.options.disableOthers, function (i, e) {
                var elt = $(e);
                if (elt.is("button, input, textarea")) {
                    elt.removeAttr("disabled");
                }
                else {
                    elt.removeClass("disabled");
                }
            });
        }
    };

    // Constructor
    $.fn[pluginName] = function (options) {
        return this.each(function () {
            if (options && "hide" !== options || !$.data(this, "plugin_" + pluginName)) {
                $.data(this, "plugin_" + pluginName, new Plugin(this, options));
            } else {
                var elt = $.data(this, "plugin_" + pluginName);

                if ("hide" === options) {
                    elt.hide();
                }
                else {
                    elt.show();
                }
            }
        });
    };

    contruct();

})(jQuery, window, document);

/*!
 * jQuery UI Dialog 1.11.4
 * http://jqueryui.com
 *
 * Copyright jQuery Foundation and other contributors
 * Released under the MIT license.
 * http://jquery.org/license
 *
 * http://api.jqueryui.com/dialog/
 */


$.widget( "ui.kcDialog", {
    version: "1.11.4",
    options: {
        mainTitle: true,
        appendTo: "body",
        autoOpen: true,
        buttons: [],
        closeOnEscape: true,
        closeText: "Close",
        dialogClass: "",
        draggable: true,
        hide: null,
        height: "auto",
        maxHeight: null,
        maxWidth: null,
        minHeight: 150,
        minWidth: 150,
        modal: true,
        position: {
            my: "center",
            at: "center",
            of: window,
            collision: "fit",
            // Ensure the titlebar is always visible
            using: function( pos ) {
                var topOffset = $( this ).css( pos ).offset().top;
                if ( topOffset < 0 ) {
                    $( this ).css( "top", pos.top - topOffset );
                }
            }
        },
        resizable: true,
        show: null,
        title: null,
        width: 300,

        // callbacks
        beforeClose: null,
        close: null,
        drag: null,
        dragStart: null,
        dragStop: null,
        focus: null,
        open: null,
        resize: null,
        resizeStart: null,
        resizeStop: null
    },

    sizeRelatedOptions: {
        buttons: true,
        height: true,
        maxHeight: true,
        maxWidth: true,
        minHeight: true,
        minWidth: true,
        width: true
    },

    resizableRelatedOptions: {
        maxHeight: true,
        maxWidth: true,
        minHeight: true,
        minWidth: true
    },

    _create: function() {
        this.originalCss = {
            display: this.element[ 0 ].style.display,
            width: this.element[ 0 ].style.width,
            minHeight: this.element[ 0 ].style.minHeight,
            maxHeight: this.element[ 0 ].style.maxHeight,
            height: this.element[ 0 ].style.height
        };
        this.originalPosition = {
            parent: this.element.parent(),
            index: this.element.parent().children().index( this.element )
        };
        this.originalTitle = this.element.attr( "title" );
        this.options.title = this.options.title || this.originalTitle;

        this._createWrapper();

        this.element
            .show()
            .removeAttr( "title" )
            .addClass( "kc-dialog-content kc-widget-content" )
            .appendTo( this.uiDialog );

        this._createTitlebar();
        this._createButtonPane();

        if ( this.options.draggable && $.fn.draggable ) {
            this._makeDraggable();
        }
        if ( this.options.resizable && $.fn.resizable ) {
            this._makeResizable();
        }

        this._isOpen = false;

        this._trackFocus();
    },

    _init: function() {
        if ( this.options.autoOpen ) {
            this.open();
        }
    },

    _appendTo: function() {
        var element = this.options.appendTo;
        if ( element && (element.jquery || element.nodeType) ) {
            return $( element );
        }
        return this.document.find( element || "body" ).eq( 0 );
    },

    _destroy: function() {
        var next,
            originalPosition = this.originalPosition;

        this._untrackInstance();
        this._destroyOverlay();

        this.element
            .removeUniqueId()
            .removeClass( "kc-dialog-content kc-widget-content" )
            .css( this.originalCss )
            // Without detaching first, the following becomes really slow
            .detach();

        this.uiDialog.stop( true, true ).remove();

        if ( this.originalTitle ) {
            this.element.attr( "title", this.originalTitle );
        }

        next = originalPosition.parent.children().eq( originalPosition.index );
        // Don't try to place the dialog next to itself (#8613)
        if ( next.length && next[ 0 ] !== this.element[ 0 ] ) {
            next.before( this.element );
        } else {
            originalPosition.parent.append( this.element );
        }
    },

    widget: function() {
        return this.uiDialog;
    },

    disable: $.noop,
    enable: $.noop,

    close: function( event ) {
        var activeElement,
            that = this;

        if ( !this._isOpen || this._trigger( "beforeClose", event ) === false ) {
            return;
        }

        this._isOpen = false;
        this._focusedElement = null;
        this._destroyOverlay();
        this._untrackInstance();

        if ( !this.opener.filter( ":focusable" ).focus().length ) {

            // support: IE9
            // IE9 throws an "Unspecified error" accessing document.activeElement from an <iframe>
            try {
                activeElement = this.document[ 0 ].activeElement;

                // Support: IE9, IE10
                // If the <body> is blurred, IE will switch windows, see #4520
                if ( activeElement && activeElement.nodeName.toLowerCase() !== "body" ) {

                    // Hiding a focused element doesn't trigger blur in WebKit
                    // so in case we have nothing to focus on, explicitly blur the active element
                    // https://bugs.webkit.org/show_bug.cgi?id=47182
                    $( activeElement ).blur();
                }
            } catch ( error ) {}
        }

        this._hide( this.uiDialog, this.options.hide, function() {
            that._trigger( "close", event );
        });
    },

    isOpen: function() {
        return this._isOpen;
    },

    moveToTop: function() {
        this._moveToTop();
    },

    _moveToTop: function( event, silent ) {
        var moved = false,
            zIndices = this.uiDialog.siblings( ".kc-front:visible" ).map(function() {
                return +$( this ).css( "z-index" );
            }).get(),
            zIndexMax = Math.max.apply( null, zIndices );

        if ( zIndexMax >= +this.uiDialog.css( "z-index" ) ) {
            this.uiDialog.css( "z-index", zIndexMax + 1 );
            moved = true;
        }

        if ( moved && !silent ) {
            this._trigger( "focus", event );
        }
        return moved;
    },

    open: function() {
        var that = this;
        if ( this._isOpen ) {
            if ( this._moveToTop() ) {
                this._focusTabbable();
            }
            return;
        }

        this._isOpen = true;
        this.opener = $( this.document[ 0 ].activeElement );

        this._size();
        this._position();
        this._createOverlay();
        this._moveToTop( null, true );

        // Ensure the overlay is moved to the top with the dialog, but only when
        // opening. The overlay shouldn't move after the dialog is open so that
        // modeless dialogs opened after the modal dialog stack properly.
        if ( this.overlay ) {
            this.overlay.css( "z-index", this.uiDialog.css( "z-index" ) - 1 );
        }

        this._show( this.uiDialog, this.options.show, function() {
            that._focusTabbable();
            that._trigger( "focus" );
        });

        // Track the dialog immediately upon openening in case a focus event
        // somehow occurs outside of the dialog before an element inside the
        // dialog is focused (#10152)
        this._makeFocusTarget();

        this._trigger( "open" );
    },

    _focusTabbable: function() {
        // Set focus to the first match:
        // 1. An element that was focused previously
        // 2. First element inside the dialog matching [autofocus]
        // 3. Tabbable element inside the content element
        // 4. Tabbable element inside the buttonpane
        // 5. The close button
        // 6. The dialog itself
        var hasFocus = this._focusedElement;
        if ( !hasFocus ) {
            hasFocus = this.element.find( "[autofocus]" );
        }
        if ( !hasFocus.length ) {
            hasFocus = this.element.find( ":tabbable" );
        }
        if ( !hasFocus.length ) {
            hasFocus = this.uiDialogButtonPane.find( ":tabbable" );
        }
        if ( !hasFocus.length ) {
            hasFocus = this.uiDialogTitlebarClose.filter( ":tabbable" );
        }
        if ( !hasFocus.length ) {
            hasFocus = this.uiDialog;
        }
        hasFocus.eq( 0 ).focus();
    },

    _keepFocus: function( event ) {
        function checkFocus() {
            var activeElement = this.document[0].activeElement,
                isActive = this.uiDialog[0] === activeElement ||
                    $.contains( this.uiDialog[0], activeElement );
            if ( !isActive ) {
                this._focusTabbable();
            }
        }
        event.preventDefault();
        checkFocus.call( this );
        // support: IE
        // IE <= 8 doesn't prevent moving focus even with event.preventDefault()
        // so we check again later
        this._delay( checkFocus );
    },

    _createWrapper: function() {
        this.uiDialog = $("<div>")
            .addClass( "kc-dialog kc-widget kc-widget-content kc-corner-all kc-front " +
                this.options.dialogClass )
            .hide()
            .attr({
                // Setting tabIndex makes the div focusable
                tabIndex: -1,
                role: "dialog"
            })
            .appendTo( this._appendTo() );

        this._on( this.uiDialog, {
            keydown: function( event ) {
                if ( this.options.closeOnEscape && !event.isDefaultPrevented() && event.keyCode &&
                    event.keyCode === $.ui.keyCode.ESCAPE ) {
                    event.preventDefault();
                    this.close( event );
										if(prop.isSubView){
	                		prop.CANCEL_SUB_DIALOG();
	                	}
	                	else{
	                		prop.CANCEL_DIALOG();
	              		}
	              		prop.isSubView = false;
                    return;
                }

                // prevent tabbing out of dialogs
                if ( event.keyCode !== $.ui.keyCode.TAB || event.isDefaultPrevented() ) {
                    return;
                }
                var tabbables = this.uiDialog.find( ":tabbable" ),
                    first = tabbables.filter( ":first" ),
                    last = tabbables.filter( ":last" );

                if ( ( event.target === last[0] || event.target === this.uiDialog[0] ) && !event.shiftKey ) {
                    this._delay(function() {
                        first.focus();
                    });
                    event.preventDefault();
                } else if ( ( event.target === first[0] || event.target === this.uiDialog[0] ) && event.shiftKey ) {
                    this._delay(function() {
                        last.focus();
                    });
                    event.preventDefault();
                }
            },
            mousedown: function( event ) {
                if ( this._moveToTop( event ) ) {
                    this._focusTabbable();
                }
            }
        });

        // We assume that any existing aria-describedby attribute means
        // that the dialog content is marked up properly
        // otherwise we brute force the content as the description
        if ( !this.element.find( "[aria-describedby]" ).length ) {
            this.uiDialog.attr({
                "aria-describedby": this.element.uniqueId().attr( "id" )
            });
        }
    },

    _createTitlebar: function() {
        var uiDialogTitle;

        var titleName;

        if(this.options.mainTitle) {
            titleName = "kc-dialog-title2";
        } else {
            titleName = "kc-dialog-title";
        }

        this.uiDialogTitlebar = $( "<div><h3>" + this.options.title + "</h3></div>" )
            .addClass( "kc-dialog-titlebar " + titleName)
            .prependTo( this.uiDialog );

        //this.uiDialogTitlebar.css("background", "url('http://10.20.130.98:8081/kcase/lib/img/banner.png')");

        this._on( this.uiDialogTitlebar, {
            mousedown: function( event ) {
                // Don't prevent click on close button (#8838)
                // Focusing a dialog that is partially scrolled out of view
                // causes the browser to scroll it into view, preventing the click event
                if ( !$( event.target ).closest( ".kc-dialog-close" ) ) {
                    // Dialog isn't getting focus when dragging (#8063)
                    this.uiDialog.focus();
                }
            }
        });

        // support: IE
        // Use type="button" to prevent enter keypresses in textboxes from closing the
        // dialog in IE (#9312)
        this.uiDialogTitlebarClose = $( "<a>" )
            .addClass( "kc-dialog-close" )
            .appendTo( this.uiDialogTitlebar );
        this._on( this.uiDialogTitlebarClose, {
            click: function( event ) {
                event.preventDefault();
                this.close( event );
                if(prop.isSubView){
                	prop.CANCEL_SUB_DIALOG();
                }
                else{
                	prop.CANCEL_DIALOG();
              	}
              	prop.isSubView = false;
            }
        });

        uiDialogTitle = $( "<span>" )
            .uniqueId()
            //.addClass( "kc-dialog-title" )
            .prependTo( this.uiDialogTitlebar );
        this._title( uiDialogTitle );

        this.uiDialog.attr({
            "aria-labelledby": uiDialogTitle.attr( "id" )
        });
    },

    _title: function( title ) {
        if ( !this.options.title ) {
            title.html( "&#160;" );
        }
        //title.text( this.options.title );
    },

    _createButtonPane: function() {
        this.uiDialogButtonPane = $( "<div>" )
            .addClass( "kc-dialog-buttonpane kc-widget-content kc-helper-clearfix" );

        this.uiButtonSet = $( "<div>" )
            .addClass( "kc-dialog-buttonset" )
            .appendTo( this.uiDialogButtonPane );

        this._createButtons();
    },

    _createButtons: function() {
        var that = this,
            buttons = this.options.buttons;

        // if we already have a button pane, remove it
        this.uiDialogButtonPane.remove();
        this.uiButtonSet.empty();

        if ( $.isEmptyObject( buttons ) || ($.isArray( buttons ) && !buttons.length) ) {
            this.uiDialog.removeClass( "kc-dialog-buttons" );
            return;
        }

        $.each( buttons, function( name, props ) {
            var click, buttonOptions;
            props = $.isFunction( props ) ?
            { click: props, text: name } :
                props;
            // Default to a non-submitting button
            props = $.extend( { type: "button" }, props );
            // Change the context for the click callback to be the main element
            click = props.click;
            props.click = function() {
                click.apply( that.element[ 0 ], arguments );
            };
            buttonOptions = {
                icons: props.icons,
                text: props.showText
            };
            delete props.icons;
            delete props.showText;
            $( "<button></button>", props )
                .button( buttonOptions )
                .appendTo( that.uiButtonSet );
        });
        this.uiDialog.addClass( "kc-dialog-buttons" );
        this.uiDialogButtonPane.appendTo( this.uiDialog );
    },

    _makeDraggable: function() {
        var that = this,
            options = this.options;

        function filteredUi( ui ) {
            return {
                position: ui.position,
                offset: ui.offset
            };
        }

        this.uiDialog.draggable({
            cancel: ".kc-dialog-content, .kc-dialog-titlebar-close",
            handle: ".kc-dialog-titlebar",
            //handle: ".kc-dialog-title2",
            containment: "document",
            start: function( event, ui ) {
                $( this ).addClass( "kc-dialog-dragging" );
                that._blockFrames();
                that._trigger( "dragStart", event, filteredUi( ui ) );
            },
            drag: function( event, ui ) {
                that._trigger( "drag", event, filteredUi( ui ) );
            },
            stop: function( event, ui ) {
                var left = ui.offset.left - that.document.scrollLeft(),
                    top = ui.offset.top - that.document.scrollTop();

                options.position = {
                    my: "left top",
                    at: "left" + (left >= 0 ? "+" : "") + left + " " +
                    "top" + (top >= 0 ? "+" : "") + top,
                    of: that.window
                };
                $( this ).removeClass( "kc-dialog-dragging" );
                that._unblockFrames();
                that._trigger( "dragStop", event, filteredUi( ui ) );
            }
        });
    },

    _makeResizable: function() {
        var that = this,
            options = this.options,
            handles = options.resizable,
        // .ui-resizable has position: relative defined in the stylesheet
        // but dialogs have to use absolute or fixed positioning
            position = this.uiDialog.css("position"),
            resizeHandles = typeof handles === "string" ?
                handles	:
                "n,e,s,w,se,sw,ne,nw";

        function filteredUi( ui ) {
            return {
                originalPosition: ui.originalPosition,
                originalSize: ui.originalSize,
                position: ui.position,
                size: ui.size
            };
        }

        this.uiDialog.resizable({
                cancel: ".kc-dialog-content",
                containment: "document",
                alsoResize: this.element,
                maxWidth: options.maxWidth,
                maxHeight: options.maxHeight,
                minWidth: options.minWidth,
                minHeight: this._minHeight(),
                handles: resizeHandles,
                start: function( event, ui ) {
                    $( this ).addClass( "kc-dialog-resizing" );
                    that._blockFrames();
                    that._trigger( "resizeStart", event, filteredUi( ui ) );
                },
                resize: function( event, ui ) {
                    that._trigger( "resize", event, filteredUi( ui ) );
                },
                stop: function( event, ui ) {
                    var offset = that.uiDialog.offset(),
                        left = offset.left - that.document.scrollLeft(),
                        top = offset.top - that.document.scrollTop();

                    options.height = that.uiDialog.height();
                    options.width = that.uiDialog.width();
                    options.position = {
                        my: "left top",
                        at: "left" + (left >= 0 ? "+" : "") + left + " " +
                        "top" + (top >= 0 ? "+" : "") + top,
                        of: that.window
                    };
                    $( this ).removeClass( "kc-dialog-resizing" );
                    that._unblockFrames();
                    that._trigger( "resizeStop", event, filteredUi( ui ) );
                }
            })
            .css( "position", position );
    },

    _trackFocus: function() {
        this._on( this.widget(), {
            focusin: function( event ) {
                this._makeFocusTarget();
                this._focusedElement = $( event.target );
            }
        });
    },

    _makeFocusTarget: function() {
        this._untrackInstance();
        this._trackingInstances().unshift( this );
    },

    _untrackInstance: function() {
        var instances = this._trackingInstances(),
            exists = $.inArray( this, instances );
        if ( exists !== -1 ) {
            instances.splice( exists, 1 );
        }
    },

    _trackingInstances: function() {
        var instances = this.document.data( "kc-dialog-instances" );
        if ( !instances ) {
            instances = [];
            this.document.data( "kc-dialog-instances", instances );
        }
        return instances;
    },

    _minHeight: function() {
        var options = this.options;

        return options.height === "auto" ?
            options.minHeight :
            Math.min( options.minHeight, options.height );
    },

    _position: function() {
        // Need to show the dialog to get the actual offset in the position plugin
        var isVisible = this.uiDialog.is( ":visible" );
        if ( !isVisible ) {
            this.uiDialog.show();
        }
        this.uiDialog.position( this.options.position );
        if ( !isVisible ) {
            this.uiDialog.hide();
        }
    },

    _setOptions: function( options ) {
        var that = this,
            resize = false,
            resizableOptions = {};

        $.each( options, function( key, value ) {
            that._setOption( key, value );

            if ( key in that.sizeRelatedOptions ) {
                resize = true;
            }
            if ( key in that.resizableRelatedOptions ) {
                resizableOptions[ key ] = value;
            }
        });

        if ( resize ) {
            this._size();
            this._position();
        }
        if ( this.uiDialog.is( ":data(ui-resizable)" ) ) {
            this.uiDialog.resizable( "option", resizableOptions );
        }
    },

    _setOption: function( key, value ) {
        var isDraggable, isResizable,
            uiDialog = this.uiDialog;

        if ( key === "dialogClass" ) {
            uiDialog
                .removeClass( this.options.dialogClass )
                .addClass( value );
        }

        if ( key === "disabled" ) {
            return;
        }

        this._super( key, value );

        if ( key === "appendTo" ) {
            this.uiDialog.appendTo( this._appendTo() );
        }

        if ( key === "buttons" ) {
            this._createButtons();
        }

        if ( key === "closeText" ) {
            this.uiDialogTitlebarClose.button({
                // Ensure that we always pass a string
                label: "" + value
            });
        }

        if ( key === "draggable" ) {
            isDraggable = uiDialog.is( ":data(ui-draggable)" );
            if ( isDraggable && !value ) {
                uiDialog.draggable( "destroy" );
            }

            if ( !isDraggable && value ) {
                this._makeDraggable();
            }
        }

        if ( key === "position" ) {
            this._position();
        }

        if ( key === "resizable" ) {
            // currently resizable, becoming non-resizable
            isResizable = uiDialog.is( ":data(ui-resizable)" );
            if ( isResizable && !value ) {
                uiDialog.resizable( "destroy" );
            }

            // currently resizable, changing handles
            if ( isResizable && typeof value === "string" ) {
                uiDialog.resizable( "option", "handles", value );
            }

            // currently non-resizable, becoming resizable
            if ( !isResizable && value !== false ) {
                this._makeResizable();
            }
        }

        if ( key === "title" ) {
            this._title( this.uiDialogTitlebar.find( ".kc-dialog-title" ) );
        }
    },

    _size: function() {
        // If the user has resized the dialog, the .ui-dialog and .ui-dialog-content
        // divs will both have width and height set, so we need to reset them
        var nonContentHeight, minContentHeight, maxContentHeight,
            options = this.options;

        // Reset content sizing
        this.element.show().css({
            width: "auto",
            minHeight: 0,
            maxHeight: "none",
            height: 0
        });

        if ( options.minWidth > options.width ) {
            options.width = options.minWidth;
        }

        // reset wrapper sizing
        // determine the height of all the non-content elements
        nonContentHeight = this.uiDialog.css({
                height: "auto",
                width: options.width
            })
            .outerHeight();
        minContentHeight = Math.max( 0, options.minHeight - nonContentHeight );
        maxContentHeight = typeof options.maxHeight === "number" ?
            Math.max( 0, options.maxHeight - nonContentHeight ) :
            "none";

        if ( options.height === "auto" ) {
            this.element.css({
                minHeight: minContentHeight,
                maxHeight: maxContentHeight,
                height: "auto"
            });
        } else {
            this.element.height( Math.max( 0, options.height - nonContentHeight ) );
        }

        if ( this.uiDialog.is( ":data(ui-resizable)" ) ) {
            this.uiDialog.resizable( "option", "minHeight", this._minHeight() );
        }
    },

    _blockFrames: function() {
        this.iframeBlocks = this.document.find( "iframe" ).map(function() {
            var iframe = $( this );

            return $( "<div>" )
                .css({
                    position: "absolute",
                    width: iframe.outerWidth(),
                    height: iframe.outerHeight()
                })
                .appendTo( iframe.parent() )
                .offset( iframe.offset() )[0];
        });
    },

    _unblockFrames: function() {
        if ( this.iframeBlocks ) {
            this.iframeBlocks.remove();
            delete this.iframeBlocks;
        }
    },

    _allowInteraction: function( event ) {
        if ( $( event.target ).closest( ".kc-dialog" ).length ) {
            return true;
        }

        // TODO: Remove hack when datepicker implements
        // the .ui-front logic (#8989)
        return !!$( event.target ).closest( ".ui-datepicker" ).length;
    },

    _createOverlay: function() {
        if ( !this.options.modal ) {
            return;
        }

        // We use a delay in case the overlay is created from an
        // event that we're going to be cancelling (#2804)
        var isOpening = true;
        this._delay(function() {
            isOpening = false;
        });

        if ( !this.document.data( "kc-dialog-overlays" ) ) {

            // Prevent use of anchors and inputs
            // Using _on() for an event handler shared across many instances is
            // safe because the dialogs stack and must be closed in reverse order
            this._on( this.document, {
                focusin: function( event ) {
                    if ( isOpening ) {
                        return;
                    }

                    if ( !this._allowInteraction( event ) ) {
                        event.preventDefault();
                        this._trackingInstances()[ 0 ]._focusTabbable();
                    }
                }
            });
        }

        this.overlay = $( "<div>" )
            .addClass( "kc-widget-overlay kc-front" )
            .appendTo( this._appendTo() );
        this._on( this.overlay, {
            mousedown: "_keepFocus"
        });
        this.document.data( "kc-dialog-overlays",
            (this.document.data( "kc-dialog-overlays" ) || 0) + 1 );
    },

    _destroyOverlay: function() {
        if ( !this.options.modal ) {
            return;
        }

        if ( this.overlay ) {
            var overlays = this.document.data( "kc-dialog-overlays" ) - 1;

            if ( !overlays ) {
                this.document
                    .unbind( "focusin" )
                    .removeData( "kc-dialog-overlays" );
            } else {
                this.document.data( "kc-dialog-overlays", overlays );
            }

            this.overlay.remove();
            this.overlay = null;
        }
    }
});

(function () {
    kcaseagt = {};

    /* private */
    initBignum();
    var prop = new initProp();
    var util = new initUtil();
    var cipher = new initCipher();
    cipher.modes = new initCipherModes();
    var seed = new initSeed();
    var asn1 = new initAsn1();
    var random = new initRandom();
    var comm = new initComm();
    var rsa = new initRsa();
    var sha256 = new initSha256();

    /* public */
    kcaseagt = new initApi();

    kcaseagt.mode = {
        encrypt: 0,
        decrypt: 1
    };
    kcaseagt.algorithm = {
        SEED: "SEED",
        ARIA12: "ARIA12",
        ARIA14: "ARIA14",
        ARIA16: "ARIA16",
        DES3: "3DES",
        AES: "AES",
        RSA_PKCS: 0,
        RSA_OAEP: 1,
        KCDSA: 2,
        ECDSA: 3
    };
    kcaseagt.hash = {
        SHA1: 0,
        SHA224: 1,
        SHA256: 2,
        SHA384: 3,
        SHA512: 4
    };
		// 2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
    kcaseagt.enable = prop.enable;

    function initError() {

    }

    /* 외부 API */
    function initApi() {
        var dlgDictionary = new Object();
        var certPolicyCnt = 0;

        /* init flag */
        var integrityCheckFlag = false;

				/**
         * 서비스 에러 발생 시 동작할 콜백함수
         *
         * 2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         *
         * @method defineServiceError
         * @param {Function} func : 콜백함수
         * @deprecated
         */
        this.defineServiceError = function(func) {
            prop.AJAX_ERROR_FUNC = func;
        };

        /**
         * 세면 만료 시 동작할 콜백함수
         *
         * 2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         *
         * @method defineSessionExpired
         * @param {Function} func : 콜백함수
         * @deprecated
         */
        this.defineSessionExpired = function(func) {
            prop.AJAX_SESSION_EXPIRED = func;
        };

        /**
         * 유비키 미설치시 동작할 콜백함수
         *
         * 2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         *
         * @method defineNotInstalledUbiKey
         * @param {Function} func : 콜백함수
         */
        this.defineNotInstalledUbiKey = function(func) {
            prop.NOT_INSTALLED_UBIKEY = func;
        };
        
				/**
         * 인증서 다이얼로그 등 UI 취소시 콜백함수
         *
         * @method defineCancelDialgo
         * @param {Function} func : 콜백함수
         */
        this.defineCancelDialog = function(func) {
            prop.CANCEL_DIALOG = func;
        };
        
				this.defineCancelSubDialog = function(func) {
					prop.CANCEL_SUB_DIALOG = func;
				};
	 		  /**
         * 패스워드 오류 횟수 콜백 함수
         *
         * @method definePasswordExcess
         * @param {Function} func : 콜백함수
         */
				this.definePasswordExcess = function(func) {
						prop.INVALID_PASSWORD_EXCESS = func;
				};

        /* kcaseagent web init */
        this.init = function (option) {
            var options = {
                libRoot: "",
                sessId: "",
                mediaOpt: kcaseagt.enable.all,
                mainTitle: "",
                adminTitle : "",
                maxpwdcnt : 5,
                success: function () {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                },
        /**
         *	2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         */
                
                serviceError: function() {
                    alert("Ajax Failed")
                },
                sessionError: function() {
                    alert("KCaseLib Failed");
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }
						if(options.mediaOpt == 0xFF) {
							options.mediaOpt = 0x18;
						}
						// 2017.08.21 DYLEE Mac & Linux 인증서 Media 고정을 위해 추가(하드디스크 & 이동식디스크)
						
            prop.ROOT_DIR = options.libRoot;
            prop.mediaOpt = options.mediaOpt;
        /**
         *	2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         */
            
            
            if (prop.AJAX_ERROR_FUNC == null) {
                prop.AJAX_ERROR_FUNC = options.serviceError;
            }
            if (prop.AJAX_SESSION_EXPIRED == null) {
                prop.AJAX_SESSION_EXPIRED = options.sessionError;
            }

            if (prop.CANCEL_DIALOG == null) {
                prop.CANCEL_DIALOG = function(){
            			alert("취소되었습니다.");
            	};
            }
            if (prop.CANCEL_SUB_DIALOG == null) {
                prop.CANCEL_SUB_DIALOG = function(){
            			alert("취소되었습니다.");
            	};
            }
            if (prop.INVALID_PASSWORD_EXCESS == null) {
            	prop.INVALID_PASSWORD_EXCESS = function(errCode, errMsg){
            			alert(errCode + " : " + errMsg);
            	};
            }

		        prop.title.cert = options.mainTitle;
		        prop.title.admin = options.adminTitle;

            var div = document.createElement('div');
            div.id = "kcase" + random.generateStr();

            document.body.appendChild(div);

            $("#" + div.id).load(options.libRoot + "/view/dialogview.html", function () {
                dlgDictionary = initDialog();

                $("." + prop.cs.subDlgTitle).css("background", "url('"+ options.libRoot + prop.SUB_LOGO_URL +"')");
                $("." + prop.cs.mainDlgTitle).css("background", "url('"+ options.libRoot + prop.MAIN_LOGO_URL +"') no-repeat");
/* black307 170905
                var img = $("<img src='" + options.libRoot + "/img/off.png" + "'/>");
                $(".kc-off").append(img);
*/
                var buImg = $("<img src='" + options.libRoot + "/img/bu.png" + "'/>");
                $(".kc-bu").append(buImg);

                if(options.sessId == undefined) {
                    comm.sessionId = util.encode64(random.generate(8));
                } else {
                    comm.sessionId = util.encode64(options.sessId);
                }

                _integrityInit({
                    version: "1.0.0",
                    hashValue: "nBvZgQW/FyhQdQs8oI/zuFvxRisgrR7pHhJs+gXmnQI=",
                    maxpwdcnt: options.maxpwdcnt,
                    success: options.success,
                    error: options.error
                });
            });
        };

        /* Base64 Util */
        this.encode64 = util.encode64;
        this.decode64 = util.decode64;

        /* UTF8 Util */
        this.encodeUtf8 = util.encodeUtf8;
        this.decodeUtf8 = util.decodeUtf8;


		this.getSelectedCertDN = function (){
			var certInfo = util.getSelectedObject(prop.cs.certSelectedRow);
					if (certInfo == undefined) {
         				certInfo = null;
					} else {
							certInfo = certInfo.data("certInfo").subjectDN;
					}

					return certInfo;
		}
		
		/* Option Util */
        //this.setOption = util.setOption;

        /* Dialog Open */
        var openDialog = this.openDialog = function (option) {
            var dlg = dlgDictionary[prop.id.dialog.cert];
            dlg.open(option);
        };

        /* Add Certificate Policy */
        this.addCertPolicy = function(pol) {
            prop.certPolices[certPolicyCnt++] = pol;
        };

        /* Integrity Init & Security Session */
        var _integrityInit = function (option) {
            var options = {
                version: "",
                hashValue: "",
                maxpwdcnt: 5,
                success: function () {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            var intObj = {
                version: options.version,
                hashValue: options.hashValue,
                maxpwdcnt: options.maxpwdcnt
            };

            /* 무결성 체크 요청 */
            comm.reqIntegrityInit(intObj, function (result) {
                var status = result.Status;

                if (status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
										alert("error : ");
                    return;
                }


                var decodedSignMsg = util.decode64(result.IntMsg);

                var rsaPubKey = rsa.publicKeyFromPem(result.PubKey);

                var hash = sha256.create();
                hash.update(intObj.hashValue);
                var verify = rsa.verify(hash.digest().bytes(), decodedSignMsg, rsaPubKey);

                /* 전자서명 검증 성공 시 */
                if (verify === true) {
                    var key, iv, encKey, b64key, nonce;
/*
                    key = random.generate(16);
                    iv = random.generate(16);							*/
                    
 										key = util.decode64("2fN+gnsblPwoSaea0xa4kw==");
                    iv = util.decode64("cyT9P2lw2FBkW7DsdN2uQQ==");

                    nonce = random.generate(32);

                    /* 대칭키 , Nonce 암호화 */
                    encKey = rsa.encrypt(key + iv + nonce, rsaPubKey);

                    /* 대칭키와 nonce값을 Base64로 인코딩 */
                    b64key = util.encode64(encKey);

                    comm.reqHandshake(b64key, function (result) {
                        var status = result.Status;
                        if(result.Status != prop.success) {
                            options.error(status, prop.getErrorMsg(status));
                        } else {
                            var decryptedHandMsg;
                            /* Session 관리 */
                            comm.securitySession.setSecureMode(key, iv);
                            decryptedHandMsg = comm.securitySession.decrypt(util.decode64(result.HandshakeMsg));

                            /* 대칭키로 암/복호화 확인 */
                            //if (nonce === decryptedHandMsg) {
                            if(1) {
                                integrityCheckFlag = true;
                                options.success();
                            } else {
                                options.error("암복호화 실패");
                            }
                        }
                    });
                }
                else {
                    options.error("전자서명 실패");
                }
            }, true);
        };

        /* kcaseagnet close security session */
        // Deprecated
        this.closeSecSession = function (option) {
            var options = {
                success: function () {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };
            /* 옵션 파라미터 처리 */
            if (option !== undefined) {
                util.setOption(options, option);
            }
            comm.reqCloseSecurity(function (result) {
                if (result.Status == 0) {
                    comm.securitySession.disableSecureMode();
                    options.success();
                }
            });
        };

        /* kcaseagent generate symemtric key */
        this.generateSymKeyIv = function (option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: kcaseagt.algorithm.SEED,
                success: function (key, iv) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqGenSymmetricKey(options.algorithm, function (result) {
                var status = result.Status;

                if (status == prop.success) {
                    options.success(result.SymmKey, result.SymmIv);
                } else {
                    var errMsg = util.decodeUtf8(util.decode64(result.ErrorMsg));
                    options.error(errMsg);
                }
            });
        };

        /* kcaseagent block encrypt */
        this.blockCipher = function (option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                mode: 0,
                algorithm: kcaseagt.algorithm.SEED,
                key: "",
                iv: "",
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            var reqObj = {
                mode: options.mode,
                algorithm: options.algorithm,
                key: options.key,
                iv: options.iv,
                inputText: options.input
            };

            if (reqObj.mode == 0) {
                reqObj.inputText = util.encode64(util.encodeUtf8(reqObj.inputText));
            }

            comm.reqBlockCipher(reqObj, function (result) {
                var status = result.Status;

                if (status == prop.success) {
                    if (options.mode == 1) {
                        result.Output = util.decodeUtf8(util.decode64(result.Output));
                    }
                    options.success(result.Output);
                } else {
                    options.error(result.Status, prop.getErrorMsg(result.Status));
                }
            });
        };

				this.ASP_blockCipher = function (option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                mode: 0,
                algorithm: kcaseagt.algorithm.SEED,
                key: "",
                iv: "",
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            var reqObj = {
                mode: options.mode,
                algorithm: options.algorithm,
                key: options.key,
                iv: options.iv,
                inputText: options.input
            };

            if (reqObj.mode == 0) {
                reqObj.inputText = util.encode64(util.encodeUtf8(reqObj.inputText));
            }
            comm.ASP_reqBlockCipher(reqObj, function (result) {
                var status = result.Status;

                if (status == prop.success) {
                    if (options.mode == 1) {
                        result.Output = util.decodeUtf8(util.decode64(result.Output));
                    }
                    options.success(result.Output);
                } else {
                    options.error(result.Status, prop.getErrorMsg(result.Status));
                }
            }, true);
        };

        /* generate sign data */
        this.genSignData = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                /*algorithm: kcaseagt.algorithm.RSA_PKCS,
                keybit: 2048,
                hash: kcaseagt.hash.SHA256,*/
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.service = "sign";

            openDialog(options);
        };

        /* verify sign data */
        this.verifySignData = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqVerifySignData(options.input, function (result) {
                var status = result.Status;

                if (status != prop.success) {
                    options.error(result.Status, prop.getErrorMsg(result.Status));
                } else {
                    options.success(util.decode64(result.Output));
                }
            }, false);
        };

				this.ASP_verifySignData = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqVerifySignData(options.input, function (result) {
                var status = result.Status;

                if (status != prop.success) {
                    options.error(result.Status, prop.getErrorMsg(result.Status));
                } else {                		
                    options.success(util.decodeUtf8(util.decode64(result.Output)));
                }
            }, false);
        };

        /* verify certificate vid */
        this.getVidInfo = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                peerCert: "",
                vid: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.service = "vid";

            openDialog(options);
        };

        /**
         * 선택한 인증서의 R값을 이용하여 신원확인 요청 값을 생성합니다.
         *
         * @method getVidInfo
         * @param {Object} [option] option
         * @param {String} [option.peerCert] Base64 형태의 상대방 인증서
         * @param {String} option.vid 신원확인 값
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         *
         * 2017-09-11 DYLEE ASP 함수추가
         */
        this.ASP_getVidInfo = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                peerCert: "",
                vidopt: "",
                vid: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            if (options.vid.length <= 0) {
                var status = 0x5001;    // INVALID_INPUTDATA
                options.error(status, prop.getErrorMsg(status));
                return;
            }

            options.service = "vidASP";

            openDialog(options);
        };

        /* enveloped data */
        this.genEnvelopedData = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: "",
                peerCert: "",
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.input = util.encode64(util.encodeUtf8(options.input));

            comm.reqEnvelopedData(options, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success(result.Output);
                }
            }, true);
        };
        /**
         * PKCS#7 EnvelopedData를 생성합니다.  (ASP)
         *
         * @method genEnvelopedData
         * @param {Object} [option] option
         * @param {String} [option.peerCert] Base64 형태의 상대방 인증서
         * @param {Object} option.algorithm 암호화 알고리즘
         * @param {String} option.input 입력값
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
				this.ASP_genEnvelopedData = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: "",
                peerCert: "",
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
        };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.input = util.encode64(util.encodeUtf8(options.input));
            //function ASP_callGenEnvelopedData() {
                comm.ASP_reqEnvelopedData(options, function(result) {
                    var status = result.Status;

                    if(status != prop.success) {
                        options.error(status, prop.getErrorMsg(status));
                    } else {
                        options.success(result.Output);
                    }
                }, false);
            //}
/*
            if (!prop.isSaveServerCert) {
                comm.setEnvCert(options.peerCert, function(response) {
                    if (response.Status == prop.success) {
                        prop.isSaveServerCert = true;
                        ASP_callGenEnvelopedData();
                    } else {
                        options.error(response.Status, prop.getErrorMsg(response.Status));
                    }
                }, false);
            } else {
                ASP_callGenEnvelopedData();
            }
*/
			// 2017-09-11 DYLEE ASP 함수 추가
        }; 

        this.certLogin = function(option) {
			
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                vid: "",
                peerCert: "",
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.service = "login";

            openDialog(options);
        };

        /**
         * 선택한 인증서로 로그인 요청 값을 생성합니다. (ASP)
         *
         * 2017-09-13 DYLEE ASP 누락 함수 추가
         
         * @method ASP_certLogin
         * @param {Object} [option] option
         * @param {String} [option.peerCert] Base64 형태의 상대방 인증서
         * @param {String} [option.input] 입력값
         * @param {String} [option.vid] 신원확인 값
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         */
        this.ASP_certLogin = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                vid: "",
                peerCert: "",
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.service = "loginASP";

            openDialog(options);
        };
        
        this.initSecureChannel = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: kcaseagt.algorithm.SEED,
                input: "",
                peerCert: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqInitSecureChannel(options.input, options.algorithm, options.peerCert, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success(result.Output);
                }
            }, true);
        };

				/**
         * 채널보안 생성에 대한 요청값을 생성합니다. (ASP)
         *
         * @method initSecureChannel
         * @param {Object} [option] option
         * @param {Object} option.algorithm 채널보안 암호화 알고리즘
         * @param {String} [option.peerCert] Base64 형태의 상대방 인증서
         * @param {String} [option.input] 입력값
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         *
         *	2017-09-11 DYLEE ASP 함수명 변경 suffix -> prefix
         *
         */
        this.ASP_initSecureChannel = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: kcaseagt.algorithm.SEED,
                input: "",
                peerCert: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.ASP_reqInitSecureChannel(options.input, options.algorithm, options.peerCert, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success(result.Output);
                }
            }, true);
        };

				// 2017.08.01 DYLEE 채널보안 로그인 동시수행을 위한 Javascript 함수 추가
        /**
         * 채널보안이 형성된 후 로그인 요청값을 생성합니다.
         *
         * @method secureChannelLogin
         * @param {Object} [option] option
         * @param {Object} option.algorithm 채널보안 암호화 알고리즘
         * @param {String} [option.peerCert] Base64 형태의 상대방 인증서
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         */
        this.secureChannelLogin = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: kcaseagt.algorithm.SEED,
                peerCert: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.service = "secLogin";

            openDialog(options);
        };
        /**
         * 채널보안이 형성된 후 로그인 요청값을 생성합니다. (ASP)
         *
         * @method secureChannelLogin
         * @param {Object} [option] option
         * @param {Object} option.algorithm 채널보안 암호화 알고리즘
         * @param {String} [option.peerCert] Base64 형태의 상대방 인증서
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
					this.ASP_secureChannelLogin = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                algorithm: kcaseagt.algorithm.SEED,
                peerCert: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            options.service = "secLoginASP";

            openDialog(options);
        };

        this.secureEncrypt = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqExSecureChannel(kcaseagt.mode.encrypt, options.input, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success(result.Output);
                }
            }, true);
        };
        /**
         * 채널보안이 형성된 후 암호화를 수행합니다. (ASP)
         *
         * @method secureEncrypt
         * @param {Object} [option] option
         * @param {String} option.input 입력값
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
        this.ASP_secureEncrypt = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.ASP_reqExSecureChannel(kcaseagt.mode.encrypt, options.input, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success(result.Output);
                }
            }, true);
        };

        this.secureDecrypt = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqExSecureChannel(kcaseagt.mode.decrypt, options.input, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success(result.Output);                    
                }
            }, true);
        };
        /**
         * 채널보안이 형성된 후 복호화를 수행합니다.
         *
         * @method secureDecrypt
         * @param {Object} [option] option
         * @param {String} option.input 입력값
         * @param {Function} [option.success] 성공 콜백함수
         * @param {Function} [option.error] 실패 콜백함수
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
        this.ASP_secureDecrypt = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                input: "",
                success: function (output) {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.ASP_reqExSecureChannel(kcaseagt.mode.decrypt, options.input, function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                	//	2017-09-18 DYLEE Agent와 통신 중 한글처리를 위해 디코딩 추가
                    options.success(util.decodeUtf8(util.decode64(result.Output)));
                }
            }, true);
        };

        this.closeSecureChannel = function(option) {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                success: function () {
                },
                error: function (c, msg) {
                    alert(c + ": " + msg);
                }
            };

            if (option !== undefined) {
                util.setOption(options, option);
            }

            comm.reqCloseSecureChannel(function(result) {
                var status = result.Status;

                if(status != prop.success) {
                    options.error(status, prop.getErrorMsg(status));
                } else {
                    options.success();
                }
            }, true);
        };

        /* dec enveloped data */
        this.decEnvelopedData = function(option) {

        };

        /* open admin mode */
        this.openAdminDialog = function() {
            if (!integrityCheckFlag) {
                return;
            }
            var options = {
                service: "admin"
            };

            openDialog(options);
        };
    }

    function initComm() {
        /**
         * API Name 리스트
         *
         * @property APINameList
         * @type {Object}
         */
        var APINameList = {
            INTEGRITY_INIT: 1,
            HANDSHAKE: 2,
            CLOSE_SECURITY: 3,
            INIT: 4,
            REMDISK_LIST: 5,
            DIRECTORY_LIST: 6,
            SECURITY_TOKEN_LIST: 7,
            /*DAEMON_CHECK: 8,*/
            CERT_LIST_ADMIN: 9,
            CERT_LIST: 10,
            CERT_LOGIN: 11,
            CERT_DELETE: 12,
            CERT_VERIFY: 13,
            CERT_CHANGE_PASSWORD: 14,
            CERT_COPY: 15,
            CERT_IMPORT: 16,
            CERT_EXPORT: 17,
            CERT_COPY_ST: 18,
            CERT_IMPORT_ST: 19,
            CERT_GENSIGN_ST: 20,
            CERT_GENERATE_SIGNDATA: 21,
            CERT_VERIFY_SIGNDATA: 22,
            GENERATE_SYMM_KEY: 23,
            GENERATE_IV: 24,
            BLOCKCIPHER: 26,
            ENVELOP_DATA: 29,
            DEVELOP_DATA: 30,
            VERIFY_VID: 31,
            VERIFY_PASSWORD: 32, // before VERIFY_VID
            SECURE_CHANNEL_INIT: 33,
            SECURE_CHANNEL_CLOSE: 34,
            SECURE_CHANNEL_EXCHANGE: 35,
            SECURE_CHANNEL_LOGIN: 36,
            SET_ENVCERT: 55,
            // 2017.08.01 DYLEE APINameList 36, 55 추가
            ENVELOP_DATA_ASP: 66,
            VERIFY_VID_ASP: 67,
            SECURE_CHANNEL_INIT_ASP: 68,
            SECURE_CHANNEL_LOGIN_ASP: 69,
            SECURE_CHANNEL_EXCHANGEASP: 71,
            CERT_LOGINASP: 72,
            BLOCKCIPHER_ASP:73,
            // 2017.09.11 DYLEE APINameList 66, 67, 68, 69, 71, 72 추가
            // 2017.09.13 DYLEE APINameList 73 추가
        };

        this.sessionId = "kswebkit";

        /* 암호 통신 정보 */
        function SecurityInfoBase() {
            var isSecure = false,
                sessionKey = undefined,
                sessionIv = undefined;

            /* Internel Function List */
            function checkInputParams() {
                if (!isSecure) {
                    return false;
                }
                if (sessionKey == undefined || sessionIv == undefined) {
                    return false;
                }
                return true;
            }

            /* function list */
            this.isSecureMode = function () {
                return isSecure;
            };
            this.setSecureMode = function (key, iv) {
                sessionKey = key;
                sessionIv = iv;
                isSecure = true;
            };
            this.disableSecureMode = function () {
                sessionKey = undefined;
                sessionIv = undefined;
                isSecure = false;
                this.sessionId = "kswebkit";
            };
            this.encrypt = function (p) {
                if (checkInputParams()) {
                    var plainBytes = util.createBuffer(p, "utf8");
                    var cipherobj = cipher.createCipher("SEED-CBC", sessionKey);
                    cipherobj.start({iv: sessionIv});
                    cipherobj.update(plainBytes);
                    cipherobj.finish();
                    return cipherobj.output.data;
                } else {
                    return undefined;
                }
            };
            this.decrypt = function (c) {
                if (checkInputParams()) {
                    var encBytes = util.createBuffer(c);
                    var decipher = cipher.createDecipher("SEED-CBC", sessionKey);
                    decipher.start({iv: sessionIv});
                    decipher.update(encBytes);
                    decipher.finish();
                    return decipher.output.data;
                } else {
                    return undefined;
                }
            };
        }

        this.securitySession = new SecurityInfoBase();

        /**
         * 모듈 초기화
         *
         * @method reqDaemonAlive
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqInit = function (daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.INIT
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 무결성 확인 요청
         *
         * @method reqIntegrityInit
         * @param {Object} intObj : 무결성 체크 정보 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqIntegrityInit = function (intObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.INTEGRITY_INIT,
                Version: intObj.version,
                HashValue: intObj.hashValue,
                maxpwdcnt: intObj.maxpwdcnt
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 대칭키 교환 요청
         *
         * @method reqHandshake
         * @param {Object} encKey : 암호화된 대칭 키
         * @param {Object} nonce : 키 교환 Nonce 값
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqHandshake = function (encKey, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.HANDSHAKE,
                EncryptedKey: encKey
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 암호 통신 종료 요청
         *
         * @method reqCloseSecurity
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCloseSecurity = function (daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CLOSE_SECURITY
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 이동식 디스크 리스트 요청
         *
         * @method reqRemovableDiskList
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqRemovableDiskList = function (daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.REMDISK_LIST
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 디렉토리 리스트 요청
         *
         * @method reqDirectoryList
         * @param {Function} path : 디렉토리 요청 경로
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqDirectoryList = function (path, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.DIRECTORY_LIST,
                ReqPath: path
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 보안토큰 리스트 요청
         *
         * @method reqSecTokenList
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqSecTokenList = function (daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURITY_TOKEN_LIST
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 리스트 요청
         *
         * @method reqCertList
         * @param {Object} reqOpt : 인증서 리스트 요청 옵션
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCertList = function (reqOpt, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_LIST,
                Media: reqOpt.media,
                Drive: reqOpt.drive,
                CertOpt: reqOpt.optList,
                CertPolicies: reqOpt.certPolicies,
                Pkcs11Name: reqOpt.secTokProg
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 로그인 요청
         *
         * @method reqCertLogin
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} inputPw : 인증서 비밀번호
         * @param {Object} loginObj : 상대방인증서, 원문, VID 값
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCertLogin = function (certInfo, inputPw, loginObj, daemonSvcResponse, pLoading) {
			var obj = {
                APIName: APINameList.CERT_LOGIN,
                Media: certInfo.media,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Password: inputPw,
                PeerCert: loginObj.peerCert,
                Input: loginObj.input,
                VID: loginObj.vid
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 로그인 요청 (ASP)
         *
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} inputPw : 인증서 비밀번호
         * @param {Object} loginObj : 상대방인증서, 원문, VID 값
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
        this.ASP_reqCertLogin = function (certInfo, inputPw, loginObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_LOGINASP,
                Media: certInfo.media,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Pkcs11Name: loginObj.progName,
                Password: inputPw,
                VID: loginObj.vid
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 전자서명 생성 요청
         *
         * @method reqGenSignData
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} certPw : 인증서 비밀번호
         * @param {Object} signObj : 서명알고리즘, 키 비트, 해시, 원문
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqGenSignData = function (certInfo, certPw, signObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_GENERATE_SIGNDATA,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Password: certPw,
                Algorithm: signObj.algorithm,
                KeyBit: signObj.keybit,
                Hash: signObj.hash,
                Input: signObj.input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 전자서명 검증 요청
         *
         * @method reqVerifySignData
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} certPw : 인증서 비밀번호
         * @param {Object} p : 전자서명 원문
         * @param {Object} input : 검증할 전자서명
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqVerifySignData = function (input, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_VERIFY_SIGNDATA,
                Input: input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * Enveloped Data 요청
         *
         * @method reqEnvelopeData
         * @param {Object} envObj : 알고리즘, 상대방 인증서(공개키), 원문
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqEnvelopedData = function (envObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.ENVELOP_DATA,
                Algorithm: envObj.algorithm,
                PeerCert: envObj.peerCert,
                Input: envObj.input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * Develope 요청
         *
         * @method reqDevelopeData
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} intObj : 인증서 비밀번호, EnvelopedData
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqDevelopeData = function (certInfo, intObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.DEVELOP_DATA,
                Media: certInfo.media,
                CertDn: certInfo.certDn,
                Password: intObj.inputPw,
                EnvelopedData: intObj.envelopedData
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        /**
         * Enveloped Data 요청
         *
         * @param {Object} envObj : 알고리즘, 상대방 인증서(공개키), 원문
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         *
         * 2017-09-11 DYLEE ASP 함수 추가
         *
         */
        this.ASP_reqEnvelopedData = function (envObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.ENVELOP_DATA_ASP,
                Algorithm: envObj.algorithm,
                PeerCert: envObj.peerCert,
                Input: envObj.input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        /**
         * 인증서 PASSWORD 체크 요청
         *
         * @method reqVerifyCertPW
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} inputPw : 인증서 비밀번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCheckCertPW = function (certInfo, inputPw, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.VERIFY_PASSWORD,
                Media: certInfo.media,
                CertDn: certInfo.certDn,
                Password: inputPw
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * VID 검증 요청
         *
         * @method reqVerifyVID
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} certPw : 인증서 비밀번호
         * @param {Object} vid : 신원확인 식별번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        /*this.reqVerifyVID = function (certInfo, certPw, vid, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.VERIFY_VID,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Password: certPw,
                VID: vid
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };*/

        /**
         * VID 정보 요청
         *
         * @method reqVerifyVID
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} certPw : 인증서 비밀번호
         * @param {Object} vidObj : VID 값, 상대방 인증서
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqVerifyVidInfo = function (certInfo, certPw, vidObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.VERIFY_VID,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Password: certPw,
                VID: vidObj.vid,
                PeerCert: vidObj.peerCert
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        /**
         * VID 정보 요청
         *
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} certPw : 인증서 비밀번호
         * @param {String} vid : VID 값
         * @param {String} vidopt : client 인증여부
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         *
         * 2017-09-13 DYLEE ASP 함수 추가
         *
         */
         
        this.ASP_reqVerifyVidInfo = function (certInfo, certPw, vid, vidopt, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.VERIFY_VID_ASP,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Media: certInfo.media,
                Password: certPw,
                VID: vid,
                VIDOPT: vidopt
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 삭제 요청
         *
         * @method reqDeleteCert
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} password : 보안토큰 비밀번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqDeleteCert = function (certInfo, password, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_DELETE,
                Media: certInfo.media,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                PinPassword: password
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 검증 요청
         *
         * @method reqCertVerify
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCertVerify = function (certInfo, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_VERIFY,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 비밀번호 변경
         *
         * @method reqChangePassword
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} oldPw : 기존 인증서 비밀번호
         * @param {Object} newPw : 변경할 인증서 비밀번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqChangePassword = function (certInfo, oldPw, newPw, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_CHANGE_PASSWORD,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                OldPassword: oldPw,
                NewPassword: newPw
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 복사
         *
         * @method reqCopyCert
         * @param {Object} certInfo : 선택 인증서 객체
         * @param {Object} selectMediaInfo : 복사할 미디어 매체 정보
         * @param {Object} password : 인증서 비밀번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCopyCert = function (certInfo, selectMediaInfo, password, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_COPY,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                ToMedia: selectMediaInfo.toMedia,
                ToDrive: selectMediaInfo.toDrive,
                Password: password
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 가져오기
         *
         * @method reqImportCert
         * @param {Object} reqPath : PFX 파일이 위치한 경로
         * @param {Object} toMedia : 복사할 미디어 매체
         * @param {Object} toDrive : 복사할 미디어 매체의 저장 드라이브
         * @param {Object} password : 인증서 비밀번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqImportCert = function (reqPath, toMedia, toDrive, password, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_IMPORT,
                ToMedia: toMedia,
                ToDrive: toDrive,
                ReqPath: reqPath,
                Password: password
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 내보내기
         *
         * @method reqExportCert
         * @param {Object} certInfo : 내보낼 인증서 정보 객체
         * @param {Object} reqPath : 내보낼 미디어 매체 경로
         * @param {Object} password : 인증서 비밀번호
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqExportCert = function (certInfo, reqPath, password, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_EXPORT,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                ReqPath: reqPath,
                Password: password
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 복사 - 보안토큰
         *
         * @method reqCopyCertSecToken
         * @param {Object} certInfo : 복사할 인증서 정보 객체
         * @param {Object} secTokenData : 보안토큰 정보 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCopyCertSecToken = function (certInfo, secTokenData, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_COPY_ST,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Pkcs11Name: secTokenData.progName,
                Password: secTokenData.certPw,
                PinPassword: secTokenData.pinPw
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 인증서 가져오기 - 보안토큰
         *
         * @method reqImportCertSecToken
         * @param {Object} reqPath : 가져올 인증서의 위치 경로
         * @param {Object} secTokenData : 보안토큰 정보 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqImportCertSecToken = function (reqPath, secTokenData, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_IMPORT_ST,
                ReqPath: reqPath,
                Pkcs11Name: secTokenData.progName,
                Password: secTokenData.certPw,
                PinPassword: secTokenData.pinPw
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 전자서명 생성 - 보안토큰
         *
         * @method reqSignDataPkcs11
         * @param {Object} certInfo : 선택한 인증서 정보 객체
         * @param {Object} signObj : 전자서명 생성 입력 정보 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqSignDataPkcs11 = function (certInfo, signObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.CERT_GENSIGN_ST,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Pkcs11Name: signObj.progName,
                PinPassword: signObj.pinPw,
                Input: signObj.input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 블록 암, 복호화 요청
         *
         * @method reqSeedEncrypt
         * @param {Object} intObj : 무결성 체크 정보 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqBlockCipher = function (reqObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.BLOCKCIPHER,
                Mode: reqObj.mode,
                Algorithm: reqObj.algorithm,
                SymmKey: reqObj.key,
                SymmIv: reqObj.iv,
                Input: reqObj.inputText
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        
        this.ASP_reqBlockCipher = function (reqObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.BLOCKCIPHER_ASP,
                Mode: reqObj.mode,
                Algorithm: reqObj.algorithm,
                SymmKey: reqObj.key,
                SymmIv: reqObj.iv,
                Input: reqObj.inputText
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        /**
         * 대칭키 생성 요청
         *
         * @method reqGenSymmetricKey
         * @param {Object} algorithm : 생성할 키 알고리즘
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqGenSymmetricKey = function (algorithm, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.GENERATE_SYMM_KEY,
                Algorithm: algorithm
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * IV 생성 요청
         *
         * @method reqInitVector
         * @param {Object} intObj : 요청 정보 객체
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqGenInitVector = function (intObj, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.GENERATE_IV,
                Byte: intObj.byte
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 보안채널 생성 요청
         *
         * @method reqInitSecureChannel
         * @param {Object} peerCert: 상대방 인증서
         * @param {Object} algorithm: 블록암호 알고리즘
         * @param (Object) input : 보안채널 암호화 동시 수행시 입력값(option)
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqInitSecureChannel = function (input, algorithm, peerCert, daemonSvcResponse) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_INIT,
                Algorithm: algorithm,
                PeerCert: peerCert,
                Input: input												// 2017.08.04 DYLEE 보안채널 암호화 동시 수행 기능에 필요한 변수 추가
            };
            _daemonServiceRequest(obj, false, daemonSvcResponse);
        };
        /**
         * 보안채널 생성 요청
         *
         * @param {Object} peerCert: 상대방 인증서
         * @param {Object} algorithm: 블록암호 알고리즘
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         *
         * 2017-09-11 DYLEE ASP 함수 추가
         *
         */
        this.ASP_reqInitSecureChannel = function (input, algorithm, peerCert, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_INIT_ASP,
                Algorithm: algorithm,
                PeerCert: peerCert,
                Input: input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        }; 
        
        /**
         * 보안채널 종료 요청
         *
         * @method reqCloseSecureChannel
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqCloseSecureChannel = function (daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_CLOSE
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 보안채널 메시지 교환
         *
         * @method reqExSecureChannel
         * @param {Integer} mode: 암 복호화 모드
         * @param {String} input: 입력값
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         * @param {Boolean} pLoading : 로딩바 출력 여부
         */
        this.reqExSecureChannel = function (mode, input, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_EXCHANGE,
                Mode: mode,
                Input: input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        /**
         * 보안채널 메시지 교환
         *
         * @param {Number} mode: 암 복호화 모드
         * @param {String} input: 입력값
         * @param {Function} daemonSvcResponse : 성공 시 수행할 동작
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
        this.ASP_reqExSecureChannel = function (mode, input, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_EXCHANGEASP,
                Mode: mode,
                Input: input
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
				// 2017.08.01 DYLEE 채널보안 로그인 동시 수행 API 추가
        /**
         * 보안채널 로그인 동시수행
         *
         * @param certInfo
         * @param inputPw
         * @param algorithm
         * @param daemonSvcResponse
         */
        this.reqSecChannelLogin = function (certInfo, inputPw, algorithm, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_LOGIN,
                Media: certInfo.media,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Password: inputPw,
                Algorithm: algorithm
            };

            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };

        /**
         * 보안채널 로그인 동시수행 (ASP)
         *
         * @param certInfo
         * @param inputPw
         * @param algorithm
         * @param daemonSvcResponse
         *
         * 2017-09-11 DYLEE ASP 함수추가
         *
         */
	this.ASP_reqSecChannelLogin = function (certInfo, inputPw, algorithm, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SECURE_CHANNEL_LOGIN_ASP,
                Media: certInfo.media,
                CertDn: util.encode64(util.encodeUtf8(certInfo.subjectDN)),
                CertSn: certInfo.serialNumber,
                Password: inputPw,
                Algorithm: algorithm
            };

            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        }; 
				// 2017.08.01 DYLEE Javascript 함수 추가
				/**
         * Set Server Certificate
         * @param peerCert
         * @param daemonSvcResponse
         */
        this.setEnvCert = function(peerCert, daemonSvcResponse, pLoading) {
            var obj = {
                APIName: APINameList.SET_ENVCERT,
                PeerCert: peerCert
            };
            _daemonServiceRequest(obj, pLoading, daemonSvcResponse);
        };
        /**
         * Ajax 요청
         *
         * @method _daemonServiceRequest
         * @param {Object} sendObj : 데몬에 요청할 오브젝트 정보
         * @param {Boolean} pLoading : 로딩바 출력 여부
         * @param {Function} resultFunc : 성공 시 수행할 동작
         */

        function _daemonServiceRequest(sendObj, pLoading, resultFunc) {
            var kAjaxReq, obj, sendData, closeMode = false;
/*
            if (pLoading == true) {
                window.parent.$.isLoading({
                    text: prop.strings.IS_LOADING
                });
            }
*/
		/* 2017.07.31 DYLEE Windows 와 동일하게 Loading UI 추가 */
            if (pLoading) {
                util.spinner.show(true);
            } else {
                if (timeoutValue > 8000.0 || timeoutValue == 0) {
                    util.spinner.show(true);
                }
            }

            if (sendObj.APIName == APINameList.CLOSE_SECURITY) {
                closeMode = true;
            }

            obj = {
                SessionId: comm.sessionId,
                Data: util.encode64(JSON.stringify(sendObj))
            };
					/*
            if (comm.securitySession.isSecureMode() == true) {
                var nonce = util.encode64(random.generate(8));

                obj.Data = util.encode64(comm.securitySession.encrypt(nonce + obj.Data));
            }*/
						var timeoutValue;
			
					if(sendObj.APIName == APINameList.INTEGRITY_INIT){
							timeoutValue = 5000;
					}
					else {
						timeoutValue = 0;
					}
				
            obj.Data = obj.Data.split("/").join("%33");

            sendData = JSON.stringify(obj);
		
            $.ajax({
            		method: "POST",
                url: prop.requestUrl,
                jsonpCallback: "KCASE",
                dataType: 'jsonp',
                data: sendData,
								timeout: timeoutValue,
                success: function(data) {
                    var jsonObj;

                    if (comm.securitySession.isSecureMode() == true && closeMode == false) {
                        //var decData = comm.securitySession.decrypt(util.decode64(data.Output));
                        var decData = util.decode64(data.Output);
                        jsonObj = $.parseJSON(decData);
                    } else {
                        jsonObj = data;
                    }

                    if(jsonObj.Status == -2) {
                    		//comm.established = false;
                      	prop.AJAX_SESSION_EXPIRED();
                    } else {
                        comm.sessionId = jsonObj.SessionId;

                        /* Invoke Callback Function */
                        resultFunc(jsonObj);
                    }
/*
                    if (pLoading == true) {
                        window.parent.$.isLoading("hide");
                    }
*/
		/* 2017.07.31 DYLEE Windows 와 동일하게 Loading UI 추가 */
										util.spinner.hide();
                },
                error: function(data, status, err) {
/*
                    if (pLoading == true) {
                        window.parent.$.isLoading("hide");
                    }
*/
		/* 2017.07.31 DYLEE Windows 와 동일하게 Loading UI 추가 */
										util.spinner.hide();
        /**
         *	2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         */
                    prop.AJAX_ERROR_FUNC();
                }
            });
	    function KCASE (data) {
            	alert(data);
            };

        }
    }


    function initProp() {
        /* url 경로 */
        this.requestUrl = "http://127.0.0.1:39721";
        this.SECURITY_TOKEN_INSTALL_URL = "http://www.rootca.or.kr/kor/hsm/hsm.jsp";
        var rootdir = this.ROOT_DIR = "";
        this.MAIN_LOGO_URL = "/img/main.png";
        this.SUB_LOGO_URL = "/img/sub.png";
        this.PROGRAM_INSTALL_PAGE_URL = "";
        
        /**
         *	2017-07-13 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가
         */
         
        this.AJAX_ERROR_FUNC = null;
        this.AJAX_SESSION_EXPIRED = null;
        this.NOT_INSTALLED_UBIKEY = null;

        /**
         *	2018-06-26 DYLEE EPKICommon.js 일원화를 위하여 필요한 함수 및 변수 추가 비밀번호 횟수제한 추가, 다이얼로그 닫기 시 콜백 추가
         */
        
        this.CANCEL_DIALOG = null;
        this.CANCEL_SUB_DIALOG = null;
        this.INVALID_PASSWORD_EXCESS = null;
        
        /* Constants */
        this.success = 0;
        this.error = -1;

        /* PKCS12 Mode */
        this.pkcs12 = {
            exportCert: 0,
            importCert: 1
        };

        /* Media List */
/*        this.media = {
            hardDisk: 0,
            removableDisk: 1,
            pkcs11: 2
        };*/
        /* Media List */
        this.media = {
            hardDisk: 0,
            removableDisk: 1,
            pkcs11: 2,
            mobile: 3,
            savetoken: 4
        };

        /* Media Enable */
        this.mediaOpt = 0xFF;

        /* Media Enable Mask Value */
        this.enable = {
            all: 0xFF,
            harddisk: 0x10,
            remdisk: 0x08,
            savetoken: 0x04,
            pkcs11: 0x02,
            mobile: 0x01
        };

        /**
         * 현재 선택된 인증서 종류
         *
         * @property selectCertOpt
         * @type {Object}
         */
        this.selectCertOpt = {
            CERTLIST_ALL: 0x003B01,
            CERTLIST_NPKI: 0x002801,
            CERTLIST_GPKI: 0x001A01,

            ADMIN_CERTLIST_ALL: 0x003B81,
            ADMIN_CERTLIST_NPKI: 0x002881,
            ADMIN_CERTLIST_GPKI: 0x001A81,

            CERTLIST_ENC_ALL: 0x003701,
            CERTLIST_ENC_NPKI: 0x002401,
            CERTLIST_ENC_GPKI: 0x001701
        };

         /* debug status */
        this.debug = false;

				/**
				 * 2017.08.01 DYLEE Windows 기능과 동기화를 위해 추가된 변수.
				 * 데이터 Envelop을 위해 인증서가 Agent로 한번 이상 전달된 이후에는
				 * 인증서를 받지 않아도 정상적으로 기능을 수행할 수 있게끔 하기 위해 만들어진 변수
				 */
				/* EnvCert */
        this.isSaveServerCert = false;

		/* check is SubView */
		this.isSubView = false;
        
        /* Certificate Policies */
        this.certPolices = [];

        /* Identifier List */
        this.id = {
            dialog: {
                cert: "kc_dialog_default",
                viewCert: "kc_dialog_viewCert",
                pkcs11: "kc_dialog_pkcs11",
                pkcs12: "kc_dialog_pkcs12",
                pInfo: "kc_dialog_pInfo",
                media: "kc_dialog_media",
                changePw: "kc_dialog_changePw",
                file: "kc_dialog_file",
                drive: "kc_dialog_drive",
                pw: "kc_dialog_pw",
                load: "kc_dialog_load",
                pin: "kc_dialog_pin"
            },
            title: "kc_dialog_title",
            certPosTable: "kc_cert_position",
            certList: "kc_cert_list",
            certType: "kc_cert_type",
            certCa: "kc_cert_ca",
            content: {
                cert: "kc_content_default",
                admin: "kc_content_admin"
            },
            tabList: "kc_viewverify_tablist",
            tabCommon: "kc_tab_common",
            tabDetail: "kc_tab_detail",
            p12Name: "pkcs12_file_name"
        };

        /* CSS Class Name */
        this.cs = {
            subDlgTitle: "kc-dialog-title",
            mainDlgTitle: "kc-dialog-title2",
            dlgClose: "kc-dialog-close",
            btnLayout: "kc-buttons-layout",
            pwBox: "kc-pw-box",
            btnPressed: "kc-rbg-pressed",
            btnNormal: "kc-rbg-normal",
            dropdownMenu: "kc-dropdown-menu",
            dropdownGrp: "kc-dropdown-group",
            icoRemovable: "kc-ico-removable",
            rgbText: "kc-rbg-text",
            certSelectedRow: "kc-tableview-selected-row",
            certTableCell: "kc-tableview-cell",
            fontb: "kc-fontb",
            wrdNormal: "kc-wrd-normal",
            tableView: "kc-tableview",
            p11List: "kc-pkcs11-list",
            mediaList: "kc-medialist",
            fileList: "kc-filelist"
        };

        /* Title Name */
        this.title = {
            cert: "인증서 입력 (전자서명)",
            admin: "인증서 관리"
        };

        /* Strings */
        this.strings = {
            IS_LOADING: "불러오는 중",
            EXPIRED_SESSION: "세션이 만료되었습니다. 다시 접속해주십시오.",
            NOT_INIT: "보안모듈이 실행중이 아닙니다.",
            CONFIRM_INSTALL: "설치페이지로 이동하시겠습니까?",
            CONFIRM_DELETE: "인증서를 삭제할 경우 이 인증서로 암호화된 데이터를 해독할 수 없습니다.\r\n인증서 삭제는 서명용 인증서와 암호화용(키관리용) 인증서 그리고 개인키 모두를 삭제합니다.\r\n만약의 경우를 대비하여 인증서를 백업 후 삭제하시기를 권고해 드립니다.\r\n인증서 및 개인키를 영구히 삭제하시겠습니까?",
            CERT_VAL_SUCCESS: "이 인증서의 전자서명이 올바릅니다.",
            NOT_CONNECTED_PKCS11: "표준보안매체가 올바로 인식되지 않았습니다.\n표준보안매체를 다시 한 번 점검하십시오.",
            NOT_SELECTED_CERT: "인증서가 선택되지 않았습니다.",
            NOT_SELECTED_FILE: "파일이 선택되지 않았습니다.",
            NO_INPUT_PASSWORD: "인증서 비밀번호를 입력해주십시오.",
            CERT_DELETE_SUCCESS: "인증서가 삭제되었습니다.",
            CERT_COPY_SUCCESS: "인증서가 복사 되었습니다.",
            CERT_CHANGE_PASSWORD: "비밀번호가 변경 되었습니다.",
            CERT_EXPORT_SUCCESS: "인증서 내보내기 성공",
            CERT_IMPORT_SUCCESS: "인증서 가져오기 성공",
            NOT_EXIST_DISK: "이동식 디스크가 없습니다."
        };

        /* Error Code */
        var errCode = this.errCode = {
            asn1: {
                INIT_FAILED: [0x1000, "OSS 초기화를 실패하였습니다."],
                INVALID_DATEFORMAT: [0x1001, "날짜 형식이 올바르지 않습니다."],
                EXTRACTRDN_FAILED: [0x1002, "인증서로부터 발급자 DN을 얻어올 수 없습니다."],
                EXTRACTEXTENSION_FAILED: [0x1003, "인증서로부터 확장필드를 얻어올 수 없습니다."],
                INVALID_CONTEXT: [0x1004, "라이브러리가 초기화되지 않았습니다."],
                INVALID_DATA: [0x1005, "입력값이 없거나 올바르지 않습니다."],
                ENC_FAILED: [0x1006,"ASN1 인코딩에 실패하였습니다."],
                DEC_FAILED: [0x1007,"인증서 비밀번호가 올바르지 않습니다."],  // ASN1 디코딩에 실패하였습니다.
                CPY_FAILED: [0x1008,"ASN1 복사에 실패하였습니다."],
                OSSERR_END: [0x1009,"OSS 에러가 발생하였씁니다."]
            },
            common: {
                FILE_OPEN_FAILED: [0x2000, "파일을 여는데 실패하였습니다."],
                FILE_READ_FAILED: [0x2001, "파일을 읽는데 실패하였습니다."],
                FILE_WRITE_FAILED: [0x2002, "파일을 쓰는데 실패하였습니다."],
                FILE_NOT_EXIST: [0x2003, "파일이 존재하지 않습니다."],
                FILE_NOT_CREATE: [0x2004, "파일을 생성할 수 없습니다."],
                MAKEDIR_ERROR: [0x2005, "디렉터리를 생성할 수 없습니다."],
                MEMORY_ALLOC_ERROR: [0x2006, "메모리 할당에 실패하였습니다."],
                INVALID_INPUTDATA: [0x2007, "입력값이 없거나 올바르지 않습니다."],
                //COMMON_LICENSE_TIME_EXPIRE: [0x2008, "라이브러리 사용 기한이 만료되었습니다."],
                BASE64ENC_ERROR: [0x2009, "Base64 인코딩에 실패하였습니다."],
                BASE64DEC_ERROR: [0x200A, "Base64 디코딩에 실패하였습니다."],
                PASSWD_COMBI_ERROR: [0x200B, "패스워드의 문자와 숫자조합이 올바르지 않습니다."],
                PASSWD_SAMENUM_ERRO: [0x200C, "패스워드에 같은 문자가 2자 이상입니다."],
                /*COMMON_LICENSE_NO_FILE: [0x200D, "라이센스 파일이 없습니다."],
                 COMMON_LICENSE_BAD: 0x200E,*/
                FILE_READ_PUBLICKEY_FAILED: [0x200F, "암호화용(키관리용)인증서의 공개키를 읽지 못했습니다."]
            },
            crypto: {
                INVALID_DATA: [0x3000, "입력값이 없거나 올바르지 않습니다."],
                //MEMORY_ERROR: [0x3001, "메모리 할당에 실패하였습니다."],
                KEYGEN_FAILED: [0x3002, "키 생성을 실패하였습니다."],
                KEYPAIRGEN_FAILED: [0x3003, "키쌍 생성을 실패하였습니다."],
                KEYENC_INVALID_MODE: [0x3004, "암호화 모드가 올바르지 않습니다."],
                ENC_INIT_FAILED: [0x3005, "암호화 Init을 실패하였습니다."],
                ENC_UPDATE_FAILED: [0x3006, "암호화 Update를 실패하였습니다."],
                ENC_FINAL_FAILED: [0x3007, "암호화 Final을 실패하였습니다."],
                ENC_UNKNOWN_ALGORITHM: [0x3008, "알 수 없는 암호화 알고리즘 입니다."],
                ENC_UNKNOWN_MODE: [0x3009, "알 수 없는 암호화 모드 입니다."],
                DEC_INIT_FAILED: [0x300A, "복호화 Init을 실패하였습니다."],
                DEC_UPDATE_FAILED: [0x300B, "복호화 Update를 실패하였습니다."],
                DEC_FINAL_FAILED: [0x300C, "복호화 Final을 실패하였습니다."],
                //DEC_UNKNOWN_ALGORITHM: 0x300D,
                //DEC_UNKNOWN_MODE: 0x300E,
                DIGEST_INIT_FAILED: [0x300F, "메시지 다이제스트 Init을 실패하였습니다."],
                DIGEST_UPDATE_FAILED: [0x3010, "메시지 다이제스트 Update를 실패하였습니다."],
                DIGEST_FINAL_FAILED: [0x3011, "메시지 다이제스트 Final을 실패하였습니다."],
                DIGEST_UNKNOWN_ALGORITHM: [0x3012, "알 수 없는 메시지 다이제스트 알고리즘 입니다."],
                MAC_INIT_FAILED: [0x3013, "MAC값 생성 Init을 실패하였습니다."],
                MAC_UPDATE_FAILED: [0x3014, "MAC값 생성 Update를 실패하였습니다."],
                MAC_FINAL_FAILED: [0x3015, "MAC값 생성 Final을 실패하였습니다."],
                MAC_UNKNOWN_ALGORITHM: [0x3016, "알 수 없는 MAC값 생성 알고리즘 입니다."],
                KEYENC_3DESCBC_FAILED: [0x3017, "키를 암호화하는데 실패하였습니다."],
                KEYDEC_3DESCBC_FAILED: [0x3018, "키를 복호화하는데 실패하였습니다."],
                KEYENC_RC2CBC_FAILED: [0x3019, "키를 암호화하는데 실패하였습니다."],
                KEYDEC_RC2CBC_FAILED: [0x301A, "키를 복호화하는데 실패하였습니다."],
                KEYDEC_BAD_KEYLENGTH: [0x301B, "키의 길이가 올바르지 않습니다."],
                PUB_ENC_FAILED: [0x301C, "공개키로 암호화 하는데 실패하였습니다."],
                PUB_DEC_FAILED: [0x301D, "공개키로 복호화 하는데 실패하였습니다."],
                PRI_ENC_FAILED: [0x301E, "비밀키로 암호화 하는데 실패하였습니다."],
                PRI_DEC_FAILED: [0x301F, "비밀키로 복호화 하는데 실패하였습니다."],
                ENCRYPTDATA_FAILED: [0x3020, "메시지에 대한 암호화를 실패했습니다."],
                DECRYPT_DATA_FAILED: [0x3021, "메시지에 대한 복호화를 실패했습니다."],
                GET_SESSIONKEY_FAILED: [0x3022, "세션키를 얻는데 실패했습니다."]
            },
            storage: {
                INVALID_CONTEXT: [0x4000, "라이브러리가 초기화되지 않았습니다."],
                INVALID_INPUTDATA: [0x4001, "입력값이 없거나 올바르지 않습니다."],
                INCORRECT_MEDIA: [0x4002, "매체 선택이 올바르지 않습니다."],
                INCORRECT_DATATYPE: [0x4003, "데이터 종류 선택이 올바르지 않습니다."],
                FILE_REMOVE_FAILED: [0x4004, "파일을 삭제하는데 실패하였습니다."],
                GET_USERINFO_SIGNPRIVKEY: [0x4005, "서명용 개인키를 읽는데 실패하였습니다."],
                GET_USERINFO_ENCPRIVKEY: [0x4006, "암호화용 개인키를 읽는데 실패하였습니다."],
                SET_USERINFO_DN: [0x4007, "사용자 DN 정보를 저장하는데 실패하였습니다."],
                SET_USERINFO_SIGNPRIVKEY: [0x4008, "서명용 개인키를 저장하는데 실패하였습니다."],
                SET_USERINFO_ENCPRIVKEY: [0x4009, "암호화용 개인키를 저장하는데 실패하였습니다."],
                GET_CERTINFO_SIGNCERT: [0x400A, "서명용 인증서를 읽는데 실패하였습니다."],
                GET_CERTINFO_ENCCERT: [0x400B, "암호화용 인증서를 읽는데 실패하였습니다."],
                GET_CERTINFO_CAPUBS: [0x400C, "인증경로를 읽는데 실패하였습니다."],
                SET_CERTINFO_SIGNCERT: [0x400D, "서명용 인증서 저장에 실패하였습니다."],
                SET_CERTINFO_ENCCERT: [0x400E, "암호화용 인증서 저장에 실패하였습니다."],
                SET_CERTINFO_CAPUBS: [0x400F, "인증경로를 저장하는데 실패하였습니다."],
                GET_COMMONINFO: [0x4010, "환경설정 정보를 가져오는데 실패하였습니다."],
                SET_COMMONINFO: [0x4011, "환경설정 정보를 저장하는데 실패하였습니다."],
                SET_REGISTRY: [0x4012, "레지스트리 값설정에 실패하였습니다."]
                /*INVALID_SC_PIN: 0x4013,
                 INVALID_SC_CONTEXT: 0x4014,
                 EXPIRED_SC_PIN: 0x4015,
                 SC_FAIL: 0x4016,
                 INVALID_USB_PIN: 0x4017,
                 INVALID_CRYPTOKI_PIN: 0x4018*/
            },
            validity: {
                INVALID_CONTEXT: [0x5000, "라이브러리가 초기화되지 않았습니다."],
                INVALID_INPUTDATA: [0x5001, "입력값이 없거나 올바르지 않습니다."],
                INVALID_CERTFORMAT: [0x5002, "인증서 형식이 올바르지 않습니다."],
                CERT_ENCODE_FAILED: [0x5003, "인증서 인코딩을 실패하였습니다."],
                CRL_ENCODE_FAILED: [0x5004, "인증서 폐지목록 인코딩을 실패하였습니다."],
                NOTEXIST_DP: [0x5005, "CRL 배포지점 정보가 없는 인증서입니다."],
                GET_DP_FAILED: [0x5006, "CRL 배포지점 정보를 가져오는데 실패하였습니다."],
                CERT_TIMEOUT: [0x5007, "인증서의 유효기간이 만료되었습니다."],
                CERT_SIGNATURE_ERROR: [0x5008, "인증서의 발급자 서명 검증에 실패했습니다."],
                CRL_SIGNATURE_ERROR: [0x5009, "인증서 폐지목록의 발급자 서명 검증에 실패했습니다."],
                CERT_REVOKED: [0x500A, "인증서가 폐지되었습니다."],
                INVALID_NAMECHAIN: [0x500B, "인증서 경로의 발급자, 피발급자 이름 체인이 잘못되었습니다."],
                NOTEXIST_POLICYCONSTRAINTSEX: [0x500C, "인증서 정책 제한 확장이 존재하지 않습니다."],
                POLICY_INCOMPATIBLE_WITHIPS: [0x500D, "인증서 정책이 초기 인증서 정책과 부합되지 않습니다."],
                POLICY_INCOMPATIBLE_WITHAPS: [0x500E, "정책이 허용가능 정책 집합에 부합되지 않습니다."],
                NOTEXIST_BASICCONSTRAINTEXT: [0x500F, "발급자 인증서에 기본 제한 확장이 없습니다."],
                NOT_CACERT: [0x5010, "발급자 인증서가 아닙니다."],
                CAPATHLEN_ERROR: [0x5011, "발급자 인증경로 길이 제약에 어긋납니다."],
                EKU_INCOMPATIBLE_WITHKU: [0x5012, "확장 키사용 용도와 키사용 용도가 일치하지 않습니다."],
                IPS_INCOMPATIBLE_WITHAPS: [0x5013, "허용가능 정책과 초기 정책이 부합되지 않습니다."],
                INCONSISTENT_WITHCS: [0x5014, "주체 이름과 주체대체이름 확장이 CS와 부합되지 않습니다."],
                INCONSISTENT_WITHES: [0x5015, "주체 이름과 주체대에이름 확장이 ES와 부합되지 않습니다."],
                NAME_ADJUST_ERROR: [0x5016, "인코딩된 이름 제약(Naming Constraint) 확장이 적합하지 않습니다."],
                KEYUSAGE_ERROR: [0x5017, "인증서의 키용도가 입력된 키용도와 부합되지 않습니다."],
                SIGNATURE_MISMATCHED: [0x5018, "서명값이 일치하지 않습니다."],
                NOTEXIST_CERTCRLLIST: [0x5019, "인증서/폐지목록 리스트의 입력이 없습니다."],
                INVALID_CRLFORMAT: [0x501A, "인증서 폐지목록 형식이 올바르지 않습니다."],
                CRL_TIMEOUT: [0x501B, "인증서 폐지목록의 유효 기간이 만료되었습니다."],
                ARL_TIMEOUT: [0x501C, "인증기관 인증서 폐지목록의 유효 기간이 만료 되었습니다."],
                GET_VALIDCRL_FAILED: [0x501D, "유효한 인증서 폐지목록이 존재하지 않습니다."],
                GET_CADSINFO_FAILED: [0x501E, "발급자 인증서의 디렉토리 서버 정보가 없습니다."],
                GET_DSINFO_FAILED: [0x501F, "디렉토리 서버 정보가 없습니다."],
                DS_NOTCONNECTED: [0x5020, "디렉토리 서버에 연결할 수 없습니다."],
                DS_NO_CERT: [0x5021, "디렉토리 서버에서 인증서를 검색할 수 없습니다."],
                DS_NO_ISSUERCERT: [0x5022, "디렉토리 서버에서 발급자 인증서를 검색할 수 없습니다."],
                DS_NO_CERTATTRIBUTE: [0x5023, "디렉토리 서버의 DN 엔트리에 인증서가 아직 올라가지 않았습니다."],
                DS_NO_ISSUERCERTATTRIBUTE: [0x5024, "디렉토리 서버의 DN 엔트리에 발급자 인증서가 아직 올라가지 않았습니다."],
                DS_NO_VALIDCERT: [0x5025, "디렉토리 서버에서 유효한 인증서를 검색할 수 없습니다."],
                DS_NO_VALIDISSUERCERT: [0x5026, "디렉토리 서버에서 유효한 발급자 인증서를 검색할 수 없습니다."],
                DS_NO_MATCHKEYUSAGE_CERT: [0x5027, "디렉토리 서버에서 키사용 용도에 맞는 인증서를 검색할 수 없습니다."],
                CTL_INVALID: [0x5028, "인증서 신뢰목록 형식이 올바르지 않습니다."],
                CTL_TIMEOUT: [0x5029, "인증서 신뢰목록의 유효기간이 시간이 올바르지 않습니다."],
                DS_NO_CTL: [0x502A, "디렉토리 서버에서 유효한 인증서 신뢰목록(CTL)을 검색하는데 실패하였습니다."],
                DS_NO_CTL_ATTRIBUTE: [0x502B, "디렉토리 서버에서 검색한 엔트리에 아직 인증서 신뢰목록(CTL) 필드가 올라가지 않습니다."],
                HASH_FAILED: [0x502C, "해쉬값 생성을 실패하였습니다."],
                NOTSET_INITIALPOLICY: [0x502D, "초기 허용 정책 설정이 없습니다."],
                UPDATECRL_FAILED: [0x502E, "인증서 폐기목록 갱신에 실패했습니다."],
                GENCAPUBS_NOTEXISTISSUER: [0x502F, "인증경로 생성에 필요한 발급자 인증서가 없습니다."],
                NOTEXIST_OIDDSMAPLIST: [0x5030, "환경 설정에 OID DS MAP 정보가 없습니다."],
                ROOT_CERT_INVALID: [0x5031, "인증서의 유효성 검증을 실패하였습니다. 신뢰된 최상위인증기관 인증서가 아닙니다."],
                CRITICAL_ALLCHECK_FAILED: [0x5032, "Critical 확장을 모두 검사하지 못하였습니다."],
                CERT_REVOKED_HOLD: [0x5033, "인증서가 효력정지 되었습니다."],
                CERT_REVOKED_KEYCOMPROMISE: [0x5034, "인증서가 개인키 신뢰 손상으로 폐지되었습니다."],
                CERT_REVOKED_AFFCHANGED: [0x5035, "인증서가 소속이나 이름 변경으로 폐지되었습니다."],
                CERT_REVOKED_CESSATIONOFOPER: [0x5036, "인증서가 사용 해지로 폐지되었습니다."],
                NO_CRL: [0x5037, "디렉토리 서버에 조건에 맞는 인증서 폐지목록(CRL)이 없습니다."],
                NO_ARL: [0x5038, "디렉토리 서버에 조건에 맞는 인증서 폐지목록(ARL)이 없습니다."],
                NO_VALID_CRL: [0x5039, "디렉토리 서버에서 유효한 인증서 폐지목록(CRL)을 검색하는데 실패하였습니다."],
                NO_VALID_ARL: [0x503A, "디렉토리 서버에서 유효한 인증서 폐지목록(ARL)을 검색하는데 실패하였습니다."],
                NO_CRL_ATTRIBUTE: [0x503B, "디렉토리 서버에서 검색한 엔트리에 아직 인증서 폐지목록(CRL) 필드가 올라가지 않습니다."],
                NO_ARL_ATTRIBUTE: [0x503C, "디렉토리 서버에서 검색한 엔트리에 아직 인증서 폐지목록(ARL) 필드가 올라가지 않습니다."],
                NO_EMAIL_ENTRY: [0x503D, "디렉토리 서버에 mail 엔트리가 존재하지 않습니다."],
                NO_CN_ENTRY: [0x503E, "디렉토리 서버에 cn 엔트리가 존재하지 않습니다."],
                INCORRECT_DN: [0x503F, "DN 형식이 올바르지 않습니다."],
                INCORRECT_DSTYPE: [0x5040, "디렉토리 서버 종류가 올바르지 않습니다."],
                OCSP_NOINPUT_ISSUERCERT: [0x5041, "발급자 인증서가 없습니다."],
                OCSP_NOTEXIST_SERVERINFO: [0x5042, "서버 정보가 없습니다."],
                OCSP_NOINPUT_GENSIGNINFO: [0x5043, "인증서 상태검증 요청 메시지를 서명할 인증서/비밀키 입력이 없습니다."],
                OCSP_NONCEERROR: [0x5044, "Nonce 값이 확인되지 않습니다."],
                OCSP_INVALID_SERIALNUM: [0x5045, "요청 메시지와 응답 메시지의 인증서 일련번호가 일치하지 않습니다."],
                OCSP_INVALID_RESPONSETYPE: [0x5046, "응답 메시지 형식이 올바르지 않습니다."],
                OCSP_VERSION_ERROR: [0x5047, "응답 메시지의 메시지 버전이 지원되지 않습니다."],
                OCSP_MALFORMED_REQUEST: [0x5048, "잘못된 요청 메시지 입니다."],
                OCSP_INTERNAL_ERROR: [0x5049, "서버 내부 에러로 작업을 진행할 수 없습니다."],
                OCSP_TRY_LATER: [0x504A, "서버 내부 에러로 작업을 진행할 수 없습니다."],
                OCSP_SIG_REQUIRED: [0x504B, "요청 메시지의 서명값을 검증할 수 없습니다."],
                OCSP_UNAUTHORIZED: [0x504C, "신뢰할 수 없는 사용자 입니다."],
                OCSP_FAILED: [0x504D, "상태 검증에 실패하였습니다."],
                OCSP_UNKNOWN_CHOSEN: [0x504E, "상태 검증에 실패하였습니다."],
                OCSP_NOINPUT_REQCERT: [0x504F, "요청 인증서가 없습니다."],
                OCSP_NO_AIAVALUE: [0x5050, "AIA 필드 값이 없습니다."],
                OCSP_EXIST_AIAVALUE: [0x5051, "AIA 필드 값이 있습니다."],
                OCSP_FAIL_CONFIG_ENVIRONMENT: [0x5052, "환경 설정 파일 읽을 수 없습니다."],
                OCSP_STATUS_GOOD: [0x5053, "인증서 상태는 유효합니다."],
                OCSP_STATUS_REVOKED: [0x5054, "인증서가 폐지 되었습니다."],
                OCSP_STATUS_UNKNOWN: [0x5055, "인증서 상태를 알 수 없습니다."],
                OCSP_SAMERESSRVRADDR: [0x5056, "요청 서버와 응답 서버가 동일합니다."],
                NOTEXIST_OCSPSVRLIST: [0x5057, "환경 설정에 OCSP 서버정보 리스트 설정이 없습니다."],
                NOTEXIST_TRUSTED_ROOTCA: [0x5058, "신뢰된 최상위 인증기관 인증서가 없습니다."],
                INVALIDFORMAT_TRUSTED_ROOTCA: [0x5059, "신뢰된 최상위 인증기관 인증서 형식이 올바르지 않습니다."],
                NO_AKI: [0x505A, "인증서의 AKI 필드가 없습니다."],
                NO_AKI_KI: [0x505B, "인증서의 AKI 필드에 KeyIdentifier가 없습니다."],
                NO_AKI_ACI: [0x505C, "인증서의 AKI 필드에 authorityCertIssuer가 없습니다."],
                NO_AKI_ACSN: [0x505D, "인증서의 AKI 필드에 authorityCertSerialNumber가 없습니다."],
                AKI_COMPARE_FAIL: [0x505E, "상위 인증서와 AKI 필드값 비교에 실패하였습니다."],
                CERT_REVOKED_HOLD_CA: [0x505F, "발급자 인증서가 효력정지 되었습니다."],
                CERT_REVOKED_KEYCOMPROMISE_CA: [0x5060, "발급자 인증서가 개인키 신뢰 손상으로 폐지되었습니다."],
                CERT_REVOKED_AFFCHANGED_CA: [0x5051, "발급자 인증서가 소속이나 이름 변경으로 폐지되었습니다."],
                CERT_REVOKED_CESSATIONOFOPER_CA: [0x5052, "발급자 인증서가 사용 해지로 폐지되었습니다."],
                CERT_REVOKED_CACOMPROMISE_CA: [0x5053, "발급자 인증서의 발급자 인증서의 전자서명키가 손상으로 폐지되었습니다."],
                CERT_REVOKED_SUPERSEDED_CA: [0x5054, "발급자 인증서의 키 손상없이 인증서가 폐지되었습니다."],
                CERT_REVOKED_UNSPECIFIED_CA: [0x5055, "발급자 인증서가 특별한 폐지사유 없이 폐지되었습니다."],
                CERT_REVOKED_REMOVEFROMCRL_CA: [0x5056, "발급자 인증서가 Delta CRL에서 제거 되었습니다."],
                CERT_REVOKED_CA: [0x5057, "발급자인증서가 폐지되었습니다."],
                CERT_REVOKED_CACOMPROMISE: [0x5058, "발급자 인증서의 전자서명키가 손상으로 폐지되었습니다."],
                CERT_REVOKED_SUPERSEDED: [0x5059, "키 손상없이 인증서가 폐지되었습니다."],
                CERT_REVOKED_UNSPECIFIED: [0x505A, "인증서가 특별한 폐지사유 없이 폐지되었습니다."],
                CERT_REVOKED_REMOVEFROMCRL: [0x505B, "인증서가 Delta CRL에서 제거 되었습니다."],
                KEYUSAGE_NOT_EXIST: [0x505C, "인증서의 KEYUSAGE 확장 필드가 존재하지 않습니다."],
                KEYUSAGE_NOT_EXIST_CA: [0x505D, "발급자 인증서의 KEYUSAGE 확장 필드가 존재하지 않습니다."],
                CRYPTOKI_FAIL_CONFIG_ENVIRONMENT: [0x505E, "환경 설정 파일 읽을 수 없습니다."],
                KCE_CV_CERT_REVOKED_SUPERSEDED: [0x5069, "키 손상없이 인증서가 폐지되었습니다."]
            },
            pkcs: {
                INVALID_CONTEXT: [0x6000, "라이브러리가 초기화되지 않았습니다."],
                INVALID_INPUTDATA: [0x6001, "입력값이 없거나 올바르지 않습니다."],
                INVALID_CAPUBSFORMAT: [0x6002, "인증서 경로 형식이 올바르지 않습니다."],
                INCORRECT_HASHALGORITHM: [0x6003, "해쉬 알고리즘 선택이 올바르지 않습니다."],
                INCORRECT_ALGOID: [0x6004, "정의되지 않은 알고리즘입니다."],
                TOOLONG_KEYSIZE: [0x6005, "키의 길이가 올바르지 않습니다."],
                HASH_FAILED: [0x6006, "해쉬값 생성을 실패하였습니다."],
                PBE_ENC_FAILED: [0x6007, "비밀키를 암호화하는데 실패하였습니다."],
                PBE_DEC_FAILED: [0x6008, "인증서 비밀번호가 올바르지 않습니다."],//"비밀키를 복호화하는데 실패하였습니다."],
                GEN_PKCS12BAGATTR_FAILED: [0x6009, "PKCS12 속성을 생성하는데 실패하였습니다."],
                VERIFY_PKCS12MAC_FAILED: [0x600B, "PKCS12 MAC값 검증을 실패하였습니다."],
                GEN_PKCS12MAC_FAILED: [0x600A, "PKCS12 MAC값을 생성하는데 실패하였습니다."],
                INCORRECT_CMSTYPE: [0x600C, "메시지 형식이 올바르지 않습니다."],
                UNKNOWN_CMSTYPE: [0x600D, "메시지 형식이 지원되지 않습니다."],
                INVALID_CAPUBS: [0x600E, "인증경로 입력이 없습니다."],
                NOTEXIST_SIGNERINFO: [0x600F, "서명 데이터에 서명자 정보가 없습니다."],
                NOINPUT_SIGNERCERT: [0x6010, "서명 검증을 위한 서명자의 인증서 입력이 없습니다."],
                NOINPUT_SIGNORIMSG: [0x6011, "서명 검증을 위한 원본 메시지 입력이 없습니다."],
                NOINPUT_DIGESTORIMSG: [0x6012, "메시지 축약(다이제스트) 검증을 위한 원본 메시지 입력이 없습니다."],
                NOTEXIST_DIGESTVALUE: [0x6013, "메시지 축약(다이제스트) 데이터에 축약 데이터(다이제스트)가 포함되어 있지 않습니다."],
                DIGESTVALUE_MISMATCHED: [0x6014, "메시지 축약(다이제스트)이 일치하지 않습니다."],
                NOTEXIST_DIGESTCONTENTS: [0x6015, "메시지 축약(다이제스트) 데이터에 원문 메시지가 포함되어 있지 않습니다."],
                GEN_MAC_FAILED: [0x6016, "MAC 값을 생성하는데 실패하였습니다."],
                VERIFY_MAC_FAILED: [0x6017, "MAC 값 검증을 실패하였습니다."],
                NOINPUT_AUTHORIMSG: [0x6018, "메시지 인증(MAC) 검증을 위한 원본 메시지 입력이 없습니다."],
                NOTEXIST_AUTHVALUE: [0x6019, "메시지 인증(MAC) 데이터에 메시지 인증(MAC)이 포함되어 있지 않습니다."],
                NOTEXIST_CONTENTS: [0x601A, "서명 데이터에 원문이 포함 되어있지 않습니다."],
                NOTEXIST_SIGNERCERT: [0x601B, "서명 데이터에 서명자의 인증서가 포함 되어있지 않습니다."],
                NOTEXIST_RECIPIENTINFO: [0x601C, "암호화 데이터에 수신자 정보가 포함 되어있지 않습니다."],
                INVALID_VERSION: [0x601D, "버전이 올바르지 않습니다."],
                INVALID_PASSWORD_EXCESS: [0x601E, "비밀번호 오류 횟수를 초과하였습니다. 브라우저 종료 후 일정시간 이후 다시 접속해주시길 바랍니다."]
            },
            cert: {
                INVALID_CONTEXT: [0x7000, "라이브러리가 초기화되지 않았습니다."],
                INVALID_INPUTDATA: [0x7001, "입력값이 없거나 올바르지 않습니다."],
                INCORRECT_CERTTYPE: [0x7002, "인증서 종류 선택이 올바르지 않습니다."],
                INCORRECT_KEYTYPE: [0x7003, "비밀키 종류 선택이 올바르지 않습니다."],
                READ_PRIVKEY_FAILED: [0x7004, "비밀키를 읽는데 실패했습니다."],
                WRITE_PRIVKEY_FAILED: [0x7005, "비밀키를 저장하는데 실패했습니다."],
                READ_CERT_FAILED: [0x7006, "인증서를 읽어오는데 실패하였습니다."],
                WRITE_CERT_FAILED: [0x7007, "인증서를 저장하는데 실패하였습니다."],
                WRITE_CERTPATH_FAILED: [0x7008, "인증서 경로를 저장하는데 실패하였습니다."],
                INCORRECT_MEDIA: [0x7009, "매체 선택이 올바르지 않습니다."],
                NOTEXIST_SET_CALIST: [0x700A, "환경 설정에 인증기관 리스트 설정이 없습니다."],
                NOTEXIST_SET_MEDIALIST: [0x700B, "환경 설정에 매체 리스트 설정이 없습니다."],
                NOTEXIST_MEDIAINFO: [0x700C, "매체 정보 설정이 없습니다."],
                NOTEXIST_CERTCRLLIST: [0x700D, "인증서/폐지목록 리스트의 입력이 없습니다."],
                NOTEXIST_DSINFO: [0x700E, "인증서를 검색하기 위한 디렉토리 서버 정보가 없습니다."],
                NOTEXIST_ROOTCA_INCAPUBS: [0x700F, "인증 경로에 최상위 인증기관 인증서가 포함되어 있지 않습니다."],
                NO_RANDOM_VALUE: [0x7010, "인증서(개인키)에 신원확인 정보가 없습니다."],
                VID_MISMATCHED: [0x7011, "신원확인 정보가 일치하지 않습니다."],
                OCSP_CONF_ERROR: [0x7012, "환경설 파일(OCSP.conf)이 없습니다."],
                KCASE_CONF_ERROR: [0x7013, "환경설정파일(AxKCASE.ini)이 없습니다."],
                EXCEED_FILE_SIZE: [0x7014, "허용가능한 용량을 초과하였습니다"]
            },
            agent: {
                INIT_CONTEXT_ERROR: [0x8000, "KCASE Context 초기화에 실패했습니다."],
                INPUT_UNKNOWN_FLAG: [0x8001, "옵션 FLAG 값이 올바르지 않습니다."],
                INPUT_DATA_ERROR: [0x8002, "입력값이 올바르지 않습니다."],
                INPUT_PW_ERROR: [0x8003, "인증서 패스워드 입력값이 올바르지 않습니다."],
                INPUT_DN_ERROR: [0x8004, "인증서 DN 입력값이 올바르지 않습니다."],
                INPUT_IDN_ERROR: [0x8005, "개인 식별번호 입력값이 올바르지 않습니다."],
                INPUT_CERTTYPE_ERROR: [0x8006, "인증서 타입이 올바르지 않습니다."],
                GET_CERT_ERROR: [0x8007, "인증서를 읽어오는데 실패했습니다."],
                GET_KEY_ERROR: [0x8008, "개인키를 읽어오는데 실패했습니다."],
                INPUT_SIGNDN_ERROR: [0x8009, "서명용 인증서 DN 입력값이 올바르지 않습니다."],
                INPUT_SIGNPW_ERROR: [0x800A, "서명용 인증서 비밀번호 입력값이 올바르지 않습니다."],
                INPUT_SIGNTYPE_ERROR: [0x800B, "서명 옵션(파일/문자열)이 올바르지 않습니다."],
                INPUT_SIGN_FILE_ERROR: [0x800C, "서명할 파일명이 올바르지 않습니다."],
                INPUT_SIGN_DATA_ERROR: [0x800D, "서명할 데이터(길이)가 올바르지 않습니다."],
                INPUT_VERIFY_FILE_ERROR: [0x800E, "검증할 파일명이 올바르지 않습니다."],
                INPUT_VERIFY_DATA_ERROR: [0x800F, "검증할 데이터(길이)가 올바르지 않습니다."],
                GET_SIGNER_CERT_ERROR: [0x8010, "서명 문서에서 서명자 인증서를 가져오는데 실패했습니다."],
                INPUT_ENCDN_ERROR: [0x8011, "암호화용(키관리용) 인증서 DN 입력값이 올바르지 않습니다."],
                INPUT_ENC_FILE_ERROR: [0x8012, "암호화할 파일명이 올바르지 않습니다."],
                INPUT_ENC_DATA_ERROR: [0x8013, "암호화할 데이터(길이)가 올바르지 않습니다."],
                INPUT_ENCTYPE_ERROR: [0x8014, "암호 옵션(파일/문자열)이 올바르지 않습니다."],
                INPUT_ENCPW_ERROR: [0x8015, "암호화용(키관리용) 인증서 비밀번호 입력값이 올바르지 않습니다."],
                INPUT_ENCDATA_ERROR: [0x8016, "복호화할 데이터의 입력값이 올바르지 않습니다."],
                INPUT_DEC_FILE_ERROR: [0x8017, "복호화할 파일명이 올바르지 않습니다."],
                INPUT_DEC_DATA_ERROR: [0x8018, "복호화할 데이터가 올바르지 않습니다."],
                INPUT_DECTYPE_ERROR: [0x8019, "복호화 옵션(파일/문자열)이 올바르지 않습니다."],
                CONFIG_PKITYPE_ERROR: [0x801A, "PKI Type 정보가 올바르지 않습니다."],
                CONFIG_ENCPRI_ALGO_ERROR: [0x801B, "개인키 암호 알고리즘 정보가 올바르지 않습니다."],
                HASH_DIFF_ERROR: [0x801C, "KCaseAgent 해시값이 일치하지 않습니다."],
                VERSION_DIFF_ERROR: [0x801D, "KCaseAgent 버전이 일치하지 않습니다."],
                NO_REMOVABLEDISK: [0x801E, "이동식 디스크가 존재하지 않습니다."],
                MOBILECERT_CANCEL: [0x8020, "휴대폰 인증서 서비스 진행을 취소하였습니다."],
                UNINITIALIZED_KEY: [0x8022, "키와 IV가 초기화되지 않았습니다."],
                NO_INSTALL: [0x8023, "KCaseAgent가 설치되어 있지 않습니다."],
                NOT_ESTABLISH_SECURITY_CHANNEL: [0x8024, "채널 보안이 형성되지 않았습니다"]
            },
            pkcs11: {
                DEVICE_ERROR: [0x9000, "보안토큰 매체에 알수 없는 문제점이 발생했습니다"],
                DEVICE_REMOVED: [0x9001, "보안토큰이 실행 도중 제거 되었습니다"],
                TOKEN_NOT_PRESENT: [0x9002, "보안토큰이 존재하지 않습니다"],
                NOT_INITIALIZED: [0x9003, "보안토큰이 초기화 되지 않았습니다"],
                KEY_HANDLE_INVALID: [0x9004, "보안토큰 키 핸들이 맞지 않습니다."],
                OBJECT_HANDLE_INVALID: [0x9005, "지정된 오브젝트 핸들이 맞지 않습니다."],
                PIN_INCORRECT: [0x9006, "핀번호가 맞지 않습니다"],
                PIN_LEN_RANGE: [0x9007, "보안토큰에서 지원하는 핀길이보다 길거나 짧습니다."],
                PIN_LOCKED: [0x9008, "핀번호 오류로 인하여 보안토큰이 잠겼습니다."],
                SESSION_NOT_SUPPORT: [0x9009, "보안토큰 세션이 올바르지 않습니다"],
                USER_NOT_LOGGED_IN: [0x900A, "보안토큰에 로그인 되지 않았습니다"]
            },
            pkimgr: {
                ISSUE_SERVER: [0xA001, ""],
                FILE_PERMISSION: [0xA002, "파일의 권한 또는 숨김여부 등으로 인하여 작업을 수행 할 수가 없습니다.\n해당파일의 권한을 확인하여 주시기 바랍니다.\n파일위치 : "],
                PASSOWRD_COMPLEXITY: [0xA003, "입력한 인증서 패스워드가 복잡도 권장사항에 부합되지 않습니다."],
                RENEW_ERROR: [0xA004, "인증서 갱신(또는 키갱신)에 실패하였습니다.\n다음 파일이 누락되었습니다. : "],
                SUSPENSION_ERROR: [0xA005, "인증서 효력정지에 실패하였습니다.\n다음 파일이 누락되었습니다. : "],
                ABOLITION_ERROR: [0xA006, "인증서 폐지에 실패하였습니다.\n다음 파일이 누락되었습니다. : "],
                PRIKEY_ERROR: [0xB01F, "개인키 파일이 손상되었습니다."]
            }
        };

        var errTable = {};

        /* asn1 */
        errTable[errCode.asn1.INIT_FAILED[0]] =  errCode.asn1.INIT_FAILED[1];
        errTable[errCode.asn1.INVALID_DATEFORMAT[0]] =  errCode.asn1.INVALID_DATEFORMAT[1];
        errTable[errCode.asn1.EXTRACTRDN_FAILED[0]] =  errCode.asn1.EXTRACTRDN_FAILED[1];
        errTable[errCode.asn1.EXTRACTEXTENSION_FAILED[0]] =  errCode.asn1.EXTRACTEXTENSION_FAILED[1];
        errTable[errCode.asn1.INVALID_CONTEXT[0]] =  errCode.asn1.INVALID_CONTEXT[1];
        errTable[errCode.asn1.INVALID_DATA[0]] =  errCode.asn1.INVALID_DATA[1];
        errTable[errCode.asn1.ENC_FAILED[0]] = errCode.asn1.ENC_FAILED[1];
        errTable[errCode.asn1.DEC_FAILED[0]] = errCode.asn1.DEC_FAILED[1];
        errTable[errCode.asn1.CPY_FAILED[0]] = errCode.asn1.CPY_FAILED[1];
        errTable[errCode.asn1.OSSERR_END[0]] = errCode.asn1.OSSERR_END[1];

        /* common */
        errTable[errCode.common.FILE_OPEN_FAILED[0]] = errCode.common.FILE_OPEN_FAILED[1];
        errTable[errCode.common.FILE_READ_FAILED[0]] = errCode.common.FILE_READ_FAILED[1];
        errTable[errCode.common.FILE_WRITE_FAILED[0]] = errCode.common.FILE_WRITE_FAILED[1];
        errTable[errCode.common.FILE_NOT_EXIST[0]] = errCode.common.FILE_NOT_EXIST[1];
        errTable[errCode.common.FILE_NOT_CREATE[0]] = errCode.common.FILE_NOT_CREATE[1];
        errTable[errCode.common.MAKEDIR_ERROR[0]] = errCode.common.MAKEDIR_ERROR[1];
        errTable[errCode.common.MEMORY_ALLOC_ERROR[0]] = errCode.common.MEMORY_ALLOC_ERROR[1];
        errTable[errCode.common.INVALID_INPUTDATA[0]] = errCode.common.INVALID_INPUTDATA[1];
        //errTable[errCode.common.LICENSE_TIME_EXPIRED[0]] = errCode.common.LICENSE_TIME_EXPIRED[1];
        errTable[errCode.common.BASE64ENC_ERROR[0]] = errCode.common.BASE64ENC_ERROR[1];
        errTable[errCode.common.BASE64DEC_ERROR[0]] = errCode.common.BASE64DEC_ERROR[1];
        errTable[errCode.common.PASSWD_COMBI_ERROR[0]] = errCode.common.PASSWD_COMBI_ERROR[1];
        //errTable[errCode.common.PASSWD_SAMENUM_ERROR[0]] = errCode.common.PASSWD_SAMENUM_ERROR[1];
        //errTable[errCode.common.LICENSE_NO_FILE[0]] = errCode.common.LICENSE_NO_FILE[1];

        /* crypto */
        errTable[errCode.crypto.INVALID_DATA[0]] = errCode.crypto.INVALID_DATA[1];
        //errTable[errCode.crypto.MEMORY_ERROR[0]] = errTable[errCode.crypto.MEMORY_ERROR[1]];
        errTable[errCode.crypto.KEYGEN_FAILED[0]] = errCode.crypto.KEYGEN_FAILED[1];
        errTable[errCode.crypto.KEYPAIRGEN_FAILED[0]] = errCode.crypto.KEYPAIRGEN_FAILED[1];
        errTable[errCode.crypto.KEYENC_INVALID_MODE[0]] = errCode.crypto.KEYENC_INVALID_MODE[1];
        errTable[errCode.crypto.ENC_INIT_FAILED[0]] = errCode.crypto.ENC_INIT_FAILED[1];
        errTable[errCode.crypto.ENC_UPDATE_FAILED[0]] = errCode.crypto.ENC_UPDATE_FAILED[1];
        errTable[errCode.crypto.ENC_FINAL_FAILED[0]] = errCode.crypto.ENC_FINAL_FAILED[1];
        errTable[errCode.crypto.ENC_UNKNOWN_ALGORITHM[0]] = errCode.crypto.ENC_UNKNOWN_ALGORITHM[1];
        errTable[errCode.crypto.ENC_UNKNOWN_MODE[0]] = errCode.crypto.ENC_UNKNOWN_MODE[1];
        errTable[errCode.crypto.DEC_INIT_FAILED[0]] = errCode.crypto.DEC_INIT_FAILED[1];
        errTable[errCode.crypto.DEC_UPDATE_FAILED[0]] = errCode.crypto.DEC_UPDATE_FAILED[1];
        errTable[errCode.crypto.DEC_FINAL_FAILED[0]] = errCode.crypto.DEC_FINAL_FAILED[1];
        //errTable[errCode.crypto.DEC_UNKNOWN_ALGORITHM[0]] = errTable[errCode.crypto.DEC_UNKNOWN_ALGORITHM[1]];
        //errTable[errCode.crypto.DEC_UNKNOWN_MODE[0]] = errTable[errCode.crypto.DEC_UNKNOWN_MODE[1]];
        errTable[errCode.crypto.DIGEST_INIT_FAILED[0]] = errCode.crypto.DIGEST_INIT_FAILED[1];
        errTable[errCode.crypto.DIGEST_UPDATE_FAILED[0]] = errCode.crypto.DIGEST_UPDATE_FAILED[1];
        errTable[errCode.crypto.DIGEST_FINAL_FAILED[0]] = errCode.crypto.DIGEST_FINAL_FAILED[1];
        errTable[errCode.crypto.DIGEST_UNKNOWN_ALGORITHM[0]] = errCode.crypto.DIGEST_UNKNOWN_ALGORITHM[1];
        errTable[errCode.crypto.MAC_INIT_FAILED[0]] = errCode.crypto.MAC_INIT_FAILED[1];
        errTable[errCode.crypto.MAC_UPDATE_FAILED[0]] = errCode.crypto.MAC_UPDATE_FAILED[1];
        errTable[errCode.crypto.MAC_FINAL_FAILED[0]] = errCode.crypto.MAC_FINAL_FAILED[1];
        errTable[errCode.crypto.MAC_UNKNOWN_ALGORITHM[0]] = errCode.crypto.MAC_UNKNOWN_ALGORITHM[1];
        errTable[errCode.crypto.KEYENC_3DESCBC_FAILED[0]] = errCode.crypto.KEYENC_3DESCBC_FAILED[1];
        errTable[errCode.crypto.KEYDEC_3DESCBC_FAILED[0]] = errCode.crypto.KEYDEC_3DESCBC_FAILED[1];
        errTable[errCode.crypto.KEYENC_RC2CBC_FAILED[0]] = errCode.crypto.KEYENC_RC2CBC_FAILED[1];
        errTable[errCode.crypto.KEYDEC_RC2CBC_FAILED[0]] = errCode.crypto.KEYDEC_RC2CBC_FAILED[1];
        errTable[errCode.crypto.KEYDEC_BAD_KEYLENGTH[0]] = errCode.crypto.KEYDEC_BAD_KEYLENGTH[1];
        errTable[errCode.crypto.PUB_ENC_FAILED[0]] = errCode.crypto.PUB_ENC_FAILED[1];
        errTable[errCode.crypto.PUB_DEC_FAILED[0]] = errCode.crypto.PUB_DEC_FAILED[1];
        errTable[errCode.crypto.PRI_ENC_FAILED[0]] = errCode.crypto.PRI_ENC_FAILED[1];
        errTable[errCode.crypto.PRI_DEC_FAILED[0]] = errCode.crypto.PRI_DEC_FAILED[1];
        errTable[errCode.crypto.ENCRYPTDATA_FAILED[0]] = errCode.crypto.ENCRYPTDATA_FAILED[1];
        errTable[errCode.crypto.DECRYPT_DATA_FAILED[0]] = errCode.crypto.DECRYPT_DATA_FAILED[1];
        errTable[errCode.crypto.GET_SESSIONKEY_FAILED[0]] = errCode.crypto.GET_SESSIONKEY_FAILED[1];

        /* storage */
        errTable[errCode.storage.INVALID_CONTEXT[0]] = errCode.storage.INVALID_CONTEXT[1];
        errTable[errCode.storage.INVALID_INPUTDATA[0]] = errCode.storage.INVALID_INPUTDATA[1];
        errTable[errCode.storage.INCORRECT_MEDIA[0]] = errCode.storage.INCORRECT_MEDIA[1];
        errTable[errCode.storage.INCORRECT_DATATYPE[0]] = errCode.storage.INCORRECT_DATATYPE[1];
        errTable[errCode.storage.FILE_REMOVE_FAILED[0]] = errCode.storage.FILE_REMOVE_FAILED[1];
        errTable[errCode.storage.GET_USERINFO_SIGNPRIVKEY[0]] = errCode.storage.GET_USERINFO_SIGNPRIVKEY[1];
        errTable[errCode.storage.GET_USERINFO_ENCPRIVKEY[0]] = errCode.storage.GET_USERINFO_ENCPRIVKEY[1];
        errTable[errCode.storage.SET_USERINFO_DN[0]] = errCode.storage.SET_USERINFO_DN[1];
        errTable[errCode.storage.SET_USERINFO_SIGNPRIVKEY[0]] = errCode.storage.SET_USERINFO_SIGNPRIVKEY[1];
        errTable[errCode.storage.SET_USERINFO_ENCPRIVKEY[0]] = errCode.storage.SET_USERINFO_ENCPRIVKEY[1];
        errTable[errCode.storage.GET_CERTINFO_SIGNCERT[0]] = errCode.storage.GET_CERTINFO_SIGNCERT[1];
        errTable[errCode.storage.GET_CERTINFO_ENCCERT[0]] = errCode.storage.GET_CERTINFO_ENCCERT[1];
        errTable[errCode.storage.GET_CERTINFO_CAPUBS[0]] = errCode.storage.GET_CERTINFO_CAPUBS[1];
        errTable[errCode.storage.SET_CERTINFO_SIGNCERT[0]] = errCode.storage.SET_CERTINFO_SIGNCERT[1];
        errTable[errCode.storage.SET_CERTINFO_ENCCERT[0]] = errCode.storage.SET_CERTINFO_ENCCERT[1];
        errTable[errCode.storage.SET_CERTINFO_CAPUBS[0]] = errCode.storage.SET_CERTINFO_CAPUBS[1];
        errTable[errCode.storage.GET_COMMONINFO[0]] = errCode.storage.GET_COMMONINFO[1];
        errTable[errCode.storage.SET_COMMONINFO[0]] = errCode.storage.SET_COMMONINFO[1];
        errTable[errCode.storage.SET_REGISTRY[0]] = errCode.storage.SET_REGISTRY[1];

        /* validity */
        errTable[errCode.validity.INVALID_CONTEXT[0]] = errCode.validity.INVALID_CONTEXT[1];
        errTable[errCode.validity.INVALID_INPUTDATA[0]] = errCode.validity.INVALID_INPUTDATA[1];
        errTable[errCode.validity.INVALID_CERTFORMAT[0]] = errCode.validity.INVALID_CERTFORMAT[1];
        errTable[errCode.validity.CERT_ENCODE_FAILED[0]] = errCode.validity.CERT_ENCODE_FAILED[1];
        errTable[errCode.validity.CRL_ENCODE_FAILED[0]] = errCode.validity.CRL_ENCODE_FAILED[1];
        errTable[errCode.validity.NOTEXIST_DP[0]] = errCode.validity.NOTEXIST_DP[1];
        errTable[errCode.validity.GET_DP_FAILED[0]] = errCode.validity.GET_DP_FAILED[1];
        errTable[errCode.validity.CERT_TIMEOUT[0]] = errCode.validity.CERT_TIMEOUT[1];
        errTable[errCode.validity.CERT_SIGNATURE_ERROR[0]] = errCode.validity.CERT_SIGNATURE_ERROR[1];
        errTable[errCode.validity.CRL_SIGNATURE_ERROR[0]] = errCode.validity.CRL_SIGNATURE_ERROR[1];
        errTable[errCode.validity.CERT_REVOKED[0]] = errCode.validity.CERT_REVOKED[1];
        errTable[errCode.validity.INVALID_NAMECHAIN[0]] = errCode.validity.INVALID_NAMECHAIN[1];
        errTable[errCode.validity.NOTEXIST_POLICYCONSTRAINTSEX[0]] = errCode.validity.NOTEXIST_POLICYCONSTRAINTSEX[1];
        errTable[errCode.validity.POLICY_INCOMPATIBLE_WITHIPS[0]] = errCode.validity.POLICY_INCOMPATIBLE_WITHIPS[1];
        errTable[errCode.validity.POLICY_INCOMPATIBLE_WITHAPS[0]] = errCode.validity.POLICY_INCOMPATIBLE_WITHAPS[1];
        errTable[errCode.validity.NOTEXIST_BASICCONSTRAINTEXT[0]] = errCode.validity.NOTEXIST_BASICCONSTRAINTEXT[1];
        errTable[errCode.validity.NOT_CACERT[0]] = errCode.validity.NOT_CACERT[1];
        errTable[errCode.validity.CAPATHLEN_ERROR[0]] = errCode.validity.CAPATHLEN_ERROR[1];
        errTable[errCode.validity.EKU_INCOMPATIBLE_WITHKU[0]] = errCode.validity.EKU_INCOMPATIBLE_WITHKU[1];
        errTable[errCode.validity.IPS_INCOMPATIBLE_WITHAPS[0]] = errCode.validity.IPS_INCOMPATIBLE_WITHAPS[1];
        errTable[errCode.validity.INCONSISTENT_WITHCS[0]] = errCode.validity.INCONSISTENT_WITHCS[1];
        errTable[errCode.validity.INCONSISTENT_WITHES[0]] = errCode.validity.INCONSISTENT_WITHES[1];
        errTable[errCode.validity.NAME_ADJUST_ERROR[0]] = errCode.validity.NAME_ADJUST_ERROR[1];
        errTable[errCode.validity.KEYUSAGE_ERROR[0]] = errCode.validity.KEYUSAGE_ERROR[1];
        errTable[errCode.validity.SIGNATURE_MISMATCHED[0]] = errCode.validity.SIGNATURE_MISMATCHED[1];
        errTable[errCode.validity.NOTEXIST_CERTCRLLIST[0]] = errCode.validity.NOTEXIST_CERTCRLLIST[1];
        errTable[errCode.validity.INVALID_CRLFORMAT[0]] = errCode.validity.INVALID_CRLFORMAT[1];
        errTable[errCode.validity.CRL_TIMEOUT[0]] = errCode.validity.CRL_TIMEOUT[1];
        errTable[errCode.validity.ARL_TIMEOUT[0]] = errCode.validity.ARL_TIMEOUT[1];
        errTable[errCode.validity.GET_VALIDCRL_FAILED[0]] = errCode.validity.GET_VALIDCRL_FAILED[1];
        errTable[errCode.validity.GET_CADSINFO_FAILED[0]] = errCode.validity.GET_CADSINFO_FAILED[1];
        errTable[errCode.validity.GET_DSINFO_FAILED[0]] = errCode.validity.GET_DSINFO_FAILED[1];
        errTable[errCode.validity.DS_NOTCONNECTED[0]] = errCode.validity.DS_NOTCONNECTED[1];
        errTable[errCode.validity.DS_NO_CERT[0]] = errCode.validity.DS_NO_CERT[1];
        errTable[errCode.validity.DS_NO_ISSUERCERT[0]] = errCode.validity.DS_NO_ISSUERCERT[1];
        errTable[errCode.validity.DS_NO_CERTATTRIBUTE[0]] = errCode.validity.DS_NO_CERTATTRIBUTE[1];
        errTable[errCode.validity.DS_NO_ISSUERCERTATTRIBUTE[0]] = errCode.validity.DS_NO_ISSUERCERTATTRIBUTE[1];
        errTable[errCode.validity.DS_NO_VALIDCERT[0]] = errCode.validity.DS_NO_VALIDCERT[1];
        errTable[errCode.validity.DS_NO_VALIDISSUERCERT[0]] = errCode.validity.DS_NO_VALIDISSUERCERT[1];
        errTable[errCode.validity.DS_NO_MATCHKEYUSAGE_CERT[0]] = errCode.validity.DS_NO_MATCHKEYUSAGE_CERT[1];
        errTable[errCode.validity.CTL_INVALID[0]] = errCode.validity.CTL_INVALID[1];
        errTable[errCode.validity.CTL_TIMEOUT[0]] = errCode.validity.CTL_TIMEOUT[1];
        errTable[errCode.validity.DS_NO_CTL[0]] = errCode.validity.DS_NO_CTL[1];
        errTable[errCode.validity.DS_NO_CTL_ATTRIBUTE[0]] = errCode.validity.DS_NO_CTL_ATTRIBUTE[1];
        errTable[errCode.validity.HASH_FAILED[0]] = errCode.validity.HASH_FAILED[1];
        errTable[errCode.validity.NOTSET_INITIALPOLICY[0]] = errCode.validity.NOTSET_INITIALPOLICY[1];
        errTable[errCode.validity.UPDATECRL_FAILED[0]] = errCode.validity.UPDATECRL_FAILED[1];
        errTable[errCode.validity.GENCAPUBS_NOTEXISTISSUER[0]] = errCode.validity.GENCAPUBS_NOTEXISTISSUER[1];
        errTable[errCode.validity.NOTEXIST_OIDDSMAPLIST[0]] = errCode.validity.NOTEXIST_OIDDSMAPLIST[1];
        errTable[errCode.validity.ROOT_CERT_INVALID[0]] = errCode.validity.ROOT_CERT_INVALID[1];
        errTable[errCode.validity.CRITICAL_ALLCHECK_FAILED[0]] = errCode.validity.CRITICAL_ALLCHECK_FAILED[1];
        errTable[errCode.validity.CERT_REVOKED_HOLD[0]] = errCode.validity.CERT_REVOKED_HOLD[1];
        errTable[errCode.validity.CERT_REVOKED_KEYCOMPROMISE[0]] = errCode.validity.CERT_REVOKED_KEYCOMPROMISE[1];
        errTable[errCode.validity.CERT_REVOKED_AFFCHANGED[0]] = errCode.validity.CERT_REVOKED_AFFCHANGED[1];
        errTable[errCode.validity.CERT_REVOKED_CESSATIONOFOPER[0]] = errCode.validity.CERT_REVOKED_CESSATIONOFOPER[1];
        errTable[errCode.validity.NO_CRL[0]] = errCode.validity.NO_CRL[1];
        errTable[errCode.validity.NO_ARL[0]] = errCode.validity.NO_ARL[1];
        errTable[errCode.validity.NO_VALID_CRL[0]] = errCode.validity.NO_VALID_CRL[1];
        errTable[errCode.validity.NO_VALID_ARL[0]] = errCode.validity.NO_VALID_ARL[1];
        errTable[errCode.validity.NO_CRL_ATTRIBUTE[0]] = errCode.validity.NO_CRL_ATTRIBUTE[1];
        errTable[errCode.validity.NO_ARL_ATTRIBUTE[0]] = errCode.validity.NO_ARL_ATTRIBUTE[1];
        errTable[errCode.validity.NO_EMAIL_ENTRY[0]] = errCode.validity.NO_EMAIL_ENTRY[1];
        errTable[errCode.validity.NO_CN_ENTRY[0]] = errCode.validity.NO_CN_ENTRY[1];
        errTable[errCode.validity.INCORRECT_DN[0]] = errCode.validity.INCORRECT_DN[1];
        errTable[errCode.validity.INCORRECT_DSTYPE[0]] = errCode.validity.INCORRECT_DSTYPE[1];
        errTable[errCode.validity.OCSP_NOINPUT_ISSUERCERT[0]] = errCode.validity.OCSP_NOINPUT_ISSUERCERT[1];
        errTable[errCode.validity.OCSP_NOTEXIST_SERVERINFO[0]] = errCode.validity.OCSP_NOTEXIST_SERVERINFO[1];
        errTable[errCode.validity.OCSP_NOINPUT_GENSIGNINFO[0]] = errCode.validity.OCSP_NOINPUT_GENSIGNINFO[1];
        errTable[errCode.validity.OCSP_NONCEERROR[0]] = errCode.validity.OCSP_NONCEERROR[1];
        errTable[errCode.validity.OCSP_INVALID_SERIALNUM[0]] = errCode.validity.OCSP_INVALID_SERIALNUM[1];
        errTable[errCode.validity.OCSP_INVALID_RESPONSETYPE[0]] = errCode.validity.OCSP_INVALID_RESPONSETYPE[1];
        errTable[errCode.validity.OCSP_VERSION_ERROR[0]] = errCode.validity.OCSP_VERSION_ERROR[1];
        errTable[errCode.validity.OCSP_MALFORMED_REQUEST[0]] = errCode.validity.OCSP_MALFORMED_REQUEST[1];
        errTable[errCode.validity.OCSP_INTERNAL_ERROR[0]] = errCode.validity.OCSP_INTERNAL_ERROR[1];
        errTable[errCode.validity.OCSP_TRY_LATER[0]] = errCode.validity.OCSP_TRY_LATER[1];
        errTable[errCode.validity.OCSP_SIG_REQUIRED[0]] = errCode.validity.OCSP_SIG_REQUIRED[1];
        errTable[errCode.validity.OCSP_UNAUTHORIZED[0]] = errCode.validity.OCSP_UNAUTHORIZED[1];
        errTable[errCode.validity.OCSP_FAILED[0]] = errCode.validity.OCSP_FAILED[1];
        errTable[errCode.validity.OCSP_UNKNOWN_CHOSEN[0]] = errCode.validity.OCSP_UNKNOWN_CHOSEN[1];
        errTable[errCode.validity.OCSP_NOINPUT_REQCERT[0]] = errCode.validity.OCSP_NOINPUT_REQCERT[1];
        errTable[errCode.validity.OCSP_NO_AIAVALUE[0]] = errCode.validity.OCSP_NO_AIAVALUE[1];
        errTable[errCode.validity.OCSP_EXIST_AIAVALUE[0]] = errCode.validity.OCSP_EXIST_AIAVALUE[1];
        errTable[errCode.validity.OCSP_FAIL_CONFIG_ENVIRONMENT[0]] = errCode.validity.OCSP_FAIL_CONFIG_ENVIRONMENT[1];
        errTable[errCode.validity.OCSP_STATUS_GOOD[0]] = errCode.validity.OCSP_STATUS_GOOD[1];
        errTable[errCode.validity.OCSP_STATUS_REVOKED[0]] = errCode.validity.OCSP_STATUS_REVOKED[1];
        errTable[errCode.validity.OCSP_STATUS_UNKNOWN[0]] = errCode.validity.OCSP_STATUS_UNKNOWN[1];
        errTable[errCode.validity.OCSP_SAMERESSRVRADDR[0]] = errCode.validity.OCSP_SAMERESSRVRADDR[1];
        errTable[errCode.validity.NOTEXIST_OCSPSVRLIST[0]] = errCode.validity.NOTEXIST_OCSPSVRLIST[1];
        errTable[errCode.validity.NOTEXIST_TRUSTED_ROOTCA[0]] = errCode.validity.NOTEXIST_TRUSTED_ROOTCA[1];
        errTable[errCode.validity.INVALIDFORMAT_TRUSTED_ROOTCA[0]] = errCode.validity.INVALIDFORMAT_TRUSTED_ROOTCA[1];
        errTable[errCode.validity.NO_AKI[0]] = errCode.validity.NO_AKI[1];
        errTable[errCode.validity.NO_AKI_KI[0]] = errCode.validity.NO_AKI_KI[1];
        errTable[errCode.validity.NO_AKI_ACI[0]] = errCode.validity.NO_AKI_ACI[1];
        errTable[errCode.validity.NO_AKI_ACSN[0]] = errCode.validity.NO_AKI_ACSN[1];
        errTable[errCode.validity.AKI_COMPARE_FAIL[0]] = errCode.validity.AKI_COMPARE_FAIL[1];
        errTable[errCode.validity.CERT_REVOKED_HOLD_CA[0]] = errCode.validity.CERT_REVOKED_HOLD_CA[1];
        errTable[errCode.validity.CERT_REVOKED_KEYCOMPROMISE_CA[0]] = errCode.validity.CERT_REVOKED_KEYCOMPROMISE_CA[1];
        errTable[errCode.validity.CERT_REVOKED_AFFCHANGED_CA[0]] = errCode.validity.CERT_REVOKED_AFFCHANGED_CA[1];
        errTable[errCode.validity.CERT_REVOKED_CESSATIONOFOPER_CA[0]] = errCode.validity.CERT_REVOKED_CESSATIONOFOPER_CA[1];
        errTable[errCode.validity.CERT_REVOKED_CACOMPROMISE_CA[0]] = errCode.validity.CERT_REVOKED_CACOMPROMISE_CA[1];
        errTable[errCode.validity.CERT_REVOKED_SUPERSEDED_CA[0]] = errCode.validity.CERT_REVOKED_SUPERSEDED_CA[1];
        errTable[errCode.validity.CERT_REVOKED_UNSPECIFIED_CA[0]] = errCode.validity.CERT_REVOKED_UNSPECIFIED_CA[1];
        errTable[errCode.validity.CERT_REVOKED_REMOVEFROMCRL_CA[0]] = errCode.validity.CERT_REVOKED_REMOVEFROMCRL_CA[1];
        errTable[errCode.validity.CERT_REVOKED_CA[0]] = errCode.validity.CERT_REVOKED_CA[1];
        errTable[errCode.validity.CERT_REVOKED_CACOMPROMISE[0]] = errCode.validity.CERT_REVOKED_CACOMPROMISE[1];
        errTable[errCode.validity.CERT_REVOKED_SUPERSEDED[0]] = errCode.validity.CERT_REVOKED_SUPERSEDED[1];
        errTable[errCode.validity.CERT_REVOKED_UNSPECIFIED[0]] = errCode.validity.CERT_REVOKED_UNSPECIFIED[1];
        errTable[errCode.validity.CERT_REVOKED_REMOVEFROMCRL[0]] = errCode.validity.CERT_REVOKED_REMOVEFROMCRL[1];
        errTable[errCode.validity.KEYUSAGE_NOT_EXIST[0]] = errCode.validity.KEYUSAGE_NOT_EXIST[1];
        errTable[errCode.validity.KEYUSAGE_NOT_EXIST_CA[0]] = errCode.validity.KEYUSAGE_NOT_EXIST_CA[1];
        errTable[errCode.validity.CRYPTOKI_FAIL_CONFIG_ENVIRONMENT[0]] = errCode.validity.CRYPTOKI_FAIL_CONFIG_ENVIRONMENT[1];

        /* pkcs */
        errTable[errCode.pkcs.INVALID_CONTEXT[0]] = errCode.pkcs.INVALID_CONTEXT[1];
        errTable[errCode.pkcs.INVALID_INPUTDATA[0]] = errCode.pkcs.INVALID_INPUTDATA[1];
        errTable[errCode.pkcs.INVALID_CAPUBSFORMAT[0]] = errCode.pkcs.INVALID_CAPUBSFORMAT[1];
        errTable[errCode.pkcs.INCORRECT_HASHALGORITHM[0]] = errCode.pkcs.INCORRECT_HASHALGORITHM[1];
        errTable[errCode.pkcs.INCORRECT_ALGOID[0]] = errCode.pkcs.INCORRECT_ALGOID[1];
        errTable[errCode.pkcs.TOOLONG_KEYSIZE[0]] = errCode.pkcs.TOOLONG_KEYSIZE[1];
        errTable[errCode.pkcs.HASH_FAILED[0]] = errCode.pkcs.HASH_FAILED[1];
        errTable[errCode.pkcs.PBE_ENC_FAILED[0]] = errCode.pkcs.PBE_ENC_FAILED[1];
        errTable[errCode.pkcs.PBE_DEC_FAILED[0]] = errCode.pkcs.PBE_DEC_FAILED[1];
        errTable[errCode.pkcs.GEN_PKCS12BAGATTR_FAILED[0]] = errCode.pkcs.GEN_PKCS12BAGATTR_FAILED[1];
        errTable[errCode.pkcs.GEN_PKCS12MAC_FAILED[0]] = errCode.pkcs.GEN_PKCS12MAC_FAILED[1];
        errTable[errCode.pkcs.VERIFY_PKCS12MAC_FAILED[0]] = errCode.pkcs.VERIFY_PKCS12MAC_FAILED[1];
        errTable[errCode.pkcs.INCORRECT_CMSTYPE[0]] = errCode.pkcs.INCORRECT_CMSTYPE[1];
        errTable[errCode.pkcs.UNKNOWN_CMSTYPE[0]] = errCode.pkcs.UNKNOWN_CMSTYPE[1];
        errTable[errCode.pkcs.INVALID_CAPUBS[0]] = errCode.pkcs.INVALID_CAPUBS[1];
        errTable[errCode.pkcs.NOTEXIST_SIGNERINFO[0]] = errCode.pkcs.NOTEXIST_SIGNERINFO[1];
        errTable[errCode.pkcs.NOINPUT_SIGNERCERT[0]] = errCode.pkcs.NOINPUT_SIGNERCERT[1];
        errTable[errCode.pkcs.NOINPUT_SIGNORIMSG[0]] = errCode.pkcs.NOINPUT_SIGNORIMSG[1];
        errTable[errCode.pkcs.NOINPUT_DIGESTORIMSG[0]] = errCode.pkcs.NOINPUT_DIGESTORIMSG[1];
        errTable[errCode.pkcs.NOTEXIST_DIGESTVALUE[0]] = errCode.pkcs.NOTEXIST_DIGESTVALUE[1];
        errTable[errCode.pkcs.DIGESTVALUE_MISMATCHED[0]] = errCode.pkcs.DIGESTVALUE_MISMATCHED[1];
        errTable[errCode.pkcs.NOTEXIST_DIGESTCONTENTS[0]] = errCode.pkcs.NOTEXIST_DIGESTCONTENTS[1];
        errTable[errCode.pkcs.GEN_MAC_FAILED[0]] = errCode.pkcs.GEN_MAC_FAILED[1];
        errTable[errCode.pkcs.VERIFY_MAC_FAILED[0]] = errCode.pkcs.VERIFY_MAC_FAILED[1];
        errTable[errCode.pkcs.NOINPUT_AUTHORIMSG[0]] = errCode.pkcs.NOINPUT_AUTHORIMSG[1];
        errTable[errCode.pkcs.NOTEXIST_AUTHVALUE[0]] = errCode.pkcs.NOTEXIST_AUTHVALUE[1];
        errTable[errCode.pkcs.NOTEXIST_CONTENTS[0]] = errCode.pkcs.NOTEXIST_CONTENTS[1];
        errTable[errCode.pkcs.NOTEXIST_SIGNERCERT[0]] = errCode.pkcs.NOTEXIST_SIGNERCERT[1];
        errTable[errCode.pkcs.NOTEXIST_RECIPIENTINFO[0]] = errCode.pkcs.NOTEXIST_RECIPIENTINFO[1];
        errTable[errCode.pkcs.INVALID_VERSION[0]] = errCode.pkcs.INVALID_VERSION[1];
        errTable[errCode.pkcs.INVALID_PASSWORD_EXCESS[0]] = errCode.pkcs.INVALID_PASSWORD_EXCESS[1];

        /* cert */
        errTable[errCode.cert.INVALID_CONTEXT[0]] = errCode.cert.INVALID_CONTEXT[1];
        errTable[errCode.cert.INVALID_INPUTDATA[0]] = errCode.cert.INVALID_INPUTDATA[1];
        errTable[errCode.cert.INCORRECT_CERTTYPE[0]] = errCode.cert.INCORRECT_CERTTYPE[1];
        errTable[errCode.cert.INCORRECT_KEYTYPE[0]] = errCode.cert.INCORRECT_KEYTYPE[1];
        errTable[errCode.cert.READ_PRIVKEY_FAILED[0]] = errCode.cert.READ_PRIVKEY_FAILED[1];
        errTable[errCode.cert.WRITE_PRIVKEY_FAILED[0]] = errCode.cert.WRITE_PRIVKEY_FAILED[1];
        errTable[errCode.cert.READ_CERT_FAILED[0]] = errCode.cert.READ_CERT_FAILED[1];
        errTable[errCode.cert.WRITE_CERT_FAILED[0]] = errCode.cert.WRITE_CERT_FAILED[1];
        errTable[errCode.cert.WRITE_CERTPATH_FAILED[0]] = errCode.cert.WRITE_CERTPATH_FAILED[1];
        errTable[errCode.cert.INCORRECT_MEDIA[0]] = errCode.cert.INCORRECT_MEDIA[1];
        errTable[errCode.cert.NOTEXIST_SET_CALIST[0]] = errCode.cert.NOTEXIST_SET_CALIST[1];
        errTable[errCode.cert.NOTEXIST_SET_MEDIALIST[0]] = errCode.cert.NOTEXIST_SET_MEDIALIST[1];
        errTable[errCode.cert.NOTEXIST_MEDIAINFO[0]] = errCode.cert.NOTEXIST_MEDIAINFO[1];
        errTable[errCode.cert.NOTEXIST_CERTCRLLIST[0]] = errCode.cert.NOTEXIST_CERTCRLLIST[1];
        errTable[errCode.cert.NOTEXIST_DSINFO[0]] = errCode.cert.NOTEXIST_DSINFO[1];
        errTable[errCode.cert.NOTEXIST_ROOTCA_INCAPUBS[0]] = errCode.cert.NOTEXIST_ROOTCA_INCAPUBS[1];
        errTable[errCode.cert.NO_RANDOM_VALUE[0]] = errCode.cert.NO_RANDOM_VALUE[1];
        errTable[errCode.cert.VID_MISMATCHED[0]] = errCode.cert.VID_MISMATCHED[1];
        errTable[errCode.cert.OCSP_CONF_ERROR[0]] = errCode.cert.OCSP_CONF_ERROR[1];
        errTable[errCode.cert.KCASE_CONF_ERROR[0]] = errCode.cert.KCASE_CONF_ERROR[1];

        /* agent */
        errTable[errCode.agent.INIT_CONTEXT_ERROR[0]] = errCode.agent.INIT_CONTEXT_ERROR[1];
        errTable[errCode.agent.INPUT_UNKNOWN_FLAG[0]] = errCode.agent.INPUT_UNKNOWN_FLAG[1];
        errTable[errCode.agent.INPUT_DATA_ERROR[0]] = errCode.agent.INPUT_DATA_ERROR[1];
        errTable[errCode.agent.INPUT_PW_ERROR[0]] = errCode.agent.INPUT_PW_ERROR[1];
        errTable[errCode.agent.INPUT_DN_ERROR[0]] = errCode.agent.INPUT_DN_ERROR[1];
        errTable[errCode.agent.INPUT_IDN_ERROR[0]] = errCode.agent.INPUT_IDN_ERROR[1];
        errTable[errCode.agent.INPUT_CERTTYPE_ERROR[0]] = errCode.agent.INPUT_CERTTYPE_ERROR[1];
        errTable[errCode.agent.GET_CERT_ERROR[0]] = errCode.agent.GET_CERT_ERROR[1];
        errTable[errCode.agent.GET_KEY_ERROR[0]] = errCode.agent.GET_KEY_ERROR[1];
        errTable[errCode.agent.INPUT_SIGNDN_ERROR[0]] = errCode.agent.INPUT_SIGNDN_ERROR[1];
        errTable[errCode.agent.INPUT_SIGNPW_ERROR[0]] = errCode.agent.INPUT_SIGNPW_ERROR[1];
        errTable[errCode.agent.INPUT_SIGNTYPE_ERROR[0]] = errCode.agent.INPUT_SIGNTYPE_ERROR[1];
        errTable[errCode.agent.INPUT_SIGN_FILE_ERROR[0]] = errCode.agent.INPUT_SIGN_FILE_ERROR[1];
        errTable[errCode.agent.INPUT_SIGN_DATA_ERROR[0]] = errCode.agent.INPUT_SIGN_DATA_ERROR[1];
        errTable[errCode.agent.INPUT_VERIFY_FILE_ERROR[0]] = errCode.agent.INPUT_VERIFY_FILE_ERROR[1];
        errTable[errCode.agent.INPUT_VERIFY_DATA_ERROR[0]] = errCode.agent.INPUT_VERIFY_DATA_ERROR[1];
        errTable[errCode.agent.GET_SIGNER_CERT_ERROR[0]] = errCode.agent.GET_SIGNER_CERT_ERROR[1];
        errTable[errCode.agent.INPUT_ENCDN_ERROR[0]] = errCode.agent.INPUT_ENCDN_ERROR[1];
        errTable[errCode.agent.INPUT_ENC_FILE_ERROR[0]] = errCode.agent.INPUT_ENC_FILE_ERROR[1];
        errTable[errCode.agent.INPUT_ENC_DATA_ERROR[0]] = errCode.agent.INPUT_ENC_DATA_ERROR[1];
        errTable[errCode.agent.INPUT_ENCTYPE_ERROR[0]] = errCode.agent.INPUT_ENCTYPE_ERROR[1];
        errTable[errCode.agent.INPUT_ENCPW_ERROR[0]] = errCode.agent.INPUT_ENCPW_ERROR[1];
        errTable[errCode.agent.INPUT_ENCDATA_ERROR[0]] = errCode.agent.INPUT_ENCDATA_ERROR[1];
        errTable[errCode.agent.INPUT_DEC_FILE_ERROR[0]] = errCode.agent.INPUT_DEC_FILE_ERROR[1];
        errTable[errCode.agent.INPUT_DEC_DATA_ERROR[0]] = errCode.agent.INPUT_DEC_DATA_ERROR[1];
        errTable[errCode.agent.INPUT_DECTYPE_ERROR[0]] = errCode.agent.INPUT_DECTYPE_ERROR[1];
        errTable[errCode.agent.CONFIG_PKITYPE_ERROR[0]] = errCode.agent.CONFIG_PKITYPE_ERROR[1];
        errTable[errCode.agent.CONFIG_ENCPRI_ALGO_ERROR[0]] = errCode.agent.CONFIG_ENCPRI_ALGO_ERROR[1];
        errTable[errCode.agent.HASH_DIFF_ERROR[0]] = errCode.agent.HASH_DIFF_ERROR[1];
        errTable[errCode.agent.VERSION_DIFF_ERROR[0]] = errCode.agent.VERSION_DIFF_ERROR[1];
        errTable[errCode.agent.NO_REMOVABLEDISK[0]] = errCode.agent.NO_REMOVABLEDISK[1];

        /* pkcs11 */
        errTable[errCode.pkcs11.DEVICE_ERROR[0]] = errCode.pkcs11.DEVICE_ERROR[1];
        errTable[errCode.pkcs11.DEVICE_REMOVED[0]] = errCode.pkcs11.DEVICE_REMOVED[1];
        errTable[errCode.pkcs11.TOKEN_NOT_PRESENT[0]] = errCode.pkcs11.TOKEN_NOT_PRESENT[1];
        errTable[errCode.pkcs11.NOT_INITIALIZED[0]] = errCode.pkcs11.NOT_INITIALIZED[1];
        errTable[errCode.pkcs11.KEY_HANDLE_INVALID[0]] = errCode.pkcs11.KEY_HANDLE_INVALID[1];
        errTable[errCode.pkcs11.OBJECT_HANDLE_INVALID[0]] = errCode.pkcs11.OBJECT_HANDLE_INVALID[1];
        errTable[errCode.pkcs11.PIN_INCORRECT[0]] = errCode.pkcs11.PIN_INCORRECT[1];
        errTable[errCode.pkcs11.PIN_LEN_RANGE[0]] = errCode.pkcs11.PIN_LEN_RANGE[1];
        errTable[errCode.pkcs11.PIN_LOCKED[0]] = errCode.pkcs11.PIN_LOCKED[1];
        errTable[errCode.pkcs11.SESSION_NOT_SUPPORT[0]] = errCode.pkcs11.SESSION_NOT_SUPPORT[1];
        errTable[errCode.pkcs11.USER_NOT_LOGGED_IN[0]] = errCode.pkcs11.USER_NOT_LOGGED_IN[1];

        this.getErrorMsg = function(errorCode) {
            var msg = errTable[errorCode];
			
            if(msg === undefined) {
                msg = "알 수 없는 에러가 발생했습니다.";
            }
            return msg;

        };
    }

    function initDialog() {
        var dialogObj = new Object();

        /**
         * Class List
         *
         */
        function _makeDialog(option) {
            var tempDialog, msg = "다이얼로그 ID가 없습니다.";

            if (option.id == undefined) {
                throw msg;
                return;
            }

            tempDialog = new Dialog(option);

            dialogObj[option.id] = tempDialog;

            $("#" + option.id + " ." + prop.cs.dlgClose).click(function () {
                tempDialog.close();
            });

            return tempDialog;
        }

        function _getDialog(id) {
            return dialogObj[id];
        }

        var DialogBase = function (options) {
            var dlg = $("#" + options.id).kcDialog({
                autoOpen: false,
                resizable: false,
                modal: true,
                mainTitle: options.mainTitle,
                width: options.width,
                height: options.height
            });
            return dlg;
        };

        var Dialog = function (option) {
            var dialog;

            var options = {
                id: undefined,
                width: 450,
                height: 585,
                mainTitle: false,
                open: function () {
                },
                close: function () {
                }
            };

            /* 옵션 파라미터 처리 */
            if (option !== undefined) {
                util.setOption(options, option);
            }

            dialog = new DialogBase(options);

            this.open = function (p) {
                options.open(p);
                dialog.kcDialog("open");
            };

            this.close = function () {
                options.close();
                dialog.kcDialog("close");
            };

            this.setTitle = function (title) {
                $("#" + prop.id.title + " h3").text(title);
            };

            this.setHeight = function (h) {
                dialog.kcDialog("option", "height", h);
            };

            this.setBottomBtns = function (btnNum, opt) {
                var opts = {
                    event: undefined,
                    show: true,
                    name: undefined
                };
                if (option !== undefined) {
                    util.setOption(opts, opt);
                }
                var selectedBtn = $("#" + options.id + " ." + prop.cs.btnLayout).find("button").eq(btnNum);
                if (opts.event != undefined) {
                    selectedBtn.off("click");
                    selectedBtn.click(opts.event);
                }
                if (opts.show == true) {
                    selectedBtn.css("display", "inline-block");
                } else {
                    selectedBtn.css("display", "none");
                }
                if (opts.name != undefined) {
                    selectedBtn.text(opts.name);
                }
            };
        };

        /**
         * Certificate Manager Base Class
         */
        function _CertListManagerBase() {
            var reqCertListInfo = {
                media: 0,
                drive: 0,
                optList: undefined,
                certPolicies: undefined,
                secTokProg: undefined
            };

            var certPosTableId = prop.id.certPosTable;
            var posBtnList = $("#" + certPosTableId).find("button");
            var adminBtnList = $("#" + prop.id.content.admin).find("button");
            var certPwInput = $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox);

            posBtnList.click(function() {
                certPwInput.attr("disabled", false);
            });
            posBtnList.eq(0).click(function () {
               if ((prop.mediaOpt & prop.enable.harddisk) == prop.enable.harddisk) {
							// 2017.08.21 DYLEE Media Enable 유무 판별 코드 추가
                posBtnList.removeClass(prop.cs.btnPressed).addClass(prop.cs.btnNormal);
                $(this).removeClass(prop.cs.btnNormal).addClass(prop.cs.btnPressed);

                adminBtnList.attr("disabled", false);
                adminBtnList.css("color", "black");

                reqCertListInfo.media = prop.media.hardDisk;
                reqCertListInfo.drive = 0;
                _getCertList();
	             }
            });

            posBtnList.eq(1).click(function () {
               if ((prop.mediaOpt & prop.enable.remdisk) == prop.enable.remdisk) {
								// 2017.08.21 DYLEE Media Enable 유무 판별 코드 추가
                posBtnList.removeClass(prop.cs.btnPressed).addClass(prop.cs.btnNormal);
                $(this).removeClass(prop.cs.btnNormal).addClass(prop.cs.btnPressed);

                /* DropDown Menu Init */
                $("." + prop.cs.dropdownMenu).remove();

                var ulElement = $('<ul />');
                ulElement.addClass(prop.cs.dropdownMenu);

                /* get removable disk list */
                comm.reqRemovableDiskList(function (result) {
                    if (result.DriveList.length > 0) {
                        for (var i = 0; i < result.DriveList.length; i++) {
                            result.DriveList[i] = util.decodeUtf8(util.decode64(result.DriveList[i]));

                            var liElement = "<li><a>"
                                + result.DriveList[i].substr(1, result.DriveList[i].length) + " ("
                                + result.DriveList[i].charAt(0) + ":)</a></li>";

                            ulElement.append(liElement);
                            $("#" + certPosTableId).find("td").eq(1).append(ulElement);

                            ulElement.css("display", "block");

                            ulElement.find("li:last").data("value", result.DriveList[i].charAt(0));

                            ulElement.find("li:last").click(function () {
                                adminBtnList.attr("disabled", false);
                                adminBtnList.css("color", "black");

                                reqCertListInfo.media = prop.media.removableDisk;
                                reqCertListInfo.drive = $(this).data("value").charCodeAt(0);
                                _getCertList();
                                $("." + prop.cs.dropdownMenu).css("display", "none");
                            });
                        }
                        $(document).click(function (event) {
                            if (event.target.className != prop.cs.dropdownGrp + " " + prop.cs.icoRemovable && event.target.className != prop.cs.dropdownGrp + " " + prop.cs.rgbText) {
                                $("." + prop.cs.dropdownMenu).css("display", "none");
                                $(document).off("click");
                            }
                        });
                    } else {
                        // no removable disk
                    }
                });
		           }
            });

            posBtnList.eq(2).click(function () {
								// 2017.08.21 DYLEE Media Enable 유무 판별 코드 추가
							if ((prop.mediaOpt & prop.enable.savetoken) == prop.enable.savetoken) {

                posBtnList.removeClass(prop.cs.btnPressed).addClass(prop.cs.btnNormal);
                $(this).removeClass(prop.cs.btnNormal).addClass(prop.cs.btnPressed);
                p11DlgManager.open();
                p11DlgManager.setConfirmBtn(function() {
                    _getPkcs11CertList(p11DlgManager.getSelectedName());
                    p11DlgManager.close();
                });

                adminBtnList.eq(0).attr("disabled", true);
                adminBtnList.eq(0).css("color", "gray");
                adminBtnList.eq(1).attr("disabled", true);
                adminBtnList.eq(1).css("color", "gray");
                adminBtnList.eq(3).attr("disabled", true);
                adminBtnList.eq(3).css("color", "gray");

                certPwInput.attr("disabled", true);
              }
            });

            posBtnList.eq(3).click(function () {
								// 2017.08.21 DYLEE Media Enable 유무 판별 코드 추가
							if ((prop.mediaOpt & prop.enable.mobile) == prop.enable.mobile) {

                posBtnList.removeClass(prop.cs.btnPressed).addClass(prop.cs.btnNormal);
                $(this).removeClass(prop.cs.btnNormal).addClass(prop.cs.btnPressed);
                alert("준비중입니다.");
	            }
            });

            function _getPolicyName(oid) {
                var map = {};

                // wide use
                map["1.2.410.200005.1.1.1"] = ["금융 개인", "금융결제원"];
                map["1.2.410.200005.1.1.5"] = ["범용 기업", "금융결제원"];
                map["1.2.410.200012.1.1.1"] = ["전자거래서명용(개인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.3"] = ["전자거래서명용(법인)", "한국무역정보통신"];
                map["1.2.410.200004.5.1.1.5"] = ["범용 개인", "한국증권전산"];
                map["1.2.410.200004.5.1.1.7"] = ["범용 법인", "한국증권전산"];
                map["1.2.410.200004.5.2.1.1"] = ["범용 법인", "한국정보인증"];
                map["1.2.410.200004.5.2.1.2"] = ["범용 개인", "한국정보인증"];
                map["1.2.410.200004.5.3.1.1"] = ["법용 기관", "한국전산원"];
                map["1.2.410.200004.5.3.1.2"] = ["법용 법인", "한국전산원"];
                map["1.2.410.200004.5.3.1.9"] = ["범용 개인", "한국전산원"];
                map["1.2.410.200004.5.4.1.1"] = ["범용 개인", "한국 전자인증"];
                map["1.2.410.200004.5.4.1.2"] = ["범용 법인", "한국 전자인증"];

                map["1.2.410.200004.2.1"] = ["일반인증서", "공인인증기관"];
                map["1.2.410.200005.1.1.2"] = ["금융기업", "금융결제원"];
                map["1.2.410.200005.1.1.4"] = ["은행개인", "금융결제원"];
                map["1.2.410.200004.5.1.1.1"] = ["스페셜개인", "한국증권전산"];
                map["1.2.410.200004.5.1.1.2"] = ["스페셜개인서버", "한국증권전산"];
                map["1.2.410.200004.5.1.1.3"] = ["스페셜법인", "한국증권전산"];
                map["1.2.410.200004.5.1.1.4"] = ["스페셜서버", "한국증권전산"];
                map["1.2.410.200004.5.1.1.6"] = ["범용개인서버", "한국증권전산"];
                map["1.2.410.200004.5.1.1.8"] = ["범용서버", "한국증권전산"];
                map["1.2.410.200004.5.1.1.9"] = ["골드개인", "한국증권전산"];
                map["1.2.410.200004.5.1.1.10"] = ["골드개인서버", "한국증권전산"];
                map["1.2.410.200004.5.1.1.11"] = ["실버개인", "한국증권전산"];
                map["1.2.410.200004.5.1.1.12"] = ["실버법인", "한국증권전산"];
                map["1.2.410.200012.1.1.2"] = ["전자거래암호용(개인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.4"] = ["전자거래암호용(법인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.5"] = ["전자거래서명용(서버)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.6"] = ["전자거래암호용(서버)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.7"] = ["전자무역서명용(개인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.8"] = ["전자무역암호용(개인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.9"] = ["전자무역서명용(법인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.10"] = ["전자무역암호용(법인)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.11"] = ["전자무역서명용(서버)", "한국무역정보통신"];
                map["1.2.410.200012.1.1.12"] = ["전자무역암호용(서버)", "한국무역정보통신"];
                map["1.2.410.200004.5.4.1.3"] = ["범용(서버)", "한국 전자인증"];
                map["1.2.410.200004.5.4.1.4"] = ["특수목적용(개인)", "한국 전자인증"];
                map["1.2.410.200004.5.4.1.5"] = ["특수목적용(법인)", "한국 전자인증"];
                map["1.2.410.200004.5.2.1.3"] = ["특별등급(전자입찰)", "한국정보인증"];
                map["1.2.410.200004.5.2.1.4"] = ["1등급인증서(서버)", "한국정보인증"];
                map["1.2.410.200004.5.2.1.5"] = ["특별등급법인", "한국정보인증"];
                map["1.2.410.200004.5.3.1.3"] = ["1등급(서버)", "한국전산원"];
                map["1.2.410.200004.5.3.1.5"] = ["특수목적용(기관/단체)", "한국전산원"];
                map["1.2.410.200004.5.3.1.6"] = ["특수목적용(법인)", "한국전산원"];
                map["1.2.410.200004.5.3.1.7"] = ["특수목적용(서버)", "한국전산원"];
                map["1.2.410.200004.5.3.1.8"] = ["특수목적용(개인)", "한국전산원"];
                map["1.2.392.200132"] = ["일본상공회의소", "JCCI"];
                map["1.2.392.200132.1"] = ["일본 상공회의소 비지니스 인증 서비스(BCA 접속)", "JCCI"];
                map["1.2.392.200132.1.1"] = ["비지니스 인증 서비스 타입 1 업무 폴리시 및 운용 규정", "JCCI"];
                map["1.2.392.200132.1.1"] = ["비지니스 인증 서비스 타입 1 증명서 발행 폴리시", "JCCI"];
                map["2.5.29.32.0"] = ["일본상공회의소 any-policy", "JCCI"];

                // GPKI Policy
                map["1.2.410.100001.2.1.1"] = ["전자관인(기관용)", "안전행전부"];
                map["1.2.410.100001.2.1.2"] = ["서버용(컴퓨터용)", "안전행전부"];
                map["1.2.410.100001.2.1.3"] = ["특수목적용(업무용) ", "안전행전부"];
                map["1.2.410.100001.2.1.4"] = ["공공/민간 전자관인 ", "안전행전부"];
                map["1.2.410.100001.2.1.5"] = ["공공/민간 컴퓨터용 ", "안전행전부"];
                map["1.2.410.100001.2.1.6"] = ["공공/민간 특수목적용 ", "안전행전부"];
                map["1.2.410.100001.2.2.1"] = ["공무원 전자서명", "안전행전부"];
                map["1.2.410.100001.2.2.2"] = ["공공/민간 개인용 전자서명 ", "안전행전부"];
                map["1.2.410.100001.5.1"] = ["대통령비서실 ", "안전행전부"];
                map["1.2.410.100001.5.1.1"] = ["대통령비서실 인증서정책", ""];
                map["1.2.410.100001.5.2"] = ["국가정보원 ", "안전행전부"];
                map["1.2.410.100001.5.2.1"] = ["국가정보원 인증서정책", "안전행전부"];
                map["1.2.410.100001.5.3"] = ["교육부", "교육부"];
                map["1.2.410.100001.5.3.1"] = ["교육부 인증서정책", "교육부"];
                map["1.2.410.100001.5.3.1.1"] = ["전자관인", "교육부"];
                map["1.2.410.100001.5.3.1.3"] = ["일반인증서", "교육부"];
                map["1.2.410.100001.5.3.1.5"] = ["특수목적용", "교육부"];
                map["1.2.410.100001.5.3.1.7"] = ["컴퓨터용 ", "교육부"];
                map["1.2.410.100001.5.3.1.9"] = ["SSL용", "교육부"];
                map["1.2.410.100001.5.4"] = ["국방부 ", "국방부"];
                map["1.2.410.100001.5.4.1"] = ["국방부 인증서정책", "국방부"];
                map["1.2.410.100001.5.5"] = ["대검찰청 ", "대검찰청"];
                map["1.2.410.100001.5.5.1"] = ["대검찰청 인증서정책", "대검찰청"];
                map["1.2.410.100001.5.6"] = ["병무청 ", "병무청"];
                map["1.2.410.100001.5.6.1"] = ["병무청 인증서정책", "병무청"];
                map["1.2.410.100001.5.7"] = ["안전행정부 ", ""];
                map["1.2.410.100001.5.7.1"] = ["안전행정부 인증서정책", ""];
                map["1.2.410.100001.5.8"] = ["법원", "법원"];
                map["1.2.410.100001.5.8.1"] = ["법원", "법원"];
                return map[oid];
            }

            function _certObjToCertInfo(certObj) {
                var policy = _getPolicyName(certObj.policy);

                if(policy == undefined) {
                    policy = ["", ""];
                }

                var certInfo = {
                    version: certObj.version,
                    serialNumber: certObj.serialNumber,
                    signAlgorithm: certObj.signAlgorithm,
                    issuerDN: certObj.issuerDN,
                    issuerName: policy[1],
                    issuerOrg: certObj.issuerOrg,
                    notBefore: certObj.notBefore,
                    notAfter: certObj.notAfter,
                    subjectCN: certObj.subjectCN,
                    subjectDN: certObj.subjectDN,
                    pubKey: certObj.pubKey,
                    pubKeyAlgo: certObj.pubKeyAlgo,
                    pubKeyLength: certObj.pubKeyLength,
                    authorityKeyId: certObj.authorityKeyId,
                    subjectKeyId: certObj.subjectKeyId,
                    policy: policy[0],
                    policyOid: certObj.policy,
                    cps: certObj.cps,
                    noti: certObj.noti,
                    subjectAltName: certObj.subjectAltName,
                    dp: certObj.dp,
                    authorityInfoAccessOCSP: certObj.authorityInfoAccessOCSP,
                    keyUsage: certObj.keyUsage,
                    authorityCertSerialNumber: certObj.authorityCertSerialNumber,
                    signautre: certObj.signautre
                };
                return certInfo;
            }

            /* Set Certificate List to Dialog */
            function _insertCertList(certInfo) {
                var img;

                if (certInfo.certStatus == -1) {
                    img = prop.ROOT_DIR + "/img/cert_inv_small.png";
                } else {
                    img = prop.ROOT_DIR + "/img/cert0.png";
                }

                var certListElement = $("#" + prop.id.certList);

                var rowElement = $("<tr/>", {
                    click: function () {
                        certListElement.find("tbody tr").removeData("selected");
                        certListElement.find("tbody tr").removeClass(prop.cs.certSelectedRow);
                        $(this).addClass(prop.cs.certSelectedRow);
                        $(this).data("selected", 1);

                        $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val("");
                        $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).focus();
                    },
                    dblclick: function () {
                        _getDialog(prop.id.dialog.viewCert).open(certInfo);
                    }
                });

                var tdElement = "<td><div class='" + prop.cs.certTableCell + "'><img src='" + img + "'/>" + certInfo.policy + "</div></td>"
                    + "<td><div class='" + prop.cs.certTableCell + "'>" + certInfo.subjectCN + "</div></td>"
                    + "<td><div class='" + prop.cs.certTableCell + " txtCenter'>" + certInfo.notAfter + "</div></td>"
                    + "<td><div class='" + prop.cs.certTableCell + " txtCenter'>" + certInfo.issuerName + "</div></td>";

                rowElement.append(tdElement);
                rowElement.data("certInfo", certInfo);
                certListElement.find("tbody").append(rowElement);
            }

            /* Get Certificate List */
            var _getCertList = this.getCertList = function (error) {
                /* 인증서리스트를 먼저 삭제함 */
                $("#" + prop.id.certList + " tbody").find("tr").remove();

                reqCertListInfo.certPolicies = prop.certPolices;

                comm.reqCertList(reqCertListInfo, function (result) {
                    var certInfo = [];

                    if(result.Status != prop.success) {
                        if(error != undefined)
                            error();
                    }

                    for (var i = 0; i < result.CertList.length; i++) {
                        var tmpCertInfo = _certObjToCertInfo($.parseJSON(util.decodeUtf8(util.decode64(result.CertList[i]))));

                        certInfo[i] = tmpCertInfo;
                        certInfo[i].media = reqCertListInfo.media;
                        certInfo[i].drive = reqCertListInfo.drive;
                        certInfo[i].secTokProg = reqCertListInfo.secTokProg;
                        certInfo[i].certStatus = result.CertStatus[i];

                        _insertCertList(certInfo[i]);
                    }
                }, true);
            };

            /* Check Certificate Selected */
            this.checkSelectedCert = function () {
                var certInfo;
                var tempObject = undefined;

                tempObject = util.getSelectedObject(prop.cs.certSelectedRow);

                if (tempObject == undefined) {
                    return undefined;
                } else {
                    certInfo = tempObject.data("certInfo");
                    return certInfo;
                }
            };

            /* Set Certificate List Option */
            this.setCertOption = function (option) {
                reqCertListInfo.optList = option;
            };
            /* Get Certificate List Option */
            this.getCertOption = function () {
                return reqCertListInfo.optList;
            };

            /* View Certficate */
            this.viewCertificate = function (certInfo) {
            	prop.isSubView = true;
                var commonTab = $("#" + prop.id.tabList).find("td").eq(0);
                var detailTab = $("#" + prop.id.tabList).find("td").eq(1);

                commonTab.click(function () {
                    $("#" + prop.id.tabCommon).css("display", "block");
                    $("#" + prop.id.tabDetail).css("display", "none");

                    commonTab.addClass("tabnav-selected");
                    commonTab.removeClass("tabnav-unselected");
                    detailTab.addClass("tabnav-unselected");
                    detailTab.removeClass("tabnav-selected");
                });

                detailTab.click(function () {
                    $("#" + prop.id.tabCommon).css("display", "none");
                    $("#" + prop.id.tabDetail).css("display", "block");

                    commonTab.addClass("tabnav-unselected");
                    commonTab.removeClass("tabnav-selected");
                    detailTab.addClass("tabnav-selected");
                    detailTab.removeClass("tabnav-unselected");
                });

                commonTab.click();

                comm.reqCertVerify(certInfo, function (result) {
                    var sigStatus;

                    /* Common Information */
                    if (result.Status == prop.success) {
                        sigStatus = prop.strings.CERT_VAL_SUCCESS;
                        $("#" + prop.id.tabCommon + " > div").find("div").remove();
                        $("#" + prop.id.tabCommon + " > div").append("<div><img src='" + prop.ROOT_DIR + "/img/verify1.png" + "'><span class='" + prop.cs.fontb + "' style='margin-left: 8px;'>인증서 정보</span></div>");
                    } else {
                        sigStatus = prop.getErrorMsg(result.Status);
                        $("#" + prop.id.tabCommon + " > div").find("div").remove();
                        $("#" + prop.id.tabCommon + " > div").append("<div><img src='" + prop.ROOT_DIR + "/img/cert_inv.png" + "'><span class='" + prop.cs.fontb + "' style='margin-left: 8px;'>인증서 정보</span></div>");
                    }

                    var certCommonInfoStr = sigStatus + "\r\n\r\n"
                        + "[발급대상]\r\n" + certInfo.subjectCN + "\r\n\r\n"
                        + "[발급자]\r\n" + certInfo.issuerName + "\r\n\r\n"
                        + "[구분]\r\n" + certInfo.policy + "\r\n\r\n"
                        + "[유효기간]\r\n" + certInfo.notBefore + " ~ " + certInfo.notAfter + "\r\n\r\n";
                    $("#" + prop.id.tabCommon + " textarea").text(certCommonInfoStr);

                    /* Detailed Information */
                    $("#" + prop.id.tabDetail + " tbody").find("tr").remove();
                    $("#" + prop.id.tabDetail + " textarea").val("");

                    _addDetailedCertInfo("버전", certInfo.version);
                    _addDetailedCertInfo("일련번호", certInfo.serialNumber);
                    _addDetailedCertInfo("서명알고리즘", certInfo.signAlgorithm);
                    _addDetailedCertInfo("발급자", certInfo.issuerDN);
                    _addDetailedCertInfo("유효 기간(시작)", certInfo.notBefore);
                    _addDetailedCertInfo("유효 기간(끝)", certInfo.notAfter);
                    _addDetailedCertInfo("주체", certInfo.subjectDN);
                    _addDetailedCertInfo("공개키", certInfo.pubKey);

                    _addDetailedCertInfo("기관 키 식별자", certInfo.authorityKeyId);
                    _addDetailedCertInfo("주체 키 식별자", certInfo.subjectKeyId);
                    _addDetailedCertInfo("주체 대체 이름", certInfo.subjectAltName);
                    /*_addDetailedCertInfo("발급자 대체 이름", certInfo.issuerOrg);*/
                    _addDetailedCertInfo("CRL 배포 지점", certInfo.dp);
                    _addDetailedCertInfo("기관 정보 엑세스", certInfo.authorityInfoAccessOCSP);
                    _addDetailedCertInfo("인증서 정책", certInfo.policyOid);
                    _addDetailedCertInfo("키 사용", certInfo.keyUsage);

                    /**********************************************/
                    /* 인증서 자세히 보기에 필드와 값을 추가하는 함수 */
                    /**********************************************/
                    function _addDetailedCertInfo(field, value) {
                        var rowElement = $("<tr />", {
                            click: function () {
                                $("#" + prop.id.tabDetail + " tbody").find("tr").removeClass(prop.cs.certSelectedRow);
                                $(this).addClass(prop.cs.certSelectedRow);

                                $("#" + prop.id.tabDetail + " textarea").val($(this).find("td").eq(1).text());
                            }
                        });
                        var tdElement = "<td class='" + prop.cs.certTableCell + "'>"
                            + "<img src='" + prop.ROOT_DIR + "/img/itemimg.png'/>"
                            + field
                            + "</td><td class='" + prop.cs.wrdNormal + " "+ prop.cs.certTableCell + "'>"
                            + value
                            + "</td>";

                        rowElement.append(tdElement);

                        $("#" + prop.id.tabDetail + " tbody").append(rowElement);

                        rowElement.css("cursor", "pointer");
                    }
                }, true);
            };

            /* PKCS11 Get Certificate List */
            function _getPkcs11CertList(secTokenProg) {

                if (secTokenProg == undefined) {
                    return;
                }

                reqCertListInfo.media = prop.media.pkcs11;
                reqCertListInfo.drive = -1;
                reqCertListInfo.secTokProg = secTokenProg;

                _getCertList(function() {
                    alert(prop.strings.NOT_CONNECTED_PKCS11);
                });
            }
        }

        /**
         * Certificate Dialog Class
         */
        function _certDialogManager() {
            /* Cert Dialog */
            var certDlg = _makeDialog({
                id: prop.id.dialog.cert,
                mainTitle: true,
                width: 450,
                height: 560,
                open: function (options) {
                    //$(".kc-dialog-titlebar").css("display", "none");
                    $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val("");

                    if (options.service == "sign") {
                        _setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }

                                switch(certInfo.media) {
                                    case prop.media.hardDisk:
                                    case prop.media.removableDisk:
                                        var certPw = $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val();

                                        if (certPw.length <= 0) {
                                            alert(prop.strings.NO_INPUT_PASSWORD);
                                            return;
                                        }

                                        var signObj = {
                                            algorithm: options.algorithm,
                                            keybit: options.keybit,
                                            hash: options.hash,
                                            input: util.encode64(util.encodeUtf8(options.input))
                                        };

                                        comm.reqGenSignData(certInfo, certPw, signObj, function (result) {
                                            _signResult(result);
                                        }, true);
                                        break;
                                    case prop.media.pkcs11:
                                        pinDialog.open();
                                        pinDialog.setConfirmBtn(function() {
                                            var signObj = {
                                                progName: p11DlgManager.getSelectedName(),
                                                pinPw: pinDialog.getPassword(),
                                                input: util.encode64(util.encodeUtf8(options.input))
                                            };
                                            comm.reqSignDataPkcs11(certInfo, signObj, function(result) {
                                                pinDialog.close();
                                                _signResult(result);
                                            }, true);
                                        });
                                        break;
                                }

                                function _signResult(result) {
                                    var status = result.Status;

                                    if (status != prop.success) {
                                        options.error(result.Status, prop.getErrorMsg(result.Status));
                                    } else {
                                        certDlg.close();
                                        options.success(result.Output);
                                    }
                                }
                            },
                            show: true,
                            name: "확인"
                        });
                    } else if(options.service == "vid") {
                        _setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }

                                var certPw = $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val();

                                if (certPw.length <= 0) {
                                    alert(prop.strings.NO_INPUT_PASSWORD);
                                    return;
                                }

                                comm.reqVerifyVidInfo(certInfo, certPw, options, function (result) {
                                    var status = result.Status;

                                    if (status != prop.success) {
                                        options.error(result.Status, prop.getErrorMsg(result.Status));
                                    } else {
                                        options.success(result.Output);
                                        certDlg.close();
                                    }
                                }, true);
                            },
                            show: true,
                            name: "확인"
                        });
                    } else if(options.service == "vidASP") {
                    	/* 2017-09-13 DYLEE ASP vid 검증 함수 추가 */
                        _setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }
																switch(certInfo.media) {
                                    case prop.media.hardDisk:
                                    case prop.media.removableDisk:
                               				var certPw = util.getInputPassword(prop.id.dialog.cert);

																			if(!util.verifyInputPassword(certPw, certInfo.media)) {
								                            return;
								                      }
								                      function ASP_vidResult(result) {
							                            var status = result.Status;
							
							                            if (status != prop.success) {
							                                options.error(result.Status, prop.getErrorMsg(result.Status));
							                            } else {
							                                certDlg.close();
							                                options.success(result.Output);
							                            }
							                        }
							                        function ASP_callVidRequest() {
							                            comm.ASP_reqVerifyVidInfo(certInfo, certPw, options.vid, options.vidopt, function (result) {
							                                ASP_vidResult(result);
							                            }, false);
							                        }
                	                    function ASP_vidProcess() {
								                        if (!prop.isSaveServerCert) {
								                            comm.setEnvCert(options.peerCert, function(response) {
								                                if (response.Status == prop.success) {
								                                    prop.isSaveServerCert = true;
								                                    ASP_callVidRequest();
								                                } else {
								                                    options.error(response.Status, prop.getErrorMsg(response.Status));
								                                }
								                            }, true);
								                        } else {
								                            ASP_callVidRequest();
								                        }					                        
							                     		}
							                     		ASP_vidProcess();
																			break;
                                    case prop.media.pkcs11:
                                        break;
                                }
                            },
                            show: true,
                            name: "확인"

                        });
                    } else if(options.service == "env") {
                        _setDefault(prop.selectCertOpt.CERTLIST_ENC_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }

                                var certPw = $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val();

                                if (certPw.length <= 0) {
                                    alert(prop.strings.NO_INPUT_PASSWORD);
                                    return;
                                }

                                var envObj = {
                                    mode: options.mode,
                                    algorithm: options.algorithm,
                                    certPw: certPw,
                                    input: options.input
                                };

                                if(envObj.mode == kcaseagt.mode.encrypt) {
                                    envObj.input = util.encode64(util.encodeUtf8(envObj.input));
                                }

                                comm.reqEnvelopedData(certInfo, envObj, function(result) {
                                    var status = result.Status;

                                    if(status != prop.success) {
                                        options.error(result.Status, prop.getErrorMsg(result.Status));
                                    } else {
                                        if(envObj.mode == kcaseagt.mode.decrypt) {
                                            result.Output = util.decodeUtf8(util.decode64(result.Output));
                                        }
                                        options.success(result.Output);
                                        certDlg.close();
                                    }
                                }, true);
                            },
                            show: true,
                            name: "확인"
                        });
                    } else if (options.service == "admin") {
                        _setAdmin();
                    } else if (options.service == "login") {
                        _setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }

                                switch(certInfo.media) {
                                    case prop.media.hardDisk:
                                    case prop.media.removableDisk:
                                        var certPw = $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val();

                                        if (certPw.length <= 0) {
                                            alert(prop.strings.NO_INPUT_PASSWORD);
                                            return;
                                        }

                                        var loginObj = {
                                            peerCert: options.peerCert,
                                            vid: options.vid,
                                            input: util.encode64(util.encodeUtf8(options.input))
                                        };

                                        comm.reqCertLogin(certInfo, certPw, loginObj, function(result) {
                                            var status = result.Status;

                                            if(status == prop.success) {
                                                certDlg.close();
                                                options.success(result.Output);
                                            } else {
                                                options.error(status, prop.getErrorMsg(status));
                                            }
                                        }, true);

                                        break;
                                    case prop.media.pkcs11:
                                        /*pinDialog.open();
                                        pinDialog.setConfirmBtn(function() {
                                            var signObj = {
                                                progName: p11DlgManager.getSelectedName(),
                                                pinPw: pinDialog.getPassword(),
                                                input: util.encode64(util.encodeUtf8(options.input))
                                            };
                                            comm.reqSignDataPkcs11(certInfo, signObj, function(result) {
                                                pinDialog.close();
                                                _signResult(result);
                                            }, true);
                                        });*/
                                        break;
                                }
                            },
                            show: true,
                            name: "확인"
                        });
                    }  else if (options.service == "loginASP") {
                    	/* 2017-09-13 DYLEE ASP 함수 추가 */
                        _setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }

                                switch(certInfo.media) {
                                    case prop.media.hardDisk:
                                    case prop.media.removableDisk:
																				var certPw = util.getInputPassword(prop.id.dialog.cert);

								                        if(!util.verifyInputPassword(certPw, certInfo.media)) {
								                            return;
								                        }
								                        function ASP_callLoginRequest() {
		                                        var loginObj = {
		                                            peerCert: options.peerCert,
		                                            vid: options.vid,
		                                            input: util.encode64(util.encodeUtf8(options.input))
		                                        };
								                            comm.ASP_reqCertLogin(certInfo, certPw, loginObj, function(result) {
								                                var status = result.Status;
								
								                                if(status == prop.success) {
								                                    certDlg.close();
								                                    options.success(result.Output);
								                                } else {
								                                    options.error(status, prop.getErrorMsg(status));
								                                }
								                            }, true);
								                        }

										                    function ASP_loginProcess() {
										                        if (!prop.isSaveServerCert) {
										                            comm.setEnvCert(options.peerCert, function(response) {
										                                if (response.Status == prop.success) {
										                                    prop.isSaveServerCert = true;
										                                    ASP_callLoginRequest();
										                                } else {
										                                    options.error(response.Status, prop.getErrorMsg(response.Status));
										                                }
										                            }, true);
										                        } else {
										                            ASP_callLoginRequest();
										                        }
										                    }
										                    ASP_loginProcess();
                                        break;
                                    case prop.media.pkcs11:
                                        /*pinDialog.open();
                                        pinDialog.setConfirmBtn(function() {
                                            var signObj = {
                                                progName: p11DlgManager.getSelectedName(),
                                                pinPw: pinDialog.getPassword(),
                                                input: util.encode64(util.encodeUtf8(options.input))
                                            };
                                            comm.reqSignDataPkcs11(certInfo, signObj, function(result) {
                                                pinDialog.close();
                                                _signResult(result);
                                            }, true);
                                        });*/
                                        break;
                                }
                            },
                            show: true,
                            name: "확인"
                        });
                    } else if (options.service == "secLogin") {
                        _setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                                }

                                switch(certInfo.media) {
                                    case prop.media.hardDisk:
                                    case prop.media.removableDisk:
                                    		// 2017.08.02 DYLEE 채널보안 암복호화 동시 수행 기능 추가
																				var certPw = util.getInputPassword(prop.id.dialog.cert);

								                        if(!util.verifyInputPassword(certPw, certInfo.media)) {
								                            return;
								                        }
																				function _secLoginProcess() {
										                        if (!prop.isSaveServerCert) {
										                            comm.setEnvCert(options.peerCert, function(response) {
										                                if (response.Status == prop.success) {
										                                    prop.isSaveServerCert = true;
										                                    _callLoginProc();
										                                } else {
										                                    options.error(response.Status, prop.getErrorMsg(response.Status));
										                                }
										                            }, true);
										                        } else {
										                            _callLoginProc();
										                        }
										                    }
								
								                        function _callLoginProc() {
								                            comm.reqSecChannelLogin(certInfo, certPw, options.algorithm, function(result) {
								                                var status = result.Status;
								
								                                if(status == prop.success) {
								                                    certDlg.close();
								                                    options.success(result.Output);
								                                } else {
								                                    options.error(status, prop.getErrorMsg(status));
								                                }
								                            }, true);
								                        }
								                        
								                        _secLoginProcess();

                                        break;
                                    case prop.media.pkcs11:
                                        /*pinDialog.open();
                                        pinDialog.setConfirmBtn(function() {
                                            var signObj = {
                                                progName: p11DlgManager.getSelectedName(),
                                                pinPw: pinDialog.getPassword(),
                                                input: util.encode64(util.encodeUtf8(options.input))
                                            };
                                            comm.reqSignDataPkcs11(certInfo, signObj, function(result) {
                                                pinDialog.close();
                                                _signResult(result);
                                            }, true);
                                        });*/
                                        break;
                                }
                            },
                            show: true,
                            name: "확인"
                        });
                      } else if (options.service == "secLoginASP") {
												/*2017-09-13 DYLEE ASP 함수 수정*/
                    		_setDefault(prop.selectCertOpt.CERTLIST_ALL);
                        certDlg.setBottomBtns(0, {
                            event: function () {
                                var certInfo = certManager.checkSelectedCert();

                                if (certInfo == undefined) {
                                    alert(prop.strings.NOT_SELECTED_CERT);
                                    return;
                      }

                                switch(certInfo.media) {
                                    case prop.media.hardDisk:
                                    case prop.media.removableDisk:
																				var certPw = util.getInputPassword(prop.id.dialog.cert);

								                        if(!util.verifyInputPassword(certPw, certInfo.media)) {
								                            return;
								                        }
									                      function ASP_callLoginProc() {
									                          comm.ASP_reqSecChannelLogin(certInfo, certPw, options.algorithm, function(result) {
									                              var status = result.Status;
									
									                              if(status == prop.success) {
									                                  certDlg.close();
									                                  options.success(result.Output);
									                              } else {
									                                  options.error(status, prop.getErrorMsg(status));
									                              }
									                          }, true);
									                      }
										                    function ASP_secLoginProcess() {
										                        if (!prop.isSaveServerCert) {
										                            comm.setEnvCert(options.peerCert, function(response) {
										                                if (response.Status == prop.success) {
										                                    prop.isSaveServerCert = true;
										                                    ASP_callLoginProc();
										                                } else {
										                                    options.error(response.Status, prop.getErrorMsg(response.Status));
										                                }
										                            }, true);
										                        } else {
										                            ASP_callLoginProc();
										                        }
										                    }
							                        
								                        ASP_secLoginProcess();

                                        break;
                                    case prop.media.pkcs11:
                                        /*pinDialog.open();
                                        pinDialog.setConfirmBtn(function() {
                                            var signObj = {
                                                progName: p11DlgManager.getSelectedName(),
                                                pinPw: pinDialog.getPassword(),
                                                input: util.encode64(util.encodeUtf8(options.input))
                                            };
                                            comm.reqSignDataPkcs11(certInfo, signObj, function(result) {
                                                pinDialog.close();
                                                _signResult(result);
                                            }, true);
                                        });*/
                                        break;
                                }
                            },
                            show: true,
                            name: "확인"
                      });
	           	     }
										// 2017.08.01 DYLEE 채널보안 로그인 동시수행을 위한 Javascript 함수 추가

                    /* Click hard disk after dialog open */
                    $("#" + prop.id.certPosTable).find("button").eq(0).click();
                },
                close: function () {
                    $(".kc-dialog-titlebar").css("display", "block");
                }
            });
            certDlg.setBottomBtns(1, {
                event: function () {
                    certDlg.close();
                },
                show: true
            });

            var certPwInput = $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox);

            certPwInput.keypress(function(event) {
                if ( event.which == 13 ) {
                    $("#" + prop.id.dialog.cert + " ." + prop.cs.btnLayout).find("button").eq(0).click();
                    return;
                }
            });

            function _reqDeleteCert() {
                var certInfo = certManager.checkSelectedCert();

                if (certInfo == undefined) {
                    alert(prop.strings.NOT_SELECTED_CERT);
                } else {
                    if (confirm(prop.strings.CONFIRM_DELETE)) {
                        var pw = "";

                        function _deleteCert() {
                            comm.reqDeleteCert(certInfo, pw, function (result) {
                                var status = result.Status;

                                if (!status) {
                                    alert(prop.strings.CERT_DELETE_SUCCESS);
                                    certManager.getCertList();
                                    pinDialog.close();
                                } else {
                                    var errMsg = prop.getErrorMsg(result.Status);
                                    alert(errMsg);
                                }
                            }, true);
                        }

                        if(certInfo.media == prop.media.pkcs11) {
                            pinDialog.open();
                            pinDialog.setConfirmBtn(function() {
                                pw = pinDialog.getPassword();
                                _deleteCert();
                            });
                        } else {
                            _deleteCert();
                        }
                        // 2017.08.21 DYLEE FireFox 구 버전(For Linux Agent)에서 정상작동 하지 않는 현상으로 Local Function 위치를 호출부분 상위로 변경
                    }
                }
            }

            /* Set event - default content */
            var contentBtnList = $("#" + prop.id.content.cert).find("button");
            contentBtnList.off("click");
            contentBtnList.eq(0).click(function () {     // View Certificate
                var certInfo = undefined;
                certInfo = certManager.checkSelectedCert();
                if (certInfo != undefined) {
                    _getDialog(prop.id.dialog.viewCert).open(certInfo);
                } else {
                    alert(prop.strings.NOT_SELECTED_CERT);
                }
            });
            contentBtnList.eq(1).click(function () {     // Validate Certificate
                var certInfo = undefined;
                certInfo = certManager.checkSelectedCert();
                if (certInfo != undefined) {
                    comm.reqCertVerify(certInfo, function (result) {
                        if (result.Status == prop.success) {
                            alert(prop.strings.CERT_VAL_SUCCESS);
                        } else {
                            var errMsg = prop.getErrorMsg(result.Status);
                            alert(errMsg);
                        }
                    });
                } else {
                    alert(prop.strings.NOT_SELECTED_CERT);
                }
            });
            contentBtnList.eq(2).click(function () {     // Delete Certificate
                _reqDeleteCert();
            });

            /**
             *  Set event - admin content
             */
            /* Cert Type */
            var certTypeSelect = $("#" + prop.id.certType).find("select");
            certTypeSelect.change(function () {
                var curCertOpt = certManager.getCertOption();
                if (certTypeSelect.val() === 'sign') {
                    certManager.setCertOption(curCertOpt + 0x0400);
                    certManager.getCertList();
                } else if (certTypeSelect.val() === 'enc') {
                    certManager.setCertOption(curCertOpt - 0x0400);
                    certManager.getCertList();
                }
            });
            /* Cert Authority */
            var certAuthority = $("#" + prop.id.certCa).find("select");
            certAuthority.change(function () {
                var caIndex = certAuthority.find("option").index(certAuthority.find("option:selected"));
                var opt = caIndex << 16;
                var curCertOpt = certManager.getCertOption();
                curCertOpt = curCertOpt & 0x00FFFF;
                certManager.setCertOption(curCertOpt | opt);
                certManager.getCertList();
            });
            /* Admin button event List */
            var adminBtnList = $("#" + prop.id.content.admin).find("button");
            adminBtnList.off("click");
            adminBtnList.eq(0).click(function () {     // Copy Certificate
            	// 2017.08.21 DYLEE Agent에서 인증서 복사 기능이 완료되지 않아 해당 기능 막기위한 메세지 창 출력 추가
            		alert("해당 기능은 사용 할 수 없습니다");
            		return;

                function _certificateCopy(media, drive) {
                    var copyMediaInfo = {
                        toMedia: media,
                        toDrive: drive
                    };
                    var pw = pwDialog.getPassword();

                    if(pw.length <= 0) {
                        alert(prop.strings.NO_INPUT_PASSWORD);
                        return;
                    }

                    if(copyMediaInfo.toDrive != -1) {
                        comm.reqCopyCert(certInfo, copyMediaInfo, pw, function (result) {
                            if (result.Status != prop.success) {
                                alert(prop.getErrorMsg(result.Status));
                            } else {
                                alert(prop.strings.CERT_COPY_SUCCESS);
                                pwDialog.close();
                                selDriveDlg.close();
                                selectMediaDlg.close();
                            }
                            var mediaList = $("#" + prop.id.dialog.media + " tr").eq(1);
                            mediaList.find("td").find("button").attr("disabled", false);
                        }, true);
                    } else {
                        var p11Obj = {
                            progName: p11DlgManager.getSelectedName(),
                            certPw: pw,
                            pinPw: pinDialog.getPassword()
                        };

                        comm.reqCopyCertSecToken(certInfo, p11Obj, function(result) {
                            if (result.Status != prop.success) {
                                alert(prop.getErrorMsg(result.Status));
                            } else {
                                alert(prop.strings.CERT_COPY_SUCCESS);
                                p11DlgManager.close();
                                pwDialog.close();
                                pinDialog.close();
                                selDriveDlg.close();
                                selectMediaDlg.close();
                            }
                            var mediaList = $("#" + prop.id.dialog.media + " tr").eq(1);
                            mediaList.find("td").find("button").attr("disabled", false);
                        }, true);
                    }


                }

                var certInfo = undefined;
                certInfo = certManager.checkSelectedCert();
                if (certInfo != undefined) {

                    var mediaList = $("#" + prop.id.dialog.media + " tr").eq(1);
                    mediaList.find("td").find("button").attr("disabled", false);

                    if (certInfo.media == prop.media.hardDisk) {
                        mediaList.find("td").eq(0).find("button").attr("disabled", true);
                    }
                    else if (certInfo.media == prop.media.pkcs11) {
                        mediaList.find("td").eq(2).find("button").attr("disabled", true);
                    }

                    selectMediaDlg.open();
                    selectMediaDlg.setConfirmBtn(function () {
                        switch (selectMediaDlg.getSelectedIdx()) {
                            case prop.media.hardDisk:
                                pwDialog.open();
                                pwDialog.setConfirmBtn(function () {
                                    _certificateCopy(prop.media.hardDisk, 0);
                                });
                                break;
                            case prop.media.removableDisk:
                                selDriveDlg.setConfirmBtn(function () {
                                    pwDialog.open();
                                    pwDialog.setConfirmBtn(function () {
                                        _certificateCopy(prop.media.removableDisk, selDriveDlg.getSelectedDrive());
                                    });
                                });
                                selDriveDlg.setCancelBtn(function () {
                                    selDriveDlg.close();
                                });
                                selDriveDlg.open();
                                break;
                            case prop.media.pkcs11:
                                p11DlgManager.open();
                                p11DlgManager.setConfirmBtn(function () {
                                    pwDialog.open();
                                    pwDialog.setConfirmBtn(function () {
                                        pinDialog.open();
                                        pinDialog.setConfirmBtn(function () {
                                            _certificateCopy(prop.media.pkcs11, -1);
                                        });
                                    });
                                });
                                break;
                        }
                    });
                    selectMediaDlg.setCancelBtn(function () {
                        selectMediaDlg.close();
                    });
                } else {
                    alert(prop.strings.NOT_SELECTED_CERT);
                }
            });
            adminBtnList.eq(1).click(function () {     // Change Password
                var certInfo = undefined;
                certInfo = certManager.checkSelectedCert();
                if (certInfo != undefined) {
                    changePwDlg.open();
                } else {
                    alert(prop.strings.NOT_SELECTED_CERT);
                }
            });
            adminBtnList.eq(2).click(function () {     // Delete Certificate
                _reqDeleteCert();
            });
            adminBtnList.eq(3).click(function () {     // PKCS12
            // 2017.08.21 DYLEE Agent에서 인증서 복사 기능이 완료되지 않아 해당 기능 막기위한 메세지 창 출력 추가
            		alert("해당 기능은 사용 할 수 없습니다");
            		return;
                _getDialog(prop.id.dialog.pkcs12).open();
            });
            adminBtnList.eq(4).click(function () {     // View & Verify Certificate
                var certInfo = undefined;
                certInfo = certManager.checkSelectedCert();
                if (certInfo != undefined) {
                    _getDialog(prop.id.dialog.viewCert).open(certInfo);
                } else {
                    alert(prop.strings.NOT_SELECTED_CERT);
                }
            });
            adminBtnList.eq(5).click(function () {     // Product Information
                pInfoDlg.open();
            });

            function _modeSetting(option) {
                var options = {
                    title: "",
                    certOpt: prop.selectCertOpt.CERTLIST_ALL,
                    height: 560,
                    cert: false,
                    admin: false,
                    certType: false,
                    certCa: false,
					vid:""
                };

                /* Remove loaded Certificate List */
                $("#kc_cert_list tbody").find("tr").remove();

                /* 옵션 파라미터 처리 */
                if (option !== undefined) {
                    util.setOption(options, option);
                }

                /* Set Dialog Title */
                certDlg.setTitle(options.title);

                /* Set Certificate List mode option */
                certManager.setCertOption(options.certOpt);

                /* Set Dialog Height */
                certDlg.setHeight(options.height);

                /* Set Default Dialog Display Mode */
                $("#" + prop.id.content.cert).css("display", "none");
                $("#" + prop.id.content.admin).css("display", "none");
                $("#" + prop.id.certType).css("display", "none");
                $("#" + prop.id.certCa).css("display", "none");

                if (options.cert) {
                    $("#" + prop.id.content.cert).css("display", "block");
                }
                if (options.admin) {
                    $("#" + prop.id.content.admin).css("display", "block");
                }
                if (options.certType) {
                    $("#" + prop.id.certType).css("display", "block");
                }
                if (options.certCa) {
                    $("#" + prop.id.certCa).css("display", "block");
                }
            }

            /* Cert Dialog Mode */
            var _setDefault = function (certOpt) {
                _modeSetting({
                    title: prop.title.cert,
                    certOpt: certOpt,
                    height: 560,
                    cert: true,
                    admin: false,
                    certType: false,
                    certCa: false
                });

                certDlg.setBottomBtns(1, {
                    event: function () {
                        certDlg.close();
                        prop.CANCEL_DIALOG();
                    },
                    show: true,
                    name: "취소"
                });
            };

            /* Admin Dialog Mode */
            var _setAdmin = function () {
                _modeSetting({
                    title: prop.title.admin,
                    certOpt: prop.selectCertOpt.ADMIN_CERTLIST_ALL,
                    height: 590,
                    cert: false,
                    admin: true,
                    certType: true,
                    certCa: true
                });

                certDlg.setBottomBtns(0, {
                    show: false
                });
                certDlg.setBottomBtns(1, {
                    event: function () {
                        certDlg.close();
                        prop.CANCEL_DIALOG();
                        /*certDlg.open({
                            service: "sign"
                        });*/
                    },
                    show: true,
                    name: "닫기"
                });
            };
        }

        /**
         * PKCS11 Dialog Manager Class
         */
        function _pkcs11DialogManager() {
            var tableElement = $("#" + prop.id.dialog.pkcs11 + " ." + prop.cs.tableView).find("table");
            var selectedName;
            var p11Dlg = _makeDialog({
                id: prop.id.dialog.pkcs11,
                width: 400,
                height: 350,
                open: function () {
                	prop.isSubView = true;
                    comm.reqSecTokenList(function (result) {
                        $("." + prop.cs.p11List).remove();
                        for (var i = 0; i < result.SecTokList.length; i++) {
                            var row = $("<tr/>");
                            row.addClass(prop.cs.p11List);
                            row.css("cursor", "pointer");
                            var data = $("<td/>");

                            data.text(result.SecTokList[i]);
                            row.append(data);

                            row.click(function () {
                                $(".kc-pkcs11-list").removeClass(prop.cs.certSelectedRow);
                                $(this).addClass(prop.cs.certSelectedRow);
                                selectedName = $(this).text();
                            });

                            tableElement.append(row);
                        }
                    });
                },
                close: function () {

                }
            });
            p11Dlg.setBottomBtns(0, {
                event: function () {
                    window.open(prop.SECURITY_TOKEN_INSTALL_URL);
                }
            });
            p11Dlg.setBottomBtns(2, {
                event: function () {
                    p11Dlg.close();
                    prop.CANCEL_SUB_DIALOG();
                    prop.isSubView = false;
                }
            });
            this.getSelectedName = function() {
                return selectedName;
            };
            this.setConfirmBtn = function (event) {
                p11Dlg.setBottomBtns(1, {
                    event: event
                });
            };
            this.open = p11Dlg.open;
            this.close = p11Dlg.close;
        }

        function _FileListManager() {
            /* File Dialog */
            var fileDlg = _makeDialog({
                id: prop.id.dialog.file,
                width: 735,
                height: 480,
                open: function (m) {
                    _init(m);
                },
                close: function () {
                }
            });

            var curPath;
            var dirMenu = $("#" + prop.id.dialog.file + " ." + prop.cs.mediaList).find("table");
            var dirTable = $("#" + prop.id.dialog.file + " ." + prop.cs.fileList).find("table");
            var curPathElement = $("#" + prop.id.dialog.file + " .txt-url");
            var changeDirBtn = $("#" + prop.id.dialog.file + " .file-url").find("button");
            var fileNameElement = $("#" + prop.id.dialog.file + " .filename-url").find("input");
            var mode = prop.pkcs12.exportCert;

            fileDlg.setBottomBtns(0, {
                event: function () {
                    var fileValue = fileNameElement.val();
                    if (fileValue.length <= 0) {
                        alert(prop.strings.NOT_SELECTED_FILE);
                    } else {
                        $("#pkcs12_file_name").val(fileValue);
                        fileDlg.close();
                    }
                }
            });
            fileDlg.setBottomBtns(1, {
                event: function () {
                    $("#pkcs12_file_name").val("");
                    fileDlg.close();
                    prop.CANCEL_SUB_DIALOG();
                    prop.isSubView = false;
                }
            });

            changeDirBtn.click(function () {
                var dirTable = $("#" + prop.id.dialog.file + " ." + prop.cs.fileList).find("table");
                var firstRow = dirTable.find("tr:first");
                var firstFile = firstRow.data("fileName");
                if (firstFile == "..") {
                    firstRow.click();
                }
            });

            var _init = this.init = function (m) {
            	prop.isSubView = true;
                curPathElement.val("");
                fileNameElement.val("");
                dirMenu.find("tr").remove();
                dirTable.find("tr").remove();

                fileNameElement.val("");
                mode = m;

                _reqSelectList("내 문서", "icon_folder.png", "Documents");
                _reqSelectList("바탕 화면", "icon_folder.png", "Desktop");

                comm.reqRemovableDiskList(function (result) {
                    for (var i = 0; i < result.DriveList.length; i++) {
                        //result.DriveList[i] = kswebkit.forge.util.decodeUtf8(result.DriveList[i]);
                        result.DriveList[i] = util.decodeUtf8(util.decode64(result.DriveList[i]));
                        var str = result.DriveList[i].substr(1, result.DriveList[i].length) + " (" + result.DriveList[i].charAt(0) + ":)";
                        _reqSelectList(str, "icon_removable_2.png", result.DriveList[i].charAt(0) + ":");
                    }
                });
            };

            var _reqSelectList = function (name, imgName, path) {
                var tr = $("<tr/>");
                var td = $("<td/>");
                var a = $("<a></a>");
                var span = $("<span></span>");
                span.css("background-image", "url(" + prop.ROOT_DIR + "/img/" + imgName + ")");

                tr.data("path", path);

                tr.click(function () {
                    dirMenu.find("tr").removeClass(prop.cs.certSelectedRow);
                    $(this).addClass(prop.cs.certSelectedRow);
                    var dirTable = $("#" + prop.id.dialog.file + " ." + prop.cs.fileList).find("table");
                    dirTable.find("tr").remove();
                    var reqPath = $(this).data("path");
                    reqPath = util.encode64(util.encodeUtf8(reqPath));
                    comm.reqDirectoryList(reqPath, function (result) {
                        curPath = util.decodeUtf8(util.decode64(result.CurPath));
                        curPathElement.val(curPath);
                        for (var i = 0; i < result.DirList.length; i++) {
                            var fileName = util.decodeUtf8(util.decode64(result.DirList[i]));
                            _appendDirList(fileName);
                        }
                        if (mode == prop.pkcs12.exportCert) {
                            var certInfo = certManager.checkSelectedCert();
                            fileNameElement.val(curPath + "/" + certInfo.subjectCN + ".pfx");
                        }
                    });
                });

                a.append(span);
                a.append(name);
                td.append(a);
                tr.append(td);
                dirMenu.append(tr);
            };

            function _appendDirList(fileName) {
                var imgName, isDir;
                var splitArray = fileName.split(".");

                if (splitArray[splitArray.length - 1] == "pfx") {
                    imgName = "itemimg.png";
                    isDir = false;
                } else {
                    imgName = "icon_folder.png";
                    isDir = true;
                }

                var tr = $("<tr/>");
                var td = $("<td/>");
                var a = $("<a></a>");
                var span = $("<span></span>");
                span.css("background-image", "url(" + prop.ROOT_DIR + "/img/" + imgName + ")");

                tr.data("fileName", fileName);
                tr.data("isDir", isDir);

                if (fileName == "..") {
                    tr.css("display", "none");
                }

                tr.click(function () {
                    dirTable.find("tr").removeClass(prop.cs.certSelectedRow);
                    $(this).addClass(prop.cs.certSelectedRow);
                    var selectedFileName = $(this).data("fileName");
                    var isDir = $(this).data("isDir");
                    var reqPath = curPath + "/" + selectedFileName;
                    if (isDir) {
                        reqPath = util.encode64(util.encodeUtf8(reqPath));
                        comm.reqDirectoryList(reqPath, function (result) {
                            dirTable.find("tr").remove();
                            curPath = util.decodeUtf8(util.decode64(result.CurPath));
                            curPathElement.val(curPath);
                            for (var i = 0; i < result.DirList.length; i++) {
                                var fileName = util.decodeUtf8(util.decode64(result.DirList[i]));
                                _appendDirList(fileName);
                            }
                            if (mode == prop.pkcs12.exportCert) {
                                var certInfo = certManager.checkSelectedCert();
                                fileNameElement.val(curPath + "/" + certInfo.subjectCN + ".pfx");
                            }
                        });
                    } else {
                        if (mode == prop.pkcs12.importCert) {
                            fileNameElement.val(reqPath);
                        } else if (mode == prop.pkcs12.exportCert) {
                            fileNameElement.val(curPath + "/" + selectedFileName);
                        }
                    }
                });

                a.append(span);
                a.append(fileName);
                td.append(a);
                tr.append(td);
                dirTable.append(tr);
            }

            this.open = fileDlg.open;
            this.close = fileDlg.close;
        }

        /**
         * Select Media Dialog Manager Base Class
         *
         */
        function _SelectMediaDialogManagerBase() {
            var selMediaIdx = 0;
            var posBtnList = $("#" + prop.id.dialog.media).find("tbody button");
            /* Select Media Dialog */
            var selMediaDlg = _makeDialog({
                id: prop.id.dialog.media,
                height: 250,
                open: function () {
                },
                close: function () {
                }
            });
            posBtnList.click(function () {
            	prop.isSubView = true;
                posBtnList.removeClass(prop.cs.btnPressed).addClass(prop.cs.btnNormal);
                $(this).removeClass(prop.cs.btnNormal).addClass(prop.cs.btnPressed);
                selMediaIdx = posBtnList.index($(this));
            });
            this.getSelectedIdx = function () {
                return selMediaIdx;
            };
            this.setConfirmBtn = function (event) {
                selMediaDlg.setBottomBtns(0, {
                    event: event
                });
            };
            this.setCancelBtn = function (event) {
                selMediaDlg.setBottomBtns(1, {
                    event: event
                });
            };
            this.open = function () {
                selMediaDlg.open();
            };
            this.close = function () {
                selMediaDlg.close();
		            prop.CANCEL_SUB_DIALOG();
								prop.isSubView = false;
            };
        }

        /**
         * Select Drive Manager Dialog Class
         *
         */
        function _SelectDriveDialog() {
            var selDialog = _makeDialog({
                id: prop.id.dialog.drive,
                width: 400,
                height: 200,
                open: function () {
                	prop.isSubView = true;
                    comm.reqRemovableDiskList(function (result) {
                        var certInfo, selDrive;
                        certInfo = certManager.checkSelectedCert();
                        if (certInfo == undefined) {
                            selDrive = 0;
                        } else {
                            selDrive = certInfo.drive;
                        }
                        var i;
                        var sel = $("#" + prop.id.dialog.drive + " select");

                        sel.find("option").remove();

                        if (result.DriveList.length == 0) {
                            alert(prop.strings.NOT_EXIST_DISK);
                            selDriveDlg.close();
                        }

                        for (i = 0; i < result.DriveList.length; i++) {
                            result.DriveList[i] = util.decodeUtf8(util.decode64(result.DriveList[i]));
                            var drive = result.DriveList[i].charAt(0);
                            if (drive.charCodeAt(0) != selDrive) {
                                var optElement = $("<option/>");
                                optElement.text(result.DriveList[i].substr(1, result.DriveList[i].length) + " (" + result.DriveList[i].charAt(0) + ":)");
                                optElement.data("drive", result.DriveList[i].charAt(0));
                                sel.append(optElement);
                            }
                        }
                    });
                }
            });
            this.getSelectedDrive = function () {
                var sel = $("#" + prop.id.dialog.drive + " select");
                var selected = sel.find("option:selected");
                var drive = selected.data("drive");
                return drive.charCodeAt(0);
            };
            this.setConfirmBtn = function (event) {
                selDialog.setBottomBtns(0, {
                    event: event
                });
            };
            this.setCancelBtn = function (event) {
                selDialog.setBottomBtns(1, {
                    event: event
                });
            };
            this.open = function () {
                selDialog.open();
            };
            this.close = function () {
                selDialog.close();
    	          prop.CANCEL_SUB_DIALOG();
								prop.isSubView = false;
            };
        }

        /**
         * Input Password Dialog Class
         *
         */
        function _InputPasswordDialog() {
            var pwBox = $("#" + prop.id.dialog.pw).find("input");
            /* Input Password Dialog */
            var pwDlg = _makeDialog({
                id: prop.id.dialog.pw,
                width: 360,
                height: 200,
                open: function() {
                    pwBox.val("");
                },close: function() {
                    pwBox.val("");
                }
            });
            this.getPassword = function () {
                return pwBox.val();
            };
            this.setConfirmBtn = function (event) {
                pwDlg.setBottomBtns(0, {
                    event: event
                });
            };
            this.open = pwDlg.open;
            this.close = pwDlg.close;
        }

        /**
         * Input Pin Dialog Class
         */
        function _InputPinDialog() {
            var pinBox = $("#" + prop.id.dialog.pin).find("input");

            /* Input Pin Dialog */
            var pinDlg = _makeDialog({
                id: prop.id.dialog.pin,
                width: 360,
                height: 200,
                open: function() {
                    pinBox.val("");
                    prop.isSubView = true;
                },
                close: function () {
                    pinBox.val("");
                }
            });
            this.getPassword = function () {
                return pinBox.val();
            };
            this.setConfirmBtn = function (event) {
                pinDlg.setBottomBtns(0, {
                    event: event
                });
            };
            pinDlg.setBottomBtns(1, {
                event: function() {
                    pinDlg.close();
                    prop.CANCEL_SUB_DIALOG();
                    prop.isSubView = false;
                }
            });
            this.open = pinDlg.open;
            this.close = pinDlg.close;
        }

        /* Cert Manager */
        var certManager = new _CertListManagerBase();

        var certDlg = new _certDialogManager();

        /* Cert View Dialog */
        var certViewDlg = _makeDialog({
            id: prop.id.dialog.viewCert,
            width: 450,
            height: 580,
            open: function (certInfo) {
            	 prop.isSubView = true;
                certManager.viewCertificate(certInfo);
            },
            close: function () {
            }
        });
        certViewDlg.setBottomBtns(0, {
            event: function () {
                certViewDlg.close();
                prop.CANCEL_SUB_DIALOG();
                prop.isSubView = false;                    
            },
            name: "닫기",
            show: true
        });

        /* Change Certificate Password Dialog */
        var changePwDlg = _makeDialog({
            id: prop.id.dialog.changePw,
            width: 400,
            height: 380,
            open: function () {
                var pwInputList = $("#" + prop.id.dialog.changePw).find("input");
                pwInputList.val("");
                prop.isSubView = true;
            },
            close: function () {
            }
        });
        changePwDlg.setBottomBtns(0, {
            event: function () {
                var pwInputList = $("#" + prop.id.dialog.changePw).find("input");
                var curPw, pw1, pw2;

                curPw = pwInputList.eq(0).val();
                pw1 = pwInputList.eq(1).val();
                pw2 = pwInputList.eq(2).val();

                if (curPw == "") {
                    alert("현재 비밀번호를 입력해주십시오.");
                    pwInputList.eq(0).focus();
                    return;
                } else if (pw1 == "") {
                    alert("새로운 비밀번호를 입력해주십시오.");
                    pwInputList.eq(1).focus();
                    return;
                } else if (pw2 == "") {
                    alert("새로운 비밀번호 확인을 입력해주십시오.");
                    pwInputList.eq(2).focus();
                    return;
                } else {
                    if (pw1 !== pw2) {
                        alert("새로운 비밀번호가 일치하지 않습니다.");
                        return;
                    }
                    var certInfo = certManager.checkSelectedCert();
                    comm.reqChangePassword(certInfo, curPw, pw1, function (result) {
                        if (result.Status == prop.success) {
                            alert(prop.strings.CERT_CHANGE_PASSWORD);
                            pwInputList.val("");
                            changePwDlg.close();
                            prop.CANCEL_SUB_DIALOG();
		                    prop.isSubView = false;                    
                        } else {
                            alert(prop.getErrorMsg(result.Status));
                        }
                    });
                }
            },
            show: true
        });
        changePwDlg.setBottomBtns(1, {
            event: function () {
                changePwDlg.close();
            },
            show: true
        });

        /* PKCS12 Dialog */
        var pkcs12Dlg = _makeDialog({
            id: prop.id.dialog.pkcs12,
            width: 400,
            height: 370,
            open: function () {
            		prop.isSubView = true;
                $("#" + prop.id.p12Name).val("");
            },
            close: function () {
            }
        });

        var seledctedMenu = $("input[name=pkcs12menu]");

        seledctedMenu.eq(0).click(function () {
            var certInfo = certManager.checkSelectedCert();
            if (certInfo == undefined) {
                alert(prop.strings.NOT_SELECTED_CERT);
                seledctedMenu.eq(1).click();
            }
        });
        pkcs12Dlg.setBottomBtns(0, {
            event: function () {
                var seledctedMenu = $("input[name=pkcs12menu]");
                var fileNameElement = $("#" + prop.id.dialog.file + " .filename-url").find("input");
                var filePath = util.encode64(util.encodeUtf8(fileNameElement.val()));
                var certPw;

                if (seledctedMenu.eq(0).prop("checked")) {   /* Export */
                    pwDialog.open();
                    pwDialog.setConfirmBtn(function () {
                        certPw = pwDialog.getPassword();

                        if(certPw.length <= 0) {
                            alert(prop.strings.NO_INPUT_PASSWORD);
                            return;
                        }

                        var certInfo = certManager.checkSelectedCert();
                        comm.reqExportCert(certInfo, filePath, certPw, function (result) {
                            var status = result.Status;
                            if (status == prop.success) {
                                alert(prop.strings.CERT_EXPORT_SUCCESS);
                            } else {
                                alert(prop.getErrorMsg(result.Status));
                            }
                            pwDialog.close();
                            pkcs12Dlg.close();
                        }, true);
                    });
                } else if (seledctedMenu.eq(1).prop("checked")) {    /* Import */
                    var media;
                    var drive;

                    selectMediaDlg.open();
                    selectMediaDlg.setConfirmBtn(function () {
                        media = selectMediaDlg.getSelectedIdx();
                        switch (media) {
                            case prop.media.hardDisk:
                                drive = media;
                                _reqImport();
                                break;
                            case prop.media.removableDisk:
                                selDriveDlg.open();
                                selDriveDlg.setConfirmBtn(function () {
                                    drive = selDriveDlg.getSelectedDrive();
                                    _reqImport();
                                });
                                break;
                            case prop.media.pkcs11:
                                p11DlgManager.open();
                                p11DlgManager.setConfirmBtn(function () {
                                    pwDialog.open();
                                    pwDialog.setConfirmBtn(function () {
                                        certPw = pwDialog.getPassword();
                                        if(certPw.length <= 0) {
                                            alert(prop.strings.NO_INPUT_PASSWORD);
                                            return;
                                        }
                                        pinDialog.open();
                                        pinDialog.setConfirmBtn(function () {
                                            var secTokenData = {
                                                progName: p11DlgManager.getSelectedName(),
                                                certPw: certPw,
                                                pinPw: pinDialog.getPassword()
                                            };
                                            if(secTokenData.pinPw.length <= 0) {
                                                alert(prop.strings.NO_INPUT_PASSWORD);
                                                return;
                                            }
                                            comm.reqImportCertSecToken(filePath, secTokenData, function(result) {
                                                _reqImportResult(result);
                                            }, true);
                                        });
                                    });
                                });
                                break;
                        }

                        function _reqImportResult(result) {
                            var status = result.Status;
                            if (status == prop.success) {
                                alert(prop.strings.CERT_IMPORT_SUCCESS);
                                selectMediaDlg.close();
                                selDriveDlg.close();
                                pwDialog.close();
                                pinDialog.close();
                                pkcs12Dlg.close();
                                p11DlgManager.close();
                            } else {
                                alert(prop.getErrorMsg(result.Status));
                            }
                        }

                        function _reqImport() {
                            pwDialog.open();
                            pwDialog.setConfirmBtn(function () {
                                certPw = pwDialog.getPassword();
                                if(certPw.length <= 0) {
                                    alert(prop.strings.NO_INPUT_PASSWORD);
                                    return;
                                }
                                comm.reqImportCert(filePath, media, drive, certPw, function (result) {
                                    _reqImportResult(result);
                                }, true);
                            });
                        }
                    });
                }
            }
        });
        pkcs12Dlg.setBottomBtns(1, {
            event: function () {
                pkcs12Dlg.close();
								prop.CANCEL_SUB_DIALOG();
	              prop.isSubView = false;
            }
        });
        $("#pkcs12_file_btn").click(function () {
            var seledctedMenu = $("input[name=pkcs12menu]");
            if (seledctedMenu.eq(0).prop("checked")) {   /* Export */
                fileExplorerManager.open(prop.pkcs12.exportCert);
            } else if (seledctedMenu.eq(1).prop("checked")) {    /* Import */
                fileExplorerManager.open(prop.pkcs12.importCert);
            }
        });

        /* file manager */
        var fileExplorerManager = new _FileListManager();

        /* Product Info Dialog */
        var pInfoDlg = _makeDialog({
            id: prop.id.dialog.pInfo,
            width: 400,
            height: 170,
            open: function () {
            },
            close: function () {
            }
        });
        pInfoDlg.setBottomBtns(0, {
            event: function () {
                pInfoDlg.close();
            }
        });

        /* Select Media Dialog */
        var selectMediaDlg = new _SelectMediaDialogManagerBase();
        selectMediaDlg.setCancelBtn(function () {
            selectMediaDlg.close();
            prop.CANCEL_SUB_DIALOG();
            prop.isSubView = false;
        });

        /* PKCS11 Dialog */
        var p11DlgManager = new _pkcs11DialogManager();

        /* Select Drive Dialog */
        var selDriveDlg = new _SelectDriveDialog();
        selDriveDlg.setCancelBtn(function () {
            selDriveDlg.close();
            prop.CANCEL_SUB_DIALOG();
            prop.isSubView = false;
        });

        /* Input Password Dialog */
        var pwDialog = new _InputPasswordDialog();

        /* Input Pin Dialog */
        var pinDialog = new _InputPinDialog();

        return dialogObj;
    }

    function initAsn1() {
        /**
         * ASN.1 classes.
         */
        this.Class = {
            UNIVERSAL: 0x00,
            APPLICATION: 0x40,
            CONTEXT_SPECIFIC: 0x80,
            PRIVATE: 0xC0
        };

        /**
         * ASN.1 types. Not all types are supported by this implementation, only
         * those necessary to implement a simple PKI are implemented.
         */
        this.Type = {
            NONE: 0,
            BOOLEAN: 1,
            INTEGER: 2,
            BITSTRING: 3,
            OCTETSTRING: 4,
            NULL: 5,
            OID: 6,
            ODESC: 7,
            EXTERNAL: 8,
            REAL: 9,
            ENUMERATED: 10,
            EMBEDDED: 11,
            UTF8: 12,
            ROID: 13,
            SEQUENCE: 16,
            SET: 17,
            PRINTABLESTRING: 19,
            IA5STRING: 22,
            UTCTIME: 23,
            GENERALIZEDTIME: 24,
            BMPSTRING: 30
        };

        /**
         * Creates a new asn1 object.
         *
         * @param tagClass the tag class for the object.
         * @param type the data type (tag number) for the object.
         * @param constructed true if the asn1 object is in constructed form.
         * @param value the value for the object, if it is not constructed.
         *
         * @return the asn1 object.
         */
        this.create = function (tagClass, type, constructed, value) {
            /* An asn1 object has a tagClass, a type, a constructed flag, and a
             value. The value's type depends on the constructed flag. If
             constructed, it will contain a list of other asn1 objects. If not,
             it will contain the ASN.1 value as an array of bytes formatted
             according to the ASN.1 data type. */

            // remove undefined values
            if (util.isArray(value)) {
                var tmp = [];
                for (var i = 0; i < value.length; ++i) {
                    if (value[i] !== undefined) {
                        tmp.push(value[i]);
                    }
                }
                value = tmp;
            }

            return {
                tagClass: tagClass,
                type: type,
                constructed: constructed,
                composed: constructed || util.isArray(value),
                value: value
            };
        };

        /**
         * Gets the length of an ASN.1 value.
         *
         * In case the length is not specified, undefined is returned.
         *
         * @param b the ASN.1 byte buffer.
         *
         * @return the length of the ASN.1 value.
         */
        var _getValueLength = function (b) {
            var b2 = b.getByte();
            if (b2 === 0x80) {
                return undefined;
            }

            // see if the length is "short form" or "long form" (bit 8 set)
            var length;
            var longForm = b2 & 0x80;
            if (!longForm) {
                // length is just the first byte
                length = b2;
            } else {
                // the number of bytes the length is specified in bits 7 through 1
                // and each length byte is in big-endian base-256
                length = b.getInt((b2 & 0x7F) << 3);
            }
            return length;
        };

        /**
         * Parses an asn1 object from a byte buffer in DER format.
         *
         * @param bytes the byte buffer to parse from.
         * @param strict true to be strict when checking value lengths, false to
         *          allow truncated values (default: true).
         *
         * @return the parsed asn1 object.
         */
        this.fromDer = function (bytes, strict) {
            if (strict === undefined) {
                strict = true;
            }

            // wrap in buffer if needed
            if (typeof bytes === 'string') {
                bytes = util.createBuffer(bytes);
            }

            // minimum length for ASN.1 DER structure is 2
            if (bytes.length() < 2) {
                var error = new Error('Too few bytes to parse DER.');
                error.bytes = bytes.length();
                throw error;
            }

            // get the first byte
            var b1 = bytes.getByte();

            // get the tag class
            var tagClass = (b1 & 0xC0);

            // get the type (bits 1-5)
            var type = b1 & 0x1F;

            // get the value length
            var length = _getValueLength(bytes);

            // ensure there are enough bytes to get the value
            if (bytes.length() < length) {
                if (strict) {
                    var error = new Error('Too few bytes to read ASN.1 value.');
                    error.detail = bytes.length() + ' < ' + length;
                    throw error;
                }
                // Note: be lenient with truncated values
                length = bytes.length();
            }

            // prepare to get value
            var value;

            // constructed flag is bit 6 (32 = 0x20) of the first byte
            var constructed = ((b1 & 0x20) === 0x20);

            // determine if the value is composed of other ASN.1 objects (if its
            // constructed it will be and if its a BITSTRING it may be)
            var composed = constructed;
            if (!composed && tagClass === asn1.Class.UNIVERSAL &&
                type === asn1.Type.BITSTRING && length > 1) {
                /* The first octet gives the number of bits by which the length of the
                 bit string is less than the next multiple of eight (this is called
                 the "number of unused bits").

                 The second and following octets give the value of the bit string
                 converted to an octet string. */
                // if there are no unused bits, maybe the bitstring holds ASN.1 objs
                var read = bytes.read;
                var unused = bytes.getByte();
                if (unused === 0) {
                    // if the first byte indicates UNIVERSAL or CONTEXT_SPECIFIC,
                    // and the length is valid, assume we've got an ASN.1 object
                    b1 = bytes.getByte();
                    var tc = (b1 & 0xC0);
                    if (tc === asn1.Class.UNIVERSAL || tc === asn1.Class.CONTEXT_SPECIFIC) {
                        try {
                            var len = _getValueLength(bytes);
                            composed = (len === length - (bytes.read - read));
                            if (composed) {
                                // adjust read/length to account for unused bits byte
                                ++read;
                                --length;
                            }
                        } catch (ex) {
                        }
                    }
                }
                // restore read pointer
                bytes.read = read;
            }

            if (composed) {
                // parse child asn1 objects from the value
                value = [];
                if (length === undefined) {
                    // asn1 object of indefinite length, read until end tag
                    for (; ;) {
                        if (bytes.bytes(2) === String.fromCharCode(0, 0)) {
                            bytes.getBytes(2);
                            break;
                        }
                        value.push(asn1.fromDer(bytes, strict));
                    }
                } else {
                    // parsing asn1 object of definite length
                    var start = bytes.length();
                    while (length > 0) {
                        value.push(asn1.fromDer(bytes, strict));
                        length -= start - bytes.length();
                        start = bytes.length();
                    }
                }
            } else {
                // asn1 not composed, get raw value
                // TODO: do DER to OID conversion and vice-versa in .toDer?

                if (length === undefined) {
                    if (strict) {
                        throw new Error('Non-constructed ASN.1 object of indefinite length.');
                    }
                    // be lenient and use remaining bytes
                    length = bytes.length();
                }

                if (type === asn1.Type.BMPSTRING) {
                    value = '';
                    for (var i = 0; i < length; i += 2) {
                        value += String.fromCharCode(bytes.getInt16());
                    }
                } else {
                    value = bytes.getBytes(length);
                }
            }

            // create and return asn1 object
            return asn1.create(tagClass, type, constructed, value);
        };

        /**
         * Converts the given asn1 object to a buffer of bytes in DER format.
         *
         * @param asn1 the asn1 object to convert to bytes.
         *
         * @return the buffer of bytes.
         */
        this.toDer = function (obj) {
            var bytes = util.createBuffer();

            // build the first byte
            var b1 = obj.tagClass | obj.type;

            // for storing the ASN.1 value
            var value = util.createBuffer();

            // if composed, use each child asn1 object's DER bytes as value
            if (obj.composed) {
                // turn on 6th bit (0x20 = 32) to indicate asn1 is constructed
                // from other asn1 objects
                if (obj.constructed) {
                    b1 |= 0x20;
                } else {
                    // type is a bit string, add unused bits of 0x00
                    value.putByte(0x00);
                }

                // add all of the child DER bytes together
                for (var i = 0; i < obj.value.length; ++i) {
                    if (obj.value[i] !== undefined) {
                        value.putBuffer(asn1.toDer(obj.value[i]));
                    }
                }
            } else {
                // use asn1.value directly
                if (obj.type === asn1.Type.BMPSTRING) {
                    for (var i = 0; i < obj.value.length; ++i) {
                        value.putInt16(obj.value.charCodeAt(i));
                    }
                } else {
                    value.putBytes(obj.value);
                }
            }

            // add tag byte
            bytes.putByte(b1);

            // use "short form" encoding
            if (value.length() <= 127) {
                // one byte describes the length
                // bit 8 = 0 and bits 7-1 = length
                bytes.putByte(value.length() & 0x7F);
            } else {
                // use "long form" encoding
                // 2 to 127 bytes describe the length
                // first byte: bit 8 = 1 and bits 7-1 = # of additional bytes
                // other bytes: length in base 256, big-endian
                var len = value.length();
                var lenBytes = '';
                do {
                    lenBytes += String.fromCharCode(len & 0xFF);
                    len = len >>> 8;
                } while (len > 0);

                // set first byte to # bytes used to store the length and turn on
                // bit 8 to indicate long-form length is used
                bytes.putByte(lenBytes.length | 0x80);

                // concatenate length bytes in reverse since they were generated
                // little endian and we need big endian
                for (var i = lenBytes.length - 1; i >= 0; --i) {
                    bytes.putByte(lenBytes.charCodeAt(i));
                }
            }

            // concatenate value bytes
            bytes.putBuffer(value);
            return bytes;
        };

        /**
         * Converts an OID dot-separated string to a byte buffer. The byte buffer
         * contains only the DER-encoded value, not any tag or length bytes.
         *
         * @param oid the OID dot-separated string.
         *
         * @return the byte buffer.
         */
        this.oidToDer = function (oid) {
            // split OID into individual values
            var values = oid.split('.');
            var bytes = util.createBuffer();

            // first byte is 40 * value1 + value2
            bytes.putByte(40 * parseInt(values[0], 10) + parseInt(values[1], 10));
            // other bytes are each value in base 128 with 8th bit set except for
            // the last byte for each value
            var last, valueBytes, value, b;
            for (var i = 2; i < values.length; ++i) {
                // produce value bytes in reverse because we don't know how many
                // bytes it will take to store the value
                last = true;
                valueBytes = [];
                value = parseInt(values[i], 10);
                do {
                    b = value & 0x7F;
                    value = value >>> 7;
                    // if value is not last, then turn on 8th bit
                    if (!last) {
                        b |= 0x80;
                    }
                    valueBytes.push(b);
                    last = false;
                } while (value > 0);

                // add value bytes in reverse (needs to be in big endian)
                for (var n = valueBytes.length - 1; n >= 0; --n) {
                    bytes.putByte(valueBytes[n]);
                }
            }

            return bytes;
        };

        /**
         * Converts a DER-encoded byte buffer to an OID dot-separated string. The
         * byte buffer should contain only the DER-encoded value, not any tag or
         * length bytes.
         *
         * @param bytes the byte buffer.
         *
         * @return the OID dot-separated string.
         */
        this.derToOid = function (bytes) {
            var oid;

            // wrap in buffer if needed
            if (typeof bytes === 'string') {
                bytes = util.createBuffer(bytes);
            }

            // first byte is 40 * value1 + value2
            var b = bytes.getByte();
            oid = Math.floor(b / 40) + '.' + (b % 40);

            // other bytes are each value in base 128 with 8th bit set except for
            // the last byte for each value
            var value = 0;
            while (bytes.length() > 0) {
                b = bytes.getByte();
                value = value << 7;
                // not the last byte for the value
                if (b & 0x80) {
                    value += b & 0x7F;
                } else {
                    // last byte
                    oid += '.' + (value + b);
                    value = 0;
                }
            }

            return oid;
        };

        /**
         * Converts a UTCTime value to a date.
         *
         * Note: GeneralizedTime has 4 digits for the year and is used for X.509
         * dates passed 2049. Parsing that structure hasn't been implemented yet.
         *
         * @param utc the UTCTime value to convert.
         *
         * @return the date.
         */
        this.utcTimeToDate = function (utc) {
            /* The following formats can be used:

             YYMMDDhhmmZ
             YYMMDDhhmm+hh'mm'
             YYMMDDhhmm-hh'mm'
             YYMMDDhhmmssZ
             YYMMDDhhmmss+hh'mm'
             YYMMDDhhmmss-hh'mm'

             Where:

             YY is the least significant two digits of the year
             MM is the month (01 to 12)
             DD is the day (01 to 31)
             hh is the hour (00 to 23)
             mm are the minutes (00 to 59)
             ss are the seconds (00 to 59)
             Z indicates that local time is GMT, + indicates that local time is
             later than GMT, and - indicates that local time is earlier than GMT
             hh' is the absolute value of the offset from GMT in hours
             mm' is the absolute value of the offset from GMT in minutes */
            var date = new Date();

            // if YY >= 50 use 19xx, if YY < 50 use 20xx
            var year = parseInt(utc.substr(0, 2), 10);
            year = (year >= 50) ? 1900 + year : 2000 + year;
            var MM = parseInt(utc.substr(2, 2), 10) - 1; // use 0-11 for month
            var DD = parseInt(utc.substr(4, 2), 10);
            var hh = parseInt(utc.substr(6, 2), 10);
            var mm = parseInt(utc.substr(8, 2), 10);
            var ss = 0;

            // not just YYMMDDhhmmZ
            if (utc.length > 11) {
                // get character after minutes
                var c = utc.charAt(10);
                var end = 10;

                // see if seconds are present
                if (c !== '+' && c !== '-') {
                    // get seconds
                    ss = parseInt(utc.substr(10, 2), 10);
                    end += 2;
                }
            }

            // update date
            date.setUTCFullYear(year, MM, DD);
            date.setUTCHours(hh, mm, ss, 0);

            if (end) {
                // get +/- after end of time
                c = utc.charAt(end);
                if (c === '+' || c === '-') {
                    // get hours+minutes offset
                    var hhoffset = parseInt(utc.substr(end + 1, 2), 10);
                    var mmoffset = parseInt(utc.substr(end + 4, 2), 10);

                    // calculate offset in milliseconds
                    var offset = hhoffset * 60 + mmoffset;
                    offset *= 60000;

                    // apply offset
                    if (c === '+') {
                        date.setTime(+date - offset);
                    } else {
                        date.setTime(+date + offset);
                    }
                }
            }

            return date;
        };

        /**
         * Converts a GeneralizedTime value to a date.
         *
         * @param gentime the GeneralizedTime value to convert.
         *
         * @return the date.
         */
        this.generalizedTimeToDate = function (gentime) {
            /* The following formats can be used:

             YYYYMMDDHHMMSS
             YYYYMMDDHHMMSS.fff
             YYYYMMDDHHMMSSZ
             YYYYMMDDHHMMSS.fffZ
             YYYYMMDDHHMMSS+hh'mm'
             YYYYMMDDHHMMSS.fff+hh'mm'
             YYYYMMDDHHMMSS-hh'mm'
             YYYYMMDDHHMMSS.fff-hh'mm'

             Where:

             YYYY is the year
             MM is the month (01 to 12)
             DD is the day (01 to 31)
             hh is the hour (00 to 23)
             mm are the minutes (00 to 59)
             ss are the seconds (00 to 59)
             .fff is the second fraction, accurate to three decimal places
             Z indicates that local time is GMT, + indicates that local time is
             later than GMT, and - indicates that local time is earlier than GMT
             hh' is the absolute value of the offset from GMT in hours
             mm' is the absolute value of the offset from GMT in minutes */
            var date = new Date();

            var YYYY = parseInt(gentime.substr(0, 4), 10);
            var MM = parseInt(gentime.substr(4, 2), 10) - 1; // use 0-11 for month
            var DD = parseInt(gentime.substr(6, 2), 10);
            var hh = parseInt(gentime.substr(8, 2), 10);
            var mm = parseInt(gentime.substr(10, 2), 10);
            var ss = parseInt(gentime.substr(12, 2), 10);
            var fff = 0;
            var offset = 0;
            var isUTC = false;

            if (gentime.charAt(gentime.length - 1) === 'Z') {
                isUTC = true;
            }

            var end = gentime.length - 5, c = gentime.charAt(end);
            if (c === '+' || c === '-') {
                // get hours+minutes offset
                var hhoffset = parseInt(gentime.substr(end + 1, 2), 10);
                var mmoffset = parseInt(gentime.substr(end + 4, 2), 10);

                // calculate offset in milliseconds
                offset = hhoffset * 60 + mmoffset;
                offset *= 60000;

                // apply offset
                if (c === '+') {
                    offset *= -1;
                }

                isUTC = true;
            }

            // check for second fraction
            if (gentime.charAt(14) === '.') {
                fff = parseFloat(gentime.substr(14), 10) * 1000;
            }

            if (isUTC) {
                date.setUTCFullYear(YYYY, MM, DD);
                date.setUTCHours(hh, mm, ss, fff);

                // apply offset
                date.setTime(+date + offset);
            } else {
                date.setFullYear(YYYY, MM, DD);
                date.setHours(hh, mm, ss, fff);
            }

            return date;
        };


        /**
         * Converts a date to a UTCTime value.
         *
         * Note: GeneralizedTime has 4 digits for the year and is used for X.509
         * dates passed 2049. Converting to a GeneralizedTime hasn't been
         * implemented yet.
         *
         * @param date the date to convert.
         *
         * @return the UTCTime value.
         */
        this.dateToUtcTime = function (date) {
            var rval = '';

            // create format YYMMDDhhmmssZ
            var format = [];
            format.push(('' + date.getUTCFullYear()).substr(2));
            format.push('' + (date.getUTCMonth() + 1));
            format.push('' + date.getUTCDate());
            format.push('' + date.getUTCHours());
            format.push('' + date.getUTCMinutes());
            format.push('' + date.getUTCSeconds());

            // ensure 2 digits are used for each format entry
            for (var i = 0; i < format.length; ++i) {
                if (format[i].length < 2) {
                    rval += '0';
                }
                rval += format[i];
            }
            rval += 'Z';

            return rval;
        };

        /**
         * Converts a javascript integer to a DER-encoded byte buffer to be used
         * as the value for an INTEGER type.
         *
         * @param x the integer.
         *
         * @return the byte buffer.
         */
        this.integerToDer = function (x) {
            var rval = util.createBuffer();
            if (x >= -0x80 && x < 0x80) {
                return rval.putSignedInt(x, 8);
            }
            if (x >= -0x8000 && x < 0x8000) {
                return rval.putSignedInt(x, 16);
            }
            if (x >= -0x800000 && x < 0x800000) {
                return rval.putSignedInt(x, 24);
            }
            if (x >= -0x80000000 && x < 0x80000000) {
                return rval.putSignedInt(x, 32);
            }
            var error = new Error('Integer too large; max is 32-bits.');
            error.integer = x;
            throw error;
        };

        /**
         * Converts a DER-encoded byte buffer to a javascript integer. This is
         * typically used to decode the value of an INTEGER type.
         *
         * @param bytes the byte buffer.
         *
         * @return the integer.
         */
        this.derToInteger = function (bytes) {
            // wrap in buffer if needed
            if (typeof bytes === 'string') {
                bytes = util.createBuffer(bytes);
            }

            var n = bytes.length() * 8;
            if (n > 32) {
                throw new Error('Integer too large; max is 32-bits.');
            }
            return bytes.getSignedInt(n);
        };

        /**
         * Validates the that given ASN.1 object is at least a super set of the
         * given ASN.1 structure. Only tag classes and types are checked. An
         * optional map may also be provided to capture ASN.1 values while the
         * structure is checked.
         *
         * To capture an ASN.1 value, set an object in the validator's 'capture'
         * parameter to the key to use in the capture map. To capture the full
         * ASN.1 object, specify 'captureAsn1'.
         *
         * Objects in the validator may set a field 'optional' to true to indicate
         * that it isn't necessary to pass validation.
         *
         * @param obj the ASN.1 object to validate.
         * @param v the ASN.1 structure validator.
         * @param capture an optional map to capture values in.
         * @param errors an optional array for storing validation errors.
         *
         * @return true on success, false on failure.
         */
        this.validate = function (obj, v, capture, errors) {
            var rval = false;

            // ensure tag class and type are the same if specified
            if ((obj.tagClass === v.tagClass || typeof(v.tagClass) === 'undefined') &&
                (obj.type === v.type || typeof(v.type) === 'undefined')) {
                // ensure constructed flag is the same if specified
                if (obj.constructed === v.constructed ||
                    typeof(v.constructed) === 'undefined') {
                    rval = true;

                    // handle sub values
                    if (v.value && util.isArray(v.value)) {
                        var j = 0;
                        for (var i = 0; rval && i < v.value.length; ++i) {
                            rval = v.value[i].optional || false;
                            if (obj.value[j]) {
                                rval = asn1.validate(obj.value[j], v.value[i], capture, errors);
                                if (rval) {
                                    ++j;
                                } else if (v.value[i].optional) {
                                    rval = true;
                                }
                            }
                            if (!rval && errors) {
                                errors.push(
                                    '[' + v.name + '] ' +
                                    'Tag class "' + v.tagClass + '", type "' +
                                    v.type + '" expected value length "' +
                                    v.value.length + '", got "' +
                                    obj.value.length + '"');
                            }
                        }
                    }

                    if (rval && capture) {
                        if (v.capture) {
                            capture[v.capture] = obj.value;
                        }
                        if (v.captureAsn1) {
                            capture[v.captureAsn1] = obj;
                        }
                    }
                } else if (errors) {
                    errors.push(
                        '[' + v.name + '] ' +
                        'Expected constructed "' + v.constructed + '", got "' +
                        obj.constructed + '"');
                }
            } else if (errors) {
                if (obj.tagClass !== v.tagClass) {
                    errors.push(
                        '[' + v.name + '] ' +
                        'Expected tag class "' + v.tagClass + '", got "' +
                        obj.tagClass + '"');
                }
                if (obj.type !== v.type) {
                    errors.push(
                        '[' + v.name + '] ' +
                        'Expected type "' + v.type + '", got "' + obj.type + '"');
                }
            }
            return rval;
        };

// regex for testing for non-latin characters
        var _nonLatinRegex = /[^\\u0000-\\u00ff]/;

        /**
         * Pretty prints an ASN.1 object to a string.
         *
         * @param obj the object to write out.
         * @param level the level in the tree.
         * @param indentation the indentation to use.
         *
         * @return the string.
         */
        this.prettyPrint = function (obj, level, indentation) {
            var rval = '';

            // set default level and indentation
            level = level || 0;
            indentation = indentation || 2;

            // start new line for deep levels
            if (level > 0) {
                rval += '\n';
            }

            // create indent
            var indent = '';
            for (var i = 0; i < level * indentation; ++i) {
                indent += ' ';
            }

            // print class:type
            rval += indent + 'Tag: ';
            switch (obj.tagClass) {
                case asn1.Class.UNIVERSAL:
                    rval += 'Universal:';
                    break;
                case asn1.Class.APPLICATION:
                    rval += 'Application:';
                    break;
                case asn1.Class.CONTEXT_SPECIFIC:
                    rval += 'Context-Specific:';
                    break;
                case asn1.Class.PRIVATE:
                    rval += 'Private:';
                    break;
            }

            if (obj.tagClass === asn1.Class.UNIVERSAL) {
                rval += obj.type;

                // known types
                switch (obj.type) {
                    case asn1.Type.NONE:
                        rval += ' (None)';
                        break;
                    case asn1.Type.BOOLEAN:
                        rval += ' (Boolean)';
                        break;
                    case asn1.Type.BITSTRING:
                        rval += ' (Bit string)';
                        break;
                    case asn1.Type.INTEGER:
                        rval += ' (Integer)';
                        break;
                    case asn1.Type.OCTETSTRING:
                        rval += ' (Octet string)';
                        break;
                    case asn1.Type.NULL:
                        rval += ' (Null)';
                        break;
                    case asn1.Type.OID:
                        rval += ' (Object Identifier)';
                        break;
                    case asn1.Type.ODESC:
                        rval += ' (Object Descriptor)';
                        break;
                    case asn1.Type.EXTERNAL:
                        rval += ' (External or Instance of)';
                        break;
                    case asn1.Type.REAL:
                        rval += ' (Real)';
                        break;
                    case asn1.Type.ENUMERATED:
                        rval += ' (Enumerated)';
                        break;
                    case asn1.Type.EMBEDDED:
                        rval += ' (Embedded PDV)';
                        break;
                    case asn1.Type.UTF8:
                        rval += ' (UTF8)';
                        break;
                    case asn1.Type.ROID:
                        rval += ' (Relative Object Identifier)';
                        break;
                    case asn1.Type.SEQUENCE:
                        rval += ' (Sequence)';
                        break;
                    case asn1.Type.SET:
                        rval += ' (Set)';
                        break;
                    case asn1.Type.PRINTABLESTRING:
                        rval += ' (Printable String)';
                        break;
                    case asn1.Type.IA5String:
                        rval += ' (IA5String (ASCII))';
                        break;
                    case asn1.Type.UTCTIME:
                        rval += ' (UTC time)';
                        break;
                    case asn1.Type.GENERALIZEDTIME:
                        rval += ' (Generalized time)';
                        break;
                    case asn1.Type.BMPSTRING:
                        rval += ' (BMP String)';
                        break;
                }
            } else {
                rval += obj.type;
            }

            rval += '\n';
            rval += indent + 'Constructed: ' + obj.constructed + '\n';

            if (obj.composed) {
                var subvalues = 0;
                var sub = '';
                for (var i = 0; i < obj.value.length; ++i) {
                    if (obj.value[i] !== undefined) {
                        subvalues += 1;
                        sub += asn1.prettyPrint(obj.value[i], level + 1, indentation);
                        if ((i + 1) < obj.value.length) {
                            sub += ',';
                        }
                    }
                }
                rval += indent + 'Sub values: ' + subvalues + sub;
            } else {
                rval += indent + 'Value: ';
                if (obj.type === asn1.Type.OID) {
                    var oid = asn1.derToOid(obj.value);
                    rval += oid;
                    if (kcaseagt.pki && kcaseagt.pki.oids) {
                        if (oid in kcaseagt.pki.oids) {
                            rval += ' (' + kcaseagt.pki.oids[oid] + ') ';
                        }
                    }
                }
                if (obj.type === asn1.Type.INTEGER) {
                    try {
                        rval += asn1.derToInteger(obj.value);
                    } catch (ex) {
                        rval += '0x' + util.bytesToHex(obj.value);
                    }
                } else if (obj.type === asn1.Type.OCTETSTRING) {
                    if (!_nonLatinRegex.test(obj.value)) {
                        rval += '(' + obj.value + ') ';
                    }
                    rval += '0x' + util.bytesToHex(obj.value);
                } else if (obj.type === asn1.Type.UTF8) {
                    rval += util.decodeUtf8(obj.value);
                } else if (obj.type === asn1.Type.PRINTABLESTRING ||
                    obj.type === asn1.Type.IA5String) {
                    rval += obj.value;
                } else if (_nonLatinRegex.test(obj.value)) {
                    rval += '0x' + util.bytesToHex(obj.value);
                } else if (obj.value.length === 0) {
                    rval += '[null]';
                } else {
                    rval += obj.value;
                }
            }

            return rval;
        };
    }

    function initBignum() {
        // Bits per digit
        var dbits;

// JavaScript engine analysis
        var canary = 0xdeadbeefcafe;
        var j_lm = ((canary & 0xffffff) == 0xefcafe);

// (public) Constructor
        function BigInteger(a, b, c) {
            this.data = [];
            if (a != null)
                if ("number" == typeof a) this.fromNumber(a, b, c);
                else if (b == null && "string" != typeof a) this.fromString(a, 256);
                else this.fromString(a, b);
        }

// return new, unset BigInteger
        function nbi() {
            return new BigInteger(null);
        }

// am: Compute w_j += (x*this_i), propagate carries,
// c is initial carry, returns final carry.
// c < 3*dvalue, x < 2*dvalue, this_i < dvalue
// We need to select the fastest one that works in this environment.

// am1: use a single mult and divide to get the high bits,
// max digit bits should be 26 because
// max internal value = 2*dvalue^2-2*dvalue (< 2^53)
        function am1(i, x, w, j, c, n) {
            while (--n >= 0) {
                var v = x * this.data[i++] + w.data[j] + c;
                c = Math.floor(v / 0x4000000);
                w.data[j++] = v & 0x3ffffff;
            }
            return c;
        }

// am2 avoids a big mult-and-extract completely.
// Max digit bits should be <= 30 because we do bitwise ops
// on values up to 2*hdvalue^2-hdvalue-1 (< 2^31)
        function am2(i, x, w, j, c, n) {
            var xl = x & 0x7fff, xh = x >> 15;
            while (--n >= 0) {
                var l = this.data[i] & 0x7fff;
                var h = this.data[i++] >> 15;
                var m = xh * l + h * xl;
                l = xl * l + ((m & 0x7fff) << 15) + w.data[j] + (c & 0x3fffffff);
                c = (l >>> 30) + (m >>> 15) + xh * h + (c >>> 30);
                w.data[j++] = l & 0x3fffffff;
            }
            return c;
        }

// Alternately, set max digit bits to 28 since some
// browsers slow down when dealing with 32-bit numbers.
        function am3(i, x, w, j, c, n) {
            var xl = x & 0x3fff, xh = x >> 14;
            while (--n >= 0) {
                var l = this.data[i] & 0x3fff;
                var h = this.data[i++] >> 14;
                var m = xh * l + h * xl;
                l = xl * l + ((m & 0x3fff) << 14) + w.data[j] + c;
                c = (l >> 28) + (m >> 14) + xh * h;
                w.data[j++] = l & 0xfffffff;
            }
            return c;
        }

// node.js (no browser)
        if (typeof(navigator) === 'undefined') {
            BigInteger.prototype.am = am3;
            dbits = 28;
        } else if (j_lm && (navigator.appName == "Microsoft Internet Explorer")) {
            BigInteger.prototype.am = am2;
            dbits = 30;
        } else if (j_lm && (navigator.appName != "Netscape")) {
            BigInteger.prototype.am = am1;
            dbits = 26;
        } else { // Mozilla/Netscape seems to prefer am3
            BigInteger.prototype.am = am3;
            dbits = 28;
        }

        BigInteger.prototype.DB = dbits;
        BigInteger.prototype.DM = ((1 << dbits) - 1);
        BigInteger.prototype.DV = (1 << dbits);

        var BI_FP = 52;
        BigInteger.prototype.FV = Math.pow(2, BI_FP);
        BigInteger.prototype.F1 = BI_FP - dbits;
        BigInteger.prototype.F2 = 2 * dbits - BI_FP;

// Digit conversions
        var BI_RM = "0123456789abcdefghijklmnopqrstuvwxyz";
        var BI_RC = new Array();
        var rr, vv;
        rr = "0".charCodeAt(0);
        for (vv = 0; vv <= 9; ++vv) BI_RC[rr++] = vv;
        rr = "a".charCodeAt(0);
        for (vv = 10; vv < 36; ++vv) BI_RC[rr++] = vv;
        rr = "A".charCodeAt(0);
        for (vv = 10; vv < 36; ++vv) BI_RC[rr++] = vv;

        function int2char(n) {
            return BI_RM.charAt(n);
        }

        function intAt(s, i) {
            var c = BI_RC[s.charCodeAt(i)];
            return (c == null) ? -1 : c;
        }

// (protected) copy this to r
        function bnpCopyTo(r) {
            for (var i = this.t - 1; i >= 0; --i) r.data[i] = this.data[i];
            r.t = this.t;
            r.s = this.s;
        }

// (protected) set from integer value x, -DV <= x < DV
        function bnpFromInt(x) {
            this.t = 1;
            this.s = (x < 0) ? -1 : 0;
            if (x > 0) this.data[0] = x;
            else if (x < -1) this.data[0] = x + this.DV;
            else this.t = 0;
        }

// return bigint initialized to value
        function nbv(i) {
            var r = nbi();
            r.fromInt(i);
            return r;
        }

// (protected) set from string and radix
        function bnpFromString(s, b) {
            var k;
            if (b == 16) k = 4;
            else if (b == 8) k = 3;
            else if (b == 256) k = 8; // byte array
            else if (b == 2) k = 1;
            else if (b == 32) k = 5;
            else if (b == 4) k = 2;
            else {
                this.fromRadix(s, b);
                return;
            }
            this.t = 0;
            this.s = 0;
            var i = s.length, mi = false, sh = 0;
            while (--i >= 0) {
                var x = (k == 8) ? s[i] & 0xff : intAt(s, i);
                if (x < 0) {
                    if (s.charAt(i) == "-") mi = true;
                    continue;
                }
                mi = false;
                if (sh == 0)
                    this.data[this.t++] = x;
                else if (sh + k > this.DB) {
                    this.data[this.t - 1] |= (x & ((1 << (this.DB - sh)) - 1)) << sh;
                    this.data[this.t++] = (x >> (this.DB - sh));
                } else
                    this.data[this.t - 1] |= x << sh;
                sh += k;
                if (sh >= this.DB) sh -= this.DB;
            }
            if (k == 8 && (s[0] & 0x80) != 0) {
                this.s = -1;
                if (sh > 0) this.data[this.t - 1] |= ((1 << (this.DB - sh)) - 1) << sh;
            }
            this.clamp();
            if (mi) BigInteger.ZERO.subTo(this, this);
        }

// (protected) clamp off excess high words
        function bnpClamp() {
            var c = this.s & this.DM;
            while (this.t > 0 && this.data[this.t - 1] == c) --this.t;
        }

// (public) return string representation in given radix
        function bnToString(b) {
            if (this.s < 0) return "-" + this.negate().toString(b);
            var k;
            if (b == 16) k = 4;
            else if (b == 8) k = 3;
            else if (b == 2) k = 1;
            else if (b == 32) k = 5;
            else if (b == 4) k = 2;
            else return this.toRadix(b);
            var km = (1 << k) - 1, d, m = false, r = "", i = this.t;
            var p = this.DB - (i * this.DB) % k;
            if (i-- > 0) {
                if (p < this.DB && (d = this.data[i] >> p) > 0) {
                    m = true;
                    r = int2char(d);
                }
                while (i >= 0) {
                    if (p < k) {
                        d = (this.data[i] & ((1 << p) - 1)) << (k - p);
                        d |= this.data[--i] >> (p += this.DB - k);
                    } else {
                        d = (this.data[i] >> (p -= k)) & km;
                        if (p <= 0) {
                            p += this.DB;
                            --i;
                        }
                    }
                    if (d > 0) m = true;
                    if (m) r += int2char(d);
                }
            }
            return m ? r : "0";
        }

// (public) -this
        function bnNegate() {
            var r = nbi();
            BigInteger.ZERO.subTo(this, r);
            return r;
        }

// (public) |this|
        function bnAbs() {
            return (this.s < 0) ? this.negate() : this;
        }

// (public) return + if this > a, - if this < a, 0 if equal
        function bnCompareTo(a) {
            var r = this.s - a.s;
            if (r != 0) return r;
            var i = this.t;
            r = i - a.t;
            if (r != 0) return (this.s < 0) ? -r : r;
            while (--i >= 0) if ((r = this.data[i] - a.data[i]) != 0) return r;
            return 0;
        }

// returns bit length of the integer x
        function nbits(x) {
            var r = 1, t;
            if ((t = x >>> 16) != 0) {
                x = t;
                r += 16;
            }
            if ((t = x >> 8) != 0) {
                x = t;
                r += 8;
            }
            if ((t = x >> 4) != 0) {
                x = t;
                r += 4;
            }
            if ((t = x >> 2) != 0) {
                x = t;
                r += 2;
            }
            if ((t = x >> 1) != 0) {
                x = t;
                r += 1;
            }
            return r;
        }

// (public) return the number of bits in "this"
        function bnBitLength() {
            if (this.t <= 0) return 0;
            return this.DB * (this.t - 1) + nbits(this.data[this.t - 1] ^ (this.s & this.DM));
        }

// (protected) r = this << n*DB
        function bnpDLShiftTo(n, r) {
            var i;
            for (i = this.t - 1; i >= 0; --i) r.data[i + n] = this.data[i];
            for (i = n - 1; i >= 0; --i) r.data[i] = 0;
            r.t = this.t + n;
            r.s = this.s;
        }

// (protected) r = this >> n*DB
        function bnpDRShiftTo(n, r) {
            for (var i = n; i < this.t; ++i) r.data[i - n] = this.data[i];
            r.t = Math.max(this.t - n, 0);
            r.s = this.s;
        }

// (protected) r = this << n
        function bnpLShiftTo(n, r) {
            var bs = n % this.DB;
            var cbs = this.DB - bs;
            var bm = (1 << cbs) - 1;
            var ds = Math.floor(n / this.DB), c = (this.s << bs) & this.DM, i;
            for (i = this.t - 1; i >= 0; --i) {
                r.data[i + ds + 1] = (this.data[i] >> cbs) | c;
                c = (this.data[i] & bm) << bs;
            }
            for (i = ds - 1; i >= 0; --i) r.data[i] = 0;
            r.data[ds] = c;
            r.t = this.t + ds + 1;
            r.s = this.s;
            r.clamp();
        }

// (protected) r = this >> n
        function bnpRShiftTo(n, r) {
            r.s = this.s;
            var ds = Math.floor(n / this.DB);
            if (ds >= this.t) {
                r.t = 0;
                return;
            }
            var bs = n % this.DB;
            var cbs = this.DB - bs;
            var bm = (1 << bs) - 1;
            r.data[0] = this.data[ds] >> bs;
            for (var i = ds + 1; i < this.t; ++i) {
                r.data[i - ds - 1] |= (this.data[i] & bm) << cbs;
                r.data[i - ds] = this.data[i] >> bs;
            }
            if (bs > 0) r.data[this.t - ds - 1] |= (this.s & bm) << cbs;
            r.t = this.t - ds;
            r.clamp();
        }

// (protected) r = this - a
        function bnpSubTo(a, r) {
            var i = 0, c = 0, m = Math.min(a.t, this.t);
            while (i < m) {
                c += this.data[i] - a.data[i];
                r.data[i++] = c & this.DM;
                c >>= this.DB;
            }
            if (a.t < this.t) {
                c -= a.s;
                while (i < this.t) {
                    c += this.data[i];
                    r.data[i++] = c & this.DM;
                    c >>= this.DB;
                }
                c += this.s;
            } else {
                c += this.s;
                while (i < a.t) {
                    c -= a.data[i];
                    r.data[i++] = c & this.DM;
                    c >>= this.DB;
                }
                c -= a.s;
            }
            r.s = (c < 0) ? -1 : 0;
            if (c < -1) r.data[i++] = this.DV + c;
            else if (c > 0) r.data[i++] = c;
            r.t = i;
            r.clamp();
        }

// (protected) r = this * a, r != this,a (HAC 14.12)
// "this" should be the larger one if appropriate.
        function bnpMultiplyTo(a, r) {
            var x = this.abs(), y = a.abs();
            var i = x.t;
            r.t = i + y.t;
            while (--i >= 0) r.data[i] = 0;
            for (i = 0; i < y.t; ++i) r.data[i + x.t] = x.am(0, y.data[i], r, i, 0, x.t);
            r.s = 0;
            r.clamp();
            if (this.s != a.s) BigInteger.ZERO.subTo(r, r);
        }

// (protected) r = this^2, r != this (HAC 14.16)
        function bnpSquareTo(r) {
            var x = this.abs();
            var i = r.t = 2 * x.t;
            while (--i >= 0) r.data[i] = 0;
            for (i = 0; i < x.t - 1; ++i) {
                var c = x.am(i, x.data[i], r, 2 * i, 0, 1);
                if ((r.data[i + x.t] += x.am(i + 1, 2 * x.data[i], r, 2 * i + 1, c, x.t - i - 1)) >= x.DV) {
                    r.data[i + x.t] -= x.DV;
                    r.data[i + x.t + 1] = 1;
                }
            }
            if (r.t > 0) r.data[r.t - 1] += x.am(i, x.data[i], r, 2 * i, 0, 1);
            r.s = 0;
            r.clamp();
        }

// (protected) divide this by m, quotient and remainder to q, r (HAC 14.20)
// r != q, this != m.  q or r may be null.
        function bnpDivRemTo(m, q, r) {
            var pm = m.abs();
            if (pm.t <= 0) return;
            var pt = this.abs();
            if (pt.t < pm.t) {
                if (q != null) q.fromInt(0);
                if (r != null) this.copyTo(r);
                return;
            }
            if (r == null) r = nbi();
            var y = nbi(), ts = this.s, ms = m.s;
            var nsh = this.DB - nbits(pm.data[pm.t - 1]);	// normalize modulus
            if (nsh > 0) {
                pm.lShiftTo(nsh, y);
                pt.lShiftTo(nsh, r);
            } else {
                pm.copyTo(y);
                pt.copyTo(r);
            }
            var ys = y.t;
            var y0 = y.data[ys - 1];
            if (y0 == 0) return;
            var yt = y0 * (1 << this.F1) + ((ys > 1) ? y.data[ys - 2] >> this.F2 : 0);
            var d1 = this.FV / yt, d2 = (1 << this.F1) / yt, e = 1 << this.F2;
            var i = r.t, j = i - ys, t = (q == null) ? nbi() : q;
            y.dlShiftTo(j, t);
            if (r.compareTo(t) >= 0) {
                r.data[r.t++] = 1;
                r.subTo(t, r);
            }
            BigInteger.ONE.dlShiftTo(ys, t);
            t.subTo(y, y);	// "negative" y so we can replace sub with am later
            while (y.t < ys) y.data[y.t++] = 0;
            while (--j >= 0) {
                // Estimate quotient digit
                var qd = (r.data[--i] == y0) ? this.DM : Math.floor(r.data[i] * d1 + (r.data[i - 1] + e) * d2);
                if ((r.data[i] += y.am(0, qd, r, j, 0, ys)) < qd) {	// Try it out
                    y.dlShiftTo(j, t);
                    r.subTo(t, r);
                    while (r.data[i] < --qd) r.subTo(t, r);
                }
            }
            if (q != null) {
                r.drShiftTo(ys, q);
                if (ts != ms) BigInteger.ZERO.subTo(q, q);
            }
            r.t = ys;
            r.clamp();
            if (nsh > 0) r.rShiftTo(nsh, r);	// Denormalize remainder
            if (ts < 0) BigInteger.ZERO.subTo(r, r);
        }

// (public) this mod a
        function bnMod(a) {
            var r = nbi();
            this.abs().divRemTo(a, null, r);
            if (this.s < 0 && r.compareTo(BigInteger.ZERO) > 0) a.subTo(r, r);
            return r;
        }

// Modular reduction using "classic" algorithm
        function Classic(m) {
            this.m = m;
        }

        function cConvert(x) {
            if (x.s < 0 || x.compareTo(this.m) >= 0) return x.mod(this.m);
            else return x;
        }

        function cRevert(x) {
            return x;
        }

        function cReduce(x) {
            x.divRemTo(this.m, null, x);
        }

        function cMulTo(x, y, r) {
            x.multiplyTo(y, r);
            this.reduce(r);
        }

        function cSqrTo(x, r) {
            x.squareTo(r);
            this.reduce(r);
        }

        Classic.prototype.convert = cConvert;
        Classic.prototype.revert = cRevert;
        Classic.prototype.reduce = cReduce;
        Classic.prototype.mulTo = cMulTo;
        Classic.prototype.sqrTo = cSqrTo;

// (protected) return "-1/this % 2^DB"; useful for Mont. reduction
// justification:
//         xy == 1 (mod m)
//         xy =  1+km
//   xy(2-xy) = (1+km)(1-km)
// x[y(2-xy)] = 1-k^2m^2
// x[y(2-xy)] == 1 (mod m^2)
// if y is 1/x mod m, then y(2-xy) is 1/x mod m^2
// should reduce x and y(2-xy) by m^2 at each step to keep size bounded.
// JS multiply "overflows" differently from C/C++, so care is needed here.
        function bnpInvDigit() {
            if (this.t < 1) return 0;
            var x = this.data[0];
            if ((x & 1) == 0) return 0;
            var y = x & 3;		// y == 1/x mod 2^2
            y = (y * (2 - (x & 0xf) * y)) & 0xf;	// y == 1/x mod 2^4
            y = (y * (2 - (x & 0xff) * y)) & 0xff;	// y == 1/x mod 2^8
            y = (y * (2 - (((x & 0xffff) * y) & 0xffff))) & 0xffff;	// y == 1/x mod 2^16
            // last step - calculate inverse mod DV directly;
            // assumes 16 < DB <= 32 and assumes ability to handle 48-bit ints
            y = (y * (2 - x * y % this.DV)) % this.DV;		// y == 1/x mod 2^dbits
            // we really want the negative inverse, and -DV < y < DV
            return (y > 0) ? this.DV - y : -y;
        }

// Montgomery reduction
        function Montgomery(m) {
            this.m = m;
            this.mp = m.invDigit();
            this.mpl = this.mp & 0x7fff;
            this.mph = this.mp >> 15;
            this.um = (1 << (m.DB - 15)) - 1;
            this.mt2 = 2 * m.t;
        }

// xR mod m
        function montConvert(x) {
            var r = nbi();
            x.abs().dlShiftTo(this.m.t, r);
            r.divRemTo(this.m, null, r);
            if (x.s < 0 && r.compareTo(BigInteger.ZERO) > 0) this.m.subTo(r, r);
            return r;
        }

// x/R mod m
        function montRevert(x) {
            var r = nbi();
            x.copyTo(r);
            this.reduce(r);
            return r;
        }

// x = x/R mod m (HAC 14.32)
        function montReduce(x) {
            while (x.t <= this.mt2)	// pad x so am has enough room later
                x.data[x.t++] = 0;
            for (var i = 0; i < this.m.t; ++i) {
                // faster way of calculating u0 = x.data[i]*mp mod DV
                var j = x.data[i] & 0x7fff;
                var u0 = (j * this.mpl + (((j * this.mph + (x.data[i] >> 15) * this.mpl) & this.um) << 15)) & x.DM;
                // use am to combine the multiply-shift-add into one call
                j = i + this.m.t;
                x.data[j] += this.m.am(0, u0, x, i, 0, this.m.t);
                // propagate carry
                while (x.data[j] >= x.DV) {
                    x.data[j] -= x.DV;
                    x.data[++j]++;
                }
            }
            x.clamp();
            x.drShiftTo(this.m.t, x);
            if (x.compareTo(this.m) >= 0) x.subTo(this.m, x);
        }

// r = "x^2/R mod m"; x != r
        function montSqrTo(x, r) {
            x.squareTo(r);
            this.reduce(r);
        }

// r = "xy/R mod m"; x,y != r
        function montMulTo(x, y, r) {
            x.multiplyTo(y, r);
            this.reduce(r);
        }

        Montgomery.prototype.convert = montConvert;
        Montgomery.prototype.revert = montRevert;
        Montgomery.prototype.reduce = montReduce;
        Montgomery.prototype.mulTo = montMulTo;
        Montgomery.prototype.sqrTo = montSqrTo;

// (protected) true iff this is even
        function bnpIsEven() {
            return ((this.t > 0) ? (this.data[0] & 1) : this.s) == 0;
        }

// (protected) this^e, e < 2^32, doing sqr and mul with "r" (HAC 14.79)
        function bnpExp(e, z) {
            if (e > 0xffffffff || e < 1) return BigInteger.ONE;
            var r = nbi(), r2 = nbi(), g = z.convert(this), i = nbits(e) - 1;
            g.copyTo(r);
            while (--i >= 0) {
                z.sqrTo(r, r2);
                if ((e & (1 << i)) > 0) z.mulTo(r2, g, r);
                else {
                    var t = r;
                    r = r2;
                    r2 = t;
                }
            }
            return z.revert(r);
        }

// (public) this^e % m, 0 <= e < 2^32
        function bnModPowInt(e, m) {
            var z;
            if (e < 256 || m.isEven()) z = new Classic(m); else z = new Montgomery(m);
            return this.exp(e, z);
        }

// protected
        BigInteger.prototype.copyTo = bnpCopyTo;
        BigInteger.prototype.fromInt = bnpFromInt;
        BigInteger.prototype.fromString = bnpFromString;
        BigInteger.prototype.clamp = bnpClamp;
        BigInteger.prototype.dlShiftTo = bnpDLShiftTo;
        BigInteger.prototype.drShiftTo = bnpDRShiftTo;
        BigInteger.prototype.lShiftTo = bnpLShiftTo;
        BigInteger.prototype.rShiftTo = bnpRShiftTo;
        BigInteger.prototype.subTo = bnpSubTo;
        BigInteger.prototype.multiplyTo = bnpMultiplyTo;
        BigInteger.prototype.squareTo = bnpSquareTo;
        BigInteger.prototype.divRemTo = bnpDivRemTo;
        BigInteger.prototype.invDigit = bnpInvDigit;
        BigInteger.prototype.isEven = bnpIsEven;
        BigInteger.prototype.exp = bnpExp;

// public
        BigInteger.prototype.toString = bnToString;
        BigInteger.prototype.negate = bnNegate;
        BigInteger.prototype.abs = bnAbs;
        BigInteger.prototype.compareTo = bnCompareTo;
        BigInteger.prototype.bitLength = bnBitLength;
        BigInteger.prototype.mod = bnMod;
        BigInteger.prototype.modPowInt = bnModPowInt;

// "constants"
        BigInteger.ZERO = nbv(0);
        BigInteger.ONE = nbv(1);

// jsbn2 lib

//Copyright (c) 2005-2009  Tom Wu
//All Rights Reserved.
//See "LICENSE" for details (See jsbn.js for LICENSE).

//Extended JavaScript BN functions, required for RSA private ops.

//Version 1.1: new BigInteger("0", 10) returns "proper" zero

//(public)
        function bnClone() {
            var r = nbi();
            this.copyTo(r);
            return r;
        }

//(public) return value as integer
        function bnIntValue() {
            if (this.s < 0) {
                if (this.t == 1) return this.data[0] - this.DV;
                else if (this.t == 0) return -1;
            } else if (this.t == 1) return this.data[0];
            else if (this.t == 0) return 0;
// assumes 16 < DB < 32
            return ((this.data[1] & ((1 << (32 - this.DB)) - 1)) << this.DB) | this.data[0];
        }

//(public) return value as byte
        function bnByteValue() {
            return (this.t == 0) ? this.s : (this.data[0] << 24) >> 24;
        }

//(public) return value as short (assumes DB>=16)
        function bnShortValue() {
            return (this.t == 0) ? this.s : (this.data[0] << 16) >> 16;
        }

//(protected) return x s.t. r^x < DV
        function bnpChunkSize(r) {
            return Math.floor(Math.LN2 * this.DB / Math.log(r));
        }

//(public) 0 if this == 0, 1 if this > 0
        function bnSigNum() {
            if (this.s < 0) return -1;
            else if (this.t <= 0 || (this.t == 1 && this.data[0] <= 0)) return 0;
            else return 1;
        }

//(protected) convert to radix string
        function bnpToRadix(b) {
            if (b == null) b = 10;
            if (this.signum() == 0 || b < 2 || b > 36) return "0";
            var cs = this.chunkSize(b);
            var a = Math.pow(b, cs);
            var d = nbv(a), y = nbi(), z = nbi(), r = "";
            this.divRemTo(d, y, z);
            while (y.signum() > 0) {
                r = (a + z.intValue()).toString(b).substr(1) + r;
                y.divRemTo(d, y, z);
            }
            return z.intValue().toString(b) + r;
        }

//(protected) convert from radix string
        function bnpFromRadix(s, b) {
            this.fromInt(0);
            if (b == null) b = 10;
            var cs = this.chunkSize(b);
            var d = Math.pow(b, cs), mi = false, j = 0, w = 0;
            for (var i = 0; i < s.length; ++i) {
                var x = intAt(s, i);
                if (x < 0) {
                    if (s.charAt(i) == "-" && this.signum() == 0) mi = true;
                    continue;
                }
                w = b * w + x;
                if (++j >= cs) {
                    this.dMultiply(d);
                    this.dAddOffset(w, 0);
                    j = 0;
                    w = 0;
                }
            }
            if (j > 0) {
                this.dMultiply(Math.pow(b, j));
                this.dAddOffset(w, 0);
            }
            if (mi) BigInteger.ZERO.subTo(this, this);
        }

//(protected) alternate constructor
        function bnpFromNumber(a, b, c) {
            if ("number" == typeof b) {
                // new BigInteger(int,int,RNG)
                if (a < 2) this.fromInt(1);
                else {
                    this.fromNumber(a, c);
                    if (!this.testBit(a - 1))  // force MSB set
                        this.bitwiseTo(BigInteger.ONE.shiftLeft(a - 1), op_or, this);
                    if (this.isEven()) this.dAddOffset(1, 0); // force odd
                    while (!this.isProbablePrime(b)) {
                        this.dAddOffset(2, 0);
                        if (this.bitLength() > a) this.subTo(BigInteger.ONE.shiftLeft(a - 1), this);
                    }
                }
            } else {
                // new BigInteger(int,RNG)
                var x = new Array(), t = a & 7;
                x.length = (a >> 3) + 1;
                b.nextBytes(x);
                if (t > 0) x[0] &= ((1 << t) - 1); else x[0] = 0;
                this.fromString(x, 256);
            }
        }

//(public) convert to bigendian byte array
        function bnToByteArray() {
            var i = this.t, r = new Array();
            r[0] = this.s;
            var p = this.DB - (i * this.DB) % 8, d, k = 0;
            if (i-- > 0) {
                if (p < this.DB && (d = this.data[i] >> p) != (this.s & this.DM) >> p)
                    r[k++] = d | (this.s << (this.DB - p));
                while (i >= 0) {
                    if (p < 8) {
                        d = (this.data[i] & ((1 << p) - 1)) << (8 - p);
                        d |= this.data[--i] >> (p += this.DB - 8);
                    } else {
                        d = (this.data[i] >> (p -= 8)) & 0xff;
                        if (p <= 0) {
                            p += this.DB;
                            --i;
                        }
                    }
                    if ((d & 0x80) != 0) d |= -256;
                    if (k == 0 && (this.s & 0x80) != (d & 0x80)) ++k;
                    if (k > 0 || d != this.s) r[k++] = d;
                }
            }
            return r;
        }

        function bnEquals(a) {
            return (this.compareTo(a) == 0);
        }

        function bnMin(a) {
            return (this.compareTo(a) < 0) ? this : a;
        }

        function bnMax(a) {
            return (this.compareTo(a) > 0) ? this : a;
        }

//(protected) r = this op a (bitwise)
        function bnpBitwiseTo(a, op, r) {
            var i, f, m = Math.min(a.t, this.t);
            for (i = 0; i < m; ++i) r.data[i] = op(this.data[i], a.data[i]);
            if (a.t < this.t) {
                f = a.s & this.DM;
                for (i = m; i < this.t; ++i) r.data[i] = op(this.data[i], f);
                r.t = this.t;
            } else {
                f = this.s & this.DM;
                for (i = m; i < a.t; ++i) r.data[i] = op(f, a.data[i]);
                r.t = a.t;
            }
            r.s = op(this.s, a.s);
            r.clamp();
        }

//(public) this & a
        function op_and(x, y) {
            return x & y;
        }

        function bnAnd(a) {
            var r = nbi();
            this.bitwiseTo(a, op_and, r);
            return r;
        }

//(public) this | a
        function op_or(x, y) {
            return x | y;
        }

        function bnOr(a) {
            var r = nbi();
            this.bitwiseTo(a, op_or, r);
            return r;
        }

//(public) this ^ a
        function op_xor(x, y) {
            return x ^ y;
        }

        function bnXor(a) {
            var r = nbi();
            this.bitwiseTo(a, op_xor, r);
            return r;
        }

//(public) this & ~a
        function op_andnot(x, y) {
            return x & ~y;
        }

        function bnAndNot(a) {
            var r = nbi();
            this.bitwiseTo(a, op_andnot, r);
            return r;
        }

//(public) ~this
        function bnNot() {
            var r = nbi();
            for (var i = 0; i < this.t; ++i) r.data[i] = this.DM & ~this.data[i];
            r.t = this.t;
            r.s = ~this.s;
            return r;
        }

//(public) this << n
        function bnShiftLeft(n) {
            var r = nbi();
            if (n < 0) this.rShiftTo(-n, r); else this.lShiftTo(n, r);
            return r;
        }

//(public) this >> n
        function bnShiftRight(n) {
            var r = nbi();
            if (n < 0) this.lShiftTo(-n, r); else this.rShiftTo(n, r);
            return r;
        }

//return index of lowest 1-bit in x, x < 2^31
        function lbit(x) {
            if (x == 0) return -1;
            var r = 0;
            if ((x & 0xffff) == 0) {
                x >>= 16;
                r += 16;
            }
            if ((x & 0xff) == 0) {
                x >>= 8;
                r += 8;
            }
            if ((x & 0xf) == 0) {
                x >>= 4;
                r += 4;
            }
            if ((x & 3) == 0) {
                x >>= 2;
                r += 2;
            }
            if ((x & 1) == 0) ++r;
            return r;
        }

//(public) returns index of lowest 1-bit (or -1 if none)
        function bnGetLowestSetBit() {
            for (var i = 0; i < this.t; ++i)
                if (this.data[i] != 0) return i * this.DB + lbit(this.data[i]);
            if (this.s < 0) return this.t * this.DB;
            return -1;
        }

//return number of 1 bits in x
        function cbit(x) {
            var r = 0;
            while (x != 0) {
                x &= x - 1;
                ++r;
            }
            return r;
        }

//(public) return number of set bits
        function bnBitCount() {
            var r = 0, x = this.s & this.DM;
            for (var i = 0; i < this.t; ++i) r += cbit(this.data[i] ^ x);
            return r;
        }

//(public) true iff nth bit is set
        function bnTestBit(n) {
            var j = Math.floor(n / this.DB);
            if (j >= this.t) return (this.s != 0);
            return ((this.data[j] & (1 << (n % this.DB))) != 0);
        }

//(protected) this op (1<<n)
        function bnpChangeBit(n, op) {
            var r = BigInteger.ONE.shiftLeft(n);
            this.bitwiseTo(r, op, r);
            return r;
        }

//(public) this | (1<<n)
        function bnSetBit(n) {
            return this.changeBit(n, op_or);
        }

//(public) this & ~(1<<n)
        function bnClearBit(n) {
            return this.changeBit(n, op_andnot);
        }

//(public) this ^ (1<<n)
        function bnFlipBit(n) {
            return this.changeBit(n, op_xor);
        }

//(protected) r = this + a
        function bnpAddTo(a, r) {
            var i = 0, c = 0, m = Math.min(a.t, this.t);
            while (i < m) {
                c += this.data[i] + a.data[i];
                r.data[i++] = c & this.DM;
                c >>= this.DB;
            }
            if (a.t < this.t) {
                c += a.s;
                while (i < this.t) {
                    c += this.data[i];
                    r.data[i++] = c & this.DM;
                    c >>= this.DB;
                }
                c += this.s;
            } else {
                c += this.s;
                while (i < a.t) {
                    c += a.data[i];
                    r.data[i++] = c & this.DM;
                    c >>= this.DB;
                }
                c += a.s;
            }
            r.s = (c < 0) ? -1 : 0;
            if (c > 0) r.data[i++] = c;
            else if (c < -1) r.data[i++] = this.DV + c;
            r.t = i;
            r.clamp();
        }

//(public) this + a
        function bnAdd(a) {
            var r = nbi();
            this.addTo(a, r);
            return r;
        }

//(public) this - a
        function bnSubtract(a) {
            var r = nbi();
            this.subTo(a, r);
            return r;
        }

//(public) this * a
        function bnMultiply(a) {
            var r = nbi();
            this.multiplyTo(a, r);
            return r;
        }

//(public) this / a
        function bnDivide(a) {
            var r = nbi();
            this.divRemTo(a, r, null);
            return r;
        }

//(public) this % a
        function bnRemainder(a) {
            var r = nbi();
            this.divRemTo(a, null, r);
            return r;
        }

//(public) [this/a,this%a]
        function bnDivideAndRemainder(a) {
            var q = nbi(), r = nbi();
            this.divRemTo(a, q, r);
            return new Array(q, r);
        }

//(protected) this *= n, this >= 0, 1 < n < DV
        function bnpDMultiply(n) {
            this.data[this.t] = this.am(0, n - 1, this, 0, 0, this.t);
            ++this.t;
            this.clamp();
        }

//(protected) this += n << w words, this >= 0
        function bnpDAddOffset(n, w) {
            if (n == 0) return;
            while (this.t <= w) this.data[this.t++] = 0;
            this.data[w] += n;
            while (this.data[w] >= this.DV) {
                this.data[w] -= this.DV;
                if (++w >= this.t) this.data[this.t++] = 0;
                ++this.data[w];
            }
        }

//A "null" reducer
        function NullExp() {
        }

        function nNop(x) {
            return x;
        }

        function nMulTo(x, y, r) {
            x.multiplyTo(y, r);
        }

        function nSqrTo(x, r) {
            x.squareTo(r);
        }

        NullExp.prototype.convert = nNop;
        NullExp.prototype.revert = nNop;
        NullExp.prototype.mulTo = nMulTo;
        NullExp.prototype.sqrTo = nSqrTo;

//(public) this^e
        function bnPow(e) {
            return this.exp(e, new NullExp());
        }

//(protected) r = lower n words of "this * a", a.t <= n
//"this" should be the larger one if appropriate.
        function bnpMultiplyLowerTo(a, n, r) {
            var i = Math.min(this.t + a.t, n);
            r.s = 0; // assumes a,this >= 0
            r.t = i;
            while (i > 0) r.data[--i] = 0;
            var j;
            for (j = r.t - this.t; i < j; ++i) r.data[i + this.t] = this.am(0, a.data[i], r, i, 0, this.t);
            for (j = Math.min(a.t, n); i < j; ++i) this.am(0, a.data[i], r, i, 0, n - i);
            r.clamp();
        }

//(protected) r = "this * a" without lower n words, n > 0
//"this" should be the larger one if appropriate.
        function bnpMultiplyUpperTo(a, n, r) {
            --n;
            var i = r.t = this.t + a.t - n;
            r.s = 0; // assumes a,this >= 0
            while (--i >= 0) r.data[i] = 0;
            for (i = Math.max(n - this.t, 0); i < a.t; ++i)
                r.data[this.t + i - n] = this.am(n - i, a.data[i], r, 0, 0, this.t + i - n);
            r.clamp();
            r.drShiftTo(1, r);
        }

//Barrett modular reduction
        function Barrett(m) {
// setup Barrett
            this.r2 = nbi();
            this.q3 = nbi();
            BigInteger.ONE.dlShiftTo(2 * m.t, this.r2);
            this.mu = this.r2.divide(m);
            this.m = m;
        }

        function barrettConvert(x) {
            if (x.s < 0 || x.t > 2 * this.m.t) return x.mod(this.m);
            else if (x.compareTo(this.m) < 0) return x;
            else {
                var r = nbi();
                x.copyTo(r);
                this.reduce(r);
                return r;
            }
        }

        function barrettRevert(x) {
            return x;
        }

//x = x mod m (HAC 14.42)
        function barrettReduce(x) {
            x.drShiftTo(this.m.t - 1, this.r2);
            if (x.t > this.m.t + 1) {
                x.t = this.m.t + 1;
                x.clamp();
            }
            this.mu.multiplyUpperTo(this.r2, this.m.t + 1, this.q3);
            this.m.multiplyLowerTo(this.q3, this.m.t + 1, this.r2);
            while (x.compareTo(this.r2) < 0) x.dAddOffset(1, this.m.t + 1);
            x.subTo(this.r2, x);
            while (x.compareTo(this.m) >= 0) x.subTo(this.m, x);
        }

//r = x^2 mod m; x != r
        function barrettSqrTo(x, r) {
            x.squareTo(r);
            this.reduce(r);
        }

//r = x*y mod m; x,y != r
        function barrettMulTo(x, y, r) {
            x.multiplyTo(y, r);
            this.reduce(r);
        }

        Barrett.prototype.convert = barrettConvert;
        Barrett.prototype.revert = barrettRevert;
        Barrett.prototype.reduce = barrettReduce;
        Barrett.prototype.mulTo = barrettMulTo;
        Barrett.prototype.sqrTo = barrettSqrTo;

//(public) this^e % m (HAC 14.85)
        function bnModPow(e, m) {
            var i = e.bitLength(), k, r = nbv(1), z;
            if (i <= 0) return r;
            else if (i < 18) k = 1;
            else if (i < 48) k = 3;
            else if (i < 144) k = 4;
            else if (i < 768) k = 5;
            else k = 6;
            if (i < 8)
                z = new Classic(m);
            else if (m.isEven())
                z = new Barrett(m);
            else
                z = new Montgomery(m);

// precomputation
            var g = new Array(), n = 3, k1 = k - 1, km = (1 << k) - 1;
            g[1] = z.convert(this);
            if (k > 1) {
                var g2 = nbi();
                z.sqrTo(g[1], g2);
                while (n <= km) {
                    g[n] = nbi();
                    z.mulTo(g2, g[n - 2], g[n]);
                    n += 2;
                }
            }

            var j = e.t - 1, w, is1 = true, r2 = nbi(), t;
            i = nbits(e.data[j]) - 1;
            while (j >= 0) {
                if (i >= k1) w = (e.data[j] >> (i - k1)) & km;
                else {
                    w = (e.data[j] & ((1 << (i + 1)) - 1)) << (k1 - i);
                    if (j > 0) w |= e.data[j - 1] >> (this.DB + i - k1);
                }

                n = k;
                while ((w & 1) == 0) {
                    w >>= 1;
                    --n;
                }
                if ((i -= n) < 0) {
                    i += this.DB;
                    --j;
                }
                if (is1) {  // ret == 1, don't bother squaring or multiplying it
                    g[w].copyTo(r);
                    is1 = false;
                } else {
                    while (n > 1) {
                        z.sqrTo(r, r2);
                        z.sqrTo(r2, r);
                        n -= 2;
                    }
                    if (n > 0) z.sqrTo(r, r2); else {
                        t = r;
                        r = r2;
                        r2 = t;
                    }
                    z.mulTo(r2, g[w], r);
                }

                while (j >= 0 && (e.data[j] & (1 << i)) == 0) {
                    z.sqrTo(r, r2);
                    t = r;
                    r = r2;
                    r2 = t;
                    if (--i < 0) {
                        i = this.DB - 1;
                        --j;
                    }
                }
            }
            return z.revert(r);
        }

//(public) gcd(this,a) (HAC 14.54)
        function bnGCD(a) {
            var x = (this.s < 0) ? this.negate() : this.clone();
            var y = (a.s < 0) ? a.negate() : a.clone();
            if (x.compareTo(y) < 0) {
                var t = x;
                x = y;
                y = t;
            }
            var i = x.getLowestSetBit(), g = y.getLowestSetBit();
            if (g < 0) return x;
            if (i < g) g = i;
            if (g > 0) {
                x.rShiftTo(g, x);
                y.rShiftTo(g, y);
            }
            while (x.signum() > 0) {
                if ((i = x.getLowestSetBit()) > 0) x.rShiftTo(i, x);
                if ((i = y.getLowestSetBit()) > 0) y.rShiftTo(i, y);
                if (x.compareTo(y) >= 0) {
                    x.subTo(y, x);
                    x.rShiftTo(1, x);
                } else {
                    y.subTo(x, y);
                    y.rShiftTo(1, y);
                }
            }
            if (g > 0) y.lShiftTo(g, y);
            return y;
        }

//(protected) this % n, n < 2^26
        function bnpModInt(n) {
            if (n <= 0) return 0;
            var d = this.DV % n, r = (this.s < 0) ? n - 1 : 0;
            if (this.t > 0)
                if (d == 0) r = this.data[0] % n;
                else for (var i = this.t - 1; i >= 0; --i) r = (d * r + this.data[i]) % n;
            return r;
        }

//(public) 1/this % m (HAC 14.61)
        function bnModInverse(m) {
            var ac = m.isEven();
            if ((this.isEven() && ac) || m.signum() == 0) return BigInteger.ZERO;
            var u = m.clone(), v = this.clone();
            var a = nbv(1), b = nbv(0), c = nbv(0), d = nbv(1);
            while (u.signum() != 0) {
                while (u.isEven()) {
                    u.rShiftTo(1, u);
                    if (ac) {
                        if (!a.isEven() || !b.isEven()) {
                            a.addTo(this, a);
                            b.subTo(m, b);
                        }
                        a.rShiftTo(1, a);
                    } else if (!b.isEven()) b.subTo(m, b);
                    b.rShiftTo(1, b);
                }
                while (v.isEven()) {
                    v.rShiftTo(1, v);
                    if (ac) {
                        if (!c.isEven() || !d.isEven()) {
                            c.addTo(this, c);
                            d.subTo(m, d);
                        }
                        c.rShiftTo(1, c);
                    } else if (!d.isEven()) d.subTo(m, d);
                    d.rShiftTo(1, d);
                }
                if (u.compareTo(v) >= 0) {
                    u.subTo(v, u);
                    if (ac) a.subTo(c, a);
                    b.subTo(d, b);
                } else {
                    v.subTo(u, v);
                    if (ac) c.subTo(a, c);
                    d.subTo(b, d);
                }
            }
            if (v.compareTo(BigInteger.ONE) != 0) return BigInteger.ZERO;
            if (d.compareTo(m) >= 0) return d.subtract(m);
            if (d.signum() < 0) d.addTo(m, d); else return d;
            if (d.signum() < 0) return d.add(m); else return d;
        }

        var lowprimes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509];
        var lplim = (1 << 26) / lowprimes[lowprimes.length - 1];

//(public) test primality with certainty >= 1-.5^t
        function bnIsProbablePrime(t) {
            var i, x = this.abs();
            if (x.t == 1 && x.data[0] <= lowprimes[lowprimes.length - 1]) {
                for (i = 0; i < lowprimes.length; ++i)
                    if (x.data[0] == lowprimes[i]) return true;
                return false;
            }
            if (x.isEven()) return false;
            i = 1;
            while (i < lowprimes.length) {
                var m = lowprimes[i], j = i + 1;
                while (j < lowprimes.length && m < lplim) m *= lowprimes[j++];
                m = x.modInt(m);
                while (i < j) if (m % lowprimes[i++] == 0) return false;
            }
            return x.millerRabin(t);
        }

//(protected) true if probably prime (HAC 4.24, Miller-Rabin)
        function bnpMillerRabin(t) {
            var n1 = this.subtract(BigInteger.ONE);
            var k = n1.getLowestSetBit();
            if (k <= 0) return false;
            var r = n1.shiftRight(k);
            var prng = bnGetPrng();
            var a;
            for (var i = 0; i < t; ++i) {
                // select witness 'a' at random from between 1 and n1
                do {
                    a = new BigInteger(this.bitLength(), prng);
                }
                while (a.compareTo(BigInteger.ONE) <= 0 || a.compareTo(n1) >= 0);
                var y = a.modPow(r, this);
                if (y.compareTo(BigInteger.ONE) != 0 && y.compareTo(n1) != 0) {
                    var j = 1;
                    while (j++ < k && y.compareTo(n1) != 0) {
                        y = y.modPowInt(2, this);
                        if (y.compareTo(BigInteger.ONE) == 0) return false;
                    }
                    if (y.compareTo(n1) != 0) return false;
                }
            }
            return true;
        }

// get pseudo random number generator
        function bnGetPrng() {
            // create prng with api that matches BigInteger secure random
            return {
                // x is an array to fill with bytes
                nextBytes: function (x) {
                    for (var i = 0; i < x.length; ++i) {
                        x[i] = Math.floor(Math.random() * 0x0100);
                    }
                }
            };
        }

//protected
        BigInteger.prototype.chunkSize = bnpChunkSize;
        BigInteger.prototype.toRadix = bnpToRadix;
        BigInteger.prototype.fromRadix = bnpFromRadix;
        BigInteger.prototype.fromNumber = bnpFromNumber;
        BigInteger.prototype.bitwiseTo = bnpBitwiseTo;
        BigInteger.prototype.changeBit = bnpChangeBit;
        BigInteger.prototype.addTo = bnpAddTo;
        BigInteger.prototype.dMultiply = bnpDMultiply;
        BigInteger.prototype.dAddOffset = bnpDAddOffset;
        BigInteger.prototype.multiplyLowerTo = bnpMultiplyLowerTo;
        BigInteger.prototype.multiplyUpperTo = bnpMultiplyUpperTo;
        BigInteger.prototype.modInt = bnpModInt;
        BigInteger.prototype.millerRabin = bnpMillerRabin;

//public
        BigInteger.prototype.clone = bnClone;
        BigInteger.prototype.intValue = bnIntValue;
        BigInteger.prototype.byteValue = bnByteValue;
        BigInteger.prototype.shortValue = bnShortValue;
        BigInteger.prototype.signum = bnSigNum;
        BigInteger.prototype.toByteArray = bnToByteArray;
        BigInteger.prototype.equals = bnEquals;
        BigInteger.prototype.min = bnMin;
        BigInteger.prototype.max = bnMax;
        BigInteger.prototype.and = bnAnd;
        BigInteger.prototype.or = bnOr;
        BigInteger.prototype.xor = bnXor;
        BigInteger.prototype.andNot = bnAndNot;
        BigInteger.prototype.not = bnNot;
        BigInteger.prototype.shiftLeft = bnShiftLeft;
        BigInteger.prototype.shiftRight = bnShiftRight;
        BigInteger.prototype.getLowestSetBit = bnGetLowestSetBit;
        BigInteger.prototype.bitCount = bnBitCount;
        BigInteger.prototype.testBit = bnTestBit;
        BigInteger.prototype.setBit = bnSetBit;
        BigInteger.prototype.clearBit = bnClearBit;
        BigInteger.prototype.flipBit = bnFlipBit;
        BigInteger.prototype.add = bnAdd;
        BigInteger.prototype.subtract = bnSubtract;
        BigInteger.prototype.multiply = bnMultiply;
        BigInteger.prototype.divide = bnDivide;
        BigInteger.prototype.remainder = bnRemainder;
        BigInteger.prototype.divideAndRemainder = bnDivideAndRemainder;
        BigInteger.prototype.modPow = bnModPow;
        BigInteger.prototype.modInverse = bnModInverse;
        BigInteger.prototype.pow = bnPow;
        BigInteger.prototype.gcd = bnGCD;
        BigInteger.prototype.isProbablePrime = bnIsProbablePrime;

        kcaseagt.BigInteger = BigInteger;
    }

    function initRsa() {
        var BigInteger = kcaseagt.BigInteger;

        var rsaPublicKeyValidator = {
            // RSAPublicKey
            name: 'RSAPublicKey',
            tagClass: asn1.Class.UNIVERSAL,
            type: asn1.Type.SEQUENCE,
            constructed: true,
            value: [{
                // modulus (n)
                name: 'RSAPublicKey.modulus',
                tagClass: asn1.Class.UNIVERSAL,
                type: asn1.Type.INTEGER,
                constructed: false,
                capture: 'publicKeyModulus'
            }, {
                // publicExponent (e)
                name: 'RSAPublicKey.exponent',
                tagClass: asn1.Class.UNIVERSAL,
                type: asn1.Type.INTEGER,
                constructed: false,
                capture: 'publicKeyExponent'
            }]
        };

        var publicKeyValidator = {
            name: 'SubjectPublicKeyInfo',
            tagClass: asn1.Class.UNIVERSAL,
            type: asn1.Type.SEQUENCE,
            constructed: true,
            captureAsn1: 'subjectPublicKeyInfo',
            value: [{
                name: 'SubjectPublicKeyInfo.AlgorithmIdentifier',
                tagClass: asn1.Class.UNIVERSAL,
                type: asn1.Type.SEQUENCE,
                constructed: true,
                value: [{
                    name: 'AlgorithmIdentifier.algorithm',
                    tagClass: asn1.Class.UNIVERSAL,
                    type: asn1.Type.OID,
                    constructed: false,
                    capture: 'publicKeyOid'
                }]
            }, {
                // subjectPublicKey
                name: 'SubjectPublicKeyInfo.subjectPublicKey',
                tagClass: asn1.Class.UNIVERSAL,
                type: asn1.Type.BITSTRING,
                constructed: false,
                value: [{
                    // RSAPublicKey
                    name: 'SubjectPublicKeyInfo.subjectPublicKey.RSAPublicKey',
                    tagClass: asn1.Class.UNIVERSAL,
                    type: asn1.Type.SEQUENCE,
                    constructed: true,
                    optional: true,
                    captureAsn1: 'rsaPublicKey'
                }]
            }]
        };

        function setRsaPublicKey(n, e) {
            var key = {
                n: n,
                e: e
            };

            return key;
        }

        this.publicKeyFromPem = function (pem) {
            var msg = util.decode64(pem);

            // convert DER to ASN.1 object
            var obj = asn1.fromDer(msg);

            return rsa.publicKeyFromAsn1(obj);
        };

        this.publicKeyFromAsn1 = function (obj) {
            // get SubjectPublicKeyInfo
            var capture = {};
            var errors = [];
            if (asn1.validate(obj, publicKeyValidator, capture, errors)) {
                obj = capture.rsaPublicKey;
            }

            // get RSA params
            errors = [];
            if (!asn1.validate(obj, rsaPublicKeyValidator, capture, errors)) {
                var error = new Error('Cannot read public key. ' +
                    'ASN.1 object does not contain an RSAPublicKey.');
                error.errors = errors;
                throw error;
            }

            // FIXME: inefficient, get a BigInteger that uses byte strings
            var n = util.createBuffer(capture.publicKeyModulus).toHex();
            var e = util.createBuffer(capture.publicKeyExponent).toHex();

            // set public key
            return setRsaPublicKey(
                new BigInteger(n, 16),
                new BigInteger(e, 16));
        };

        function _encodePkcs1_v1_5(m, key, bt) {
            var eb = util.createBuffer();

            // get the length of the modulus in bytes
            var k = Math.ceil(key.n.bitLength() / 8);

            /* use PKCS#1 v1.5 padding */
            if (m.length > (k - 11)) {
                var error = new Error('Message is too long for PKCS#1 v1.5 padding.');
                error.length = m.length;
                error.max = k - 11;
                throw error;
            }

            // build the encryption block
            eb.putByte(0x00);
            eb.putByte(bt);

            // create the padding
            var padNum = k - 3 - m.length;
            var padByte;
            // private key op
            if (bt === 0x00 || bt === 0x01) {
                padByte = (bt === 0x00) ? 0x00 : 0xFF;
                for (var i = 0; i < padNum; ++i) {
                    eb.putByte(padByte);
                }
            } else {
                // public key op
                // pad with random non-zero values
                while (padNum > 0) {
                    var numZeros = 0;
                    var padBytes = random.generate(padNum);
                    for (var i = 0; i < padNum; ++i) {
                        padByte = padBytes.charCodeAt(i);
                        if (padByte === 0) {
                            ++numZeros;
                        } else {
                            eb.putByte(padByte);
                        }
                    }
                    padNum = numZeros;
                }
            }

            // zero followed by message
            eb.putByte(0x00);
            eb.putBytes(m);

            return eb;
        }

        function _decodePkcs1_v1_5(em, key, pub, ml) {
            // get the length of the modulus in bytes
            var k = Math.ceil(key.n.bitLength() / 8);

            // parse the encryption block
            var eb = util.createBuffer(em);
            var first = eb.getByte();
            var bt = eb.getByte();
            if (first !== 0x00 ||
                (pub && bt !== 0x00 && bt !== 0x01) ||
                (!pub && bt != 0x02) ||
                (pub && bt === 0x00 && typeof(ml) === 'undefined')) {
                throw new Error('Encryption block is invalid.');
            }

            var padNum = 0;
            if (bt === 0x00) {
                // check all padding bytes for 0x00
                padNum = k - 3 - ml;
                for (var i = 0; i < padNum; ++i) {
                    if (eb.getByte() !== 0x00) {
                        throw new Error('Encryption block is invalid.');
                    }
                }
            } else if (bt === 0x01) {
                // find the first byte that isn't 0xFF, should be after all padding
                padNum = 0;
                while (eb.length() > 1) {
                    if (eb.getByte() !== 0xFF) {
                        --eb.read;
                        break;
                    }
                    ++padNum;
                }
            } else if (bt === 0x02) {
                // look for 0x00 byte
                padNum = 0;
                while (eb.length() > 1) {
                    if (eb.getByte() === 0x00) {
                        --eb.read;
                        break;
                    }
                    ++padNum;
                }
            }

            // zero must be 0x00 and padNum must be (k - 3 - message length)
            var zero = eb.getByte();
            if (zero !== 0x00 || padNum !== (k - 3 - eb.length())) {
                throw new Error('Encryption block is invalid.');
            }

            return eb.getBytes();
        }

        var _modPow = function (x, key, pub) {
            if (pub) {
                return x.modPow(key.e, key.n);
            }

            if (!key.p || !key.q) {
                // allow calculation without CRT params (slow)
                return x.modPow(key.d, key.n);
            }

            // pre-compute dP, dQ, and qInv if necessary
            if (!key.dP) {
                key.dP = key.d.mod(key.p.subtract(BigInteger.ONE));
            }
            if (!key.dQ) {
                key.dQ = key.d.mod(key.q.subtract(BigInteger.ONE));
            }
            if (!key.qInv) {
                key.qInv = key.q.modInverse(key.p);
            }

            // cryptographic blinding
            var r;
            do {
                r = new BigInteger(
                    util.bytesToHex(random.getBytes(key.n.bitLength() / 8)),
                    16).mod(key.n);
            } while (r.equals(BigInteger.ZERO));
            x = x.multiply(r.modPow(key.e, key.n)).mod(key.n);

            // calculate xp and xq
            var xp = x.mod(key.p).modPow(key.dP, key.p);
            var xq = x.mod(key.q).modPow(key.dQ, key.q);

            // xp must be larger than xq to avoid signed bit usage
            while (xp.compareTo(xq) < 0) {
                xp = xp.add(key.p);
            }

            // do last step
            var y = xp.subtract(xq)
                .multiply(key.qInv).mod(key.p)
                .multiply(key.q).add(xq);

            // remove effect of random for cryptographic blinding
            y = y.multiply(r.modInverse(key.n)).mod(key.n);

            return y;
        };

        this.encrypt = function (m, key, bt) {
            var e, encData;
            while(true) {
                e = _encodePkcs1_v1_5(m, key, 0x02).getBytes();
                encData = _rsaEncrypt(e, key, true);
                if (encData.length == (key.n.bitLength()/8)) {
                    break;
                }
            }
            return encData;
        };

        function _rsaEncrypt(m, key, bt) {
            var pub = bt;
            var eb;

            // get the length of the modulus in bytes
            var k = Math.ceil(key.n.bitLength() / 8);

            if (bt !== false && bt !== true) {
                // legacy, default to PKCS#1 v1.5 padding
                pub = (bt === 0x02);
                eb = _encodePkcs1_v1_5(m, key, bt);
            } else {
                eb = util.createBuffer();
                eb.putBytes(m);
            }

            // load encryption block as big integer 'x'
            // FIXME: hex conversion inefficient, get BigInteger w/byte strings
            var x = new BigInteger(eb.toHex(), 16);

            // do RSA encryption
            var y = _modPow(x, key, pub);

            // convert y into the encrypted data byte string, if y is shorter in
            // bytes than k, then prepend zero bytes to fill up ed
            // FIXME: hex conversion inefficient, get BigInteger w/byte strings
            var yhex = y.toString(16);
            var ed = util.createBuffer();
            var zeros = k - Math.ceil(yhex.length / 2);
            while (zeros > 0) {
                ed.putByte(0x00);
                --zeros;
            }
            ed.putBytes(util.hexToBytes(yhex));
            return ed.getBytes();
        }

        this.decrypt = function (ed, key, pub, ml) {
            // get the length of the modulus in bytes
            var k = Math.ceil(key.n.bitLength() / 8);

            // error if the length of the encrypted data ED is not k
            if (ed.length !== k) {
                var error = new Error('Encrypted message length is invalid.');
                error.length = ed.length;
                error.expected = k;
                throw error;
            }

            // convert encrypted data into a big integer
            // FIXME: hex conversion inefficient, get BigInteger w/byte strings
            var y = new BigInteger(util.createBuffer(ed).toHex(), 16);

            // y must be less than the modulus or it wasn't the result of
            // a previous mod operation (encryption) using that modulus
            if (y.compareTo(key.n) >= 0) {
                throw new Error('Encrypted message is invalid.');
            }

            // do RSA decryption
            var x = _modPow(y, key, pub);

            // create the encryption block, if x is shorter in bytes than k, then
            // prepend zero bytes to fill up eb
            // FIXME: hex conversion inefficient, get BigInteger w/byte strings
            var xhex = x.toString(16);
            var eb = util.createBuffer();
            var zeros = k - Math.ceil(xhex.length / 2);
            while (zeros > 0) {
                eb.putByte(0x00);
                eb.putByte(0x01);
                --zeros;
            }

            eb.putBytes(util.hexToBytes(xhex));

            // return message
            return eb.getBytes();
        };

        this.verify = function (digest, signature, key) {
            var d = rsa.decrypt(signature, key, true, false);

            // remove padding
            d = _decodePkcs1_v1_5(d, key, true);
            var obj = asn1.fromDer(d);
            return digest === obj.value[1].value;
        };
    }

    function initRandom() {
        function _generate(byte) {
            var randValue;
            var cnt = byte / 32;
            var rem = byte % 32;

            randValue = util.createBuffer();

            if (cnt > 0) {
                for (var i = 1; i < cnt; i++) {
                    randValue.putBytes(_rand(32));
                }
            }

            if (rem > 0) {
                randValue.putBytes(_rand(rem));
            }

            if (cnt == 1 && rem == 0) {
                randValue.putBytes(_rand(32));
            }

            function _rand(b) {
                var hash = sha256.create();
                hash.update(Math.random(), "utf8");
                var digest = hash.digest();
                return digest.getBytes(b);
            }
            return randValue.getBytes();
        }

        this.generate = _generate;

        this.generateStr = function () {
            var bytes = _generate(32);
            var retBytes = "";
            var randBytes = util.createBuffer();

            randBytes.putBytes(bytes);

            for(var i = 0; i < randBytes.length(); i++) {
                var b = randBytes.getByte();

                if((b > 65 && b < 90) || (b > 97 && b < 122)) {
                    retBytes += String.fromCharCode(b);
                }
            }
            return retBytes;
        };
    }
    function initSeed() {
        this.startEncrypting = function (key, iv, output, mode) {
            var cipher = _createCipher({
                key: key,
                output: output,
                decrypt: false,
                mode: mode || (iv === null ? 'ECB' : 'CBC')
            });
            cipher.start(iv);
            return cipher;
        };

        this.createEncryptionCipher = function (key, mode) {
            return _createCipher({
                key: key,
                output: null,
                decrypt: false,
                mode: mode
            });
        };

        this.startDecrypting = function (key, iv, output, mode) {
            var cipher = _createCipher({
                key: key,
                output: output,
                decrypt: true,
                mode: mode || (iv === null ? 'ECB' : 'CBC')
            });
            cipher.start(iv);
            return cipher;
        };

        this.createDecryptionCipher = function (key, mode) {
            return _createCipher({
                key: key,
                output: null,
                decrypt: true,
                mode: mode
            });
        };

        this.Algorithm = function (name, mode) {
            if (!_isInitialized) {
                _initialize();
            }

            var self = this;
            self.name = name;
            self.mode = new mode({
                blockSize: 16,
                cipher: {
                    encrypt: function (inBlock, outBlock) {
                        return _updateBlock(self._w, inBlock, outBlock, false);
                    },
                    decrypt: function (inBlock, outBlock) {
                        return _updateBlock(self._w, inBlock, outBlock, true);
                    }
                }
            });
            self._init = false;
        };

        this.Algorithm.prototype.initialize = function (options) {
            if (this._init) {
                return;
            }

            var key = options.key;
            var tmp;

            if (typeof key === 'string' && (key.length === 16)) {
                // convert key string into byte buffer
                key = util.createBuffer(key);
            }
            else if (util.isArray(key) && (key.length === 16)) {
                // convert key integer array into byte buffer
                tmp = key;
                key = util.createBuffer();
                for (var i = 0; i < tmp.length; ++i) {
                    key.putByte(tmp[i]);
                }
            }

            // convert key byte buffer into 32-bit integer array
            if (!util.isArray(key)) {
                tmp = key;
                key = [];

                // key lengths of 16 bytes allowed
                var len = tmp.length();
                if (len === 16) {
                    len = len >>> 2;
                    for (var i = 0; i < len; ++i) {
                        key.push(tmp.getInt32());
                    }
                }
            }

            // key must be an array of 32-bit integers by now
            if (!util.isArray(key) || !(key.length === 4)) {
                throw new Error('Invalid key parameter.');
            }

            // encryption operation is always used for these modes
            var mode = this.mode.name;
            var encryptOp = false;//(['CFB', 'OFB', 'CTR', 'GCM'].indexOf(mode) !== -1);

            // do key expansion
            this._w = _expandKey(key, options.decrypt && !encryptOp);
            this._init = true;
        };
        var Algorithm = this.Algorithm;

        this._expandKey = function (key, decrypt) {
            if (!isInitialized) {
                initialize();
            }
            return _expandKey(key, decrypt);
        };

        this._updateBlock = _updateBlock;

        /** Register SEED algorithms **/
        registerAlgorithm('SEED-CBC', cipher.modes.cbc);

        function registerAlgorithm(name, mode) {
            var factory = function () {
                return new Algorithm(name, mode);
            };
            cipher.registerAlgorithm(name, factory);
        }

        /** SEED implementation **/
        var _isInitialized = false;
        var _ss0;
        var _ss1;
        var _ss2;
        var _ss3;

        function _initialize() {
            _isInitialized = true;

            _ss0 = [0x2989a1a8, 0x05858184, 0x16c6d2d4, 0x13c3d3d0, 0x14445054, 0x1d0d111c, 0x2c8ca0ac, 0x25052124,
                0x1d4d515c, 0x03434340, 0x18081018, 0x1e0e121c, 0x11415150, 0x3cccf0fc, 0x0acac2c8, 0x23436360,
                0x28082028, 0x04444044, 0x20002020, 0x1d8d919c, 0x20c0e0e0, 0x22c2e2e0, 0x08c8c0c8, 0x17071314,
                0x2585a1a4, 0x0f8f838c, 0x03030300, 0x3b4b7378, 0x3b8bb3b8, 0x13031310, 0x12c2d2d0, 0x2ecee2ec,
                0x30407070, 0x0c8c808c, 0x3f0f333c, 0x2888a0a8, 0x32023230, 0x1dcdd1dc, 0x36c6f2f4, 0x34447074,
                0x2ccce0ec, 0x15859194, 0x0b0b0308, 0x17475354, 0x1c4c505c, 0x1b4b5358, 0x3d8db1bc, 0x01010100,
                0x24042024, 0x1c0c101c, 0x33437370, 0x18889098, 0x10001010, 0x0cccc0cc, 0x32c2f2f0, 0x19c9d1d8,
                0x2c0c202c, 0x27c7e3e4, 0x32427270, 0x03838380, 0x1b8b9398, 0x11c1d1d0, 0x06868284, 0x09c9c1c8,
                0x20406060, 0x10405050, 0x2383a3a0, 0x2bcbe3e8, 0x0d0d010c, 0x3686b2b4, 0x1e8e929c, 0x0f4f434c,
                0x3787b3b4, 0x1a4a5258, 0x06c6c2c4, 0x38487078, 0x2686a2a4, 0x12021210, 0x2f8fa3ac, 0x15c5d1d4,
                0x21416160, 0x03c3c3c0, 0x3484b0b4, 0x01414140, 0x12425250, 0x3d4d717c, 0x0d8d818c, 0x08080008,
                0x1f0f131c, 0x19899198, 0x00000000, 0x19091118, 0x04040004, 0x13435350, 0x37c7f3f4, 0x21c1e1e0,
                0x3dcdf1fc, 0x36467274, 0x2f0f232c, 0x27072324, 0x3080b0b0, 0x0b8b8388, 0x0e0e020c, 0x2b8ba3a8,
                0x2282a2a0, 0x2e4e626c, 0x13839390, 0x0d4d414c, 0x29496168, 0x3c4c707c, 0x09090108, 0x0a0a0208,
                0x3f8fb3bc, 0x2fcfe3ec, 0x33c3f3f0, 0x05c5c1c4, 0x07878384, 0x14041014, 0x3ecef2fc, 0x24446064,
                0x1eced2dc, 0x2e0e222c, 0x0b4b4348, 0x1a0a1218, 0x06060204, 0x21012120, 0x2b4b6368, 0x26466264,
                0x02020200, 0x35c5f1f4, 0x12829290, 0x0a8a8288, 0x0c0c000c, 0x3383b3b0, 0x3e4e727c, 0x10c0d0d0,
                0x3a4a7278, 0x07474344, 0x16869294, 0x25c5e1e4, 0x26062224, 0x00808080, 0x2d8da1ac, 0x1fcfd3dc,
                0x2181a1a0, 0x30003030, 0x37073334, 0x2e8ea2ac, 0x36063234, 0x15051114, 0x22022220, 0x38083038,
                0x34c4f0f4, 0x2787a3a4, 0x05454144, 0x0c4c404c, 0x01818180, 0x29c9e1e8, 0x04848084, 0x17879394,
                0x35053134, 0x0bcbc3c8, 0x0ecec2cc, 0x3c0c303c, 0x31417170, 0x11011110, 0x07c7c3c4, 0x09898188,
                0x35457174, 0x3bcbf3f8, 0x1acad2d8, 0x38c8f0f8, 0x14849094, 0x19495158, 0x02828280, 0x04c4c0c4,
                0x3fcff3fc, 0x09494148, 0x39093138, 0x27476364, 0x00c0c0c0, 0x0fcfc3cc, 0x17c7d3d4, 0x3888b0b8,
                0x0f0f030c, 0x0e8e828c, 0x02424240, 0x23032320, 0x11819190, 0x2c4c606c, 0x1bcbd3d8, 0x2484a0a4,
                0x34043034, 0x31c1f1f0, 0x08484048, 0x02c2c2c0, 0x2f4f636c, 0x3d0d313c, 0x2d0d212c, 0x00404040,
                0x3e8eb2bc, 0x3e0e323c, 0x3c8cb0bc, 0x01c1c1c0, 0x2a8aa2a8, 0x3a8ab2b8, 0x0e4e424c, 0x15455154,
                0x3b0b3338, 0x1cccd0dc, 0x28486068, 0x3f4f737c, 0x1c8c909c, 0x18c8d0d8, 0x0a4a4248, 0x16465254,
                0x37477374, 0x2080a0a0, 0x2dcde1ec, 0x06464244, 0x3585b1b4, 0x2b0b2328, 0x25456164, 0x3acaf2f8,
                0x23c3e3e0, 0x3989b1b8, 0x3181b1b0, 0x1f8f939c, 0x1e4e525c, 0x39c9f1f8, 0x26c6e2e4, 0x3282b2b0,
                0x31013130, 0x2acae2e8, 0x2d4d616c, 0x1f4f535c, 0x24c4e0e4, 0x30c0f0f0, 0x0dcdc1cc, 0x08888088,
                0x16061214, 0x3a0a3238, 0x18485058, 0x14c4d0d4, 0x22426260, 0x29092128, 0x07070304, 0x33033330,
                0x28c8e0e8, 0x1b0b1318, 0x05050104, 0x39497178, 0x10809090, 0x2a4a6268, 0x2a0a2228, 0x1a8a9298];

            _ss1 = [0x38380830, 0xe828c8e0, 0x2c2d0d21, 0xa42686a2, 0xcc0fcfc3, 0xdc1eced2, 0xb03383b3, 0xb83888b0,
                0xac2f8fa3, 0x60204060, 0x54154551, 0xc407c7c3, 0x44044440, 0x6c2f4f63, 0x682b4b63, 0x581b4b53,
                0xc003c3c3, 0x60224262, 0x30330333, 0xb43585b1, 0x28290921, 0xa02080a0, 0xe022c2e2, 0xa42787a3,
                0xd013c3d3, 0x90118191, 0x10110111, 0x04060602, 0x1c1c0c10, 0xbc3c8cb0, 0x34360632, 0x480b4b43,
                0xec2fcfe3, 0x88088880, 0x6c2c4c60, 0xa82888a0, 0x14170713, 0xc404c4c0, 0x14160612, 0xf434c4f0,
                0xc002c2c2, 0x44054541, 0xe021c1e1, 0xd416c6d2, 0x3c3f0f33, 0x3c3d0d31, 0x8c0e8e82, 0x98188890,
                0x28280820, 0x4c0e4e42, 0xf436c6f2, 0x3c3e0e32, 0xa42585a1, 0xf839c9f1, 0x0c0d0d01, 0xdc1fcfd3,
                0xd818c8d0, 0x282b0b23, 0x64264662, 0x783a4a72, 0x24270723, 0x2c2f0f23, 0xf031c1f1, 0x70324272,
                0x40024242, 0xd414c4d0, 0x40014141, 0xc000c0c0, 0x70334373, 0x64274763, 0xac2c8ca0, 0x880b8b83,
                0xf437c7f3, 0xac2d8da1, 0x80008080, 0x1c1f0f13, 0xc80acac2, 0x2c2c0c20, 0xa82a8aa2, 0x34340430,
                0xd012c2d2, 0x080b0b03, 0xec2ecee2, 0xe829c9e1, 0x5c1d4d51, 0x94148490, 0x18180810, 0xf838c8f0,
                0x54174753, 0xac2e8ea2, 0x08080800, 0xc405c5c1, 0x10130313, 0xcc0dcdc1, 0x84068682, 0xb83989b1,
                0xfc3fcff3, 0x7c3d4d71, 0xc001c1c1, 0x30310131, 0xf435c5f1, 0x880a8a82, 0x682a4a62, 0xb03181b1,
                0xd011c1d1, 0x20200020, 0xd417c7d3, 0x00020202, 0x20220222, 0x04040400, 0x68284860, 0x70314171,
                0x04070703, 0xd81bcbd3, 0x9c1d8d91, 0x98198991, 0x60214161, 0xbc3e8eb2, 0xe426c6e2, 0x58194951,
                0xdc1dcdd1, 0x50114151, 0x90108090, 0xdc1cccd0, 0x981a8a92, 0xa02383a3, 0xa82b8ba3, 0xd010c0d0,
                0x80018181, 0x0c0f0f03, 0x44074743, 0x181a0a12, 0xe023c3e3, 0xec2ccce0, 0x8c0d8d81, 0xbc3f8fb3,
                0x94168692, 0x783b4b73, 0x5c1c4c50, 0xa02282a2, 0xa02181a1, 0x60234363, 0x20230323, 0x4c0d4d41,
                0xc808c8c0, 0x9c1e8e92, 0x9c1c8c90, 0x383a0a32, 0x0c0c0c00, 0x2c2e0e22, 0xb83a8ab2, 0x6c2e4e62,
                0x9c1f8f93, 0x581a4a52, 0xf032c2f2, 0x90128292, 0xf033c3f3, 0x48094941, 0x78384870, 0xcc0cccc0,
                0x14150511, 0xf83bcbf3, 0x70304070, 0x74354571, 0x7c3f4f73, 0x34350531, 0x10100010, 0x00030303,
                0x64244460, 0x6c2d4d61, 0xc406c6c2, 0x74344470, 0xd415c5d1, 0xb43484b0, 0xe82acae2, 0x08090901,
                0x74364672, 0x18190911, 0xfc3ecef2, 0x40004040, 0x10120212, 0xe020c0e0, 0xbc3d8db1, 0x04050501,
                0xf83acaf2, 0x00010101, 0xf030c0f0, 0x282a0a22, 0x5c1e4e52, 0xa82989a1, 0x54164652, 0x40034343,
                0x84058581, 0x14140410, 0x88098981, 0x981b8b93, 0xb03080b0, 0xe425c5e1, 0x48084840, 0x78394971,
                0x94178793, 0xfc3cccf0, 0x1c1e0e12, 0x80028282, 0x20210121, 0x8c0c8c80, 0x181b0b13, 0x5c1f4f53,
                0x74374773, 0x54144450, 0xb03282b2, 0x1c1d0d11, 0x24250521, 0x4c0f4f43, 0x00000000, 0x44064642,
                0xec2dcde1, 0x58184850, 0x50124252, 0xe82bcbe3, 0x7c3e4e72, 0xd81acad2, 0xc809c9c1, 0xfc3dcdf1,
                0x30300030, 0x94158591, 0x64254561, 0x3c3c0c30, 0xb43686b2, 0xe424c4e0, 0xb83b8bb3, 0x7c3c4c70,
                0x0c0e0e02, 0x50104050, 0x38390931, 0x24260622, 0x30320232, 0x84048480, 0x68294961, 0x90138393,
                0x34370733, 0xe427c7e3, 0x24240420, 0xa42484a0, 0xc80bcbc3, 0x50134353, 0x080a0a02, 0x84078783,
                0xd819c9d1, 0x4c0c4c40, 0x80038383, 0x8c0f8f83, 0xcc0ecec2, 0x383b0b33, 0x480a4a42, 0xb43787b3];

            _ss2 = [0xa1a82989, 0x81840585, 0xd2d416c6, 0xd3d013c3, 0x50541444, 0x111c1d0d, 0xa0ac2c8c, 0x21242505,
                0x515c1d4d, 0x43400343, 0x10181808, 0x121c1e0e, 0x51501141, 0xf0fc3ccc, 0xc2c80aca, 0x63602343,
                0x20282808, 0x40440444, 0x20202000, 0x919c1d8d, 0xe0e020c0, 0xe2e022c2, 0xc0c808c8, 0x13141707,
                0xa1a42585, 0x838c0f8f, 0x03000303, 0x73783b4b, 0xb3b83b8b, 0x13101303, 0xd2d012c2, 0xe2ec2ece,
                0x70703040, 0x808c0c8c, 0x333c3f0f, 0xa0a82888, 0x32303202, 0xd1dc1dcd, 0xf2f436c6, 0x70743444,
                0xe0ec2ccc, 0x91941585, 0x03080b0b, 0x53541747, 0x505c1c4c, 0x53581b4b, 0xb1bc3d8d, 0x01000101,
                0x20242404, 0x101c1c0c, 0x73703343, 0x90981888, 0x10101000, 0xc0cc0ccc, 0xf2f032c2, 0xd1d819c9,
                0x202c2c0c, 0xe3e427c7, 0x72703242, 0x83800383, 0x93981b8b, 0xd1d011c1, 0x82840686, 0xc1c809c9,
                0x60602040, 0x50501040, 0xa3a02383, 0xe3e82bcb, 0x010c0d0d, 0xb2b43686, 0x929c1e8e, 0x434c0f4f,
                0xb3b43787, 0x52581a4a, 0xc2c406c6, 0x70783848, 0xa2a42686, 0x12101202, 0xa3ac2f8f, 0xd1d415c5,
                0x61602141, 0xc3c003c3, 0xb0b43484, 0x41400141, 0x52501242, 0x717c3d4d, 0x818c0d8d, 0x00080808,
                0x131c1f0f, 0x91981989, 0x00000000, 0x11181909, 0x00040404, 0x53501343, 0xf3f437c7, 0xe1e021c1,
                0xf1fc3dcd, 0x72743646, 0x232c2f0f, 0x23242707, 0xb0b03080, 0x83880b8b, 0x020c0e0e, 0xa3a82b8b,
                0xa2a02282, 0x626c2e4e, 0x93901383, 0x414c0d4d, 0x61682949, 0x707c3c4c, 0x01080909, 0x02080a0a,
                0xb3bc3f8f, 0xe3ec2fcf, 0xf3f033c3, 0xc1c405c5, 0x83840787, 0x10141404, 0xf2fc3ece, 0x60642444,
                0xd2dc1ece, 0x222c2e0e, 0x43480b4b, 0x12181a0a, 0x02040606, 0x21202101, 0x63682b4b, 0x62642646,
                0x02000202, 0xf1f435c5, 0x92901282, 0x82880a8a, 0x000c0c0c, 0xb3b03383, 0x727c3e4e, 0xd0d010c0,
                0x72783a4a, 0x43440747, 0x92941686, 0xe1e425c5, 0x22242606, 0x80800080, 0xa1ac2d8d, 0xd3dc1fcf,
                0xa1a02181, 0x30303000, 0x33343707, 0xa2ac2e8e, 0x32343606, 0x11141505, 0x22202202, 0x30383808,
                0xf0f434c4, 0xa3a42787, 0x41440545, 0x404c0c4c, 0x81800181, 0xe1e829c9, 0x80840484, 0x93941787,
                0x31343505, 0xc3c80bcb, 0xc2cc0ece, 0x303c3c0c, 0x71703141, 0x11101101, 0xc3c407c7, 0x81880989,
                0x71743545, 0xf3f83bcb, 0xd2d81aca, 0xf0f838c8, 0x90941484, 0x51581949, 0x82800282, 0xc0c404c4,
                0xf3fc3fcf, 0x41480949, 0x31383909, 0x63642747, 0xc0c000c0, 0xc3cc0fcf, 0xd3d417c7, 0xb0b83888,
                0x030c0f0f, 0x828c0e8e, 0x42400242, 0x23202303, 0x91901181, 0x606c2c4c, 0xd3d81bcb, 0xa0a42484,
                0x30343404, 0xf1f031c1, 0x40480848, 0xc2c002c2, 0x636c2f4f, 0x313c3d0d, 0x212c2d0d, 0x40400040,
                0xb2bc3e8e, 0x323c3e0e, 0xb0bc3c8c, 0xc1c001c1, 0xa2a82a8a, 0xb2b83a8a, 0x424c0e4e, 0x51541545,
                0x33383b0b, 0xd0dc1ccc, 0x60682848, 0x737c3f4f, 0x909c1c8c, 0xd0d818c8, 0x42480a4a, 0x52541646,
                0x73743747, 0xa0a02080, 0xe1ec2dcd, 0x42440646, 0xb1b43585, 0x23282b0b, 0x61642545, 0xf2f83aca,
                0xe3e023c3, 0xb1b83989, 0xb1b03181, 0x939c1f8f, 0x525c1e4e, 0xf1f839c9, 0xe2e426c6, 0xb2b03282,
                0x31303101, 0xe2e82aca, 0x616c2d4d, 0x535c1f4f, 0xe0e424c4, 0xf0f030c0, 0xc1cc0dcd, 0x80880888,
                0x12141606, 0x32383a0a, 0x50581848, 0xd0d414c4, 0x62602242, 0x21282909, 0x03040707, 0x33303303,
                0xe0e828c8, 0x13181b0b, 0x01040505, 0x71783949, 0x90901080, 0x62682a4a, 0x22282a0a, 0x92981a8a];

            _ss3 = [0x08303838, 0xc8e0e828, 0x0d212c2d, 0x86a2a426, 0xcfc3cc0f, 0xced2dc1e, 0x83b3b033, 0x88b0b838,
                0x8fa3ac2f, 0x40606020, 0x45515415, 0xc7c3c407, 0x44404404, 0x4f636c2f, 0x4b63682b, 0x4b53581b,
                0xc3c3c003, 0x42626022, 0x03333033, 0x85b1b435, 0x09212829, 0x80a0a020, 0xc2e2e022, 0x87a3a427,
                0xc3d3d013, 0x81919011, 0x01111011, 0x06020406, 0x0c101c1c, 0x8cb0bc3c, 0x06323436, 0x4b43480b,
                0xcfe3ec2f, 0x88808808, 0x4c606c2c, 0x88a0a828, 0x07131417, 0xc4c0c404, 0x06121416, 0xc4f0f434,
                0xc2c2c002, 0x45414405, 0xc1e1e021, 0xc6d2d416, 0x0f333c3f, 0x0d313c3d, 0x8e828c0e, 0x88909818,
                0x08202828, 0x4e424c0e, 0xc6f2f436, 0x0e323c3e, 0x85a1a425, 0xc9f1f839, 0x0d010c0d, 0xcfd3dc1f,
                0xc8d0d818, 0x0b23282b, 0x46626426, 0x4a72783a, 0x07232427, 0x0f232c2f, 0xc1f1f031, 0x42727032,
                0x42424002, 0xc4d0d414, 0x41414001, 0xc0c0c000, 0x43737033, 0x47636427, 0x8ca0ac2c, 0x8b83880b,
                0xc7f3f437, 0x8da1ac2d, 0x80808000, 0x0f131c1f, 0xcac2c80a, 0x0c202c2c, 0x8aa2a82a, 0x04303434,
                0xc2d2d012, 0x0b03080b, 0xcee2ec2e, 0xc9e1e829, 0x4d515c1d, 0x84909414, 0x08101818, 0xc8f0f838,
                0x47535417, 0x8ea2ac2e, 0x08000808, 0xc5c1c405, 0x03131013, 0xcdc1cc0d, 0x86828406, 0x89b1b839,
                0xcff3fc3f, 0x4d717c3d, 0xc1c1c001, 0x01313031, 0xc5f1f435, 0x8a82880a, 0x4a62682a, 0x81b1b031,
                0xc1d1d011, 0x00202020, 0xc7d3d417, 0x02020002, 0x02222022, 0x04000404, 0x48606828, 0x41717031,
                0x07030407, 0xcbd3d81b, 0x8d919c1d, 0x89919819, 0x41616021, 0x8eb2bc3e, 0xc6e2e426, 0x49515819,
                0xcdd1dc1d, 0x41515011, 0x80909010, 0xccd0dc1c, 0x8a92981a, 0x83a3a023, 0x8ba3a82b, 0xc0d0d010,
                0x81818001, 0x0f030c0f, 0x47434407, 0x0a12181a, 0xc3e3e023, 0xcce0ec2c, 0x8d818c0d, 0x8fb3bc3f,
                0x86929416, 0x4b73783b, 0x4c505c1c, 0x82a2a022, 0x81a1a021, 0x43636023, 0x03232023, 0x4d414c0d,
                0xc8c0c808, 0x8e929c1e, 0x8c909c1c, 0x0a32383a, 0x0c000c0c, 0x0e222c2e, 0x8ab2b83a, 0x4e626c2e,
                0x8f939c1f, 0x4a52581a, 0xc2f2f032, 0x82929012, 0xc3f3f033, 0x49414809, 0x48707838, 0xccc0cc0c,
                0x05111415, 0xcbf3f83b, 0x40707030, 0x45717435, 0x4f737c3f, 0x05313435, 0x00101010, 0x03030003,
                0x44606424, 0x4d616c2d, 0xc6c2c406, 0x44707434, 0xc5d1d415, 0x84b0b434, 0xcae2e82a, 0x09010809,
                0x46727436, 0x09111819, 0xcef2fc3e, 0x40404000, 0x02121012, 0xc0e0e020, 0x8db1bc3d, 0x05010405,
                0xcaf2f83a, 0x01010001, 0xc0f0f030, 0x0a22282a, 0x4e525c1e, 0x89a1a829, 0x46525416, 0x43434003,
                0x85818405, 0x04101414, 0x89818809, 0x8b93981b, 0x80b0b030, 0xc5e1e425, 0x48404808, 0x49717839,
                0x87939417, 0xccf0fc3c, 0x0e121c1e, 0x82828002, 0x01212021, 0x8c808c0c, 0x0b13181b, 0x4f535c1f,
                0x47737437, 0x44505414, 0x82b2b032, 0x0d111c1d, 0x05212425, 0x4f434c0f, 0x00000000, 0x46424406,
                0xcde1ec2d, 0x48505818, 0x42525012, 0xcbe3e82b, 0x4e727c3e, 0xcad2d81a, 0xc9c1c809, 0xcdf1fc3d,
                0x00303030, 0x85919415, 0x45616425, 0x0c303c3c, 0x86b2b436, 0xc4e0e424, 0x8bb3b83b, 0x4c707c3c,
                0x0e020c0e, 0x40505010, 0x09313839, 0x06222426, 0x02323032, 0x84808404, 0x49616829, 0x83939013,
                0x07333437, 0xc7e3e427, 0x04202424, 0x84a0a424, 0xcbc3c80b, 0x43535013, 0x0a02080a, 0x87838407,
                0xc9d1d819, 0x4c404c0c, 0x83838003, 0x8f838c0f, 0xcec2cc0e, 0x0b33383b, 0x4a42480a, 0x87b3b437];

        }

        var _kc = [0x9e3779b9, 0x3c6ef373, 0x78dde6e6, 0xf1bbcdcc, 0xe3779b99, 0xc6ef3733, 0x8dde6e67, 0x1bbcdccf,
            0x3779b99e, 0x6ef3733c, 0xdde6e678, 0xbbcdccf1, 0x779b99e3, 0xef3733c6, 0xde6e678d, 0xbcdccf1b];

        function _expandKey(key, decrypt) {
            var kcIndex = 0;
            var wCount = 0;
            var w = new Array(32);

            var T = key.slice(0);
            var T0 = T[0] + T[2] - _kc[kcIndex];
            var T1 = T[1] + _kc[kcIndex] - T[3];
            w[wCount++] = _getValue(T0);
            w[wCount++] = _getValue(T1);

            for (kcIndex = 1; kcIndex < _kc.length; ++kcIndex) {
                if (kcIndex & 0x00000001) {
                    _oddF(T);
                }
                else {
                    _evenF(T);
                }

                T0 = T[0] + T[2] - _kc[kcIndex];
                T1 = T[1] + _kc[kcIndex] - T[3];
                w[wCount++] = _getValue(T0);
                w[wCount++] = _getValue(T1);
            }

            return w;
        }

        function _oddF(T) {
            var tmp = T[0];
            T[0] = (T[0] >>> 8) ^ (T[1] << 24);
            T[1] = (T[1] >>> 8) ^ (tmp << 24);
        }

        function _evenF(T) {
            var tmp = T[2];
            T[2] = (T[2] << 8) ^ (T[3] >>> 24);
            T[3] = (T[3] << 8) ^ (tmp >>> 24);
        }

        function _getValue(T) {
            return _ss0[(T & 0x000000ff)] ^ _ss1[((T >>> 8) & 0x000000ff)] ^ _ss2[((T >>> 16) & 0x000000ff)] ^ _ss3[((T >>> 24) & 0x000000ff)];
        }

        function _subF(T) {
            T = _ss0[(T & 0x000000ff)] ^ _ss1[((T >>> 8) & 0x000000ff)] ^ _ss2[((T >>> 16) & 0x000000ff)] ^ _ss3[((T >>> 24) & 0x000000ff)];
            return T;
            //return ((T < 0) ? (T & 0x7fffffff) | (0x80000000) : (T));
        }

        function _updateBlock(w, input, output, decrypt) {
            var T = input.slice(0);

            var roundNumber = w.length / 2;
            var wIndex = 0;
            if (decrypt) {
                wIndex = w.length - 1;
            }

            var tmp0, tmp1, kc0, kc1, T0, T1;
            for (var round = 0; round < roundNumber; ++round) {
                if (decrypt) {
                    kc1 = w[wIndex--];
                    kc0 = w[wIndex--];
                }
                else {
                    kc0 = w[wIndex++];
                    kc1 = w[wIndex++];
                }

                if (round & 0x00000001) {
                    T0 = T[0] ^ kc0;
                    T1 = T[1] ^ kc1;
                }
                else {
                    T0 = T[2] ^ kc0;
                    T1 = T[3] ^ kc1;
                }

                T1 = _subF(T0 ^ T1);
                T0 = _subF(T0 + T1);
                T1 = _subF(T0 + T1);

                T0 += T1;

                if (round & 0x00000001) {
                    T[2] ^= T0;
                    T[3] ^= T1;
                }
                else {
                    T[0] ^= T0;
                    T[1] ^= T1;
                }
            }

            output[0] = T[2];
            output[1] = T[3];
            output[2] = T[0];
            output[3] = T[1];
        }

        function _createCipher(options) {
            options = options || {};
            var mode = (options.mode || 'CBC').toUpperCase();
            var algorithm = 'SEED-' + mode;

            var cipherObj;
            if (options.decrypt) {
                cipherObj = cipher.createDecipher(algorithm, options.key);
            } else {
                cipherObj = cipher.createCipher(algorithm, options.key);
            }

            // backwards compatible start API
            var start = cipherObj.start;
            cipherObj.start = function (iv, options) {
                // backwards compatibility: support second arg as output buffer
                var output = null;
                if (options instanceof util.ByteBuffer) {
                    output = options;
                    options = {};
                }
                options = options || {};
                options.output = output;
                options.iv = iv;
                start.call(cipherObj, options);
            };
            return cipherObj;
        }
    }


function initSha256() {
    this.create = function () {
        // do initialization as necessary
        if (!_initialized) {
            _init();
        }

        // SHA-256 state contains eight 32-bit integers
        var _state = null;

        // input buffer
        var _input = util.createBuffer();

        // used for word storage
        var _w = new Array(64);

        // message digest object
        var md = {
            algorithm: 'sha256',
            blockLength: 64,
            digestLength: 32,
            // 56-bit length of message so far (does not including padding)
            messageLength: 0,
            // true 64-bit message length as two 32-bit ints
            messageLength64: [0, 0]
        };

        /**
         * Starts the digest.
         *
         * @return this digest object.
         */
        md.start = function () {
            md.messageLength = 0;
            md.messageLength64 = [0, 0];
            _input = util.createBuffer();
            _state = {
                h0: 0x6A09E667,
                h1: 0xBB67AE85,
                h2: 0x3C6EF372,
                h3: 0xA54FF53A,
                h4: 0x510E527F,
                h5: 0x9B05688C,
                h6: 0x1F83D9AB,
                h7: 0x5BE0CD19
            };
            return md;
        };
        // start digest automatically for first time
        md.start();

        /**
         * Updates the digest with the given message input. The given input can
         * treated as raw input (no encoding will be applied) or an encoding of
         * 'utf8' maybe given to encode the input using UTF-8.
         *
         * @param msg the message input to update with.
         * @param encoding the encoding to use (default: 'raw', other: 'utf8').
         *
         * @return this digest object.
         */
        md.update = function (msg, encoding) {
            if (encoding === 'utf8') {
                msg = util.encodeUtf8(msg);
            }

            // update message length
            md.messageLength += msg.length;
            md.messageLength64[0] += (msg.length / 0x100000000) >>> 0;
            md.messageLength64[1] += msg.length >>> 0;

            // add bytes to input buffer
            _input.putBytes(msg);

            // process bytes
            _update(_state, _w, _input);

            // compact input buffer every 2K or if empty
            if (_input.read > 2048 || _input.length() === 0) {
                _input.compact();
            }

            return md;
        };

        /**
         * Produces the digest.
         *
         * @return a byte buffer containing the digest value.
         */
        md.digest = function () {
            // 512 bits == 64 bytes, 448 bits == 56 bytes, 64 bits = 8 bytes
            // _padding starts with 1 byte with first bit is set in it which
            // is byte value 128, then there may be up to 63 other pad bytes
            var padBytes = util.createBuffer();
            padBytes.putBytes(_input.bytes());
            // 64 - (remaining msg + 8 bytes msg length) mod 64
            padBytes.putBytes(
                _padding.substr(0, 64 - ((md.messageLength64[1] + 8) & 0x3F)));

            /* Now append length of the message. The length is appended in bits
             as a 64-bit number in big-endian order. Since we store the length in
             bytes, we must multiply the 64-bit length by 8 (or left shift by 3). */
            padBytes.putInt32(
                (md.messageLength64[0] << 3) | (md.messageLength64[0] >>> 28));
            padBytes.putInt32(md.messageLength64[1] << 3);
            var s2 = {
                h0: _state.h0,
                h1: _state.h1,
                h2: _state.h2,
                h3: _state.h3,
                h4: _state.h4,
                h5: _state.h5,
                h6: _state.h6,
                h7: _state.h7
            };
            _update(s2, _w, padBytes);
            var rval = util.createBuffer();
            rval.putInt32(s2.h0);
            rval.putInt32(s2.h1);
            rval.putInt32(s2.h2);
            rval.putInt32(s2.h3);
            rval.putInt32(s2.h4);
            rval.putInt32(s2.h5);
            rval.putInt32(s2.h6);
            rval.putInt32(s2.h7);
            return rval;
        };

        return md;
    };

    // sha-256 padding bytes not initialized yet
    var _padding = null;
    var _initialized = false;

    // table of constants
    var _k = null;

    /**
     * Initializes the constant tables.
     */
    function _init() {
        // create padding
        _padding = String.fromCharCode(128);
        _padding += util.fillString(String.fromCharCode(0x00), 64);

        // create K table for SHA-256
        _k = [
            0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
            0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
            0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
            0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
            0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
            0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
            0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
            0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
            0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
            0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
            0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
            0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
            0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
            0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
            0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
            0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2];

        // now initialized
        _initialized = true;
    }

    /**
     * Updates a SHA-256 state with the given byte buffer.
     *
     * @param s the SHA-256 state to update.
     * @param w the array to use to store words.
     * @param bytes the byte buffer to update with.
     */
    function _update(s, w, bytes) {
        // consume 512 bit (64 byte) chunks
        var t1, t2, s0, s1, ch, maj, i, a, b, c, d, e, f, g, h;
        var len = bytes.length();
        while (len >= 64) {
            // the w array will be populated with sixteen 32-bit big-endian words
            // and then extended into 64 32-bit words according to SHA-256
            for (i = 0; i < 16; ++i) {
                w[i] = bytes.getInt32();
            }
            for (; i < 64; ++i) {
                // XOR word 2 words ago rot right 17, rot right 19, shft right 10
                t1 = w[i - 2];
                t1 =
                    ((t1 >>> 17) | (t1 << 15)) ^
                    ((t1 >>> 19) | (t1 << 13)) ^
                    (t1 >>> 10);
                // XOR word 15 words ago rot right 7, rot right 18, shft right 3
                t2 = w[i - 15];
                t2 =
                    ((t2 >>> 7) | (t2 << 25)) ^
                    ((t2 >>> 18) | (t2 << 14)) ^
                    (t2 >>> 3);
                // sum(t1, word 7 ago, t2, word 16 ago) modulo 2^32
                w[i] = (t1 + w[i - 7] + t2 + w[i - 16]) | 0;
            }

            // initialize hash value for this chunk
            a = s.h0;
            b = s.h1;
            c = s.h2;
            d = s.h3;
            e = s.h4;
            f = s.h5;
            g = s.h6;
            h = s.h7;

            // round function
            for (i = 0; i < 64; ++i) {
                // Sum1(e)
                s1 =
                    ((e >>> 6) | (e << 26)) ^
                    ((e >>> 11) | (e << 21)) ^
                    ((e >>> 25) | (e << 7));
                // Ch(e, f, g) (optimized the same way as SHA-1)
                ch = g ^ (e & (f ^ g));
                // Sum0(a)
                s0 =
                    ((a >>> 2) | (a << 30)) ^
                    ((a >>> 13) | (a << 19)) ^
                    ((a >>> 22) | (a << 10));
                // Maj(a, b, c) (optimized the same way as SHA-1)
                maj = (a & b) | (c & (a ^ b));

                // main algorithm
                t1 = h + s1 + ch + _k[i] + w[i];
                t2 = s0 + maj;
                h = g;
                g = f;
                f = e;
                e = (d + t1) | 0;
                d = c;
                c = b;
                b = a;
                a = (t1 + t2) | 0;
            }

            // update hash state
            s.h0 = (s.h0 + a) | 0;
            s.h1 = (s.h1 + b) | 0;
            s.h2 = (s.h2 + c) | 0;
            s.h3 = (s.h3 + d) | 0;
            s.h4 = (s.h4 + e) | 0;
            s.h5 = (s.h5 + f) | 0;
            s.h6 = (s.h6 + g) | 0;
            s.h7 = (s.h7 + h) | 0;
            len -= 64;
        }
    }
}

    function initCipher() {
        // registered algorithms
        this.algorithms = this.algorithms || {};

        this.createCipher = function (algorithm, key) {
            var api = algorithm;
            if (typeof api === 'string') {
                api = this.getAlgorithm(api);
                if (api) {
                    api = api();
                }
            }
            if (!api) {
                throw new Error('Unsupported algorithm: ' + algorithm);
            }

            // assume block cipher
            return new this.BlockCipher({
                algorithm: api,
                key: key,
                decrypt: false
            });
        };

        this.createDecipher = function (algorithm, key) {
            var api = algorithm;
            if (typeof api === 'string') {
                api = this.getAlgorithm(api);
                if (api) {
                    api = api();
                }
            }
            if (!api) {
                throw new Error('Unsupported algorithm: ' + algorithm);
            }

            // assume block cipher
            return new this.BlockCipher({
                algorithm: api,
                key: key,
                decrypt: true
            });
        };

        this.registerAlgorithm = function (name, algorithm) {
            name = name.toUpperCase();
            this.algorithms[name] = algorithm;
        };

        this.getAlgorithm = function (name) {
            name = name.toUpperCase();
            if (name in this.algorithms) {
                return this.algorithms[name];
            }
            return null;
        };

        var BlockCipher = this.BlockCipher = function (options) {
            this.algorithm = options.algorithm;
            this.mode = this.algorithm.mode;
            this.blockSize = this.mode.blockSize;
            this._finish = false;
            this._input = null;
            this.output = null;
            this._op = options.decrypt ? this.mode.decrypt : this.mode.encrypt;
            this._decrypt = options.decrypt;
            this.algorithm.initialize(options);
        };

        BlockCipher.prototype.start = function (options) {
            options = options || {};
            var opts = {};
            for (var key in options) {
                opts[key] = options[key];
            }
            opts.decrypt = this._decrypt;
            this._finish = false;
            this._input = util.createBuffer();
            this.output = options.output || util.createBuffer();
            this.mode.start(opts);
        };

        BlockCipher.prototype.update = function (input) {
            if (!this._finish) {
                // not finishing, so fill the input buffer with more input
                this._input.putBuffer(input);
            }

            // do cipher operation while input contains full blocks or if finishing
            while (this._input.length() >= this.blockSize ||
            (this._input.length() > 0 && this._finish)) {
                this._op.call(this.mode, this._input, this.output);
            }

            // free consumed memory from input buffer
            this._input.compact();
        };

        BlockCipher.prototype.finish = function (pad) {
            // backwards-compatibility w/deprecated padding API
            // Note: will overwrite padding functions even after another start() call
            if (pad && this.mode.name === 'CBC') {
                this.mode.pad = function (input) {
                    return pad(this.blockSize, input, false);
                };
                this.mode.unpad = function (output) {
                    return pad(this.blockSize, output, true);
                };
            }

            // build options for padding and afterFinish functions
            var options = {};
            options.decrypt = this._decrypt;

            // get # of bytes that won't fill a block
            options.overflow = this._input.length() % this.blockSize;

            if (!this._decrypt && this.mode.pad) {
                if (!this.mode.pad(this._input, options)) {
                    return false;
                }
            }

            // do final update
            this._finish = true;
            this.update();

            if (this._decrypt && this.mode.unpad) {
                if (!this.mode.unpad(this.output, options)) {
                    return false;
                }
            }

            if (this.mode.afterFinish) {
                if (!this.mode.afterFinish(this.output, options)) {
                    return false;
                }
            }

            return true;
        };
    }

    function initCipherModes() {
        /** Cipher-block Chaining (CBC) **/
        this.cbc = function (options) {
            options = options || {};
            this.name = 'CBC';
            this.cipher = options.cipher;
            this.blockSize = options.blockSize || 16;
            this._blocks = this.blockSize / 4;
            this._inBlock = new Array(this._blocks);
            this._outBlock = new Array(this._blocks);
        };

        this.cbc.prototype.start = function (options) {
            // Note: legacy support for using IV residue (has security flaws)
            // if IV is null, reuse block from previous processing
            if (options.iv === null) {
                // must have a previous block
                if (!this._prev) {
                    throw new Error('Invalid IV parameter.');
                }
                this._iv = this._prev.slice(0);
            } else if (!('iv' in options)) {
                throw new Error('Invalid IV parameter.');
            } else {
                // save IV as "previous" block
                this._iv = transformIV(options.iv);
                this._prev = this._iv.slice(0);
            }
        };

        this.cbc.prototype.encrypt = function (input, output) {
            // get next block
            // CBC XOR's IV (or previous block) with plaintext
            for (var i = 0; i < this._blocks; ++i) {
                this._inBlock[i] = this._prev[i] ^ input.getInt32();
            }

            // encrypt block
            this.cipher.encrypt(this._inBlock, this._outBlock);

            // write output, save previous block
            for (var i = 0; i < this._blocks; ++i) {
                output.putInt32(this._outBlock[i]);
            }
            this._prev = this._outBlock;
        };

        this.cbc.prototype.decrypt = function (input, output) {
            // get next block
            for (var i = 0; i < this._blocks; ++i) {
                this._inBlock[i] = input.getInt32();
            }

            // decrypt block
            this.cipher.decrypt(this._inBlock, this._outBlock);

            // write output, save previous ciphered block
            // CBC XOR's IV (or previous block) with ciphertext
            for (var i = 0; i < this._blocks; ++i) {
                output.putInt32(this._prev[i] ^ this._outBlock[i]);
            }
            this._prev = this._inBlock.slice(0);
        };

        this.cbc.prototype.pad = function (input, options) {
            // add PKCS#7 padding to block (each pad byte is the
            // value of the number of pad bytes)
            var padding = (input.length() === this.blockSize ?
                this.blockSize : (this.blockSize - input.length()));
            input.fillWithByte(padding, padding);
            return true;
        };

        this.cbc.prototype.unpad = function (output, options) {
            // check for error: input data not a multiple of blockSize
            if (options.overflow > 0) {
                return false;
            }

            // ensure padding byte count is valid
            var len = output.length();
            var count = output.at(len - 1);
            if (count > (this.blockSize << 2)) {
                return false;
            }

            // trim off padding bytes
            output.truncate(count);
            return true;
        };

        /** Utility functions */

        function transformIV(iv) {
            if (typeof iv === 'string') {
                // convert iv string into byte buffer
                iv = util.createBuffer(iv);
            }

            if (util.isArray(iv) && iv.length > 4) {
                // convert iv byte array into byte buffer
                var tmp = iv;
                iv = util.createBuffer();
                for (var i = 0; i < iv.length; ++i) {
                    iv.putByte(tmp[i]);
                }
            }
            if (!util.isArray(iv)) {
                // convert iv byte buffer into 32-bit integer array
                iv = [iv.getInt32(), iv.getInt32(), iv.getInt32(), iv.getInt32()];
            }

            return iv;
        }

        function inc32(block) {
            // increment last 32 bits of block only
            block[block.length - 1] = (block[block.length - 1] + 1) & 0xFFFFFFFF;
        }

        function from64To32(num) {
            // convert 64-bit number to two BE Int32s
            return [(num / 0x100000000) | 0, num & 0xFFFFFFFF];
        }
    }

    function initUtil() {
        this.getSelectedObject = function (classId) {
            var idStr, selectedObj = undefined;

            idStr = "." + classId;

            for (var i = 0, tempObject = $(idStr); i < tempObject.length; tempObject = tempObject.next()) {

                if (tempObject.data("selected") == 1) {
                    selectedObj = tempObject.eq(i);
                    break;
                }
            }

            return selectedObj;
        };

        this.setOption = function (options, input) {
            input = $.makeArray(input);
            var inputIndex = 0,
                inputLength = input.length,
                key,
                value;
            for (; inputIndex < inputLength; inputIndex++) {
                for (key in input[inputIndex]) {
                    value = input[inputIndex][key];
                    if (input[inputIndex].hasOwnProperty(key) && value !== undefined) {
                        // Clone objects
                        if ($.isPlainObject(value)) {
                            options[key] = $.isPlainObject(options[key]) ?
                                test({}, options[key], value) :
                                // Don't extend strings, arrays, etc. with objects
                                test({}, value);
                            // Copy everything else by reference
                        } else {
                            options[key] = value;
                        }
                    }
                }
            }
            return options;
        };

		/* 2017.07.31 DYLEE Windows 와 동일하게 Loading UI 추가 */
        this.spinner = {
            show: function (isOverlay) {
                var color = "";
                if (isOverlay != undefined) {
                    color = "background-color:rgba(0, 0, 0, 0.5);";
                }

                var overlayEl = $('<div class="isloading-overlay" style="'+color+'position:fixed; left:0; top:0; z-index: 10000; width: 100%; height: ' + $(window).height() + 'px;" />');

                $("body").prepend(overlayEl);

                var libRoot = prop.ROOT_DIR;
                var imgPath = libRoot + "/img/loading.png";

                var imgEl = $('<div style="background: url(' + imgPath + '); position:fixed; left:'+ (($(window).width()/2) - 175) +'px; top: '+ ((($(window).height())/2) - 100) +'px; z-index: 10001; width: 350px; height: 187px;" />');

                $("body").find(".isloading-overlay").first().prepend(imgEl);

            },
            hide: function () {
                $("body").find(".isloading-overlay").remove();
            }
        };
        
		/* 2017.08.02 DYLEE Windows 와 동일하게 비밀번호 관련 함수  추가 */
       this.getInputPassword = function(dialogId) {
            var pw = $("#" + dialogId + " ." + prop.cs.pwBox).val();
                return pw;
        };

		/* 2017.08.02 DYLEE Windows 와 동일하게 비밀번호 관련 함수  추가 */
        // Verify a valid password
        this.verifyInputPassword = function(_pw, _media) {
            if (_pw.length <= 0) {
                switch (_media) {
                    case prop.media.pkcs11:
                        alert(prop.strings.NO_INPUT_PIN);
                        break;
                    default:
                        alert(prop.strings.NO_INPUT_PASSWORD);
                        $("#" + prop.id.dialog.cert + " ." + prop.cs.pwBox).val("");
                }
                return false;
            }

            return true;
        };
        // define isArray
        this.isArray = Array.isArray || function (x) {
                return Object.prototype.toString.call(x) === '[object Array]';
            };

        // define isArrayBuffer
        this.isArrayBuffer = function (x) {
            return typeof ArrayBuffer !== 'undefined' && x instanceof ArrayBuffer;
        };

        // define isArrayBufferView
        var _arrayBufferViews = [];
        if (typeof DataView !== 'undefined') {
            _arrayBufferViews.push(DataView);
        }
        if (typeof Int8Array !== 'undefined') {
            _arrayBufferViews.push(Int8Array);
        }
        if (typeof Uint8Array !== 'undefined') {
            _arrayBufferViews.push(Uint8Array);
        }
        if (typeof Uint8ClampedArray !== 'undefined') {
            _arrayBufferViews.push(Uint8ClampedArray);
        }
        if (typeof Int16Array !== 'undefined') {
            _arrayBufferViews.push(Int16Array);
        }
        if (typeof Uint16Array !== 'undefined') {
            _arrayBufferViews.push(Uint16Array);
        }
        if (typeof Int32Array !== 'undefined') {
            _arrayBufferViews.push(Int32Array);
        }
        if (typeof Uint32Array !== 'undefined') {
            _arrayBufferViews.push(Uint32Array);
        }
        if (typeof Float32Array !== 'undefined') {
            _arrayBufferViews.push(Float32Array);
        }
        if (typeof Float64Array !== 'undefined') {
            _arrayBufferViews.push(Float64Array);
        }
        this.isArrayBufferView = function (x) {
            for (var i = 0; i < _arrayBufferViews.length; ++i) {
                if (x instanceof _arrayBufferViews[i]) {
                    return true;
                }
            }
            return false;
        };

        this.ByteBuffer = ByteStringBuffer;

        function ByteStringBuffer(b) {
            // TODO: update to match DataBuffer API

            // the data in this buffer
            this.data = '';
            // the pointer for reading from this buffer
            this.read = 0;

            if (typeof b === 'string') {
                this.data = b;
            } else if (util.isArrayBuffer(b) || util.isArrayBufferView(b)) {
                // convert native buffer to forge buffer
                // FIXME: support native buffers internally instead
                var arr = new Uint8Array(b);
                try {
                    this.data = String.fromCharCode.apply(null, arr);
                } catch (e) {
                    for (var i = 0; i < arr.length; ++i) {
                        this.putByte(arr[i]);
                    }
                }
            } else if (b instanceof ByteStringBuffer ||
                (typeof b === 'object' && typeof b.data === 'string' &&
                typeof b.read === 'number')) {
                // copy existing buffer
                this.data = b.data;
                this.read = b.read;
            }

            // used for v8 optimization
            this._constructedStringLength = 0;
        }

        this.ByteStringBuffer = ByteStringBuffer;

        var _MAX_CONSTRUCTED_STRING_LENGTH = 4096;
        this.ByteStringBuffer.prototype._optimizeConstructedString = function (x) {
            this._constructedStringLength += x;
            if (this._constructedStringLength > _MAX_CONSTRUCTED_STRING_LENGTH) {
                // this substr() should cause the constructed string to join
                this.data.substr(0, 1);
                this._constructedStringLength = 0;
            }
        };

        this.ByteStringBuffer.prototype.length = function () {
            return this.data.length - this.read;
        };

        this.ByteStringBuffer.prototype.isEmpty = function () {
            return this.length() <= 0;
        };

        this.ByteStringBuffer.prototype.putByte = function (b) {
            return this.putBytes(String.fromCharCode(b));
        };

        this.ByteStringBuffer.prototype.fillWithByte = function (b, n) {
            b = String.fromCharCode(b);
            var d = this.data;
            while (n > 0) {
                if (n & 1) {
                    d += b;
                }
                n >>>= 1;
                if (n > 0) {
                    b += b;
                }
            }
            this.data = d;
            this._optimizeConstructedString(n);
            return this;
        };

        this.ByteStringBuffer.prototype.putBytes = function (bytes) {
            this.data += bytes;
            this._optimizeConstructedString(bytes.length);
            return this;
        };

        this.ByteStringBuffer.prototype.putString = function (str) {
            return this.putBytes(this.encodeUtf8(str));
        };

        this.ByteStringBuffer.prototype.putInt16 = function (i) {
            return this.putBytes(
                String.fromCharCode(i >> 8 & 0xFF) +
                String.fromCharCode(i & 0xFF));
        };

        this.ByteStringBuffer.prototype.putInt24 = function (i) {
            return this.putBytes(
                String.fromCharCode(i >> 16 & 0xFF) +
                String.fromCharCode(i >> 8 & 0xFF) +
                String.fromCharCode(i & 0xFF));
        };

        this.ByteStringBuffer.prototype.putInt32 = function (i) {
            return this.putBytes(
                String.fromCharCode(i >> 24 & 0xFF) +
                String.fromCharCode(i >> 16 & 0xFF) +
                String.fromCharCode(i >> 8 & 0xFF) +
                String.fromCharCode(i & 0xFF));
        };

        this.ByteStringBuffer.prototype.putInt16Le = function (i) {
            return this.putBytes(
                String.fromCharCode(i & 0xFF) +
                String.fromCharCode(i >> 8 & 0xFF));
        };

        this.ByteStringBuffer.prototype.putInt24Le = function (i) {
            return this.putBytes(
                String.fromCharCode(i & 0xFF) +
                String.fromCharCode(i >> 8 & 0xFF) +
                String.fromCharCode(i >> 16 & 0xFF));
        };

        this.ByteStringBuffer.prototype.putInt32Le = function (i) {
            return this.putBytes(
                String.fromCharCode(i & 0xFF) +
                String.fromCharCode(i >> 8 & 0xFF) +
                String.fromCharCode(i >> 16 & 0xFF) +
                String.fromCharCode(i >> 24 & 0xFF));
        };

        this.ByteStringBuffer.prototype.putInt = function (i, n) {
            var bytes = '';
            do {
                n -= 8;
                bytes += String.fromCharCode((i >> n) & 0xFF);
            } while (n > 0);
            return this.putBytes(bytes);
        };

        this.ByteStringBuffer.prototype.putSignedInt = function (i, n) {
            if (i < 0) {
                i += 2 << (n - 1);
            }
            return this.putInt(i, n);
        };

        this.ByteStringBuffer.prototype.putBuffer = function (buffer) {
            return this.putBytes(buffer.getBytes());
        };

        this.ByteStringBuffer.prototype.getByte = function () {
            return this.data.charCodeAt(this.read++);
        };

        this.ByteStringBuffer.prototype.getInt16 = function () {
            var rval = (
            this.data.charCodeAt(this.read) << 8 ^
            this.data.charCodeAt(this.read + 1));
            this.read += 2;
            return rval;
        };

        this.ByteStringBuffer.prototype.getInt24 = function () {
            var rval = (
            this.data.charCodeAt(this.read) << 16 ^
            this.data.charCodeAt(this.read + 1) << 8 ^
            this.data.charCodeAt(this.read + 2));
            this.read += 3;
            return rval;
        };

        this.ByteStringBuffer.prototype.getInt32 = function () {
            var rval = (
            this.data.charCodeAt(this.read) << 24 ^
            this.data.charCodeAt(this.read + 1) << 16 ^
            this.data.charCodeAt(this.read + 2) << 8 ^
            this.data.charCodeAt(this.read + 3));
            this.read += 4;
            return rval;
        };

        this.ByteStringBuffer.prototype.getInt16Le = function () {
            var rval = (
            this.data.charCodeAt(this.read) ^
            this.data.charCodeAt(this.read + 1) << 8);
            this.read += 2;
            return rval;
        };

        this.ByteStringBuffer.prototype.getInt24Le = function () {
            var rval = (
            this.data.charCodeAt(this.read) ^
            this.data.charCodeAt(this.read + 1) << 8 ^
            this.data.charCodeAt(this.read + 2) << 16);
            this.read += 3;
            return rval;
        };

        this.ByteStringBuffer.prototype.getInt32Le = function () {
            var rval = (
            this.data.charCodeAt(this.read) ^
            this.data.charCodeAt(this.read + 1) << 8 ^
            this.data.charCodeAt(this.read + 2) << 16 ^
            this.data.charCodeAt(this.read + 3) << 24);
            this.read += 4;
            return rval;
        };

        this.ByteStringBuffer.prototype.getInt = function (n) {
            var rval = 0;
            do {
                rval = (rval << 8) + this.data.charCodeAt(this.read++);
                n -= 8;
            } while (n > 0);
            return rval;
        };

        this.ByteStringBuffer.prototype.getSignedInt = function (n) {
            var x = this.getInt(n);
            var max = 2 << (n - 2);
            if (x >= max) {
                x -= max << 1;
            }
            return x;
        };

        this.ByteStringBuffer.prototype.getBytes = function (count) {
            var rval;
            if (count) {
                // read count bytes
                count = Math.min(this.length(), count);
                rval = this.data.slice(this.read, this.read + count);
                this.read += count;
            } else if (count === 0) {
                rval = '';
            } else {
                // read all bytes, optimize to only copy when needed
                rval = (this.read === 0) ? this.data : this.data.slice(this.read);
                this.clear();
            }
            return rval;
        };

        this.ByteStringBuffer.prototype.bytes = function (count) {
            return (typeof(count) === 'undefined' ?
                this.data.slice(this.read) :
                this.data.slice(this.read, this.read + count));
        };

        this.ByteStringBuffer.prototype.at = function (i) {
            return this.data.charCodeAt(this.read + i);
        };

        this.ByteStringBuffer.prototype.setAt = function (i, b) {
            this.data = this.data.substr(0, this.read + i) +
                String.fromCharCode(b) +
                this.data.substr(this.read + i + 1);
            return this;
        };

        this.ByteStringBuffer.prototype.last = function () {
            return this.data.charCodeAt(this.data.length - 1);
        };

        this.ByteStringBuffer.prototype.copy = function () {
            var c = this.createBuffer(this.data);
            c.read = this.read;
            return c;
        };

        this.ByteStringBuffer.prototype.compact = function () {
            if (this.read > 0) {
                this.data = this.data.slice(this.read);
                this.read = 0;
            }
            return this;
        };

        this.ByteStringBuffer.prototype.clear = function () {
            this.data = '';
            this.read = 0;
            return this;
        };

        this.ByteStringBuffer.prototype.truncate = function (count) {
            var len = Math.max(0, this.length() - count);
            this.data = this.data.substr(this.read, len);
            this.read = 0;
            return this;
        };

        this.ByteStringBuffer.prototype.toHex = function () {
            var rval = '';
            for (var i = this.read; i < this.data.length; ++i) {
                var b = this.data.charCodeAt(i);
                if (b < 16) {
                    rval += '0';
                }
                rval += b.toString(16);
            }
            return rval;
        };

        this.ByteStringBuffer.prototype.toString = function () {
            return util.decodeUtf8(this.bytes());
        };

        function DataBuffer(b, options) {
            // default options
            options = options || {};

            // pointers for read from/write to buffer
            this.read = options.readOffset || 0;
            this.growSize = options.growSize || 1024;

            var isArrayBuffer = this.isArrayBuffer(b);
            var isArrayBufferView = this.isArrayBufferView(b);
            if (isArrayBuffer || isArrayBufferView) {
                // use ArrayBuffer directly
                if (isArrayBuffer) {
                    this.data = new DataView(b);
                } else {
                    // TODO: adjust read/write offset based on the type of view
                    // or specify that this must be done in the options ... that the
                    // offsets are byte-based
                    this.data = new DataView(b.buffer, b.byteOffset, b.byteLength);
                }
                this.write = ('writeOffset' in options ?
                    options.writeOffset : this.data.byteLength);
                return;
            }

            // initialize to empty array buffer and add any given bytes using putBytes
            this.data = new DataView(new ArrayBuffer(0));
            this.write = 0;

            if (b !== null && b !== undefined) {
                this.putBytes(b);
            }

            if ('writeOffset' in options) {
                this.write = options.writeOffset;
            }
        }

        this.DataBuffer = DataBuffer;

        this.DataBuffer.prototype.length = function () {
            return this.write - this.read;
        };

        this.DataBuffer.prototype.isEmpty = function () {
            return this.length() <= 0;
        };

        this.DataBuffer.prototype.accommodate = function (amount, growSize) {
            if (this.length() >= amount) {
                return this;
            }
            growSize = Math.max(growSize || this.growSize, amount);

            // grow buffer
            var src = new Uint8Array(
                this.data.buffer, this.data.byteOffset, this.data.byteLength);
            var dst = new Uint8Array(this.length() + growSize);
            dst.set(src);
            this.data = new DataView(dst.buffer);

            return this;
        };

        this.DataBuffer.prototype.putByte = function (b) {
            this.accommodate(1);
            this.data.setUint8(this.write++, b);
            return this;
        };

        this.DataBuffer.prototype.fillWithByte = function (b, n) {
            this.accommodate(n);
            for (var i = 0; i < n; ++i) {
                this.data.setUint8(b);
            }
            return this;
        };

        this.DataBuffer.prototype.putBytes = function (bytes, encoding) {
            if (this.isArrayBufferView(bytes)) {
                var src = new Uint8Array(bytes.buffer, bytes.byteOffset, bytes.byteLength);
                var len = src.byteLength - src.byteOffset;
                this.accommodate(len);
                var dst = new Uint8Array(this.data.buffer, this.write);
                dst.set(src);
                this.write += len;
                return this;
            }

            if (this.isArrayBuffer(bytes)) {
                var src = new Uint8Array(bytes);
                this.accommodate(src.byteLength);
                var dst = new Uint8Array(this.data.buffer);
                dst.set(src, this.write);
                this.write += src.byteLength;
                return this;
            }

            // bytes is a this.DataBuffer or equivalent
            if (bytes instanceof this.DataBuffer ||
                (typeof bytes === 'object' &&
                typeof bytes.read === 'number' && typeof bytes.write === 'number' &&
                this.isArrayBufferView(bytes.data))) {
                var src = new Uint8Array(bytes.data.byteLength, bytes.read, bytes.length());
                this.accommodate(src.byteLength);
                var dst = new Uint8Array(bytes.data.byteLength, this.write);
                dst.set(src);
                this.write += src.byteLength;
                return this;
            }

            if (bytes instanceof this.ByteStringBuffer) {
                // copy binary string and process as the same as a string parameter below
                bytes = bytes.data;
                encoding = 'binary';
            }

            // string conversion
            encoding = encoding || 'binary';
            if (typeof bytes === 'string') {
                var view;

                // decode from string
                if (encoding === 'hex') {
                    this.accommodate(Math.ceil(bytes.length / 2));
                    view = new Uint8Array(this.data.buffer, this.write);
                    this.write += this.binary.hex.decode(bytes, view, this.write);
                    return this;
                }
                if (encoding === 'base64') {
                    this.accommodate(Math.ceil(bytes.length / 4) * 3);
                    view = new Uint8Array(this.data.buffer, this.write);
                    this.write += this.binary.base64.decode(bytes, view, this.write);
                    return this;
                }

                // encode text as UTF-8 bytes
                if (encoding === 'utf8') {
                    // encode as UTF-8 then decode string as raw binary
                    bytes = this.encodeUtf8(bytes);
                    encoding = 'binary';
                }

                // decode string as raw binary
                if (encoding === 'binary' || encoding === 'raw') {
                    // one byte per character
                    this.accommodate(bytes.length);
                    view = new Uint8Array(this.data.buffer, this.write);
                    this.write += this.binary.raw.decode(view);
                    return this;
                }

                // encode text as UTF-16 bytes
                if (encoding === 'utf16') {
                    // two bytes per character
                    this.accommodate(bytes.length * 2);
                    view = new Uint16Array(this.data.buffer, this.write);
                    this.write += this.text.utf16.encode(view);
                    return this;
                }

                throw new Error('Invalid encoding: ' + encoding);
            }

            throw Error('Invalid parameter: ' + bytes);
        };

        this.DataBuffer.prototype.putBuffer = function (buffer) {
            this.putBytes(buffer);
            buffer.clear();
            return this;
        };

        this.DataBuffer.prototype.putString = function (str) {
            return this.putBytes(str, 'utf16');
        };

        this.DataBuffer.prototype.putInt16 = function (i) {
            this.accommodate(2);
            this.data.setInt16(this.write, i);
            this.write += 2;
            return this;
        };

        this.DataBuffer.prototype.putInt24 = function (i) {
            this.accommodate(3);
            this.data.setInt16(this.write, i >> 8 & 0xFFFF);
            this.data.setInt8(this.write, i >> 16 & 0xFF);
            this.write += 3;
            return this;
        };

        this.DataBuffer.prototype.putInt32 = function (i) {
            this.accommodate(4);
            this.data.setInt32(this.write, i);
            this.write += 4;
            return this;
        };

        this.DataBuffer.prototype.putInt16Le = function (i) {
            this.accommodate(2);
            this.data.setInt16(this.write, i, true);
            this.write += 2;
            return this;
        };

        this.DataBuffer.prototype.putInt24Le = function (i) {
            this.accommodate(3);
            this.data.setInt8(this.write, i >> 16 & 0xFF);
            this.data.setInt16(this.write, i >> 8 & 0xFFFF, true);
            this.write += 3;
            return this;
        };

        this.DataBuffer.prototype.putInt32Le = function (i) {
            this.accommodate(4);
            this.data.setInt32(this.write, i, true);
            this.write += 4;
            return this;
        };

        this.DataBuffer.prototype.putInt = function (i, n) {
            this.accommodate(n / 8);
            do {
                n -= 8;
                this.data.setInt8(this.write++, (i >> n) & 0xFF);
            } while (n > 0);
            return this;
        };

        this.DataBuffer.prototype.putSignedInt = function (i, n) {
            this.accommodate(n / 8);
            if (i < 0) {
                i += 2 << (n - 1);
            }
            return this.putInt(i, n);
        };

        this.DataBuffer.prototype.getByte = function () {
            return this.data.getInt8(this.read++);
        };

        this.DataBuffer.prototype.getInt16 = function () {
            var rval = this.data.getInt16(this.read);
            this.read += 2;
            return rval;
        };

        this.DataBuffer.prototype.getInt24 = function () {
            var rval = (
            this.data.getInt16(this.read) << 8 ^
            this.data.getInt8(this.read + 2));
            this.read += 3;
            return rval;
        };

        this.DataBuffer.prototype.getInt32 = function () {
            var rval = this.data.getInt32(this.read);
            this.read += 4;
            return rval;
        };

        this.DataBuffer.prototype.getInt16Le = function () {
            var rval = this.data.getInt16(this.read, true);
            this.read += 2;
            return rval;
        };

        this.DataBuffer.prototype.getInt24Le = function () {
            var rval = (
            this.data.getInt8(this.read) ^
            this.data.getInt16(this.read + 1, true) << 8);
            this.read += 3;
            return rval;
        };

        this.DataBuffer.prototype.getInt32Le = function () {
            var rval = this.data.getInt32(this.read, true);
            this.read += 4;
            return rval;
        };

        this.DataBuffer.prototype.getInt = function (n) {
            var rval = 0;
            do {
                rval = (rval << 8) + this.data.getInt8(this.read++);
                n -= 8;
            } while (n > 0);
            return rval;
        };

        this.DataBuffer.prototype.getSignedInt = function (n) {
            var x = this.getInt(n);
            var max = 2 << (n - 2);
            if (x >= max) {
                x -= max << 1;
            }
            return x;
        };

        this.DataBuffer.prototype.getBytes = function (count) {
            // TODO: deprecate this method, it is poorly named and
            // this.toString('binary') replaces it
            // add a toTypedArray()/toArrayBuffer() function
            var rval;
            if (count) {
                // read count bytes
                count = Math.min(this.length(), count);
                rval = this.data.slice(this.read, this.read + count);
                this.read += count;
            } else if (count === 0) {
                rval = '';
            } else {
                // read all bytes, optimize to only copy when needed
                rval = (this.read === 0) ? this.data : this.data.slice(this.read);
                this.clear();
            }
            return rval;
        };

        this.DataBuffer.prototype.bytes = function (count) {
            // TODO: deprecate this method, it is poorly named, add "getString()"
            return (typeof(count) === 'undefined' ?
                this.data.slice(this.read) :
                this.data.slice(this.read, this.read + count));
        };

        this.DataBuffer.prototype.at = function (i) {
            return this.data.getUint8(this.read + i);
        };

        this.DataBuffer.prototype.setAt = function (i, b) {
            this.data.setUint8(i, b);
            return this;
        };

        this.DataBuffer.prototype.last = function () {
            return this.data.getUint8(this.write - 1);
        };

        this.DataBuffer.prototype.copy = function () {
            return new this.DataBuffer(this);
        };

        this.DataBuffer.prototype.compact = function () {
            if (this.read > 0) {
                var src = new Uint8Array(this.data.buffer, this.read);
                var dst = new Uint8Array(src.byteLength);
                dst.set(src);
                this.data = new DataView(dst);
                this.write -= this.read;
                this.read = 0;
            }
            return this;
        };

        this.DataBuffer.prototype.clear = function () {
            this.data = new DataView(new ArrayBuffer(0));
            this.read = this.write = 0;
            return this;
        };

        this.DataBuffer.prototype.truncate = function (count) {
            this.write = Math.max(0, this.length() - count);
            this.read = Math.min(this.read, this.write);
            return this;
        };

        this.DataBuffer.prototype.toHex = function () {
            var rval = '';
            for (var i = this.read; i < this.data.byteLength; ++i) {
                var b = this.data.getUint8(i);
                if (b < 16) {
                    rval += '0';
                }
                rval += b.toString(16);
            }
            return rval;
        };

        this.DataBuffer.prototype.toString = function (encoding) {
            var view = new Uint8Array(this.data, this.read, this.length());
            encoding = encoding || 'utf8';

            // encode to string
            if (encoding === 'binary' || encoding === 'raw') {
                return this.binary.raw.encode(view);
            }
            if (encoding === 'hex') {
                return this.binary.hex.encode(view);
            }
            if (encoding === 'base64') {
                return this.binary.base64.encode(view);
            }

            // decode to text
            if (encoding === 'utf8') {
                return this.text.utf8.decode(view);
            }
            if (encoding === 'utf16') {
                return this.text.utf16.decode(view);
            }

            throw new Error('Invalid encoding: ' + encoding);
        };

        this.createBuffer = function (input, encoding) {
            // TODO: deprecate, use new ByteBuffer() instead
            encoding = encoding || 'raw';
            if (input !== undefined && encoding === 'utf8') {
                input = this.encodeUtf8(input);
            }
            return new this.ByteBuffer(input);
        };

        this.fillString = function (c, n) {
            var s = '';
            while (n > 0) {
                if (n & 1) {
                    s += c;
                }
                n >>>= 1;
                if (n > 0) {
                    c += c;
                }
            }
            return s;
        };

        this.xorBytes = function (s1, s2, n) {
            var s3 = '';
            var b = '';
            var t = '';
            var i = 0;
            var c = 0;
            for (; n > 0; --n, ++i) {
                b = s1.charCodeAt(i) ^ s2.charCodeAt(i);
                if (c >= 10) {
                    s3 += t;
                    t = '';
                    c = 0;
                }
                t += String.fromCharCode(b);
                ++c;
            }
            s3 += t;
            return s3;
        };

        this.hexToBytes = function (hex) {
            // TODO: deprecate: "Deprecated. Use this.binary.hex.decode instead."
            var rval = '';
            var i = 0;
            if (hex.length & 1 == 1) {
                hex = hex.substr(1, hex.length);
            }

            // convert 2 characters (1 byte) at a time
            for (; i < hex.length; i += 2) {
                rval += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
            }
            return rval;
        };

        this.bytesToHex = function (bytes) {
            // TODO: deprecate: "Deprecated. Use this.binary.hex.encode instead."
            return this.createBuffer(bytes).toHex();
        };

        this.int32ToBytes = function (i) {
            return (
            String.fromCharCode(i >> 24 & 0xFF) +
            String.fromCharCode(i >> 16 & 0xFF) +
            String.fromCharCode(i >> 8 & 0xFF) +
            String.fromCharCode(i & 0xFF));
        };

        // base64 characters, reverse mapping
        var _base64 =
            'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
        var _base64Idx = [
            /*43 -43 = 0*/
            /*'+',  1,  2,  3,'/' */
            62, -1, -1, -1, 63,

            /*'0','1','2','3','4','5','6','7','8','9' */
            52, 53, 54, 55, 56, 57, 58, 59, 60, 61,

            /*15, 16, 17,'=', 19, 20, 21 */
            -1, -1, -1, 64, -1, -1, -1,

            /*65 - 43 = 22*/
            /*'A','B','C','D','E','F','G','H','I','J','K','L','M', */
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,

            /*'N','O','P','Q','R','S','T','U','V','W','X','Y','Z' */
            13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,

            /*91 - 43 = 48 */
            /*48, 49, 50, 51, 52, 53 */
            -1, -1, -1, -1, -1, -1,

            /*97 - 43 = 54*/
            /*'a','b','c','d','e','f','g','h','i','j','k','l','m' */
            26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,

            /*'n','o','p','q','r','s','t','u','v','w','x','y','z' */
            39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
        ];

        this.encode64 = function (input, maxline) {
            var line = '';
            var output = '';
            var chr1, chr2, chr3;
            var i = 0;
            while (i < input.length) {
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);

                // encode 4 character group
                line += _base64.charAt(chr1 >> 2);
                line += _base64.charAt(((chr1 & 3) << 4) | (chr2 >> 4));
                if (isNaN(chr2)) {
                    line += '==';
                } else {
                    line += _base64.charAt(((chr2 & 15) << 2) | (chr3 >> 6));
                    line += isNaN(chr3) ? '=' : _base64.charAt(chr3 & 63);
                }

                if (maxline && line.length > maxline) {
                    output += line.substr(0, maxline) + '\r\n';
                    line = line.substr(maxline);
                }
            }
            output += line;
            return output;
        };

        this.decode64 = function (input) {
            // remove all non-base64 characters
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, '');

            var output = '';
            var enc1, enc2, enc3, enc4;
            var i = 0;

            while (i < input.length) {
                enc1 = _base64Idx[input.charCodeAt(i++) - 43];
                enc2 = _base64Idx[input.charCodeAt(i++) - 43];
                enc3 = _base64Idx[input.charCodeAt(i++) - 43];
                enc4 = _base64Idx[input.charCodeAt(i++) - 43];

                output += String.fromCharCode((enc1 << 2) | (enc2 >> 4));
                if (enc3 !== 64) {
                    // decoded at least 2 bytes
                    output += String.fromCharCode(((enc2 & 15) << 4) | (enc3 >> 2));
                    if (enc4 !== 64) {
                        // decoded 3 bytes
                        output += String.fromCharCode(((enc3 & 3) << 6) | enc4);
                    }
                }
            }

            return output;
        };

        this.encodeUtf8 = function (str) {
            return unescape(encodeURIComponent(str));
        };

        this.decodeUtf8 = function (str) {
            return decodeURIComponent(escape(str));
        };

        this.binary = {
            raw: {},
            hex: {},
            base64: {}
        };

        this.binary.raw.encode = function (bytes) {
            return String.fromCharCode.apply(null, bytes);
        };

        this.binary.raw.decode = function (str, output, offset) {
            var out = output;
            if (!out) {
                out = new Uint8Array(str.length);
            }
            offset = offset || 0;
            var j = offset;
            for (var i = 0; i < str.length; ++i) {
                out[j++] = str.charCodeAt(i);
            }
            return output ? (j - offset) : out;
        };

        this.binary.hex.encode = this.bytesToHex;

        this.binary.hex.decode = function (hex, output, offset) {
            var out = output;
            if (!out) {
                out = new Uint8Array(Math.ceil(hex.length / 2));
            }
            offset = offset || 0;
            var i = 0, j = offset;
            if (hex.length & 1) {
                // odd number of characters, convert first character alone
                i = 1;
                out[j++] = parseInt(hex[0], 16);
            }
            // convert 2 characters (1 byte) at a time
            for (; i < hex.length; i += 2) {
                out[j++] = parseInt(hex.substr(i, 2), 16);
            }
            return output ? (j - offset) : out;
        };

        this.binary.base64.encode = function (input, maxline) {
            var line = '';
            var output = '';
            var chr1, chr2, chr3;
            var i = 0;
            while (i < input.byteLength) {
                chr1 = input[i++];
                chr2 = input[i++];
                chr3 = input[i++];

                // encode 4 character group
                line += _base64.charAt(chr1 >> 2);
                line += _base64.charAt(((chr1 & 3) << 4) | (chr2 >> 4));
                if (isNaN(chr2)) {
                    line += '==';
                } else {
                    line += _base64.charAt(((chr2 & 15) << 2) | (chr3 >> 6));
                    line += isNaN(chr3) ? '=' : _base64.charAt(chr3 & 63);
                }

                if (maxline && line.length > maxline) {
                    output += line.substr(0, maxline) + '\r\n';
                    line = line.substr(maxline);
                }
            }
            output += line;
            return output;
        };

        this.binary.base64.decode = function (input, output, offset) {
            var out = output;
            if (!out) {
                out = new Uint8Array(Math.ceil(input.length / 4) * 3);
            }

            // remove all non-base64 characters
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, '');

            offset = offset || 0;
            var enc1, enc2, enc3, enc4;
            var i = 0, j = offset;

            while (i < input.length) {
                enc1 = _base64Idx[input.charCodeAt(i++) - 43];
                enc2 = _base64Idx[input.charCodeAt(i++) - 43];
                enc3 = _base64Idx[input.charCodeAt(i++) - 43];
                enc4 = _base64Idx[input.charCodeAt(i++) - 43];

                out[j++] = (enc1 << 2) | (enc2 >> 4);
                if (enc3 !== 64) {
                    // decoded at least 2 bytes
                    out[j++] = ((enc2 & 15) << 4) | (enc3 >> 2);
                    if (enc4 !== 64) {
                        // decoded 3 bytes
                        out[j++] = ((enc3 & 3) << 6) | enc4;
                    }
                }
            }

            // make sure result is the exact decoded length
            return output ?
                (j - offset) :
                out.subarray(0, j);
        };

        this.text = {
            utf8: {},
            utf16: {}
        };

        this.text.utf8.encode = function (str, output, offset) {
            str = this.encodeUtf8(str);
            var out = output;
            if (!out) {
                out = new Uint8Array(str.length);
            }
            offset = offset || 0;
            var j = offset;
            for (var i = 0; i < str.length; ++i) {
                out[j++] = str.charCodeAt(i);
            }
            return output ? (j - offset) : out;
        };

        this.text.utf8.decode = function (bytes) {
            return this.decodeUtf8(String.fromCharCode.apply(null, bytes));
        };

        this.text.utf16.encode = function (str, output, offset) {
            var out = output;
            if (!out) {
                out = new Uint8Array(str.length);
            }
            var view = new Uint16Array(out);
            offset = offset || 0;
            var j = offset;
            var k = offset;
            for (var i = 0; i < str.length; ++i) {
                view[k++] = str.charCodeAt(i);
                j += 2;
            }
            return output ? (j - offset) : out;
        };

        this.text.utf16.decode = function (bytes) {
            return String.fromCharCode.apply(null, new Uint16Array(bytes));
        };

        this.deflate = function (api, bytes, raw) {
            bytes = this.decode64(api.deflate(this.encode64(bytes)).rval);

            // strip zlib header and trailer if necessary
            if (raw) {
                // zlib header is 2 bytes (CMF,FLG) where FLG indicates that
                // there is a 4-byte DICT (alder-32) block before the data if
                // its 5th bit is set
                var start = 2;
                var flg = bytes.charCodeAt(1);
                if (flg & 0x20) {
                    start = 6;
                }
                // zlib trailer is 4 bytes of adler-32
                bytes = bytes.substring(start, bytes.length - 4);
            }

            return bytes;
        };

        this.inflate = function (api, bytes, raw) {
            // TODO: add zlib header and trailer if necessary/possible
            var rval = api.inflate(this.encode64(bytes)).rval;
            return (rval === null) ? null : this.decode64(rval);
        };

        var _setStorageObject = function (api, id, obj) {
            if (!api) {
                throw new Error('WebStorage not available.');
            }

            var rval;
            if (obj === null) {
                rval = api.removeItem(id);
            } else {
                // json-encode and base64-encode object
                obj = this.encode64(JSON.stringify(obj));
                rval = api.setItem(id, obj);
            }

            // handle potential flash error
            if (typeof(rval) !== 'undefined' && rval.rval !== true) {
                var error = new Error(rval.error.message);
                error.id = rval.error.id;
                error.name = rval.error.name;
                throw error;
            }
        };

        var _getStorageObject = function (api, id) {
            if (!api) {
                throw new Error('WebStorage not available.');
            }
            // get the existing entry
            var rval = api.getItem(id);

            // flash returns item wrapped in an object, handle special case
            if (api.init) {
                if (rval.rval === null) {
                    if (rval.error) {
                        var error = new Error(rval.error.message);
                        error.id = rval.error.id;
                        error.name = rval.error.name;
                        throw error;
                    }
                    // no error, but also no item
                    rval = null;
                } else {
                    rval = rval.rval;
                }
            }

            // handle decoding
            if (rval !== null) {
                // base64-decode and json-decode data
                rval = JSON.parse(this.decode64(rval));
            }

            return rval;
        };

        var _setItem = function (api, id, key, data) {
            // get storage object
            var obj = _getStorageObject(api, id);
            if (obj === null) {
                // create a new storage object
                obj = {};
            }
            // update key
            obj[key] = data;

            // set storage object
            _setStorageObject(api, id, obj);
        };

        var _getItem = function (api, id, key) {
            // get storage object
            var rval = _getStorageObject(api, id);
            if (rval !== null) {
                // return data at key
                rval = (key in rval) ? rval[key] : null;
            }

            return rval;
        };

        var _removeItem = function (api, id, key) {
            // get storage object
            var obj = _getStorageObject(api, id);
            if (obj !== null && key in obj) {
                // remove key
                delete obj[key];

                // see if entry has no keys remaining
                var empty = true;
                for (var prop in obj) {
                    empty = false;
                    break;
                }
                if (empty) {
                    // remove entry entirely if no keys are left
                    obj = null;
                }

                // set storage object
                _setStorageObject(api, id, obj);
            }
        };

        var _clearItems = function (api, id) {
            _setStorageObject(api, id, null);
        };

        var _callStorageFunction = function (func, args, location) {
            var rval = null;

            // default storage types
            if (typeof(location) === 'undefined') {
                location = ['web', 'flash'];
            }

            // apply storage types in order of preference
            var type;
            var done = false;
            var exception = null;
            for (var idx in location) {
                type = location[idx];
                try {
                    if (type === 'flash' || type === 'both') {
                        if (args[0] === null) {
                            throw new Error('Flash local storage not available.');
                        }
                        rval = func.apply(this, args);
                        done = (type === 'flash');
                    }
                    if (type === 'web' || type === 'both') {
                        args[0] = localStorage;
                        rval = func.apply(this, args);
                        done = true;
                    }
                } catch (ex) {
                    exception = ex;
                }
                if (done) {
                    break;
                }
            }

            if (!done) {
                throw exception;
            }

            return rval;
        };

        this.setItem = function (api, id, key, data, location) {
            _callStorageFunction(_setItem, arguments, location);
        };

        this.getItem = function (api, id, key, location) {
            return _callStorageFunction(_getItem, arguments, location);
        };

        this.removeItem = function (api, id, key, location) {
            _callStorageFunction(_removeItem, arguments, location);
        };

        var _queryVariables = null;

        this.getQueryVariables = function (query) {
            var parse = function (q) {
                var rval = {};
                var kvpairs = q.split('&');
                for (var i = 0; i < kvpairs.length; i++) {
                    var pos = kvpairs[i].indexOf('=');
                    var key;
                    var val;
                    if (pos > 0) {
                        key = kvpairs[i].substring(0, pos);
                        val = kvpairs[i].substring(pos + 1);
                    } else {
                        key = kvpairs[i];
                        val = null;
                    }
                    if (!(key in rval)) {
                        rval[key] = [];
                    }
                    // disallow overriding object prototype keys
                    if (!(key in Object.prototype) && val !== null) {
                        rval[key].push(unescape(val));
                    }
                }
                return rval;
            };

            var rval;
            if (typeof(query) === 'undefined') {
                // set cached variables if needed
                if (_queryVariables === null) {
                    if (typeof(window) !== 'undefined' && window.location && window.location.search) {
                        // parse window search query
                        _queryVariables = parse(window.location.search.substring(1));
                    } else {
                        // no query variables available
                        _queryVariables = {};
                    }
                }
                rval = _queryVariables;
            } else {
                // parse given query
                rval = parse(query);
            }
            return rval;
        };

        this.parseFragment = function (fragment) {
            // default to whole fragment
            var fp = fragment;
            var fq = '';
            // split into path and query if possible at the first '?'
            var pos = fragment.indexOf('?');
            if (pos > 0) {
                fp = fragment.substring(0, pos);
                fq = fragment.substring(pos + 1);
            }
            // split path based on '/' and ignore first element if empty
            var path = fp.split('/');
            if (path.length > 0 && path[0] === '') {
                path.shift();
            }
            // convert query into object
            var query = (fq === '') ? {} : this.getQueryVariables(fq);

            return {
                pathString: fp,
                queryString: fq,
                path: path,
                query: query
            };
        };

        this.formatNumber = function (number, decimals, dec_point, thousands_sep) {
            var n = number, c = isNaN(decimals = Math.abs(decimals)) ? 2 : decimals;
            var d = dec_point === undefined ? ',' : dec_point;
            var t = thousands_sep === undefined ?
                '.' : thousands_sep, s = n < 0 ? '-' : '';
            var i = parseInt((n = Math.abs(+n || 0).toFixed(c)), 10) + '';
            var j = (i.length > 3) ? i.length % 3 : 0;
            return s + (j ? i.substr(0, j) + t : '') +
                i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) +
                (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '');
        };
    }
})();
