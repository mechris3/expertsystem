<?php
	
	session_start();
?>
<html>
	<head>
	<style type="text/css">
	
	
@import  "libraries/dojo-release-1.7.2/dijit/themes/claro/claro.css" ; 
@import  "libraries/dojo-release-1.7.2/dojo/resources/dojo.css";
@import  "libraries/dojo-release-1.7.2/dojox/grid/resources/tundraGrid.css" ; 
</style>
	<script type="text/javascript" src="libraries/dojo-release-1.7.2/dojo/dojo.js" ></script>
	<script type="text/javascript" src="javascripts/utils.js"></script>  					
<!--	<script type="text/javascript" src="javascripts/jquery-1.10.2.min.js"></script>  					-->
	<script type="text/javascript" src="libraries/d3/mbostock-d3-1196f55/d3.v2.js?2.8.1"> </script>			
	
	

		
<style>


.Finding 	{ 	background-color: #BEF59D 	}
.Question 	{	background-color: #F7F30A 	}
.Disease 	{	background-color: #FC909E 	}
.EntryPoint	{	background-color: pink		}

.flash
{
	animation:myfirst 0.2s; 	animation-iteration-count:infinite;	
}
.focusNode
{
	color:red;	
	animation:myfirst 0.2s;
	animation-iteration-count:infinite;	
	border-width:2px
}

@keyframes myfirst
{
	from {background:black;}
	to {background:white;}
	from {color:white;}
	to {color:black;}
}

.node
{
	-webkit-border-radius: .7em;
	-moz-border-radius: .7em;
	border-radius: .7em;
	z-index:100;
	font-size:8;
	border: black;	
	border-style:solid ;
	border-width:1px;	
	cursor: pointer;
	font-family: verdana
}
.link
{
	stroke: #ccc;
	stroke-width: 1
}
.linkText
{
	font-size:7
}

.goal
{
	font-size:6;
	width: 40px
}
.nill
{
	-webkit-border-radius: 1em;
	-moz-border-radius: 1em;
	border-radius: 1em;
	color:gray;
	background-color:gray;
	width: 5px;
	height: 5px
}
body {background-color: #EEE}
.mybutton {
	width: 100px;
	text-align:center;
	padding: .5em;
	color: #ffffff;
	text-shadow: 1px 1px 1px #000;
	border: solid thin #882d13;
	-webkit-border-radius: .7em;
	-moz-border-radius: .7em;
	border-radius: .7em;
	-webkit-box-shadow: 2px 2px 3px #999; 
	box-shadow: 2px 2px 2px #bbb;
	background-color: #ce401c;
	background-image: -webkit-gradient(linear, left top, left bottom, from(#e9ede8), to(#ce401c),color-stop(0.4, #8c1b0b));
}

button.clean-gray 
{
  background-color: #eeeeee;
  background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #eeeeee), color-stop(100%, #cccccc));
  background-image: -webkit-linear-gradient(top, #eeeeee, #cccccc);
  background-image: -moz-linear-gradient(top, #eeeeee, #cccccc);
  background-image: -ms-linear-gradient(top, #eeeeee, #cccccc);
  background-image: -o-linear-gradient(top, #eeeeee, #cccccc);
  background-image: linear-gradient(top, #eeeeee, #cccccc);
  border: 1px solid #ccc;
  border-bottom: 1px solid #bbb;
  border-radius: 3px;
  color: #333;
  font: bold 11px/1 "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", Geneva, Verdana, sans-serif;
  padding: 8px 0;
  text-align: center;
  text-shadow: 0 1px 0 #eee;
  width: 150px; 
 }
 button.clean-gray:hover 
 {
    background-color: #dddddd;
    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #dddddd), color-stop(100%, #bbbbbb));
    background-image: -webkit-linear-gradient(top, #dddddd, #bbbbbb);
    background-image: -moz-linear-gradient(top, #dddddd, #bbbbbb);
    background-image: -ms-linear-gradient(top, #dddddd, #bbbbbb);
    background-image: -o-linear-gradient(top, #dddddd, #bbbbbb);
    background-image: linear-gradient(top, #dddddd, #bbbbbb);
    border: 1px solid #bbb;
    border-bottom: 1px solid #999;
    cursor: pointer;
    text-shadow: 0 1px 0 #ddd; 
}
 
 button.clean-gray:active 
 {
    border: 1px solid #aaa;
    border-bottom: 1px solid #888;
    -webkit-box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee;
    box-shadow: inset 0 0 5px 2px #aaaaaa, 0 1px 0 0 #eeeeee; 
}
.svgContainer
{
	width: 1000px;
	background-color: white;
	height: 600px;
	z-index: -10
}
button
{
	width: 110px
}

.loggingContainer
{
	position:fixed;
	top:30px;
	font-size:10;
	overflow:auto;
	height: 500px;
	bottom: 0px; 
	left:1025px
}
.highlightText
{
	color: red;
}

</style>
</script>

</head>
<body >
<?php			
	$sourceFile=getcwd()."\acessm\ssmCopy.xml";
	$targetFile=getcwd()."\acessm\ssm.xml";
	copy ( $sourceFile , $targetFile );	
?>	
<div class="controls">
<button class="xclean-gray" id="btnStart" onclick="Start()">Start</button>
<button class="xclean-gray" id="btnGetGoals" onclick="GetGoals()">Find Goals</button>
<button class="xclean-gray" id="btnChooseGoal" disabled="disabled" onclick="ChooseGoal()">Choose Goal</button>
<button class="xclean-gray" id="btnSatisfyGoals" disabled="disabled" onclick="SatisfyGoal()">Satisfy Goal</button>
<button class="xclean-gray" id="btnSatisfyGoals" onclick="nCycles(1)">One Cycle</button>
<button class="xclean-gray" id="btnSatisfyGoals" onclick="nCycles(document.getElementById('tNumberOfCycles').value)">n Cycles</button>
<input type="text" value="5" id="tNumberOfCycles"/>
</div>
<div>
	<div class="svgContainer" id="dvConsultation"></div>
	<div class="loggingContainer" id="dvLoggin" ></div>
</div>


<script>

var aSycnBuffer = new Array(); 	// used to allow ordering of async operations
var runNextOperationInBuffer = true;	// set to false before each async call, and back to true when the call is finished so we know if to run the next operation
var firstCycle=true;
var Cycle=0;

var width = 900,
    height = 500;

var color = d3.scale.category10();

var nodes = [],
    links = [];

var goal = new Object();
var force = d3.layout.force()
    .nodes(nodes)
    .links(links)
    .charge(-400)
    .linkDistance(function(d){if ((d.source.name.substr(0,1)=="?")||(d.target.name.substr(0,1)=="?")) {return 25} else {return 120}})
    .size([width, height])
    .on("tick", tick);

var svg = d3.select("#dvConsultation").append("svg:svg")
    .attr("width", width)
    .attr("height", height)
	.attr("id","svg");

var link = svg.selectAll("line"),
	linkArrow = svg.selectAll("polygon.linkArrow"),
	node = svg.selectAll("foreignObject"),    	
	linkText = svg.selectAll("text");



var svg = d3.select("#dvConsultation") 
.append("svg:svg")   
.attr("pointer-events", "all");  

var links = svg.append('svg:g')  
.attr("id","link_elements");   

svg = svg.append('svg:g')   
.attr("id","node_elements");

	

var sBuffer = new serverBuffer();									
sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})					
d3.json(sBuffer.run(), updateJSON)
		
function updateJSON (d)
{
	try
	{				
		
		while (links.length>0) {links.pop()}		
		for (i=0;i<d.links.length;i++)
		{
			links.push(d.links[i])
		}
		
		// we need to not only add nodes that should be there, but take out nodes that should not		
		// add nodes that need to be there - any in d.nodes that are not in nodes		
		for (i=0;i<d.nodes.length;i++)
		{
			// only push it in if the nodes is not already in there
			var id=d.nodes[i].id;							
			var nodeIsInArrayAlready = function(id, nodes)
			{
				for (j=0;j<nodes.length;j++)
				{					
					if (id==nodes[j].id) 
					{					
						nodes[j].name=d.nodes[i].name;
						nodes[j].label=d.nodes[i].label;
						nodes[j].isGoalNode=d.nodes[i].isGoalNode;
						nodes[j].type=d.nodes[i].type;						
						return true;
					}
				}
				return false
			}			
			if (!(nodeIsInArrayAlready(id,nodes)) ) { nodes.push(d.nodes[i]);  }
		}				
		// now remove any from nodes that are not in d.nodes				
		var length=nodes.length-1;		
		for (i=length;i>-1;i--)
		{
			var id=nodes[i].id;
			var popNode=true			;
			for (j=0;j<d.nodes.length;j++)
			{									
				if (id==nodes[j].id) { popNode=false; j=d.nodes.length } 				
			}						
			if (popNode) {nodes.pop(); }
		}				
		dojo.query("polygon").forEach(	function (p) { dojo.destroy(p);});
		dojo.query("text").forEach(	function (p) { dojo.destroy(p);} );	
		start();
	}
	catch(e) { 
	var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
	for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
	alert(x);			
	}	
}		

function tick() {
	node.attr("x", function(d) { var halfWidth=50; if (d.type=="nill") {halfWidth=5}; return d.x-halfWidth; })
		.attr("y", function(d) { var halfWidth=10; if (d.type=="nill") {halfWidth=5}; return d.y-halfWidth;  })

	link.attr("x1", function(d) { return d.source.x; })
		.attr("y1", function(d) { return d.source.y; })
		.attr("x2", function(d) { return d.target.x; })
		.attr("y2", function(d) { return d.target.y; });
	  
	linkArrow.attr("transform", renderArrow)	  
	
	linkText.attr("x", function(d) 
						{
							if (d.source.name!=d.target.name)
							{
								tx=d.target.x; sx=d.source.x; x=sx+((tx-sx)/2); return x-15
							}
						})
			.attr("y", function(d) { ty=d.target.y; sy=d.source.y; y=sy+((ty-sy)/2); return y })
}

function log(p){console.log(p)}
function init() {}

function GetGoals()	
{
	try
	{							
		Cycle=Cycle+1;
		$("btnChooseGoal").disabled=false;
		$("btnSatisfyGoals").disabled="disabled";
		var sBuffer = new serverBuffer();									
		sBuffer.Do({"functionName":"transformAndSave","parameters":["gops.xslt"]})			
		sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})	
		
		d3.json(sBuffer.run(),updateJSON);			
		
	}
	catch(e) { 
	var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
	for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
	alert(x);			
	}	
}

function ChooseGoal()	
{
	try
	{	
		//$("btnGetGoals").disabled="disabled";		
		$("btnChooseGoal").disabled="disabled";
		$("btnSatisfyGoals").disabled=false;
		
		//saveNodePositions();			
		var sBuffer = new serverBuffer();									
		sBuffer.Do({"functionName":"transformAndSave","parameters":["sops.xslt"]})			
		sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})			
		d3.json(sBuffer.run(),showGoal);						
	}
	catch(e) 
	{ 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
	}	
}
function dump(pO) 
{ 
	var x=""
	log("du"+"mp")
	for (prop in pO)	{ x+=prop+"="+pO[prop]+"\n";	}; 
	log(x)
}
function dumpA(pA) 
{ 
	var x=""
	log("du"+"mp")
	for (var i=0;i<pA.length;i++)	{ x+=pA[i]+"\n";	}; 
	log(x)
}
function showGoal(d)
{
try
	{
		var goalText="";
		var Nodes = new Array();
		var nodeDetails = new Array()
		d.nodes.forEach(function(n) 
			{
			var id="node:"+n.id;
			var nd=d3.select($(id))
			
			nodeDetails[n.id]=n;			
			
			if (n.isGoalNode=="true")
			{
				nd.classed("focusNode",true);
				var i = Nodes.length;
				Nodes[i] = {"id":n.id, "name":n.name};
				//log( n.id+ "is a focus node.")
				
			}
			else
			{
				nd.classed("focusNode",false)
			}					
			})		
		var A = "**A not set**";
		var B = "**B not set**";
		var Relationship = "**Relationship not set**";
		var keepLooking=true;
		var keepLooking
		d.links.forEach(function(lnk)
			{
							
				/*
				link
					source=0
					target=1
					name=includes
				
				node
					id=0
					name=Diplopia
				*/
				if (keepLooking)
				{
					if (lnk.source==Nodes[0].id) A = lnk.source;
					if (lnk.source==Nodes[1].id) A = lnk.source;
					if (lnk.target==Nodes[0].id) B = lnk.target;
					if (lnk.target==Nodes[1].id) B = lnk.target;					
					if ((lnk.source==A)&&(lnk.target==B)) { Relationship=lnk.name; keepLooking = false; }					
				}
						
			}
			)
			
		/*
			isGoalNode=true
			id=0
			name=Diplopia
			type=Finding
			group=0
			color=#1F77B4
			label=Diplopia (Double Vision)
		*/		
		goal.A=A; goal.B=B; goal.Relationship=Relationship;
		
		var a; var b;
		if (nodeDetails[A].label!="") {a=nodeDetails[A].label} else {a=nodeDetails[A].name};
		if (nodeDetails[B].label!="") {b=nodeDetails[B].label} else {b=nodeDetails[B].name};
		
		if (a.substring(0,1)=="?") {a="What " +a.substring(1) ; goal.A="?" } else {a="<span onMouseover='highlightNode("+A+",true);' onMouseout='highlightNode("+A+",false);' class='cls"+A+"'>"+a+"</span>"}
		if (b.substring(0,1)=="?") {b=" what "+b.substring(1); goal.B="?"; }else { b="<span onMouseover='highlightNode("+B+",true);' onMouseout='highlightNode("+B+",false);' class='cls"+B+"'>"+b+"</span>"}				
		var UpdateText=Cycle + " - &nbsp;&nbsp;" + a+ " " + Relationship + " " + b+"<br/>";
		var dv=document.getElementById("dvLoggin")
		dv.innerHTML+=UpdateText;
		runNextOperationInBuffer = true;
	}
	catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 		
		alert(x);			
		}		
}

function SatisfyGoal()	
{
	try
	{		
		//$("btnGetGoals").disabled=false;		
		$("btnChooseGoal").disabled="disabled";
		$("btnSatisfyGoals").disabled="disabled";
		//saveNodePositions();
		var sBuffer = new serverBuffer();									
		sBuffer.Do({"functionName":"transformAndSave","parameters":["kops.xslt"]})			
		sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})			
		
		d3.json(sBuffer.run(),refreshSSM);							
	}
	catch(e) { 
	var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
	for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
	alert(x);			
	}	
}	

function start() {
	
	link = link.data(force.links(), function(d) { return d.source.id + "-" + d.target.id; });
	link.enter().append("line", ".node").attr("class", "link");
	link.exit().remove();
	
	linkArrow = svg.selectAll("polygon.linkArrow")
				.data(links)
				.enter()
				.append("polygon")
				.attr("class","linkArrow")
				.attr("points","-3,6 0,0 3,6 0,-1")
				.attr("style","fill:black;stroke:black;stroke-width:1")	;
	
	linkText = linkText.data(force.links(), function(d) { return d.source.id + "-" + d.target.id; });
	linkText.enter().append("text", ".linkText").attr("class", "linkText").text(function(d) {return d.name});
	linkText.exit().remove();			
				
	node = node.data(force.nodes(), function(d) { return d.id;});  
	node.enter().append("foreignObject").attr("width","100").attr("height","100").call(force.drag)
	node.exit().remove();		  
	
	node.html(function(d)
	{
		var lbl=d.label;
		var goal="";
		if (lbl=="") {lbl=d.name; goal=" goal "}
		if (d.type=="nill") {lbl=""}		
		var rtn= "<div title='Node Id: "+d.id+"' id='node:"+d.id+"' onMouseover='highlightText("+d.id+",true)' onMouseout='highlightText("+d.id+",false)' class='node "+d.type+goal+"'>&nbsp;"+lbl+"&nbsp;</div>";
		return rtn
		
	})
	
	
	reorder();
	
	force.start();
	runNextOperationInBuffer = true;
	
	
	firstCycle=false
}

function reorder()
{
	return
	d3.selectAll($("svg").childNodes).sort(function(a,b)
			{
				//if (a.id==undefined) return -1;
				return 0
			
			})
}
function highlightText(pId,pHighlight)
{
	var els = dojo.query(".cls"+pId)
	els.forEach(function(pEl) 
		{			
			if (pHighlight)
			{
				pEl.style="animation:myfirst 0.2s; 	animation-iteration-count:infinite;	";
			}
			else
			{
				pEl.style="";
			}
			
		})	
}

function highlightNode(pId,pHighlight)
{
//log(pHighlight)
	var el = $("node:"+pId)
//	log("node:"+pId)
	if (pHighlight)
	{
		el.style="animation:myfirst 0.2s; 	animation-iteration-count:infinite;	";
	}
	else
	{
		el.style="";
	}
			

}

function refreshSSM(data)
{

	try
		{			
			var allNodeDetails = []

			var nodes = svg.selectAll("foreignObject")
						.data(data.nodes)
						.classed("focusNode",false)
				nodes.exit().remove();
			
			data.nodes.forEach(function(d) 
					{
						var id="node:"+d.id;
						var nd=d3.select($(id))	;
						
						allNodeDetails[d.id]=d.label
						if (allNodeDetails[d.id]=="") {allNodeDetails[d.id]=d.name; }
						nd.classed("focusNode",false)		
						nd.classed("goal",false)								
						nd.classed("node",true)							
						if (d.name=="?nill")
						{
							nd.attr("class","")
							nd.html("")							
							nd.classed("nillNode",true)									
						}
						else
						{																				
							nd.classed(d.type,true)	
						
						}
								
					} )
			
			var edges = svg.selectAll("line")
						.data(links)
				edges.exit().remove();
			
			linkArrow = svg.selectAll("polygon.linkArrow")
						.data(links)												
			linkArrow.exit().remove();
			
			
			dojo.query("text").forEach(	function (p) 
										{
											dojo.destroy(p);
											//alert(p.innerText)
										}
									);
			
			var linkText = svg.selectAll("text")
					.data(data.links)
				linkText.exit().remove();			
			var newNodes = [];
			if (goal.B.toString().substring(0,1)=="?") 
			{
				data.links.forEach(function(d) 
				{
					// we are looing for b's in links where
					// link.A=goal. and link.name=goal.Relationship
					if ((d.source==goal.A)&&(d.name==goal.Relationship))
					{											
						newNodes[newNodes.length]=d.target						
					}
				})
			}			

			if (goal.A.toString().substring(0,1)=="?") 
			{
				data.links.forEach(function(d) 
				{
					// we are looking for a's in links where
					// link.A=goal. and link.name=goal.Relationship
					if ((d.target==goal.B)&&(d.name==goal.Relationship))
					{											
						newNodes[newNodes.length]=d.source;						
					}
				})
			}
			
			newNodes=newNodes.sort(function(a,b){return a-b});
			var noDuplicates = [];
			while (newNodes.length>0)
			{
				var el=newNodes.pop();				
				if (noDuplicates.length==0)
				{
					noDuplicates.push(el)
				}
				if (noDuplicates.length>0)
				{				
					if (noDuplicates[noDuplicates.length-1]!=el) {noDuplicates.push(el)}
				}
			
			}
			//dumpA(noDuplicates)
			
			while (noDuplicates.length>0)
			{
				var n = noDuplicates.pop();
				var t=allNodeDetails[n];
				if (t.substring(0,1)=="?") {t="&lt;none&gt;"}		
				
				t = "<span onMouseover='highlightNode("+n+",true);' onMouseout='highlightNode("+n+",false);'  class='cls" + n +"'>"+t+"</span>";
				
				var UpdateText="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+t+"<br/>";
				var dv=document.getElementById("dvLoggin")
				dv.innerHTML+=UpdateText;
			}
			
			updateJSON(data)
			
		}
	catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 		
		alert(x);			
		}	
}

function quadrant(d)
{
	/* return:
		TR - Top Right
		BR - Bottom Right
		TL - Top Left
		BL - Bottom Left
	*/
	var sx = d.source.x; var sy = d.source.y; var tx = d.target.x; var ty = d.target.y; 
	var x="R"; if (sx>tx) {x="L"};
	var y="T"; if (sy<ty) {y="B"};
	return y+x;
}
function renderArrow(d)
{
	try
	{
		var sx = d.source.x; var sy = d.source.y; var tx = d.target.x; var ty = d.target.y; 
		var dx=tx-sx; var dy=ty-sy;
		var gradient=dy/dx;																									
		var x = tx-(dx/4);
		var y = ty-(dy/4);					
		// the position of the arrow is correct
		// now flip the gradient to it matches the normal mathematical grident
		gradient=-gradient;
		var theta=Math.atan(1/gradient)					
		var angle=Math.degrees(theta);					
		var correctedAngle=angle;
		var quad=quadrant(d)					
		if ((quad=="BL")||(quad=="BR")) { correctedAngle=correctedAngle+180 }

		return "translate("+x+" "+y+") rotate("+correctedAngle+" 0 0)"
	}
	catch(e) 
	{ 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 		
		alert(x);			
	}				
 }
 
 
function nCycles(pNumberOfCycles)
{	
	for (var i=0;i<pNumberOfCycles;i++)
	{
		aSycnBuffer.push("GetGoals()")
		aSycnBuffer.push("ChooseGoal();")
		aSycnBuffer.push("SatisfyGoal();")
	}
	
	flushaSycnBuffer();
}

function flushaSycnBuffer()
{	
	if (aSycnBuffer.length>0) 
	{
	
		if (runNextOperationInBuffer==true)
		{
			var operation=aSycnBuffer.shift()			
			runNextOperationInBuffer = false;
			eval(operation)
		}
		setTimeout("flushaSycnBuffer();",1)
		
	}
	
}

function $(pId) {return document.getElementById(pId)}
// Converts from degrees to radians.
Math.radians = function(degrees) { return degrees * Math.PI / 180; };
// Converts from radians to degrees.
Math.degrees = function(radians) { return radians * 180 / Math.PI; };
</script>

	</body>
</html>