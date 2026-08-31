class /ITETR/CL_EARCHIVE_WS_KOC definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  create public .

public section.

  methods DOWNLOAD_REGISTERED_TAXPAYERS
    redefinition .
  methods GET_INCOMING_ARCHIVES
    redefinition .
  methods INCOMING_ARCHIVE_DOWNLOAD
    redefinition .
  methods OUTGOING_INVOICE_CANCEL
    redefinition .
  methods OUTGOING_INVOICE_DOWNLOAD
    redefinition .
  methods OUTGOING_INVOICE_GET_STATUS
    redefinition .
  methods OUTGOING_INVOICE_SEND
    redefinition .
  methods OUTGOING_INVOICE_PREVIEW
    redefinition .
protected section.
  PRIVATE SECTION.

ENDCLASS.



CLASS /ITETR/CL_EARCHIVE_WS_KOC IMPLEMENTATION.


  METHOD download_registered_taxpayers.

  ENDMETHOD.


  method GET_INCOMING_ARCHIVES.
  endmethod.


  METHOD incoming_archive_download.
  ENDMETHOD.


  METHOD outgoing_invoice_cancel.
    DATA: lv_request_xml          TYPE string,
          lv_response_xml         TYPE string,
          lt_xml_table            TYPE TABLE OF smum_xmltb,
          ls_xml_line             TYPE smum_xmltb,
          lt_request_header       TYPE mty_service_header_tab,
          lv_status               TYPE text255,
          lv_description          TYPE string,
          lv_message              TYPE bapi_msg,
          lx_exception            TYPE REF TO /itetr/cx_regulative_exception,
          ls_company_parameter    TYPE /itetr/inv_eacp,
          lv_tax_exclusive_amount TYPE text30.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    MOVE iv_tax_exclusive_amount TO lv_tax_exclusive_amount.
    CONDENSE lv_tax_exclusive_amount.
    CONCATENATE
        '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"'
           ` ` 'xmlns:tem="http://tempuri.org/"'
           ` ` 'xmlns:ks="http://schemas.datacontract.org/2004/07/KS_eArchive.ProcessingServiceLibrary.Contract">'
           '<soap:Header/>'
           '<soap:Body>'
              '<tem:CancelDocument>'
                 '<tem:requestInfo>'
                  '<tem:EInvoiceUuid>' is_document_numbers-duich '</tem:EInvoiceUuid>'
                   '<tem:EInvoiceId>' is_document_numbers-docno '</tem:EInvoiceId>'
                    '<tem:EInvoiceCanceledDate>' sy-datum(4) '-' sy-datum+4(2) '-' sy-datum+6(2) 'T' sy-uzeit(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2) 'Z' '</tem:EInvoiceCanceledDate>'
                    '<tem:EInvoiceTotalWithOutTax>' lv_tax_exclusive_amount '</tem:EInvoiceTotalWithOutTax>'
                    '<tem:WcfUserName>' ms_company_parameters-wsusr '</tem:WcfUserName>'
                    '<tem:WcfUserPassword>' ms_company_parameters-wspwd '</tem:WcfUserPassword>'
                 '</tem:requestInfo>'
              '</tem:CancelDocument>'
           '</soap:Body>'
        '</soap:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/ArchiveInvoiceService.svc'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'application/soap+xml;charset=UTF-8;action="http://tempuri.org/IProcess/CancelDocument"'.
    READ TABLE mt_custom_parameters INTO ls_company_parameter WITH KEY cuspa = 'ERPCODE'.
    IF sy-subrc = 0 AND ls_company_parameter-value IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'erpcode'.
      <ls_request_header>-value = ls_company_parameter-value.
    ENDIF.
    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    FIND REGEX '(<s:Envelope.*</s:Envelope>)' IN lv_response_xml SUBMATCHES lv_response_xml.
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'Status'.
          lv_status = ls_xml_line-cvalue.
        WHEN 'Description'.
          CONCATENATE lv_description ls_xml_line-cvalue INTO lv_description.
      ENDCASE.
    ENDLOOP.
    IF lv_status <> 'true'.
      lv_message = lv_description.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml       TYPE string,
          lv_response_xml      TYPE string,
          lt_xml_table         TYPE TABLE OF smum_xmltb,
          ls_xml_line          TYPE smum_xmltb,
          lt_request_header    TYPE mty_service_header_tab,
          lv_status            TYPE text255,
          lv_description       TYPE string,
          lv_message           TYPE bapi_msg,
          lx_exception         TYPE REF TO /itetr/cx_regulative_exception,
          ls_company_parameter TYPE /itetr/inv_eacp,
          lv_service_name      TYPE text30.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CASE iv_content_type.
      WHEN /itetr/cl_regulative_archive=>mc_content_types-html.
        lv_service_name = 'GetDocumentHtml'.
      WHEN /itetr/cl_regulative_archive=>mc_content_types-pdf.
