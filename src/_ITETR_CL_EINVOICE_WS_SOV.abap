class /ITETR/CL_EINVOICE_WS_SOV definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
  final
  create public .

public section.

  types MTY_XML_TABLE type SRT_XML_DATA_TAB .
  types:
    BEGIN OF mty_document_status,
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
  types:
    BEGIN OF mty_incoming_document,
        belgeno                 TYPE string,
        belgesirano             TYPE string,
        belgetarihi             TYPE string,
        ettn                    TYPE string,
        zarfid                  TYPE string,
        gonderenetiket          TYPE string,
        gonderenvkntckn         TYPE string,
        belgexmlzipped          TYPE string,
        odenecektutar           TYPE string,
        odenecektutardovizcinsi TYPE string,
      END OF mty_incoming_document .
  types:
    mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .

  constants MC_ERPCODE_PARAMETER type /ITETR/COM_E_CUSPA value 'ERPCODE' ##NO_TEXT.

  methods SET_INCOMING_INVOICE_RECEIVED
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DUICH
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods INCOMING_INVOICE_READ
    importing
      !IT_REQUEST type /ITETR/INV_TT_GETUBL_REQUEST
      !IV_CONTENT_TYPE type /ITETR/COM_E_CONTY
    returning
      value(RT_INVOICE_DATA) type /ITETR/INV_TT_GETUBL_RESPONSE
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods PARSE_XML_TO_TABLE
    importing
      !IV_XML type STRING
    returning
      value(RT_XML_TABLE) type MTY_XML_TABLE
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
private section.
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS_SOV IMPLEMENTATION.


  METHOD download_registered_taxpayers.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
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
          ls_alias          TYPE /itetr/inv_s_userlist_alias.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<ein:getRAWUserListRequest>'
         '<ein:Identifier>' ms_company_parameters-gb_alias '</ein:Identifier>'
         '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
         '<ein:Role>PK</ein:Role>'                                             "*>YiğitcanÖ.
      '</ein:getRAWUserListRequest>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getRAWUserList'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'DocData'.
          CONCATENATE lv_base64_content ls_xml_line-cvalue INTO lv_base64_content.
      ENDCASE.
    ENDLOOP.

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
      IF lv_count LE  lv_parca_sayi.

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


    " end partial for memory

    DATA: lv_deletion_date TYPE datum.
    DATA : lt_default_allias TYPE TABLE OF /itetr/inv_allis.
    " SELECT * FROM /itetr/inv_taxp INTO TABLE lt_default_allias WHERE defal EQ abap_true.
    SELECT * FROM /itetr/inv_allis INTO TABLE lt_default_allias .
    SORT lt_default_allias BY taxid aliass.

    LOOP AT ls_user_list-user INTO ls_user.

      CLEAR ls_taxpayer.
      CASE ls_user-type.
        WHEN 'OZEL'.
          ls_taxpayer-txpty = 'OZEL'.
        WHEN OTHERS.
          ls_taxpayer-txpty = 'KAMU'.
      ENDCASE.


      LOOP AT ls_user-documents INTO ls_documents WHERE document = 'Invoice'. "YiğitcanÖ. 04102023

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

    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_table        TYPE smum_xmltb,
          lt_request_header   TYPE mty_service_header_tab,
          lv_invui            TYPE /itetr/com_e_duich,
          lv_content          TYPE xstring,
          ls_document_numbers TYPE /itetr/com_s_document_numbers,
          ls_invoice          TYPE /itetr/com_message1,
          lv_attachment_count TYPE i,
          ls_additional       TYPE /itetr/com_additional_document,
          ls_taxes            TYPE /itetr/com_tax_total,
          lx_root             TYPE REF TO cx_root,
          ls_tevkifat         TYPE /itetr/com_withholding_tax_tot,
          ls_doc_ref          TYPE /itetr/com_despatch_document_r,
          lv_invoice          TYPE string,
          ls_despatch         TYPE /itetr/inv_icdes,
          lt_icinv            TYPE TABLE OF /itetr/inv_icinv,
          lv_tabix            TYPE sy-tabix,
          ls_ublextension     TYPE /itetr/com_ublextension,
          lv_extension        TYPE string,
          lv_uri              TYPE string,
          lv_digest           TYPE string,
          lv_offset           TYPE i,
          ls_departmant       TYPE /itetr/com_cmpdp.

    FIELD-SYMBOLS: <ls_list>           TYPE /itetr/inv_icinv,
                   <lv_invoice_field>  TYPE any,
                   <ls_request_header> TYPE mty_service_header.

    DATA: lv_taraf      TYPE text1000,
          lv_difference TYPE i.

    DATA : lt_request       TYPE  /itetr/inv_tt_getubl_request,
           lt_response_temp TYPE  /itetr/inv_tt_getubl_response,
           lt_response      TYPE  /itetr/inv_tt_getubl_response.

    DATA lv_invoice_temp TYPE string.
    DATA lv_check.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
     '<soapenv:Header/>'
      '<soapenv:Body>'
       '<ein:getUBLListRequest>'
          '<ein:Identifier>' ms_company_parameters-pk_alias '</ein:Identifier>'
          '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
          '<ein:DocType>INVOICE</ein:DocType>'
          '<ein:Type>INBOUND</ein:Type>'
          '<ein:FromDate>' iv_date_from+0(4) '-' iv_date_from+4(2) '-' iv_date_from+6(2) 'T00:00:00.000+02:00</ein:FromDate>'
          '<ein:ToDate>' iv_date_to+0(4) '-' iv_date_to+4(2) '-' iv_date_to+6(2) 'T00:00:00.000+02:00</ein:ToDate>'
       '</ein:getUBLListRequest>'
      '</soapenv:Body>'
     '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getUBLList'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_table.
      CASE ls_xml_table-cname.
        WHEN 'EnvUUID'.
          <ls_list>-envui = ls_xml_table-cvalue.
        WHEN 'UUID'.
          APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.
          <ls_list>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
          <ls_list>-bukrs = ms_company_parameters-bukrs.
          <ls_list>-invui = ls_xml_table-cvalue.
          <ls_list>-invqi = ls_xml_table-cvalue.
        WHEN 'VKN_TCKN '.
          <ls_list>-taxid = ls_xml_table-cvalue.
        WHEN 'Identifier'.
          <ls_list>-aliass = ls_xml_table-cvalue.
        WHEN 'ID'.
          <ls_list>-invno = ls_xml_table-cvalue.
        WHEN 'InsertDateTime'.
          REPLACE ALL OCCURRENCES OF '-' IN ls_xml_table-cvalue WITH ``.
          <ls_list>-recdt = ls_xml_table-cvalue(8).
      ENDCASE.
    ENDLOOP.

    IF rt_list IS NOT INITIAL.
      SELECT *
        FROM /itetr/inv_icinv
        INTO TABLE lt_icinv
        FOR ALL ENTRIES IN rt_list
        WHERE invno EQ rt_list-invno.

      LOOP AT rt_list INTO DATA(ls_list).
        lv_tabix = sy-tabix.
        READ TABLE lt_icinv  WITH KEY invui = ls_list-invui TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0 .
          APPEND INITIAL LINE TO lt_request ASSIGNING FIELD-SYMBOL(<fs_request>).
          <fs_request>-invui = ls_list-invui.
        ELSE.
          DELETE rt_list INDEX lv_tabix.
        ENDIF.

        IF lines( lt_request ) = 20.
          lt_response_temp = incoming_invoice_read(
                        it_request      = lt_request
                        iv_content_type = 'UBL' ).

          APPEND LINES OF lt_response_temp TO lt_response.
          CLEAR : lt_response_temp,lt_request.

        ENDIF.

      ENDLOOP.

      IF lines( lt_request ) > 0.                      "20 li paketin dışında kalanlar için.
        lt_response_temp = incoming_invoice_read(
                      it_request      = lt_request
                      iv_content_type = 'UBL' ).

        APPEND LINES OF lt_response_temp TO lt_response.
        CLEAR : lt_response_temp, lt_request.
      ENDIF.

    ENDIF.

    SELECT SINGLE * FROM /itetr/com_cmpdp INTO ls_departmant WHERE defal = 'X'.


    LOOP AT lt_response INTO DATA(ls_response).
      CLEAR: lv_check , lv_invoice_temp.

      CALL FUNCTION 'CRM_IC_XML_XSTRING2STRING'
        EXPORTING
          inxstring = ls_response-content
        IMPORTING
          outstring = lv_invoice.

      lv_invoice_temp = lv_invoice.

      REPLACE ALL OCCURRENCES OF REGEX '<cac:PartyLegalEntity>' IN lv_invoice_temp WITH space.
      IF sy-subrc IS  INITIAL.
        lv_check = 'X'.
      ENDIF.
      IF lv_check IS NOT INITIAL.
        REPLACE ALL OCCURRENCES OF REGEX '<cbc:RegistrationName>SETAŞ KİMYA SANAYİ A.Ş.</cbc:RegistrationName>' IN lv_invoice_temp WITH space.
        IF sy-subrc IS  INITIAL.
          lv_check = 'X'.
        ELSE.
          REPLACE ALL OCCURRENCES OF REGEX '<cbc:RegistrationName>Setaş Kimya Sanayi A.Ş.</cbc:RegistrationName>' IN lv_invoice_temp WITH space.
          IF sy-subrc IS NOT INITIAL.
            CLEAR lv_check.
          ELSE.
            lv_check = 'X'.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_check IS NOT INITIAL.
        REPLACE ALL OCCURRENCES OF REGEX '</cac:PartyLegalEntity>' IN lv_invoice_temp WITH space.
        IF sy-subrc IS  INITIAL.
          lv_check = 'X'.
        ELSE.
          CLEAR lv_check.
        ENDIF.
      ENDIF.

      IF lv_check IS INITIAL.
        REPLACE ALL OCCURRENCES OF REGEX '<ns3:PartyLegalEntity>' IN lv_invoice_temp WITH space.
        IF sy-subrc IS  INITIAL.
          lv_check = 'X'.
        ELSE.
          CLEAR lv_check.
        ENDIF.
        IF lv_check IS NOT INITIAL.
          REPLACE ALL OCCURRENCES OF REGEX '<ns2:RegistrationName>Setaş Kimya Sanayi A.Ş.</ns2:RegistrationName>' IN lv_invoice_temp WITH space.
          IF sy-subrc IS  INITIAL.
            lv_check = 'X'.
          ELSE.
            REPLACE ALL OCCURRENCES OF REGEX '<ns2:RegistrationName>SETAŞ KİMYA SANAYİ A.Ş.</ns2:RegistrationName>' IN lv_invoice_temp WITH space.
            IF sy-subrc IS NOT INITIAL.
              CLEAR lv_check.
            ENDIF.
          ENDIF.
        ENDIF.


        IF lv_check IS NOT INITIAL.
          REPLACE ALL OCCURRENCES OF REGEX '</ns3:PartyLegalEntity>' IN lv_invoice_temp WITH space.
          IF sy-subrc IS  INITIAL.
            lv_check = 'X'.
          ELSE.
            CLEAR lv_check.
          ENDIF.
        ENDIF.
      ENDIF.
      IF lv_check IS NOT INITIAL.
        lv_invoice =  lv_invoice_temp.
      ENDIF.

