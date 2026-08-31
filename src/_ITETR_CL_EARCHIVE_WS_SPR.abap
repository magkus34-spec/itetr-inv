class /ITETR/CL_EARCHIVE_WS_SPR definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  create public .

public section.

  methods GET_TOKEN
    returning
      value(RV_TOKEN) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_SEND_DRAFT
    importing
      !IV_INVOICE_UUID type /ITETR/COM_E_DUICH
    exporting
      !EV_ISAPPROVED type XFELD
      !EV_MESSAGE type /ITETR/COM_E_LONG_NOTE
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .

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



CLASS /ITETR/CL_EARCHIVE_WS_SPR IMPLEMENTATION.


  method DOWNLOAD_REGISTERED_TAXPAYERS.
  endmethod.


  method GET_INCOMING_ARCHIVES.
  endmethod.


  METHOD get_token.
*&---------------------------------------------------------------------*
*&Gülay Kadıoğlu ------------------------------------------------------*
*&November 05, 2025  --------------------------------------------------*
*&---------------------------------------------------------------------*

    DATA: ls_token            TYPE /itetr/com_token,
          ls_token_old        TYPE /itetr/com_token,
          lv_timestamp        TYPE timestamp,
          lv_expire_timestamp TYPE timestamp,
          lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_content          TYPE string,
          lv_zipped_file      TYPE xstring,
          lv_document_uuid    TYPE /itetr/com_e_duich,
          lv_alliass          TYPE string,
          lv_message          TYPE bapi_msg,
          lt_request_header   TYPE mty_service_header_tab,
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    SELECT SINGLE * FROM /itetr/com_token INTO ls_token_old WHERE client_id = sy-sysid AND
                                                                  intid = ms_company_parameters-intid.
    GET TIME STAMP FIELD lv_timestamp.

    "Token hâlâ geçerli mi?
    IF ls_token_old-expire_at IS NOT INITIAL AND
       ls_token_old-expire_at > lv_timestamp + 150. "son 5 dk kala degistirilir
      rv_token = ls_token_old-access_token.
      RETURN.
    ENDIF.

    IF  rv_token IS INITIAL.

      CALL FUNCTION 'ENQUEUE_/ITETR/ECOM_TKN'
        EXPORTING
          client_id      = sy-sysid
          intid          = ms_company_parameters-intid
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        rv_token = ls_token_old-access_token.
      ELSE.


        CONCATENATE
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:auth="http://wsdl.superentegrator.com/auth">'
          '<soapenv:Header/>'
            '<soapenv:Body>'
              '<auth:loginRequest>'
               '<CustomerIdentity>' mv_company_taxid   '</CustomerIdentity>'
               '<EMail>'  ms_company_parameters-wsusr  '</EMail>'
                 '<Password>' ms_company_parameters-wspwd '</Password>'
                 '<ClientType>WebService</ClientType>'
                 '</auth:loginRequest>'
                 '</soapenv:Body>'
                 '</soapenv:Envelope>'
                 INTO lv_request_xml.

        APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
        <ls_request_header>-name  = 'SOAPAction'.
        <ls_request_header>-value = 'Login'.
        APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
        <ls_request_header>-name  = 'Content-Type'.
        <ls_request_header>-value = 'text/xml; charset=utf-8'.
        APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
        <ls_request_header>-name  = 'Accept-Encoding'.
        <ls_request_header>-value = 'gzip,deflate'.

        lv_response_xml = run_service( iv_request = lv_request_xml
                                       it_request_header = lt_request_header
                                       iv_use_alternative_endpoint = abap_true ).

        lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'accessToken'.
        IF sy-subrc EQ 0.
          LOOP AT lt_xml_table INTO ls_xml_line.
            CASE ls_xml_line-cname.
              WHEN 'accessToken'.
                CONCATENATE rv_token
                    ls_xml_line-cvalue
                    INTO rv_token.
            ENDCASE.
          ENDLOOP.
        ELSE.
          lv_message = TEXT-001.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                            iv_msgv1 = lv_message(50)
                                                                            iv_msgv2 = lv_message+50(50)
                                                                            iv_msgv3 = lv_message+100(50)
                                                                            iv_msgv4 = lv_message+150(50) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.

        IF rv_token IS NOT INITIAL.

          "24 saat eklenir
          cl_abap_tstmp=>add(
            EXPORTING
              tstmp = lv_timestamp
              secs = 86400        " 24 saat = 24 * 60 * 60
            RECEIVING
              r_tstmp = lv_expire_timestamp ).

          ls_token-client_id = sy-sysid.
          ls_token-access_token = rv_token.
          ls_token-created_on = lv_timestamp.
          ls_token-expire_at = lv_expire_timestamp.
          ls_token-intid = ms_company_parameters-intid.
          MODIFY /itetr/com_token FROM ls_token.
          COMMIT WORK AND WAIT.
        ENDIF.

        CALL FUNCTION 'DEQUEUE_/ITETR/ECOM_TKN'
          EXPORTING
            client_id = sy-sysid
            intid     = ms_company_parameters-intid.

      ENDIF.
    ENDIF.



  ENDMETHOD.


  method INCOMING_ARCHIVE_DOWNLOAD.
  endmethod.


  METHOD outgoing_invoice_cancel.
    DATA: lv_invoice_base64    TYPE string,
          lv_request_xml       TYPE string,
          lv_response_xml      TYPE string,
          lv_zipped_file       TYPE xstring,
          lv_file_name         TYPE string,
          lt_request_header    TYPE mty_service_header_tab,
          ls_xml_line          TYPE smum_xmltb,
          lt_xml_table         TYPE TABLE OF smum_xmltb,
          lv_token             TYPE string,
          lv_message           TYPE bapi_msg,
          lx_exception         TYPE REF TO /itetr/cx_regulative_exception,
          ls_int_status        TYPE /itetr/inv_inst,
          lv_status_enum_value TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.


    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">'
   '<soapenv:Header>'
      '<ear:Authorization>' lv_token '</ear:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ear:AuthToken></ear:AuthToken>'
      '<ear:CancelInvoiceRequest>'
         '<EarchiveInvoiceUUID>' is_document_numbers-duich '</EarchiveInvoiceUUID>'
      '</ear:CancelInvoiceRequest>'
  ' </soapenv:Body>'
