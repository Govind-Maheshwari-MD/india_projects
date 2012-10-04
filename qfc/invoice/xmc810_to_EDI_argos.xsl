<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java" >
	<xsl:output method="text" indent="yes"/>
     
	<xsl:variable name="Separator">
		<xsl:text>+</xsl:text>
	</xsl:variable>

    <xsl:variable name="segSeparator">
        <xsl:text>'</xsl:text>
	</xsl:variable>

	<xsl:variable name="subElementSeparator">
        <xsl:text>:</xsl:text>
	</xsl:variable>

   
	<!-- ================================ / ================================ -->
	<xsl:template match="/">
		<xsl:apply-templates select="/message-document/envelope-header"/>
		<xsl:apply-templates select="/message-document/message-body"/>		
		<xsl:apply-templates select="/message-document/envelope-footer"/>
	</xsl:template>	

	<!-- ======================= header =========================== -->
	<xsl:template match="envelope-header">
		<xsl:call-template name="interchange-control-header"/>
		<xsl:call-template name="functional-group-header"/>
	</xsl:template>

    <!-- ======================= envelope-footer =========================== -->
	<xsl:template match="envelope-footer">
		<xsl:call-template name="functional-group-trailer"/>
		<xsl:call-template name="createTAXCON"/>
		<xsl:call-template name="interchange-control-trailer"/>
	</xsl:template>

	<!-- ========================functional-group-trailer ========================= -->
	<xsl:template name="functional-group-trailer">
		<xsl:text>UNT</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="2+count(/message-document/message-body/transaction/date-time-reference[date-qualifier='131'])+1+2+count(/message-document/message-body/transaction/header-entity-loop)+count(/message-document/message-body/transaction/baseline-item-data)+3+1+count(/message-document/message-body/transaction/baseline-item-data)+count(/message-document/message-body/transaction/reference-numbers[reference-number-qualifier!='VA'])"/> 
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/>
		<xsl:value-of select="$segSeparator"/>
		<xsl:text>
</xsl:text>
	</xsl:template>
<!-- ========================interchange-control-trailer ========================= -->
	<xsl:template name="interchange-control-trailer">
	
		<xsl:text>UNZ</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="1"/> 
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/>
		<xsl:value-of select="$segSeparator"/>
		<xsl:text>
</xsl:text>
	</xsl:template>


	<!-- ========================interchange-control-header ========================= -->
	<xsl:template name="interchange-control-header">
		<xsl:text>UNB</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>UNOA</xsl:text>
        <xsl:value-of select="$subElementSeparator"/>
        <xsl:text>2</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/envelope-header/interchange-control-header/interchange-sender-id)"/> 
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/envelope-header/interchange-control-header/interchange-receiver-id)"/> 
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-date"/> 
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-time"/> 
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/> 
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
        <xsl:text>1</xsl:text>
		<xsl:value-of select="$segSeparator"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

