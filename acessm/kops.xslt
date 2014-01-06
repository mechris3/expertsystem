<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xsl:template match="/">
		<ssm>
			<xsl:copy-of select="ssm/meta"/>
			<graph mode="static" defaultedgetype="directed">
				<xsl:copy-of select="/ssm/graph/next_goal"/>
				<nodes>
					<xsl:apply-templates select="/ssm/graph/nodes"/>
					<!-- This adds new nodes -->
					<xsl:apply-templates select="/ssm/graph/next_goal" mode="node">
						<xsl:with-param name="outputtype" select="tag"/>
					</xsl:apply-templates>
				</nodes>
				<relationships>
					<xsl:apply-templates select="/ssm/graph/relationships"/>
					<xsl:apply-templates select="/ssm/graph/next_goal" mode="relationship"/>
					<!-- if the nodes that would have been added, already existed in the ssm
						this creates the relationships for them -->
					<!-- <xsl:apply-templates select="/ssm/graph/next_goal" mode="findRelationships"/> -->
					<fred>
						<xsl:apply-templates select="/ssm/graph/next_goal" mode="node">
							<xsl:with-param name="outputtype" select="list"/>
						</xsl:apply-templates>
					</fred>
					<xsl:call-template name="findRelationShips"/>
				</relationships>
			</graph>
			<xsl:copy-of select="/ssm/kb"/>
		</ssm>
	</xsl:template>
	<xsl:template match="/ssm/graph/nodes/node">
		<!-- First Copy the node -->
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="/ssm/graph/relationships/relationship">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="createNodes">
		<xsl:param name="nodeList"/>
		<xsl:param name="idToUse"/>
		<!--
		<debug>
			<xsl:value-of select="$nodeList"/>
		</debug>
