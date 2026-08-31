class /ITETR/CL_EINVOICE_WS_VBT definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
  final
  create public .

public section.

  types:
    BEGIN OF ty_detail,
        stacktrace      TYPE string,
        type            TYPE string,
        innerexceptions TYPE string,
      END OF ty_detail .
  types:
    BEGIN OF ty_error,
        type      TYPE i,
        type_desc TYPE string,
        errorcode TYPE string,
        message   TYPE string,
        detail    TYPE ty_detail,
      END OF ty_error .
  types MS_ERROR type TY_ERROR .
  types:
    BEGIN OF mty_http_request_header.
    TYPES name  TYPE string.
    TYPES value TYPE string.
    TYPES rtype TYPE char1. "q:query h:header
    TYPES END OF mty_http_request_header .
  types:
    mty_http_request_header_t TYPE TABLE OF mty_http_request_header .
  types:
    BEGIN OF mty_incoming_document,
        invoicenumber               TYPE string,
        profileid                   TYPE string,
        invoicetypecode             TYPE string,
        id                          TYPE string,
        sqlid                       TYPE string,
        incomingdate                TYPE string,
        firmid                      TYPE string,
        documentcurrencycode        TYPE string,
        accountingsupplierpartyname TYPE string,
        accountingsuppliervkntckn   TYPE string,
        issuedate                   TYPE string,
        lineextensionamount         TYPE string,
        taxexclusiveamount          TYPE string,
        taxinclusiveamount          TYPE string,
        allowancetotalamount        TYPE string,
        payableamount               TYPE string,
        envelopeid                  TYPE string,
        invoicestatusforuser        TYPE string,
        isprinted                   TYPE string,
        uuid                        TYPE string,
        taxtotalamount              TYPE string,
        withholdingtaxtotalamount   TYPE string,
        locationcode                TYPE string,
        invoicestatus               TYPE string,
        inworkflow                  TYPE string,
        lastapproveruser            TYPE string,
        calculationrate             TYPE string,
        erpprocessuserid            TYPE string,
        erpprocessdate              TYPE string,
        erpprocessbranch            TYPE string,
        iserpprocessed              TYPE string,
        isarchived                  TYPE string,
        archivedate                 TYPE string,
        archiveuser                 TYPE string,
        archivestatus               TYPE string,
        isread                      TYPE string,
        isreaddate                  TYPE string,
      END OF mty_incoming_document .
  types:
    mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .

  methods GET_TOKEN
    returning
      value(RV_TOKEN) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods RUN_SERVICE_REST
    importing
      !IV_BODY type STRING
      !IT_REQUEST_HEADER type MTY_HTTP_REQUEST_HEADER_T optional
      !IV_API type STRING
      !IV_METHOD type STRING
      !IV_ZIPPED type XFELD optional
      !IV_USE_ALTERNATIVE_ENDPOINT type XFELD optional
    returning
      value(RV_RESPONSE) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_INCOMING_INVOICES_INT
    importing
      !IV_DATE_FROM type BEGDA
      !IV_DATE_TO type ENDDA
    returning
      value(RT_INVOICES) type MTY_INCOMING_DOCUMENTS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods SET_INCOMING_INVOICE_RECEIVED
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DUICH
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .

  methods DOWNLOAD_REGISTERED_TAXPAYERS
    redefinition .
  methods DOWNLOAD_REGISTERED_TAXP_TIME
    redefinition .
  methods GET_INCOMING_INVOICES
    redefinition .
  methods INCOMING_INVOICE_DOWNLOAD
    redefinition .
  methods INCOMING_INVOICE_GET_STATUS
    redefinition .
  methods INCOMING_INVOICE_RESPONSE
    redefinition .
  methods OUTGOING_INVOICE_CANCEL
    redefinition .
  methods OUTGOING_INVOICE_DOWNLOAD
    redefinition .
  methods OUTGOING_INVOICE_GET_EXPORT
    redefinition .
  methods OUTGOING_INVOICE_GET_STATUS
    redefinition .
  methods OUTGOING_INVOICE_RESPONSE
    redefinition .
  methods OUTGOING_INVOICE_SEND
    redefinition .
  methods OUTGOING_INVOICE_SEND_AGAIN
    redefinition .
  methods OUTGOING_INVOICE_PREVIEW
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS_VBT IMPLEMENTATION.


  METHOD download_registered_taxpayers.

    TYPES: BEGIN OF ty_data,
             total             TYPE i,
             userlistfilebytes TYPE string,
           END OF ty_data.

    TYPES: BEGIN OF ty_json,
             refreshtoken TYPE string,
             data         TYPE ty_data,
           END OF ty_json.

    DATA: lv_body           TYPE string,
          lv_response       TYPE string,
          lt_request_header TYPE mty_http_request_header_t,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          ls_user_list      TYPE /itetr/inv_s_userlist,
          ls_user_list2     TYPE /itetr/inv_s_userlist,
          ls_user           TYPE /itetr/inv_s_user_vbt,
          ls_documents      TYPE /itetr/inv_user_doc_vbt,
          ls_alias          TYPE /itetr/inv_s_userlist_alias,
          lv_url            TYPE string,
          lv_apptype        TYPE string,
          lv_type           TYPE string,
          lv_token          TYPE string,
          ls_result         TYPE ty_json,
          lv_unzipped_data  TYPE xstring,
          lt_binary_data    TYPE solix_tab,
          lv_json_data      TYPE string,
          lv_length         TYPE i,
          lv_tag_name       TYPE string,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.


    lv_response = me->run_service_rest(  EXPORTING
                                       iv_method         = 'GET'
                                       iv_body           = ''
                                       it_request_header = lt_request_header
                                       iv_api            = '/api/VbtApi/GetGibInvoiceAllUserListZip' ).

    /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                         pretty_name = 'X'
                              CHANGING   data        = ls_result ).

    IF ls_result-data-userlistfilebytes IS NOT INITIAL.
      lv_base64_content = ls_result-data-userlistfilebytes .
    ENDIF.

    IF lv_base64_content IS INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '002' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).

    /itetr/cl_regulative_common=>unzip_file_single(
         EXPORTING
           iv_zipped_file_xstr = lv_zipped_file
         IMPORTING
           ev_output_data_xstr = lv_unzipped_data ).

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_unzipped_data
      IMPORTING
        output_length = lv_length
      TABLES
        binary_tab    = lt_binary_data.
    CALL FUNCTION 'SCMS_BINARY_TO_STRING'
      EXPORTING
        input_length = lv_length
      IMPORTING
        text_buffer  = lv_json_data
      TABLES
        binary_tab   = lt_binary_data
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc IS NOT INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
      RAISE EXCEPTION lx_exception.
    ELSE.
      DATA lt_user_list TYPE /itetr/inv_user_data_vbt.
      DATA: lv_deletion_date TYPE datum.
      DATA : lt_default_allias TYPE TABLE OF /itetr/inv_allis.
      SELECT * FROM /itetr/inv_allis INTO TABLE lt_default_allias .
      SORT lt_default_allias BY taxid aliass.


      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_data
                                           pretty_name = 'X'
                                 CHANGING data = lt_user_list ).

      LOOP AT lt_user_list-users INTO ls_user.
        CLEAR ls_taxpayer.
        CASE ls_user-type.
          WHEN 'OZEL'.
            ls_taxpayer-txpty = 'OZEL'.
          WHEN OTHERS.
            ls_taxpayer-txpty = 'KAMU'.
        ENDCASE.
        LOOP AT ls_user-documents INTO ls_documents WHERE type EQ 'Invoice'.
          LOOP AT ls_documents-aliases INTO ls_alias.
            IF ls_alias IS NOT INITIAL.
              REPLACE ALL OCCURRENCES OF '-' IN ls_alias-creationtime WITH ''.
              REPLACE ALL OCCURRENCES OF ':' IN ls_alias-creationtime WITH ''.
              REPLACE ALL OCCURRENCES OF '-' IN ls_alias-deletiontime WITH ''.
              REPLACE ALL OCCURRENCES OF ':' IN ls_alias-deletiontime WITH ''.
              ls_taxpayer-regdt = ls_alias-creationtime(8).
              ls_taxpayer-regtm = ls_alias-creationtime+9(6).
              CLEAR: lv_deletion_date.
              IF ls_alias-deletiontime IS NOT INITIAL.
                lv_deletion_date = ls_alias-deletiontime(8).
              ENDIF.
            ENDIF.

            IF lv_deletion_date LE sy-datum AND lv_deletion_date IS NOT INITIAL.
              CHECK 1 = 2.
            ENDIF.

            IF ls_alias-name IS NOT INITIAL.
              ls_taxpayer-aliass = ls_alias-name.
            ENDIF.
            ls_taxpayer-title = ls_user-title.
            ls_taxpayer-taxid = ls_user-identifier.

            READ TABLE lt_default_allias TRANSPORTING NO FIELDS WITH KEY taxid  = ls_taxpayer-taxid
                                                               aliass = ls_taxpayer-aliass  BINARY SEARCH.
            IF sy-subrc  IS INITIAL.
              ls_taxpayer-defal = 'X'.
            ENDIF.


            APPEND ls_taxpayer TO rt_list.
            CLEAR:ls_taxpayer-defal.
          ENDLOOP.
        ENDLOOP.
      ENDLOOP.
    ENDIF.




  ENDMETHOD.


  method DOWNLOAD_REGISTERED_TAXP_TIME.
  endmethod.


  METHOD get_incoming_invoices.
    DATA: lv_body             TYPE string,
          lv_response         TYPE string,
          lt_request_header   TYPE mty_http_request_header_t,
          lv_base64_content   TYPE string,
          lv_zipped_file      TYPE xstring,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          lv_file_name        TYPE string,
          lv_url              TYPE string,
          lv_apptype          TYPE string,
          lv_type             TYPE string,
          lv_token            TYPE string,
          lv_unzipped_data    TYPE xstring,
          lt_binary_data      TYPE solix_tab,
          lv_json_data        TYPE string,
          lv_invoice_base64   TYPE string,
          lv_input            TYPE string,
          lv_message          TYPE bapi_msg,
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception,
          ls_int_status       TYPE /itetr/inv_inst,
          lt_service_return   TYPE mty_incoming_documents,
          lv_invui            TYPE /itetr/com_e_duich,
          lx_root             TYPE REF TO cx_root,
          lv_content          TYPE xstring,
          ls_invoice          TYPE /itetr/com_message1,
          ls_document_numbers TYPE /itetr/com_s_document_numbers,
          ls_doc_ref          TYPE /itetr/com_despatch_document_r,
          ls_despatch         TYPE /itetr/inv_icdes,
          lv_extension        TYPE string,
          lv_uri              TYPE string,
          lv_digest           TYPE string,
          lv_offset           TYPE i,
          ls_ublextension     TYPE /itetr/com_ublextension,
          ls_departmant       TYPE /itetr/com_cmpdp.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header,
                   <ls_service_return> TYPE mty_incoming_document,
                   <ls_list>           TYPE /itetr/inv_icinv.