<!-- ========================functional-group-header========================= -->
	<xsl:template name="functional-group-header">
		<xsl:text>UNH</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/>
        <xsl:value-of select="$Separator"/>
		<xsl:text>INVOIC</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>2</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>901</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>UN</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>GBAS01</xsl:text>
		<xsl:value-of select="$segSeparator"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- ============================ message-body ================================ -->
   <xsl:template match="message-body">
		<xsl:call-template name="createBGM"/>
		<xsl:call-template name="createNAD_SU"/>
		<xsl:call-template name="createNAD_BY"/>
		<xsl:call-template name="createNAD_DP"/>
		<xsl:call-template name="createDTM"/>
		<xsl:call-template name="createCUX"/>
		<xsl:call-template name="createUNSD"/>
		<xsl:call-template name="createLIN"/>
		<xsl:apply-templates select="transaction/reference-numbers"/>
		<xsl:call-template name="createIMD"/>
		<xsl:call-template name="createTRI"/>
		<xsl:call-template name="createUNSS"/>
		<xsl:call-template name="createTMA"/>
		<xsl:call-template name="createTXS"/>
	</xsl:template>

   <!-- ============================ createTAXCON ================================ -->
   <xsl:template name="createTAXCON">
		<xsl:call-template name="createUNH_TAXCON"/>
        <xsl:call-template name="createBGM_TAXCON"/>         
		<xsl:call-template name="createNAD_TAXCON"/> 
		<xsl:call-template name="createRFF_TAXCON"/> 
		<xsl:call-template name="createNAD_BY_TAXCON"/> 
		<xsl:call-template name="createDCT_TAXCON"/> 
		<xsl:call-template name="createTXS_TAXCON"/> 
		<xsl:call-template name="createUNT_TAXCON"/> 
   </xsl:template>
	
		<!-- ============================ createUNH_TAXCON ================================ -->
	<xsl:template name="createUNH_TAXCON">

		<xsl:text>UNH</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/>
		<xsl:value-of select="$Separator"/>
		<xsl:text>TAXCON</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>1</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>901</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>AS</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:text>GBAS01</xsl:text>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- ============================ createBGM_TAXCON ================================ -->
	<xsl:template name="createBGM_TAXCON">

		<xsl:text>BGM</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>999</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:value-of select="/message-document/message-body/transaction/begin-invoice/invoice-number"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/begin-invoice/invoice-date)"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>
      

