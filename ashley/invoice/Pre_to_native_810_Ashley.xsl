<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xmcStrings="xmc.xslt.extensions.StringExtension" 
  xmlns:java="http://xml.apache.org/xslt/java" 
  xmlns:fnBase="http://support.furnishnet.com/xml/schemas/fnBase_v1.5" 
  xmlns:fnItem="http://support.furnishnet.com/xml/schemas/fnItem_v1.5" 
  xmlns:fnParty="http://support.furnishnet.com/xml/schemas/fnParty_v1.4">

  <xsl:output method="xml" indent="yes" />
    <xsl:template match="/">
    <message-document>
      <!-- ============================= envelope-header ================================= -->
      <envelope-header>
        <xsl:call-template name="create-interchange-control-header" />
      </envelope-header>

      <!-- =============================== message-body ================================== -->
      <message-body>
        <transaction>
          <xsl:call-template name="create-po-header" />
		  
   		  <total-monetary-value-summary>
		    <total-invoice-amount>
               <xsl:value-of select="//invoiceSummaryFinancial/totalNetInvoicedAmount"/> 
			</total-invoice-amount>
            <amount-subject-to-terms-discount>
			   <xsl:value-of select="//invoiceSummaryFinancial/totalFreightDueAmount"/> 
			</amount-subject-to-terms-discount>
            <discounted-amount-due>
			    <xsl:value-of select="//invoiceSummaryFinancial/totalLinesDueAmount"/> 
			</discounted-amount-due>
            <terms-discount-amount>
			   <xsl:value-of select="//invoiceSummaryFinancial/totalAllowanceAmount"/> 
			</terms-discount-amount>
 		  </total-monetary-value-summary>

		  <tax-information>
		    <tax-type-code>S</tax-type-code>
            <monetary-amount>		        
			  <xsl:value-of select="//invoiceSummaryFinancial/totalTaxDueAmount"/> 
			</monetary-amount>
		  </tax-information>
          <invoice-shipment-summary>
		    <number-of-units-shipped>			  
			</number-of-units-shipped>
            <unit-of-measurement-code></unit-of-measurement-code>
            <weight>
			  
			</weight>
            <volume>
			  
			</volume>
		  </invoice-shipment-summary>

          <CTT>
            <CTT01>
               <xsl:value-of select="count(//invoiceLine)"/>              
            </CTT01>
			<CTT02/>             			
          </CTT>

          <transaction-set-trailer>
            <number-of-included-segments/>
			<transaction-set-control-nbr/>
          </transaction-set-trailer>
        </transaction>
      </message-body>

      <!-- ============================= envelope-footer ================================= -->
	  <envelope-footer>
        <functional-group-trailer>
          <number-of-transactions-sets/>
          <group-control-number/>
        </functional-group-trailer>
        <interchange-control-trailer>
          <number-of-groups/>
          <interchange-control-number/>
        </interchange-control-trailer>
      </envelope-footer>
   </message-document>

  </xsl:template>

  <!-- ====================== create-interchange-control-header =================== -->
  <xsl:template name="create-interchange-control-header">
    
    <interchange-control-header>
      <authorization-information-qualifier>00</authorization-information-qualifier>
      <authorization-information>          </authorization-information>
      <security-information-qualifier>00</security-information-qualifier>
      <security-information>          </security-information>
      <interchange-sender-id-qualifier>ZZ</interchange-sender-id-qualifier>
      <interchange-sender-id>
        <xsl:value-of select="//fnParty:partyIdentifier[@partyIdentifierQualifierCode='DUNS']/@partyIdentifierCode"/>
      </interchange-sender-id>
      <interchange-receiver-id-qualifier>01</interchange-receiver-id-qualifier>
      <interchange-receiver-id>
        <xsl:value-of select="//fnParty:partyIdentifier/@partyIdentifierCode"/> 
      </interchange-receiver-id>
      <interchange-date>
       <xsl:value-of select="translate(//creationDate,'-','')"/>
      </interchange-date>
      <interchange-time>	   
	  </interchange-time>
      <interchange-control-standards>U</interchange-control-standards>
      <interchange-control-version>00400</interchange-control-version>
      <interchange-control-number>	   
	  </interchange-control-number>
      <acknowledgement-requested>0</acknowledgement-requested>
      <usage-indicator>T</usage-indicator>
    </interchange-control-header>

    <functional-group-header>
      <functional-identifier-code>IN</functional-identifier-code>
      <sender-id>
        <xsl:value-of select="//fnParty:partyIdentifier[@partyIdentifierQualifierCode='DUNS']/@partyIdentifierCode"/>
      </sender-id>
      <receiver-id>
        <xsl:value-of select="//fnParty:partyIdentifier/@partyIdentifierCode"/> 
      </receiver-id>
      <date>
        <xsl:value-of select="translate(//creationDate,'-','')"/>
      </date>
      <time>	    
	  </time>
      <group-control-number/>
      <responsible-agency-code>X</responsible-agency-code>
      <edi-version>004010</edi-version>
    </functional-group-header>
  </xsl:template>

  <!-- =============================== create-po-header  =============================== -->
  <xsl:template name="create-po-header">

    <!-- ==================== transaction-set-header ======================== -->
    <transaction-set-header>
      <transaction-set-id>810</transaction-set-id>
      <transaction-set-control-nbr></transaction-set-control-nbr>
    </transaction-set-header>

    <!-- ==================== begin-invoice ========================= -->
    <BIG>
	  <BIG01>	      
	  </BIG01>
      <BIG02>        
	    <xsl:value-of select="//@id"/>
	  </BIG02>
	  <BIG03/>
	  <BIG04>
	     <xsl:value-of select="//@referenceNumberValue"/> 
      </BIG04>
      <release-number/>
      <change-order-sequence-number/>
      <transaction-type>INVOIC</transaction-type>
    </BIG>


   
    <!-- ========================= date-time-reference ============================= -->
      <DTM>
       <DTM01>017</DTM01> 
       <DTM02>
	   <xsl:value-of select="translate(//@shipDate,'-','')"/> 
	   </DTM02>
      </DTM>  

   <!-- ========================= note-special-instruction ============================= -->
 
    <NTE> 
	    <NTE01>ZZZ</NTE01>
        <NTE02>
          <xsl:value-of select="//invoiceNotes"/> 
		</NTE02>
	</NTE>

    <!-- ========================= header-entity-loop ============================= -->
    <header-entity-loop>
      <entity-identifier-code>RI</entity-identifier-code>
      <name>
       <xsl:value-of select="//fnParty:partyName"/>
      </name>
      <identification-code-qualifier/>
      <identification-code></identification-code>
	  <address-information-line1>
	   <xsl:value-of select="//fnParty:addressLine"/>
      </address-information-line1>
	  <address-information-line2/>
      <city-name>
  	      <xsl:value-of select="//fnParty:city"/>
      </city-name>
      <state-or-province-code>
	      <xsl:value-of select="//fnParty:stateOrProvince"/>
      </state-or-province-code>
	  <postal-code>
	      <xsl:value-of select="//fnParty:postalCode"/>
      </postal-code>
    </header-entity-loop>

