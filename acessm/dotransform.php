 <?php
	//d3.json("acessm/dotransform.php?mode=return&xsl=ssmjson.xsl",renderSSM);
	
	$proc = new XSLTProcessor;
	 // attach the xsl rules
	
	if ($_GET["mode"]=="return") { echo $proc->transformToXML($xml); }
	
	
	
	
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
	
	/*
	
		$xsl = new DOMDocument;
	$xsl->load("sops.xslt");
	
	$proc = new XSLTProcessor;
	$proc->importStyleSheet($xsl); // attach the xsl rules
	$proc->transformToURI($xml,"ssm.xml");
	//print $xml->saveXML();
	//$xml->save("ssm.xml");
	
	//$xml->saveXML();
	
	//$xml->load("SSM.xml");
	// now get the rendered JSON
	$xsl = new DOMDocument;		
	$xsl->load("ssmjson.xsl");	
	$proc->importStyleSheet($xsl); 
	echo $proc->transformToXML($xml);
	*/
 ?>