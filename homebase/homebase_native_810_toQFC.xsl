<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmcStrings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java">
<xsl:output method="text" indent="yes"/>

<xsl:variable name="elementSeparator">
 <xsl:text>+</xsl:text>
</xsl:variable>

<xsl:variable name="segmentSeparator">
 <xsl:text>'</xsl:text>
</xsl:variable>


<xsl:template match="/">
  <xsl:call-template name="createUNB"/> 	
  <xsl:call-template name="createUNH"/>
  <xsl:call-template name="createBGM"/>
  <xsl:call-template name="createDTM"/>
  <xsl:call-template name="createRFF"/>
  <xsl:call-template name="createRFF-DTM"/>
  <xsl:call-template name="createNAD-BY"/>
  <xsl:call-template name="createNAD-SU"/>
  <xsl:call-template name="createRFF-VA"/>  
  <xsl:call-template name="createRFF-IA"/>
  <xsl:call-template name="createNAD-DP"/>
  <xsl:call-template name="createCUX"/>
  <xsl:call-template name="createLIN"/>
  <xsl:call-template name="createUNS"/>
  <xsl:call-template name="createCNT"/>
  <xsl:call-template name="createMOA-amount-due"/>
  <xsl:call-template name="createMOA-total-line-items-amount"/>
  <xsl:call-template name="createMOA-tax-amount"/>
  <xsl:call-template name="createMOA-taxable-amount"/>
  <xsl:call-template name="createTAX"/>
  <xsl:call-template name="createTAX-MOA-tax"/>
  <xsl:call-template name="createTAX-MOA-taxable"/>
  <xsl:call-template name="createUNZ"/>
</xsl:template>

