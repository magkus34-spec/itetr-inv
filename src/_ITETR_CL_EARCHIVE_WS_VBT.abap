class /ITETR/CL_EARCHIVE_WS_VBT definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  final
  create public .

public section.

  types:
    BEGIN OF mty_http_request_header.
    TYPES name  TYPE string.
    TYPES value TYPE string.
    TYPES rtype TYPE char1. "q:query h:header
    TYPES END OF mty_http_request_header .
  types:
    mty_http_request_header_t TYPE TABLE OF mty_http_request_header .

  methods GET_TOKEN
    returning
      value(RV_TOKEN) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods RUN_SERVICE_REST
    importing
      !IV_BODY type STRING
      !IV_API type STRING
      !IV_METHOD type STRING
      !IV_ZIPPED type XFELD optional
      !IT_REQUEST_HEADER type MTY_HTTP_REQUEST_HEADER_T optional
      !IV_USE_ALTERNATIVE_ENDPOINT type XFELD optional
    returning
      value(RV_RESPONSE) type STRING
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



CLASS /ITETR/CL_EARCHIVE_WS_VBT IMPLEMENTATION.


  method DOWNLOAD_REGISTERED_TAXPAYERS.
  endmethod.


  method GET_INCOMING_ARCHIVES.
  endmethod.


  METHOD get_token.

    TYPES : BEGIN OF ty_result,
              token TYPE string.
    TYPES END OF ty_result.

    TYPES : BEGIN OF ty_json,
              errorcode TYPE string,
              message   TYPE string.
    TYPES END OF ty_json.

    DATA: lv_body               TYPE string,
          lv_response           TYPE string,
          lt_request_header     TYPE mty_http_request_header_t,
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
          lv_url                TYPE string,
          ls_result             TYPE ty_result,
          ls_json               TYPE ty_json,
          lv_message            TYPE bapi_msg.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    CONCATENATE '{"Email": "' ms_company_parameters-wsusr '","Password": "' ms_company_parameters-wspwd '"}' INTO lv_body.

    lv_response = run_service_rest( iv_body    = lv_body
                                    iv_api     = '/api/Account/Token'
                                    iv_method  = 'POST' ).

    /ui2/cl_json=>deserialize( EXPORTING  json        = lv_response
                                          pretty_name = 'X'
                               CHANGING   data        = ls_result ).

    IF ls_result-token IS NOT INITIAL.
      rv_token = ls_result-token.
    ELSE.
      /ui2/cl_json=>deserialize( EXPORTING  json        = lv_response
                                            pretty_name = 'X'
                                 CHANGING   data        = ls_json ).

      CONCATENATE ls_json-errorcode '-' ls_json-message INTO lv_message SEPARATED BY space.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.

    ENDIF.
  ENDMETHOD.


  method INCOMING_ARCHIVE_DOWNLOAD.
  endmethod.


  METHOD outgoing_invoice_cancel.

    TYPES: BEGIN OF ty_result,
             refreshtoken TYPE string,
             data         TYPE string,
           END OF ty_result.

    TYPES: BEGIN OF ty_detail,
             stacktrace      TYPE string,
             type            TYPE string,
             innerexceptions TYPE string,
           END OF ty_detail.

    TYPES: BEGIN OF ty_error,
             type      TYPE i,
             type_desc TYPE string,
             errorcode TYPE string,
             message   TYPE string,
             detail    TYPE ty_detail,
           END OF ty_error.

    DATA: lv_body           TYPE string,
          lv_response       TYPE string,
          lt_request_header TYPE mty_http_request_header_t,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_file_name      TYPE string,
          lv_url            TYPE string,
          lv_apptype        TYPE string,
          lv_type           TYPE string,
          lv_token          TYPE string,
          lv_unzipped_data  TYPE xstring,
          lt_binary_data    TYPE solix_tab,
          lv_json_data      TYPE string,
          lv_invoice_base64 TYPE string,
          lv_input          TYPE string,
          lv_message        TYPE bapi_msg,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          ls_int_status     TYPE /itetr/inv_inst,
          ls_result         TYPE ty_result,
          ls_error          TYPE ty_error.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.

    lv_input = '{"InvoiceExternalId": "' && is_document_numbers-docii && '","EArchiveStatus": 2,"EArchiveCancelDescription": "FATURA TERS KAYIT"}'.


    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/VbtApi/CancelOutgoingEArchiveInvoice' ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                pretty_name = 'X'
                              CHANGING data = ls_result ).

    IF ls_result-data NE abap_true.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                           pretty_name = 'X'
                                CHANGING   data = ls_error ).

      lv_message = ls_error-message.

      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.

    ENDIF.


  ENDMETHOD.


 METHOD outgoing_invoice_download.



   TYPES: BEGIN OF ty_pdf,
            invoicepdffilebytes TYPE string,
          END OF ty_pdf.

   TYPES: BEGIN OF ty_json_pdf,
            refreshtoken TYPE string,
            data         TYPE ty_pdf,
          END OF ty_json_pdf.

   TYPES: BEGIN OF ty_html,
            invoicehtmlview TYPE string,
          END OF ty_html.

   TYPES: BEGIN OF ty_json_html,
            refreshtoken TYPE string,
            data         TYPE ty_html,
          END OF ty_json_html.

   TYPES: BEGIN OF ty_ubl,
            outgoinginvoicexmllist TYPE string,
          END OF ty_ubl.

   TYPES: BEGIN OF ty_json_ubl,
            refreshtoken TYPE string,
            data         TYPE ty_ubl,
          END OF ty_json_ubl.

   DATA: lv_body           TYPE string,
         lv_response       TYPE string,
         lt_request_header TYPE mty_http_request_header_t,
         lv_base64_content TYPE string,
         lv_zipped_file    TYPE xstring,
         lt_xml_table      TYPE TABLE OF smum_xmltb,
         ls_xml_line       TYPE smum_xmltb,
         lv_file_name      TYPE string,
         lv_url            TYPE string,
         lv_apptype        TYPE string,
         lv_type           TYPE string,
         lv_token          TYPE string,
         lv_unzipped_data  TYPE xstring,
         lt_binary_data    TYPE solix_tab,
         lv_json_data      TYPE string,
         lv_invoice_base64 TYPE string,
         lv_input          TYPE string,
         ls_json_pdf       TYPE ty_json_pdf,
         ls_json_ubl       TYPE ty_json_ubl,
         ls_json_html      TYPE ty_json_html,
         lv_message        TYPE bapi_msg,
         lx_exception      TYPE REF TO /itetr/cx_regulative_exception.

   FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


   lv_token   = get_token( ).

   APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
   <ls_request_header>-name  = 'vbtauthorization'.
   <ls_request_header>-value = lv_token .
   <ls_request_header>-rtype = 'h'.


   CASE iv_content_type.
     WHEN /itetr/cl_regulative_archive=>mc_content_types-html.

       lv_input = '{"Ettn": "' && is_document_numbers-duich && '"}'.

       lv_response = me->run_service_rest(
                            EXPORTING
                              iv_method         = 'POST'
                              iv_body           = lv_input
                              it_request_header = lt_request_header
                              iv_api            = '/api/VbtApi/GetOutgoingInvoiceView' ).

       /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                            pretty_name = 'X'
                                   CHANGING data = ls_json_html ).

       rv_invoice_data = /itetr/cl_regulative_common=>convert_string_to_xstring( iv_input = ls_json_html-data-invoicehtmlview ).

     WHEN /itetr/cl_regulative_archive=>mc_content_types-pdf.

       lv_input = '{"InvoiceEttns": ["' && is_document_numbers-duich && '"]}'.
       lv_response = me->run_service_rest(
                            EXPORTING
                              iv_method         = 'POST'
                              iv_body           = lv_input
                              it_request_header = lt_request_header
                              iv_api            = '/api/VbtApi/GetOutgoingInvoicePdf' ).

       /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                     pretty_name = 'X'
                                CHANGING data = ls_json_pdf ).

       rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = ls_json_pdf-data-invoicepdffilebytes ).

     WHEN /itetr/cl_regulative_archive=>mc_content_types-ubl.

       lv_input = '{"InvoiceEttns": ["' && is_document_numbers-duich && '"]}'.

       lv_response = me->run_service_rest(
                    EXPORTING
                      iv_method         = 'POST'
                      iv_body           = lv_input
                      it_request_header = lt_request_header
                      iv_api            = '/api/VbtApi/GetOutgoingInvoiceXmlList' ).

       /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                    pretty_name = 'X'
                                 CHANGING data = ls_json_ubl ).

       lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = ls_json_ubl-data-outgoinginvoicexmllist ).
       /itetr/cl_regulative_common=>unzip_file_single(
         EXPORTING
           iv_zipped_file_xstr = lv_zipped_file
         IMPORTING
           ev_output_data_xstr = rv_invoice_data ).
   ENDCASE.

   IF rv_invoice_data IS INITIAL.
     lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
     RAISE EXCEPTION lx_exception.
   ENDIF.

 ENDMETHOD.


  METHOD outgoing_invoice_get_status.


    TYPES: BEGIN OF ty_result,
             accountingcustomerpartyname  TYPE string,
             accountingcustomervkntckn    TYPE string,
             actualrealizationdate        TYPE string,
             allowancetotalamount         TYPE string,
             channelcode                  TYPE string,
             documentcurrencycode         TYPE string,
             envelopeid                   TYPE string,
             envelopestatus               TYPE string,
             firmid                       TYPE string,
             firmname                     TYPE string,
             gcbregistrationnumber        TYPE string,
             gtbreferencenumber           TYPE string,
             id                           TYPE string,
             invoiceexternalid            TYPE string,
             invoicenumber                TYPE string,
             invoicetypecode              TYPE string,
             isdeleted                    TYPE string,
             isprinted                    TYPE string,
             issuedate                    TYPE string,
             lineextensionamount          TYPE string,
             locationcode                 TYPE string,
             firmbranchcode               TYPE string,
             outgoingdate                 TYPE string,
             outgoinginvoicestatus        TYPE string,
             outgoinginvoicestatusforuser TYPE string,
             payableamount                TYPE string,
             profileid                    TYPE string,
             receiveridentifier           TYPE string,
             sqlid                        TYPE string,
             taxexclusiveamount           TYPE string,
             taxinclusiveamount           TYPE string,
             taxtotalamount               TYPE string,
             trycount                     TYPE string,
             trycountdescription          TYPE string,
             uuid                         TYPE string,
             orderreferenceno             TYPE string,
             withholdingtaxtotalamount    TYPE string,
             mailto                       TYPE string,
             dateposted                   TYPE string,
             erpnotificationstatus        TYPE string,
             erpprocessbranch             TYPE string,
             erpprocessdate               TYPE string,
             erpprocessuserid             TYPE string,
             iserpprocessed               TYPE string,
             isread                       TYPE string,
             isreaddate                   TYPE string,
             isarchived                   TYPE string,
             archivedate                  TYPE string,
             archiveuser                  TYPE string,
             archivestatus                TYPE string,
           END OF ty_result.

    TYPES: tt_results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES: BEGIN OF ty_data,
             total   TYPE i,
             results TYPE tt_results,
           END OF ty_data.

    TYPES: BEGIN OF ty_root,
             refreshtoken TYPE string,
             data         TYPE ty_data,
           END OF ty_root.

    DATA: ls_root   TYPE ty_root,
          ls_result TYPE ty_result.


    DATA: lv_body           TYPE string,
          lv_response       TYPE string,
          lt_request_header TYPE mty_http_request_header_t,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_file_name      TYPE string,
          lv_url            TYPE string,
          lv_apptype        TYPE string,
          lv_type           TYPE string,
          lv_token          TYPE string,
          lv_unzipped_data  TYPE xstring,
          lt_binary_data    TYPE solix_tab,
          lv_json_data      TYPE string,
          lv_invoice_base64 TYPE string,
          lv_input          TYPE string,
          lv_message        TYPE bapi_msg,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          ls_int_status     TYPE /itetr/inv_inst.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.

    lv_input = '{"Query": {"InvoiceExternalId": "' && is_document_numbers-docii && '"},"Skip": 0,"Take": 1 }'.

    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/VbtApi/GetOutgoingInvoiceList' ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                  pretty_name = 'X'
                              CHANGING data = ls_root ).

    READ TABLE ls_root-data-results INTO ls_result INDEX 1.
    IF sy-subrc EQ 0.
      CASE ls_result-outgoinginvoicestatus.
        WHEN 'WaitingForSendingToGib'.
          rs_status-stacd = '1'.
