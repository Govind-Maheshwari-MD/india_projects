<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmcStrings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java">

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
          <xsl:call-template name="create-invoice-header" />
          <xsl:apply-templates select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceDetail/MerchandiseLine" />

   		  <total-monetary-value-summary>
		    <total-invoice-amount>
               <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalNetAmount"/> 
			</total-invoice-amount>
            <amount-subject-to-terms-discount>
			   <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalInvDiscAmount"/> 
			</amount-subject-to-terms-discount>
            <discounted-amount-due>
			    <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalInvAmountExclTax"/> 
			</discounted-amount-due>
            <terms-discount-amount>
			   <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalTermsDiscountAmount"/> 
			</terms-discount-amount>
 		  </total-monetary-value-summary>

		  <tax-information>
		    <tax-type-code>S</tax-type-code>
            <monetary-amount>
		        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalSalesTax"/> 
			</monetary-amount>
		  </tax-information>
          <invoice-shipment-summary>
		    <number-of-units-shipped>
			  <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalQuantity"/> 
			</number-of-units-shipped>
            <unit-of-measurement-code></unit-of-measurement-code>
            <weight>
			  <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalMass"/> 
			</weight>
            <volume>
			  <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceTotal/TotalVolume"/> 
			</volume>
		  </invoice-shipment-summary>
          
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
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/TransmissionHeader/SenderCode"/> 
      </interchange-sender-id>
      <interchange-receiver-id-qualifier>01</interchange-receiver-id-qualifier>
      <interchange-receiver-id>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/TransmissionHeader/ReceiverCode"/>
      </interchange-receiver-id>
      <interchange-date>
        <xsl:value-of select="substring(translate(/SalesInvoices/Invoice-Transaction/TransmissionHeader/DatePrepared,'-',''),3,6)"/> 
      </interchange-date>
      <interchange-time>
	    <xsl:value-of select="translate(/SalesInvoices/Invoice-Transaction/TransmissionHeader/TimePrepared,':','')"/> 
	  </interchange-time>
      <interchange-control-standards>U</interchange-control-standards>
      <interchange-control-version>00400</interchange-control-version>
      <interchange-control-number>
	   <xsl:value-of select="/SalesInvoices/Invoice-Transaction/TransmissionHeader/TransmissionReference"/>
	  </interchange-control-number>
      <acknowledgement-requested>0</acknowledgement-requested>
      <usage-indicator>T</usage-indicator>
    </interchange-control-header>

    <functional-group-header>
      <functional-identifier-code>IN</functional-identifier-code>
      <sender-id>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/TransmissionHeader/SenderCode"/> 
      </sender-id>
      <receiver-id>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/TransmissionHeader/ReceiverCode"/> 
      </receiver-id>
      <date>
        <xsl:value-of select="substring(translate(/SalesInvoices/Invoice-Transaction/TransmissionHeader/DatePrepared,'-',''),3,6)"/> 
      </date>
      <time>
	    <xsl:value-of select="translate(/SalesInvoices/Invoice-Transaction/TransmissionHeader/TimePrepared,':','')"/> 
	  </time>
      <group-control-number/>
      <responsible-agency-code>X</responsible-agency-code>
      <edi-version>004010</edi-version>
    </functional-group-header>
  </xsl:template>

  <!-- =============================== create-invoice-header  =============================== -->
  <xsl:template name="create-invoice-header">

    <!-- ==================== transaction-set-header ======================== -->
    <transaction-set-header>
      <transaction-set-id>810</transaction-set-id>
      <transaction-set-control-nbr>0700</transaction-set-control-nbr>
    </transaction-set-header>

    <!-- ==================== begin-invoice ========================= -->
    <begin-invoice>
	  <invoice-date>
	   <xsl:value-of select="substring(translate(/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceDate,'-',''),3,6)"/>     
	  </invoice-date>
      <invoice-number>
	   <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/SalesInvoiceNumber"/>     
	  </invoice-number>
	  <purchase-order-date/>
	  <purchase-order-number>
	     <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CustomerPoNumber"/> 
      </purchase-order-number>
      <release-number/>
      <change-order-sequence-number/>
      <transaction-type>INVOIC</transaction-type>
    </begin-invoice>


    <!-- ========================= currency ============================= -->
 
    <currency> 
	    <entity-identifier-code></entity-identifier-code>
        <currency-code>
		 <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/Currency"/>
		</currency-code>
		<exchange-rate>
		 <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CurrencyRate"/>
		</exchange-rate> 	  
	</currency>

	

	<!-- ========================= reference-numbers ============================= -->
     <reference-numbers> 
	    <reference-number-qualifier>PO</reference-number-qualifier>
        <reference-number>
		<xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CustomerPoNumber"/> 
		</reference-number>
	  </reference-numbers>
	
  <!-- ========================= reference-numbers ============================= -->
   <xsl:if test="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/DeliveryNoteNumber!=''"> 
    <reference-numbers> 
	    <reference-number-qualifier>AAU</reference-number-qualifier>
        <reference-number>
		 <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/DeliveryNoteNumber"/>
		</reference-number>
	  </reference-numbers>
   </xsl:if>

 <!-- ========================= reference-numbers ============================= -->
 
    <reference-numbers> 
	    <reference-number-qualifier>VA</reference-number-qualifier>
        <reference-number>
		 <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CompanyTaxRegNumber"/>
		</reference-number>
	  </reference-numbers>
  
    <!-- ========================= header-entity-loop ============================= -->
    <header-entity-loop>
      <entity-identifier-code>ST</entity-identifier-code>
      <name>
    <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CustomerName"/>
      </name>
      <identification-code-qualifier/>
      <identification-code></identification-code>
	  <address-information-line1>
	      <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/ShipAddress1"/>
      </address-information-line1>
	  <address-information-line2/>
      <city-name>
  	      <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/ShipAddress2"/>
      </city-name>
      <state-or-province-code>
	      <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/ShipAddress3"/>    
      </state-or-province-code>
	  <postal-code>
	      <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/ShipPostalCode"/>    
      </postal-code>
    </header-entity-loop>

