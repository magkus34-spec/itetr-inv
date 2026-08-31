class /ITETR/CL_EARCHIVE_WS_HTK definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  create public .

public section.

  methods GET_TOKEN
    returning
      value(RV_TOKEN) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods UTILENCRYPT
    exporting
      !EV_CRUSER type STRING
      !EV_CRPSW type STRING
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

  methods RUN_SERVICE_REST
    importing
      !IV_BODY type STRING
      !IT_REQUEST_HEADER type MTY_SERVICE_HEADER_TAB optional
      !IV_URL type STRING
      !IV_METHOD type STRING optional
    returning
      value(RV_RESPONSE) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
private section.
ENDCLASS.



CLASS /ITETR/CL_EARCHIVE_WS_HTK IMPLEMENTATION.


  method DOWNLOAD_REGISTERED_TAXPAYERS.
  endmethod.


  method GET_INCOMING_ARCHIVES.
  endmethod.


  METHOD get_token.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_result,
              token TYPE string.
    TYPES END OF ty_result.

    DATA: lv_body               TYPE string,
          lv_response           TYPE string,
          lt_request_header     TYPE mty_service_header_tab,
          lv_base64_content     TYPE string,
          lv_zipped_file        TYPE xstring,
          lt_xml_table          TYPE TABLE OF smum_xmltb,
          ls_xml_line           TYPE smum_xmltb,
          lv_taxpayers_xml      TYPE string,
          ls_taxpayer           TYPE /itetr/inv_taxp,
          ls_user_list          TYPE /itetr/inv_s_userlist,
          ls_user               TYPE /itetr/inv_s_user,
          ls_documents          TYPE /itetr/inv_s_userlist_doc,
          ls_alias              TYPE /itetr/inv_s_userlist_alias,
          ls_company_parameters TYPE /itetr/inv_einp,
          lx_exception          TYPE REF TO /itetr/cx_regulative_exception,
          lv_cruser             TYPE string,
          lv_crpsw              TYPE string,
          lt_result             TYPE TABLE OF ty_result,
          ls_result             TYPE ty_result,
          lv_url                TYPE string.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.


    CALL METHOD me->utilencrypt
      IMPORTING
        ev_cruser = lv_cruser
        ev_crpsw  = lv_crpsw.

    CONCATENATE '{ "apiKey": "' ms_company_parameters-apikey '", "username": "' lv_cruser '", "password": "' lv_crpsw '" }' INTO lv_body.


*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Content-Type'.
*    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_url = ms_company_parameters-wsend && 'Login'.

    lv_response = run_service_rest( iv_body        = lv_body
                                        iv_url            = lv_url
                                        iv_method         = 'POST'
                                        it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                         pretty_name = 'X'
                               CHANGING  data        = lt_result ).
    READ TABLE lt_result INTO ls_result INDEX 1.
    IF sy-subrc EQ 0.
      rv_token = ls_result-token.
    ENDIF.






  ENDMETHOD.


  METHOD incoming_archive_download.
  ENDMETHOD.


  METHOD outgoing_invoice_cancel.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_result ,
              issucceeded TYPE string,
              message     TYPE string.
    TYPES END OF ty_result.

    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response       TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lv_token          TYPE string,
          lv_body           TYPE string,
          lv_url            TYPE string,
          ls_result         TYPE ty_result,
          lv_message        TYPE bapi_msg,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception.

    DATA: BEGIN OF ls_data,
            documentuuid TYPE string,
            cancelreason TYPE string,
            apptype      TYPE string,
            canceldate   TYPE string,
          END OF ls_data.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.


    lv_token = get_token( ).

    ls_data-apptype        = '3'.
    ls_data-documentuuid   = is_document_numbers-duich.
    ls_data-CancelReason   = ''.
    ls_data-CancelDate     = sy-datum.

    lv_body = /ui2/cl_json=>serialize( data         = ls_data
                                       pretty_name  = 'X'
                                     ).


    "lv_url = 'https://econnecttest.hizliteknxoloji.com.tr/HizliApi/RestApi/CancelDocument' .
    lv_url = ms_company_parameters-wsend && 'CancelDocument' .

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response     = run_service_rest( iv_body           = lv_body
                                        iv_url            = lv_url
                                        iv_method         = 'POST'
                                        it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                         pretty_name = 'X'
                               CHANGING  data        = ls_result ).

    IF ls_result-issucceeded EQ 'false'.
      lv_message   = ls_result-message.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

