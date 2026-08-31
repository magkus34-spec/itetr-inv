class /ITETR/CL_EINVOICE_WS_LOG definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
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



CLASS /ITETR/CL_EINVOICE_WS_LOG IMPLEMENTATION.


  METHOD download_registered_taxpayers.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 02, 2024 ---------------------------------------------*
*&---------------------------------------------------------------------*


    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_sessionid      TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF srt_xml_data,
          ls_xml_line       TYPE srt_xml_data,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          ls_user_list      TYPE /itetr/inv_s_userlist,
          ls_user_list2     TYPE /itetr/inv_s_userlist,
          ls_user           TYPE /itetr/inv_s_user,
          ls_documents      TYPE /itetr/inv_s_userlist_doc,
          ls_alias          TYPE /itetr/inv_s_userlist_alias,
          lv_base64_content TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.


    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:efat="http://schemas.datacontract.org/2004/07/eFaturaWebService">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<tem:getUserListNew>'
           '<!--Optional:-->'
           '<tem:login>'
              '<efat:appStr>?</efat:appStr>'
              '<efat:passWord>' me->ms_company_parameters-wspwd '</efat:passWord>'
              '<efat:source>?</efat:source>'
              '<efat:userName>' me->ms_company_parameters-wsusr '</efat:userName>'
              '<efat:version>?</efat:version>'
           '</tem:login>'
           '<!--Optional:-->'
           '<tem:listType>PKLIST</tem:listType>'
        '</tem:getUserListNew>'
     '</soapenv:Body>'
  '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/getUserListNew'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table_2( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-tag_name.
        WHEN 'a:Value'.
          CONCATENATE lv_base64_content ls_xml_line-tag_value INTO lv_base64_content.
      ENDCASE.
    ENDLOOP.

    lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).
********
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
**************


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

*******************************************

**    /itetr/cl_regulative_common=>unzip_file_single(
**      EXPORTING
**        iv_zipped_file_xstr = lv_zipped_file
**      IMPORTING
**        ev_output_data_str = lv_taxpayers_xml ).
**
**    CALL TRANSFORMATION /itetr/inv_userlist
**      SOURCE XML lv_taxpayers_xml
**      RESULT userlist = ls_user_list.

    DATA: lv_deletion_date TYPE datum.
    DATA : lt_default_allias TYPE TABLE OF /itetr/inv_allis.
    "SELECT * FROM /itetr/inv_taxp INTO TABLE lt_default_allias.
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
      LOOP AT ls_user-documents INTO ls_documents WHERE document = 'Invoice' .
        LOOP AT ls_documents-alias INTO ls_alias WHERE deletiontime IS INITIAL.
          IF ls_alias IS NOT INITIAL.
**            REPLACE ALL OCCURRENCES OF '-' IN ls_alias-creationtime WITH ''.
**            REPLACE ALL OCCURRENCES OF ':' IN ls_alias-creationtime WITH ''.
**            ls_taxpayer-regdt = ls_alias-creationtime(8).
**            ls_taxpayer-regtm = ls_alias-creationtime+9(6).
            REPLACE ALL OCCURRENCES OF '-' IN ls_user-firstcreationtime WITH ''.
            REPLACE ALL OCCURRENCES OF ':' IN ls_user-firstcreationtime WITH ''.
            REPLACE ALL OCCURRENCES OF '-' IN ls_alias-deletiontime WITH ''.
            REPLACE ALL OCCURRENCES OF ':' IN ls_alias-deletiontime WITH ''.
            ls_taxpayer-regdt = ls_user-firstcreationtime(8).
            ls_taxpayer-regtm = ls_user-firstcreationtime+9(6).
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
          CLEAR: ls_taxpayer-defal.
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD DOWNLOAD_REGISTERED_TAXP_TIME.

  ENDMETHOD.


  METHOD get_incoming_invoices.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 03, 2024 ---------------------------------------------*
