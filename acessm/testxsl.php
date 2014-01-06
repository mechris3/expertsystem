<?php

	$xml = new DOMDocument;
	$xml->load("SSM.xml");

	$xsl = new DOMDocument;
	$xsl->load("GetGoalstructure.xsl");
	
	$proc = new XSLTProcessor;
	$proc->importStyleSheet($xsl); // attach the xsl rules

	echo $proc->transformToXML($xml);

	?>
