<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xmcStrings="xmc.xslt.extensions.StringExtension" xmlns:java="http://xml.apache.org/xslt/java">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="elementSeparator">
		<xsl:text> </xsl:text>
	</xsl:variable>
<xsl:variable name="header-line" select="/Document/Header/line"/>
<xsl:variable name="message-line" select="/Document/Message/Component/line"/>
	<xsl:template match="/">
		<message-document>
			<envelope-header>
				<interchange-control-header>
					<authorization-information-qualifier>00</authorization-information-qualifier>
					<authorization-information>          </authorization-information>
					<security-information-qualifier>00</security-information-qualifier>
					<security-information>          </security-information>
					<interchange-sender-id-qualifier>01</interchange-sender-id-qualifier>
					<interchange-sender-id>7044355881     </interchange-sender-id>
					<interchange-receiver-id-qualifier>ZZ</interchange-receiver-id-qualifier>
					<interchange-receiver-id>
					  <xsl:value-of select="substring($header-line,8,18)"/>						
					</interchange-receiver-id>
					<interchange-date>
					 <xsl:value-of select="substring($message-line,478,6)"/>						
					</interchange-date>
					<interchange-time>						
					</interchange-time>
					<interchange-control-standards>U</interchange-control-standards>
					<interchange-control-version-number>00401</interchange-control-version-number>
					<interchange-control-number></interchange-control-number>
					<acknowledgement-requested>0</acknowledgement-requested>
					<usage-indicator>T</usage-indicator>
					<subelement-separator></subelement-separator>
				</interchange-control-header>
				<functional-group-header>
					<functional-identifier-code>PR</functional-identifier-code>
					<sender-id>7044355881</sender-id>
					<receiver-id><xsl:value-of select="substring($header-line,8,18)"/>	</receiver-id>
					<date>
					 <xsl:value-of select="substring($message-line,476,8)"/>
					</date>
					<time></time>
					<group-control-number></group-control-number>
					<responsible-agency-code>X</responsible-agency-code>
					<edi-version>004010</edi-version>
				</functional-group-header>
			</envelope-header>
			<message-body>
				<transaction>					
					<transaction-set-header>
						<transaction-set-id>855</transaction-set-id>
						<transaction-set-control-nbr>							
						</transaction-set-control-nbr>
					</transaction-set-header>
					
					<begin-acknowledgement>
						<transaction-set-purpose-code>00</transaction-set-purpose-code>
						<acknowledgement-type>AC</acknowledgement-type>
						<purchase-order-number>
						    <xsl:value-of select="normalize-space(substring($header-line,26,18))"/>							
						</purchase-order-number>
						<purchase-order-date>
						    <xsl:value-of select="substring($header-line,44,8)"/>
						</purchase-order-date>
						<release-number/>
						<contract-number></contract-number> 
						<reference-number>
						  <xsl:value-of select="substring($message-line,470,6)"/>
						</reference-number>
						<acknowledgement-date>
						<xsl:value-of select="substring($message-line,476,8)"/>
						</acknowledgement-date>						
					</begin-acknowledgement>
					<reference-numbers>
                        <reference-number-qualifier>60</reference-number-qualifier> 
                        <reference-number> 
						  <xsl:value-of select="substring($header-line,56,5)"/>
						</reference-number>
                        <description /> 
                    </reference-numbers>
					<reference-numbers>
                        <reference-number-qualifier>CR</reference-number-qualifier> 
                        <reference-number>
						 <xsl:value-of select="normalize-space(substring($header-line,61,20))"/>
						</reference-number>
						<description>
						</description>
                    </reference-numbers>
					<administrative-communications-contact> <!--PER-->
					  <contact-function-code>IC</contact-function-code>
					  <name>
					    <xsl:value-of select="normalize-space(substring($header-line,81,30))"/>
					  </name>
					</administrative-communications-contact>
					<date-and-time>
                         <date-qualifier>017</date-qualifier> 
                         <date>
						   <xsl:value-of select="substring($header-line,111,8)"/>
						 </date> 
                    </date-and-time>
					<header-entity-loop>
					  <entity-identifier-code>ST</entity-identifier-code>
                      <name>
					      <xsl:value-of select="normalize-space(substring($header-line,398,25))"/>
					  </name>
					  <identification-code-qualifier></identification-code-qualifier>
					  <identification-code></identification-code>					  
					  <name1></name1>
					  <name2></name2>
					  <address-information-line1>
					      <xsl:value-of select="normalize-space(substring($header-line,423,25))"/>
					  </address-information-line1>
					  <address-information-line2>
					      <xsl:value-of select="normalize-space(substring($header-line,448,25))"/>
					  </address-information-line2>
					  <city-name>
					      <xsl:value-of select="normalize-space(substring($header-line,473,20))"/>
					  </city-name>
					  <state-or-province-code>
					      <xsl:value-of select="substring($header-line,493,2)"/>
					  </state-or-province-code>
					  <postal-code>
					     <xsl:value-of select="substring($header-line,495,5)"/>
					  </postal-code>
					</header-entity-loop>
					<header-entity-loop>
					  <entity-identifier-code>BT</entity-identifier-code>
                      <name>
					     <xsl:value-of select="normalize-space(substring($header-line,500,25))"/>
					  </name>
					  <identification-code-qualifier></identification-code-qualifier>
					  <identification-code></identification-code>					  
					  <name1></name1>
					  <name2></name2>
					  <address-information-line1>
					    <xsl:value-of select="normalize-space(substring($header-line,525,25))"/>
					  </address-information-line1>
					  <address-information-line2>
					    <xsl:value-of select="normalize-space(substring($header-line,550,25))"/>
					  </address-information-line2>
					  <city-name>
					    <xsl:value-of select="normalize-space(substring($header-line,575,20))"/>
					  </city-name>
					  <state-or-province-code>
					    <xsl:value-of select="substring($header-line,595,2)"/>
					  </state-or-province-code>
					  <postal-code>
                        <xsl:value-of select="substring($header-line,597,5)"/>
					  </postal-code>
					</header-entity-loop>
					<xsl:for-each select="/Document/Message/Component/line[starts-with(text(),' DTL')]">
						<xsl:call-template name="create-product-line"/>
					</xsl:for-each>
					<transaction-totals>
						<number-of-line-items>
							<xsl:value-of select="count(/Document/Message/Component/line)"/>
						</number-of-line-items>
					</transaction-totals>
					
                    <monetary-amount>
                       <amount-qualifier-code>					       	
					   </amount-qualifier-code> 
                       <monetary-amount>					       	
					   </monetary-amount> 
                    </monetary-amount> 
					<transaction-set-trailer>						
						<number-of-included-segments>						
						</number-of-included-segments>
						<transaction-set-control-nbr>						
						</transaction-set-control-nbr>
					</transaction-set-trailer>
				</transaction>
			</message-body>
			<envelope-footer>
				<functional-group-trailer>
					<number-of-transaction-sets-included>						
					</number-of-transaction-sets-included>
					<group-control-number>						
					</group-control-number>
				</functional-group-trailer>
				<interchange-control-trailer>
					<number-of-included-functional-groups>						
					</number-of-included-functional-groups>
					<interchange-control-number>						
					</interchange-control-number>
				</interchange-control-trailer>
			</envelope-footer>
		</message-document>
	</xsl:template>

	<xsl:template name="create-product-line">
		<product>			
			<assigned-identification>
			    <xsl:value-of select="substring(text(),56,2)"/>				
			</assigned-identification>
			<quantity-ordered>
			    <xsl:value-of select="substring(text(),58,2)"/>				
			</quantity-ordered>
			<unit-of-measurement-code>EA</unit-of-measurement-code>
			<unit-price>
			    <xsl:value-of select="substring(text(),60,6)"/>			    
			</unit-price>
			<basis-of-unit-price-code>PE</basis-of-unit-price-code>
			<xsl:element name="product-id">
				<xsl:attribute name="qualifier">
			      <xsl:text>VC</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="normalize-space(substring(text(),66,12))"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="product-id">
				<xsl:attribute name="qualifier">
                  <xsl:text>SK</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="id">
                  <xsl:value-of select="normalize-space(substring(text(),78,16))"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="product-id">
				<xsl:attribute name="qualifier">
				  <xsl:text>VN</xsl:text>			
				</xsl:attribute>
				<xsl:attribute name="id">
                  <xsl:value-of select="normalize-space(substring(text(),94,16))"/>
				</xsl:attribute>
			</xsl:element>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),110,40))"/>
			</xsl:attribute> 
			</product-description>
            <product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),150,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),190,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),230,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),270,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),310,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),350,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),390,40))"/>
			</xsl:attribute> 
			</product-description>
			<product-description item-description-type="F">
			<xsl:attribute name="description">
			  <xsl:value-of select="normalize-space(substring(text(),430,40))"/>
			</xsl:attribute> 
			</product-description>
			<line-item-acknowledgement>
               <line-item-status-code></line-item-status-code> 
               <date>
			     <xsl:value-of select="substring(text(),476,8)"/> <!--Acknowledge Date-->
			   </date> 
               <request-reference-number>
			     <xsl:value-of select="substring(text(),470,6)"/>  <!--Acknowledge Num-->
			   </request-reference-number> 
            </line-item-acknowledgement>
		</product>
   </xsl:template>
</xsl:stylesheet>






<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="by855_pp1.xml" htmlbaseurl="" processortype="xalan" commandline="" additionalpath="" additionalclasspath="D:\XSLExtensionsLIB\xalan.jar;d:\XSLExtensionsLIB\xml&#x2D;apis.jar;d:\XSLExtensionsLIB\xml.jar;d:\XSLExtensionsLIB\xerces.jar;d:\XSLExtensionsLIB\xmcXSLExtensions.jar; d:\XSLExtensionsLIB\xsltc.jar" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->