*      REPLACE ALL OCCURRENCES OF REGEX '<cac:PartyLegalEntity>' IN lv_invoice WITH space.
*      REPLACE ALL OCCURRENCES OF REGEX '<cbc:RegistrationName>SETAŞ KİMYA SANAYİ A.Ş.</cbc:RegistrationName>' IN lv_invoice WITH space.
*      REPLACE ALL OCCURRENCES OF REGEX '</cac:PartyLegalEntity>' IN lv_invoice WITH space.
*
*      REPLACE ALL OCCURRENCES OF REGEX '<ns3:PartyLegalEntity>' IN lv_invoice WITH space.
*      REPLACE ALL OCCURRENCES OF REGEX '<ns2:RegistrationName>Setaş Kimya Sanayi A.Ş.</ns2:RegistrationName>' IN lv_invoice WITH space.
*      REPLACE ALL OCCURRENCES OF REGEX '</ns3:PartyLegalEntity>' IN lv_invoice WITH space.

      CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
        EXPORTING
          text   = lv_invoice
        IMPORTING
          buffer = lv_content
        EXCEPTIONS
          failed = 1
          OTHERS = 2.                                  "23012024 Added "YiğitcanÖ.

      cl_proxy_xml_transform=>xml_xstring_to_abap(
        EXPORTING
          ddic_type               = '/ITETR/COM_MESSAGE1'
          xml                     = lv_content
          ext_xml                 = abap_true
        IMPORTING
          abap_data               = ls_invoice ).

      READ TABLE rt_list ASSIGNING <ls_list> WITH KEY invno = ls_invoice-part1-id-base-base-content.
      IF sy-subrc EQ 0.
        ls_document_numbers-docui = <ls_list>-docui.
        ls_document_numbers-duich = <ls_list>-invui.
        ls_document_numbers-docno = <ls_list>-invno.
        ls_document_numbers-envui = <ls_list>-envui.

        <ls_list>-invqi = ls_invoice-part1-uuid-base-base-content.
        REPLACE ALL OCCURRENCES OF '-' IN ls_invoice-part1-issue_date-base-content WITH ``.
        <ls_list>-bldat = ls_invoice-part1-issue_date-base-content(8).
