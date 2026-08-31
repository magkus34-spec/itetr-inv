class /ITETR/CL_PRRECEIPT_WS definition
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
    TYPES emsta TYPE /itetr/inv_e_emsta.
    TYPES smsta TYPE /itetr/inv_e_smsta.
    TYPES rprid TYPE /itetr/inv_e_rprid.
    TYPES envui TYPE /itetr/com_e_envui.
    TYPES invui TYPE /itetr/com_e_duich.
    TYPES invno TYPE /itetr/com_e_docno.
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
      value(RO_INSTANCE) type ref to /ITETR/CL_PRRECEIPT_WS
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
      !IV_EARCHIVE_TYPE type /ITETR/INV_E_EATYP optional
      !IV_INTERNET_SALE type /ITETR/INV_E_INTSL optional
      !IT_CUSTOM_PARAMETERS type /ITETR/COM_TT_CUSTOM_PARAM optional
    exporting
      !EV_INTEGRATOR_UUID type /ITETR/COM_E_DOCII
      !EV_INVOICE_UUID type /ITETR/COM_E_DUICH
      !EV_INVOICE_NO type /ITETR/COM_E_DOCNO
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
      !IV_TAX_EXCLUSIVE_AMOUNT type WRBTR optional
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods OUTGOING_INVOICE_PREVIEW
  abstract
    importing
      !IV_CONTENT_TYPE type /ITETR/COM_E_CONTY
      !IV_UBL_XSTRING type /ITETR/COM_E_CONTN
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DOCUI
    returning
      value(RV_INVOICE_DATA) type /ITETR/COM_E_CONTN
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  PROTECTED SECTION.
    DATA:
      mv_company_taxid      TYPE stcd2,
      ms_company_parameters TYPE /itetr/inv_earp,
      mt_custom_parameters  TYPE STANDARD TABLE OF /itetr/inv_eacp
                            WITH NON-UNIQUE SORTED KEY by_cuspa COMPONENTS cuspa,
      mv_request_url        TYPE string.

    TYPES:
      BEGIN OF mty_document_status,
        aciklama                  TYPE string,
        alimtarihi                TYPE string,
        belgeno                   TYPE string,
        ettn                      TYPE string,
        yanitdetayi               TYPE string,
        yanitdurumu               TYPE string,
        yanitgonderimcevabidetayi TYPE string,
        yanitgonderimcevabikodu   TYPE string,
        yanitgonderimdurumu       TYPE string,
        yanitgonderimtarihi       TYPE string,
        sirano                    TYPE string,
        yereleaktarimdurumu       TYPE string,
        kepdurum                  TYPE string,
        gibiptaldurum             TYPE string,
      END OF mty_document_status .
*    TYPES:
*      BEGIN OF mty_incoming_document,
*        faturaNo         TYPE string,
*        firmaVkn         TYPE string,
*        gonderimSekli    TYPE string,
*        insertDate       TYPE string,
*        iptalItirazDurum TYPE string,
*        iptalItirazTarih TYPE string,
*        mukTckn          TYPE string,
*        mukVkn           TYPE string,
*        odenecek         TYPE string,
*        paraBirimi       TYPE string,
*        tarih            TYPE string,
*        tesisatNo        TYPE string,
*        toplam           TYPE string,
*        unvan            TYPE string,
*        vergi            TYPE string,
*        zaman            TYPE string,
*      END OF mty_incoming_document .
    TYPES:
      BEGIN OF mty_incoming_document,
        duzenlenmetarihi TYPE string,
        faturano         TYPE /itetr/com_e_docno,
        firmavkn         TYPE string,
        gonderimsekli    TYPE string,
        insertdate       TYPE string,
        iptalitirazdurum TYPE string,
        iptalitiraztarih TYPE string,
        mukelleftckn     TYPE string,
        mukellefvkn      TYPE stcd2,
        odenecektutar    TYPE string,
        parabirimi       TYPE string,
        tcknvkn          TYPE string,
        tarih            TYPE string,
        tesisatnumarasi  TYPE string,
        toplamtutar      TYPE string,
        unvan            TYPE string,
        vergilertutari   TYPE string,
        zaman            TYPE string,
      END OF mty_incoming_document .
    TYPES:
      mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .


    METHODS run_service
      IMPORTING
        !iv_request                  TYPE string
        !iv_use_alternative_endpoint TYPE xfeld OPTIONAL
        !iv_authenticate             TYPE xfeld OPTIONAL
        !it_request_header           TYPE mty_service_header_tab OPTIONAL
      RETURNING
        VALUE(rv_response)           TYPE string
      RAISING
        /itetr/cx_regulative_exception.
private section.

  methods GET_SERVICE_PARAMETERS
    importing
      !IS_COMPANY_PARAMETERS type /ITETR/INV_EARP .
ENDCLASS.



CLASS /ITETR/CL_PRRECEIPT_WS IMPLEMENTATION.


  METHOD factory.
    DATA: ls_company_parameters  TYPE /itetr/inv_earp,
          lx_exception           TYPE REF TO /itetr/cx_regulative_exception,
          lx_create_object_error TYPE REF TO cx_sy_create_object_error,
          lv_reference_class     TYPE seoclsname.

    "Belki bu değişebilir, e-arşivden farklı mı parametreleri?
    SELECT SINGLE *
      INTO ls_company_parameters
      FROM /itetr/inv_emmp
      WHERE bukrs = iv_company.
    IF sy-subrc <> 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '001' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

    "burası sabit kalacak!
    SELECT SINGLE refcl
      INTO lv_reference_class
      FROM /itetr/com_refcl
      WHERE bukrs = iv_company
        AND prncl = '/ITETR/CL_PRRECEIPT_WS'.
    IF lv_reference_class IS INITIAL.
      CONCATENATE '/ITETR/CL_PRRECEIPT_WS_' ls_company_parameters-intid INTO lv_reference_class.
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
    DATA: ls_custom_parameter   TYPE /itetr/inv_eacp.

    ms_company_parameters = is_company_parameters.

    IF ms_company_parameters-wsusr IS INITIAL.
      SELECT SINGLE wsend wsena wsusr wspwd
        INTO ( ms_company_parameters-wsend, ms_company_parameters-wsena, ms_company_parameters-wsusr, ms_company_parameters-wspwd )
        FROM /itetr/inv_emil
        WHERE bukrs   = ms_company_parameters-bukrs
          AND intid   = ms_company_parameters-intid.
    ENDIF.

    SELECT *
      INTO TABLE mt_custom_parameters
      FROM /itetr/inv_emcp
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


  METHOD RUN_SERVICE.
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
          ls_request_header  TYPE /ITETR/CL_PRRECEIPT_WS=>mty_service_header.

    lv_request_length = strlen( iv_request ).
    MOVE lv_request_length TO lv_length_text.
    CONDENSE lv_length_text.

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
*    CONCATENATE ms_company_parameters-wsusr ':' ms_company_parameters-wspwd INTO lv_authorization.
*    lv_authorization = /itetr/cl_regulative_common=>encode_base64( lv_authorization ).
*    CONCATENATE 'Basic' lv_authorization INTO lv_authorization SEPARATED BY space.
*    lo_http_client->request->set_header_field( name  = 'Authorization'
*                                               value = lv_authorization ).

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