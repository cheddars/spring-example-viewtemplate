<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<span>reload each 10s</span>
<div id="trafficContainer"></div>

<div id="hitratioContainer"></div>

<style type="text/css">
#analysis {
	width : 100%
}

#analysis caption { text-align: right; }
#analysis table { width: 100%; border: 1px solid #AAA; border-collapse: collapse; }
#analysis table thead { background-color: #EBB; }
#analysis table tr { height: 25px; }
#analysis table th { border: 1px solid #AAA; }
#analysis table td { border: 1px solid #AAA; }
#analysis table tbody td { text-align: right; padding-right: 5px; }
</style>

<div id="analysis">
	<div id="analysis-time-table-traffic">
		<h3>Summary - Traffic</h3>
		<table id="summary-table-traffic">
			<caption>lastest 5 days statistic info</caption>
			<thead>
				<tr>
					<th colspan="2" style="width: 15%;">sect</th>
					<th rowspan="2" style="width: 9%;">Sample Count</th>
					<th colspan="3" style="width: 36%;">Response time(ms)</th>
					<th colspan="3" style="width: 36%;">Measurement/Observation time(s)</th>
				</tr>
				<tr>
					<th>volume</th><th>old/new</th>
					<th>min</th><th>max</th><th>avg</th>
					<th>min</th><th>max</th><th>avg</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		
		<h3>Summary - Hitratio</h3>
		<table id="summary-table-hitratio">
			<caption>lastest 5 days statistic info</caption>
			<thead>
				<tr>
					<th colspan="2" style="width: 15%;">sect</th>
					<th rowspan="2" style="width: 9%;">Sample Count</th>
					<th colspan="3" style="width: 36%;">Response time(ms)</th>
					<th colspan="3" style="width: 36%;">Measurement/Observation time(s)</th>
				</tr>
				<tr>
					<th>volume</th><th>old/new</th>
					<th>min</th><th>max</th><th>avg</th>
					<th>min</th><th>max</th><th>avg</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
		
	</div>
	
	<div id="analysis-responsetime-distribution-graph">
		<h3>Response Time Distribution Graph</h3>
		<div id="responsetime-graph"></div>
	</div>
	<div id="analysis-measurementtime-distribution-graph">
		<h3>Measurement/Observation Time Distribution Graph</h3>
		<div id="messurement-graph"></div>
	</div>
</div>

<script type="text/javascript">
/**
 * 전체 그래프의 범위는 72시간으로 고정
 */
var volumes = [
        {name:'aionkor', last: 0},
        {name:'aionkortest', last: 0},
		{name:'l2kor', last: 0},
		{name:'common', last: 0}
];

var five_hours_in_ms = 5*60*60*1000;	// 5 hour

function loadDataInterval(series, type){
	for(var i = 0; i < series.length; i++){
		// 최초 로드시에는 VRC 별은 로드하지 않음
		if(series[i].name.indexOf("ktg") < 0){
			getData(series[i], series[i].name, type);	
		}
	}
	
    setInterval(function(){
    	for(var i = 0; i < series.length; i++){
    		getData(series[i], series[i].name, type);	
    	}
    }, 60000);
}

function loadSummaryData(){
	$.ajax({
		url: "/openapi/graph/summary.json",
		type: "post",
		data: "type=traffic",
		success: function(data){
			renderSummaryTable("summary-table-traffic", data);	
		}
	});
	$.ajax({
		url: "/openapi/graph/summary.json",
		type: "post",
		data: "type=hitratio",
		success: function(data){
			renderSummaryTable("summary-table-hitratio", data);	
		}
	});
	
    setInterval(function(){
    	$.ajax({
    		url: "/openapi/graph/summary.json",
    		type: "post",
    		data: "type=traffic",
    		success: function(data){
    			renderSummaryTable("summary-table-traffic", data);	
    		}
    	});
    }, 300000);
    setInterval(function(){
    	$.ajax({
    		url: "/openapi/graph/summary.json",
    		type: "post",
    		data: "type=hitratio",
    		success: function(data){
    			renderSummaryTable("summary-table-hitratio", data);	
    		}
    	});
    }, 300000);
}

function renderSummaryTable(tableId, infos){
	$("#" + tableId+ " > tbody").empty();
	
	for(var i = 0; i < infos.length; i++){
		var bgcolor = (infos[i].type == "old")? "#FFFFEA" : "#FFEAFF";
		var tr = $("<tr/>").css("background-color", bgcolor);
		tr.append($("<td/>").text(infos[i].volume))
			.append($("<td/>").text(infos[i].type))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].count, 0)))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].res_min, 0)))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].res_max, 0)))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].res_avg, 0)))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].osv_min, 0)))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].osv_max, 0)))
			.append($("<td/>").text(Highcharts.numberFormat(infos[i].osv_avg, 0)));
		$("#" + tableId+ " > tbody").append(tr);
	}
}

function getData(series, volume, type){
	var last = "";
	if(series != null && series.data && series.data.length > 0){
		last = series.data[series.data.length - 1].x;
	}
	
	$.ajax({
		url: "/openapi/graph/vol/" + volume + "/"+type+".json",
		type: "post",
		data: "last=" + last,
		success: function(data){
			if(data && data.list && data.list.length > 0){
				for(var i = 0; i < data.list.length; i++){
					var info = data.list[i];
					if(series.data[0].x > ((new Date()).getTime() - five_hours_in_ms)){
						series.addPoint([info.itemTs, info.data], true, false);	// 최초 초기화시에는 그래프 화면 이동 안함
					}else{
						series.addPoint([info.itemTs, info.data], true, true);
					}
				}
			}	
		}
	});	
}

$(function () {
    $(document).ready(function() {
    	// load summary
    	loadSummaryData();
    	
    	// load highchart
        Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });
    
    	renderGraph("traffic", "trafficContainer");
    	renderGraph("hitratio", "hitratioContainer");
    });
});


function renderGraph(type, target){
	var chart;
    chart = new Highcharts.Chart({
        chart: {
            renderTo: target,
            type: 'spline',
            marginRight: 10,
            events: {
                load: function() {
                	loadDataInterval(this.series, type)           	
                }
            }
        },
        title: {
            text: "Old Stat vs New Stat Compare("+type+")"
        },
        xAxis: {
            type: 'datetime',
            tickPixelInterval: 150
        },
        yAxis: {
            title: {
                text: (type=="traffic")?'MBps':"%"
            },
            plotLines: [{
                value: 0,
                width: 1,
                color: '#808080'
            }]
        },
        tooltip: {
            formatter: function() {
                    return '<b>'+ this.series.name +'</b><br/>'+
                    Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) +'<br/>'+
                    Highcharts.numberFormat(this.y, 2);
            }
        },
        legend: {enabled: true},
        exporting: {enabled: false},
        series: [
                 {name: 'aionkor-old',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'aionkor-new',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'aionkortest-old',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'aionkortest-new',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'common-old',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'common-new',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'l2kor-old',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]},
                 {name: 'l2kor-new',data: [[(new Date()).getTime()-five_hours_in_ms, 1]]}
                ]
    });
}
</script>