*      <ls_list>-recdt = ls_invoice-part1-issue_date-base-content(8).
        <ls_list>-waers = ls_invoice-part1-document_currency_code-base-base-content.
        <ls_list>-dmbtr = ls_invoice-part1-legal_monetary_total-line_extension_amount-base-content.
        <ls_list>-wrbtr = ls_invoice-part1-legal_monetary_total-payable_amount-base-content.

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

        CLEAR lv_attachment_count.
        LOOP AT ls_invoice-part1-additional_document_reference INTO ls_additional.
          lv_attachment_count = lv_attachment_count + 1.
        ENDLOOP.
        LOOP AT ls_invoice-part1-tax_total INTO ls_taxes.
          <ls_list>-fwste = <ls_list>-fwste + ls_taxes-tax_amount-base-content.
        ENDLOOP.
        IF lv_attachment_count > 1.
          <ls_list>-attex = abap_true.
        ENDIF.

        TRY.
            <ls_list>-kursf = ls_invoice-part1-pricing_exchange_rate-calculation_rate-base-base-content."Kur bilgisi eklemesi
          CATCH cx_root INTO lx_root.
            CLEAR <ls_list>-kursf.
        ENDTRY.

        "YiğitcanÖ. 10052023
        IF <ls_list>-prfid = 'TEMEL'.
          <ls_list>-resst = 'X'.
        ELSE.
          <ls_list>-resst = '0'.
          lv_difference = sy-datum - <ls_list>-recdt.
          IF lv_difference GT 8.
            <ls_list>-resst = '2'.
          ENDIF.
        ENDIF.
        "YiğitcanÖ. 10052023

        <ls_list>-orderid = ls_invoice-part1-order_reference-id-base-base-content.
        <ls_list>-allowance = ls_invoice-part1-legal_monetary_total-allowance_total_amount-base-content."Indirim Tutarını Okuma
        READ TABLE ls_invoice-part1-withholding_tax_total INTO ls_tevkifat INDEX 1."Tevkifat Tutarını Okuma
        IF sy-subrc EQ 0.
          <ls_list>-withholding = ls_tevkifat-tax_amount-base-content.
        ENDIF.
        READ TABLE ls_invoice-part1-despatch_document_reference INTO ls_doc_ref INDEX 1."AS Gelen irsaliye numarası okuma
        IF sy-subrc EQ 0. "AS Gelen irsaliye numarası okuma
          <ls_list>-despid = ls_doc_ref-id-base-base-content."AS Gelen irsaliye numarası okuma
        ENDIF."AS Gelen irsaliye numarası okuma

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
        CLEAR : lv_difference,lv_content.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD incoming_invoice_download.

    DATA: lv_request_xml    TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_content        TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_content_type   TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    IF iv_content_type EQ 'DEF'.
      lv_content_type = 'HTML_DEFAULT'.
    ELSE.
      lv_content_type = iv_content_type.
    ENDIF.

    IF iv_content_type EQ 'UBL'.

      CONCATENATE
         '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
           '<soapenv:Header/>'
           '<soapenv:Body>'
              '<ein:getUBLRequest>'
                 '<ein:Identifier>' ms_company_parameters-pk_alias '</ein:Identifier>'
                 '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
                 '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
                 '<ein:DocType>INVOICE</ein:DocType>'
                 '<ein:Type>INBOUND</ein:Type>'
                 '<ein:Parameters>zip</ein:Parameters>'
              '</ein:getUBLRequest>'
           '</soapenv:Body>'
         '</soapenv:Envelope>'
         INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'getUBL'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'DocData'.
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


      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<ein:getInvoiceViewRequest>'
               '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