*        lv_service_name = 'GetDocumentPdf'.

        "*--> ekaya com.08.02.2022 15:31:54 geçici
    lv_message = TEXT-001.
    lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '000'
    iv_msgv1 = lv_message(50)
    iv_msgv2 = lv_message+50(50)
    iv_msgv3 = lv_message+100(50)
    iv_msgv4 = lv_message+150(50) ).
    RAISE EXCEPTION lx_exception.

        "*--< ekaya com.08.02.2022 15:31:54

      WHEN /itetr/cl_regulative_archive=>mc_content_types-ubl.
        lv_service_name = 'GetDocument'.
    ENDCASE.
    "*--> ekaya ins.08.02.2022 11:23:15
*    CONCATENATE
*      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/"xmlns:ks="http://schemas.datacontract.org/2004/07/KS_eArchive.ProcessingServiceLibrary.Contract">'
*         '<soapenv:Header/>'
*         '<soapenv:Body>'
*            '<tem:' lv_service_name '>'
*               '<tem:requestInfo>'
**                  '<tem:ExtensionData/>'
*                  '<ks:EInvoiceId>' is_document_numbers-docno '</ks:EInvoiceId>'
*                  '<ks:EInvoiceUuid>' is_document_numbers-duich '</ks:EInvoiceUuid>'
*                  '<ks:WcfUserName>' ms_company_parameters-wsusr '</ks:WcfUserName>'
*                  '<ks:WcfUserPassword>' ms_company_parameters-wspwd '</ks:WcfUserPassword>'
*               '</tem:requestInfo>'
*            '</tem:' lv_service_name '>'
*         '</soapenv:Body>'
*      '</soapenv:Envelope>'
*      INTO lv_request_xml.

    "*--< ekaya ins.08.02.2022 11:23:15

    "*--> ekaya com.08.02.2022 11:23:15 geçici kapatıldı
    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<tem:' lv_service_name '>'
               '<tem:requestInfo>'
                  '<tem:ExtensionData/>'
                  '<tem:EInvoiceUuid>' is_document_numbers-duich '</tem:EInvoiceUuid>'
                  '<tem:EInvoiceId>' is_document_numbers-docno '</tem:EInvoiceId>'
                  '<tem:WcfUserName>' ms_company_parameters-wsusr '</tem:WcfUserName>'
                  '<tem:WcfUserPassword>' ms_company_parameters-wspwd '</tem:WcfUserPassword>'
               '</tem:requestInfo>'
            '</tem:' lv_service_name '>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
    "*--< ekaya com.08.02.2022 11:23:15