*          rs_status-staex = TEXT-008.
        WHEN 'WaitingForSendingToGib'.
          rs_status-stacd = '1'.
*          rs_status-staex = TEXT-010.
        WHEN 'CouldNotSentToGib'.
          rs_status-stacd = '1'.
*          rs_status-staex = TEXT-011.
        WHEN 'SentToGib' OR 'Signed'.
          rs_status-stacd = '5'.
*          rs_status-staex = TEXT-012.
        WHEN 'GibFailed'.
          rs_status-stacd = '2'.
*          rs_status-staex = TEXT-013.
        WHEN 'GibReceived' .
          rs_status-stacd = '6'.
*          rs_status-staex = TEXT-014.
        WHEN 'GibCouldNotSendToParty' .
          rs_status-stacd = '6'.
*          rs_status-staex = TEXT-015.
        WHEN 'GibCouldNotSendToPartyAndEnd' .
          rs_status-stacd = '6'.
*          rs_status-staex = TEXT-016.
        WHEN 'SentToParty' .
          rs_status-stacd = '6'.
*          rs_status-staex = TEXT-017.
        WHEN 'PartyReturnedError'.
          rs_status-stacd = '7'.
*          rs_status-staex = TEXT-018.
        WHEN OTHERS.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
          RAISE EXCEPTION lx_exception.
      ENDCASE.
    ENDIF.




  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_send.
    TYPES: BEGIN OF ty_data,
             invoiceexternalid  TYPE string,
             receiveridentifier TYPE string,
             filebytes          TYPE string,
             iszipped           TYPE string,
             issigned           TYPE string,
             earchivemailto     TYPE string,
             mailto             TYPE string,
           END OF ty_data.

    TYPES: BEGIN OF ty_error,
             errorcode    TYPE string,
             errormessage TYPE string,
           END OF ty_error.

    TYPES: tt_error TYPE STANDARD TABLE OF ty_error WITH EMPTY KEY.

    TYPES: BEGIN OF ty_json,
             invoicenumber TYPE string,
             ettn          TYPE string,
             pdfurl        TYPE string,
             xmlurl        TYPE string,
             haserror      TYPE abap_bool,
             errors        TYPE tt_error,
           END OF ty_json.

    TYPES: BEGIN OF ty_root,
             refreshtoken TYPE string,
             data         TYPE ty_json,
           END OF ty_root.

    DATA: ls_root  TYPE ty_root,
          ls_error TYPE ty_error.


    DATA: lv_body           TYPE string,
          lv_response       TYPE string,
          lt_request_header TYPE mty_http_request_header_t,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_file_name      TYPE string,
          lv_url            TYPE string,
          lv_apptype        TYPE string,
          lv_type           TYPE string,
          lv_token          TYPE string,
          lv_unzipped_data  TYPE xstring,
          lt_binary_data    TYPE solix_tab,
          lv_json_data      TYPE string,
          ls_data           TYPE ty_data,
          lv_invoice_base64 TYPE string,
          lv_ubl_string     TYPE string,
          lv_ubl_xstring    TYPE xstring,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          lv_message        TYPE bapi_msg,
          lv_mail           TYPE string.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    lv_token   = get_token( ).


    lv_ubl_string = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = iv_ubl_xstring ).
    REPLACE ALL OCCURRENCES OF '<cbc:UBLVersionID>' IN lv_ubl_string WITH '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent><auto-generated-wildcard /></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.
    lv_ubl_xstring = /itetr/cl_regulative_common=>convert_string_to_xstring( iv_input = lv_ubl_string ).


    CONCATENATE is_ubl_structure-part1-uuid-base-base-content '.xml' INTO lv_file_name.
    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = lv_ubl_xstring
                                                                   iv_input_name = lv_file_name ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

    IF is_ubl_structure-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content IS NOT INITIAL.
      lv_mail = is_ubl_structure-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content.
    ENDIF.


    ls_data-invoiceexternalid      = iv_document_uuid.
    ls_data-receiveridentifier     = ''.
    ls_data-filebytes              = lv_invoice_base64.
    ls_data-iszipped               = 'true'.
    ls_data-issigned               = 'false'.
    ls_data-earchivemailto         = lv_mail.
    ls_data-mailto                 = ''.


    lv_body = /ui2/cl_json=>serialize( data         = ls_data
                                       pretty_name  = 'X'
                                     ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.

    lv_response = me->run_service_rest(  EXPORTING
                                   iv_method         = 'POST'
                                   iv_body           = lv_body
                                   it_request_header = lt_request_header
                                   iv_api            = '/api/VbtApi/AddOutgoingInvoiceByUbl' ).


    /ui2/cl_json=>deserialize( EXPORTING   json        = lv_response
                                           pretty_name = 'X'
                               CHANGING    data        = ls_root ).

    IF ls_root-data-haserror EQ abap_true.
      LOOP AT ls_root-data-errors INTO ls_error.
        CONCATENATE lv_message ls_error-errormessage INTO lv_message SEPARATED BY '-'.
      ENDLOOP.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ELSE."Basarılı
      IF ls_root-data-ettn IS NOT INITIAL.
        ev_invoice_uuid = ls_root-data-ettn.
      ENDIF.

      IF ls_root-data-invoicenumber IS NOT INITIAL.
        ev_invoice_no = ls_root-data-invoicenumber.
      ENDIF.
    ENDIF.

    ev_integrator_uuid = iv_document_uuid.

  ENDMETHOD.


  METHOD run_service_rest.
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
          lv_uri             TYPE string,
          ls_request_header  TYPE mty_http_request_header.

    IF iv_use_alternative_endpoint = abap_true.
      lv_endpoint = ms_company_parameters-wsena.
    ELSE.
      lv_endpoint = ms_company_parameters-wsend.
    ENDIF.


    cl_http_client=>create_by_destination(
      EXPORTING
        destination              = lv_endpoint
      IMPORTING
        client                   = lo_http_client
      EXCEPTIONS
        argument_not_found       = 1
        destination_not_found    = 2
        destination_no_authority = 3
        plugin_not_active        = 4
        internal_error           = 5
        OTHERS                   = 6  ).
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.


    lv_uri = iv_api.
    LOOP AT it_request_header INTO ls_request_header.
      CASE ls_request_header-rtype.
        WHEN 'q'.
          lv_uri = lv_uri && '?' && ls_request_header-name && '=' && ls_request_header-value.
        WHEN 'h'.
          lo_http_client->request->set_header_field( name = ls_request_header-name value = ls_request_header-value ).
      ENDCASE.
    ENDLOOP.
    lo_http_client->request->set_header_field( name = '~request_method' value = iv_method ).
    lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json; charset=utf-8' ).
    lo_http_client->request->set_header_field( name = '~request_uri' value = lv_uri ).

    IF iv_body IS NOT INITIAL.
      lo_http_client->request->set_cdata( data = iv_body offset = 0 length = strlen( iv_body ) ).
    ENDIF.


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
ENDCLASS.