*             '<ein:CustInvID> </ein:CustInvID>'
               '<ein:Identifier>' ms_company_parameters-pk_alias '</ein:Identifier>'
               '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
               '<ein:Type>INBOUND</ein:Type>'
               '<ein:DocType>' lv_content_type '</ein:DocType>'
            '</ein:getInvoiceViewRequest>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'getInvoiceView'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'DocData'.
            CONCATENATE lv_content
                ls_xml_line-cvalue
                INTO lv_content.
        ENDCASE.
      ENDLOOP.

      IF lv_content IS NOT INITIAL.
        rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_content ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD incoming_invoice_get_status.

    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lt_request_header   TYPE mty_service_header_tab.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<ein:getInvResponsesRequest>'
           '<ein:Identifier>' ms_company_parameters-pk_alias '</ein:Identifier>'
           '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
           '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
           '<ein:Type>INBOUND</ein:Type>'
           '<ein:Parameters>DOC_DATA</ein:Parameters>'
        '</ein:getInvResponsesRequest>'
     '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getInvResponses'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ARType'.
    IF sy-subrc EQ 0.
      IF ls_xml_line-cvalue EQ 'KABUL'.
        rs_status-resst = '2'.
      ELSE.
        rs_status-resst = '1'.
      ENDIF.
    ENDIF.

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ARNotes'.
    IF sy-subrc EQ 0.
      rs_status-staex = ls_xml_line-cvalue.
    ENDIF.

  ENDMETHOD.


  METHOD incoming_invoice_read.

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lt_request_header TYPE mty_service_header_tab,
          lv_content        TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_tabix          TYPE sy-tabix,
          lt_xml            TYPE srt_xml_data_tab,
          ls_xml            TYPE srt_xml_data.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
         '<ein:getUBLRequest>'
            '<ein:Identifier>' ms_company_parameters-pk_alias '</ein:Identifier>'
            '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
