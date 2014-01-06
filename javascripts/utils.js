function polar(ptx,pty,pr,ptheta)
{
	var thetaRad=(ptheta/360)*(2*Math.PI);
	var DeltaX=Math.sqrt((pr*pr) / (Math.tan(thetaRad)*Math.tan(thetaRad)+1));
	var DeltaY=DeltaX*Math.tan(thetaRad);
	var newX=ptx+DeltaX;
	var newY=parseInt(pty)+parseInt(DeltaY)
	var ans= newX+","+newY+" ";
	var t="theta:"+ptheta;
	t+="\nthetaRad:"+thetaRad;
	t+="\nDeltaX:"+DeltaX;
	t+="\nDeltaY:"+DeltaY;
	t+="\npr:"+pr;
	t+="\nptx:"+ptx;
	t+="\npty:"+pty;
	t+="\nnewX:"+newX;
	t+="\nnewY:"+newY;			
	return ans		
}
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
		//var dx=tx-sx; var dy=ty-tx;
		//var gradient=dy/dx;
		// Code to calculate an arrow head
		/*
		var arrowHeadLength=30;		
		var dx=tx-sx; var dy=ty-tx;
		var gradient=dy/dx;
		
		var DeltaX=Math.sqrt((arrowHeadLength*arrowHeadLength)/(1+(1/(gradient*gradient))))
		var DeltaY=-DeltaX/gradient;
		var x1=tx+DeltaX;
		var y1=ty+DeltaY;
		*/
		//var theta=30; var r=50;
		//var lineAngle = Math.atan(gradient);
		//var lineAngleDeg = lineAngle*(180/Math.PI);
		//var totalAngle=theta-lineAngleDeg
		points=p(sx,sy)+p(tx,ty)
		//+polar(tx,ty,r,totalAngle)
	}
	else
	{		
		x=sx;y=sy
		if (d.selfrelationship==2)  {x=x+50}
		points=p(x,y)+p(x,y-verticals)+p(x-horizontals,y-verticals)+p(x-horizontals,y+verticals)+p(x,y+verticals)+p(x,y)		
	}
	
	return points					
}
/*
function updateSSM(json)
{
try
		{
			data=json
			renderSSM(data)
			return						
		}
		catch(e) { 
		var x=arguments.callee.toString().split("(")[0]+"\n"+e.message+"\n"
		for (prop in e)	{ x+=prop+"="+e[prop]+"\n";	}; 
		alert(x);			
		}
}
*/
function $Char(pAscii) {return escape(String.fromCharCode(pAscii))}
function serverBuffer()
{
	this._Buffer = new Array()
	this.Do=function AddInstruction(pInstruction)
		{
			this._Buffer.push(pInstruction)
		}
	this.URLParams = function()
	{
		var ret="";

		var temp;var delim;
		var thisInstruction;
		
		for (var i=0;i<this._Buffer.length;i++)
		{
			temp=""
			thisInstruction=this._Buffer[i];
			for (j=0;j<thisInstruction.parameters.length;j++) {delim=""; if (j>0) {delim=$Char(1)}; temp+=delim+thisInstruction.parameters[j]}
			ret+=thisInstruction.functionName+$Char(1)+temp+$Char(2)
		}
		
		return ret
	}
	this.run = function() {return  "acessm/serverfunctions.php?"+this.URLParams();};
}
function asyncBuffer()
{
	this._Buffer = new Array()
	this.Do=function AddInstruction(pInstruction)
		{
			this._Buffer.push(pInstruction)
		}

	this.run = function() 
	{
		if (this._Buffer.length=0) {return;}
		var xString=this._Buffer.shift();
		if (xString="") {return;};
		xString+=";oAsyncBuffer.run()";
		eval();
		
	};
}