<xsl:template name="createUNB">
  <xsl:text>UNB</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>UNOA</xsl:text>
  <xsl:text>:</xsl:text>
  <xsl:text>3</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="message-document/envelope-header/interchange-control-header/interchange-date"/>
  <xsl:text>:</xsl:text>
  <xsl:value-of select="message-document/envelope-header/interchange-control-header/interchange-time"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="message-document/envelope-header/interchange-control-header/interchange-control-number"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>INVOIC</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createUNH">
  <xsl:text>UNH</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="message-document/message-body/transaction/begin-invoice/transaction-type"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>D</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>96A</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>UN</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>EAN008</xsl:text>
  <xsl:value-of select="$segmentSeparator"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createBGM">
  <xsl:text>BGM</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>380</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="message-document/message-body/transaction/begin-invoice/invoice-number"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>9</xsl:text> 
  <xsl:value-of select="$segmentSeparator"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createDTM">
  <xsl:text>DTM</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>137</xsl:text>
  <xsl:value-of select="':'"/>
  <xsl:value-of select="concat('20',message-document/message-body/transaction/begin-invoice/invoice-date)"/>
  <xsl:value-of select="':'"/>
  <xsl:text>102</xsl:text>
  <xsl:value-of select="$segmentSeparator"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createRFF">
  <xsl:text>RFF</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>ON</xsl:text>
  <xsl:value-of select="':'"/>
  <xsl:value-of select="message-document/message-body/transaction/begin-invoice/purchase-order-number"/>
  <xsl:value-of select="$segmentSeparator"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createRFF-DTM">
  <xsl:text>RFF</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>171</xsl:text>
  <xsl:value-of select="':'"/>
  <!--<xsl:value-of select="message-document/message-body/transaction"/>-->
  <xsl:value-of select="':'"/>
  <xsl:text>102</xsl:text>
  <xsl:value-of select="$segmentSeparator"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createNAD-BY">
	<xsl:text>NAD</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>BY</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/envelope-header/functional-group-header/receiver-id"/>
	<xsl:value-of select="':'"/>
	<xsl:text>9</xsl:text>
	<xsl:value-of select="':'"/>
	<xsl:value-of select="message-document/message-body/transaction/header-entity-loop/name[../entity-identifier-code='BY']"/>
	<xsl:value-of select="':'"/>
    <xsl:value-of select="message-document/message-body/transaction/header-entity-loop/address-information-line1[../entity-identifier-code='BY']"/>
	<xsl:value-of select="':'"/>
    <xsl:value-of select="message-document/message-body/transaction/header-entity-loop/address-information-line2[../entity-identifier-code='BY']"/>
	<xsl:value-of select="':'"/>
	<xsl:value-of select="message-document/message-body/transaction/header-entity-loop/city-name[../entity-identifier-code='BY']"/>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createNAD-SU">
	<xsl:text>NAD</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>SU</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/envelope-header/functional-group-header/sender-id"/>
	<xsl:value-of select="':'"/>
	<xsl:text>9</xsl:text>
	<xsl:value-of select="':'"/>
	<xsl:value-of select="message-document/message-body/transaction/header-entity-loop/name[../entity-identifier-code='SU']"/>
	<xsl:value-of select="':'"/>
    <xsl:value-of select="message-document/message-body/transaction/header-entity-loop/address-information-line1[../entity-identifier-code='SU']"/>
	<xsl:value-of select="':'"/>
    <xsl:value-of select="message-document/message-body/transaction/header-entity-loop/address-information-line2[../entity-identifier-code='SU']"/>
	<xsl:value-of select="':'"/>
	<xsl:value-of select="message-document/message-body/transaction/header-entity-loop/city-name[../entity-identifier-code='SU']"/>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createRFF-VA">
    <xsl:text>RFF</xsl:text> 
    <xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/message-body/transaction/reference-numbers/reference-number-qualifier[../reference-number-qualifier='VA']"/> 
	<xsl:text>:</xsl:text>
	<xsl:value-of select="message-document/message-body/transaction/reference-numbers/reference-number[../reference-number-qualifier='VA']"/>
	<xsl:text>'</xsl:text> 
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createRFF-IA">
    <xsl:text>RFF</xsl:text> 
    <xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="'IA'"/> 
	<xsl:text>:</xsl:text>
	<xsl:value-of select="message-document/message-body/transaction/reference-numbers/reference-number[../reference-number-qualifier='VA']"/>
	<xsl:text>'</xsl:text> 
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createNAD-DP">
	<xsl:text>NAD</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>DP</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<!--<xsl:value-of select=""/>-->
	<xsl:value-of select="':'"/>
	<xsl:text>9</xsl:text>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createCUX">
	<xsl:text>CUX</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>2</xsl:text>
	<xsl:value-of select="':'"/>
	<xsl:value-of select="message-document/message-body/transaction/currency/currency-code"/>
	<xsl:value-of select="':'"/>
	<xsl:text>4</xsl:text>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createLIN">
	<xsl:text>LIN</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>2</xsl:text>
	<xsl:value-of select="':'"/>
	<!--<xsl:value-of select=""/>-->
	<xsl:value-of select="':'"/>
	<xsl:text>4</xsl:text>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
	<xsl:call-template name="createPIA-IN"/>
	<xsl:call-template name="createPIA-SA"/>
	<xsl:call-template name="createIMD"/>
	<xsl:call-template name="createQTY"/>
	<xsl:call-template name="createLIN-MOA"/>
	<xsl:call-template name="createLIN-PRI"/>
	<xsl:call-template name="createLIN-TAX"/>
</xsl:template>


