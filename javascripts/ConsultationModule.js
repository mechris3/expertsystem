function ConsultationModule()
{
	if (dojo.query("#dvConsultation").length>0) return;
	// global reference = oModules.ConsultationModule
	this.w=1000;
	this.h=800;
	this.window;
	this.force = d3.layout.force();
	this.nodes = new Array();
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
				destroyOnClose: true, recenterAuto:false, resizable:true, onResize:function() {oModules.ConsultationModule.doResize()}, onMaximize:function() {oModules.ConsultationModule.doResize()},
				onFocus:function() {setTimeout("oModules.ConsultationControlsModule.toFront()",10)}});
			
			pModule.window=ConsultationWindow
			var dvConsultation = dojo.create("div",{id:"dvConsultation"},dojo.body());			
			createLayout(dvConsultation,pModule)
			dvConsultation.style.backgroundColor="white"
			ConsultationWindow.setContent("dvConsultation");					
			ConsultationWindow.setCloseCallback(function() { dojo.destroy("dvConsultation") ; return true; });
			ConsultationWindow.showCenter();
			
			//ConsultationWindow.maximize();
			//setTimeout("try {oModules.ConsultationWindow.maximize();} catch(e) {alert(e)}",200)
			
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
			pModule.force.charge(-220)            
			pModule.force.linkDistance(function(d){if ((d.source.name.substr(0,1)=="?")||(d.target.name.substr(0,1)=="?")) {return 100} else {return 200}})
            pModule.force.theta(.04)
            pModule.force.gravity(.024)           
			pModule.force.size([pModule.w, pModule.h])													
			setTimeout("oModules.ConsultationModule.window.maximize();",10)			
			var sBuffer = new serverBuffer();									
			sBuffer.Do({"functionName":"transformAndEcho","parameters":["ssmjson.xsl"]})			
			d3.json(sBuffer.run(),renderSSM);			
			
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}			
	}
	function getGoalText()
	{
		try
		{
			var sBuffer = new serverBuffer();	
			sBuffer.Do({"functionName":"transformAndEcho","parameters":["getGoal.xsl"]})		
			d3.text(sBuffer.run(),setGoalText);
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}
	}
	function setGoalText(pText)
	{
		dojo.byId("txtGoalText").value=pText;
	}
	this.renderSSM=renderSSM;
}

