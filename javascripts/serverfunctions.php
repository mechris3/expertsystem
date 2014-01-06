<?php
	
	//$qString=$_SERVER['QUERY_STRING'];
	//echo "fred".$qString;
	function transformAndSave($pXSLFile) 
	{
		$xml = new DOMDocument;
		$xml->load("SSM.xml");
		$xsl = new DOMDocument;
		$xsl->load($_GET["xsl"]);	
		$proc = new XSLTProcessor;
		$proc->importStyleSheet($xsl);
		$proc->transformToURI($xml,"ssm.xml");
	}
	
	function transformAndEcho($pXSLFile) 
	{
		$xml = new DOMDocument;
		$xml->load("SSM.xml");
		$xsl = new DOMDocument;
		$xsl->load($_GET["xsl"]);	
		$proc = new XSLTProcessor;
		$proc->importStyleSheet($xsl);		
		echo $proc->transformToXML($xml);
	}
	
?>
ffddfsdfsdfs