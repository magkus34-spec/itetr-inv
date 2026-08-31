class /ITETR/CL_EINVOICE_WS_HTK definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
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
  methods OUTGOING_INVOICE_PREVIEW
    redefinition .
  methods OUTGOING_INVOICE_RESPONSE
    redefinition .
  methods OUTGOING_INVOICE_SEND
    redefinition .
  methods OUTGOING_INVOICE_SEND_AGAIN
    redefinition .
protected section.

  methods RUN_SERVICE_REST
    importing
      !IV_BODY type STRING
      !IT_REQUEST_HEADER type MTY_SERVICE_HEADER_TAB optional
      !IV_URL type STRING
      !IV_METHOD type STRING
    returning
      value(RV_RESPONSE) type STRING
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
private section.
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS_HTK IMPLEMENTATION.


  METHOD download_registered_taxpayers.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_result,
              documentfile TYPE string.
    TYPES END OF ty_result.

    DATA: lv_body           TYPE string,
          lv_response       TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          ls_user_list      TYPE /itetr/inv_s_userlist,
          ls_user_list2     TYPE /itetr/inv_s_userlist,
          ls_user           TYPE /itetr/inv_s_user,
          ls_documents      TYPE /itetr/inv_s_userlist_doc,
          ls_alias          TYPE /itetr/inv_s_userlist_alias,
          lv_url            TYPE string,
          lv_apptype        TYPE string,
          lv_type           TYPE string,
          lv_token          TYPE string,
          ls_result         TYPE ty_result.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    lv_token   = get_token( ).

    lv_type    = 'PK_Yeni_Format'.
    lv_apptype = '0'.

    lv_url     =  ms_company_parameters-wsend && 'GetGibUserFile' &&
                 '?AppType=' && lv_apptype &&
                 '&Type='    && lv_type.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response = run_service_rest( iv_body           = lv_body
                                        iv_url            = lv_url
                                        iv_method         = 'GET'
                                        it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json    = lv_response
                                     pretty_name = 'X'
                           CHANGING  data        = ls_result ).

    IF ls_result-documentfile IS NOT INITIAL.
      lv_base64_content = ls_result-documentfile.
    ENDIF.

    lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).

