// Append SVG
/////////////////////////////

d3.selection.prototype.appendSVG = function(_svgString) {
    var skeleton = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">' + _svgString + '</svg>';
    var dom = new DOMParser().parseFromString(skeleton, 'application/xml');
    var childNode = dom.documentElement.firstChild;
    while(childNode) {
        this.node().appendChild(this.node().ownerDocument.importNode(childNode, true));
        childNode = childNode.nextSibling;
    }
    if (dom.querySelector('parsererror')){
//        console.log(dom.querySelector('parsererror div').innerText);
        return null;
    }
    return d3.select(this.node().lastChild);
};


d3.plugly = {};


// Simple templating
/////////////////////////////

d3.plugly.compileTemplate = function(_template, _values){
    return [].concat(_values).map(function(d, i){
        return _template.replace(/{([^}]*)}/g, function(s, key){return d[key] || '';});
    }).join('\n');
};


// Text utilities
/////////////////////////////

d3.plugly.convertToTspans = function(){
    var str = this.text();
    var lineHeight = ~~this.attr('font-size');
    var converted = d3.plugly.convertToSvg(str);
    this.text('');
    var result = this.appendSVG(converted);
    if(!result ){
        this.text(str);
//        if(this.attr('y')){
//            $(this.node()).tooltip({title:"Oops! We didn't get that. You can style text with "+
//            "HTML-like tags, but all tags except &lt;br&gt; must be closed, and "+
//            "sometimes you have to use &amp;gt; for &gt; and &amp;lt; for &lt;."})
//            .tooltip('show');
//        }
    }
    return this;
};

d3.plugly.convertToSvg = function(_str){
    var conversion = {
        sup: 'baseline-shift:super;font-size:70%',
        sub: 'baseline-shift:sub;font-size:70%',
        b: 'font-weight:bold',
        i: 'font-style:italic',
        a: '',
        font: '',
        span: '',
        br: '',
        em: 'font-style:italic;font-weight:bold'
    };
    var result = _str
        .split(/(<[^<>]*>)/).map(function(d, i){
            var match = d.match(/<(\/?)([^ >]*)[ ]?(.*)>/i);
            if(match && match[2] in conversion){
                if(match[2] === 'a' && match[3]){
                    return '<a xlink:show="new" xlink:'+ conversion[match[2]] + match[3] + '>';
                }
                else if(match[2] === 'a' && match[1]) return '</a>';
                else if(match[1]) return '</tspan>';
                else if(match[3]) return '<tspan '+ conversion[match[2]] + match[3] + '>';
                else if(match[2] === 'br') return d;
                else return '<tspan' + ' style="' + conversion[match[2]]+ '">';
            }
            else{
                return d.replace(/</g, '&lt;');;
            }
        });

    var indices = [];
    for (var index = result.indexOf('<br>'); index > 0; index = result.indexOf('<br>', index+1)){
        indices.push(index);
    }
    var count = 0;
    indices.forEach(function(d, i){
        var brIndex = d + count;
        var search = result.slice(0, brIndex);
        var previousOpenTag = '';
        for(var i2=search.length-1; i2>=0; i2--){
            var isTag = search[i2].match(/<(\/?).*>/i);
            if(isTag && search[i2] !== '<br>'){
                if(!isTag[1]) previousOpenTag = search[i2];
                break;
            }
        }
        if(previousOpenTag){
            result.splice(brIndex+1, 0, previousOpenTag);
            result.splice(brIndex, 0, '</tspan>');
            count += 2;
        }
    });

    var joined = result.join('');
    var splitted = joined.split(/<br>/gi);
    if(splitted.length > 1){
        result = splitted.map(function(d, i){
            return '<tspan class="line" dy="' + (i*1.3) + 'em">'+ d +'</tspan>';
        });
    }

    return result.join('');
};

