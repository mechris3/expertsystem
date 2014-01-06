<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:v="urn:schemas-microsoft-com:vml" version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="q">"</xsl:variable>
	<xsl:template match="/">
		<xsl:text>{</xsl:text>
		<xsl:text>"nodes": [</xsl:text>
		<xsl:apply-templates select="ssm/graph/nodes/node"/>
		<xsl:text>],</xsl:text>
		<xsl:text>"links": [</xsl:text>
		<xsl:apply-templates select="/ssm/graph/relationships/relationship"/>
		<xsl:text>]</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="ssm/graph/nodes/node">
		<xsl:variable name="node" select='concat("{",$q,"id",$q,":",$q,@id,$q,",",$q,"name",$q,":",$q,@name,$q,",",$q,"type",$q,":",$q,@type,$q,",",$q,"group",$q,":",@id,"}")'/>
		<xsl:value-of disable-output-escaping="yes" select="$node"/>
		<xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ssm/graph/relationships/relationship">
		<xsl:value-of disable-output-escaping="yes" select='concat("{",$q,"source",$q,":",@a,",",$q,"target",$q,":",@b,",",$q,"name",$q,":",$q,@type,$q,"}")'/>
				<xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>