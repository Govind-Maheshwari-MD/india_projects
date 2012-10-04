<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:strings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java strings">

	<xsl:output method="xml" indent="yes"/>

	<xsl:variable name="Separator">
		<xsl:text>*</xsl:text>
	</xsl:variable>

    <xsl:variable name="segSeparator">
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
		<xsl:call-template name="createBIG"/>
		<xsl:apply-templates select="REF"/>
		<xsl:apply-templates select="header-entity-loop"/>
		<xsl:apply-templates select="ITD"/>
		<xsl:apply-templates select="DTM"/>
		<xsl:apply-templates select="item"/>
		<xsl:call-template name="createTDS"/>
		<xsl:call-template name="createCAD"/>
		<xsl:call-template name="createSAC"/>
		<xsl:apply-templates select="ISS"/>
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
	<xsl:template match="ITD">
		<xsl:call-template name="createITD"/>
	</xsl:template>

	<!-- ======================== DTM ========================== -->
	<xsl:template match="DTM">
		<xsl:call-template name="createDTM"/>
	</xsl:template>

	<!-- ======================== product ========================== -->
	<xsl:template match="item">
		<xsl:call-template name="createIT1"/>
       	<xsl:call-template name="createPID"/>
	</xsl:template>

	<!-- ======================== ISS ========================== -->
	<xsl:template match="ISS">
		<xsl:call-template name="createISS"/>
    </xsl:template>

	<!-- ============================ createISA ================================ -->
	<xsl:template name="createISA">
	<line>
		<xsl:text>ISA</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/authorization-information-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="strings:stringModify(/message-document/envelope-header/interchange-control-header/authorization-information/text(),'left','10',' ','true')"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/envelope-header/interchange-control-header/security-information-qualifier"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="strings:stringModify(/message-document/envelope-header/interchange-control-header/security-information/text(),'left','10',' ','true')"/>
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
		<xsl:value-of select="$segSeparator" />
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
		<xsl:value-of select="$segSeparator" />
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
		<xsl:value-of select="$segSeparator" />
	</line>
	</xsl:template>

	<!-- ============================ createBIG ================================ -->
	<xsl:template name="createBIG">
	<line>

		<xsl:text>BIG</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BIG/BIG01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BIG/BIG02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BIG/BIG03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BIG/BIG04"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BIG/BIG07"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/BIG/BIG08"/>
		<xsl:value-of select="$segSeparator" />
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
		<xsl:value-of select="$segSeparator" />
	</line>
	</xsl:template>



<!-- ============================ createN1 ================================ -->


  <xsl:template name="createN1">
	<line>

    <xsl:text>N1</xsl:text>
    <xsl:value-of select="$Separator" />
    <xsl:value-of select="N1/N101"/>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N1/N102"/>
	<xsl:if test="N1/N103!=''">
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N1/N103"/>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N1/N104"/>
	</xsl:if>
	<xsl:value-of select="$segSeparator" />
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
	<xsl:value-of select="$segSeparator" />
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
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="N4/N403"/>
	<xsl:value-of select="$segSeparator" />
	</line>
  </xsl:if>
  </xsl:template>

<!-- ============================ createITD ================================ -->

 <xsl:template name="createITD">

	<line>
    <xsl:text>ITD</xsl:text>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD01" />
	<xsl:value-of select="$Separator" />
	<!--<xsl:value-of select="ITD02" />-->
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD03" />
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD04" />
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD05" />
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD06" />
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD07" />
	<xsl:value-of select="$Separator" />
	<!--<xsl:value-of select="ITD08" />-->
	<xsl:value-of select="$Separator" />
	<!--<xsl:value-of select="ITD09" />-->
	<xsl:value-of select="$Separator" />
	<!--<xsl:value-of select="ITD10" />-->
	<xsl:value-of select="$Separator" />
	<!--<xsl:value-of select="ITD11" />-->
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="ITD12" />
    <xsl:value-of select="$segSeparator" />
	</line>
    
  </xsl:template>


<!-- ============================ createDTM ================================ -->

 <xsl:template name="createDTM">

	<line>
    <xsl:text>DTM</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="DTM01"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="DTM02"/>
	<xsl:value-of select="$segSeparator" />
	</line>
    
  </xsl:template>


<!-- ============================ createIT1 ================================ -->

 <xsl:template name="createIT1">

	<line>
    <xsl:text>IT1</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="IT1/IT101"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="IT1/IT102"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="IT1/IT103"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="IT1/IT104"/>
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="IT1/IT105"/>
	
	<xsl:for-each select="IT1/product-id">
	<xsl:if test="@qualifier!=''">
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="@qualifier" />
	<xsl:value-of select="$Separator"/>
	<xsl:value-of select="@id"/>
	</xsl:if>
	</xsl:for-each>
	<xsl:value-of select="$segSeparator" />
	</line>
  </xsl:template>

<!-- ============================= createPID =========================== -->
  <xsl:template name="createPID">
  <xsl:for-each select="PID" >
	<line>
    <xsl:text>PID</xsl:text>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="PID01"/>
    <xsl:value-of select="$Separator" />
	<xsl:value-of select="PID02"/>
	<xsl:value-of select="$Separator" />
    <xsl:value-of select="$Separator" />
	<xsl:value-of select="$Separator" />
	<xsl:value-of select="PID05"/>
	<xsl:value-of select="$segSeparator" />
	</line>
  </xsl:for-each>
 </xsl:template>
 
	<!-- ============================== createTDS ============================ -->
	<xsl:template name="createTDS">
	<line>
		<xsl:text>TDS</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TDS/TDS01"/>
		<xsl:if test="TDS/TDS04!=''">
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TDS/TDS02"/>		
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TDS/TDS03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="TDS/TDS04"/>		
		</xsl:if>
		<xsl:value-of select="$segSeparator" />
	</line>
	</xsl:template>


<!-- ============================== createCAD  ============================ -->
	
	<xsl:template name="createCAD">
	<xsl:if test="/message-document/message-body/transaction/CAD/CAD04!=''">
	<line>
		<xsl:text>CAD</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD03"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD04"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD05"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD06"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD07"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="CAD/CAD08"/>
		<xsl:value-of select="$segSeparator" />
	</line>
</xsl:if>
	</xsl:template>

<!-- ============================== createSAC  ============================ -->
	
	<xsl:template name="createSAC">
	<xsl:if test="/message-document/message-body/transaction/SAC/SAC01!=''">
	<line>
		<xsl:text>SAC</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SAC/SAC01"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SAC/SAC02"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SAC/SAC05"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SAC/SAC12"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/SAC/SAC15"/>
		<xsl:value-of select="$segSeparator" />
	</line>
</xsl:if>
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
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="ISS04"/>
		<xsl:value-of select="$segSeparator" />
	</line>
	</xsl:template>
	<!-- ============================== createCTT ============================ -->
	<xsl:template name="createCTT">
	<line>
		<xsl:text>CTT</xsl:text>
		<xsl:value-of select="$Separator"/>
		<xsl:value-of select="/message-document/message-body/transaction/CTT/CTT01"/>
		<xsl:value-of select="$segSeparator" />
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
		<xsl:value-of select="$segSeparator" />
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
		<xsl:value-of select="$segSeparator" />
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
		<xsl:value-of select="$segSeparator" />
	</line>
	</xsl:template>
</xsl:stylesheet>