-->
		<xsl:variable name="thisNode" select="substring-before($nodeList,',')"/>
		<xsl:variable name="restOfNodes" select="substring-after($nodeList,',')"/>
		<!-- Finding:FocalNeurologicalFinding:28 -->
		<xsl:variable name="nodeName" select="substring-before(substring-after($thisNode,':'),':')"/>
		<!--
		<debug a="nodeName">
			<xsl:value-of select="$nodeName"/>
		</debug>
	-->
		<xsl:variable name="nodeType" select="substring-before($thisNode,':')"/>
		<xsl:variable name="nodeId" select="substring-after(substring-after($thisNode,':'),':')"/>
		<xsl:if test="count(/ssm/graph/nodes/node[(@name=$nodeName) and substring($nodeName,1,1)!='?'])=0">
			<xsl:variable name="label" select="/ssm/kb/nodes/node[@name=$nodeName]/@label"/>
			<node type="{$nodeType}" name="{$nodeName}" id="{$idToUse}" label="{$label}" c="{count(/ssm/graph/nodes/node[@name=$nodeName])}"/>
		</xsl:if>
		<!-- Recursively go through the node list -->
		<!-- TODO can probably add a parameter to the call to createNodes that outputs either the nodes as tag
			or else as a string list. We then know what nodes have been added can can use this to decide if any relationsips
			need adding -->
		<xsl:if test="$restOfNodes!=''">
			<xsl:call-template name="createNodes">
				<xsl:with-param name="nodeList" select="$restOfNodes"/>
				<xsl:with-param name="idToUse" select="$idToUse+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/ssm/graph/next_goal" mode="node">
		<xsl:param name="outputtype"></xsl:param>
		<!-- Responsible for adding the new node (or nill) to the ssm from the kb -->
		<!-- Before adding the node, we need to check if the node is already present in the ssm from an earlier iteration -->
		<xsl:variable name="relationshipName" select="/ssm/graph/next_goal/relationship/@type"/>
		<xsl:variable name="boundNodeId">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@b"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@a"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="boundNode">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="'b'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'a'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="boundNodeName" select="/ssm/graph/nodes/node[@id=$boundNodeId]/@name"/>
		<!-- Infer the current Max Id from the number of nodes -->
		<xsl:variable name="startId" select="count(/ssm/graph/nodes/node)"/>
		<xsl:variable name="nodeList">
			<xsl:choose>
				<xsl:when test="$boundNode='a'">
					<!--
				count(/ssm/graph/nodes/node[@type=$newNodeType and @name=$newNodeName])
				we are probably going to check that @b does not already exist in /ssm/graph/nodes/node
				-->
					<xsl:for-each select="/ssm/kb/relationships/relationship[@type=$relationshipName and @a=$boundNodeName]">
						<xsl:variable name="newNodeName" select="@b"/>
						<xsl:variable name="newNodeType" select="/ssm/kb/nodes/node[@name=$newNodeName]/@type"/>
						<xsl:variable name="label" select="/ssm/kb/nodes/node[@name=$newNodeName]/@label"/>
						<xsl:variable name="id" select="$startId+position()-1"/>
						<xsl:variable name="attributes">
							<xsl:for-each select="/ssm/kb/nodes/node[@name=$newNodeName]/attribute">
								<xsl:value-of select="concat(@name,'=',@value,'|')"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="concat($newNodeType,':',$newNodeName,':',$attributes,',')"/>
					</xsl:for-each>
					<xsl:if test="count(/ssm/kb/relationships/relationship[@type=$relationshipName and @a=$boundNodeName])=0">
						<xsl:variable name="id" select="$startId+position()-1"/>
						<xsl:value-of select="concat('nill',':','?nill:',',')"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<!--					<xsl:for-each select="/ssm/kb/relationships/relationship[(@type=$relationshipName and @b=$boundNodeName) and count(/ssm/graph/nodes/node[@a])=0]"> -->
					<xsl:for-each select="/ssm/kb/relationships/relationship[@type=$relationshipName and @b=$boundNodeName]">
						<xsl:variable name="newNodeName" select="@a"/>
						<xsl:variable name="newNodeType" select="/ssm/kb/nodes/node[@name=$newNodeName]/@type"/>
						<xsl:variable name="label" select="/ssm/kb/nodes/node[@name=$newNodeName]/@label"/>
						<xsl:variable name="id" select="$startId+position()-1"/>
						<xsl:variable name="attributes">
							<xsl:for-each select="/ssm/kb/nodes/node[@name=$newNodeName]/attribute">
								<xsl:value-of select="concat(@name,'=',@value,'|')"/>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="concat($newNodeType,':',$newNodeName,':',$attributes,',')"/>
					</xsl:for-each>
					<xsl:if test="count(/ssm/kb/relationships/relationship[@type=$relationshipName and @b=$boundNodeName])=0">
						<xsl:variable name="id" select="$startId+position()-1"/>
						<xsl:value-of select="concat('nill',':','?nill:',',')"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="createNodes">
			<xsl:with-param name="nodeList" select="$nodeList"/>
			<xsl:with-param name="idToUse" select="count(/ssm/graph/nodes/node)"/>
		</xsl:call-template>
		<!--
		**********
		<xsl:value-of select="$nodeList"></xsl:value-of>
		Finding:FocalNeurologicalFinding,
		*********
		-->
	</xsl:template>
	<xsl:template match="/ssm/graph/next_goal" mode="relationship">
		<!-- Responsible for adding the new relationship to the ssm from the kb -->
		<xsl:variable name="relationshipName" select="/ssm/graph/next_goal/relationship/@type"/>
		<xsl:variable name="boundNodeId">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@b"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@a"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="boundNode">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="'b'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'a'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="boundNodeName" select="/ssm/graph/nodes/node[@id=$boundNodeId]/@name"/>
		<!-- Infer the current Max Id from the number of nodes -->
		<xsl:variable name="startId" select="count(/ssm/graph/nodes/node)"/>
		<xsl:variable name="NodesInSSM">
			<xsl:for-each select="/ssm/graph/nodes/node">
				<xsl:value-of select="concat(':',@name,':')"/>
			</xsl:for-each>
		</xsl:variable>
		<!--
		<debug a="NodesInSSM">
			<xsl:value-of select="$NodesInSSM"/>
		</debug>