d3.plugly.alignSVGWith_bk = function (_base, _options){
    return function(d, i){
        var bBox = this.node().getBBox();
        var posX = bBox.x;
        var posY = bBox.y + bBox.height - 6;
        var hMargin = (_options.horizontalMargin || 0);
        var vMargin = (_options.verticalMargin || 0);
        var baseNode = _base.node();
        var baseBBoxW = (baseNode.width) ? baseNode.width.baseVal.value : baseNode.getBBox().width;
        var baseBBoxH = (baseNode.height) ? baseNode.height.baseVal.value : baseNode.getBBox().height;
        var baseNodeX = baseNode.getBBox().x + baseNode.getCTM().e;
        var baseNodeY = baseNode.getBBox().y + baseNode.getCTM().f;
        if (baseNode.nodeName === 'circle') baseNodeX -= baseBBoxW / 2;

        if(_options.horizontalAlign === 'center') posX = baseNodeX + Math.round(baseBBoxW / 2 - bBox.width / 2 + hMargin);
        else if(_options.horizontalAlign === 'right') posX = Math.round(baseNodeX + baseBBoxW + _options.horizontalMargin);
        else if(_options.horizontalAlign === 'left') posX = Math.round(baseNodeX - bBox.width - _options.horizontalMargin);

//        if(_options.verticalAlign === 'bottom') posY = _options.verticalMargin + baseNodeY + baseBBoxH + bBox.height;
        if(_options.verticalAlign === 'bottom') posY = _options.verticalMargin + baseNodeY + baseBBoxH;
        else if(_options.verticalAlign === 'center') posY = _options.verticalMargin + baseNodeY + baseBBoxH / 2 + bBox.height / 4;
        else if(_options.verticalAlign === 'top') posY = baseNodeY - bBox.height - _options.verticalMargin;

        if(_options.horizontalAlign) this.attr({x: posX}).selectAll('tspan.line').attr({x: posX});
//        if(_options.verticalAlign)this.attr({y: posY}).selectAll('tspan.line').attr({y: posY});
        if(_options.verticalAlign)this.attr({y: posY}).selectAll('tspan.line');

        return this;
    };
};

d3.plugly.alignSVGWith = function (_base, _options){
    return function(d, i){
        var baseBBox = _base.node().getBBox();
        var bBox = this.node().getBBox();
        var alignH = '50%';
        var alignTextH = alignH;
        var anchor = 'middle';
        var vMargin = 0;
        var dY = 0;
        var hMargin = _options.horizontalMargin || 0;
        if(_options.orientation === 'under') vMargin = baseBBox.y + baseBBox.height;
        else if(_options.orientation === 'over') vMargin = baseBBox.y;
        else if(_options.orientation === 'inside'){
//            vMargin = baseBBox.y + (baseBBox.y - bBox.y);
            vMargin = baseBBox.y;
        }
        if(_options.verticalMargin) vMargin += _options.verticalMargin;
        if(_options.horizontalAlign === 'center'){
            alignH = '50%';
            anchor = 'middle';
            hMargin = hMargin/4;
        }
        else if(_options.horizontalAlign === 'right'){
            alignH = '0%';
            anchor = 'start';
        }
        else if(_options.horizontalAlign === 'left'){
            alignH = '100%';
            anchor = 'end';
            hMargin = -hMargin;
        }
        else if(typeof _options.horizontalAlign === 'number'){
            alignH = _options.horizontalAlign;
            anchor = 'middle';
        }
        if(_options.orientation === 'inside'){
            alignTextH = 0;
        }

        this.attr({x: alignTextH, dx: hMargin, y: vMargin}).style({'text-anchor': anchor})
            .selectAll('tspan.line').attr({x: alignH, dx: hMargin, y: vMargin});

//        this.call(align).selectAll('tspan.line').call(align);
//        function align(){
//            this.attr({x: alignH, dx: hMargin, y: vMargin}).style({'text-anchor': anchor});
//            return this;
//        }

        return this;
    };
};

d3.plugly.alignHTMLWith = function (_base){
    return function(d, i){
        var bRect = _base.node().getBoundingClientRect();
        this.style({
            top: bRect.top + 'px',
            left: bRect.left + 'px',
            'z-index': 1000
        });
        return this;
    };
};

d3.plugly.alignHTMLWith2 = function (_base){
    return function(d, i){
        var bRect = _base.node().getBoundingClientRect();
        this.style({
            left: bRect.left + 'px',
            'z-index': 1000
        });
        return this;
    };
};


// Editable title
/////////////////////////////