*&---------------------------------------------------------------------*


    DATA : BEGIN OF ls_detail,
             uuid            TYPE string,
             envelopeid      TYPE string,
             issuedate       TYPE string,
             suppliervkntckn TYPE string,
             gbalias         TYPE string.
    DATA END OF ls_detail.

    TYPES : BEGIN OF ty_documents,
              documentuuid TYPE string,
              string       TYPE string.
    TYPES END OF ty_documents.

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
          lv_content        TYPE string,
          lt_documents      TYPE TABLE OF ty_documents,
          ls_documents      TYPE  ty_documents,
          lv_data           TYPE /itetr/com_e_contn,
          ls_invoice        TYPE /itetr/com_message1,
          ls_despatch       TYPE /itetr/inv_icdes,
          lv_match          TYPE  string,
          lv_string         TYPE string,
          lv_extension      TYPE string,
          lv_uri            TYPE string,
          lv_digest         TYPE string,
          lv_offset         TYPE i,
          ls_tevkifat       TYPE /itetr/com_withholding_tax_tot,
          ls_doc_ref        TYPE /itetr/com_despatch_document_r,
          ls_ublextension   TYPE /itetr/com_ublextension,
          lv_invui          TYPE /itetr/com_e_duich,
          lv_difference     TYPE i,
          ls_departmant     TYPE /itetr/com_cmpdp.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_list>           TYPE /itetr/inv_icinv,
                   <fs_document>       TYPE  ty_documents.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.

    CONCATENATE
   '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
   '<tem:GetDocumentList>'
   '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
   '<tem:paramList>'
   '<arr:string>BEGINDATE=' iv_date_from(4) '-' iv_date_from+4(2) '-' iv_date_from+6(2) '</arr:string>'
   '<arr:string>ENDDATE=' iv_date_to(4) '-' iv_date_to+4(2) '-' iv_date_to+6(2) '</arr:string>'
   '<arr:string>DOCUMENTTYPE=EINVOICEDETAIL</arr:string>'
   '<arr:string>OPTYPE=2</arr:string>'
   '<arr:string>DATEBY=0</arr:string>'
   '</tem:paramList>'
   '</tem:GetDocumentList>'
   '</soapenv:Body>'
   '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/GetDocumentList'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line .
      CASE ls_xml_line-cname.
        WHEN 'string'.
*          APPEND INITIAL LINE TO lt_documents ASSIGNING FIELD-SYMBOL(<fs_document>).
*          FIND REGEX 'ENVELOPEID=(.*)' IN ls_xml_line-cvalue SUBMATCHES lv_match.
*          IF sy-subrc = 0.
*            <fs_document>-envelopeid = lv_match.
*          ENDIF.
          lv_string = |{ lv_string }{ ls_xml_line-cvalue }|.
        WHEN 'documentUuid'.
          APPEND INITIAL LINE TO lt_documents ASSIGNING <fs_document>.
          <fs_document>-documentuuid = ls_xml_line-cvalue .
          <fs_document>-string       = lv_string .
          CLEAR lv_string.
      ENDCASE.
    ENDLOOP.

    CLEAR : lt_request_header[].

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/GetDocumentData'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.


    SELECT SINGLE * FROM /itetr/com_cmpdp INTO ls_departmant WHERE defal = 'X'.
    LOOP AT lt_documents INTO ls_documents.

      CLEAR : lv_request_xml,lt_xml_table,lv_content.
      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
      '<tem:GetDocumentData>'
      '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
      '<tem:uuid>' ls_documents-documentuuid '</tem:uuid>'
      '<tem:paramList>'
      '<arr:string>DOCUMENTTYPE=EINVOICE</arr:string>'
      '<arr:string>DATAFORMAT=UBL</arr:string>'
      '</tem:paramList>'
      '</tem:GetDocumentData>'
      '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_authenticate = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      LOOP AT lt_xml_table INTO ls_xml_line .
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
            ev_output_data_xstr = lv_data ).

        cl_proxy_xml_transform=>xml_xstring_to_abap(
                EXPORTING
                  ddic_type               = '/ITETR/COM_MESSAGE1'
                  xml                     = lv_data
                  ext_xml                 = abap_true
                IMPORTING
                  abap_data               = ls_invoice ).

        APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.

        /ui2/cl_json=>deserialize( EXPORTING json        = ls_documents-string
                                             pretty_name = 'X'
                                   CHANGING  data        = ls_detail ).
        IF ls_detail IS NOT INITIAL.
          <ls_list>-envui  = ls_detail-envelopeid.
          CONDENSE <ls_list>-envui NO-GAPS.