*            '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
    INTO lv_request_xml.
    LOOP AT it_request INTO DATA(ls_request).
      CONCATENATE lv_request_xml '<ein:UUID>' ls_request-invui '</ein:UUID>' INTO lv_request_xml.
    ENDLOOP.
    CONCATENATE lv_request_xml
            '<ein:DocType>INVOICE</ein:DocType>'
            '<ein:Type>INBOUND</ein:Type>'
            '<ein:Parameters>zip</ein:Parameters>'
         '</ein:getUBLRequest>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getUBL'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).
    "gkadioglu  12082024
    lt_xml = parse_xml_to_table( lv_response_xml ).
    LOOP AT lt_xml INTO ls_xml WHERE tag_name = 'DocData'.
      IF rt_invoice_data IS INITIAL.
        APPEND INITIAL LINE TO rt_invoice_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      ENDIF.
      IF ls_xml-tag_value IS NOT INITIAL.
        lv_content = ls_xml-tag_value.
        lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
        /itetr/cl_regulative_common=>unzip_file_single(
          EXPORTING
            iv_zipped_file_xstr = lv_zipped_file
          IMPORTING
            ev_output_data_xstr = <fs_data>-content ).
        CLEAR lv_content.
        APPEND INITIAL LINE TO rt_invoice_data ASSIGNING <fs_data>.
      ENDIF.
    ENDLOOP.

    "bazi belgelerde sorun oldugu icin bu kod blogu kapatildi begin