'</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'CancelInvoice'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusEnumValue'.
    IF sy-subrc EQ 0 and  ls_xml_line-cvalue NE '1'.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
        IF sy-subrc EQ 0.
          lv_message = ls_xml_line-cvalue .
        ENDIF.

        IF lv_message IS NOT INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                            iv_msgv1 = lv_message(50)
                                                                            iv_msgv2 = lv_message+50(50)
                                                                            iv_msgv3 = lv_message+100(50)
                                                                            iv_msgv4 = lv_message+150(50) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_invoice_base64    TYPE string,
          lv_request_xml       TYPE string,
          lv_response_xml      TYPE string,
          lv_zipped_file       TYPE xstring,
          lv_file_name         TYPE string,
          lt_request_header    TYPE mty_service_header_tab,
          ls_xml_line          TYPE smum_xmltb,
          lt_xml_table         TYPE TABLE OF smum_xmltb,
          lv_token             TYPE string,
          lv_message           TYPE bapi_msg,
          lx_exception         TYPE REF TO /itetr/cx_regulative_exception,
          ls_int_status        TYPE /itetr/inv_inst,
          lv_status_enum_value TYPE string,
          lv_output_type       TYPE /itetr/com_e_conty,
          lv_content           TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.

    CASE iv_content_type.
      WHEN 'UBL'.
        lv_output_type  = 'Ubl'.
      WHEN 'PDF'.
        lv_output_type  = 'Pdf'.
      WHEN 'HTML'.
        lv_output_type  = 'Html'.
    ENDCASE.


    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">'
   '<soapenv:Header>'
      '<ear:Authorization>' lv_token '</ear:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ear:AuthToken></ear:AuthToken>'
      '<ear:GetDocumentRequest>'
         '<InvoiceNumber></InvoiceNumber>'
         '<InvoiceUUID>' is_document_numbers-duich '</InvoiceUUID>'
         '<OutputType>' lv_output_type '</OutputType>'
         '<IncludeInvoiceBinaryData>true</IncludeInvoiceBinaryData>'
        ' <CompressedBinaryData>true</CompressedBinaryData>'
         '<MappingCode></MappingCode>'
      '</ear:GetDocumentRequest>'
  '</soapenv:Body>'
