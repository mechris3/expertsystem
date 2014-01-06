function GoalStructureModule()
{
	if (dojo.query("#dvGoalStructure").length>0) return;
	w=1000;
	h=750;
	o = new Object();
	force = new Object();
	init()
	function init()
	{		
		try
		{									
			win = new Window({className: "bluelighting", title: "Goal Structure", width:this.w+"px", height:this.h+"px", 
				destroyOnClose: true, recenterAuto:false, resizable:true, onResize:function() {doResize()}, 
						onMaximize:function() {doResize()}    });			
			var dvGoalStructure = dojo.create("div",{id:"dvGoalStructure"},dojo.body());			
			createLayout(dvGoalStructure)
			dvGoalStructure.style.backgroundColor="gray"
			win.setContent("dvGoalStructure");					
			win.setCloseCallback(function() { dojo.destroy("dvGoalStructure") ; return true; });
			win.showCenter();
			doResize();
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}	
	}
	
	function doResize()
	{
		this.w=win.width;
		this.h=win.height;
		dvGoalStructure=dojo.byId("dvGoalStructure");
		dvGoalStructure.style.height=this.h;
		dvGoalStructure.style.width=this.w;
				
		svgGoals=dojo.byId("svgGoals")
		svgGoals.width=this.w;
		svgGoals.height=this.h;
		force.size([this.w,this.h]);
		window.status="HI"
		force.start();
		force.resume();
	} 	
	function createLayout(pDV)
	{
		try
		{			
			var w = this.w; var h = this.h;
			var fill = d3.scale.category20(); //twenty colors
			var linkmap = d3.scale.category20b(); //twenty colors		
			var vis = d3.select("#dvGoalStructure").append("svg:svg").attr("id","svgGoals");											
			force = d3.layout.force()
				force.charge(-420)
                force.distance(200)
                force.theta(.04)
                force.gravity(.024)           
                force.size([w, h])	
			//this.o=force
			
			
			function renderGoalStructure(json)
			{
				function renderLinks(d)
				{						
					function p(pX,pY) { return pX+","+pY+" " }
					var verticals=25;
					var horizontals=80;					
					if (d.selfrelationship==2) {horizontals=-80; }
					
					tx=Math.round(d.target.x); sx=Math.round(d.source.x); 
					ty=Math.round(d.target.y); sy=Math.round(d.source.y); 
					if (d.source.name!=d.target.name)
					{
						points=p(sx,sy)+p(tx,ty)						
					}
					else
					{
						
						x=sx;y=sy
						if (d.selfrelationship==2)  {x=x+50}
						points=p(x,y)+p(x,y-verticals)+p(x-horizontals,y-verticals)+p(x-horizontals,y+verticals)+p(x,y+verticals)+p(x,y)
						
					}					
					return points					
				}
				data=json				
				force.nodes(data.nodes)            			
				force.links(data.links)            
				force.start();
 
				var link = vis.selectAll("dvGoalStructure")
					.data(data.links).enter().append("svg:g").attr("class","gLink").append("svg:polyline").attr("class", "link")
					.attr("stroke", "black").style("stroke-width", "2").attr("fill","none").attr("points", function (d) {	return renderLinks(d)})					

				var linkText = vis.selectAll(".gLink").append("svg:text")
					.data(data.links).text(function(d) {return d.name}).attr("x", function(d) {return (d.target.x - d.source.x)})
					.attr("y", function(d) {return (d.target.y - d.source.y)}).attr("stroke", "black");
														
				var node = vis.selectAll("dvGoalStructure").data(data.nodes).enter()
					.append("svg:svg").attr("x", function (d) { return d.x-25; }).attr("y", function (d) { return d.y-10; }).call(force.drag)																	
				node.append("svg:rect").attr("width", 120).attr("height", 20).attr("rx", 6).attr("ry", 6)
					.attr("stroke","1")
					.style("fill", function (d) { return fill(d.group); })															
																									
				node.append("svg:text").attr("style","stroke: #660000; fill: #660000").attr("y","15px").attr("x","15px").text(function(d) {return d.name})														
				vis.style("opacity", 1e-6).transition().duration(1000).style("opacity", 1);
				force.on("tick", function () 
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
			force.start();
			force.resume();
			d3.json("acessm/GetGoalstructure.php",renderGoalStructure);
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}	
	}
}