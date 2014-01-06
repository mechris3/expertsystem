<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="q">"</xsl:variable>
	<xsl:template match="/">
		<xsl:text>{"nodes":[</xsl:text>
		<xsl:apply-templates select="/ssm/meta/goal_structure/nodes/node" mode="node"/>
		<xsl:text>],</xsl:text>
		<xsl:text>"links":[</xsl:text>
		<xsl:apply-templates select="/ssm/meta/goal_structure/relationships/relationship"/>
		<xsl:text>]}</xsl:text>
	</xsl:template>
	<xsl:template match="/ssm/meta/goal_structure/nodes/node" mode="node">
		<xsl:value-of disable-output-escaping="yes" select='concat("{",$q,"name",$q,":",$q,@type,$q,",",$q,"group",$q,":",$q,position()-1,$q,"}")'/>
		<xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/ssm/meta/goal_structure/relationships/relationship">
		<xsl:variable name="a" select="@a"/>
		<xsl:variable name="b" select="@b"/>
		<xsl:variable name="name" select="@type"/>
		<xsl:variable name="selfrelationship">
			<xsl:if test="@a=@b">
				<xsl:apply-templates select="/ssm/meta/goal_structure/relationships/relationship[@a=@b and @a=$a]" mode="selflinks">
					<xsl:with-param name="relationshipName" select="$name"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="source">
			<xsl:apply-templates select="/ssm/meta/goal_structure/nodes/node" mode="links">
				<xsl:with-param name="nodeName" select="$a"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="target">
			<xsl:apply-templates select="/ssm/meta/goal_structure/nodes/node" mode="links">
				<xsl:with-param name="nodeName" select="$b"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes" select='concat("{",$q,"source",$q,":",$source,",",$q,"target",$q,":",$target,",",$q,"name",$q,":",$q,@type,$q,",",$q,"selfrelationship",$q,":",$q,$selfrelationship,$q,"}")'/>
		<xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template mode="links" match="*">
		<xsl:param name="nodeName"/>
		<xsl:if test="@type=$nodeName">
			<xsl:value-of select="position()-1"/>
		</xsl:if>
		<xsl:text/>
	</xsl:template>
	<xsl:template mode="selflinks" match="*">
		<xsl:param name="relationshipName"/>
		<xsl:if test="$relationshipName=@name">
			<xsl:value-of select="position()"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>