*          <ls_list>-recdt  = |{ ls_detail-issuedate+0(4) }{ ls_detail-issuedate+5(2) }{ ls_detail-issuedate+8(2) }|.
          <ls_list>-recdt  = sy-datum.
          <ls_list>-aliass = ls_detail-gbalias.
          <ls_list>-taxid  = ls_detail-suppliervkntckn.
        ENDIF.

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
        READ TABLE ls_invoice-part1-withholding_tax_total INTO ls_tevkifat INDEX 1."Tevkifat Tutarını Okuma
        IF sy-subrc EQ 0.
          <ls_list>-withholding = ls_tevkifat-tax_amount-base-content.
          CLEAR: ls_tevkifat.
        ENDIF.
        READ TABLE ls_invoice-part1-despatch_document_reference INTO ls_doc_ref INDEX 1." Gelen irsaliye numarası okuma
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
        IF <ls_list>-prfid = 'TEMEL'.
          <ls_list>-resst = 'X'.
        ELSE.
          <ls_list>-resst = '0'.
          lv_difference = sy-datum - <ls_list>-recdt.
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
ENHANCEMENT-POINT edit_table SPOTS /itetr/inv_log_get_incoming .
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
      ENDIF.

    ENDLOOP.

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


  METHOD incoming_invoice_download.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 03, 2024 ---------------------------------------------*
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
             '<tem:docType>EINVOICE</tem:docType>'
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


  METHOD incoming_invoice_get_status.
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
          ls_inst           TYPE /itetr/inv_inst,
          lv_code           TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:GetDocumentStatus>'
             '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
             '<tem:uuid>' is_document_numbers-duich '</tem:uuid>'
             '<tem:paramList>'
                '<arr:string>DOCUMENTTYPE=INVOICEAPPRESP</arr:string>'
             '</tem:paramList>'
          '</tem:GetDocumentStatus>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/GetDocumentStatus'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'string'.
          IF ls_xml_line-cvalue CP 'RespCode=RED'.
            rs_status-resst = '1'.
          ELSEIF ls_xml_line-cvalue CP 'RespCode=KABUL'.
            rs_status-resst = '2'.
          ENDIF.
        WHEN 'code'.
          lv_code = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.


    SELECT SINGLE *
      FROM /itetr/inv_inst
      INTO ls_inst
      WHERE intid = 'LOG'
        AND insta = lv_code.
    IF sy-subrc EQ 0.
      rs_status-radsc = ls_inst-radsc.
    ENDIF.

    SELECT SINGLE bezei
      FROM /itetr/inv_instx
      INTO rs_status-staex
      WHERE spras = sy-langu
        AND intid = 'LOG'
        AND insta = lv_code.


    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


  METHOD incoming_invoice_response.
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
                '<arr:string>DOCUMENTTYPE=CREATEAPPLICATIONRESPONSE</arr:string>'
                '<arr:string>UUID=' is_document_numbers-duich '</arr:string>'
                '<arr:string>APPLICATIONRESPONSE=' iv_response '</arr:string>'
                '<arr:string>DESCRIPTION=' iv_note '</arr:string>'
                  '<arr:string>ALIAS=' iv_receiver_alias '</arr:string>'
             '</tem:paramList>'
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
      ENDCASE.
    ENDLOOP.

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


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


  method OUTGOING_INVOICE_CANCEL.
  endmethod.


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
             '<tem:docType>EINVOICE</tem:docType>'
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


  METHOD outgoing_invoice_get_export.
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
          ls_int_status     TYPE /itetr/inv_inst,
          lv_match          TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:GetDocumentStatus>'
             '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
             '<tem:uuid>' is_document_numbers-duich '</tem:uuid>'
             '<tem:paramList>'
                '<arr:string>DOCUMENTTYPE=EINVOICE</arr:string>'
             '</tem:paramList>'
          '</tem:GetDocumentStatus>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/GetDocumentStatus'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).


    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'string'.

          FIND REGEX 'GTB_REFNO=(.*)' IN ls_xml_line-cvalue SUBMATCHES lv_match.
          IF sy-subrc = 0.
            rs_status-radrn = lv_match. CLEAR lv_match.
          ENDIF.
          FIND REGEX 'GTB_FIILI_IHRACAT_TARIHI=(.*)' IN ls_xml_line-cvalue SUBMATCHES lv_match.
          IF sy-subrc = 0.
            DATA: lv_char TYPE c LENGTH 30.
            lv_char = lv_match.
            condense lv_char.
            CONCATENATE lv_char+0(4) lv_char+5(2) lv_char+8(2) INTO rs_status-raded.