*    DO.
    CLEAR:lt_service_return.
    lt_service_return = get_incoming_invoices_int( iv_date_from = iv_date_from
                                                   iv_date_to = iv_date_to ).
*      IF lt_service_return IS INITIAL.
*        EXIT.
*      ELSE.


    SELECT SINGLE * FROM /itetr/com_cmpdp INTO ls_departmant WHERE defal = 'X'.

    LOOP AT lt_service_return ASSIGNING <ls_service_return>.
      TRY.
          APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.
          <ls_list>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
          <ls_list>-invui = <ls_service_return>-uuid.
          <ls_list>-invno = <ls_service_return>-invoicenumber.
          <ls_list>-invii = <ls_service_return>-sqlid.
          <ls_list>-envui = <ls_service_return>-envelopeid.
          <ls_list>-invqi = <ls_service_return>-id.
          <ls_list>-bukrs = ms_company_parameters-bukrs.
          <ls_list>-taxid = <ls_service_return>-accountingsuppliervkntckn.
          <ls_list>-title = <ls_service_return>-accountingsupplierpartyname.
          CONCATENATE  <ls_service_return>-issuedate+0(4) <ls_service_return>-issuedate+5(2) <ls_service_return>-issuedate+8(2) INTO <ls_list>-bldat.
          CONCATENATE  <ls_service_return>-incomingdate+0(4) <ls_service_return>-incomingdate+5(2) <ls_service_return>-incomingdate+8(2) INTO <ls_list>-recdt.
          <ls_list>-wrbtr = <ls_service_return>-payableamount.
          <ls_list>-dmbtr = <ls_service_return>-lineextensionamount.
          <ls_list>-waers = <ls_service_return>-documentcurrencycode.
          <ls_list>-allowance = <ls_service_return>-allowancetotalamount.
          <ls_list>-withholding = <ls_service_return>-withholdingtaxtotalamount.
          <ls_list>-fwste  = <ls_service_return>-taxtotalamount.


          ls_document_numbers-docui = <ls_list>-docui.
          ls_document_numbers-docii = <ls_list>-invii.
          ls_document_numbers-duich = <ls_list>-invui.
          ls_document_numbers-docno = <ls_list>-invno.
          ls_document_numbers-envui = <ls_list>-envui.

          lv_content = incoming_invoice_download(
           is_document_numbers = ls_document_numbers
           iv_content_type     = 'UBL' ).

          cl_proxy_xml_transform=>xml_xstring_to_abap(
            EXPORTING
              ddic_type                = '/ITETR/COM_MESSAGE1'
              xml                      = lv_content
              ext_xml                  = abap_true
            IMPORTING
              abap_data                = ls_invoice
                ).

          <ls_list>-orderid = ls_invoice-part1-order_reference-id-base-base-content.
          READ TABLE ls_invoice-part1-despatch_document_reference INTO ls_doc_ref INDEX 1.
          IF sy-subrc EQ 0.
            <ls_list>-despid = ls_doc_ref-id-base-base-content.
          ENDIF.

          CALL FUNCTION 'CONVERSION_EXIT_YYPRF_INPUT'
            EXPORTING
              input  = <ls_service_return>-profileid
            IMPORTING
              output = <ls_list>-prfid.

          CALL FUNCTION 'CONVERSION_EXIT_YYINT_INPUT'
            EXPORTING
              input  = <ls_service_return>-invoicetypecode
            IMPORTING
              output = <ls_list>-invty.

          <ls_list>-aprvd = abap_true.
          IF <ls_list>-prfid = 'TEMEL'.
            <ls_list>-resst = 'X'.
          ELSE.
            <ls_list>-resst = '0'.
          ENDIF.

        CATCH cx_root INTO lx_root.
          CLEAR <ls_list>-docui.
          lv_message = lx_root->get_text( ).
          CONCATENATE <ls_service_return>-invoicenumber ' Hata: ' lv_message INTO ev_message.
          CONTINUE.
      ENDTRY.

      TRY.
          <ls_list>-kursf = ls_invoice-part1-pricing_exchange_rate-calculation_rate-base-base-content.
        CATCH cx_root INTO lx_root.
          CLEAR <ls_list>-kursf.
      ENDTRY.

      READ TABLE ls_invoice-part1-ublextensions-ublextension INTO ls_ublextension INDEX 1.
      IF sy-subrc EQ 0.
        lv_extension = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = ls_ublextension-extension_content-any ).
        FIND REGEX 'URI="">(.*)' IN lv_extension SUBMATCHES lv_uri.
        IF lv_uri IS NOT INITIAL.
          FIND REGEX '<ds:DigestValue>(.*)' IN lv_uri SUBMATCHES lv_digest.
          IF lv_digest IS INITIAL.
            FIND REGEX '<DigestValue>(.*)' IN lv_uri SUBMATCHES lv_digest.
          ENDIF.
          IF lv_digest IS NOT INITIAL.
            FIND FIRST OCCURRENCE OF '</ds:DigestValue>' IN lv_digest MATCH OFFSET lv_offset.
            IF lv_offset IS INITIAL.
              FIND FIRST OCCURRENCE OF '</DigestValue>' IN lv_digest MATCH OFFSET lv_offset.
            ENDIF.
            IF lv_offset IS NOT INITIAL.
              <ls_list>-hashcode = lv_digest(lv_offset).
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR: lv_uri, lv_digest, lv_offset , ls_ublextension,lv_extension.

      SELECT SINGLE depcd
             FROM /itetr/inv_eidm
             INTO <ls_list>-depcd
           WHERE  bukrs = <ls_list>-bukrs
             AND  taxid = <ls_list>-taxid.
      IF ls_departmant-depcd IS NOT INITIAL AND <ls_list>-depcd IS INITIAL.
        <ls_list>-depcd = ls_departmant-depcd.
      ENDIF.

      SELECT SINGLE invui
         FROM /itetr/inv_icinv
         INTO lv_invui
        WHERE bukrs = ms_company_parameters-bukrs
          AND invui = <ls_list>-invui.
      IF sy-subrc NE 0.
        LOOP AT ls_invoice-part1-despatch_document_reference INTO ls_doc_ref.
          ADD 1 TO ls_despatch-line.
          ls_despatch-despid = ls_doc_ref-id-base-base-content.
          ls_despatch-docui  = <ls_list>-docui.
          INSERT /itetr/inv_icdes FROM ls_despatch.
          COMMIT WORK AND WAIT.
        ENDLOOP.

        <ls_list>-aprvd = abap_true.
        IF <ls_list>-wrbtr IS INITIAL.
          <ls_list>-procs = abap_true.
        ENDIF.
        INSERT /itetr/inv_icinv FROM <ls_list>.
        COMMIT WORK AND WAIT.
      ELSE.
        CLEAR <ls_list>-docui.
      ENDIF.
      set_incoming_invoice_received( <ls_list>-invui ).
    ENDLOOP.

