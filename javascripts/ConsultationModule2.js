function ConsultationModule()
{
	if (dojo.query("#dvConsultation").length>0) return;
	// global reference = oModules.ConsultationModule
	this.w=1000;
	this.h=650;
	this.force = d3.layout.force();
	this.vis = new Object();
	init(this)
	var ConsultationWindow;
	this.doResize = function ()
	{	
		this.w=ConsultationWindow.width;
		this.h=ConsultationWindow.height;
		dvGoalStructure=dojo.byId("dvConsultation");
		dvGoalStructure.style.height=this.h;
		dvGoalStructure.style.width=this.w;				
		svgConsultation=dojo.byId("svgConsultation")
		svgConsultation.width=this.w;
		svgConsultation.height=this.h;
		oModules.ConsultationModule.force.size([this.w,this.h]);								
		oModules.ConsultationModule.force.resume();	
	} 
	function init(pModule)
	{		
		try
		{								
		
			ConsultationWindow = new Window({className: "bluelighting", title: "Consultation", width:pModule.w+"px", height:pModule.h+"px", 
				destroyOnClose: true, recenterAuto:false, resizable:true, onResize:function() {oModules.ConsultationModule.doResize()}, onMaximize:function() {oModules.ConsultationModule.doResize()}    });
						
			var dvConsultation = dojo.create("div",{id:"dvConsultation"},dojo.body());			
			createLayout(dvConsultation,pModule)
			dvConsultation.style.backgroundColor="gray"
			ConsultationWindow.setContent("dvConsultation");					
			ConsultationWindow.setCloseCallback(function() { dojo.destroy("dvConsultation") ; return true; });
			ConsultationWindow.showCenter();
			
			var ctrls = new ConsultationControlsModule()
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}	
	}		
	function createLayout(pDV,pModule)
	{
		try
		{
						
			var fill = d3.scale.category20(); //twenty colors
			var linkmap = d3.scale.category20b(); //twenty colors		
			pModule.vis = d3.select("#dvConsultation").append("svg:svg").attr("id","svgConsultation");				
			pModule.force.charge(-420)            
			pModule.force.linkDistance(function(d){if ((d.source.name.substr(0,1)=="?")||(d.target.name.substr(0,1)=="?")) {return 100} else {return 200}})
            pModule.force.theta(.04)
            pModule.force.gravity(.024)           
			pModule.force.size([pModule.w, pModule.h])										
			d3.json("acessm/consultation.php",renderSSM);
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}			
	}
	function renderSSM(json)
	{
		try
		{
			
			data=json							
			oModules.ConsultationModule.force.nodes(data.nodes)            			
			oModules.ConsultationModule.force.links(data.links)            
			oModules.ConsultationModule.force.start();
					
			var vis = oModules.ConsultationModule.vis
			
			var fill = d3.scale.category20(); //twenty colors
			
			var link = vis.selectAll("dvConsultation.line")
				.data(data.links)								
				.enter().append("svg:g").attr("class","gLink").append("svg:polyline").attr("class", "link")
				.attr("stroke", "black").style("stroke-width", "2").attr("fill","none").attr("points", function (d) {	return renderLinks(d)})
				
			
			
			var linkText = vis.selectAll("dvConsultation.gLink").append("svg:text")
				.data(data.links).text(function(d) {return d.name}).attr("x", function(d) {return (d.target.x - d.source.x)})
				.attr("y", function(d) {return (d.target.y - d.source.y)}).attr("stroke", "black")				
																
			var node = vis.selectAll("#dvConsultation.node").data(data.nodes)
			node.exit().remove();	
			node.enter().append("svg:svg").attr("x", function (d) { return d.x-25; }).attr("y", function (d) { return d.y-10; }).call(oModules.ConsultationModule.force.drag)																	
			node.exit().remove();	
			node.append("svg:rect").attr("width", 120).attr("height", 20).attr("rx", 6).attr("ry", 6)
				.attr("stroke","1")
				.style("fill", function (d) { return fill(d.group); })		
			node.exit().remove();														
			node.append("svg:text").attr("style","stroke: #660000; fill: #660000").attr("y","15px").attr("x","15px").text(function(d) {return d.name});
			
			node.exit().attr("x", function() {alert("2");return 0}).remove();
			
			vis.style("opacity", 1e-6).transition().duration(1000).style("opacity", 1);			
			
			oModules.ConsultationModule.doResize()
			oModules.ConsultationModule.force.on("tick", function () 
			{
				link.attr("points", function (d) {	return renderLinks(d)})					
				node.attr("x", function (d) { return d.x-25; }).attr("y", function (d) { return d.y-10; })																
				linkText.attr("x", function(d) 
							{
								if (d.source.name!=d.target.name)
								{
									tx=d.target.x; sx=d.source.x; x=sx+((tx-sx)/2); return x-35
								}
								else
								{
									if (d.selfrelationship==2) 
									{
										tx=d.target.x; sx=d.source.x; x=sx+((tx-sx)/2); return x+100
									}
									else
									{
										tx=d.target.x; sx=d.source.x; x=sx+((tx-sx)/2); return x-100
									}
								}
							})
						.attr("y", function(d) { ty=d.target.y; sy=d.source.y; y=sy+((ty-sy)/2); return y })										
			});	
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}
	}
	this.renderSSM=renderSSM;
}