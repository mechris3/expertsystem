<?php

	if (!(isset($_SESSION["ssm"])))
	{
		
		$xml = new DOMDocument;
		$xml->load("SSM.xml");
		$_SESSION['ssm'] = $xml;
	}
	else
	{
		$xml=$_SESSION['ssm'];		
	}
	
	//$xh = xslt_process();
	$xsl = new DOMDocument;
	$xsl->load("gops.xslt");
	
	$proc = new XSLTProcessor;
	$proc->importStyleSheet($xsl); // attach the xsl rules
	$proc->transformToURI($xml,"ssm.xml");
	//echo $xml
	//$xml->save("ssm.xml");
	
	//$xml->saveXML();
	
	$xml->load("SSM.xml");
	// now get the rendered JSON
	$xsl = new DOMDocument;
	
	
	$xsl->load("ssmjson.xsl");	
	$proc->importStyleSheet($xsl); 
	echo $proc->transformToXML($xml);
	

	?>
