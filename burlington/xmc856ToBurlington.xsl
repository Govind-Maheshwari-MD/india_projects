<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:strings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java strings">

	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="Separator">
		<xsl:text>*</xsl:text>
	</xsl:variable>

    <xsl:variable name="SEGSeparator">
		<xsl:text>&#xA;</xsl:text>
	</xsl:variable>
	<!-- ================================ / ================================ -->
	<xsl:template match="/">
		<Document>
	<sender-id> <xsl:value-of select="message-document/envelope-header/functional-group-header/sender-id"/> </sender-id>
	<receiver-id> <xsl:value-of select="message-document/envelope-header/functional-group-header/receiver-id"/> </receiver-id>
	<time> <xsl:value-of select="message-document/envelope-header/functional-group-header/time"/> </time>
	<group-control-number> <xsl:value-of select="message-document/envelope-header/functional-group-header/group-control-number"/> </group-control-number>
	<interchange-time> <xsl:value-of select="message-document/envelope-header/interchange-control-header/interchange-time"/> </interchange-time>
	<interchange-control-number> <xsl:value-of select="message-document/envelope-header/interchange-control-header/interchange-control-number"/> </interchange-control-number>
	<transaction-set-control-nbr> <xsl:value-of select="message-document/message-body/transaction/ST/ST02"/> </transaction-set-control-nbr>
	<number-of-transactions-sets> <xsl:value-of select="message-document/envelope-footer/functional-group-trailer/number-of-transactions-sets"/> </number-of-transactions-sets>
	<key-field/>
		<Header>
		<xsl:apply-templates select="message-document/envelope-header"/>
		</Header>
		<Message>
		<Component>
		<xsl:apply-templates select="message-document/message-body/transaction"/>
		</Component>
		</Message>
		<Footer>
		<xsl:apply-templates select="message-document/envelope-footer"/>
		</Footer>
		</Document>
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
		<xsl:call-template name="createST"/>
		<xsl:call-template name="createBSN"/>
		<xsl:apply-templates select="shipment-level-data"/>
	   	<xsl:call-template name="createCTT"/>
		<xsl:call-template name="createSE"/>
	</xsl:template>
    
	<!-- ========================interchange-control-header ========================= -->
	<xsl:template match="interchange-control-header">
		<xsl:call-template name="createISA"/>
	</xsl:template>

	<!-- ========================functional-group-header ========================= -->
	<xsl:template match="functional-group-header">
		<xsl:call-template name="createGS"/>
	</xsl:template>

	
    <!-- ======================== REF ========================= -->
	<xsl:template match="REF">
		<xsl:call-template name="createREF"/>
	</xsl:template>

	<!-- ======================== functional-group-trailer ========================= -->
	<xsl:template match="functional-group-trailer">
		<xsl:call-template name="createGE"/>
	</xsl:template>

	<!-- ======================== interchange-control-trailer ========================= -->
	<xsl:template match="interchange-control-trailer">
		<xsl:call-template name="createIEA"/>
	</xsl:template>

	<!-- ======================== header-entity-loop ========================== -->
	<xsl:template match="header-entity-loop">
		<xsl:call-template name="createN1"/>
		<xsl:call-template name="createN3"/>
		<xsl:call-template name="createN4"/>
    </xsl:template>

	<!-- ======================== DTM ========================== -->
	<xsl:template match="DTM">
		<xsl:call-template name="createDTM"/>
	</xsl:template>

	<xsl:template match="shipment-level-data">
	  <xsl:call-template name="createHL"/>
	  <xsl:apply-templates select="TD1"/>
	  <xsl:apply-templates select="TD5"/>
	  <xsl:apply-templates select="TD3"/>
	  <xsl:apply-templates select="REF"/>
	  <xsl:call-template name="createPER"/>
	  <xsl:apply-templates select="DTM"/>
	  <xsl:apply-templates select="header-entity-loop" />
	  <xsl:apply-templates select="order-level-data"/>
	</xsl:template> 

  <!-- ============================ item-level-data ================================ -->
  <xsl:template match="item-level-data">
      <xsl:call-template name="createHL"/>
      <xsl:call-template name="createLIN"/>
	  <xsl:call-template name="createSN1"/>
	  <xsl:call-template name="createPO4"/>
	  <!-- <xsl:if test="/message-document/message-body/transaction/BSN/BSN05='0002'"> --> <!-- Commented Out by Ashish 06/18/04 -->
    <xsl:variable name="parentId" select="HL/HL01" />
	  <xsl:apply-templates select="/message-document/message-body/transaction/shipment-level-data/pack-level-data">
      <xsl:with-param name="parentId" select="$parentId" />
    </xsl:apply-templates >
	<!-- </xsl:if> -->
  </xsl:template>
	<!-- ============================ order-level-data ================================ -->
   <xsl:template match="order-level-data">
    <xsl:call-template name="createHL"/>
    <xsl:call-template name="createPRF"/>
	<xsl:apply-templates select="TD1"/>
	<xsl:apply-templates select="TD5"/>

	<xsl:apply-templates select="REF"/>
	<xsl:apply-templates select="header-entity-loop"/>
	<!--<xsl:if test="../../BSN/BSN05='0002'"> -->  <!--Commented by Ankit Jun/18/04-->
	<xsl:apply-templates select="item-level-data"/>
	<!--</xsl:if>-->  <!--Commented by Ankit Jun/18/04-->
    <!--<xsl:if test="../../BSN/BSN05='0001'">--> <!--Commented by Ankit Jun/18/04-->
	<xsl:apply-templates select="pack-level-data"/>
	<!--</xsl:if>--> <!--Commented by Ankit Jun/18/04-->
   </xsl:template>
   	<!-- ============================ pack-level-data ================================ -->
   <xsl:template match="pack-level-data">
    <xsl:param name="parentId" />

    <xsl:if test="HL/HL02=$parentId">
    <xsl:call-template name="createHL"/>
	<xsl:for-each select="PKG">
    <xsl:call-template name="createPKG"/>	
	</xsl:for-each>
	<xsl:for-each select="MAN">
    <xsl:call-template name="createMAN"/>	
	</xsl:for-each>
	<xsl:if test="/message-document/message-body/transaction/BSN/BSN05='0001'">
	  <xsl:apply-templates select="item-level-data"/>
	</xsl:if>
    </xsl:if>
   </xsl:template>
	<!-- ============================ createISA ================================ -->
	<xsl:template name="createISA">

	<line>
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
		<xsl:text>&gt;</xsl:text>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================ createGS ================================ -->
	<xsl:template name="createGS">

	<line>
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
		<xsl:value-of select="'VI'"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="'004010VICS'"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================ createST ================================ -->
	<xsl:template name="createST">

	<line>
		<xsl:text>ST</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/ST/ST01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/ST/ST02"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================ createBSN ================================ -->
	<xsl:template name="createBSN">

	<line>
		<xsl:text>BSN</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BSN/BSN01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BSN/BSN02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BSN/BSN03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BSN/BSN04"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BSN/BSN05"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>


	<!-- ============================ createHL ================================ -->
	<xsl:template name="createHL">

	<line>
		<xsl:text>HL</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="HL/HL01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="HL/HL02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="HL/HL03"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

    <!-- ============================ createPO4 ================================ -->
	<xsl:template name="createPO4">
    <xsl:if test="PO4/PO401!=''"> 
	<line>
		<xsl:text>PO4</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PO4/PO401"/>
		<xsl:if test="PO4/PO414!=''">
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PO4/PO414"/>
		</xsl:if>
		<xsl:value-of select="$SEGSeparator" />
	</line>
