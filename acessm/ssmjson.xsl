<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>
	<xsl:variable name="q">"</xsl:variable>
	<xsl:template match="/">
		<xsl:text>{</xsl:text>
		<xsl:text>"nodes": [</xsl:text>
		<xsl:apply-templates select="/ssm/graph/nodes/node"/>
		<xsl:apply-templates select="/ssm/graph/nodes/goals/relationship" mode="node"/>
		<xsl:text>],</xsl:text>
		<xsl:text>"links": [</xsl:text>
		<xsl:apply-templates select="/ssm/graph/relationships/relationship" mode="links"/>
		<xsl:apply-templates select="/ssm/graph/nodes/goals/relationship" mode="links"/>
		<xsl:text>]</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template match="ssm/graph/nodes/node">
		<xsl:variable name="focusNodeId">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@b"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@a"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="goalNode">
			<xsl:value-of select="$focusNodeId=@id"/>
		</xsl:variable>
		<xsl:variable name="type" select="@type"/>
		<xsl:variable name="name" select="@name"/>
		<xsl:variable name="label" select="/ssm/kb/nodes/node[@name=$name]/@label"/>
		<xsl:variable name="color" select="/ssm/meta/goal_structure/nodes/node[@type=$type]/@color"/>
		<xsl:variable name="node">
			<xsl:value-of select='concat("{",$q,"isGoalNode",$q,":",$q,$goalNode,$q,",",$q,"id",$q,":",$q,@id,$q,",",$q,"name",$q,":",$q,@name,$q,",")'/>
			<xsl:value-of select='concat($q,"type",$q,":",$q,@type,$q,",",$q,"group",$q,":",@id,",",$q,"color",$q,":",$q,$color,$q,",",$q,"label",$q,":",$q,$label,$q,"}")'/>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes" select="$node"/>
		<xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/ssm/graph/nodes/goals/relationship" mode="node">
		<xsl:variable name="HighestNodeSoFar" select="count(/ssm/graph/nodes/node)-1"/>
		<xsl:variable name="nodeId" select="$HighestNodeSoFar+position()"/>
		<xsl:variable name="name" select="/ssm/graph/next_goal/relationship/@type"/>
		<xsl:variable name="a" select="/ssm/graph/next_goal/relationship/@a"/>
		<xsl:variable name="b" select="/ssm/graph/next_goal/relationship/@b"/>
		<xsl:variable name="isGoalNode">
			<xsl:choose>
			<!--<xsl:when test="(@name=$name) and (@a=$a) or ( (@a=$a) and (@b=$b))">	-->
<!--				<xsl:when test="(@type=$name) and (@a=$a) or ((@type=$name) and (@a=$a) and (@b=$b))"> -->
				<xsl:when test="((@type=$name) and (@a=$a) and (@b=$b))">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:text>,</xsl:text>
		<xsl:variable name="goalNode">
			<xsl:choose>
				<xsl:when test="starts-with(@b,'?')">
					<!-- Edit this -->
					<xsl:value-of select="@b"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@a"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="node">
			<!-- Something here needs changing, the type is wrong -->
			<xsl:variable name="type" select="substring($goalNode,2)"/>
			<xsl:value-of select='concat("{",$q,"isGoalNode",$q,":",$q,$isGoalNode,$q,",",$q,"id",$q,":",$q,$nodeId,$q,",",$q,"name",$q,":",$q,$goalNode,$q,",",$q,"type",$q,":",$q,$type,$q,",",$q,"label",$q,":",$q,$q,"}")'/>
		</xsl:variable>
		<xsl:value-of disable-output-escaping="yes" select="$node"/>
	</xsl:template>
	<xsl:template match="ssm/graph/relationships/relationship" mode="links">
		<xsl:value-of disable-output-escaping="yes" select='concat("{",$q,"source",$q,":",@a,",",$q,"target",$q,":",@b,",",$q,"name",$q,":",$q,@type,$q,"}")'/>
		<xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/ssm/graph/nodes/goals/relationship" mode="links">
		<xsl:variable name="HighestNodeSoFar" select="count(/ssm/graph/nodes/node)-1"/>
		<xsl:if test="not(count(/ssm/graph/relationships/relationship) = 0 and position()=1)">
			<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="starts-with(@a,'?')">
				<!-- Edit this -->
				<xsl:value-of disable-output-escaping="yes" select='concat("{",$q,"source",$q,":",$HighestNodeSoFar+position(),",",$q,"target",$q,":",@b,",",$q,"name",$q,":",$q,@type,$q,"}")'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of disable-output-escaping="yes" select='concat("{",$q,"source",$q,":",@a,",",$q,"target",$q,":",$HighestNodeSoFar+position(),",",$q,"name",$q,":",$q,@type,$q,"}")'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>