**    /itetr/cl_regulative_common=>unzip_file_single(
**      EXPORTING
**        iv_zipped_file_xstr = lv_zipped_file
**      IMPORTING
**        ev_output_data_str = lv_taxpayers_xml ).

    "begin partial for memory

    DATA: lo_zip           TYPE REF TO cl_abap_zip,
          lv_input_xstring TYPE xstring,
          ls_file          TYPE cl_abap_zip=>t_file,
          lv_file_name     TYPE string,
          lv_xml_xstring   TYPE xstring,
          lv_xml_xstring1  TYPE xstring,
          lv_xml_xstring2  TYPE xstring,
          lv_xml_xstring3  TYPE xstring.


    lv_input_xstring = lv_zipped_file.
    .
    CREATE OBJECT lo_zip.
    lo_zip->load(
      EXPORTING
        zip             = lv_input_xstring
      EXCEPTIONS
        zip_parse_error = 1
        OTHERS          = 2 ).
    CHECK sy-subrc IS INITIAL.

    READ TABLE lo_zip->files INTO ls_file INDEX 1.
    CHECK sy-subrc IS INITIAL.

    lv_file_name = ls_file-name.
    lo_zip->get(
      EXPORTING
        name                    = lv_file_name
      IMPORTING
        content                 = lv_xml_xstring
      EXCEPTIONS
        zip_index_error         = 1
        zip_decompression_error = 2
        OTHERS                  = 3 ).


    DATA: lv_user_list_e TYPE xstring , "</UserList>
          lv_user_s      TYPE xstring . "<User>

    DATA: lt_user_open TYPE match_result_tab,
          ls_userss    LIKE LINE OF lt_user_open.

    DATA: lv_proc_xml TYPE xstring,
          lv_count    TYPE i.

    DATA: lv_start_i TYPE i,
          lv_end_i   TYPE i,
          lv_length  TYPE i,
          lv_cycle   TYPE i.

    DATA: lv_datum TYPE sy-datum,
          lv_uzeit TYPE sy-uzeit.



    lv_user_list_e = '3C2F557365724C6973743E'.
    lv_user_s = '3C557365723E'.


    DATA : lv_parcali TYPE /itetr/inv_eicp-value.
    DATA : lv_parca_sayi TYPE i.
    SELECT SINGLE value FROM /itetr/inv_eicp INTO lv_parcali WHERE cuspa = 'PARTITE'.
    IF lv_parcali IS NOT INITIAL.
      lv_parca_sayi = lv_parcali.
    ELSE.
      lv_parca_sayi = 100000.
    ENDIF.

    lv_cycle = lv_parca_sayi + 1.

    lv_datum = sy-datum.
    lv_uzeit = sy-uzeit.

    FIND ALL OCCURRENCES OF lv_user_s IN lv_xml_xstring IN BYTE MODE RESULTS lt_user_open.

    READ TABLE lt_user_open INTO ls_userss INDEX 1.
    lv_start_i = ls_userss-offset.
    CLEAR ls_userss.

    DO.

      FIND ALL OCCURRENCES OF lv_user_s IN lv_xml_xstring IN BYTE MODE RESULTS lt_user_open.
      DESCRIBE TABLE lt_user_open LINES lv_count.

      "IF lv_count LE 100000.
      IF lv_count LE lv_parca_sayi.

        lv_taxpayers_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_xml_xstring ).

        CALL TRANSFORMATION /itetr/inv_userlist
          SOURCE XML lv_taxpayers_xml
          RESULT userlist = ls_user_list2.
        APPEND LINES OF ls_user_list2-user TO ls_user_list-user.


        EXIT.

      ELSE.

        READ TABLE lt_user_open INTO ls_userss INDEX lv_cycle.

        lv_end_i = ls_userss-offset.
        lv_length = ls_userss-offset - lv_start_i.
        CONCATENATE  lv_xml_xstring(lv_end_i)
                     lv_user_list_e
              INTO lv_proc_xml IN BYTE MODE.

        lv_length = xstrlen( lv_xml_xstring ).
        lv_length = lv_length - lv_end_i.

        lv_xml_xstring1 = lv_xml_xstring(lv_start_i).
        lv_xml_xstring2 =  lv_xml_xstring+lv_end_i(lv_length).

*        CONCATENATE  lv_xml_xstring(lv_start_i)
*                     lv_xml_xstring+lv_end_i(lv_length)
*              INTO lv_xml_xstring IN BYTE MODE.

        CLEAR lv_xml_xstring.
        CONCATENATE  lv_xml_xstring1
                     lv_xml_xstring2
              INTO lv_xml_xstring3 IN BYTE MODE.

        lv_xml_xstring = lv_xml_xstring3.

        CLEAR: lv_xml_xstring3,
               lv_xml_xstring2,
               lv_xml_xstring1.

        lv_taxpayers_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_proc_xml ).

        CALL TRANSFORMATION /itetr/inv_userlist
          SOURCE XML lv_taxpayers_xml
          RESULT userlist = ls_user_list2.

        APPEND LINES OF ls_user_list2-user TO ls_user_list-user.


        CLEAR lv_proc_xml.
        CLEAR lv_taxpayers_xml.
        CLEAR ls_user_list2.

      ENDIF.

    ENDDO.