ENDMETHOD.


  METHOD outgoing_invoice_download.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_result,
              documentfile TYPE string.
    TYPES END OF ty_result.

    DATA: lv_request_xml      TYPE string,
          lv_response         TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_content          TYPE string,
          lv_zipped_file      TYPE xstring,
          lv_body             TYPE string,
          lv_url              TYPE string,
          lv_apptype          TYPE string,
          lv_uuid             TYPE string,
          lv_tur              TYPE string,
          lv_isdraft          TYPE string,
          lv_token            TYPE string,
          lt_request_header   TYPE mty_service_header_tab,
          ls_result           TYPE ty_result,
          lv_base64_content   TYPE string,
          lv_output           TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    lv_token   = get_token( ).

    lv_apptype = '3'.
    lv_uuid    = is_document_numbers-duich.
    lv_tur     = iv_content_type.
    lv_isdraft = 'false'.

    lv_url     = ms_company_parameters-wsend && 'GetDocumentFile' &&
                 '?AppType=' && lv_apptype &&
                 '&Uuid='    && lv_uuid &&
                 '&Tur='     && lv_tur &&
                 '&IsDraft=' && lv_apptype.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response  = run_service_rest( iv_body              = lv_body
                                        iv_url            = lv_url
                                        iv_method         = 'GET'
                                        it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json    = lv_response
                                     pretty_name = 'X'
                           CHANGING  data        = ls_result ).

    IF ls_result-documentfile IS NOT INITIAL.
      lv_base64_content = ls_result-documentfile.
    ENDIF.

    lv_content = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).
    rv_invoice_data = lv_content.
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
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES: BEGIN OF ty_data,
             apptype               TYPE string,
             sourceurn             TYPE string,
             destinationidentifier TYPE string,
             destinationurn        TYPE string,
             xmlcontent            TYPE string,
             documentuuid          TYPE string,
             documentid            TYPE string,
             documentdate          TYPE string,
             localid               TYPE string,
             updatedocument        TYPE string,
             isdraft               TYPE string,
             isdraftsend           TYPE string,
           END OF ty_data.

    TYPES : BEGIN OF ty_result,
              IsSucceeded TYPE boolean_flg,
              message     TYPE char600.
    TYPES END OF ty_result.

    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response       TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lv_token          TYPE string,
          lv_body           TYPE string,
          lv_url            TYPE string,
          lt_data           TYPE TABLE OF ty_data,
          ls_data           TYPE  ty_data,
          lv_invoice        TYPE string,
          lv_documentid     TYPE char16,
          lv_documentuuid   TYPE string,
          lv_documentdate   TYPE char10,
          lt_result         TYPE TABLE OF ty_result,
          ls_result         TYPE ty_result,
          lv_ubl_string     TYPE string.

    DATA: lx_exception TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.


    CALL FUNCTION 'CRM_IC_XML_XSTRING2STRING'
      EXPORTING
        inxstring = iv_ubl_xstring
      IMPORTING
        outstring = lv_invoice.
    .
    FIND REGEX '<cbc:ID>(.*)</cbc:ID>'               IN lv_invoice SUBMATCHES lv_documentid.
    FIND REGEX '<cbc:UUID>(.*)</cbc:UUID>'           IN lv_invoice SUBMATCHES lv_documentuuid.
    FIND REGEX '<cbc:IssueDate>(.*)</cbc:IssueDate>' IN lv_invoice SUBMATCHES lv_documentdate.


    lv_ubl_string = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = iv_ubl_xstring ).
    REPLACE ALL OCCURRENCES OF '<cbc:UBLVersionID>' IN lv_ubl_string WITH '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent><auto-generated-wildcard /></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.

    lv_token = get_token( ).

    ls_data-apptype               = '3'.                             " 2 : e-Fatura, 3 :e-Arşiv , 5 : e-İrsaliye , 6 : e-Serbest Meslek Makbuzu , 7 : e-Müstahsil Makbuzu , 11:e-Döviz Belgesi , 12:e-Adisyon Belgesi
