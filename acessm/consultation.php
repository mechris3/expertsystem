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
	
	$xsl = new DOMDocument;
	$xsl->load("ssmjson.xsl");
	
	$proc = new XSLTProcessor;
	$proc->importStyleSheet($xsl); // attach the xsl rules

	echo $proc->transformToXML($xml);
	
	

	?>
