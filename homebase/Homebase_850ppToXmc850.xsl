<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmcStrings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">

		<xsl:variable name="singlequote">
			<xsl:text>'</xsl:text>
		</xsl:variable>

		<message-document>
			<!-- ============================= envelope-header ================================= -->
			<envelope-header>
				<xsl:call-template name="create-interchange-control-header">
					<xsl:with-param name="unbline" select="/Document/Header/line[starts-with(text(),'UNB')]"/>
					<xsl:with-param name="unhline" select="/Document/Message/Component/line[starts-with(text(),'UNH')]"/>
				</xsl:call-template>
			</envelope-header>
			<!-- =============================== message-body ================================== -->
			<message-body>
				<transaction>
					<xsl:call-template name="create-po-header">
						<xsl:with-param name="nad_su_line" select="/Document/Message/Component/line[starts-with(text(),'NAD+SU')]"/>
						<xsl:with-param name="nad_by_line" select="/Document/Message/Component/line[starts-with(text(),'NAD+BY')]"/>
						<xsl:with-param name="nad_dp_line" select="/Document/Message/Component/line[starts-with(text(),'NAD+DP')]"/>
						<xsl:with-param name="bgmline" select="/Document/Message/Component/line[starts-with(text(),'BGM')]"/>
						<xsl:with-param name="rffline" select="/Document/Message/Component/line[starts-with(text(),'RFF')]"/>
						<xsl:with-param name="singlequote" select="$singlequote"/>
					</xsl:call-template>
					<xsl:for-each select="/Document/Message/Component/line[starts-with(text(),'LIN')]">
						<xsl:call-template name="create-product-line">
							<xsl:with-param name="singlequote" select="$singlequote"/>
						</xsl:call-template>
					</xsl:for-each>

					<transaction-totals>
						<xsl:variable name="CNT-line" select="/Document/Message/Component/line[starts-with(text(),'CNT+2')]"/>
						<number-of-line-items>
							<xsl:value-of select="xmcStrings:delimited($CNT-line,1,':',$singlequote)"/>
						</number-of-line-items>
						<hash-totals/>
					</transaction-totals>

					<xsl:variable name="untline" select="/Document/Message/Component/line[starts-with(text(),'UNT')]"/>
					<transaction-set-trailer>
						<number-of-included-segments>
							<xsl:value-of select="xmcStrings:delimited($untline,1,'+','+')"/>
						</number-of-included-segments>
						<transaction-set-control-nbr>
							<xsl:value-of select="xmcStrings:delimited($untline,2,'+',$singlequote)"/>
						</transaction-set-control-nbr>
					</transaction-set-trailer>
				</transaction>
			</message-body>
			<!-- ============================= envelope-footer ================================= -->
			<envelope-footer>
				<xsl:variable name="unzline" select="/Document/Footer/line[starts-with(text(),'UNZ')]"/>
				<xsl:variable name="uneline" select="/Document/Footer/line[starts-with(text(),'UNE')]"/>
				<functional-group-trailer>
					<number-of-transactions-sets>
					</number-of-transactions-sets>
					<group-control-number>
					</group-control-number>
				</functional-group-trailer>
				<interchange-control-trailer>
					<number-of-groups>
						<xsl:value-of select="xmcStrings:delimited($unzline,1,'+','+')"/>
					</number-of-groups>
					<interchange-control-number>
						<xsl:value-of select="xmcStrings:delimited($unzline,2,'+',$singlequote)"/>
					</interchange-control-number>
				</interchange-control-trailer>
			</envelope-footer>
		</message-document>
	</xsl:template>
	<!-- ====================== create-interchange-control-header =================== -->
	<xsl:template name="create-interchange-control-header">
		<xsl:param name="unbline"/>
		<xsl:param name="unhline"/>
		<xsl:param name="sellerline"/>
		<xsl:param name="headerline"/>
		<xsl:variable name="date-time" select="xmcStrings:delimited($unbline,4,'+','+')"/>
		<interchange-control-header>
			<authorization-information-qualifier>00</authorization-information-qualifier>
			<authorization-information>          </authorization-information>
			<security-information-qualifier>00</security-information-qualifier>
			<security-information>          </security-information>
			<interchange-sender-id-qualifier>
				<xsl:value-of select="substring-after(xmcStrings:delimited($unbline,2,'+','+'),':')"/>
			</interchange-sender-id-qualifier>
			<interchange-sender-id>
				<xsl:choose>
					<xsl:when test="substring-after(xmcStrings:delimited($unbline,2,'+','+'),':')!=''">
						<xsl:value-of select="xmcStrings:stringModify(substring-before(xmcStrings:delimited($unbline,2,'+','+'),':'),'right','15',' ','true')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="xmcStrings:stringModify(xmcStrings:delimited($unbline,2,'+','+'),'right','15',' ','true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</interchange-sender-id>
			<interchange-receiver-id-qualifier>
				<xsl:value-of select="substring-after(xmcStrings:delimited($unbline,3,'+','+'),':')"/>
			</interchange-receiver-id-qualifier>
			<interchange-receiver-id>
				<xsl:choose>
					<xsl:when test="substring-after(xmcStrings:delimited($unbline,3,'+','+'),':')!=''">
						<xsl:value-of select="xmcStrings:stringModify(substring-before(xmcStrings:delimited($unbline,3,'+','+'),':'),'right','15',' ','true')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="xmcStrings:stringModify(xmcStrings:delimited($unbline,3,'+','+'),'right','15',' ','true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</interchange-receiver-id>
			<interchange-date>
				<xsl:value-of select="substring-before(xmcStrings:delimited($unbline,4,'+','+'),':')"/>
			</interchange-date>
			<interchange-time>
				<xsl:value-of select="substring-after(xmcStrings:delimited($unbline,4,'+','+'),':')"/>
			</interchange-time>
			<interchange-control-standards>U</interchange-control-standards>
			<interchange-control-version>00400</interchange-control-version>
			<interchange-control-number>
				<xsl:value-of select="xmcStrings:delimited($unbline,5,'+','+')"/>
			</interchange-control-number>
			<acknowledgement-requested>0</acknowledgement-requested>
			<usage-indicator>T</usage-indicator>
		</interchange-control-header>

		<functional-group-header>
			<functional-identifier-code>PO</functional-identifier-code>
			<sender-id>
				<xsl:choose>
					<xsl:when test="substring-after(xmcStrings:delimited($unbline,2,'+','+'),':')!=''">
						<xsl:value-of select="xmcStrings:stringModify(substring-before(xmcStrings:delimited($unbline,2,'+','+'),':'),'right','15',' ','true')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="xmcStrings:stringModify(xmcStrings:delimited($unbline,2,'+','+'),'right','15',' ','true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</sender-id>
			<receiver-id>
				<xsl:choose>
					<xsl:when test="substring-after(xmcStrings:delimited($unbline,3,'+','+'),':')!=''">
						<xsl:value-of select="xmcStrings:stringModify(substring-before(xmcStrings:delimited($unbline,3,'+','+'),':'),'right','15',' ','true')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="xmcStrings:stringModify(xmcStrings:delimited($unbline,3,'+','+'),'right','15',' ','true')"/>
					</xsl:otherwise>
				</xsl:choose>
			</receiver-id>
			<date>
				<xsl:value-of select="substring-before($date-time,':')"/>
			</date>
			<time>
				<xsl:value-of select="substring-after($date-time,':')"/>
			</time>
			<group-control-number>
			</group-control-number>
			<responsible-agency-code>X</responsible-agency-code>
			<edi-version>004010</edi-version>
		</functional-group-header>
	</xsl:template>
	<!-- =============================== create-po-header  =============================== -->
	<xsl:template name="create-po-header">

		<xsl:param name="bgmline"/>
		<xsl:param name="nad_su_line"/>
		<xsl:param name="nad_by_line"/>
		<xsl:param name="nad_dp_line"/>
		<xsl:param name="rffline"/>
		<xsl:param name="singlequote"/>
		<!-- ==================== transaction-set-header ======================== -->
		<transaction-set-header>
			<transaction-set-id>850</transaction-set-id>
			<transaction-set-control-nbr/>
		</transaction-set-header>
		<!-- ==================== begin-purchase-order ========================= -->
		<begin-purchase-order>
			<transaction-set-purpose-code>00</transaction-set-purpose-code>
			<purchase-order-type-code>
				<xsl:value-of select="xmcStrings:delimited($bgmline,3,'+',$singlequote)"/>
			</purchase-order-type-code>
			<purchase-order-number>
				<xsl:value-of select="xmcStrings:delimited($bgmline,2,'+','+')"/>
			</purchase-order-number>
			<xsl:variable name="unh-line" select="Document/Message/Component/line[starts-with(text(),'UNH')]"/>
			<release-number>
				<xsl:value-of select="xmcStrings:delimited(xmcStrings:delimited($unh-line,2,'+','+'),2,':',':')"/>
			</release-number>
			<xsl:variable name="purchase-order-dt-line" select="/Document/Message/Component/line[starts-with(text(),'DTM+137')]"/>
			<purchase-order-date>
				<xsl:value-of select="xmcStrings:delimited($purchase-order-dt-line,1,':',':')"/>
			</purchase-order-date>
			<contract-number/>
		</begin-purchase-order>
		<!-- ==================== currency ========================= -->
		<xsl:variable name="curline" select="/Document/Message/Component/line[starts-with(text(),'CUX')]"/>
		<currency>
			<entity-identifier-code>
				<xsl:value-of select="xmcStrings:delimited($curline,1,'+',':')"/>
			</entity-identifier-code>
			<currency-code>
				<xsl:value-of select="xmcStrings:delimited($curline,1,':',':')"/>
			</currency-code>
		</currency>
		<!-- ==================== reference-numbers ========================= -->
		<xsl:for-each select="Document/Message/Component/line[starts-with(text(),'RFF')]">
			<reference-numbers>
				<reference-number-qualifier>
					<xsl:value-of select="xmcStrings:delimited(text(),1,'+',':')"/>
				</reference-number-qualifier>
				<reference-number>
					<xsl:value-of select="xmcStrings:delimited(text(),1,':',$singlequote)"/>
				</reference-number>
				<description/>
			</reference-numbers>
		</xsl:for-each>
		<!-- =========================== date-time-reference =============================== -->


		<xsl:for-each select="/Document/Message/Component/line[starts-with(text(),'DTM')]">
			<date-time-reference>
				<date-time-qualifier>
					<xsl:value-of select="xmcStrings:delimited(text(),1,'+',':')"/>
				</date-time-qualifier>
				<date>
					<xsl:value-of select="xmcStrings:delimited(text(),1,':',':')"/>
				</date>
			</date-time-reference>
		</xsl:for-each>


		<xsl:for-each select="/Document/Message/Component/line[starts-with(text(),'FTX')]">
			<xsl:call-template name="message-segment">
				<xsl:with-param name="singlequote" select="$singlequote"/>
			</xsl:call-template>
		</xsl:for-each>
		<!-- ========================= header-entity-loop ============================= -->
		<header-entity-loop>
			<entity-identifier-code>ST</entity-identifier-code>
			<name>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 3, '+', '+')"/>
			</name>
			<identification-code-qualifier>DP</identification-code-qualifier>
			<identification-code>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 2, '+', ':')"/>
			</identification-code>
			<address-information-line1>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 4, '+', '+')"/>
			</address-information-line1>
			<address-information-line2>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 5, '+', '+')"/>
			</address-information-line2>
			<city-name>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 6, '+', '+')"/>
			</city-name>
			<state-or-province-code>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 7, '+', '+')"/>
			</state-or-province-code>
			<postal-code>
				<xsl:value-of select="xmcStrings:delimited($nad_dp_line, 8, '+', '+')"/>
			</postal-code>
		</header-entity-loop>

		<xsl:variable name="ctaline" select="Document/Message/Component/line[starts-with(text(),'CTA')]"/>
		<!-- =================== administrative-communications-contact ===================== -->
		<xsl:for-each select="Document/Message/Component/line[starts-with(text(),'COM')]">
			<administrative-communications-contact>
				<contact-function-code>
					<xsl:value-of select="xmcStrings:delimited($ctaline,1,'+',$singlequote)"/>
				</contact-function-code>
				<name/>
				<communication-number-qualifier>
					<xsl:value-of select="xmcStrings:delimited(text(),1,':',$singlequote)"/>
				</communication-number-qualifier>
				<communication-number>
					<xsl:value-of select="xmcStrings:delimited(text(),1,'+',':')"/>
				</communication-number>
			</administrative-communications-contact>
		</xsl:for-each>
		<!-- ========================= header-entity-loop ============================= -->
		<header-entity-loop>
			<entity-identifier-code>SU</entity-identifier-code>
			<name>
			</name>
			<identification-code-qualifier/>
			<identification-code>
				<xsl:value-of select="xmcStrings:delimited($nad_su_line, 2, '+', ':')"/>
			</identification-code>
			<address-information-line1>
				<!--<xsl:value-of select="xmcStrings:delimited($nad_su_line, 1, ':', ':')"/>-->
			</address-information-line1>
			<address-information-line2/>
			<city-name>
				<!--<xsl:value-of select="xmcStrings:delimited($nad_su_line, 2, ':', ':')"/>-->
			</city-name>
			<state-or-province-code>
				<!--<xsl:value-of select="xmcStrings:delimited($nad_su_line, 3, ':', ':')"/>-->
			</state-or-province-code>
			<postal-code>
				<!--<xsl:value-of select="substring-before(xmcStrings:delimited($nad_su_line, 4, ':', ':'),$singlequote)"/>-->
			</postal-code>
		</header-entity-loop>
		<!-- ========================= header-entity-loop ============================= -->

		<header-entity-loop>
			<entity-identifier-code>BY</entity-identifier-code>
			<name>
			</name>
			<identification-code-qualifier/>
			<identification-code>
				<xsl:value-of select="xmcStrings:delimited($nad_by_line, 2, '+', ':')"/>
			</identification-code>
		</header-entity-loop>
	</xsl:template>
	<!-- =========================== message-segment =============================== -->
	<xsl:template name="message-segment">
		<xsl:param name="singlequote"/>
		<message-segment>
			<reference-identification>
				<xsl:value-of select="xmcStrings:delimited(text(),1,'+','+')"/>
			</reference-identification>
			<free-form-message-text>
				<xsl:value-of select="xmcStrings:delimited(text(),4,'+',$singlequote)"/>
			</free-form-message-text>
		</message-segment>
	</xsl:template>
	<!-- ========================= create-product-line ================================== -->
	<xsl:template name="create-product-line">
		<xsl:param name="singlequote"/>
		<product>
			<assigned-identification>
				<xsl:value-of select="xmcStrings:delimited(text(), 1, '+', '+')"/>
			</assigned-identification>
			<xsl:variable name="quantity" select="/Document/Message/Component/line[starts-with(text(),'QTY+21')]"/>
			<quantity-ordered>
				<xsl:value-of select="xmcStrings:delimited($quantity,1,':',$singlequote)"/>
			</quantity-ordered>
			<unit-of-measurement-code>EA</unit-of-measurement-code>
			<xsl:variable name="PRI-line" select="/Document/Message/Component/line[starts-with(text(),'PRI')]"/>
			<unit-price>
				<xsl:value-of select="xmcStrings:delimited($PRI-line, 1, ':', $singlequote)"/>
			</unit-price>
			<basis-of-unit-price-code>PE</basis-of-unit-price-code>
			<product-id>
				<xsl:attribute name="qualifier">
					<xsl:value-of select="xmcStrings:delimited(text(),1,':',$singlequote)"/>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="xmcStrings:delimited(text(), 3,'+',':')"/>
				</xsl:attribute>
			</product-id>

			<xsl:variable name="PIA-line" select="/Document/Message/Component/line[starts-with(text(),'PIA')]"/>
			<product-id>
				<xsl:attribute name="qualifier">
					<xsl:value-of select="xmcStrings:delimited($PIA-line, 1, ':', $singlequote)"/>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="xmcStrings:delimited($PIA-line, 2, '+', ':')"/>
				</xsl:attribute>
			</product-id>

			<xsl:variable name="imd_line" select="/Document/Message/Component/line[starts-with(text(),'IMD')]"/>
			<product-description>
				<xsl:attribute name="product-characteristic-code"/>
				<xsl:attribute name="item-description-type">
					<xsl:value-of select="xmcStrings:delimited($imd_line, 1, '+', '+')"/>
				</xsl:attribute>
				<xsl:attribute name="description">
					<xsl:value-of select="xmcStrings:delimited($imd_line, 3, ':', $singlequote)"/>
				</xsl:attribute>
			</product-description>
		</product>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario2" userelativepaths="yes" url="homebase850_pp1.xml" htmlbaseurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml&#x2D;apis.jar;d:\XSLExtensionsLIB\xml.jar;d:\XSLExtensionsLIB\xerces.jar;d:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="Scenario1" userelativepaths="yes" url="..\homebase\pp_HOMEBASE_850.xml" htmlbaseurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml&#x2D;apis.jar;d:\XSLExtensionsLIB\xml.jar;d:\XSLExtensionsLIB\xerces.jar;d:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