d3.plugly.makeEditable = function(){
    var that = this;
    var dispatch = d3.dispatch('edit', 'input', 'cancel');
    var text = this.text();
    this.style({'pointer-events': 'all'})
        .attr({'xml:space': 'preserve'})
        .on('click', function(d, i){
            appendEditable();
            d3.select(this).style({opacity: 0});
        });

    function selectElementContents(_el) {
        var el = _el.node();
        var range = document.createRange();
        range.selectNodeContents(el);
        var sel = window.getSelection();
        sel.removeAllRanges();
        sel.addRange(range);
        el.focus();
    }

    function appendEditable(){
        var div = d3.select('body').append('div').classed('plugly-editable editable', true);
        div.style({
                position: 'absolute',
                'font-family': that.style('font-family') || 'Arial',
                'font-size': that.style('font-size') || 12,
                color: that.style('fill') || 'black',
                opacity: 1,
                'background-color': 'transparent',
                outline: '#ffffff33 1px solid',
                margin: [-parseFloat(that.style('font-size'))/8+1, 0, 0, -1].join('px ') + 'px',
                padding: '0',
                'box-sizing': 'border-box'
            })
            .attr({contenteditable: true})
            .text(that.attr('data-unformatted'))
            .call(d3.plugly.alignHTMLWith(that))
            .on('blur', function(d, i){
                that.text(this.textContent)
                    .style({opacity: 1});
                var text = this.textContent;
                d3.select(this).transition().duration(0).remove();
                d3.select(document).on('mouseup', null);
                dispatch.edit.call(that, text);
            })
            .on('focus', function(d, i){
                var context = this;
                d3.select(document).on('mouseup', function(d, i){
                    if(d3.event.target === context) return false;
                    if(document.activeElement === div.node()) div.node().blur();
                });
            })
            .on('keyup', function(d, i){
                if(d3.event.which === 27){
                    that.style({opacity: 1})
                    d3.select(this)
                        .style({opacity: 0})
                        .on('blur', function(d, i){ return false; })
                        .transition().remove();
                    dispatch.cancel.call(that, this.textContent);
                }
                else{
                    dispatch.input.call(that, this.textContent);
                    d3.select(this).call(d3.plugly.alignHTMLWith2(that));
                }
            })
            .on('keydown', function(d, i){
                if(d3.event.which === 13) this.blur();
            })
            .call(selectElementContents);

    }
    return d3.rebind(this, dispatch, "on");
};


// Word wrap
/////////////////////////////

d3.plugly.wrap = function(_wrapW){
    return function(d, i){
        var that = this;

        function tspanify(){
            var lineH = this.node().getBBox().height;
            this.text('')
                .selectAll('tspan')
                .data(lineArray)
                .enter().append('tspan')
                .attr({
                    x: 0,
                    y: function(d, i){ return (i + 1) * lineH; }
                })
                .text(function(d, i){ return d.join(' '); })
        }

        function checkW(_text){
            var textTmp = that
                .style({visibility: 'hidden'})
                .text(_text);
            var textW = textTmp.node().getBBox().width;
            that.style({visibility: 'visible'}).text(text);
            return textW;
        }

        var text = this.text();
        var parentNode = this.node().parentNode;
        var textSplitted = text.split(' ');
        var lineArray = [[]];
        var count = 0;
        textSplitted.forEach(function(d, i){
            if(checkW(lineArray[count].concat(d).join(' '), parentNode) >= _wrapW){
                count++;
                lineArray[count] = [];
            }
            lineArray[count].push(d)
        });

        this.call(tspanify)
    }
};


// MathJax
/////////////////////////////

var MathjaxIt = function(_selector){
    var texDiv = null,
        context = null;
    function exports(d, i){
        context = this;
        var texString = d3.select(_selector).property('value');
        texDiv = d3.select('body').append('div')
            .style({visibility: 'hidden'})
            .html(texString);
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
    }
    MathJax.Hub.Register.MessageHook("New Math", function (message) {
        context.selectAll('*').remove();
        context.node().appendChild(texDiv.select('svg').node());
        texDiv.remove();
    });
    return exports;
};

//var mathjaxIt = MathjaxIt('#tex-input')
//
//d3.select('#convert').on('click', function(d, i){
//    d3.select('svg#root').attr({width: 300, height: 100})
//        .call(mathjaxIt)
//});