*    mv_request_url = '/ArchiveInvoiceService.svc'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name = 'Accept-Encoding'.
*    <ls_request_header>-value = 'gzip,deflate'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name = 'Content-Type'.
*    CONCATENATE 'application/soap+xml;charset=UTF-8;action="http://tempuri.org/IProcess/' lv_service_name '"' INTO <ls_request_header>-value.
*    READ TABLE mt_custom_parameters INTO ls_company_parameter WITH KEY cuspa = 'ERPCODE'.
*    IF sy-subrc = 0 AND ls_company_parameter-value IS NOT INITIAL.
*      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*      <ls_request_header>-name = 'erpcode'.
*      <ls_request_header>-value = ls_company_parameter-value.
*    ENDIF.
    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    FIND REGEX '(<s:Envelope.*</s:Envelope>)' IN lv_response_xml SUBMATCHES lv_response_xml.
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'Status'.
          lv_status = ls_xml_line-cvalue.
        WHEN 'Description'.
          CONCATENATE lv_description ls_xml_line-cvalue INTO lv_description RESPECTING BLANKS.
      ENDCASE.
    ENDLOOP.
    IF lv_status <> 'true'.
      lv_message = lv_description.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ELSE.
      CASE iv_content_type.
        WHEN /itetr/cl_regulative_archive=>mc_content_types-pdf.
          rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_description ).
        WHEN OTHERS.
          rv_invoice_data = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_description ).
      ENDCASE.
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
    rs_status-stacd = '5'.
  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_send.
    DATA: lv_request_xml       TYPE string,
          lv_response_xml      TYPE string,
          lt_xml_table         TYPE TABLE OF smum_xmltb,
          ls_xml_line          TYPE smum_xmltb,
          lv_earchive_type     TYPE text10,
          lv_send_type         TYPE text10,
          lv_print_type        TYPE text30,
          lv_ubl_xml           TYPE string,
          lv_ubl_raw           TYPE xstring,
          lv_mail              TYPE ad_smtpadr,
          lv_mail_receiver     TYPE pad_cname,
          ls_custom_parameter  TYPE /itetr/com_s_custom_param,
          lv_submatch          TYPE string,
          lv_hash              TYPE hash160,
          lv_xslt_code         TYPE /itetr/com_e_value,
          ls_company_parameter TYPE /itetr/inv_eacp,
          lt_request_header    TYPE mty_service_header_tab,
          lv_status            TYPE text255,
          lv_description       TYPE text255,
          lx_exception         TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

*    CASE iv_earchive_type.
*      WHEN 'ELEKTRONIK'.
*        lv_send_type = 'Elektronik'.
*      WHEN OTHERS.
*        lv_send_type = 'Kagit'.
*    ENDCASE.

    CASE iv_internet_sale.
      WHEN abap_true.
        lv_earchive_type = 'Internet'.
      WHEN OTHERS.
        lv_earchive_type = 'Normal'.
    ENDCASE.

    "is_ubl_structure-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content IS NOT INITIAL.
    READ TABLE it_custom_parameters INTO ls_custom_parameter WITH KEY cuspa = 'MAIL'.
    IF sy-subrc = 0.
      lv_mail = ls_custom_parameter-value.
      lv_print_type = 'EpostaYoluylaEkOlarakPdf'.
      IF is_ubl_structure-part1-accounting_customer_party-party-party_name-name-base-base-content IS NOT INITIAL.
        lv_mail_receiver = is_ubl_structure-part1-accounting_customer_party-party-party_name-name-base-base-content.
      ENDIF.
      IF is_ubl_structure-part1-accounting_customer_party-party-person-first_name-base-base-content IS NOT INITIAL.
        lv_mail_receiver = is_ubl_structure-part1-accounting_customer_party-party-person-first_name-base-base-content.
      ENDIF.
      lv_send_type = 'Elektronik'.
    ELSE.
      lv_print_type = 'Gonderilmeyecek'.
      lv_send_type = 'Kagit'.
    ENDIF.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'KOC_XSLT'.
    IF sy-subrc = 0.
      lv_xslt_code = ls_company_parameter-value.
    ENDIF.

    lv_ubl_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_ubl_xstring ).
    REPLACE FIRST OCCURRENCE OF '<?xml version="1.0"?>' IN lv_ubl_xml WITH ``.
*    FIND REGEX '(<n\w:UBLVersionID>)' IN lv_ubl_xml SUBMATCHES lv_submatch.
    lv_submatch = '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.
*    CONCATENATE '<n3:UBLExtensions><n3:UBLExtension><n3:ExtensionContent></n3:ExtensionContent></n3:UBLExtension></n3:UBLExtensions>' lv_submatch INTO lv_submatch.
    REPLACE REGEX '<cbc:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.