-->
		<xsl:choose>
			<xsl:when test="$boundNode='a'">
				<xsl:for-each select="/ssm/kb/relationships/relationship[(@type=$relationshipName and @a=$boundNodeName) and not(contains($NodesInSSM,concat(':',@b,':'))) ]">
					<xsl:variable name="newNodeName" select="@b"/>
					<xsl:variable name="newNodeType" select="/ssm/kb/nodes/node[@name=$newNodeName]/@type"/>
					<xsl:variable name="aId" select="/ssm/kb/nodes/node[@name=$newNodeName]/@label"/>
					<!-- If the node doesn't already exist, it will have been created so set bId to -->
					<xsl:variable name="bId" select="$startId+position()-1"/>
					<xsl:variable name="aNodeName">
						<xsl:call-template name="getNameFromId">
							<xsl:with-param name="pId" select="$boundNodeId"/>
						</xsl:call-template>
					</xsl:variable>
					<relationship type="{/ssm/graph/next_goal/relationship/@type}" a="{$boundNodeId}" b="{$bId}" aText="{$aNodeName}" bText="{$newNodeName}" id="{$boundNodeId}x{$bId}"/>
				</xsl:for-each>
				<!-- Now take care of the nill case -->
				<xsl:if test="count(/ssm/kb/relationships/relationship[@type=$relationshipName and @a=$boundNodeName])=0">
					<xsl:variable name="bId" select="$startId+position()-1"/>
					<relationship type="{/ssm/graph/next_goal/relationship/@type}" a="{$boundNodeId}" b="{$bId}" aText="{$boundNodeName}" bText="?nill" id="{$boundNodeId}x{$bId}"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="/ssm/kb/relationships/relationship[@type=$relationshipName and @b=$boundNodeName]">
					<xsl:variable name="newNodeName" select="@a"/>
					<xsl:variable name="newNodeType" select="/ssm/kb/nodes/node[@name=$newNodeName]/@type"/>
					<xsl:variable name="aId" select="$startId+position()-1"/>
					<xsl:variable name="bId" select="/ssm/kb/nodes/node[@name=$newNodeName]/@label"/>
					<relationship type="{/ssm/graph/next_goal/relationship/@type}" a="{$aId}" b="{$boundNodeId}" aText="{$newNodeName}" bText="{$boundNodeName}" id="{$aId}x{$boundNodeId}"/>
				</xsl:for-each>
				<!-- Now take care of the nill case -->
				<xsl:if test="count(/ssm/kb/relationships/relationship[@type=$relationshipName and @b=$boundNodeName])=0">
					<xsl:variable name="aId" select="$startId+position()-1"/>
					<relationship type="{/ssm/graph/next_goal/relationship/@type}" a="{$aId}" b="{$boundNodeId}" aText="?nill" bText="{$boundNodeName}" id="{$aId}x{$boundNodeId}"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="/ssm/graph/next_goal" mode="findRelationships">
		<!- Responsible for adding the new node (or nill) to the ssm from the kb ->
		<xsl:variable name="relationshipName" select="/ssm/graph/next_goal/relationship/@type"/>
		<xsl:variable name="boundNodeId">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@b"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/ssm/graph/next_goal/relationship/@a"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="boundNode">
			<xsl:choose>
				<xsl:when test="substring(/ssm/graph/next_goal/relationship/@a,1,1)='?'">
					<xsl:value-of select="'b'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'a'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="boundNodeName" select="/ssm/graph/nodes/node[@id=$boundNodeId]/@name"/>
		<!- Infer the current Max Id from the number of nodes ->
		<xsl:variable name="startId" select="count(/ssm/graph/nodes/node)"/>
		<xsl:variable name="nodeList">
			<xsl:choose>
				<xsl:when test="$boundNode='a'">
					<xsl:for-each select="/ssm/kb/relationships/relationship[@type=$relationshipName and @a=$boundNodeName]">
						<xsl:variable name="newNodeName" select="@b"/>
						<xsl:variable name="newNodeType" select="/ssm/kb/nodes/node[@name=$newNodeName]/@type"/>
						<xsl:variable name="label" select="/ssm/kb/nodes/node[@name=$newNodeName]/@label"/>
						<xsl:variable name="id" select="$startId+position()-1"/>
						<!-Look for possible relationships here ->
						<xsl:value-of select="concat($newNodeType,':',$newNodeName,':',$id,',')"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="/ssm/kb/relationships/relationship[@type=$relationshipName and @b=$boundNodeName]">
						<xsl:variable name="newNodeName" select="@a"/>
						<xsl:variable name="newNodeType" select="/ssm/kb/nodes/node[@name=$newNodeName]/@type"/>
						<xsl:variable name="label" select="/ssm/kb/nodes/node[@name=$newNodeName]/@label"/>
						<xsl:variable name="id" select="$startId+position()-1"/>
						<!-Look for possible relationships here ->
						<xsl:value-of select="concat($newNodeType,':',$newNodeName,':',$id,',')"/>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!- Finding:FocalNeurologicalFinding:28, ->
		<xsl:call-template name="findRelationShips">
			<xsl:with-param name="nodeList" select="$nodeList"/>
		</xsl:call-template>
	</xsl:template>
	-->
	<xsl:template name="findRelationShips">
		<xsl:param name="nodeList"/>
		<xsl:variable name="thisNode" select="substring-before($nodeList,',')"/>
		<xsl:variable name="restOfNodes" select="substring-after($nodeList,',')"/>
		<!-- Finding:FocalNeurologicalFinding:28 -->
		<xsl:variable name="nodeName" select="substring-before(substring-after($thisNode,':'),':')"/>
		<xsl:variable name="nodeType" select="substring-before($thisNode,':')"/>
		<xsl:variable name="nodeId">
			<xsl:choose>
				<xsl:when test="count(/ssm/graph/nodes/node[@type=$nodeType and @name=$nodeName])=0">
					<xsl:value-of select="substring-after(substring-after($thisNode,':'),':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/ssm/graph/nodes/node[@type=$nodeType and @name=$nodeName]/@id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="/ssm/kb/relationships/relationship[@a=$nodeName or @b=$nodeName]">
			<xsl:variable name="relationshipType" select="@type"/>
			<xsl:variable name="unboundNode">
				<xsl:choose>
					<xsl:when test="@a=$nodeName">
						<xsl:value-of select="@b"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@a"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!--
			<debug a="unboundNode">
				<xsl:value-of select="$unboundNode"/>
			</debug>