'</soapenv:Envelope>'
      INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetDocument'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusEnumValue'
                                                       hier = '4'.
    IF sy-subrc EQ 0 and  ls_xml_line-cvalue EQ '1'.

        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'Data'.
              CONCATENATE lv_content
                  ls_xml_line-cvalue
                  INTO lv_content.
          ENDCASE.
        ENDLOOP.
        IF lv_content IS NOT INITIAL.
          lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
          /itetr/cl_regulative_common=>unzip_file_single(
            EXPORTING
              iv_zipped_file_xstr = lv_zipped_file
            IMPORTING
              ev_output_data_xstr = rv_invoice_data ).
        ENDIF.

      ELSE.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
        IF sy-subrc EQ 0.
          lv_message = ls_xml_line-cvalue .
        ENDIF.

        IF lv_message IS NOT INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                            iv_msgv1 = lv_message(50)
                                                                            iv_msgv2 = lv_message+50(50)
                                                                            iv_msgv3 = lv_message+100(50)
                                                                            iv_msgv4 = lv_message+150(50) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDIF.


  ENDMETHOD.


  METHOD outgoing_invoice_get_status.

    rs_status-stacd = '5'.

***    DATA: lv_invoice_base64    TYPE string,
***          lv_request_xml       TYPE string,
***          lv_response_xml      TYPE string,
***          lv_zipped_file       TYPE xstring,
***          lv_file_name         TYPE string,
***          lt_request_header    TYPE mty_service_header_tab,
***          ls_xml_line          TYPE smum_xmltb,
***          lt_xml_table         TYPE TABLE OF smum_xmltb,
***          lv_token             TYPE string,
***          lv_message           TYPE bapi_msg,
***          lx_exception         TYPE REF TO /itetr/cx_regulative_exception,
***          ls_int_status        TYPE /itetr/inv_inst,
***          lv_status_enum_value TYPE string.
***
***
***    CALL METHOD me->get_token
***      RECEIVING
***        rv_token = lv_token.
***
***    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.
***
***
***    CONCATENATE
***'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">'
***   '<soapenv:Header>'
***      '<ear:Authorization>' lv_token '</ear:Authorization>'
***   '</soapenv:Header>'
***   '<soapenv:Body>'
***      '<ear:AuthToken></ear:AuthToken>'
***      '<ear:GetInvoiceStatusRequest>'
***         '<UUID>' is_document_numbers-duich '</UUID>'
***      '</ear:GetInvoiceStatusRequest>'
***   '</soapenv:Body>'
***'</soapenv:Envelope>'
***              INTO lv_request_xml.
***
***    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
***    <ls_request_header>-name  = 'SOAPAction'.
***    <ls_request_header>-value = 'GetInvoiceStatus'.
***    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
***    <ls_request_header>-name  = 'Content-Type'.
***    <ls_request_header>-value = 'text/xml; charset=utf-8'.
***    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
***    <ls_request_header>-name  = 'Accept-Encoding'.
***    <ls_request_header>-value = 'gzip,deflate'.
***
***    lv_response_xml = run_service( iv_request = lv_request_xml
***                                   iv_authenticate = abap_true
***                                   it_request_header = lt_request_header ).
***
***    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
***
***
***    LOOP AT lt_xml_table INTO ls_xml_line.
***      CASE ls_xml_line-cname.
***        WHEN 'InvoiceUUID'.
***          rs_status-invui = ls_xml_line-cvalue.
***        WHEN 'DocumentId'.
***          rs_status-invno = ls_xml_line-cvalue.
***      ENDCASE.
***    ENDLOOP.


  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_send.
    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lv_token          TYPE string,
          lv_message        TYPE bapi_msg,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          lv_enum_value     TYPE string,
          lv_isapproved     TYPE xfeld,
          lv_msg            TYPE /itetr/com_e_long_note,
          lv_internet_sale  TYPE char5,
          lv_earchive_type  TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.



    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.


    CONCATENATE is_ubl_structure-part1-uuid-base-base-content '.xml' INTO lv_file_name.
    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = iv_ubl_xstring
                                                                   iv_input_name = lv_file_name ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

    CASE iv_internet_sale.
      WHEN abap_false.
        lv_internet_sale = 'false'.
      WHEN abap_true.
        lv_internet_sale = 'true'.
    ENDCASE.

    IF iv_earchive_type  IS NOT INITIAL.
      lv_earchive_type = iv_earchive_type .
    ELSE.
      lv_earchive_type = 'ELEKTRONIK'.
    ENDIF.

    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">'
   '<soapenv:Header>'
      '<ear:Authorization>' lv_token '</ear:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ear:AuthToken></ear:AuthToken>'
      '<ear:SendEArchiveInvoiceRequest>'
         '<SendingType>' lv_earchive_type '</SendingType>'
          '<ErpReferenceId></ErpReferenceId> '
          '<CustomerBranchCode></CustomerBranchCode> '
          '<MappingCode></MappingCode> '
          '<InvoiceIdPrefix></InvoiceIdPrefix> '
          '<XsltCode></XsltCode> '
          '<InvoiceData>' lv_invoice_base64 '</InvoiceData>'
          '<IsOnlineSale>' lv_internet_sale '</IsOnlineSale>'
          '<IncludeDocumentData>false</IncludeDocumentData> '
       '</ear:SendEArchiveInvoiceRequest> '
    '</soapenv:Body> '
 '</soapenv:Envelope> '
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'SendDocument'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusEnumValue'.
    IF sy-subrc EQ 0.
      IF ls_xml_line-cvalue EQ '0' OR ls_xml_line-cvalue EQ '1'.
        lv_enum_value = ls_xml_line-cvalue.
        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'InvoiceId'.
              ev_invoice_no = ls_xml_line-cvalue.
            WHEN 'InvoiceUUID'.
              ev_invoice_uuid = ls_xml_line-cvalue.
          ENDCASE.
        ENDLOOP.