<xsl:template name="createPIA-IN">
    <xsl:text>PIA</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>1</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/message-body/transaction/baseline-item-data/product-id/@id[../@qualifier='IN']"/>
	<xsl:text>:</xsl:text>
	<xsl:value-of select="message-document/message-body/transaction/baseline-item-data/product-id/@qualifier[../@qualifier='IN']"/>	
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createPIA-SA">
    <xsl:text>PIA</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:text>5</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/message-body/transaction/baseline-item-data/product-id/@id[../@qualifier='VN']"/>
	<xsl:text>:</xsl:text>
	<xsl:text>SA</xsl:text>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createIMD">
    <xsl:text>IMD</xsl:text>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/message-body/transaction/baseline-item-data/product-description/@item-description-type"/>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="$elementSeparator"/>
	<xsl:value-of select="message-document/message-body/transaction/baseline-item-data/product-description/@description"/>
	<xsl:value-of select="$segmentSeparator"/>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createQTY">
   <xsl:text>QTY</xsl:text>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:text>47</xsl:text>
   <xsl:text>:</xsl:text>
   <xsl:value-of select="normalize(message-document/message-body/transaction/baseline-item-data/quantity-invoiced)"/>
   <xsl:value-of select="$segmentSeparator"/>
   <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createLIN-MOA">
   <xsl:text>MOA</xsl:text>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:text>66</xsl:text>
   <xsl:text>:</xsl:text>
   <xsl:variable name="quant" select="message-document/message-body/transaction/baseline-item-data/quantity-invoiced"/>
   <xsl:variable name="price" select="message-document/message-body/transaction/baseline-item-data/unit-price"/>
   <xsl:value-of select="$quant * $price"/>		
   <xsl:value-of select="$segmentSeparator"/>
   <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createLIN-PRI">
   <xsl:text>PRI</xsl:text>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:text>AAA</xsl:text>
   <xsl:text>:</xsl:text>
   <xsl:value-of select="normalize(/message-document/message-body/transaction/baseline-item-data/unit-price)"/>		
   <xsl:value-of select="$segmentSeparator"/>
   <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createLIN-TAX">
   <xsl:text>TAX</xsl:text>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:text>7</xsl:text>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:value-of select="normalize(message-document/message-body/transaction/tax-information/monetary-amount)"/>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:value-of select="message-document/message-body/transaction/tax-information/percent"/>
   <xsl:value-of select="$elementSeparator"/>
   <xsl:value-of select="message-document/message-body/transaction/tax-information/tax-type-code"/>
   <xsl:value-of select="$segmentSeparator"/>
   <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createUNS">
  <xsl:text>UNS</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>S</xsl:text>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createCNT">
  <xsl:text>CNT</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>2</xsl:text>
  <xsl:text>:</xsl:text> 			
  <xsl:value-of select="count(message-document/message-body/transaction/baseline-item-data)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createMOA-amount-due">
  <xsl:text>MOA</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>9</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="normalize(message-document/message-body/transaction/total-monetary-value-summary/discounted-amount-due)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createMOA-total-line-items-amount">
  <xsl:text>MOA</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>79</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="normalize(message-document/message-body/transaction/total-monetary-value-summary/total-invoice-amount)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createMOA-tax-amount">
  <xsl:text>MOA</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>124</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="normalize(message-document/message-body/transaction/total-monetary-value-summary/total-sales-tax)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createMOA-taxable-amount">
  <xsl:text>MOA</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>125</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="normalize(message-document/message-body/transaction/total-monetary-value-summary/total-invoice-amount)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createTAX">
  <xsl:text>TAX</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>7</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="message-document/message-body/transaction/tax-information/percent"/>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="message-document/message-body/transaction/tax-information/tax-type-code"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="createTAX-MOA-tax">
  <xsl:text>MOA</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>124</xsl:text> 
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="normalize(message-document/message-body/transaction/tax-information/monetary-amount)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createTAX-MOA-taxable">
  <xsl:text>MOA</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>125</xsl:text> 
  <xsl:value-of select="$elementSeparator"/>
  <xsl:value-of select="normalize(message-document/message-body/transaction/total-monetary-value-summary/total-invoice-amount)"/>
  <xsl:text>'</xsl:text>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="createUNZ">
  <xsl:text>UNZ</xsl:text>
  <xsl:value-of select="$elementSeparator"/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>


</xsl:stylesheet>

<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="native_810_homebase.xml" htmlbaseurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
