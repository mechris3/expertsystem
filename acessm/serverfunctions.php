<?php
	
	$nl = chr(13).chr(10);
	$instructionsArray = explode(chr(2),urldecode($_SERVER['QUERY_STRING']));
	//echo urldecode($_SERVER['QUERY_STRING']);	
	//echo "count($instructionsArray):".count($instructionsArray).$nl;
	
	for ($i=0; $i<count($instructionsArray); $i++)
	{
		$instruction=$instructionsArray[$i];
		if ($instruction!="") 
		{
			$line=explode(chr(1),$instruction);
			$fnName=$line[0];
			$params=array_slice($line,1);			
			//echo "instruction:".$instruction.$nl;
			//echo "fnName:".$fnName.$nl;
			$args="";
			for ( $j=1; $j<=count($params); $j++)
			{
				$coma=",";
				if ($j==count($params)) $coma="" ;
				$param=chr(34).$line[$j].chr(34).$coma;
				$args=$args.$param;
				
				//echo "param:".$param.$nl;
				//$args=$args.chr(34).$line($j).chr(34);
				
			}
						
			$xString=$fnName."(".$args.");";			
			//echo "xString:".$xString.$nl;
			if ($fnName=="transformAndSave") { eval($xString);};
			if ($fnName=="transformAndEcho") { eval($xString);};
		}
	}
	
	
	function transformAndSave($pXSLFile) 
	{
		$xml = new DOMDocument;
		$xml->load("SSM.xml");
		$xsl = new DOMDocument;
		$xsl->load($pXSLFile);	
		$proc = new XSLTProcessor;
		$proc->importStyleSheet($xsl);
		$proc->transformToURI($xml,"ssm.xml");
	}
	
	function transformAndEcho($pXSLFile) 
	{
		
		$xml = new DOMDocument;
		$xml->load("SSM.xml");
		$xsl = new DOMDocument;
		$xsl->load($pXSLFile);	
		$proc = new XSLTProcessor;
		$proc->importStyleSheet($xsl);		
		echo $proc->transformToXML($xml);
	}
	
?>