*    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
*    LOOP AT lt_xml_table INTO ls_xml_line.
*      IF rt_invoice_data IS INITIAL.
*        APPEND INITIAL LINE TO rt_invoice_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      ENDIF.
*      CASE ls_xml_line-cname.
*        WHEN 'DocData'.
*          CONCATENATE lv_content ls_xml_line-cvalue INTO lv_content.
*      ENDCASE.
*      IF ls_xml_line-type = 'V'.
*        CONCATENATE lv_content ls_xml_line-cvalue INTO lv_content.
*
*        IF lv_content IS NOT INITIAL.
*          lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
*          /itetr/cl_regulative_common=>unzip_file_single(
*            EXPORTING
*              iv_zipped_file_xstr = lv_zipped_file
*            IMPORTING
*              ev_output_data_xstr = <fs_data>-content ).
*          CLEAR lv_content.
*        ENDIF.
*
*        APPEND INITIAL LINE TO rt_invoice_data ASSIGNING <fs_data>.
*      ENDIF.
*    ENDLOOP.
    "gkadioglu 12082024
    DELETE rt_invoice_data WHERE content IS INITIAL.

**  LOOP AT rt_invoice_data ASSIGNING <fs_data>.
**    IF <fs_data>-content IS NOT INITIAL.
**      lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = <fs_data>-content ).
**      /itetr/cl_regulative_common=>unzip_file_single(
**        EXPORTING
**          iv_zipped_file_xstr = lv_zipped_file
**        IMPORTING
**          ev_output_data_xstr = <fs_data>-content ).
**    ENDIF.

  ENDMETHOD.


  METHOD incoming_invoice_response.

    DATA: lv_appres_base64  TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lv_appres_xml     TYPE xstring,
          lv_appres_hash    TYPE md5_fields-hash.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    build_application_response(
      EXPORTING
        is_document_numbers = is_document_numbers
        iv_response         = iv_response
        iv_note             = iv_note
      IMPORTING
        ev_response_xml  = lv_appres_xml
        ev_response_hash = lv_appres_hash ).


    CONCATENATE is_document_numbers-duich '.xml' INTO lv_file_name.
    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = lv_appres_xml
                                                                   iv_input_name = lv_file_name ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_appres_base64.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<ein:sendUBLRequest>'
          '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
          '<ein:SenderIdentifier>' ms_company_parameters-pk_alias '</ein:SenderIdentifier>'
          '<ein:ReceiverIdentifier>' iv_receiver_alias '</ein:ReceiverIdentifier>'
          '<ein:DocType>APP_RESP</ein:DocType>'
          '<ein:DocData>' lv_appres_base64 '</ein:DocData>'
        '</ein:sendUBLRequest>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'sendUBL'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

  ENDMETHOD.


  method OUTGOING_INVOICE_CANCEL.
  endmethod.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml    TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_content        TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_content_type   TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    IF iv_content_type EQ 'UBL'.

      CONCATENATE
         '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
           '<soapenv:Header/>'
           '<soapenv:Body>'
              '<ein:getUBLRequest>'
                 '<ein:Identifier>' ms_company_parameters-gb_alias '</ein:Identifier>'
                 '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
                 '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
                 '<ein:DocType>INVOICE</ein:DocType>'
                 '<ein:Type>OUTBOUND</ein:Type>'
                 '<ein:Parameters>zip</ein:Parameters>'
              '</ein:getUBLRequest>'
           '</soapenv:Body>'
         '</soapenv:Envelope>'
         INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'getUBL'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'DocData'.
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

      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<ein:getInvoiceViewRequest>'
               '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