*            rs_status-raded = lv_match.CLEAR lv_match.
          ENDIF.
          FIND REGEX 'GTB_GCB_TESCILNO=(.*)' IN ls_xml_line-cvalue SUBMATCHES lv_match.
          IF sy-subrc = 0.
            rs_status-cedrn = lv_match.CLEAR lv_match.
          ENDIF.
        WHEN 'code'.
          rs_status-radsc = ls_xml_line-cvalue.
        WHEN 'envelopeId'.
          rs_status-invii = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.


    IF rs_status-radsc IS NOT INITIAL.
      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_int_status
        WHERE intid = 'LOG'
          AND radsc = rs_status-radsc.
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING ls_int_status TO rs_status.
        SELECT SINGLE bezei
          FROM /itetr/inv_instx
          INTO rs_status-staex
          WHERE spras = sy-langu
            AND intid = 'LOG'
            AND insta = ls_int_status-insta.
      ENDIF.
    ENDIF.


    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
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
          ls_int_status     TYPE /itetr/inv_inst,
          lv_match          TYPE string.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->login
      IMPORTING
        ev_sessionid = lv_sessionid.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:GetDocumentStatus>'
             '<tem:sessionID>' lv_sessionid '</tem:sessionID>'
             '<tem:uuid>' is_document_numbers-duich '</tem:uuid>'
             '<tem:paramList>'
                '<arr:string>DOCUMENTTYPE=EINVOICE</arr:string>'
             '</tem:paramList>'
          '</tem:GetDocumentStatus>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'http://tempuri.org/IPostBoxService/GetDocumentStatus'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   iv_authenticate = abap_true
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'code'.
          rs_status-radsc = ls_xml_line-cvalue.
        WHEN 'envelopeId'.
          rs_status-invii = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.

    IF rs_status-radsc IS NOT INITIAL.
      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_int_status
        WHERE intid = 'LOG'
          AND radsc = rs_status-radsc.
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING ls_int_status TO rs_status.
        SELECT SINGLE bezei
          FROM /itetr/inv_instx
          INTO rs_status-staex
          WHERE spras = sy-langu
            AND intid = 'LOG'
            AND insta = ls_int_status-insta.
      ENDIF.
    ENDIF.

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'string'.
          IF ls_xml_line-cvalue CP 'RespCode=RED'.
            rs_status-resst = '1'.
          ELSEIF ls_xml_line-cvalue CP 'RespCode=KABUL'.
            rs_status-resst = '2'.
          ENDIF.
      ENDCASE.
    ENDLOOP.

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_response.
*&---------------------------------------------------------------------*
*& Yiğitcan Özdemir ---------------------------------------------------*
*& Thursday, May 02, 2024 ---------------------------------------------*
*&---------------------------------------------------------------------*

  ENDMETHOD.


  METHOD outgoing_invoice_send.
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
                '<arr:string>DOCUMENTTYPE=EINVOICE</arr:string>'
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
            READ TABLE lt_xml_table INTO DATA(ls_table) WITH KEY cname = 'resultMsg'.
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


  METHOD outgoing_invoice_send_again.
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
                '<arr:string>DOCUMENTTYPE=EINVOICE</arr:string>'
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
            READ TABLE lt_xml_table INTO DATA(ls_table) WITH KEY cname = 'resultMsg'.
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
*          ev_integrator_uuid = ls_xml_line-cvalue.
      ENDCASE.
    ENDLOOP.

    CALL METHOD me->logout
      EXPORTING
        iv_sessionid = lv_sessionid.

  ENDMETHOD.
ENDCLASS.