<!-- ========================= header-entity-loop ============================= -->
    <header-entity-loop>
      <entity-identifier-code>ST</entity-identifier-code>
      <name>	    
	  </name>
      <identification-code-qualifier/>
      <identification-code>
	      <xsl:value-of select="normalize-space(//shipTo/fnParty:partyIdentifier/@partyIdentifierCode)"/>
	  </identification-code>
      <address-information-line1>        
      </address-information-line1>
	  <address-information-line2/>
      <city-name>        
      </city-name>
      <state-or-province-code>        
      </state-or-province-code>
	  <postal-code>	    
	  </postal-code>
    </header-entity-loop>

	<!-- ========================= header-entity-loop ============================= -->
    <header-entity-loop>
      <entity-identifier-code>BT</entity-identifier-code>
      <name>	    
	  </name>
	  <identification-code-qualifier/>
      <identification-code/>
	  <address-information-line1>       
      </address-information-line1>
	  <address-information-line2>       
      </address-information-line2>
      <city-name>       
      </city-name>
      <state-or-province-code>       
      </state-or-province-code>
	  <postal-code>       
      </postal-code>
    </header-entity-loop>
	
    <ITD>
	  <ITD01></ITD01>
	  <ITD02></ITD02>
	  <ITD03>
	    <xsl:value-of select="//invoiceTerms/discountPercent"/> 
	  </ITD03>
	  <ITD04>
	   <xsl:value-of select="translate(//invoiceTerms/discountBasisDate/termsBasisDateValue,'-','')"/> 
	  </ITD04>
	  <ITD05>
	   <xsl:value-of select="//invoiceTerms/discountDueDays"/> 
	  </ITD05>
	  <ITD06>
	   <xsl:value-of select="translate(//invoiceTerms/timeOfPayment/netBasisDate/termsBasisDateValue,'-','')"/> 
	  </ITD06>
	  <ITD07>
	   <xsl:value-of select="//invoiceTerms/timeOfPayment/netDueDays"/> 
	  </ITD07>
	  <ITD08>
	   <xsl:value-of select="//invoiceTerms/discountAmount"/> 
	  </ITD08>
	  <ITD12>
	    <xsl:value-of select="//invoiceTerms/termsDescription"/> 
	  </ITD12>
	</ITD>
   <xsl:for-each select="//invoiceLine">
   <item>
   <IT1>		
      <IT101>	    
	  </IT101>
      <IT102> 
	    <xsl:value-of select="invoicedQuantity/@value"/>	       
      </IT102>
      <IT103>	    
	    <xsl:value-of select="invoicedQuantity/@unitOfMeasure"/>	       
	  </IT103>
      <IT104>	    
	    <xsl:value-of select="invoicedAmount"/>	
      </IT104>
      <IT105></IT105>
      <product-id>
	    <xsl:attribute name="qualifier">
          <xsl:value-of select="'VN'"/>
        </xsl:attribute>
        <xsl:attribute name="id">
		<xsl:value-of select="invoicedItem/itemIdentifier[@itemNumberQualifier='SellerAssigned']/@itemNumber"/>	
        </xsl:attribute>
      </product-id>
	  <product-id>
        <xsl:attribute name="qualifier">
          <xsl:value-of select="'IN'"/>
        </xsl:attribute>
		<xsl:attribute name="id">
			<xsl:value-of select="invoicedItem/itemIdentifier[@itemNumberQualifier='BuyerAssigned']/@itemNumber"/>	
        </xsl:attribute>
      </product-id>      
      <product-description>
	    <xsl:attribute name="product-characteristic-code" />
        <xsl:attribute name="item-description-type">F</xsl:attribute>
		<xsl:attribute name="description">          
		  <xsl:value-of select="invoicedItem/itemDescription[@itemDescriptionQualifier='SellerAssigned']/@descriptionValue"/>	
		</xsl:attribute>	
      </product-description>      
    </IT1>
	<REF>
	  <REF01>InvoiceLineSystemRef_QualifierUnknown</REF01>
	  <REF02>
	    <xsl:value-of select="invoiceLineSystemReference/systemReferenceValue"/>	
	  </REF02>
	</REF>
    <SAC>
	  <SAC01>A</SAC01>
	  <SAC02></SAC02>
	  <SAC05>
	    <xsl:value-of select="invoiceLineAllowance/discountOrAllowanceAmount"/>
	  </SAC05>
	</SAC>
	<SAC>
	  <SAC01>C</SAC01>
	  <SAC02></SAC02>
	  <SAC05>
	    <xsl:value-of select="invoiceLineAdditionalCharge/additionalChargeAmount"/>
	  </SAC05>
	  <SAC15>
	    <xsl:value-of select="invoiceLineAdditionalCharge/additionalChargeDescription"/>
	  </SAC15>
	</SAC>
	</item>
   </xsl:for-each>

  </xsl:template>

  

  <!-- ============================= create-product-option-comment ========================== -->
  <xsl:template name="create-product-option-comment">
  </xsl:template>
  
</xsl:stylesheet>














<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="ashley810_pp4.xml" htmlbaseurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml.jar;D:\XSLExtensionsLIB\xerces.jar;D:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar " postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