**    CALL TRANSFORMATION /itetr/inv_userlist
**      SOURCE XML lv_taxpayers_xml
**      RESULT userlist = ls_user_list.

    DATA: lv_deletion_date TYPE datum.
    DATA : lt_default_allias TYPE TABLE OF /itetr/inv_allis.
    SELECT * FROM /itetr/inv_allis INTO TABLE lt_default_allias .
    "SELECT * FROM /itetr/inv_taxp INTO TABLE lt_default_allias.
    SORT lt_default_allias BY taxid aliass.


    LOOP AT ls_user_list-user INTO ls_user.
      CLEAR ls_taxpayer.
      CASE ls_user-type.
        WHEN 'OZEL'.
          ls_taxpayer-txpty = 'OZEL'.
        WHEN OTHERS.
          ls_taxpayer-txpty = 'KAMU'.
      ENDCASE.
      LOOP AT ls_user-documents INTO ls_documents WHERE document = 'Invoice'.
        LOOP AT ls_documents-alias INTO ls_alias.
          IF ls_alias IS NOT INITIAL.
            REPLACE ALL OCCURRENCES OF '-' IN ls_alias-creationtime WITH ''.
            REPLACE ALL OCCURRENCES OF ':' IN ls_alias-creationtime WITH ''.
            REPLACE ALL OCCURRENCES OF '-' IN ls_alias-deletiontime WITH ''.
            REPLACE ALL OCCURRENCES OF ':' IN ls_alias-deletiontime WITH ''.
            ls_taxpayer-regdt = ls_alias-creationtime(8).
            ls_taxpayer-regtm = ls_alias-creationtime+9(6).
            CLEAR: lv_deletion_date."gkadioglu
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

  ENDMETHOD.


  METHOD DOWNLOAD_REGISTERED_TAXP_TIME.

  ENDMETHOD.


  METHOD get_incoming_invoices.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_documents,
              uuid                 TYPE string,
              envelopeuuid         TYPE string,
              apptype              TYPE string,
              isarchive            TYPE string,
              isread               TYPE string,
              isaccount            TYPE string,
              istransferred        TYPE string,
              isprinted            TYPE string,
              documentid           TYPE string,
              profileid            TYPE string,
              documentcurrencycode TYPE string,
              targettitle          TYPE string,
              targetidentifier     TYPE string,
              targetalias          TYPE string,
              isinternetsale       TYPE string,
              sendtype             TYPE string,
              taxtotal             TYPE string,
              payableamount        TYPE string,
              localreferenceid     TYPE string,
              status               TYPE string,
              statusexp            TYPE string,
              envelopestatus       TYPE string,
              envelopeexp          TYPE string,
              messsage             TYPE string,
              issuedate            TYPE string,
              createddate          TYPE string,
              canceldate           TYPE string.
    TYPES END OF ty_documents.

    DATA : BEGIN OF ls_list_result,
             documents TYPE TABLE OF ty_documents.
    DATA END OF ls_list_result.

    DATA : BEGIN OF ls_file_result,
             documentfile TYPE string.
    DATA END OF ls_file_result.

    DATA: lv_request_xml         TYPE string,
          lv_response            TYPE string,
          lt_xml_table           TYPE TABLE OF smum_xmltb,
          ls_xml_line            TYPE smum_xmltb,
          ls_custom_parameter    TYPE /itetr/inv_eicp,
          lv_content             TYPE string,
          lv_zipped_file         TYPE string,
          lv_body                TYPE string,
          lv_url                 TYPE string,
          lv_apptype             TYPE string,
          lv_datetype            TYPE string,
          lv_startdate           TYPE string,
          lv_enddate             TYPE string,
          lv_token               TYPE string,
          lt_request_header      TYPE mty_service_header_tab,
          lv_base64_content      TYPE string,
          lv_output              TYPE string,
          lv_isnew               TYPE string,
          lv_isexport            TYPE string,
          lv_takenfromentegrator TYPE string,
          lv_isdraft             TYPE string,
          lv_branchcodes         TYPE string,
          ls_despatch            TYPE /itetr/inv_icdes,
          lv_data                TYPE /itetr/com_e_contn,
          lv_xml                 TYPE string,
          ls_invoice             TYPE /itetr/com_message1,
          lv_extension           TYPE string,
          lv_uri                 TYPE string,
          lv_digest              TYPE string,
          lv_offset              TYPE i,
          ls_ublextension        TYPE /itetr/com_ublextension,
          ls_departmant          TYPE /itetr/com_cmpdp,
          lv_invui               TYPE string,
          ls_documents           TYPE ty_documents.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    lv_token   = get_token( ).

    "branch bilgisi
    SELECT SINGLE value
     INTO lv_branchcodes
     FROM /itetr/com_cmppi
     WHERE bukrs = ms_company_parameters-bukrs
       AND prtid = 'SUBENO'.
    IF lv_branchcodes IS INITIAL.
      READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = 'INC_BRNCH'.
      IF sy-subrc EQ 0 .
        lv_branchcodes = ls_custom_parameter-value.
      ENDIF.
    ENDIF.


    lv_apptype             = '1'.
    lv_datetype            = 'IssueDate'.
    lv_startdate           = |{ iv_date_from+0(4) }-{ iv_date_from+4(2) }-{ iv_date_from+6(2) }|.
    lv_enddate             = |{ iv_date_to+0(4) }-{ iv_date_to+4(2) }-{ iv_date_to+6(2) }|.
    lv_isnew               = 'false'.
    lv_isexport            = 'false'.
    lv_takenfromentegrator = 'ALL'.
    lv_isdraft             = 'false'.
