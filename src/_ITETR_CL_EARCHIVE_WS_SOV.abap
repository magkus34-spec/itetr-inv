class /ITETR/CL_EARCHIVE_WS_SOV definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  final
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
private section.
ENDCLASS.



CLASS /ITETR/CL_EARCHIVE_WS_SOV IMPLEMENTATION.


  method DOWNLOAD_REGISTERED_TAXPAYERS.
  endmethod.


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
          lv_description          TYPE string,
          lv_tax_exclusive_amount TYPE text30,
          lv_status               TYPE text255,
          lv_message              TYPE bapi_msg,
          lx_exception            TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    MOVE iv_tax_exclusive_amount TO lv_tax_exclusive_amount.
    CONDENSE lv_tax_exclusive_amount.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inv="http://fitcons.com/earchive/invoicecancellation">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<inv:invoiceCancellationServiceRequestType>'
             '<invoiceCancelInfoTypeList>'
                '<invoiceId>' is_document_numbers-docno '</invoiceId>'
                '<vkn>' mv_company_taxid '</vkn>'
*                '<branch>default</branch>'
                '<totalAmount>' lv_tax_exclusive_amount '</totalAmount>'
                '<cancelDate>' sy-datum(4) '-' sy-datum+4(2) '-' sy-datum+6(2) '</cancelDate>'
*                '<custInvID></custInvID>'
             '</invoiceCancelInfoTypeList>'
          '</inv:invoiceCancellationServiceRequestType>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'cancelInvoice'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'Result'.
          lv_status = ls_xml_line-cvalue.
        WHEN 'message'.
          CONCATENATE lv_description ls_xml_line-cvalue INTO lv_description.
      ENDCASE.
    ENDLOOP.

    IF lv_status NE 'SUCCESS'.
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
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lt_request_header TYPE mty_service_header_tab,
          lv_description    TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    IF iv_content_type EQ 'UBL'.
      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inv="http://fitcons.com/earchive/invoice">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<inv:getSignedInvoiceRequestType>'
               '<UUID>' is_document_numbers-duich '</UUID>'
               '<vkn>' mv_company_taxid '</vkn>'
*             '<invoiceNumber>' is_document_numbers-docno '</invoiceNumber>'
*               '<outputType>' iv_content_type '</outputType>'
               '<custInvID></custInvID>'
            '</inv:getSignedInvoiceRequestType>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'getSignedInvoice'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'binaryData'.
            CONCATENATE lv_description ls_xml_line-cvalue INTO lv_description RESPECTING BLANKS.
        ENDCASE.
      ENDLOOP.

      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_description ).

    ELSE.

      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inv="http://fitcons.com/earchive/invoice">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<inv:getInvoiceDocumentRequestType>'
               '<UUID>' is_document_numbers-duich '</UUID>'
               '<vkn>' mv_company_taxid '</vkn>'
*             '<invoiceNumber>' is_document_numbers-docno '</invoiceNumber>'
               '<outputType>' iv_content_type '</outputType>'
               '<custInvID></custInvID>'
            '</inv:getInvoiceDocumentRequestType>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'getInvoiceDocument'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'binaryData'.
            CONCATENATE lv_description ls_xml_line-cvalue INTO lv_description RESPECTING BLANKS.
        ENDCASE.
      ENDLOOP.

      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_description ).
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
    rs_status-stacd = '5'.
  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_send.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_zipped_file    TYPE xstring,
          lv_invoice_base64 TYPE string,
          lv_ubl_raw        TYPE xstring,
          lv_ubl_xml        TYPE string,
          lv_ubl_xstring    TYPE xstring,
          lv_hash           TYPE hash160,
          lv_submatch       TYPE string,
          lv_message        TYPE bapi_msg,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE is_ubl_structure-part1-uuid-base-base-content '.xml' INTO lv_file_name.


    lv_ubl_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_ubl_xstring ).

    lv_submatch = '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.
    REPLACE REGEX '<cbc:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.


    lv_ubl_xstring = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_ubl_xml ).

    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = lv_ubl_xstring
                                                                   iv_input_name = lv_file_name ).


    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
      EXPORTING
        alg            = 'MD5'
        data           = lv_zipped_file
      IMPORTING
        hash           = lv_hash
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inv="http://fitcons.com/earchive/invoice">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<inv:sendInvoiceRequestType>'
             '<senderID>' mv_company_taxid '</senderID>'
             '<receiverID>' iv_receiver_taxid '</receiverID>'
             '<docType>XML</docType>'
             '<fileName>' lv_file_name '</fileName>'
             '<hash>' lv_hash '</hash>'
             '<binaryData>' lv_invoice_base64 '</binaryData>'
             '<customizationParams>'
                '<paramName>BRANCH</paramName>'
                '<paramValue>default</paramValue>'
             '</customizationParams>'
             '<responsiveOutput>'
                '<outputType>PDF</outputType>'
             '</responsiveOutput>'
          '</inv:sendInvoiceRequestType>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'sendInvoice'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'Result'.
          IF ls_xml_line-cvalue EQ 'FAIL'.
            READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ErrorDesc'.
            IF sy-subrc EQ 0.
              lv_message = ls_xml_line-cvalue.
            ENDIF.
            lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                              iv_msgv1 = lv_message(50)
                                                                              iv_msgv2 = lv_message+50(50)
                                                                              iv_msgv3 = lv_message+100(50)
                                                                              iv_msgv4 = lv_message+150(50) ).
            RAISE EXCEPTION lx_exception.
          ENDIF.
        WHEN 'UUID'.
          ev_invoice_uuid = ls_xml_line-cvalue.
          ev_integrator_uuid = ls_xml_line-cvalue.
        WHEN 'InvoiceNumber'.
          ev_invoice_no = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.