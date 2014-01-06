<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xsl:template match="/">
		<ssm>
			<xsl:copy-of select="ssm/meta"/>
			<graph mode="static" defaultedgetype="directed">
				<xsl:copy-of select="/ssm/graph/next_goal"/>
				<xsl:copy-of select="/ssm/graph/nodes"/>
				
				<relationships>
					<xsl:copy-of select="/ssm/graph/relationships"/>
					<testtag>ssss</testtag>
				</relationships>
			</graph>
			<xsl:copy-of select="/ssm/kb"/>
		</ssm>
	</xsl:template>
</xsl:stylesheet>