<!-- ============================ createNAD_TAXCON ================================ -->
	<xsl:template name="createNAD_TAXCON">
        <xsl:text>NAD</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>SU</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/identification-code[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/name[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$subElementSeparator" />
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/address-information-line1[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$subElementSeparator" />
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/city-name[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$subElementSeparator" />
		<xsl:value-of select="$subElementSeparator" />
        <xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/postal-code[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

 <!-- ============================ createRFF_TAXCON ================================ -->
	<xsl:template name="createRFF_TAXCON">

		<xsl:text>RFF</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>VA</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/reference-numbers/reference-number[../reference-number-qualifier='VA']"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

<!-- ============================ createNAD_BY_TAXCON ================================ -->
	<xsl:template name="createNAD_BY_TAXCON">
	<xsl:text>NAD</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>BY</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/name[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/address-information-line1[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/address-information-line2[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/city-name[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$Separator"/>		
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/postal-code[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
</xsl:template>

<!-- ============================ createDCT_TAXCON ================================ -->
	<xsl:template name="createDCT_TAXCON">
	<xsl:text>DCT</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>380</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:text>1</xsl:text>  <!--Assuming: Our Native will contain only one Invoice Message-->
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
</xsl:template>

   <!-- ============================ createTXS_TAXCON ================================ -->
	<xsl:template name="createTXS_TAXCON">
	<xsl:text>TXS</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>VAT</xsl:text>		
	    <xsl:value-of select="$Separator" />
	    <xsl:text>S</xsl:text>
	    <xsl:value-of select="$Separator" />
	    <xsl:value-of select="/message-document/message-body/transaction/tax-information/percent"/>
	    <xsl:value-of select="$Separator" />
	    <xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/amount-subject-to-terms-discount),'0.00')"/>
        <xsl:value-of select="$Separator" />
	    <xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/terms-discount-amount),'0.00')"/>			
	    <xsl:value-of select="$segSeparator" />
        <xsl:text>
</xsl:text>
   </xsl:template>

   <!-- ============================ createUNT_TAXCON ================================ -->
	<xsl:template name="createUNT_TAXCON">
	<xsl:text>UNT</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:value-of select="2+1+count(/message-document/message-body/transaction/reference-numbers[reference-number-qualifier='VA'])+count(/message-document/message-body/transaction/header-entity-loop[entity-identifier-code!='DP'])+1"/>
		<xsl:value-of select="$Separator"/>		
        <xsl:value-of select="/message-document/envelope-header/interchange-control-header/interchange-control-number"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
</xsl:template>

	<!-- ============================ reference-numbers ================================ -->
   <xsl:template match="reference-numbers">
		<xsl:call-template name="createRFF"/>
   </xsl:template>

	<!-- ============================ createBGM ================================ -->
	<xsl:template name="createBGM">

		<xsl:text>BGM</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>380</xsl:text>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/begin-invoice/invoice-number)"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/begin-invoice/invoice-date)"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

	
      <!-- ============================ createNAD_SU================================ -->
	<xsl:template name="createNAD_SU">

		<xsl:text>NAD</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>SU</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/identification-code[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/name[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$subElementSeparator" />
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/address-information-line1[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$subElementSeparator" />
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/city-name[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$subElementSeparator" />
		<xsl:value-of select="$subElementSeparator" />
        <xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/postal-code[../entity-identifier-code='SU'])"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

<!-- ============================ createNAD_BY ================================ -->
	<xsl:template name="createNAD_BY">

		<xsl:text>NAD</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>BY</xsl:text>
		<xsl:value-of select="$Separator"/>		
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/name[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/address-information-line1[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$subElementSeparator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/address-information-line2[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/city-name[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$Separator"/>		
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="normalize-space(/message-document/message-body/transaction/header-entity-loop/postal-code[../entity-identifier-code='BY'])"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

<!-- ============================ createNAD_DP================================ -->
	<xsl:template name="createNAD_DP">

		<xsl:text>NAD</xsl:text>
        <xsl:value-of select="$Separator"/>
		<xsl:text>DP</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="substring(/message-document/message-body/transaction/begin-invoice/purchase-order-number,1,2)"/>
		<xsl:value-of select="$segSeparator" />
		<xsl:text>
</xsl:text>
	</xsl:template>

<!-- ============================ createDTM ================================ -->
  <xsl:template name="createDTM">

    <xsl:text>DTM</xsl:text>
	<xsl:value-of select="$Separator"/>
	<xsl:value-of select="/message-document/message-body/transaction/date-time-reference/date-qualifier[../date-qualifier='131']"/>
  	<xsl:value-of select="$Separator"/>
	<xsl:value-of select="/message-document/message-body/transaction/date-time-reference/date[../date-qualifier='131']"/>
	<xsl:value-of select="$segSeparator"/>
	<xsl:text>&#xA;</xsl:text>
  </xsl:template>

	<!-- ============================ createCUX ================================ -->
  <xsl:template name="createCUX">

    <xsl:text>CUX</xsl:text>
	<xsl:value-of select="$Separator"/>
	<xsl:text>GBP</xsl:text>
  	<xsl:value-of select="$segSeparator"/>
	<xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <!-- ============================ createUNSD ================================ -->
  <xsl:template name="createUNSD">
    <xsl:text>UNS</xsl:text>
	<xsl:value-of select="$Separator"/>
	<xsl:text>D</xsl:text>
  	<xsl:value-of select="$segSeparator"/>
	<xsl:text>&#xA;</xsl:text>
  </xsl:template>
 <!-- ============================ createLIN ================================ -->

 <xsl:template name="createLIN">
    <xsl:text>LIN</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="/message-document/message-body/transaction/baseline-item-data/assigned-identification"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="normalize-space(/message-document/message-body/transaction/baseline-item-data/product-id[@qualifier='IN']/@id)"/>
	<xsl:value-of select="$subElementSeparator" />
    <xsl:text>IN</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="normalize-space(/message-document/message-body/transaction/baseline-item-data/product-id[@qualifier='VN']/@id)"/>
	<xsl:value-of select="$subElementSeparator" />
	<xsl:text>VN</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:text>47</xsl:text>
	<xsl:value-of select="$subElementSeparator" />
	<xsl:value-of select="format-number(number(normalize-space(/message-document/message-body/transaction/baseline-item-data/quantity-invoiced)),'0.00')"/>	
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(normalize-space(/message-document/message-body/transaction/baseline-item-data/unit-price)),'0.00')"/>
    <xsl:value-of select="$subElementSeparator" />
	<xsl:text>NT</xsl:text>
	<xsl:value-of select="$Separator"/>	
	<xsl:value-of select="$Separator"/>	
	<xsl:value-of select="format-number(number(normalize-space(/message-document/message-body/transaction/baseline-item-data/quantity-invoiced*/message-document/message-body/transaction/baseline-item-data/unit-price)),'0.00')"/>
	<xsl:value-of select="$segSeparator" />
	<xsl:text>&#xA;</xsl:text>
  </xsl:template>

 <!-- ============================ createRFF ================================ -->
   <xsl:template name="createRFF">
    <xsl:if test="reference-number-qualifier!='VA'">
	<xsl:text>RFF</xsl:text>
	<xsl:value-of select="$Separator"/>
	<xsl:value-of select="reference-number-qualifier"/>
	<xsl:value-of select="$Separator"/>
	<xsl:value-of select="normalize-space(reference-number)"/>
	<xsl:value-of select="$segSeparator"/>
	
	<xsl:text>&#xA;</xsl:text>
	</xsl:if>
  </xsl:template>

 
  <!-- ============================ createIMD ================================ -->
	<xsl:template name="createIMD">
        <xsl:text>IMD</xsl:text>
		<xsl:value-of select="$Separator"/>
        <xsl:value-of select="$Separator"/>
        <xsl:value-of select="$Separator"/>
        <xsl:value-of select="$Separator"/>
        <xsl:value-of select="normalize-space(/message-document/message-body/transaction/baseline-item-data/product-description/@description)"/> 
		<xsl:value-of select="$segSeparator"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- ============================ createTRI ================================ -->
	<xsl:template name="createTRI">
	    <xsl:text>TRI</xsl:text>
		<xsl:value-of select="$Separator"/>
        <xsl:text>VAT</xsl:text>
		<xsl:value-of select="$Separator"/>
        <xsl:text>S</xsl:text>
		<xsl:value-of select="$Separator"/>
        <xsl:value-of select="/message-document/message-body/transaction/tax-information/percent"/>
		<xsl:value-of select="$Separator"/>
        <xsl:value-of select="format-number(number(/message-document/message-body/transaction/tax-information/monetary-amount),'0.00')"/>
		<xsl:value-of select="$segSeparator"/>
		<xsl:text>
</xsl:text>
	</xsl:template>

 <!-- ============================ createUNSS ================================ -->
  <xsl:template name="createUNSS">

    <xsl:text>UNS</xsl:text>
	<xsl:value-of select="$Separator"/>
	<xsl:text>S</xsl:text>
  	<xsl:value-of select="$segSeparator"/>
	<xsl:text>&#xA;</xsl:text>
  </xsl:template>

<!-- ============================ createTMA ================================ -->

  <xsl:template name="createTMA">
    <xsl:text>TMA</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/total-invoice-amount),'0.00')"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/amount-subject-to-terms-discount),'0.00')"/>
    <xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/discounted-amount-due),'0.00')"/>
    <xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/discounted-amount-due),'0.00')"/>
    <xsl:value-of select="$Separator" />
    <xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/terms-discount-amount),'0.00')"/>			
	<xsl:value-of select="$segSeparator" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>

  <!-- ============================ createTXS ================================ -->

  <xsl:template name="createTXS">
    <xsl:text>TXS</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:text>VAT</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:text>S</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="/message-document/message-body/transaction/tax-information/percent"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/amount-subject-to-terms-discount),'0.00')"/>
    <xsl:value-of select="$Separator" />
	<xsl:value-of select="format-number(number(/message-document/message-body/transaction/total-monetary-value-summary/terms-discount-amount),'0.00')"/>			
	<xsl:value-of select="$segSeparator" />
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
</xsl:stylesheet>




<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="native_argos_810_new.xml" htmlbaseurl="storis\" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml&#x2D;apis.jar;d:\XSLExtensionsLIB\xml.jar;d:\XSLExtensionsLIB\xerces.jar;d:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