*             '<ein:CustInvID> </ein:CustInvID>'
               '<ein:Identifier>' ms_company_parameters-gb_alias '</ein:Identifier>'
               '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
               '<ein:Type>OUTBOUND</ein:Type>'
               '<ein:DocType>' iv_content_type '</ein:DocType>'
            '</ein:getInvoiceViewRequest>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'getInvoiceView'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'DocData'.
            CONCATENATE lv_content
                ls_xml_line-cvalue
                INTO lv_content.
        ENDCASE.
      ENDLOOP.
      IF lv_content IS NOT INITIAL.
        rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_content ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_get_export. "YiğitcanÖ. 08022024

    DATA: lv_request_xml    TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          ls_int_status     TYPE /itetr/inv_inst.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<ein:getEnvelopeStatusRequest>'
             '<ein:Identifier>' ms_company_parameters-gb_alias '</ein:Identifier>'
             '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
             '<ein:UUID>' is_document_numbers-docii  '</ein:UUID>'
             '<ein:Parameters>DOC_DATA</ein:Parameters>'
          '</ein:getEnvelopeStatusRequest>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getEnvelopeStatus'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ResponseCode'.
    IF sy-subrc IS INITIAL.
      rs_status-radsc = ls_xml_line-cvalue.
    ENDIF.

    IF rs_status-radsc IS NOT INITIAL.
      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_int_status
        WHERE intid = 'SOV'
          AND radsc = rs_status-radsc.
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING ls_int_status TO rs_status.
        SELECT SINGLE bezei
          FROM /itetr/inv_instx
          INTO rs_status-staex
          WHERE spras = sy-langu
            AND intid = 'SOV'
            AND insta = ls_int_status-insta.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.

    DATA: lv_request_xml    TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          ls_int_status     TYPE /itetr/inv_inst.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<ein:getEnvelopeStatusRequest>'
             '<ein:Identifier>' ms_company_parameters-gb_alias '</ein:Identifier>'
             '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
*             '<ein:UUID>' is_document_numbers-envui '</ein:UUID>'
             '<ein:UUID>' is_document_numbers-docii '</ein:UUID>' "YiğitcanÖ. 10102023
             '<ein:Parameters>DOC_DATA</ein:Parameters>'
          '</ein:getEnvelopeStatusRequest>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getEnvelopeStatus'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ResponseCode'.
    IF sy-subrc IS INITIAL.
      rs_status-radsc = ls_xml_line-cvalue.
    ENDIF.

    IF rs_status-radsc IS NOT INITIAL.
      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_int_status
        WHERE intid = 'SOV'
          AND radsc = rs_status-radsc.
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING ls_int_status TO rs_status.
        SELECT SINGLE bezei
          FROM /itetr/inv_instx
          INTO rs_status-staex
          WHERE spras = sy-langu
            AND intid = 'SOV'
            AND insta = ls_int_status-insta.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_response.
    "YiğitcanÖzdemir 02012024

    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<ein:getInvResponsesRequest>'
             '<ein:Identifier>' ms_company_parameters-gb_alias '</ein:Identifier>'
             '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
             '<!--1 or more repetitions:-->'
             '<ein:UUID>' is_document_numbers-duich '</ein:UUID>'
             '<ein:Type>OUTBOUND</ein:Type>'
