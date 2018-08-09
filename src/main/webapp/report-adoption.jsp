<!--
		    data: {
		        labels: ["Stream 1", "Stream 2", "Stream 3", "Stream 4"],
		        datasets: [
		        {
		        		label:"hidden",
		            data: [0, 100, 300, 100, 400],  // indent
		            backgroundColor: "rgba(0,0,0,0)",
		            hoverBackgroundColor: "rgba(0,0,0,0)"
		        },{
		            data: [100, 200, 100, 100], // actual bar
		            backgroundColor: ['rgb(146,212,0)', 'rgb(240,171,0)', 'rgb(204, 0, 0)', 'rgb(0, 65, 83)'],
		        }]
		    },
-->


<script>
function compareValues(key, order='asc') {
  return function(a, b) {
    if(!a.hasOwnProperty(key) || !b.hasOwnProperty(key)) {
      // property doesn't exist on either object
        return 0; 
    }

    const varA = (typeof a[key] === 'string') ? a[key].toUpperCase() : a[key];
    const varB = (typeof b[key] === 'string') ? b[key].toUpperCase() : b[key];

    let comparison = 0;
    if (varA > varB) {
      comparison = 1;
    } else if (varA < varB) {
      comparison = -1;
    }
    return (
      (order == 'desc') ? (comparison * -1) : comparison
    );
  };
}
</script>