*      ENDIF.
*    ENDDO.





  ENDMETHOD.


  METHOD get_incoming_invoices_int.

    TYPES: BEGIN OF ty_invoice_result,
             invoicenumber               TYPE string,
             profileid                   TYPE string,
             invoicetypecode             TYPE string,
             id                          TYPE string,
             sqlid                       TYPE string,
             incomingdate                TYPE string,
             firmid                      TYPE string,
             documentcurrencycode        TYPE string,
             accountingsupplierpartyname TYPE string,
             accountingsuppliervkntckn   TYPE string,
             issuedate                   TYPE string,
             lineextensionamount         TYPE string,
             taxexclusiveamount          TYPE string,
             taxinclusiveamount          TYPE string,
             allowancetotalamount        TYPE string,
             payableamount               TYPE string,
             envelopeid                  TYPE string,
             invoicestatusforuser        TYPE string,
             isprinted                   TYPE string,
             uuid                        TYPE string,
             taxtotalamount              TYPE string,
             withholdingtaxtotalamount   TYPE string,
             locationcode                TYPE string,
             invoicestatus               TYPE string,
             inworkflow                  TYPE string,
             lastapproveruser            TYPE string,
             calculationrate             TYPE string,
             erpprocessuserid            TYPE string,
             erpprocessdate              TYPE string,
             erpprocessbranch            TYPE string,
             iserpprocessed              TYPE string,
             isarchived                  TYPE string,
             archivedate                 TYPE string,
             archiveuser                 TYPE string,
             archivestatus               TYPE string,
             isread                      TYPE string,
             isreaddate                  TYPE string,
           END OF ty_invoice_result.

    TYPES: ty_t_invoice_results TYPE STANDARD TABLE OF ty_invoice_result WITH EMPTY KEY.

    TYPES: BEGIN OF ty_data,
             total   TYPE i,
             results TYPE ty_t_invoice_results,
           END OF ty_data.

    TYPES: BEGIN OF ty_response,
             refreshtoken TYPE string,
             data         TYPE ty_data,
           END OF ty_response.


    DATA:ls_resp TYPE ty_response,
         ls_inv  TYPE ty_invoice_result.

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

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header,
                   <ls_list>           TYPE mty_incoming_document.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.

    IF iv_date_from IS NOT INITIAL.
      lv_input = '{"Query": {"IssueDate": {"StartDate": "' && iv_date_from(4) && '-' && iv_date_from+4(2) && '-' && iv_date_from+6(2) &&
                 'T00:00:00.000Z","EndDate": "' && iv_date_to(4) && '-' && iv_date_to+4(2) && '-' && iv_date_to+6(2) &&
                 'T23:59:59.999Z"},"IsErpProcessed": false },"Skip": 0,"Take": 100}'.
    ELSE.
      lv_input = '{"Query": {"IsErpProcessed": false },"Skip": 0,"Take": 100,"OrderByName": "","OrderByType": "asc"}'.
    ENDIF.


    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/VbtApi/GetIncomingInvoiceList' ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                         pretty_name = 'X'
                                CHANGING data = ls_resp ).

    LOOP AT ls_resp-data-results INTO ls_inv.
      APPEND INITIAL LINE TO rt_invoices ASSIGNING <ls_list>.
      MOVE-CORRESPONDING ls_inv TO <ls_list>.
    ENDLOOP.



  ENDMETHOD.


  METHOD get_token.

    TYPES : BEGIN OF ty_result,
              token TYPE string.
    TYPES END OF ty_result.