*             '<ein:Parameters>'?'</ein:Parameters>'
          '</ein:getInvResponsesRequest>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'getInvResponses'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'ARType'.
          IF ls_xml_line-cvalue EQ 'RED'.
            rs_status-resst = '1'.
          ELSEIF ls_xml_line-cvalue EQ 'KABUL'.
            rs_status-resst = '2'.
          ENDIF.
      ENDCASE.
    ENDLOOP.



  ENDMETHOD.


  METHOD outgoing_invoice_send.
    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE is_ubl_structure-part1-uuid-base-base-content '.xml' INTO lv_file_name.
    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = iv_ubl_xstring
                                                                   iv_input_name = lv_file_name ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<ein:sendUBLRequest>'
          '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
          '<ein:SenderIdentifier>' ms_company_parameters-gb_alias '</ein:SenderIdentifier>'
          '<ein:ReceiverIdentifier>' iv_receiver_alias '</ein:ReceiverIdentifier>'
          '<ein:DocType>INVOICE</ein:DocType>'
          '<ein:DocData>' lv_invoice_base64 '</ein:DocData>'
        '</ein:sendUBLRequest>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'sendUBL'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'EnvUUID'.
          ev_integrator_uuid = ls_xml_line-cvalue.
          ev_envelope_uuid = ls_xml_line-cvalue.
        WHEN 'ID'.
          ev_invoice_no = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD outgoing_invoice_send_again.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lt_request_header TYPE mty_service_header_tab.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http:/fitcons.com/eInvoice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<ein:sendUBLRequest>'
          '<ein:VKN_TCKN>' mv_company_taxid '</ein:VKN_TCKN>'
          '<ein:SenderIdentifier>' ms_company_parameters-gb_alias '</ein:SenderIdentifier>'
          '<ein:DocType>ENVELOPE</ein:DocType>'
          '<ein:Parameters>RESEND:' ev_envelope_uuid '</ein:Parameters>'
        '</ein:sendUBLRequest>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'sendUBL'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

  ENDMETHOD.


  METHOD parse_xml_to_table.
    DATA: lv_xml_raw    TYPE xstring,
          ls_return     TYPE bapiret2,
          lt_return     TYPE TABLE OF bapiret2,
          lv_error_text TYPE string.
    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = iv_xml
      IMPORTING
        buffer = lv_xml_raw
      EXCEPTIONS
        failed = 1
        OTHERS = 2.

    CALL FUNCTION 'SRTUTIL_CONVERT_XML_TO_TABLE'
      EXPORTING
        xdoc       = lv_xml_raw
      IMPORTING
        error_text = lv_error_text
        data       = rt_xml_table.
    IF sy-subrc <> 0.
      ls_return-type = 'E'.
      ls_return-message = lv_error_text.
      APPEND ls_return TO lt_return.
    ENDIF.
  ENDMETHOD.


  METHOD set_incoming_invoice_received.

        DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb.

    CONCATENATE
     '<soapenv:Envelope xmlns:ein="http:/fitcons.com/eInvoice/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<ein:getEnvelopeStatusRequest>'
               '<ein:Identifier>' ms_company_parameters-wsusr '</ein:Identifier>'
               '<ein:VKN_TCKN>' ms_company_parameters-wspwd '</ein:VKN_TCKN>'
               '<ein:UUID>' iv_document_uuid '</ein:UUID>'
          '</ein:getEnvelopeStatusRequest>'
       '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
  ENDMETHOD.
ENDCLASS.