<script>

		//httpGetObject(Utils.SERVER+"/api/pathfinder/customers/"+customerId+"/report", function(report){
			//var summaryList=report.summaryList;
		var adoptionPlanColors=[];
		var lastColor=0;
		adoptionPlanColors[0]='rgb(146,212,0)';
		adoptionPlanColors[1]='rgb(240,171,0)';
		adoptionPlanColors[2]='rgb(204, 0, 0)';
		adoptionPlanColors[3]='rgb(0, 65, 83)';
		
		adoptionPlanColors[4]='#3B0083';
		adoptionPlanColors[5]='#A3DBE8';
		adoptionPlanColors[6]='#808080';
		
		function getNextColor(){
		  var c=lastColor++;
		  if (lastColor>=adoptionPlanColors.length) lastColor=0;
			return adoptionPlanColors[c];
		}
		
	  var adoptionSize=[];
	  adoptionSize['null']=1;
	  adoptionSize['SMALL']=20;
	  adoptionSize['MEDIUM']=40;
	  adoptionSize['LARGE']=80;
	  adoptionSize['XLarge']=160;
		
		//var xxx=[{n:'A',s:1},{n:'Z',s:3},{n:'B',s:2}];
		//console.log("XXXXXXXXXXXXXX"+xxx.length);
		//xxx.sort(function(a,b){
		//	return a['s']-b['s'];
		//});
		//for(j=0;j<xxx.length;j++){
		//	console.log("YYYYYYYY"+xxx[j].n);
		//}
			
		var adoptionChart;
		function redrawAdoptionPlan(applicationAssessmentSummary){
			
			//if (!undefined==adoptionChart)
			//	adoptionChart.destroy();
			//adoptionChart=null;
			//
			//var cxx=document.getElementById('adoption').getContext('2d');
			//cxx.clearRect(0, 0, cxx.width, cxx.height);
			
			//TODO: need to clear the canvas somehow
			
			
			// deep copy
			var summary=JSON.parse(JSON.stringify(applicationAssessmentSummary));
			
			
			// build map of app Id->app
			var appIdToAppMap=[];
			for(i=0;i<summary.length;i++)
				appIdToAppMap[summary[i].Id]=summary[i];
			///
			
			// manipulate dependsOn into a list of app NAME's rather than ID's
			for(i=0;i<summary.length;i++){
				if (null!=summary[i]['OutboundDeps']){
					summary[i]['DependsOn']=[];
					summary[i]["Size"]=adoptionSize[summary[i].WorkEffort];
					
					summary[i]["AdoptionOrder"]=summary[i]["Size"];
					var biggestDependencySize=0;
					
					var dependsOn=[];
					for(d=0;d<summary[i]['OutboundDeps'].length;d++)
						dependsOn.push(appIdToAppMap[summary[i]['OutboundDeps'][d]]);
					
					summary[i]["AdoptionOrder"]=summary[i]["AdoptionOrder"]*((dependsOn.length)*100)+summary[i]['Size'];
					
					// sort the dependsOn by size order to be able to set the AdoptionOrder
					dependsOn.sort(function(a,b){
						return b['Size']-a['Size'];
					});
					for(d=0;d<dependsOn.length;d++){
						summary[i]['DependsOn'].push(dependsOn[d]['Name']);
						if (dependsOn[d]['Size']>biggestDependencySize)
						  biggestDependencySize=dependsOn[d]['Size'];
						
						dependsOn[d]['AdoptionOrder']=summary[i]["AdoptionOrder"]+(d+1);
					}
					summary[i]["Padding"]=biggestDependencySize;
				}
			}
			
			// remove any apps that are not selected (because this screws up the sorting)
			for(i=0;i<summary.length;i++){
				if (!appFilter.includes(summary[i]['Id']))
					summary.splice(i,1);
				//console.log(summary[i]['AdoptionOrder'] +" - "+summary[i]['Padding']+"/"+summary[i]['Size'] +"-"+ summary[i]['Name']);
			}
			
			// sort in size order (small to large)
			//summary.sort(compareValues("AdoptionOrder"));
			summary.sort(function(a,b){
				return a['AdoptionOrder']-b['AdoptionOrder'];
			});
			summary.reverse();
			
			//function bubbleSort(a, key){
		  //  var swapped;
		  //  do {
	    //    swapped = false;
	    //    for (var i=0;i<a.length-1;i++) {
      //      if (a[i][key]>a[i+1][key]) {
      //      	console.log(a[i][key]+" is > than "+a[i+1][key] +" - so switching them "+a[i]['Name']+"<->"+a[i+1]['Name']);
      //        var temp = a[i];
      //        a[i] = a[i+1];
      //        a[i+1] = temp;
      //        swapped = true;
      //      }
	    //    }
		  //  } while (swapped);
			//}
			//bubbleSort(summary, "AdoptionOrder");
			
			
			for(i=0;i<summary.length;i++){
				if (!appFilter.includes(summary[i]['Id'])) continue;
				console.log(summary[i]['AdoptionOrder'] +" - "+summary[i]['Padding']+"/"+summary[i]['Size'] +"-"+ summary[i]['Name']);
			}
			
			//console.log(JSON.stringify(summary));
			
			
			//console.log("x="+JSON.stringify(getApp("Online Ticker",summary)));
			//console.log("l="+summary.length);
			//console.log("summary="+JSON.stringify(summary));
			
			
			var hiddenDS={
    		label:"hidden",
        data: [],  // indent
        backgroundColor: "rgba(0,0,0,0)",
        hoverBackgroundColor: "rgba(0,0,0,0)"
			};
			var realDS={
        data: [],  // actual bar
        backgroundColor: [],
			};
			var data={labels:[],datasets:[hiddenDS,realDS]};
			
			var c=0;
			for(i=0;i<summary.length;i++){
				var app=summary[i];
				
				if (!appFilter.includes(app['Id'])) continue; // should never happen by this point
				
				data.labels[c]=app['Name'];
				hiddenDS.data[c]=app['Padding'];
				realDS.data[c]=app['Size'];
				realDS.backgroundColor[c]=getNextColor();
				c++;
			}
			
			console.log(JSON.stringify(data));
			
			var ctx = document.getElementById('adoption').getContext('2d');
			adoptionChart = new Chart(ctx, {
		    type: 'horizontalBar',
		    data: data,
				options:{
							plugins: {
            					datalabels: {
            						display: false
            					}
            	},
					    hover :{
					        animationDuration:10
					    },
					    scales: {
					        xAxes: [{
					            label:"Duration",
					            ticks: {
							        		display: false,
					                beginAtZero:true,
					                fontFamily: "'Open Sans Bold', sans-serif",
					                fontSize:11
					            },
					            scaleLabel:{
					                display:false
					            },
					            gridLines: {
					            }, 
					            stacked: true
					        }],
					        yAxes: [{
					            gridLines: {
					                display:false,
					                color: "#fff",
					                zeroLineColor: "#fff",
					                zeroLineWidth: 0
					            },
					            ticks: {
					                fontFamily: "'Open Sans Bold', sans-serif",
					                fontSize:11
					            },
					            stacked: true
					        }]
					    },
					    legend:{
					        display:false
					    },
					    tooltips:{
					    	enabled: false
					    },
							//tooltips: {
					    //    callbacks: {
					    //       label: function(tooltipItem,data) {
					    //       				var label = data.datasets[tooltipItem.datasetIndex].label || '';
					    //              return label;
					    //       }
					    //    }
					    //}
					}
			});
		};
			//window.myBar=chart;
			//// this part to make the tooltip only active on your real dataset
			//var originalGetElementAtEvent = chart.getElementAtEvent;
			//chart.getElementAtEvent = function (e) {
			//		console.log(e);
			//    return originalGetElementAtEvent.apply(this, arguments).filter(function (e) {
			//        return e._datasetIndex === 1;
			//    });
			//}
			
			
			
		//});
		

</script>