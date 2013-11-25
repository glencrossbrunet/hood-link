micropolar.adapter = {};

micropolar.adapter.plotly = function (svg, data, layout){

    var container = d3.select(svg).html('');

    var micropolarData = data.map(function(d, i){
        return d3.zip(d.x, d.y);
    });

    var micropolarGeometry = data.map(function(d, i){
        return micropolar[d.type.substr(5)]().config({stroke: d.line.color});
    });

    // Mic patterns example
    ////////////////////////////////////////

    var colors = ['peru', 'darkviolet', 'deepskyblue', 'orangered', 'green'];

    var linePlot1 = micropolar.LinePlot().config({stroke: colors[0]});
    var linePlot2 = micropolar.LinePlot().config({stroke: colors[1]});
    var linePlot3 = micropolar.LinePlot().config({stroke: colors[2]});
    var linePlot4 = micropolar.LinePlot().config({stroke: colors[3]});
    var linePlot5 = micropolar.LinePlot().config({stroke: colors[4]});

    function generateData(equation){
        var step = 6;
        var data = d3.range(0, 360 + step, step).map(function(deg, index){
            var theta = deg * Math.PI / 180;
            var radius = equation(theta);
            return [deg, radius];
        });
        return data;
    }

    var data1 = generateData(function(theta){ return Math.abs(Math.cos(theta)); });
    var data2 = generateData(function(theta){ return Math.abs(0.5 + 0.5 * Math.cos(theta)); });
    var data3 = generateData(function(theta){ return Math.abs(0.25 + 0.75 * Math.cos(theta)); });
    var data4 = generateData(function(theta){ return Math.abs(0.7 + 0.3 * Math.cos(theta)); });
    var data5 = generateData(function(theta){ return Math.abs(0.37 + 0.63 * Math.cos(theta)); });

    var legend = micropolar.legend()
        .config({
            data: ['Figure 8', 'Cardioid', 'Hypercardioid', 'Subcardioid', 'Supercardioid'],
            colors: colors
        });

    var config = {
        geometry: [linePlot1, linePlot2, linePlot3, linePlot4, linePlot5],
        data: [data1, data2, data3, data4, data5],
        legend: legend,
        title: 'Microphone Patterns',
        height: 300,
        width: 300,
        angularTicksStep: 30,
        angularTicksSuffix: 'º',
        minorTicks: 1,
        flip: true,
        originTheta: -90,
        radialAxisTheta: -90,
        radialTicksSuffix: 'dB',
        containerSelector: container
    };

    var polarAxis = micropolar.Axis().config(config);
    polarAxis();

    function titleLayout(){
        var bg = container.select('.background-circle');
        this.call(d3.plugly.convertToTspans)
            .call(d3.plugly.alignSVGWith(bg, 'center'))
        return this;
    }
    var title = container.select('text.title')
        .call(titleLayout)
        .call(d3.plugly.makeEditable)
        .on('edit', function(context){
            this.call(titleLayout);
        });

};


micropolar.adapter.isPolar = function(_data){
    return (_data && _data[0] && _data[0].type && _data[0].type.substr(0, 5) === 'Polar');
}
