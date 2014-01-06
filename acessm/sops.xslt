<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xsl:template match="/">
		<!-- We may or may not have a focus node at this point -->
		<xsl:variable name="currentFocusNodeId" select="/ssm/graph/next_goal/relationship/@a"/>
		<!-- A list of all nodes who still have goals associated with them-->
		<xsl:variable name="nodeIdList">
			<xsl:apply-templates select="/ssm/graph/nodes/node" mode="RemoveSatisfiedNodes"/>
		</xsl:variable>
		<!--*** this is correct		<xsl:value-of select="$nodeIdList"></xsl:value-of>***  -->
		<!-- First get a focus node -->
		<!--		<xsl:value-of select="$nodeIdList"></xsl:value-of> -->
		<xsl:variable name="focusNodeId">
			<xsl:choose>
				<!-- If there is a focus node -->
				<xsl:when test="$currentFocusNodeId!=''">
					<xsl:choose>
						<!-- If the focus node is in the list, it remains the focus node -->
						<xsl:when test="contains(concat(',',$nodeIdList,','),concat(',',$currentFocusNodeId,','))">
							<xsl:value-of select="$currentFocusNodeId"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- If not, look for a connecected node with goals -->
							<!-- are any of the ids in nodeidlist the b to a relationship where focus node id is the a -->
							<xsl:variable name="connectedNodes">
								<xsl:for-each select="/ssm/graph/relationships/relationship[@a=$currentFocusNodeId and contains(concat(',',$nodeIdList,','),concat(',',@b,','))]">
									<xsl:value-of select="concat(@b,',')"/>
								</xsl:for-each>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$connectedNodes!=''">
									<xsl:value-of select="substring-before($connectedNodes,',')"/>
								</xsl:when>
								<!-- 
									We have exhausted all goals associated with this node, and its neighbours
									Now go back a step by grabbing all the relationships where the focus node is b
									Grab all the a's
								 -->
								<xsl:otherwise>
									<xsl:variable name="grandParents">
										<xsl:for-each select="/ssm/graph/relationships/relationship[@b=$currentFocusNodeId]">
											<!-- See if the a node is involved in any relationships with b nodes in the nodeIdList -->
											<xsl:variable name="a" select="@a"/>
											<xsl:for-each select="/ssm/graph/relationships/relationship[@a=$a]">
												<xsl:if test="contains(concat(',',$nodeIdList,','),concat(',',@b,','))"><xsl:value-of select="@b"/>,</xsl:if>
											</xsl:for-each>
										</xsl:for-each>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="$grandParents!=''">
											<xsl:call-template name="GlobalOps">
												<xsl:with-param name="nodeIdList" select="$grandParents"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="GlobalOps">
												<xsl:with-param name="nodeIdList" select="$nodeIdList"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!-- If no focus node then need to start from scratch using object and attribute centered principles -->
				<xsl:otherwise>
					<xsl:call-template name="GlobalOps">
						<xsl:with-param name="nodeIdList" select="$nodeIdList"/>
					</xsl:call-template>
					<!-- Pass the extant nodes to the strategy ops in the ssm to order them in a list  -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Now look at all the goals associated with the focus node type an pick the highest priority non satisfied one -->
		<xsl:variable name="nodeType" select="/ssm/graph/nodes/node[@id=$focusNodeId]/@type"/>
		<!-- Problem  here -->
		<xsl:variable name="goalList">
			<xsl:for-each select="/ssm/meta/goal_structure/relationships/relationship[@a=$nodeType]">
				<!-- Is our node already in a relationship such as this? -->
				<xsl:variable name="relationshipName" select="@type"/>
				<xsl:variable name="relationshipA" select="@a"/>
				<xsl:variable name="relationshipB" select="@b"/>
				<xsl:if test="count(/ssm/graph/relationships/relationship[@type=$relationshipName and @a=$focusNodeId])=0">
					<xsl:value-of select="concat(@type,',',$focusNodeId,',','?',@b,'|')"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="/ssm/meta/goal_structure/relationships/relationship[@b=$nodeType]">
				<!-- Is our node already in a relationship such as this? -->
				<xsl:variable name="relationshipName" select="@type"/>
				<xsl:variable name="relationshipA" select="@a"/>
				<xsl:variable name="relationshipB" select="@b"/>
				<xsl:if test="count(/ssm/graph/relationships/relationship[@type=$relationshipName and @b=$focusNodeId])=0">
					<xsl:value-of select="concat(@type,',','?',@a,',',$focusNodeId,'|')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!--		<xsl:value-of select="$goalList"/>  -->
		<xsl:variable name="goal" select="substring-before($goalList,'|')"/>
		<!--  causes,14,?Finding  -->
		<ssm>
			<debug_info>
				<xsl:value-of select="concat('focusNodeId=|',$focusNodeId,'|')"/>
			</debug_info>
			<debuginfo>
				<xsl:value-of select="$goalList"/>
			</debuginfo>
			<!--,
			<xsl:value-of select="concat('Node Id List: ',$nodeIdList,',')"></xsl:value-of>
			<xsl:value-of select="concat('goalList:',$goalList)"></xsl:value-of>. 
			<xsl:value-of select="concat('nodeType:',$nodeType)"></xsl:value-of>. 	
			<xsl:value-of select="concat('focusNode:',$focusNode)"></xsl:value-of>. 	
			
			<next_goal>
				<relationship type="causes" a="14" b="?Finding"/>
			</next_goal>
			-->
			<xsl:copy-of select="/ssm/meta"/>
			<graph mode="static" defaultedgetype="directed">
				<next_goal>
					<xsl:element name="relationship">
						<xsl:attribute name="type">
							<xsl:value-of select="substring-before($goal,',')"/>
						</xsl:attribute>
						<xsl:attribute name="a">
							<xsl:value-of select="substring-before(substring-after($goal,','),',')"/>
						</xsl:attribute>
						<xsl:attribute name="b">
							<xsl:value-of select="substring-after(substring-after($goal,','),',')"/>
						</xsl:attribute>
						<!--
							causes,14,?Finding
								Finding causes what?
							causes,?Finding,14							
								What causes Finding?							
							
						-->
						<xsl:element name="goalText">
							<xsl:variable name="goalText">
								<xsl:choose>
									<xsl:when test="substring(substring-before(substring-after($goal,','),','),1,1)='?'">
										<xsl:variable name="unboundNode" select="substring-before(substring-after($goal,','),',')"/>
										<xsl:value-of select="concat('What ',substring($unboundNode,2,string-length($unboundNode)),' ',substring-before($goal,','),' ',/ssm/graph/nodes/node[@id=substring-after(substring-after($goal,','),',')]/@name,'?')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="unboundNode" select="substring-after(substring-after($goal,','),',')"/>
										<xsl:value-of select="concat(/ssm/graph/nodes/node[@id=substring-before(substring-after($goal,','),',')]/@name,' ',substring-before($goal,','),' what ',substring($unboundNode,2,string-length($unboundNode)),'?')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$goalText"/>
						</xsl:element>
					</xsl:element>
				</next_goal>
				<xsl:apply-templates select="ssm/graph/nodes" mode="copy"/>
				<xsl:apply-templates select="ssm/graph/relationships"/>
			</graph>
			<xsl:copy-of select="/ssm/kb"/>
		</ssm>
	</xsl:template>
	<xsl:template name="GlobalOps">
		<!-- This list of all potential nodes -->
		<xsl:param name="nodeIdList"/>
		<!-- From this list pick an actual node to be the focus node-->
		<!-- This not being set to 5 when it should be -->
		<xsl:variable name="tFocusNode">
			<!-- The nodes types should be pursed in a particular order (source code order)
				Go through the node types in descending order of priority
				-->
			<xsl:for-each select="/ssm/meta/strategy_operators/object_centered_principles/node">
				<xsl:variable name="nodeType" select="@type"/>
				<!--Given a particular node type, we then look to attributes of that node to determine which of several instances
					of a particular node type to pursue first
				-->
				<xsl:for-each select="attribute_centered_principles/attribute">
					<!-- Get each attribute - if any - for that node type-->
					<xsl:variable name="attributeName" select="@name"/>
					<!--
						For every node instance that is in out node list of potential nodes,
						and whose type matches the type currently being considered,
						for each attribute of said node, if the node instance has that attribute
						put it in a list	
					-->
					<xsl:for-each select="/ssm/graph/nodes/node[contains(concat(',',$nodeIdList,','),concat(',',@id,',')) and @type=$nodeType]/attribute">
						<xsl:if test="@name=$attributeName">
							<xsl:value-of select="concat(../@id,',')"/>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
				<!--
						Now put nodes in the list without consideration of attributes	
					-->
				<xsl:for-each select="/ssm/graph/nodes/node[contains(concat(',',$nodeIdList),concat(',',@id,',')) and @type=$nodeType]">
					<xsl:value-of select="concat(@id,',')"/>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:variable>
		<!-- Our focus node is the first node in the list  -->
		<xsl:value-of select="substring-before($tFocusNode,',')"/>
	</xsl:template>
	<xsl:template match="ssm/graph/nodes/node" mode="RemoveSatisfiedNodes">
		<!-- Count of goals associated with that node -->
		<xsl:variable name="nodeId" select="@id"/>
		<xsl:variable name="nodeCount" select="count(/ssm/graph/nodes/goals/relationship[@a=$nodeId or @b=$nodeId])"/>
		<xsl:if test="$nodeCount!=0 and @type!='nill'">
			<xsl:value-of select="concat($nodeId,',')"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ssm/graph/nodes" mode="copy">
		<!-- First Copy the node -->
		<xsl:copy-of select="."/>
		<!-- Consult the goal structure in the meta to see what goals have been violated -->
		<!--
		<xsl:variable name="nodeID" select="@id"/>
		<xsl:variable name="nodeType" select="@type"/>
		<xsl:variable name="nodeName" select="@name"/>
		<goals>
			<xsl:for-each select="/ssm/meta/goal_structure/relationships/relationship[@a=$nodeType]">
				- Check to see if that relationship has been satisfied -
				<xsl:variable name="relationshipName" select="@type"/>
				<xsl:variable name="numberOfSatisfiedRelationShips" select="count(/ssm/graph/relationships/relationship[@a=$nodeID and @type=$relationshipName])"/>
				<xsl:if test="$numberOfSatisfiedRelationShips=0">
					<relationship name="{@type}" a="{$nodeID}" b="?{@b}" aType="{$nodeType}" bType="{@b}"/>
				</xsl:if>
			</xsl:for-each>
		</goals>
		-->
	</xsl:template>
	<xsl:template match="ssm/graph/relationships">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template name="return_first_child_node_of_current_node_in_list">
		<xsl:param name="currentFocusNodeId"/>
		<xsl:param name="nodeIdList"/>
		<xsl:variable name="firstIdInList" select="substring-before($nodeIdList,',')"/>
		<xsl:choose>
			<xsl:when test="count(/ssm/graph/relationships/relationship[@a=$currentFocusNodeId and @b=$firstIdInList])=0">
				<xsl:value-of select="$firstIdInList"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains($nodeIdList,',')=true">
						<xsl:call-template name="return_first_child_node_of_current_node_in_list">
							<xsl:with-param name="currentFocusNodeId" select="$currentFocusNodeId"/>
							<xsl:with-param name="nodeIdList" select="substring-after($nodeIdList,',')"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before($nodeIdList,',')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>