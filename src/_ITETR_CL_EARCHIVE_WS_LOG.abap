class /ITETR/CL_EARCHIVE_WS_LOG definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  create public .

public section.

  methods LOGIN
    exporting
      !EV_SESSIONID type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods LOGOUT
    importing
      !IV_SESSIONID type STRING
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
  methods OUTGOING_INVOICE_PREVIEW
    redefinition .
  methods OUTGOING_INVOICE_SEND
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /ITETR/CL_EARCHIVE_WS_LOG IMPLEMENTATION.


  method DOWNLOAD_REGISTERED_TAXPAYERS.
  endmethod.


  method GET_INCOMING_ARCHIVES.
  endmethod.


  method INCOMING_ARCHIVE_DOWNLOAD.
  endmethod.


  METHOD login.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 02, 2024 ---------------------------------------------*
*&---------------------------------------------------------------------*

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid     TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          ls_user_list      TYPE /itetr/inv_s_userlist,
          ls_user           TYPE /itetr/inv_s_user,
          ls_documents      TYPE /itetr/inv_s_userlist_doc,
          ls_alias          TYPE /itetr/inv_s_userlist_alias.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:efat="http://schemas.datacontract.org/2004/07/eFaturaWebService">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:Login>'
             '<tem:login>'
                '<efat:passWord>' me->ms_company_parameters-wspwd '</efat:passWord>'
                '<efat:userName>' me->ms_company_parameters-wsusr '</efat:userName>'
            ' </tem:login>'
          '</tem:Login>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/Login'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'sessionID'.
          CONCATENATE lv_sessionid ls_xml_line-cvalue INTO lv_sessionid.
      ENDCASE.
    ENDLOOP.

    IF lv_sessionid IS NOT INITIAL.
      ev_sessionid = lv_sessionid.
    ENDIF.

  ENDMETHOD.


  METHOD logout.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 02, 2024 ---------------------------------------------*
*&---------------------------------------------------------------------*

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid     TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          ls_user_list      TYPE /itetr/inv_s_userlist,
          ls_user           TYPE /itetr/inv_s_user,
          ls_documents      TYPE /itetr/inv_s_userlist_doc,
          ls_alias          TYPE /itetr/inv_s_userlist_alias.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:efat="http://schemas.datacontract.org/2004/07/eFaturaWebService">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:Logout>'
                ' <tem:sessionID>' iv_sessionid '</tem:sessionID>'
            ' </tem:Logout>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/Logout'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).



  ENDMETHOD.


  METHOD outgoing_invoice_cancel.

    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid      TYPE string,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_table          TYPE smum_xmltb,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception.

    DATA: lt_binary   TYPE solix_tab,
          lv_length   TYPE i,
          lv_zip_hash TYPE md5_fields-hash.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.



    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:efat="http://schemas.datacontract.org/2004/07/eFaturaWebService">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:SendDocument>'
             '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
             '<tem:paramList>'
                '<arr:string>DOCUMENTTYPE=CANCELEARCHIVEINVOICE</arr:string>'
                '<arr:string>UUID=' is_document_numbers-duich '</arr:string>'
             '</tem:paramList>'
             '<tem:document>'
                '<efat:binaryData>'
                '</efat:binaryData>'
             '</tem:document>'
          '</tem:SendDocument>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/SendDocument'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'resultCode'.
          IF ls_xml_line-cvalue NE 1.
            READ TABLE lt_xml_table INTO ls_table WITH KEY cname = 'resultMsg'.
            IF sy-subrc EQ 0.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                   iv_msgv1 = ls_table-cvalue(50)
                                                                   iv_msgv2 = ls_table-cvalue+50(50)
                                                                   iv_msgv3 = ls_table-cvalue+100(50)
                                                                   iv_msgv4 = ls_table-cvalue+150(50) ).
              RAISE EXCEPTION lx_exception.
            ENDIF.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


  METHOD outgoing_invoice_download.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 02, 2024 ---------------------------------------------*
*&---------------------------------------------------------------------*


    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid      TYPE string,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          lv_content        TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:getDocumentData>'
             '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
             '<tem:uuid>' is_document_numbers-duich '</tem:uuid>'
             '<tem:docType>EARCHIVE</tem:docType>'
             '<tem:dataType>' iv_content_type '</tem:dataType>'
          '</tem:getDocumentData>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/getDocumentData'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'Value'.
          CONCATENATE lv_content ls_xml_line-cvalue INTO lv_content.
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

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*

    rs_status-stacd = '5'.
  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_send.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, May 6, 2024 --- --------------------------------------------*
*&---------------------------------------------------------------------*

    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid      TYPE string,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_table          TYPE smum_xmltb,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception.

    DATA: lt_binary   TYPE solix_tab,
          lv_length   TYPE i,
          lv_zip_hash TYPE md5_fields-hash.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.

    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = iv_ubl_xstring
                                                                   iv_input_name = CONV #( iv_document_uuid  ) ).


    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_zipped_file
      IMPORTING
        output_length = lv_length
      TABLES
        binary_tab    = lt_binary.

    IF lt_binary IS NOT INITIAL.

      CALL FUNCTION 'MD5_CALCULATE_HASH_FOR_RAW'
        EXPORTING
          length         = lv_length
        IMPORTING
          hash           = lv_zip_hash
        TABLES
          data_tab       = lt_binary
        EXCEPTIONS
          internal_error = 1
          OTHERS         = 2.

    ENDIF.

    lv_file_name = iv_document_uuid && '.zip'.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:efat="http://schemas.datacontract.org/2004/07/eFaturaWebService">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:SendDocument>'
             '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
             '<tem:paramList>'
                '<arr:string>DOCUMENTTYPE=EARCHIVE</arr:string>'
                '<arr:string>ALIAS=' iv_receiver_alias '</arr:string>'
             '</tem:paramList>'
             '<tem:document>'
                '<!--Optional:-->'
                '<efat:binaryData>'
                   '<!--Optional:-->'
                   '<efat:Value>' lv_invoice_base64 '</efat:Value>'
                   '<efat:contentType>base64</efat:contentType>'
                '</efat:binaryData>'
                '<!--Optional:-->'
                '<efat:currentDate>' sy-datum(4) '-' sy-datum+4(2) '-' sy-datum+6(2) '</efat:currentDate>'
                '<efat:fileName>' lv_file_name '</efat:fileName>'
                '<efat:hash>' lv_zip_hash '</efat:hash>'
             '</tem:document>'
          '</tem:SendDocument>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/SendDocument'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'resultCode'.
          IF ls_xml_line-cvalue NE 1.
            READ TABLE lt_xml_table INTO ls_table WITH KEY cname = 'resultMsg'.
            IF sy-subrc EQ 0.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                   iv_msgv1 = ls_table-cvalue(50)
                                                                   iv_msgv2 = ls_table-cvalue+50(50)
                                                                   iv_msgv3 = ls_table-cvalue+100(50)
                                                                   iv_msgv4 = ls_table-cvalue+150(50) ).
              RAISE EXCEPTION lx_exception.
            ENDIF.
          ENDIF.
        WHEN 'refId'.
          ev_integrator_uuid = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.
ENDCLASS.