-->
			<xsl:variable name="newNode">
				<xsl:choose>
					<xsl:when test="@a=$nodeName">
						<xsl:text>b</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>a</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<!--
			<debug a="newNode">
				<xsl:value-of select="$newNode"/>
			</debug>
			<debug a="nodeType">
				<xsl:value-of select="$nodeType"/>
			</debug>
			-->
			<!-- -does our unbound node exist in the ssm -->
			<!-- something wrong here  -->
			<xsl:for-each select="/ssm/graph/nodes/node[@type=$nodeType and @name=$unboundNode]">
				<xsl:choose>
					<xsl:when test="$newNode='a'">
						<xsl:variable name="aNodeName">
							<xsl:call-template name="getNameFromId">
								<xsl:with-param name="pId" select="$nodeId"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="bNodeName">
							<xsl:call-template name="getNameFromId">
								<xsl:with-param name="pId" select="@id"/>
							</xsl:call-template>
						</xsl:variable>
						<!--						<relationship type="{$relationshipType}" a="{$nodeId}" b="{@id}" aText="{$aNodeName}" bText="{$bNodeName}" id="{$nodeId}xx{@id}"/>  -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="aId" select="@id"/>
						<xsl:variable name="aNodeName" select="/ssm/graph/nodes/node[@id=$aId]/@name"/>
						<xsl:variable name="bNodeName" select="/ssm/graph/nodes/node[@id=$nodeId]/@name"/>
						<!--						<relationship type="{$relationshipType}" a="{@id}" b="{$nodeId}" aText="{$aNodeName}" bText="{$bNodeName}" id="{@id}x{$nodeId}"/> -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:for-each>
		<!-- Recursively go through the node list -->
		<xsl:if test="$restOfNodes!=''">
			<xsl:call-template name="findRelationShips">
				<xsl:with-param name="nodeList" select="$restOfNodes"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getNameFromId">
		<xsl:param name="pId"/>
		<xsl:value-of select="/ssm/graph/nodes/node[@id=$pId]/@name"/>
	</xsl:template>
</xsl:stylesheet>