</xsl:if>
	</xsl:template>

<!-- ============================ TD1 ================================ -->
	<xsl:template match="TD1">

	<line>
		<xsl:text>TD1</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD101"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD102"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD103"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD104"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD105"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD106"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD107"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD108"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

<!-- ============================ TD5 ================================ -->
	<xsl:template match="TD5">
    <xsl:if test="TD502!=''">
	<line>
		<xsl:text>TD5</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD501"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD502"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD503"/>
        <xsl:if test="TD504!=''"> 
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD504"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD505"/>
		</xsl:if>
	    <xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:if>
	</xsl:template>

<!-- ============================ TD3 ================================ -->
	<xsl:template match="TD3">

	<line>
		<xsl:text>TD3</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD301"/>
		<xsl:value-of select="$Separator"/>		
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TD303"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

   <!-- ============================ createREF ================================ -->
	<xsl:template name="createREF">
	<line>
		<xsl:text>REF</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="REF01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="REF02"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>


   <!-- ============================ createPER ================================ -->
	<xsl:template name="createPER">
	<xsl:if test="PER/PER01!=''">
	<line>
		<xsl:text>PER</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PER/PER01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PER/PER02"/>
		<xsl:if test="PER/PER03!=''">
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PER/PER03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PER/PER04"/>
		</xsl:if>
		<xsl:value-of select="$SEGSeparator" />
	</line>
    </xsl:if>
	</xsl:template>


<!-- ============================ createDTM ================================ -->

 <xsl:template name="createDTM">
	<line>
    <xsl:text>DTM</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="DTM01"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="DTM02"/>
	<xsl:value-of select="$SEGSeparator" />
	</line>
  </xsl:template>


