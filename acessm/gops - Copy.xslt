<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xsl:template match="/">
		<ssm>
			<meta lastmodifieddate="{/ssm/meta/@lastmodifieddate}">
				<creator>
					<xsl:value-of select="/ssm/meta/creator"/>
				</creator>
				<description>
					<xsl:value-of select="/ssm/meta/description"/>
				</description>
				<xsl:copy-of select="/ssm/meta/goal_structure"/>
				<xsl:copy-of select="/ssm/meta/strategy_operators"/>
			</meta>
			<graph mode="static" defaultedgetype="directed">
				<xsl:copy-of select="/ssm/graph/next_goal"/>
				<nodes>
					<xsl:apply-templates select="ssm/graph/nodes/node"/>
				</nodes>
				<relationships>
					<xsl:apply-templates select="ssm/graph/relationships/relationship"/>
				</relationships>
			</graph>
			<xsl:copy-of select="/ssm/kb"/>
		</ssm>
	</xsl:template>
	<xsl:template match="ssm/graph/nodes/node">
		<!-- First Copy the node -->
		<xsl:copy-of select="."/>
		<!-- Consult the goal structure in the meta to see what goals have been violated -->
		<!-- Something here needs changing as it does not current spot goals of the form 
			a is the unbound node
			 have been satisfied
			 -->
		<xsl:variable name="nodeID" select="@id"/>
		<xsl:variable name="nodeType" select="@type"/>
		<xsl:variable name="nodeName" select="@name"/>
		<goals>
			<xsl:for-each select="/ssm/meta/goal_structure/relationships/relationship[@a=$nodeType]">
				<!-- Check to see if that relationship has been satisfied -->
				<xsl:variable name="relationshipName" select="@type"/>
				<xsl:variable name="numberOfSatisfiedRelationShips" select="count(/ssm/graph/relationships/relationship[(@a=$nodeID or @b=$nodeID) and @type=$relationshipName])"/>
				<xsl:if test="$numberOfSatisfiedRelationShips=0">
					<relationship type="{@type}" a="{$nodeID}" b="?{@b}" aType="{$nodeType}" bType="{@a}"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="/ssm/meta/goal_structure/relationships/relationship[@b=$nodeType]">
				<!-- Check to see if that relationship has been satisfied -->
				<xsl:variable name="relationshipName" select="@name"/>
				<xsl:variable name="numberOfSatisfiedRelationShips" select="count(/ssm/graph/relationships/relationship[(@b=$nodeID or @a=$nodeID) and @type=$relationshipName])"/>
				<xsl:if test="$numberOfSatisfiedRelationShips=0">
					<!-- Do something here -->
					<relationship type="{@type}" a="?{@a}" b="{$nodeID}" aType="{@a}" bType="{$nodeType}"/>
				</xsl:if>
			</xsl:for-each>
		</goals>
	</xsl:template>
	<xsl:template match="ssm/graph/relationships/*">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>