<!-- ========================= header-entity-loop ============================= -->
    <header-entity-loop>
      <entity-identifier-code>SU</entity-identifier-code>
      <name>
	    <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CompanyName"/>
	  </name>
      <identification-code-qualifier/>
      <identification-code/>
      <address-information-line1>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CompanyAddress1"/>
      </address-information-line1>
	  <address-information-line2/>
      <city-name>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CompanyAddress2"/>	
      </city-name>
      <state-or-province-code>
        <xsl:value-of select="substring-before(/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CompanyAddress3,' ')"/>	
      </state-or-province-code>
	  <postal-code>
	    <xsl:value-of select="substring-after(/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/CompanyAddress3,' ')"/>	
	  </postal-code>
    </header-entity-loop>

	<!-- ========================= header-entity-loop ============================= -->
    <header-entity-loop>
      <entity-identifier-code>BY</entity-identifier-code>
      <name>
	    <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceCustomerName"/>
	  </name>
	  <identification-code-qualifier/>
      <identification-code/>
	  <address-information-line1>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceAddress1"/>
      </address-information-line1>
	  <address-information-line2>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceAddress2"/>
      </address-information-line2>
      <city-name>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceAddress3"/>
      </city-name>
      <state-or-province-code>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceAddress4"/>	
      </state-or-province-code>
	  <postal-code>
        <xsl:value-of select="/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoicePostalCode"/>
      </postal-code>
    </header-entity-loop>
	<date-time-reference>
	  <date-qualifier>068</date-qualifier>
	  <date>
	    <xsl:value-of select="substring(translate(/SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/ShipDate,'-',''),3,6)"/>
	  </date>
	</date-time-reference>
	<date-time-reference>
	  <date-qualifier>131</date-qualifier>

	  <date>	    
	    <xsl:value-of select="substring(translate(SalesInvoices/Invoice-Transaction/SalesInvoice/InvoiceHeader/InvoiceDate,'-',''),3,6)"/>
	  </date>
	</date-time-reference>


  </xsl:template>

  <!-- ========================= create-product-line ================================== -->
  <xsl:template match="MerchandiseLine">   

    <baseline-item-data>		
      <assigned-identification>
	    <xsl:value-of select="DetailLineNumber"/>	
	  </assigned-identification>
      <quantity-invoiced>
        <xsl:value-of select="ShipQty"/>	
      </quantity-invoiced>
      <unit-of-measurement-code>
	     <xsl:value-of select="PriceUom"/>	
	  </unit-of-measurement-code>
      <unit-price>
	    <xsl:value-of select="UnitPrice"/>	
      </unit-price>
      <basis-of-unit-price-code>PE</basis-of-unit-price-code>
      <product-id>
        <xsl:attribute name="qualifier">
          <xsl:value-of select="'IN'"/>
        </xsl:attribute>
        <xsl:attribute name="id">
		<xsl:value-of select="translate(CustomerPartNumber,'/','')"/>	
        </xsl:attribute>
      </product-id>
	  <product-id>
        <xsl:attribute name="qualifier">
          <xsl:value-of select="'VN'"/>
        </xsl:attribute>
        <xsl:attribute name="id">
		<xsl:value-of select="StockCode"/>	
        </xsl:attribute>
      </product-id>
      
      <product-description>
	    <xsl:attribute name="product-characteristic-code" />
        <xsl:attribute name="item-description-type">F</xsl:attribute>
		<xsl:attribute name="description">
          <xsl:value-of select="StockDescription"/>	
		</xsl:attribute>	
      </product-description>
    </baseline-item-data>
  </xsl:template>
  
</xsl:stylesheet>


















<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="quality810_1.xml" htmlbaseurl="storis\" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml.jar;D:\XSLExtensionsLIB\xerces.jar;D:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar " postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