*    ls_data-sourceurn             = ms_company_parameters-gb_alias.  " SatıcıGB Adresi
    ls_data-destinationidentifier = iv_receiver_taxid.               " Alıcı Vergi Kimlik No
    ls_data-destinationurn        = iv_receiver_alias.               " Alıcı PK Adresi
    ls_data-xmlcontent            = lv_ubl_string.                   " xml_contenxt
    ls_data-documentuuid          = lv_documentuuid.                 " ETTN(e697232d-b057-d539-ebf8-bc3f78d02d65  )
    ls_data-documentid            = lv_documentid.
    ls_data-documentdate          = lv_documentdate.
    ls_data-localid               = lv_documentid.
    ls_data-updatedocument        = 'false'.
    ls_data-isdraft               = 'false'.
    ls_data-isdraftsend           = 'false'.

    APPEND ls_data TO lt_data.

    lv_body = /ui2/cl_json=>serialize( data         = lt_data
                                       pretty_name  = 'X'
                                      ).

    "lv_url = 'https://econnecttest.hizliteknoloji.com.tr/HizliApi/RestApi/SendDocument' .
    lv_url = ms_company_parameters-wsend && 'SendDocument' .

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response = run_service_rest( iv_body           = lv_body
                                    iv_url            = lv_url
                                    iv_method         = 'POST'
                                    it_request_header = lt_request_header ).


    /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                         pretty_name = 'X'
                               CHANGING  data        = lt_result ).

    READ TABLE lt_result INTO ls_result INDEX 1.
    IF ls_result-issucceeded EQ ''.

      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_result-message(50)
                                                                       iv_msgv2 = ls_result-message+50(50)
                                                                       iv_msgv3 = ls_result-message+100(50)
                                                                       iv_msgv4 = ls_result-message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.


  ENDMETHOD.


  METHOD run_service_rest.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    DATA: lo_http_client     TYPE REF TO if_http_client,
          lv_message         TYPE bapi_msg,
          lt_xml_table       TYPE TABLE OF smum_xmltb,
          ls_xml_line        TYPE smum_xmltb,
          lx_exception       TYPE REF TO /itetr/cx_regulative_exception,
          lv_endpoint        TYPE /itetr/com_e_wsend,
          lv_user            TYPE string,
          lv_password        TYPE string,
          lv_response_code   TYPE i,
          lv_response_reason TYPE string,
          lv_authorization   TYPE string,
          ls_request_header  TYPE /itetr/cl_einvoice_ws=>mty_service_header.


    CALL METHOD cl_http_client=>create_by_url
      EXPORTING
        url                = iv_url
      IMPORTING
        client             = lo_http_client
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    lo_http_client->request->set_header_field( name  = 'Accept'
                                               value = 'application/json' ).

    lo_http_client->request->set_header_field( name  = 'Content-Type'
                                               value = 'application/json' ).

    IF it_request_header IS NOT INITIAL.
      LOOP AT it_request_header INTO ls_request_header.
        lo_http_client->request->set_header_field( name  = ls_request_header-name
                                                   value = ls_request_header-value ).
      ENDLOOP.
    ENDIF.


    IF iv_method EQ 'POST'.
      CALL METHOD lo_http_client->request->set_method( if_http_request=>co_request_method_post ).
    ELSEIF iv_method EQ 'GET'.
      CALL METHOD lo_http_client->request->set_method( if_http_request=>co_request_method_get ).
    ENDIF.


    lo_http_client->request->set_cdata( data   = iv_body ).

    lo_http_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    lo_http_client->receive(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4 ).
    IF sy-subrc <> 0.
      rv_response = lo_http_client->response->get_cdata( ).
      REPLACE ALL OCCURRENCES OF REGEX '<[a-zA-Z\/][^>]*>' IN rv_response WITH space.
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN rv_response WITH ` `.
      lv_message = rv_response.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ELSE.
      rv_response = lo_http_client->response->get_cdata( ).
      IF rv_response IS INITIAL.
        lo_http_client->response->get_status(
          IMPORTING
            code   = lv_response_code
            reason = lv_response_reason ).
        WRITE lv_response_code TO lv_message LEFT-JUSTIFIED.
        CONCATENATE lv_message lv_response_reason INTO lv_message SEPARATED BY '-'.
        lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                          iv_msgv1 = lv_message(50)
                                                                          iv_msgv2 = lv_message+50(50)
                                                                          iv_msgv3 = lv_message+100(50)
                                                                          iv_msgv4 = lv_message+150(50) ).
        RAISE EXCEPTION lx_exception.
      ELSE.
        lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( rv_response ).

        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'faultstring'.
              lv_message = ls_xml_line-cvalue.
              lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                                iv_msgv1 = lv_message(50)
                                                                                iv_msgv2 = lv_message+50(50)
                                                                                iv_msgv3 = lv_message+100(50)
                                                                                iv_msgv4 = lv_message+150(50) ).
              RAISE EXCEPTION lx_exception.
          ENDCASE.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lo_http_client IS BOUND.
      lo_http_client->close( ).
    ENDIF.
  ENDMETHOD.


  METHOD utilencrypt.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_result ,
              username TYPE string,
              password TYPE string.
    TYPES END OF ty_result.

    DATA: lv_body               TYPE string,
          lv_response           TYPE string,
          lt_request_header     TYPE mty_service_header_tab,
          lv_base64_content     TYPE string,
          lv_zipped_file        TYPE xstring,
          lt_xml_table          TYPE TABLE OF smum_xmltb,
          ls_xml_line           TYPE smum_xmltb,
          lv_taxpayers_xml      TYPE string,
          ls_taxpayer           TYPE /itetr/inv_taxp,
          ls_user_list          TYPE /itetr/inv_s_userlist,
          ls_user               TYPE /itetr/inv_s_user,
          ls_documents          TYPE /itetr/inv_s_userlist_doc,
          ls_alias              TYPE /itetr/inv_s_userlist_alias,
          ls_company_parameters TYPE /itetr/inv_einp,
          lx_exception          TYPE REF TO /itetr/cx_regulative_exception,
          lt_data               TYPE TABLE OF string,
          ls_result             TYPE ty_result,
          lv_url                TYPE string.

    CONCATENATE '{ "secretKey": "' ms_company_parameters-secretkey '", "username": "' ms_company_parameters-wsusr '", "password": "' ms_company_parameters-wspwd '" }' INTO lv_body.

    lv_url = ms_company_parameters-wsend && 'UtilEncrypt'.

    lv_response = run_service_rest( iv_body           = lv_body
                                    iv_url            = lv_url
                                    iv_method         = 'POST'
                                    it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                         pretty_name = 'X'
                               CHANGING  data        = ls_result ).

    ev_cruser = ls_result-username.
    ev_crpsw  = ls_result-password.

  ENDMETHOD.
ENDCLASS.