****        IF  lv_enum_value EQ '1' AND ev_invoice_uuid IS NOT INITIAL. "taslak olarak kaydedilen belge gönderimi
****          CALL METHOD me->outgoing_invoice_send_draft
****            EXPORTING
****              iv_invoice_uuid = ev_invoice_uuid
****            IMPORTING
****              ev_isapproved   = lv_isapproved
****              ev_message      = lv_msg.
****        ENDIF.

      ELSE.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDetails'.
        IF sy-subrc EQ 0.
          lv_message = ls_xml_line-cvalue .
        ENDIF.

        IF lv_message IS NOT INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                            iv_msgv1 = lv_message(50)
                                                                            iv_msgv2 = lv_message+50(50)
                                                                            iv_msgv3 = lv_message+100(50)
                                                                            iv_msgv4 = lv_message+150(50) ).
          RAISE EXCEPTION lx_exception.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_send_draft.
    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lv_token          TYPE string,
          lv_message        TYPE bapi_msg,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          lv_enum_value     TYPE string.

   FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.

    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ear="http://wsdl.superentegrator.com/earchiveinvoice">'
   '<soapenv:Header>'
      '<ear:Authorization>' lv_token '</ear:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
     ' <ear:ApproveEArchiveInvoiceReqType>'
         '<InvoiceUUIDList>' iv_invoice_uuid  '</InvoiceUUIDList>'
      '</ear:ApproveEArchiveInvoiceReqType>'
      '<ear:AuthToken></ear:AuthToken>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'ApproveEArchiveInvoice'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'IsApproved'.
          ev_isapproved = ls_xml_line-cvalue.
        WHEN 'ResultMessage'.
          ev_message = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusEnumValue'.
    IF sy-subrc EQ 0 AND ls_xml_line-cvalue NE '1'.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
      IF sy-subrc EQ 0.
        lv_message = ls_xml_line-cvalue .
        CONCATENATE  lv_message '('  ev_message ')' INTO lv_message  SEPARATED BY space.
      ENDIF.

      IF lv_message IS NOT INITIAL.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                          iv_msgv1 = lv_message(50)
                                                                          iv_msgv2 = lv_message+50(50)
                                                                          iv_msgv3 = lv_message+100(50)
                                                                          iv_msgv4 = lv_message+150(50) ).
        RAISE EXCEPTION lx_exception.
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.