*    lv_branchcodes         = ''.

    lv_url     = ms_company_parameters-wsend && 'GetDocumentList' &&
                 '?AppType='               && lv_apptype             &&
                 '&DateType='              && lv_datetype            &&
                 '&StartDate='             && lv_startdate           &&
                 '&EndDate='               && lv_enddate             &&
                 '&IsNew='                 && lv_isnew               &&
                 '&IsExport='              && lv_isexport            &&
                 '&TakenFromEntegrator='   && lv_takenfromentegrator &&
                 '&IsDraft='               && lv_isdraft             &&
                 '&BranchCodes='           && lv_branchcodes         .


    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response  = run_service_rest( iv_body              = lv_body
                                        iv_url            = lv_url
                                        iv_method         = 'GET'
                                        it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                         pretty_name = 'X'
                               CHANGING  data        = ls_list_result ).

    CLEAR:lv_response,lv_url,lv_body.

    SELECT SINGLE * FROM /itetr/com_cmpdp INTO ls_departmant WHERE defal = 'X'.

    LOOP AT ls_list_result-documents INTO ls_documents.

      lv_url     = ms_company_parameters-wsend && 'GetDocumentFile' &&
                   '?AppType=' && lv_apptype         &&
                   '&Uuid='    && ls_documents-uuid  &&
                   '&IsDraft=' && lv_isdraft         &&
                   '&Tur=XML'.

      lv_response  = run_service_rest( iv_body           = lv_body
                                       iv_url            = lv_url
                                       iv_method         = 'GET'
                                       it_request_header = lt_request_header ).


      /ui2/cl_json=>deserialize( EXPORTING json        = lv_response
                                           pretty_name = 'X'
                                 CHANGING  data        = ls_file_result ).

      lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = ls_file_result-documentfile ).
      lv_data        = lv_zipped_file.

      CHECK lv_data IS NOT INITIAL.

      cl_proxy_xml_transform=>xml_xstring_to_abap(
              EXPORTING
                ddic_type               = '/ITETR/COM_MESSAGE1'
                xml                     = lv_data
                ext_xml                 = abap_true
              IMPORTING
                abap_data               = ls_invoice ).

      APPEND INITIAL LINE TO rt_list ASSIGNING FIELD-SYMBOL(<ls_list>).
      "GetDocumentList Methodudan dönen veriler ile mapping yapıldı
      <ls_list>-envui  = ls_documents-envelopeuuid.
      <ls_list>-recdt  = |{ ls_documents-createddate+0(4) }{ ls_documents-createddate+5(2) }{ ls_documents-createddate+8(2) }|.
      <ls_list>-aliass = ls_documents-targetalias.
      <ls_list>-taxid  = ls_documents-targetidentifier.
      "GetDocumentList Methodudan dönen veriler ile mapping yapıldı
      <ls_list>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
      <ls_list>-bukrs = ms_company_parameters-bukrs.
      <ls_list>-invui = ls_invoice-part1-uuid-base-base-content.
      <ls_list>-invno = ls_invoice-part1-id-base-base-content.
      <ls_list>-invqi = ls_invoice-part1-uuid-base-base-content.
      REPLACE ALL OCCURRENCES OF '-' IN ls_invoice-part1-issue_date-base-content WITH ``.
      <ls_list>-bldat = ls_invoice-part1-issue_date-base-content(8).
      <ls_list>-waers = ls_invoice-part1-document_currency_code-base-base-content.
      <ls_list>-dmbtr = ls_invoice-part1-legal_monetary_total-line_extension_amount-base-content.
      <ls_list>-wrbtr = ls_invoice-part1-legal_monetary_total-payable_amount-base-content.
      <ls_list>-fwste = ls_invoice-part1-legal_monetary_total-tax_inclusive_amount-base-content -
                        ls_invoice-part1-legal_monetary_total-tax_exclusive_amount-base-content.
      <ls_list>-allowance = ls_invoice-part1-legal_monetary_total-allowance_total_amount-base-content."Indirim Tutarını Okuma
      READ TABLE ls_invoice-part1-withholding_tax_total INTO DATA(ls_tevkifat) INDEX 1."Tevkifat Tutarını Okuma
      <ls_list>-withholding = ls_tevkifat-tax_amount-base-content.
      READ TABLE ls_invoice-part1-despatch_document_reference INTO DATA(ls_doc_ref) INDEX 1." Gelen irsaliye numarası okuma
      IF sy-subrc EQ 0. " Gelen irsaliye numarası okuma
        <ls_list>-despid = ls_doc_ref-id-base-base-content."Gelen irsaliye numarası okuma
      ENDIF." Gelen irsaliye numarası okuma
      <ls_list>-orderid = ls_invoice-part1-order_reference-id-base-base-content.
      CALL FUNCTION 'CONVERSION_EXIT_YYPRF_INPUT'
        EXPORTING
          input  = ls_invoice-part1-profile_id-base-base-content
        IMPORTING
          output = <ls_list>-prfid.
      CALL FUNCTION 'CONVERSION_EXIT_YYINT_INPUT'
        EXPORTING
          input  = ls_invoice-part1-invoice_type_code-base-base-content
        IMPORTING
          output = <ls_list>-invty.
      <ls_list>-aprvd = abap_true.
      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'Identifier'.
            <ls_list>-aliass = ls_xml_line-cvalue.
          WHEN 'Contact'.
            IF <ls_list>-taxid IS INITIAL AND ls_xml_line-cvalue CA '0123456789'
              AND  ( strlen( ls_xml_line-cvalue ) = 10 OR strlen( ls_xml_line-cvalue ) = 11 ).

              <ls_list>-taxid = ls_xml_line-cvalue.
            ENDIF.
          WHEN 'InstanceIdentifier'.
            <ls_list>-envui = ls_xml_line-cvalue.
          WHEN 'CreationDateAndTime'.
            REPLACE ALL OCCURRENCES OF '-' IN ls_xml_line-cvalue WITH ``.
            <ls_list>-recdt = ls_xml_line-cvalue(8).
        ENDCASE.
      ENDLOOP.
      IF <ls_list>-prfid = 'TEMEL'.
        <ls_list>-resst = 'X'.
      ELSE.
        <ls_list>-resst = '0'.
        DATA(lv_difference) = sy-datum - <ls_list>-recdt.
        IF lv_difference GT 8.
          <ls_list>-resst = '2'.
        ENDIF.
      ENDIF.

      READ TABLE ls_invoice-part1-ublextensions-ublextension INTO ls_ublextension INDEX 1.
      IF sy-subrc EQ 0.
        lv_extension = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = ls_ublextension-extension_content-any ).