*    TYPES : BEGIN OF ty_json,
*              errorcode TYPE string,
*              message   TYPE string.
*    TYPES END OF ty_json.

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
          ls_error              TYPE ms_error,
*          ls_json               TYPE ty_json,
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
                                 CHANGING   data        = ls_error ).

      CONCATENATE ls_error-errorcode '-' ls_error-message INTO lv_message SEPARATED BY space.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.

    ENDIF.



  ENDMETHOD.


  METHOD incoming_invoice_download.
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
             incominginvoicexmllist TYPE string,
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
                               iv_api            = '/api/VbtApi/GetIncomingInvoiceView' ).

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
                               iv_api            = '/api/VbtApi/GetIncomingInvoicePdf' ).

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
                       iv_api            = '/api/VbtApi/GetIncomingInvoiceXmlList' ).

        /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                     pretty_name = 'X'
                                  CHANGING data = ls_json_ubl ).

        lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = ls_json_ubl-data-incominginvoicexmllist ).
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


  METHOD incoming_invoice_get_status.
    TYPES: BEGIN OF ty_invoice_status,
             uuid                         TYPE string,
             invoicenumber                TYPE string,
             incominginvoicestatusforuser TYPE string,
             incominginvoicestatus        TYPE string,
           END OF ty_invoice_status.

    TYPES tt_invoice_status TYPE STANDARD TABLE OF ty_invoice_status WITH EMPTY KEY.
    TYPES: BEGIN OF ty_data,
             incominginvoicestatuslist TYPE tt_invoice_status,
           END OF ty_data.

    TYPES: BEGIN OF ty_json,
             refreshtoken TYPE string,
             data         TYPE ty_data,
           END OF ty_json.

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
          ls_invoice_status TYPE ty_json,
          ls_inv_status     TYPE ty_invoice_status.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.

    lv_input = '{"EttnList": ["' && is_document_numbers-duich && '"]}'.

    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/VbtApi/GetIncomingInvoicesStatus' ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_response
                                pretty_name = 'X'
                              CHANGING data =  ls_invoice_status ).

    READ TABLE ls_invoice_status-data-incominginvoicestatuslist INTO ls_inv_status INDEX 1.
    IF sy-subrc EQ 0.
      CASE ls_inv_status-incominginvoicestatusforuser.
        WHEN 'ApproveOrRejectNotStarted'.
          rs_status-resst = '0'.
          rs_status-staex = 'Approve/Reject process not started yet'(001).
        WHEN 'WaitingForApproveOrReject'.
          rs_status-resst = '0'.
          rs_status-staex = 'Waiting for Approve/Reject'(002).
        WHEN 'ApproveOrRejectSentWithError'.
          rs_status-resst = '0'.
          rs_status-staex = 'Approve/Reject sent (Error occures)'(003).
        WHEN 'Approving'.
          rs_status-resst = '2'.
          rs_status-staex = 'Approved (Still processing)'(004).
        WHEN 'Approved'.
          rs_status-resst = '2'.
          rs_status-staex = 'Approved'(005).
        WHEN 'Rejecting'.
          rs_status-resst = '1'.
          rs_status-staex = 'Rejected (Still processing)'(006).
        WHEN 'Rejected'.
          rs_status-resst = '1'.
          rs_status-staex = 'Rejected'(007).
      ENDCASE.
        ENDIF.


      ENDMETHOD.


  METHOD incoming_invoice_response.
    TYPES: BEGIN OF ty_detail,
             stacktrace      TYPE string,
             type            TYPE string,
             innerexceptions TYPE string,
           END OF ty_detail.

    TYPES: BEGIN OF ty_root,
             type      TYPE i,
             type_desc TYPE string,
             errorcode TYPE string,
             message   TYPE string,
             detail    TYPE ty_detail,
           END OF ty_root.
    DATA: lv_body            TYPE string,
          lv_response        TYPE string,
          lt_request_header  TYPE mty_http_request_header_t,
          lv_base64_content  TYPE string,
          lv_zipped_file     TYPE xstring,
          lt_xml_table       TYPE TABLE OF smum_xmltb,
          ls_xml_line        TYPE smum_xmltb,
          lv_file_name       TYPE string,
          lv_url             TYPE string,
          lv_apptype         TYPE string,
          lv_type            TYPE string,
          lv_token           TYPE string,
          lv_unzipped_data   TYPE xstring,
          lt_binary_data     TYPE solix_tab,
          lv_json_data       TYPE string,
          lv_invoice_base64  TYPE string,
          lv_input           TYPE string,
          lv_message         TYPE bapi_msg,
          lx_exception       TYPE REF TO /itetr/cx_regulative_exception,
          ls_int_status      TYPE /itetr/inv_inst,
          lv_approveorreject TYPE string,
          ls_return          TYPE ty_root.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.


    CASE iv_response.
      WHEN 'KABUL'.
        lv_approveorreject = 'ForwardForApprove'.
      WHEN 'RED'.
        lv_approveorreject = 'ForwardForReject'.
    ENDCASE.

    lv_input = '{"ForwardForApproveOrReject": "' &&   lv_approveorreject &&
              '","Ettn": "' && is_document_numbers-duich && '","ApplicationResponseNote": "'  && iv_note && '"}'.

    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/VbtApi/ApproveOrRejectIncomingInvoice' ).

    /ui2/cl_json=>deserialize( EXPORTING   json        = lv_response
                                           pretty_name = 'X'
                               CHANGING    data        = ls_return ).

    IF ls_return-errorcode IS NOT INITIAL.

      lv_message = ls_return-message.

      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.

    ENDIF.


  ENDMETHOD.


  method OUTGOING_INVOICE_CANCEL.
  endmethod.


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


  METHOD outgoing_invoice_get_export.

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

    lv_input = '{"Query": {"UUId": "' && is_document_numbers-duich && '"},"Skip": 0,"Take": 1 }'.

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
      IF ls_result-envelopestatus IS NOT INITIAL.
        rs_status-radsc = ls_result-envelopestatus.
        IF rs_status-radsc IS NOT INITIAL.
          SELECT SINGLE *
            FROM /itetr/inv_inst
            INTO ls_int_status
            WHERE intid = 'VBT'
              AND radsc = rs_status-radsc.
          IF sy-subrc IS INITIAL.
            MOVE-CORRESPONDING ls_int_status TO rs_status.
            SELECT SINGLE bezei
              FROM /itetr/inv_instx
              INTO rs_status-staex
              WHERE spras = sy-langu
                AND intid = 'VBT'
                AND insta = ls_int_status-insta.
          ENDIF.
        ENDIF.

        CASE ls_result-outgoinginvoicestatus.
          WHEN 'Rejected'.
            rs_status-resst = '1'.
          WHEN 'Approved'.
            rs_status-resst = '2'.
        ENDCASE.

      ELSE.

        CASE ls_result-outgoinginvoicestatus.
          WHEN 'WaitingForSendingToGib'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-008.
          WHEN 'Signed'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-009.
          WHEN 'WaitingForSendingToGib'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-010.
          WHEN 'CouldNotSentToGib'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-011.
          WHEN 'SentToGib'.
            rs_status-stacd = '5'.
            rs_status-staex = TEXT-012.
          WHEN 'GibFailed'.
            rs_status-stacd = '3'.
            rs_status-staex = TEXT-013.
          WHEN 'GibReceived' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-014.
          WHEN 'GibCouldNotSendToParty' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-015.
          WHEN 'GibCouldNotSendToPartyAndEnd' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-016.
          WHEN 'SentToParty' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-017.
          WHEN 'PartyReturnedError'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-018.
          WHEN 'PartyReceivedAndWaitingForApproval'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-019.
          WHEN 'Rejected'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-020.
            rs_status-resst = '1'.
          WHEN 'Approved'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-021.
            rs_status-resst = '2'.
        ENDCASE.
      ENDIF.

      IF ls_result-gtbreferencenumber  IS NOT INITIAL.
        rs_status-radrn = ls_result-gtbreferencenumber.
      ENDIF.

      IF ls_result-actualrealizationdate  IS NOT INITIAL.
        rs_status-raded = ls_result-actualrealizationdate(4) && ls_result-actualrealizationdate+5(2) && ls_result-actualrealizationdate+8(2).
      ENDIF.

      IF ls_result-gcbregistrationnumber  IS NOT INITIAL.
        rs_status-cedrn = ls_result-gcbregistrationnumber.
      ENDIF.

      IF ls_result-uuid  IS NOT INITIAL.
        rs_status-invui = ls_result-uuid.
      ENDIF.

      IF ls_result-envelopeid  IS NOT INITIAL.
        rs_status-envui = ls_result-envelopeid.
      ENDIF.

      IF ls_result-invoicenumber  IS NOT INITIAL.
        rs_status-invno = ls_result-invoicenumber.
      ENDIF.

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
*    lv_input = '{"Query": {"UUId": "' && is_document_numbers-duich && '"},"Skip": 0,"Take": 1 }'.

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
      IF ls_result-envelopestatus IS NOT INITIAL.
        rs_status-radsc = ls_result-envelopestatus.
        IF rs_status-radsc IS NOT INITIAL.
          SELECT SINGLE *
            FROM /itetr/inv_inst
            INTO ls_int_status
            WHERE intid = 'VBT'
              AND radsc = rs_status-radsc.
          IF sy-subrc IS INITIAL.
            MOVE-CORRESPONDING ls_int_status TO rs_status.
            SELECT SINGLE bezei
              FROM /itetr/inv_instx
              INTO rs_status-staex
              WHERE spras = sy-langu
                AND intid = 'VBT'
                AND insta = ls_int_status-insta.
          ENDIF.
        ENDIF.

        CASE ls_result-outgoinginvoicestatus.
          WHEN 'Rejected'.
            rs_status-resst = '1'.
          WHEN 'Approved'.
            rs_status-resst = '2'.
        ENDCASE.

      ELSE.

        CASE ls_result-outgoinginvoicestatus.
          WHEN 'WaitingForSendingToGib'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-008.
          WHEN 'Signed'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-009.
          WHEN 'WaitingForSendingToGib'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-010.
          WHEN 'CouldNotSentToGib'.
            rs_status-stacd = '1'.
            rs_status-staex = TEXT-011.
          WHEN 'SentToGib'.
            rs_status-stacd = '5'.
            rs_status-staex = TEXT-012.
          WHEN 'GibFailed'.
            rs_status-stacd = '5'.
            rs_status-staex = TEXT-013.
          WHEN 'GibReceived' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-014.
          WHEN 'GibCouldNotSendToParty' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-015.
          WHEN 'GibCouldNotSendToPartyAndEnd' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-016.
          WHEN 'SentToParty' .
            rs_status-stacd = '6'.
            rs_status-staex = TEXT-017.
          WHEN 'PartyReturnedError'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-018.
          WHEN 'PartyReceivedAndWaitingForApproval'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-019.
          WHEN 'Rejected'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-020.
            rs_status-resst = '1'.
          WHEN 'Approved'.
            rs_status-stacd = '7'.
            rs_status-staex = TEXT-021.
            rs_status-resst = '2'.
        ENDCASE.
      ENDIF.

      IF ls_result-gtbreferencenumber  IS NOT INITIAL.
        rs_status-radrn = ls_result-gtbreferencenumber.
      ENDIF.

      IF ls_result-actualrealizationdate  IS NOT INITIAL.
        rs_status-raded = ls_result-actualrealizationdate(4) && ls_result-actualrealizationdate+5(2) && ls_result-actualrealizationdate+8(2).
      ENDIF.

      IF ls_result-gcbregistrationnumber  IS NOT INITIAL.
        rs_status-cedrn = ls_result-gcbregistrationnumber.
      ENDIF.

      IF ls_result-uuid  IS NOT INITIAL.
        rs_status-invui = ls_result-uuid.
      ENDIF.

      IF ls_result-envelopeid  IS NOT INITIAL.
        rs_status-envui = ls_result-envelopeid.
      ENDIF.

      IF ls_result-invoicenumber  IS NOT INITIAL.
        rs_status-invno = ls_result-invoicenumber.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  method OUTGOING_INVOICE_RESPONSE.
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
          lv_message        TYPE bapi_msg.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header.

