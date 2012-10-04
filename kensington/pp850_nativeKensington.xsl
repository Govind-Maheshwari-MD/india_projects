<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmcStrings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java">
	<xsl:output method="xml" indent="yes"/>
		<xsl:variable name="elementSeparator">
		<xsl:text>*</xsl:text>
	</xsl:variable>
	<xsl:variable name="segSeparator">
		<xsl:text>~</xsl:text>
	</xsl:variable>

	<xsl:template match="/">
		<message-document>
			<xsl:variable name="isa-line-content" select="Document/Header/line[position()=1]"/>
			<xsl:variable name="gs-line-content" select="Document/Header/line[position()=2]"/>

			<xsl:variable name="first-po1-pos">
				<xsl:call-template name="get-first-position">
					<xsl:with-param name="looping-text" select="'PO1'"/>
					<xsl:with-param name="path" select="'Document/Message/Component/*'"/>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="first-n1-pos">
				<xsl:call-template name="get-first-position">
					<xsl:with-param name="looping-text" select="'N1'"/>
					<xsl:with-param name="path" select="'Document/Message/Component/*'"/>
				</xsl:call-template>
			</xsl:variable>
			<envelope-header>
				<interchange-control-header>
					<authorization-information-qualifier>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,1,$elementSeparator,$elementSeparator)"/>
					</authorization-information-qualifier>
					<authorization-information>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,2,$elementSeparator,$elementSeparator)"/>
					</authorization-information>
					<security-information-qualifier>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,3,$elementSeparator,$elementSeparator)"/>
					</security-information-qualifier>
					<security-information>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,4,$elementSeparator,$elementSeparator)"/>
					</security-information>
					<interchange-sender-id-qualifier>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,5,$elementSeparator,$elementSeparator)"/>
					</interchange-sender-id-qualifier>
					<interchange-sender-id>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,6,$elementSeparator,$elementSeparator)"/>
					</interchange-sender-id>
					<interchange-receiver-id-qualifier>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,7,$elementSeparator,$elementSeparator)"/>
					</interchange-receiver-id-qualifier>
					<interchange-receiver-id>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,8,$elementSeparator,$elementSeparator)"/>
					</interchange-receiver-id>
					<interchange-date>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,9,$elementSeparator,$elementSeparator)"/>
					</interchange-date>
					<interchange-time>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,10,$elementSeparator,$elementSeparator)"/>
					</interchange-time>
					<interchange-control-standards>U</interchange-control-standards>
					<interchange-control-version>00401</interchange-control-version>
					<interchange-control-number>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,13,$elementSeparator,$elementSeparator)"/>
					</interchange-control-number>
					<acknowledgement-requested>0</acknowledgement-requested>
					<usage-indicator>
						<xsl:value-of select="xmcStrings:delimited($isa-line-content,15,$elementSeparator,$elementSeparator)"/>
					</usage-indicator>
					<subelement-separator>&gt;</subelement-separator>
				</interchange-control-header>
				<functional-group-header>
					<functional-identifier-code>
						<xsl:value-of select="xmcStrings:delimited($gs-line-content,1,$elementSeparator,$elementSeparator)"/>
					</functional-identifier-code>
					<sender-id>
						<xsl:value-of select="xmcStrings:delimited($gs-line-content,2,$elementSeparator,$elementSeparator)"/>
					</sender-id>
					<receiver-id>
						<xsl:value-of select="xmcStrings:delimited($gs-line-content,3,$elementSeparator,$elementSeparator)"/>
					</receiver-id>
					<date>
						<xsl:value-of select="xmcStrings:delimited($gs-line-content,4,$elementSeparator,$elementSeparator)"/>
					</date>
					<time>
						<xsl:value-of select="xmcStrings:delimited($gs-line-content,5,$elementSeparator,$elementSeparator)"/>
					</time>
					<group-control-number>
						<xsl:value-of select="xmcStrings:delimited($gs-line-content,6,$elementSeparator,$elementSeparator)"/>
					</group-control-number>
					<responsible-agency-code>X</responsible-agency-code>
					<edi-version>004010</edi-version>
				</functional-group-header>
			</envelope-header>
			<message-body>
				<transaction>
					<xsl:apply-templates select="Document/Message/Component/line">
						<xsl:with-param name="first-po1-pos" select="$first-po1-pos"/>
						<xsl:with-param name="first-n1-pos" select="$first-n1-pos"/>
					</xsl:apply-templates>
					<xsl:call-template name="createCTT"/>
					<!--<xsl:call-template name="createAMT"/>-->
					<xsl:call-template name="createSE"/>
				</transaction>
			</message-body>
			<xsl:variable name="ge-line-content" select="Document/Footer/line[position()=1]"/>
			<xsl:variable name="iea-line-content" select="Document/Footer/line[position()=2]"/>
			<envelope-footer>
				<functional-group-trailer>
					<number-of-transaction-sets-included>
						<xsl:value-of select="xmcStrings:delimited($ge-line-content,1,$elementSeparator,$elementSeparator)"/>
					</number-of-transaction-sets-included>
					<group-control-number>
						<xsl:value-of select="xmcStrings:delimited($ge-line-content,2,$elementSeparator,$segSeparator)"/>
					</group-control-number>
				</functional-group-trailer>
				<interchange-control-trailer>
					<number-of-included-functional-groups>
						<xsl:value-of select="xmcStrings:delimited($iea-line-content,1,$elementSeparator,$elementSeparator)"/>
					</number-of-included-functional-groups>
					<interchange-control-number>
						<xsl:value-of select="xmcStrings:delimited($iea-line-content,2,$elementSeparator,$segSeparator)"/>
					</interchange-control-number>
				</interchange-control-trailer>
			</envelope-footer>
		</message-document>
	</xsl:template>

	<xsl:template match="line">
		<xsl:param name="first-po1-pos"/>
		<xsl:param name="first-n1-pos"/>
		<xsl:variable name="line-content" select="."/>
		<xsl:variable name="record-id" select="substring-before($line-content,$elementSeparator)"/>
		<xsl:if test="$record-id!=''">
			<xsl:choose>
				<xsl:when test="$record-id='ST'">
					<transaction-set-header>
						<transaction-set-id>
							<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
						</transaction-set-id>
						<transaction-set-control-nbr>
							<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$segSeparator)"/>
						</transaction-set-control-nbr>
					</transaction-set-header>
				</xsl:when>
				<xsl:when test="$record-id='BEG'">
					<begin-purchase-order>
						<transaction-set-purpose-code>
							<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
						</transaction-set-purpose-code>
						<purchase-order-type-code>
							<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
						</purchase-order-type-code>
						<purchase-order-number>
							<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
						</purchase-order-number>
						<release-number/>
						<purchase-order-date>
							<xsl:value-of select="xmcStrings:delimited($line-content,5,$elementSeparator,$segSeparator)"/>
						</purchase-order-date>
						<contract-number/>
					</begin-purchase-order>
				</xsl:when>

				<xsl:when test="$record-id='REF'">
					<xsl:variable name="current-pos">
						<xsl:number/>
					</xsl:variable>
					<xsl:if test="$current-pos &lt; $first-po1-pos">
						<reference-number>
							<reference-number-qualifier>
								<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
							</reference-number-qualifier>
							<reference-number>
							
							</reference-number>
							<description>
								<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$segSeparator)"/>
							</description>
						</reference-number>
					</xsl:if>
				</xsl:when>
                
			<xsl:when test="$record-id='DTM'">
				<date-time-reference>
					<date-time-qualifier>
						<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
					</date-time-qualifier>
					<date>
						<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$segSeparator)"/>
					</date>
				</date-time-reference>
		   </xsl:when>
               
			   <xsl:when test="$record-id='TD5'">
					<xsl:variable name="current-pos">
						<xsl:number/>
					</xsl:variable>
					<xsl:if test="$current-pos &lt; $first-po1-pos">
						<carrier-details>
							<routing-sequence-code/>
							<identification-code-qualifier>
							   <xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
							</identification-code-qualifier>
							<identification-code>
							   <xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
							</identification-code>
							<transportation-method-type-code/>
							<routing>
							   <xsl:value-of select="xmcStrings:delimited($line-content,5,$elementSeparator,$segSeparator)"/>
							</routing>
						</carrier-details>
					</xsl:if>
				</xsl:when>
				
				<xsl:when test="$record-id='ITD'">
					<terms-of-sale>
						<terms-type-code>
							<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
						</terms-type-code>
						<terms-basis-date-code>
						    <xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
						</terms-basis-date-code>
						<terms-discount-percent>
							<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
						</terms-discount-percent>
						<terms-discount-due-date/>
						<terms-discount-days>
							<xsl:value-of select="xmcStrings:delimited($line-content,5,$elementSeparator,$elementSeparator)"/>
						</terms-discount-days>
						<terms-net-due-date/>
						<terms-net-days>
							<xsl:value-of select="xmcStrings:delimited($line-content,6,$elementSeparator,$elementSeparator)"/>
						</terms-net-days>
					</terms-of-sale>
				</xsl:when>


				<xsl:when test="$record-id='N9'">
					<xsl:variable name="current-pos">
						<xsl:number/>
					</xsl:variable>
					<xsl:if test="$current-pos &lt; $first-po1-pos">
						<reference>
							<reference-number-qualifier>
								<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
							</reference-number-qualifier>
							<reference-number>
							    <xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$segSeparator)"/>
							</reference-number>
						</reference>
					</xsl:if>
				</xsl:when>

				<xsl:when test="$record-id='MSG'">
					<xsl:variable name="current-pos">
						<xsl:number/>
					</xsl:variable>
					<xsl:if test="$current-pos &lt; $first-po1-pos">
						<message-text>
							<free-form-message-text>
								<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
							</free-form-message-text>
						</message-text>
					</xsl:if>
				</xsl:when>


				<xsl:when test="$record-id='N1'">
					<header-entity-loop>
						<entity-identifier-code>
							<xsl:value-of select="translate(xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator),$segSeparator,'')"/>
						</entity-identifier-code>
						<name>
							<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
						</name>
						<identification-code-qualifier>
							<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
						</identification-code-qualifier>
						<identification-code>
							<xsl:value-of select="xmcStrings:delimited($line-content,4,$elementSeparator,$segSeparator)"/>
						</identification-code>

						<xsl:variable name="current-N1-pos">
							<xsl:number/>
						</xsl:variable>

						<xsl:variable name="next-N1-pos">
							<xsl:call-template name="get-next-position">
								<xsl:with-param name="looping-text" select="'N1'"/>
								<xsl:with-param name="terminating-text" select="'PO1'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:apply-templates select="following-sibling::line[position()&lt;($next-N1-pos) - ($current-N1-pos)]" mode="header-entity"/>
					</header-entity-loop>
				</xsl:when>


				<xsl:when test="$record-id='PO1'">
					<product>
						<assigned-identification>
							<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
						</assigned-identification>
						<quantity-ordered>
							<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
						</quantity-ordered>
						<unit-of-measure>
							<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
						</unit-of-measure>
						<unit-price>
							<xsl:value-of select="xmcStrings:delimited($line-content,4,$elementSeparator,$elementSeparator)"/>
						</unit-price>
						<basis-of-unit-price>
							<xsl:value-of select="xmcStrings:delimited($line-content,5,$elementSeparator,$elementSeparator)"/>
						</basis-of-unit-price>
						<xsl:call-template name="product-id-details">
							<xsl:with-param name="index" select="'6'"/>
						</xsl:call-template>
						<xsl:variable name="current-po1-pos">
							<xsl:number/>
						</xsl:variable>
						<xsl:variable name="next-po1-pos">
							<xsl:call-template name="get-next-position">
								<xsl:with-param name="looping-text" select="'PO1'"/>
								<xsl:with-param name="terminating-text" select="'CTT'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:apply-templates select="following-sibling::line[position()&lt;($next-po1-pos) - ($current-po1-pos)]" mode="line-items"/>
					</product>
				</xsl:when>
				<xsl:when test="$record-id='SAC'">
				<xsl:variable name="current-pos">
					<xsl:number/>
				</xsl:variable>

				<subline-item-detail>
					<allowance-charge-indicator>
						<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
					</allowance-charge-indicator>
					<relationship-code>
						<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
					</relationship-code>
					<agency-qualifier-code>
						<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
					</agency-qualifier-code>
					<basis-of-unit-price-code>
						<xsl:value-of select="xmcStrings:delimited($line-content,4,$elementSeparator,$elementSeparator)"/>
					</basis-of-unit-price-code>
					<description>
                        <xsl:value-of select="xmcStrings:delimited($line-content,15,$elementSeparator,$elementSeparator)"/>  
					</description>
				</subline-item-detail>
			</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="header-entity-loop-details">
		<xsl:param name="content" select="."/>
		<name>
			<xsl:value-of select="substring($content,23,40)"/>
		</name>
		<identification-code-qualifier/>
		<identification-code>
			<xsl:value-of select="substring($content,19,2)"/>
		</identification-code>
		<address-information-line1>
			<xsl:value-of select="substring($content,63,40)"/>
		</address-information-line1>
		<address-information-line2>
			<xsl:value-of select="substring($content,103,40)"/>
		</address-information-line2>
		<city-name>
			<xsl:value-of select="substring($content,143,20)"/>
		</city-name>
		<state-or-province-code>
			<xsl:value-of select="substring($content,21,2)"/>
		</state-or-province-code>
		<postal-code>
			<xsl:value-of select="substring($content,163,10)"/>
		</postal-code>
	</xsl:template>

	<xsl:template name="get-next-position">
		<xsl:param name="looping-text" select="."/>
		<xsl:param name="terminating-text" select="."/>
		<xsl:param name="terminating-text2" select="."/>

		<xsl:choose>
			<xsl:when test="count(following-sibling::line[substring-before(text(),$elementSeparator)=$looping-text])!=0">

				<xsl:for-each select="following-sibling::line[substring-before(text(),$elementSeparator)=$looping-text]">
					<xsl:if test="position()=1">
						<xsl:number/>
						<!-- get the document tree position for the first element following the context node-->
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="count(following-sibling::line[substring-before(text(),$elementSeparator)=$terminating-text])!=0">

				<xsl:for-each select="following-sibling::line[substring-before(text(),$elementSeparator)=$terminating-text]">
					<xsl:if test="position()=1">
						<xsl:number/>
						<!-- get the document tree position for the first element following the context node-->
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>

				<xsl:for-each select="following-sibling::line[substring-before(text(),$elementSeparator)=$terminating-text2]">
					<xsl:if test="position()=1">
						<xsl:number/>
						<!-- get the document tree position for the first element following the context node-->
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="get-first-position">
		<xsl:param name="looping-text" select="."/>
		<xsl:choose>
			<xsl:when test="count(descendant::Document/Message/Component/*[substring-before(text(),$elementSeparator)=$looping-text])!=0">
				<xsl:for-each select="descendant::Document/Message/Component/*[substring-before(text(),$elementSeparator)=$looping-text]">
					<xsl:if test="position()=1">
						<xsl:number/>
						<!-- get the document tree position for the first element following the context node -->
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="line" mode="header-entity">
		<xsl:variable name="segment-content" select="."/>
		<xsl:variable name="segment-id" select="substring-before($segment-content,$elementSeparator)"/>

		<xsl:choose>
			<xsl:when test="$segment-id='N2'">
				<name1>
					<xsl:value-of select="xmcStrings:delimited($segment-content,1,$elementSeparator,$elementSeparator)"/>
				</name1>
				<name2>
					<xsl:value-of select="xmcStrings:delimited($segment-content,2,$elementSeparator,$elementSeparator)"/>
				</name2>
			</xsl:when>
			<xsl:when test="$segment-id='N3'">
				<address-information-line1>
					<xsl:value-of select="xmcStrings:delimited($segment-content,1,$elementSeparator,$elementSeparator)"/>
				</address-information-line1>
				<address-information-line2>
					<xsl:value-of select="xmcStrings:delimited($segment-content,2,$elementSeparator,$elementSeparator)"/>
				</address-information-line2>
			</xsl:when>
			<xsl:when test="$segment-id='N4'">
				<city-name>
					<xsl:value-of select="xmcStrings:delimited($segment-content,1,$elementSeparator,$elementSeparator)"/>
				</city-name>
				<state-or-province-code>
					<xsl:value-of select="xmcStrings:delimited($segment-content,2,$elementSeparator,$elementSeparator)"/>
				</state-or-province-code>
				<postal-code>
					<xsl:value-of select="xmcStrings:delimited($segment-content,3,$elementSeparator,$elementSeparator)"/>
				</postal-code>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="product-id-details">

		<xsl:param name="index" select="."/>
		<xsl:variable name="line-content" select="text()"/>
		<xsl:variable name="id" select="normalize-space(xmcStrings:delimited($line-content,$index+1,$elementSeparator,$elementSeparator))"/>

		<xsl:if test="$id!=''">
			<product-id>
				<xsl:attribute name="qualifier">
					<xsl:choose>
						<xsl:when test="xmcStrings:delimited($line-content,$index,$elementSeparator,$elementSeparator) = 'VN'">
							<xsl:text>VC</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="xmcStrings:delimited($line-content,$index,$elementSeparator,$elementSeparator)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="translate($id,$segSeparator,'')"/>
				</xsl:attribute>
			</product-id>
		</xsl:if>
		<xsl:if test="$index &lt;'26'">
			<xsl:call-template name="product-id-details">
				<xsl:with-param name="index" select="$index+'2'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="line" mode="line-items">

		<xsl:variable name="line-content" select="."/>
		<xsl:variable name="record-id" select="substring-before($line-content,$elementSeparator)"/>

		<xsl:choose>

			

			<xsl:when test="$record-id='PID'">

				<product-description>
					<xsl:attribute name="item-description-type">
						<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
					</xsl:attribute>
					
					<xsl:attribute name="product-characteristic-code">
						<xsl:value-of select="xmcStrings:delimited($line-content,2,$elementSeparator,$elementSeparator)"/>
					</xsl:attribute>
                    <xsl:if test="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)!=''">
					<xsl:attribute name="agency-code">
						<xsl:value-of select="xmcStrings:delimited($line-content,3,$elementSeparator,$elementSeparator)"/>
					</xsl:attribute>
					</xsl:if>
					 <xsl:if test="xmcStrings:delimited($line-content,4,$elementSeparator,$elementSeparator)!=''">
                    <xsl:attribute name="product-description-code">
						<xsl:value-of select="xmcStrings:delimited($line-content,4,$elementSeparator,$elementSeparator)"/>
					</xsl:attribute>
					</xsl:if>
					 
					<xsl:attribute name="description">
						<xsl:value-of select="xmcStrings:delimited($line-content,5,$elementSeparator,$segSeparator)"/>
					</xsl:attribute>
				</product-description>
			</xsl:when>

			<xsl:when test="$record-id='MSG'">
				<message-segment>
					<free-form-message-text>
						<xsl:value-of select="xmcStrings:delimited($line-content,1,$elementSeparator,$elementSeparator)"/>
					</free-form-message-text>
				</message-segment>
			</xsl:when>
			
		</xsl:choose>
	</xsl:template>
	<xsl:template name="destination-quantity-details">

		<xsl:param name="index" select="."/>
		<xsl:variable name="line-content" select="text()"/>
		<xsl:variable name="id" select="normalize-space(xmcStrings:delimited($line-content,$index,$elementSeparator,$elementSeparator))"/>

		<xsl:if test="$id!=''">
			<identification-code>
				<xsl:value-of select="$id"/>
			</identification-code>
			<quantity>
				<xsl:value-of select="xmcStrings:delimited($line-content,$index+1,$elementSeparator,$elementSeparator)"/>
			</quantity>
		</xsl:if>
		<xsl:if test="$index &lt;'26'">
			<xsl:call-template name="destination-quantity-details">
				<xsl:with-param name="index" select="$index+'2'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="createCTT">
		<xsl:variable name="ctt-line" select="/Document/Message/Component/line[starts-with(text(),'CTT')]"/>
		<transaction-totals>
			<number-of-line-items>
				<xsl:value-of select="xmcStrings:delimited($ctt-line,1,$elementSeparator,$elementSeparator)"/>
			</number-of-line-items>
			<hash-total>
			    <xsl:value-of select="xmcStrings:delimited($ctt-line,2,$elementSeparator,$segSeparator)"/>
			</hash-total>
			
		</transaction-totals>
	</xsl:template>

    <xsl:template name="createAMT">
		<xsl:variable name="amt-line" select="/Document/Message/Component/line[starts-with(text(),'AMT')]"/>
		<monetary-amount>
			<amount-qualifier-code>
				<xsl:value-of select="xmcStrings:delimited($amt-line,1,$elementSeparator,$elementSeparator)"/>
			</amount-qualifier-code>
			<monetary-amount>
				<xsl:value-of select="xmcStrings:delimited($amt-line,2,$elementSeparator,$segSeparator)"/>
			</monetary-amount>
		</monetary-amount>
	</xsl:template>

	<xsl:template name="createSE">
		<xsl:variable name="se-line" select="/Document/Message/Component/line[starts-with(text(),'SE')]"/>
		<transaction-set-trailer>
			<number-of-included-segments>
				<xsl:value-of select="xmcStrings:delimited($se-line,1,$elementSeparator,$elementSeparator)"/>
			</number-of-included-segments>
			<transaction-set-control-nbr>
				<xsl:value-of select="xmcStrings:delimited($se-line,2,$elementSeparator,$segSeparator)"/>
			</transaction-set-control-nbr>
		</transaction-set-trailer>
	</xsl:template>
</xsl:stylesheet>






<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="kensington850pp.xml" htmlbaseurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml&#x2D;apis.jar;d:\XSLExtensionsLIB\xml.jar;d:\XSLExtensionsLIB\xerces.jar;d:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="Scenario1" userelativepaths="yes" url="..\preprocessed&#x2D;po.xml" htmlbaseurl="..\" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="..\" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="..\" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
