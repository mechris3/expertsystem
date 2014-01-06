
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes"/>
	<xsl:template match="/">
		<xsl:value-of select="ssm/graph/next_goal/relationship/goalText"></xsl:value-of>
		</xsl:template>
</xsl:stylesheet>