<!-- ============================ createFOB ================================ -->
 <xsl:template name="createFOB">
	<line>
    <xsl:text>FOB</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="/message-document/message-body/transaction/shipment-level-data/FOB/FOB01"/>
	<xsl:value-of select="$SEGSeparator" />
	</line>
 </xsl:template>


<!-- ============================ createN1 ================================ -->
   <xsl:template name="createN1" >
	<line>
    <xsl:text>N1</xsl:text>
    <xsl:value-of select="$Separator" />
    <xsl:value-of select="N1/N101"/>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N1/N102"/>
	<xsl:if test="N1/N101!='SF'" >
	<xsl:value-of select="$Separator" />
	</xsl:if>
    <xsl:value-of select="N1/N103"/>
	<xsl:if test="N1/N101!='SF'" >
	<xsl:value-of select="$Separator" />
	</xsl:if>
    <xsl:value-of select="N1/N104"/>
	<xsl:value-of select="$SEGSeparator" />
	</line>

  </xsl:template>

<!-- ============================ createN2 ================================ -->
  <xsl:template name="createN2">
	<line>
    <xsl:text>N2</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N2/N201"/>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N2/N202"/>
	<xsl:value-of select="$SEGSeparator" />
	</line>
  </xsl:template>

<!-- ============================ createN3 ================================ -->

  <xsl:template name="createN3">
  <xsl:if test="N3/N301!=''">
	<line>
    <xsl:text>N3</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N3/N301"/>
	<xsl:if test="N3/N302!=''">
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N3/N302"/>
	</xsl:if>
	<xsl:value-of select="$SEGSeparator" />
	</line>
  </xsl:if>
  </xsl:template>

  <!-- ============================ createN4 ================================ -->

  <xsl:template name="createN4">
  <xsl:if test="N4/N401!=''">
	<line>
    <xsl:text>N4</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N4/N401"/>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N4/N402"/>
	<xsl:if test="N4/N403!=''">
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N4/N403"/>
	</xsl:if>
	<xsl:value-of select="$SEGSeparator" />
	</line>
  </xsl:if>
  </xsl:template>

	<!-- ============================== createPRF ============================ -->
	<xsl:template name="createPRF">
	<line>
		<xsl:text>PRF</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PRF/PRF01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PRF/PRF02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PRF/PRF03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PRF/PRF04"/>		
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>
   
<!-- ============================== createLIN  ============================ -->
	
	<xsl:template name="createLIN">
	<line>
		<xsl:text>LIN</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="LIN/LIN01"/>
        <xsl:for-each select="LIN/product-id">  
		<xsl:if test="@qualifier!=''">
    	 <xsl:value-of select="$Separator"/>
		 <xsl:value-of select="@qualifier"/>
		 <xsl:value-of select="$Separator"/>
		 <xsl:value-of select="@id"/>
        </xsl:if> 
		</xsl:for-each>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

<!-- ============================== createSN1  ============================ -->
	
	<xsl:template name="createSN1">
	<line>
		<xsl:text>SN1</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="SN1/SN101"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="SN1/SN102"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="SN1/SN103"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

<!-- ============================== createPKG  ============================ -->
	
	<xsl:template name="createPKG">
	<line>
		<xsl:text>PKG</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PKG03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="PKG04"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

<!-- ============================== createMAN  ============================ -->
	
	<xsl:template name="createMAN">
	<line>
		<xsl:text>MAN</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="MAN01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="MAN02"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

<!-- ============================== createISS  ============================ -->
	<xsl:template name="createISS">
	<line>
		<xsl:text>ISS</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="ISS01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="ISS02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="ISS03"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================== createCTT ============================ -->
	<xsl:template name="createCTT">
	<line>
		<xsl:text>CTT</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/CTT/CTT01"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================== createSE ============================ -->

	<xsl:template name="createSE">
	<line>
		<xsl:text>SE</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SE/SE01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SE/SE02"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================== createGE ============================ -->
	<xsl:template name="createGE">
	<line>
		<xsl:text>GE</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-footer/functional-group-trailer/number-of-transactions-sets"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-footer/functional-group-trailer/group-control-number"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>

	<!-- ============================== createIEA ============================ -->
	<xsl:template name="createIEA">
	<line>
		<xsl:text>IEA</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-footer/interchange-control-trailer/number-of-groups"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-footer/interchange-control-trailer/interchange-control-number"/>
		<xsl:value-of select="$SEGSeparator" />
	</line>
	</xsl:template>
</xsl:stylesheet>






<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="native856_1.xml" htmlbaseurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml&#x2D;apis.jar;d:\XSLExtensionsLIB\xml.jar;d:\XSLExtensionsLIB\xerces.jar;d:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