"Dogrudan GIB gonderimi icin portal sirket ayarından parametre aktif edilmelidir

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


    ls_data-invoiceexternalid      = iv_document_uuid.
    ls_data-receiveridentifier     = iv_receiver_alias.
    ls_data-filebytes              = lv_invoice_base64.
    ls_data-iszipped               = 'true'.
    ls_data-issigned               = 'false'.
    ls_data-earchivemailto         = ''.
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


  METHOD outgoing_invoice_send_again.

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

    lv_input = '{"Ettn": "' && iv_document_uuid_char && '"}'.

    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/Invoice/ReSendOutgoingInvoiceToGib' ).

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


  METHOD set_incoming_invoice_received.

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

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_http_request_header,
                   <ls_list>           TYPE mty_incoming_document.


    lv_token   = get_token( ).

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'vbtauthorization'.
    <ls_request_header>-value = lv_token .
    <ls_request_header>-rtype = 'h'.


    lv_input = '{"Ettn": "' && iv_document_uuid && '" , "ErpProcessBranch": "" , "IsErpProcessed": true }'.


    lv_response = me->run_service_rest(
                       EXPORTING
                         iv_method         = 'POST'
                         iv_body           = lv_input
                         it_request_header = lt_request_header
                         iv_api            = '/api/VbtApi/UpdateIncomingInvoiceErpProcessStatus' ).

  ENDMETHOD.
ENDCLASS.