*        lv_extension = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = VALUE #( ls_invoice-part1-ublextensions-ublextension[ 1 ]-extension_content-any OPTIONAL ) ).
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

    ENDLOOP.
  ENDMETHOD.


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
    READ TABLE lt_result INTO DATA(ls_result) INDEX 1.
    IF sy-subrc EQ 0.
      rv_token = ls_result-token.
    ENDIF.






  ENDMETHOD.


  METHOD incoming_invoice_download.
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
          lv_output           TYPE string,
          lv_invoice          TYPE string.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    lv_token   = get_token( ).

    lv_apptype = '1'.
    lv_uuid    = is_document_numbers-duich.
    lv_isdraft = 'false'.

    IF iv_content_type EQ 'UBL'.
      lv_tur = 'XML'.
    ELSE.
      lv_tur = iv_content_type.
    ENDIF.

    lv_url     = ms_company_parameters-wsend && 'GetDocumentFile' &&
                 '?AppType=' && lv_apptype &&
                 '&Uuid='    && lv_uuid &&
                 '&Tur='     && lv_tur &&
                 '&IsDraft=' && lv_isdraft.

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

    rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).

  ENDMETHOD.


  METHOD incoming_invoice_get_status.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_document,
              uuid           TYPE string,
              envelopeuuid   TYPE string,
              documentid     TYPE string,
              status         TYPE string,
              statusexp      TYPE string,
              envelopestatus TYPE string,
              envelopeexp    TYPE string.
    TYPES END OF ty_document.

    DATA : BEGIN OF ls_result,
             documents   TYPE TABLE OF ty_document,
             issucceeded TYPE string,
             message     TYPE string.
    DATA END OF ls_result.


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
          ls_documents      TYPE ty_document,
          ls_inst           TYPE /itetr/inv_inst.

    DATA: BEGIN OF ls_data,
            apptype  TYPE string,
            guidlist TYPE TABLE OF string,
          END OF ls_data.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_data>           TYPE ty_document.

    lv_token = get_token( ).

    ls_data-apptype      = '1'.
    APPEND INITIAL LINE TO ls_data-guidlist ASSIGNING FIELD-SYMBOL(<fs_guidlist>).
    <fs_guidlist> = is_document_numbers-duich."Zarf Ettn. İçerisinde birden fazla belgenin durumu dönecek.

    lv_body = /ui2/cl_json=>serialize( data         = ls_data
                                       pretty_name  = 'X'
                                     ).


    "lv_url = 'https://econnecttest.hizliteknoloji.com.tr/HizliApi/RestApi/GetDocumentListGUID' .
    lv_url = ms_company_parameters-wsend && 'GetDocumentListGUID' .

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response = run_service_rest( iv_body           = lv_body
                                    iv_url            = lv_url
                                    iv_method         = 'POST'
                                    it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json    = lv_response
                                     pretty_name = 'X'
                           CHANGING  data        = ls_result ).
    "gkadioglu begin
    "uuid bazen kucuk harf geliyor
    LOOP AT ls_result-documents ASSIGNING <ls_data>.
      <ls_data>-uuid = to_upper( <ls_data>-uuid ).
    ENDLOOP.
    "gkadioglu end

    READ TABLE ls_result-documents INTO ls_documents WITH KEY uuid = is_document_numbers-duich.
    IF sy-subrc EQ 0.
      CASE ls_documents-status.
        WHEN '8'."Yanıt bekliyor
          rs_status-resst = '0'.
        WHEN '9' .
          rs_status-resst = '1'.
        WHEN '7'.
          rs_status-resst = '2'.
        WHEN '13' OR '15' OR '17'."Yanıt Verildi
          rs_status-resst = 'Y'.
      ENDCASE.


      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_inst
        WHERE intid = 'HTK'
          AND insta = ls_documents-envelopestatus.
      IF sy-subrc EQ 0.
        rs_status-radsc = ls_inst-radsc.
      ENDIF.

      SELECT SINGLE bezei
        FROM /itetr/inv_instx
        INTO rs_status-staex
        WHERE spras = sy-langu
          AND intid = 'HTK'
          AND insta = ls_documents-envelopestatus.

    ENDIF.


  ENDMETHOD.


  METHOD incoming_invoice_response.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


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
          ls_icinv          TYPE /itetr/inv_icinv.

    TYPES : BEGIN OF ty_document,
              documentdate TYPE string,
              documentid   TYPE string,
              documentuuid TYPE string,
            END OF ty_document.

    DATA: BEGIN OF ls_data,
            apptype             TYPE string,
            documents           TYPE TABLE OF ty_document,
            responsecode        TYPE string,
            responsedescription TYPE string,
          END OF ls_data.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    SELECT SINGLE * FROM /itetr/inv_icinv INTO ls_icinv WHERE docui EQ is_document_numbers-docui.

    lv_token = get_token( ).

    ls_data-apptype                   = '1'.
    ls_data-responsecode              = iv_response.
    ls_data-responsedescription       = ''."Zorunlu değil

    APPEND INITIAL LINE TO ls_data-documents ASSIGNING FIELD-SYMBOL(<fs_documents>).
    <fs_documents>-documentdate       = ls_icinv-bldat.
    <fs_documents>-documentid         = ls_icinv-invno.
    <fs_documents>-documentuuid       = ls_icinv-invui.

    lv_body = /ui2/cl_json=>serialize( data         = ls_data
                                       pretty_name  = 'X'
                                     ).


    "lv_url = 'https://econnecttest.hizliteknoloji.com.tr/HizliApi/RestApi/SendApplicationResponse' .
    lv_url = ms_company_parameters-wsend && 'SendApplicationResponse' .

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response = run_service_rest( iv_body           = lv_body
                                    iv_url            = lv_url
                                    iv_method         = 'POST'
                                    it_request_header = lt_request_header ).



  ENDMETHOD.


  method OUTGOING_INVOICE_CANCEL.
  endmethod.


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

    lv_apptype = '2'.
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

    lv_response = run_service_rest( iv_body               = lv_body
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


  METHOD outgoing_invoice_get_export.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*


    TYPES : BEGIN OF ty_document,
              uuid           TYPE string,
              envelopeuuid   TYPE string,
              documentid     TYPE string,
              status         TYPE string,
              statusexp      TYPE string,
              envelopestatus TYPE string,
              envelopeexp    TYPE string.
    TYPES END OF ty_document.

    DATA : BEGIN OF ls_result,
             documents   TYPE TABLE OF ty_document,
             issucceeded TYPE string,
             message     TYPE string.
    DATA END OF ls_result.


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
          ls_inst           TYPE /itetr/inv_inst.

    DATA: BEGIN OF ls_data,
            apptype  TYPE string,
            guidlist TYPE string,
          END OF ls_data.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    lv_token = get_token( ).

    ls_data-apptype                   = '2'.
    ls_data-guidlist                   = is_document_numbers-duich.
    lv_body = /ui2/cl_json=>serialize( data         = ls_data
                                       pretty_name  = 'X'
                                     ).


    "lv_url = 'https://econnecttest.hizliteknoloji.com.tr/HizliApi/RestApi/GetDocumentListGUID' .
    lv_url = ms_company_parameters-wsend && 'GetDocumentListGUID' .

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Authorization'.
    <ls_request_header>-value = |Bearer { lv_token }|.

    lv_response = run_service_rest( iv_body           = lv_body
                                    iv_url            = lv_url
                                    iv_method         = 'POST'
                                    it_request_header = lt_request_header ).

    /ui2/cl_json=>deserialize( EXPORTING json    = lv_response
                                     pretty_name = 'X'
                           CHANGING  data        = ls_result ).

    READ TABLE ls_result-documents INTO DATA(ls_documents) WITH KEY uuid       = is_document_numbers-duich
                                                                    documentid = is_document_numbers-docno.
    IF sy-subrc EQ 0.
      CASE ls_documents-status.
        WHEN '8'."Yanıt bekliyor
          rs_status-resst = '0'.
        WHEN '9'.
          rs_status-resst = '1'.
        WHEN '7'.
          rs_status-resst = '2'.
      ENDCASE.


      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_inst
        WHERE intid = 'HTK'
          AND insta = ls_documents-envelopestatus.
      IF sy-subrc EQ 0.
        rs_status-radsc = ls_inst-radsc.
      ENDIF.

      SELECT SINGLE bezei
        FROM /itetr/inv_instx
        INTO rs_status-staex
        WHERE spras = sy-langu
          AND intid = 'HTK'
          AND insta = ls_documents-envelopestatus.

    ENDIF.


  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  method OUTGOING_INVOICE_RESPONSE.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Monday, April 15, 2024  --------------------------------------------*
*&---------------------------------------------------------------------*

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
              issucceeded TYPE boolean_flg,
              message     TYPE char600.
    TYPES END OF ty_result.

    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response       TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_token          TYPE string,
          lv_body           TYPE string,
          lv_url            TYPE string,
          lt_data           TYPE TABLE OF ty_data,
          ls_data           TYPE  ty_data,
          lv_invoice        TYPE string,
          lv_documentid     TYPE char16,
          lv_documentuuid   TYPE string,
          lv_documentdate   TYPE char10,
          lt_result         TYPE TABLE OF ty_result.


    DATA: lx_exception TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.


    CALL FUNCTION 'CRM_IC_XML_XSTRING2STRING'
      EXPORTING
        inxstring = iv_ubl_xstring
      IMPORTING
        outstring = lv_invoice.

    FIND REGEX '<cbc:ID>(.*)</cbc:ID>'               IN lv_invoice SUBMATCHES lv_documentid.
    FIND REGEX '<cbc:UUID>(.*)</cbc:UUID>'           IN lv_invoice SUBMATCHES lv_documentuuid.
    FIND REGEX '<cbc:IssueDate>(.*)</cbc:IssueDate>' IN lv_invoice SUBMATCHES lv_documentdate.


    DATA(lv_ubl_string) = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_input = iv_ubl_xstring ).
    REPLACE ALL OCCURRENCES OF '<cbc:UBLVersionID>' IN lv_ubl_string WITH '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent><auto-generated-wildcard /></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.

    lv_token = get_token( ).

    ls_data-apptype               = '2'.                             " 2 : e-Fatura, 3 :e-Arşiv , 5 : e-İrsaliye , 6 : e-Serbest Meslek Makbuzu , 7 : e-Müstahsil Makbuzu , 11:e-Döviz Belgesi , 12:e-Adisyon Belgesi
    ls_data-sourceurn             = ms_company_parameters-gb_alias.  " SatıcıGB Adresi
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

    READ TABLE lt_result INTO DATA(ls_result) INDEX 1.
    IF ls_result-issucceeded EQ ''.

      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_result-message(50)
                                                                       iv_msgv2 = ls_result-message+50(50)
                                                                       iv_msgv3 = ls_result-message+100(50)
                                                                       iv_msgv4 = ls_result-message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.


  ENDMETHOD.


  method OUTGOING_INVOICE_SEND_AGAIN.
  endmethod.


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


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE '{ "secretKey": "' ms_company_parameters-secretkey '", "username": "' ms_company_parameters-wsusr '", "password": "' ms_company_parameters-wspwd '" }' INTO lv_body.

*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name  = 'Content-Type'.
*    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    "gkadioglu
    lv_url = ms_company_parameters-wsend && 'UtilEncrypt'.

    lv_response = run_service_rest( iv_body        = lv_body
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