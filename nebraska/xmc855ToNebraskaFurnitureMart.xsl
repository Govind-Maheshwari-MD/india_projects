<?xml version="1.0"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0"
  xmlns:strings="xmc.xslt.extensions.StringExtension"
  xmlns:java="http://xml.apache.org/xslt/java"
  exclude-result-prefixes="java strings">

	<xsl:output method="text" indent="yes"/>
	<xsl:variable name="Separator">
		<xsl:text>*</xsl:text>
	</xsl:variable>
	<xsl:variable name="segmentTerminator">
		<xsl:text>~&#xA;</xsl:text>
	</xsl:variable>
	<!-- ================================ / ================================ -->
	<xsl:template match="/">
		<xsl:apply-templates select="message-document/envelope-header"/>
		<xsl:apply-templates select="message-document/message-body/transaction"/>
		<xsl:apply-templates select="message-document/envelope-footer"/>
	</xsl:template>
	<!-- ======================= header =========================== -->
	<xsl:template match="envelope-header">
		<xsl:apply-templates select="interchange-control-header"/>
		<xsl:apply-templates select="functional-group-header"/>
	</xsl:template>
	<!-- ======================= Footer =========================== -->
	<xsl:template match="envelope-footer">
		<xsl:apply-templates select="functional-group-trailer"/>
		<xsl:apply-templates select="interchange-control-trailer"/>
	</xsl:template>
	<!-- ======================= transaction =========================== -->
	<xsl:template match="transaction">
		<xsl:apply-templates select="transaction-set-header"/>
		<xsl:apply-templates select="begin-acknowledgement"/>
		<xsl:apply-templates select="date-and-time"/>
		<xsl:apply-templates select="header-entity-loop"/>
		<xsl:apply-templates select="product"/>

		<xsl:call-template name="createCTT"/>
		<xsl:call-template name="createSE"/>
	</xsl:template>
	<!-- ========================interchange-control-header ========================= -->
	<xsl:template match="interchange-control-header">
		<xsl:call-template name="createISA"/>
	</xsl:template>
	<!-- ========================transaction-set-header ========================= -->
	<xsl:template match="transaction-set-header">
		<xsl:call-template name="createST"/>
	</xsl:template>
	<!-- ========================functional-group-header ========================= -->
	<xsl:template match="functional-group-header">
		<xsl:call-template name="createGS"/>
	</xsl:template>
	<!-- ======================== begin-acknowledgment ========================= -->
	<xsl:template match="begin-acknowledgement">
		<xsl:call-template name="createBAK"/>
	</xsl:template>
	<!-- ======================== functional-group-trailer ========================= -->
	<xsl:template match="functional-group-trailer">
		<xsl:call-template name="createGE"/>
	</xsl:template>
	<!-- ======================== interchange-control-trailer ========================= -->
	<xsl:template match="interchange-control-trailer">
		<xsl:call-template name="createIEA"/>
	</xsl:template>
	<!-- ======================== date-and-time ========================= -->
	<xsl:template match="date-and-time">
		<xsl:call-template name="createDTM"/>
	</xsl:template>
	<!-- ======================== header-entity-loop ========================= -->
	<xsl:template match="header-entity-loop">
		<xsl:call-template name="createN1"/>
		<xsl:call-template name="createN3"/>
		<xsl:call-template name="createN4"/>
	</xsl:template>
	<!-- ======================== product ========================== -->
	<xsl:template match="product">
		<xsl:call-template name="createPO1"/>
		<xsl:call-template name="createPID"/>
		<xsl:call-template name="createACK"/>
	</xsl:template>
	<!-- ============================ createISA ================================ -->
	<xsl:template name="createISA">

		<xsl:text>ISA</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/authorization-information-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="strings:stringModify(/message-document/envelope-header/interchange-control-header/authorization-information,'right','10',' ','true')"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/security-information-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="strings:stringModify(/message-document/envelope-header/interchange-control-header/security-information,'right','10',' ','true')"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-sender-id-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="strings:stringModify(/message-document/envelope-header/interchange-control-header/interchange-sender-id,'right','15',' ','true')"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-receiver-id-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="strings:stringModify(/message-document/envelope-header/interchange-control-header/interchange-receiver-id,'right','15',' ','true')"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-date"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-time"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-standards"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-version"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/acknowledgement-requested"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/usage-indicator"/>
                <xsl:value-of select="$Separator"/>
                <xsl:value-of select="/message-document/envelope-header/interchange-control-header/subelement-separator"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createST ================================ -->
	<xsl:template name="createST">

		<xsl:text>ST</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/transaction-set-header/transaction-set-id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/transaction-set-header/transaction-set-control-nbr"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createGS ================================ -->
	<xsl:template name="createGS">

		<xsl:text>GS</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/functional-identifier-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/sender-id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/receiver-id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/date"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/time"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/group-control-number"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/responsible-agency-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/functional-group-header/edi-version"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createBAK ================================ -->
	<xsl:template name="createBAK">

		<xsl:text>BAK</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-acknowledgement/transaction-set-purpose-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-acknowledgement/acknowledgement-type"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-acknowledgement/purchase-order-number"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-acknowledgement/purchase-order-date"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-acknowledgement/reference-number"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-acknowledgement/acknowledgement-date"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createDTM ================================ -->

	<xsl:template name="createDTM">

		<xsl:text>DTM</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="date-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="date"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createN1 ================================ -->


	<xsl:template name="createN1">

		<xsl:text>N1</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="entity-identifier-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="name"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="identification-code-qualifier"/>
		<xsl:if test="identification-code!=''">
			<xsl:value-of select="$Separator"/>
			<xsl:value-of select="identification-code"/>
		</xsl:if>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createN3 ================================ -->


	<xsl:template name="createN3">

		<xsl:text>N3</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="address-information-line1"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="address-information-line2"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================ createN4 ================================ -->


	<xsl:template name="createN4">

		<xsl:text>N4</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="city-name"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="state-or-province-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="postal-code"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================= createPO1 =========================== -->
	<xsl:template name="createPO1">

		<xsl:text>PO1</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/product/assigned-identification"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/product/quantity-ordered"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="substring(unit-of-measurement-code,1,2)"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="format-number(number(unit-price),'0.00')"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/product/basis-of-unit-price-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:text>SK</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="product-id[@qualifier='SK']/@id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:text>VN</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="product-id[@qualifier='VN']/@id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:text>UP</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="product-id[@qualifier='UP']/@id"/>
		<xsl:value-of select="$Separator"/>
		<xsl:text>VC</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="product-id[@qualifier='VC']/@id"/>

		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================= createPID =========================== -->
	<xsl:template name="createPID">

		<xsl:text>PID</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="substring(product-description/@type,1,1)"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="product-description/@description"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================== createACK ============================ -->
	<xsl:template name="createACK">
		<xsl:text>ACK</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="following-sibling::line-item-acknowledgement/line-item-status-code"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="following-sibling::line-item-acknowledgement/date-time-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="following-sibling::line-item-acknowledgement/date"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="following-sibling::line-item-acknowledgement/request-reference-number"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================== createCTT ============================ -->
	<xsl:template name="createCTT">
		<xsl:text>CTT</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/transaction-totals/number-of-line-items"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================== createSE ============================ -->

	<xsl:template name="createSE">
		<xsl:variable name="segCount">
			<xsl:call-template name="countSegments"/>
		</xsl:variable>

		<xsl:text>SE</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$segCount"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/transaction-set-trailer/transaction-set-control-nbr"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================== createGE ============================ -->
	<xsl:template name="createGE">
		<xsl:text>GE</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="1"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-footer/functional-group-trailer/group-control-number"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>
	<!-- ============================== createIEA ============================ -->
	<xsl:template name="createIEA">
		<xsl:text>IEA</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="1"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-footer/interchange-control-trailer/interchange-control-number"/>
		<xsl:value-of select="$segmentTerminator"/>
	</xsl:template>

	<xsl:template name="countSegments">
		<xsl:variable name="STcount" select="count(/message-document/message-body/transaction/transaction-set-header)"/>
		<xsl:variable name="BAKcount" select="count(/message-document/message-body/transaction/begin-acknowledgement)"/>
		<xsl:variable name="DTMcount" select="count(/message-document/message-body/transaction/date-and-time)"/>
		<xsl:variable name="HELcount" select="count(/message-document/message-body/transaction/header-entity-loop)*3"/>
		<xsl:variable name="ProductCount" select="count(/message-document/message-body/transaction/product)"/>
		<xsl:variable name="PIDcount" select="count(/message-document/message-body/transaction/product/product-description)"/>
		<xsl:variable name="ACKcount" select="count(/message-document/message-body/transaction/line-item-acknowledgement)"/>
		<xsl:variable name="CTTcount" select="count(/message-document/message-body/transaction/transaction-totals)"/>
		<xsl:variable name="SEcount" select="count(/message-document/message-body/transaction/transaction-set-trailer)"/>
		<xsl:value-of select="$STcount+$BAKcount+$DTMcount+$HELcount+$ProductCount+$PIDcount+$ACKcount+$CTTcount+$SEcount"/>
	</xsl:template>
</xsl:stylesheet>

