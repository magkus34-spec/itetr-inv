class /ITETR/CL_EINVOICE_WS definition
  public
  abstract
  create public .

public section.

  types:
    mty_taxpayers_list TYPE STANDARD TABLE OF /itetr/inv_taxp WITH DEFAULT KEY .
  types:
    BEGIN OF mty_outgoing_document_status.
    TYPES stacd TYPE /itetr/com_e_stacd.
    TYPES staex TYPE /itetr/com_e_staex.
    TYPES resst TYPE /itetr/inv_e_resst.
    TYPES radsc TYPE /itetr/com_e_radsc.
    TYPES rsend TYPE /itetr/com_e_rsend.
    TYPES raded TYPE /itetr/inv_e_raded.
    TYPES cedrn TYPE /itetr/inv_e_cedrn.
    TYPES radrn TYPE /itetr/inv_e_radrn.
    TYPES envui TYPE /itetr/com_e_envui.
    TYPES invui TYPE /itetr/com_e_duich.
    TYPES invno TYPE /itetr/com_e_docno.
    TYPES invqi TYPE /itetr/com_e_docqi.
    TYPES invii TYPE /itetr/com_e_docii.
    TYPES reached TYPE /itetr/com_e_reached. "gkadioglu
    TYPES yanit_detay TYPE /itetr/com_e_response_detail. "gkadioglu
    TYPES END OF mty_outgoing_document_status .
  types:
    BEGIN OF mty_service_header.
    TYPES name TYPE string.
    TYPES value TYPE string.
    TYPES END OF mty_service_header .
  types:
    mty_service_header_tab TYPE TABLE OF mty_service_header WITH DEFAULT KEY .

  class-methods FACTORY
    importing
      !IV_COMPANY type BUKRS
      value(IO_INVOICE) type ref to /ITETR/CL_OUTGOING_INVOICE optional
    returning
      value(RO_INSTANCE) type ref to /ITETR/CL_EINVOICE_WS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods DOWNLOAD_REGISTERED_TAXPAYERS
  abstract
    returning
      value(RT_LIST) type MTY_TAXPAYERS_LIST
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods DOWNLOAD_REGISTERED_TAXP_TIME
  abstract
    importing
      !IV_DATE type DATUM
    returning
      value(RT_LIST) type MTY_TAXPAYERS_LIST
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_INCOMING_INVOICES
  abstract
    importing
      !IV_DATE_FROM type BEGDA optional
      !IV_DATE_TO type ENDDA optional
    exporting
      !EV_MESSAGE type BAPI_MSG
    returning
      value(RT_LIST) type /ITETR/INV_TT_ICINV
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods INCOMING_INVOICE_GET_STATUS
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
    returning
      value(RS_STATUS) type /ITETR/INV_INCINV_STATUS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods INCOMING_INVOICE_DOWNLOAD
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
      !IV_CONTENT_TYPE type /ITETR/COM_E_CONTY
    returning
      value(RV_INVOICE_DATA) type /ITETR/COM_E_CONTN
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods INCOMING_INVOICE_RESPONSE
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
      !IV_RESPONSE type /ITETR/INV_E_APRES
      !IV_NOTE type /ITETR/COM_E_LNOTE optional
      !IV_RECEIVER_ALIAS type /ITETR/COM_E_ALIAS optional
      !IV_RECEIVER_TAXID type STCD2 optional
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_SEND
  abstract
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DOCUI
      !IS_UBL_STRUCTURE type /ITETR/COM_MESSAGE1
      !IV_UBL_XSTRING type XSTRING
      !IV_UBL_HASH type MD5_FIELDS-HASH
      !IV_RECEIVER_ALIAS type /ITETR/COM_E_ALIAS
      !IV_RECEIVER_TAXID type STCD2
      !IT_CUSTOM_PARAMETERS type /ITETR/COM_TT_CUSTOM_PARAM optional
    exporting
      !EV_INTEGRATOR_UUID type /ITETR/COM_E_DOCII
      !EV_INVOICE_UUID type /ITETR/COM_E_DUICH
      !EV_INVOICE_NO type /ITETR/COM_E_DOCNO
      !EV_ENVELOPE_UUID type /ITETR/COM_E_ENVUI
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_SEND_AGAIN
  abstract
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DOCUI
      !IV_DOCUMENT_UUID_CHAR type /ITETR/COM_E_DUICH
      !IS_UBL_STRUCTURE type /ITETR/COM_MESSAGE1
      !IV_UBL_XSTRING type XSTRING
      !IV_UBL_HASH type MD5_FIELDS-HASH
      !IV_RECEIVER_ALIAS type /ITETR/COM_E_ALIAS
      !IV_RECEIVER_TAXID type STCD2
      !IT_CUSTOM_PARAMETERS type /ITETR/COM_TT_CUSTOM_PARAM optional
    exporting
      !EV_ENVELOPE_UUID type /ITETR/COM_E_ENVUI
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_GET_STATUS
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
    returning
      value(RS_STATUS) type MTY_OUTGOING_DOCUMENT_STATUS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_GET_EXPORT
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
    returning
      value(RS_STATUS) type MTY_OUTGOING_DOCUMENT_STATUS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_DOWNLOAD
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
      !IV_CONTENT_TYPE type /ITETR/COM_E_CONTY
    returning
      value(RV_INVOICE_DATA) type /ITETR/COM_E_CONTN
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_CANCEL
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
      !IV_DOCUMENT_DATE type BLDAT optional
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_RESPONSE
  abstract
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
    returning
      value(RS_STATUS) type MTY_OUTGOING_DOCUMENT_STATUS .
  methods OUTGOING_INVOICE_PREVIEW
  abstract
    importing
      !IV_CONTENT_TYPE type /ITETR/COM_E_CONTY
      !IV_UBL_XSTRING type /ITETR/COM_E_CONTN
    returning
      value(RV_INVOICE_DATA) type /ITETR/COM_E_CONTN
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
protected section.

  data MV_COMPANY_TAXID type STCD2 .
  data MS_COMPANY_PARAMETERS type /ITETR/INV_EINP .
  data:
    mt_custom_parameters  TYPE STANDARD TABLE OF /itetr/inv_eicp
                            WITH NON-UNIQUE SORTED KEY by_cuspa COMPONENTS cuspa .
  data MV_REQUEST_URL type STRING .

  methods RUN_SERVICE
    importing
      !IV_REQUEST type STRING
      !IV_USE_ALTERNATIVE_ENDPOINT type XFELD optional
      !IV_AUTHENTICATE type XFELD optional
      !IT_REQUEST_HEADER type MTY_SERVICE_HEADER_TAB optional
      !IV_USE_ALTERNATIVE_ENDPOINT2 type XFELD optional
    returning
      value(RV_RESPONSE) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods BUILD_APPLICATION_RESPONSE
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS
      !IV_RESPONSE type /ITETR/INV_E_APRES
      !IV_NOTE type /ITETR/COM_E_LNOTE optional
    exporting
      !EV_RESPONSE_XML type XSTRING
      !EV_RESPONSE_HASH type MD5_FIELDS-HASH
      !ES_RESPONSE_STRUCTURE type /ITETR/COM_MESSAGE11
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
private section.

  methods GET_SERVICE_PARAMETERS
    importing
      !IS_COMPANY_PARAMETERS type /ITETR/INV_EINP .
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS IMPLEMENTATION.


  METHOD build_application_response.
    DATA: lv_invoice_xml          TYPE xstring,
          lv_response_xml         TYPE xstring,
          lx_root                 TYPE REF TO cx_root,
          ls_invoice              TYPE /itetr/com_invoice_type,
          ls_application_response TYPE /itetr/com_message11,
          lt_binary               TYPE solix_tab,
          lv_length               TYPE i,
          lv_hash_value           TYPE md5_fields-hash,
          lv_response             TYPE string,
          lx_exception            TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <ls_signature>         TYPE /itetr/com_signature,
                   <ls_document_response> TYPE /itetr/com_document_response,
                   <ls_line_response>     TYPE /itetr/com_line_response,
                   <ls_note>              TYPE /itetr/com_note,
                   <ls_response>          TYPE /itetr/com_description,
                   <ls_line_response2>    TYPE /itetr/com_response.

    lv_invoice_xml = me->incoming_invoice_download(
      EXPORTING
        is_document_numbers = is_document_numbers
        iv_content_type = 'UBL' ).

    TRY.
        cl_proxy_xml_transform=>xml_xstring_to_abap(
          EXPORTING
            ddic_type = '/ITETR/COM_INVOICE_TYPE'
            xml       = lv_invoice_xml
          IMPORTING
            abap_data = ls_invoice ).

        ls_application_response-part1-ublversion_id = ls_invoice-ublversion_id.
        ls_application_response-part1-customization_id = ls_invoice-customization_id.
        ls_application_response-part1-profile_id = ls_invoice-profile_id.
        ls_application_response-part1-id = ls_invoice-id.
        ls_application_response-part1-uuid = ls_invoice-uuid.
        ls_application_response-part1-issue_date = ls_invoice-issue_date.
        ls_application_response-part1-issue_time = ls_invoice-issue_time.
        ls_application_response-part1-sender_party = ls_invoice-accounting_customer_party-party.
        ls_application_response-part1-receiver_party = ls_invoice-accounting_supplier_party-party.
        APPEND INITIAL LINE TO ls_application_response-part1-signature ASSIGNING <ls_signature>.
        <ls_signature>-id-base-base-scheme_id = 'VKN_TCKN'.
        <ls_signature>-id-base-base-content = mv_company_taxid.
        <ls_signature>-signatory_party = ls_invoice-accounting_customer_party-party.
        APPEND INITIAL LINE TO ls_application_response-part1-document_response ASSIGNING <ls_document_response>.
        IF iv_note IS NOT INITIAL.
          APPEND INITIAL LINE TO ls_application_response-part1-note ASSIGNING <ls_note>.
          <ls_note>-base-base-content = iv_note.
          APPEND INITIAL LINE TO <ls_document_response>-response-description ASSIGNING <ls_response>.
          <ls_response>-base-base-content = iv_note.
        ELSE.
          APPEND INITIAL LINE TO ls_application_response-part1-note ASSIGNING <ls_note>.
          <ls_note>-base-base-content = iv_response.
          APPEND INITIAL LINE TO <ls_document_response>-response-description ASSIGNING <ls_response>.
          <ls_response>-base-base-content = iv_response.
        ENDIF.
        <ls_document_response>-response-response_code-base-base-content = iv_response.
        <ls_document_response>-response-reference_id-base-base-content = ls_invoice-uuid-base-base-content.
        <ls_document_response>-document_reference-issue_date = ls_invoice-issue_date.
        <ls_document_response>-document_reference-id = ls_invoice-uuid.
        <ls_document_response>-document_reference-document_type-base-base-content = 'FATURA'.
        <ls_document_response>-document_reference-document_type_code-base-base-content = 'FATURA'.

        APPEND INITIAL LINE TO <ls_document_response>-line_response ASSIGNING <ls_line_response>.
        APPEND INITIAL LINE TO <ls_line_response>-response ASSIGNING <ls_line_response2>.
        <ls_line_response2> = <ls_document_response>-response.

        lv_response_xml = cl_proxy_xml_transform=>abap_to_xml_xstring(
          EXPORTING
            abap_data               = ls_application_response
            ddic_type               = '/ITETR/COM_MESSAGE11'
            xml_header              = 'full' ).

        lv_response = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_response_xml ).
        REPLACE REGEX 'ApplicationResponse xmlns' IN lv_response
          WITH 'ApplicationResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2 UBL-ApplicationResponse-2.1.xsd" xmlns'.
        lv_response_xml = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_response ).
        ev_response_hash = /itetr/cl_regulative_common=>calculate_hash_for_raw( lv_response_xml ).
        ev_response_xml = lv_response_xml.
        es_response_structure = ls_application_response.
      CATCH cx_root INTO lx_root.
        lx_exception = /itetr/cx_regulative_exception=>create_by_exception( lx_root ).
        RAISE EXCEPTION lx_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD factory.
    DATA: ls_company_parameters  TYPE /itetr/inv_einp,
          lx_exception           TYPE REF TO /itetr/cx_regulative_exception,
          lx_create_object_error TYPE REF TO cx_sy_create_object_error,
          lv_reference_class     TYPE seoclsname.
    SELECT SINGLE *
      INTO ls_company_parameters
      FROM /itetr/inv_einp
      WHERE bukrs = iv_company.
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '001' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    SELECT SINGLE refcl
      INTO lv_reference_class
      FROM /itetr/com_refcl
      WHERE bukrs = iv_company
        AND prncl = '/ITETR/CL_EINVOICE_WS'.  "AS 01.01.2022

    IF lv_reference_class IS INITIAL.
      CONCATENATE '/ITETR/CL_EINVOICE_WS_' ls_company_parameters-intid INTO lv_reference_class.
    ENDIF.

    TRY .
        CREATE OBJECT ro_instance TYPE (lv_reference_class).
        ro_instance->get_service_parameters( ls_company_parameters ).
      CATCH cx_sy_create_object_error INTO lx_create_object_error.
        lx_exception = /itetr/cx_regulative_exception=>create_by_exception( lx_create_object_error ).
        RAISE EXCEPTION lx_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD get_service_parameters.
    DATA: ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_len              TYPE i,
          lv_inc_inv          TYPE /itetr/com_e_wsinc.

    ms_company_parameters = is_company_parameters.

    IF ms_company_parameters-wsusr IS INITIAL.
      lv_len = strlen( sy-cprog ).
      IF lv_len GE 10.
        lv_inc_inv = sy-cprog+7(3).
        IF lv_inc_inv NE 'INC'.
          CLEAR lv_inc_inv.
        ENDIF.
      ENDIF.
      SELECT SINGLE wsend wsena wsusr wspwd pk_alias gb_alias
        INTO ( ms_company_parameters-wsend, ms_company_parameters-wsena, ms_company_parameters-wsusr,
              ms_company_parameters-wspwd, ms_company_parameters-pk_alias, ms_company_parameters-gb_alias )
        FROM /itetr/inv_eiil
        WHERE bukrs   = ms_company_parameters-bukrs
          AND intid   = ms_company_parameters-intid
          AND inc_inv = lv_inc_inv.
    ENDIF.

    SELECT *
      INTO TABLE mt_custom_parameters
      FROM /itetr/inv_eicp
      WHERE bukrs = ms_company_parameters-bukrs.

    SELECT *
      APPENDING TABLE mt_custom_parameters
      FROM /itetr/com_cmpcp
      WHERE bukrs = ms_company_parameters-bukrs.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'TEST_VKN'.
    IF sy-subrc = 0.
      mv_company_taxid = ls_custom_parameter-value.
    ELSE.
      SELECT SINGLE value
        INTO mv_company_taxid
        FROM /itetr/com_cmppi
        WHERE bukrs = ms_company_parameters-bukrs
          AND prtid = 'VKN'.
    ENDIF.
  ENDMETHOD.


  METHOD run_service.
    DATA: lv_request_length  TYPE i,
          lv_length_text     TYPE string,
          lo_http_client     TYPE REF TO if_http_client,
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
          ls_request_header  TYPE /itetr/cl_einvoice_ws=>mty_service_header,
          lx_root            TYPE REF TO cx_root.

    lv_request_length = strlen( iv_request ).
    MOVE lv_request_length TO lv_length_text.
    CONDENSE lv_length_text.

    IF iv_use_alternative_endpoint = abap_true.
      lv_endpoint = ms_company_parameters-wsena.
    ELSEIF iv_use_alternative_endpoint2 = abap_true."gkadioglu
      lv_endpoint = ms_company_parameters-wsenda.
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
        OTHERS                   = 6 ).
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    IF iv_authenticate IS NOT INITIAL.
      lv_user = ms_company_parameters-wsusr.
      lv_password = ms_company_parameters-wspwd.
      lo_http_client->authenticate(
        EXPORTING
          username = lv_user
          password = lv_password ).
    ENDIF.

    lo_http_client->request->set_header_field( name  = '~request_method'
                                               value = 'POST' ).

    IF mv_request_url IS NOT INITIAL.
      lo_http_client->request->set_header_field( name  = '~request_uri'
                                                 value = mv_request_url ).
    ENDIF.

    lo_http_client->request->set_header_field( name  = 'Content-Length'
                                               value = lv_length_text ).

    IF it_request_header IS NOT INITIAL.
      LOOP AT it_request_header INTO ls_request_header.
        lo_http_client->request->set_header_field( name  = ls_request_header-name
                                                   value = ls_request_header-value ).
      ENDLOOP.
    ELSE.
      lo_http_client->request->set_header_field( name  = 'Content-Type'
                                                 value = 'text/xml; charset=utf-8' ).
    ENDIF.

    lo_http_client->request->set_cdata( data   = iv_request
                                        offset = 0
                                        length = lv_request_length ).

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
      IF lo_http_client->response IS BOUND.
        rv_response = lo_http_client->response->get_cdata( ).
      ELSE.
        rv_response = TEXT-000.
      ENDIF.
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