*    REPLACE REGEX '<n\w:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n0:Invoice' IN lv_ubl_xml WITH 'Invoice'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n1' IN lv_ubl_xml WITH 'cac'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n2' IN lv_ubl_xml WITH 'cbc'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n3' IN lv_ubl_xml WITH 'ext'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:prx="urn:sap.com:proxy:SE7:/1SAI/TASBAECC1700EB7C150E310:750"' IN lv_ubl_xml WITH ``.
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n3="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n2="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n1="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n0="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"'
*    IN lv_ubl_xml WITH 'xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"'.

    lv_ubl_raw = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_ubl_xml ).
    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
      EXPORTING
        alg            = 'MD5'
        data           = lv_ubl_raw
      IMPORTING
        hash           = lv_hash
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.
    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_ubl_raw
      IMPORTING
        output = lv_ubl_xml.

    CONCATENATE
        '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"'
           ` ` 'xmlns:tem="http://tempuri.org/"'
           ` ` 'xmlns:ks="http://schemas.datacontract.org/2004/07/KS_eArchive.ProcessingServiceLibrary.Contract.SendDocumentInfoUbl21TR12.OnlineProcessing">'
           '<soap:Header/>'
           '<soap:Body>'
              '<tem:SendDocument_Ubl21Tr12>'
                 '<tem:requestInfo>'
                    '<tem:EInvoiceDidShipping>false</tem:EInvoiceDidShipping>'
                    '<tem:EInvoiceId>' is_ubl_structure-part1-id-base-base-content '</tem:EInvoiceId>'
                    '<tem:EInvoicePrintTypeEnum>' lv_print_type '</tem:EInvoicePrintTypeEnum>'
                    '<tem:EInvoiceSendTypeEnum>' lv_send_type '</tem:EInvoiceSendTypeEnum>'
                    '<tem:EInvoiceTypeEnum>' lv_earchive_type '</tem:EInvoiceTypeEnum>'
                    '<tem:EInvoiceUuid>' is_ubl_structure-part1-uuid-base-base-content '</tem:EInvoiceUuid>'
                    '<tem:FileBytes>' lv_ubl_xml '</tem:FileBytes>'
                    '<tem:FileMd5HashCode>' lv_hash '</tem:FileMd5HashCode>'
                    '<tem:FileName>' is_ubl_structure-part1-uuid-base-base-content '.xml</tem:FileName>'
*                   '<ks:IsFinalConsumer>true</ks:IsFinalConsumer>'
                    '<tem:IsImmediateInvoice>false</tem:IsImmediateInvoice>'
                    '<tem:MailReciverName>' lv_mail_receiver '</tem:MailReciverName>'
                    '<tem:MailRecivereMailAddress>' lv_mail '</tem:MailRecivereMailAddress>'
                    '<tem:WcfUserName>' ms_company_parameters-wsusr '</tem:WcfUserName>'
                    '<tem:WcfUserPassword>' ms_company_parameters-wspwd '</tem:WcfUserPassword>'
*                   '<tem:XstlCode>' lv_xslt_code '</tem:XstlCode>'
                 '</tem:requestInfo>'
              '</tem:SendDocument_Ubl21Tr12>'
           '</soap:Body>'
        '</soap:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/ArchiveInvoiceService.svc'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'application/soap+xml;charset=UTF-8;action="http://tempuri.org/IProcess/SendDocument_Ubl21Tr12"'.
    READ TABLE mt_custom_parameters INTO ls_company_parameter WITH KEY cuspa = 'ERPCODE'.
    IF sy-subrc = 0 AND ls_company_parameter-value IS NOT INITIAL.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'erpcode'.
      <ls_request_header>-value = ls_company_parameter-value.
    ENDIF.
    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    FIND REGEX '(<s:Envelope.*</s:Envelope>)' IN lv_response_xml SUBMATCHES lv_response_xml.
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'Status'.
          lv_status = ls_xml_line-cvalue.
        WHEN 'Description'.
          lv_description = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.
    IF lv_status <> 'true'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_description(50)
                                                                        iv_msgv2 = lv_description+50(50)
                                                                        iv_msgv3 = lv_description+100(50)
                                                                        iv_msgv4 = lv_description+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.
  ENDMETHOD.
ENDCLASS.