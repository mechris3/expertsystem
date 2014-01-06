function ConsultationControlsModule()
{
	if (dojo.query("#dvConsultationControls").length>0) return;
	init();
	function init()
	{
		try
		{
			win = new Window({className: "bluelighting", title: "Consultation Controls", width:"250px", height:"300px", 
				destroyOnClose: true, recenterAuto:false, resizable:true , top:"50px", left:"20px" });
			var dvConsultationControls = dojo.create("div",{id:"dvConsultationControls"},dojo.body());		
			win.setCloseCallback(function() { dojo.destroy("dvConsultationControls") ; return true; })			
			createLayout(dvConsultationControls)
			win.setContent("dvConsultationControls")
			win.show();
			oModules.ConsultationControlsModule=win;
			
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}	
	}

	
	function createLayout(pDV)
	{
		try
		{			
			var ctl = new Array();
			
			ctl[0]=dojo.create("button",{},pDV);	
			ctl[0].innerHTML ="Run"
			ctl[0].id ="btnRunOnce"
			ctl[0].onclick = function() {RunOneCycle()};
			
			ctl[1] = dojo.create("button",{},pDV);	
			ctl[1].innerHTML ="Find Goals"
			ctl[1].onclick = function() {GetGoals()};
			ctl[1].id ="btnFindGoals"

			ctl[2] = dojo.create("button",{},pDV);	
			ctl[2].innerHTML ="Chose Goal"
			ctl[2].onclick = function() {ChooseGoal()};
			ctl[2].disabled=true;
			ctl[2].id="btnChooseGoal";

			ctl[3] = dojo.create("button",{},pDV);	
			ctl[3].innerHTML ="Satisfy Goal"
			ctl[3].onclick = function() {SatisfyGoals()};
			ctl[3].disabled=true;
			ctl[3].id="btnSatisfyGoal"


			ctl[4] = dojo.create("button",{},pDV);	
			ctl[4].innerHTML ="One Cycle"

			ctl[5] = dojo.create("button",{},pDV);	
			ctl[5].innerHTML ="Continue"
			for (i=0;i<ctl.length;i++) {ctl[i].style.width="100px"}
			
			
			ctl[6] = dojo.create("div",{},pDV);	
			ctl[6].innerHTML ="Cycle Number: "
			
			ctl[7] = dojo.create("div",{},pDV);	
			ctl[7].innerHTML ="1"			
			ctl[7].id ="spnCycleNumber"
			
			
			ctl[8]=dojo.create("button",{},pDV);	
			ctl[8].innerHTML ="Run n"
			ctl[8].id ="btnRunN"
			ctl[8].style.width="100px"
			ctl[8].onclick = function() {RunNCycles()};

			ctl[7] = dojo.create("input",{},pDV);	
			ctl[7].type ="text"			
			ctl[7].id ="txtCycleNumber"


			ctl[8] = dojo.create("textarea",{},pDV);	
			ctl[8].type ="textarea";	
			ctl[8].id ="txtGoalText";
			ctl[8].rows="4";
			ctl[8].cols="25"
			
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}	
	}

function RunNCycles()
{
	try
	{	
		
		saveNodePositions();		
		var sBuffer = new serverBuffer();									
		var NumCycles=$("txtCycleNumber").value
		for (i=0;i<NumCycles;i++)
		{
			sBuffer.Do({"functionName":"transformAndSave","parameters":["gops.xslt"]})			
			sBuffer.Do({"functionName":"transformAndSave","parameters":["sops.xslt"]})			
			sBuffer.Do({"functionName":"transformAndSave","parameters":["kops.xslt"]})			
			
			
		}
		sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})		
		d3.json(sBuffer.run(),updateSSM);			
			
	}
		
	catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
	}	
		
}
	
function RunOneCycle()
{
	try
	{	
		$("btnChooseGoal").disabled=false
		$("btnSatisfyGoal").disabled=true
		$("btnRunOnce").disabled=false
			saveNodePositions();
			var sBuffer = new serverBuffer();									
			sBuffer.Do({"functionName":"transformAndSave","parameters":["gops.xslt"]})			
			sBuffer.Do({"functionName":"transformAndSave","parameters":["sops.xslt"]})			
			sBuffer.Do({"functionName":"transformAndSave","parameters":["kops.xslt"]})			
			sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})	
			var currentCycle=$("spnCycleNumber").innerHTML;
			$("spnCycleNumber").innerHTML=parseInt(currentCycle)+1;
			d3.json(sBuffer.run(),updateSSM);			
			
	}
		
	catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
	}	
		
}






	
}


function saveNodePositions()
{
	try
	{
		force.stop();
		var NodesLength=force.nodes().length		
		for (var node=0;node<NodesLength;node++)
		{
			var oNode=force.nodes()[node];
			var toNode = {"index":oNode.index,"x":oNode.x,"y":oNode.y,}				
			ConsultationNodePositions.push(toNode)		
		}		

	}
	catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
	}		
}