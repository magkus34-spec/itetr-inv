class /ITETR/CL_EINVOICE_WS_SPR definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
  create public .

public section.

  types:
    BEGIN OF mty_incoming_document,
        id                   TYPE string,
        invoiceuuid          TYPE string,
        profileid            TYPE string,
        documentid           TYPE string,
        issuedate            TYPE string,
        issuetime            TYPE string,
        documenttype         TYPE string,
        documentcurrencycode TYPE string,
        supplierid           TYPE string,
        suppliertitle        TYPE string,
        supplieralias        TYPE string,
        customerid           TYPE string,
        customertitle        TYPE string,
        customeralias        TYPE string,
        taxtotal             TYPE string,
        payableamount        TYPE string,
        isread               TYPE string,
        erpstatus            TYPE string,
        erpstatusenumvalue   TYPE string,
        status               TYPE string,
        statusenumvalue      TYPE string,
        envelopeuuid         TYPE string,
        emailaddress         TYPE string,
        emailstatus          TYPE string,
        iserprecieved        TYPE string,
        statusdescription    TYPE string,
        lineextensionamount  TYPE string,
        taxincamount         TYPE string,
        taxexcamount         TYPE string,
        allowancetotalamount TYPE string,
        linecount            TYPE string,
        customerbranchid     TYPE string,
        customerbranchcode   TYPE string,
        createat             TYPE string,
        gibstatus            TYPE string,
        gibstatusmessage     TYPE string,
        outputdata           TYPE string,
      END OF mty_incoming_document .
  types:
    mty_incoming_documents TYPE STANDARD TABLE OF mty_incoming_document WITH DEFAULT KEY .

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
  methods GET_INCOMING_INVOICES_INT
    returning
      value(RT_INVOICES) type MTY_INCOMING_DOCUMENTS
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



CLASS /ITETR/CL_EINVOICE_WS_SPR IMPLEMENTATION.


  METHOD download_registered_taxpayers.
    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_request_header   TYPE mty_service_header_tab,
          lv_base64_content   TYPE string,
          lv_zipped_file      TYPE xstring,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          lv_taxpayers_xml    TYPE string,
          ls_taxpayer         TYPE /itetr/inv_taxp,
          ls_user_list        TYPE /itetr/inv_s_userlist,
          ls_user_list2       TYPE /itetr/inv_s_userlist,
          ls_user             TYPE /itetr/inv_s_user,
          ls_documents        TYPE /itetr/inv_s_userlist_doc,
          ls_alias            TYPE /itetr/inv_s_userlist_alias,
          lv_token            TYPE string,
          lv_message          TYPE bapi_msg,
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception,
          ls_custom_parameter TYPE /itetr/inv_eicp.


    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.

      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gib="http://wsdl.superentegrator.com/gibuserlist">'
        '<soapenv:Header>'
        '<gib:Authorization>' lv_token '</gib:Authorization>'
          '</soapenv:Header>'
            '<soapenv:Body>'
            '<gib:AuthToken>' lv_token '</gib:AuthToken>'
            '<gib:UserListRequest>'
            '<UserType>EInvoice</UserType>'
            '<AliasType>Pk</AliasType>'
            '</gib:UserListRequest>'
            '</soapenv:Body>'
            '</soapenv:Envelope>'
            INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'UserList'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Content-Type'.
      <ls_request_header>-value = 'text/xml; charset=utf-8'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'Accept-Encoding'.
      <ls_request_header>-value = 'gzip,deflate'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_use_alternative_endpoint2 = abap_true
                                     it_request_header = lt_request_header ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusEnumValue'.
      IF sy-subrc EQ 0 AND  ls_xml_line-cvalue EQ '0'."Basarılı

        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'UserListData'.
              CONCATENATE lv_base64_content ls_xml_line-cvalue INTO lv_base64_content.
          ENDCASE.
        ENDLOOP.

        IF lv_base64_content IS INITIAL.
          lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '002' ).
          RAISE EXCEPTION lx_exception.
        ENDIF.

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
      ENDIF.



  ENDMETHOD.


  method DOWNLOAD_REGISTERED_TAXP_TIME.
  endmethod.


  METHOD get_incoming_invoices.
    DATA: lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          lt_service_return   TYPE mty_incoming_documents,
          lv_zipped_file      TYPE xstring,
          lv_xml_file         TYPE string,
          lv_attachment_count TYPE i,
          ls_invoice          TYPE /itetr/com_message1,
          ls_return           TYPE bapiret2,
          lv_content          TYPE xstring,
          ls_document_numbers TYPE /itetr/com_s_document_numbers,
          ls_doc_ref          TYPE /itetr/com_despatch_document_r,
          ls_tevkifat         TYPE /itetr/com_withholding_tax_tot,
          ls_despatch         TYPE /itetr/inv_icdes,
          ls_additional       TYPE /itetr/com_additional_document,
          ls_taxes            TYPE /itetr/com_tax_total,
          lv_invui            TYPE /itetr/com_e_duich,
          lv_message          TYPE string,
          lx_root             TYPE REF TO cx_root,
          lv_extension        TYPE string,
          lv_uri              TYPE string,
          lv_digest           TYPE string,
          lv_offset           TYPE i,
          ls_ublextension     TYPE /itetr/com_ublextension,
          lv_data             TYPE xstring,
          lv_difference       TYPE i,
          ls_departmant       TYPE /itetr/com_cmpdp.

    FIELD-SYMBOLS: <ls_service_return> TYPE mty_incoming_document,
                   <ls_list>           TYPE /itetr/inv_icinv.


    "Belgeler 1 er 1 er dönüyor
    DO.
      CALL METHOD me->get_incoming_invoices_int
        RECEIVING
          rt_invoices = lt_service_return.

      IF lt_service_return IS INITIAL.

        EXIT.
      ELSE.
        SELECT SINGLE * FROM /itetr/com_cmpdp INTO ls_departmant WHERE defal = 'X'.

        LOOP AT lt_service_return ASSIGNING <ls_service_return>.
          TRY.
              APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.

              <ls_list>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
              <ls_list>-invui = <ls_service_return>-invoiceuuid.
              <ls_list>-invno = <ls_service_return>-documentid.
              <ls_list>-invii = <ls_service_return>-id.
              <ls_list>-envui = <ls_service_return>-envelopeuuid.
              <ls_list>-invqi = <ls_service_return>-invoiceuuid.
              <ls_list>-bukrs = ms_company_parameters-bukrs.
              <ls_list>-taxid = <ls_service_return>-supplierid.
              <ls_list>-title = <ls_service_return>-suppliertitle.
              <ls_list>-aliass = <ls_service_return>-supplieralias.
              <ls_list>-waers = <ls_service_return>-documentcurrencycode.
              <ls_list>-fwste = <ls_service_return>-taxtotal.

              CONCATENATE <ls_service_return>-createat(4) <ls_service_return>-createat+5(2) <ls_service_return>-createat+8(2)  INTO <ls_list>-recdt.
              <ls_list>-staex = <ls_service_return>-gibstatusmessage.
              <ls_list>-radsc = <ls_service_return>-gibstatus.


              ls_document_numbers-docui = <ls_list>-docui.
              ls_document_numbers-docii = <ls_list>-invii.
              ls_document_numbers-duich = <ls_list>-invui.
              ls_document_numbers-docno = <ls_list>-invno.
              ls_document_numbers-envui = <ls_list>-envui.

              IF <ls_service_return>-outputdata IS NOT INITIAL.
                lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = <ls_service_return>-outputdata ).
                /itetr/cl_regulative_common=>unzip_file_single(
                  EXPORTING
                    iv_zipped_file_xstr = lv_zipped_file
                  IMPORTING
                    ev_output_data_xstr = lv_data ).


                cl_proxy_xml_transform=>xml_xstring_to_abap(
                  EXPORTING
                    ddic_type                = '/ITETR/COM_MESSAGE1'
                    xml                      = lv_data
                    ext_xml                  = abap_true
                  IMPORTING
                    abap_data                = ls_invoice
                      ).
              ENDIF.

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

              <ls_list>-orderid = ls_invoice-part1-order_reference-id-base-base-content.
              <ls_list>-dmbtr = ls_invoice-part1-legal_monetary_total-line_extension_amount-base-content.
              <ls_list>-wrbtr = ls_invoice-part1-legal_monetary_total-payable_amount-base-content.
              <ls_list>-allowance = ls_invoice-part1-legal_monetary_total-allowance_total_amount-base-content.
              READ TABLE ls_invoice-part1-withholding_tax_total INTO ls_tevkifat INDEX 1.
              IF sy-subrc EQ 0.
                <ls_list>-withholding = ls_tevkifat-tax_amount-base-content.
              ENDIF.
              READ TABLE ls_invoice-part1-despatch_document_reference INTO ls_doc_ref INDEX 1.
              IF sy-subrc EQ 0.
                <ls_list>-despid = ls_doc_ref-id-base-base-content.
              ENDIF.
            CATCH cx_root INTO lx_root.
              CLEAR <ls_list>-docui.
              lv_message = lx_root->get_text( ).
              CONCATENATE <ls_service_return>-documentid ' Hata: ' lv_message INTO ev_message.
              CONTINUE.
          ENDTRY.
          TRY.
              <ls_list>-kursf = ls_invoice-part1-pricing_exchange_rate-calculation_rate-base-base-content.
            CATCH cx_root INTO lx_root.
              CLEAR <ls_list>-kursf.
          ENDTRY.

          REPLACE ALL OCCURRENCES OF '-' IN ls_invoice-part1-issue_date-base-content WITH ''.
          <ls_list>-bldat = ls_invoice-part1-issue_date-base-content(8).

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
            WHERE bukrs = <ls_list>-bukrs
              AND taxid = <ls_list>-taxid.
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
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD get_incoming_invoices_int.
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
          lv_msg            TYPE /itetr/com_e_long_note.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_list>           TYPE mty_incoming_document,
                   <lv_invoice_field>  TYPE any.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
      '<soapenv:Header>'
        '<ein:Authorization>' lv_token '</ein:Authorization>'
        '</soapenv:Header>'
        '<soapenv:Body>'
        '<ein:AuthToken></ein:AuthToken>'
      '<ein:GetUnReceivedIncomingInvoiceRequest>'
         '<OutputType>Ubl</OutputType>'
         '<SetErpRecievedStatus>Received</SetErpRecievedStatus>'
         '<SetErpStatus>New</SetErpStatus>'
         '<IncludeInvoiceBinaryData>true</IncludeInvoiceBinaryData>'
         '<CompressedBinaryData>true</CompressedBinaryData>'
      '</ein:GetUnReceivedIncomingInvoiceRequest>'
          '</soapenv:Body>'
            '</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetUnReceivedIncomingInvoice'.
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
    IF sy-subrc EQ 0 AND  ls_xml_line-cvalue EQ '1'.
        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'Invoices'.
              APPEND INITIAL LINE TO rt_invoices ASSIGNING <ls_list>.
            WHEN 'OutputData'.
              CONCATENATE <ls_list>-outputdata
                          ls_xml_line-cvalue
                          INTO <ls_list>-outputdata.
            WHEN OTHERS.
              TRANSLATE ls_xml_line-cname TO UPPER CASE.
              ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE <ls_list> TO <lv_invoice_field>.
              IF sy-subrc = 0.
                <lv_invoice_field> = ls_xml_line-cvalue.
              ENDIF.
          ENDCASE.
        ENDLOOP.

      ELSEIF ls_xml_line-cvalue EQ '2'.
        "Alınmamış fatura bulunamadı
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


  METHOD incoming_invoice_download.
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
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:AuthToken></ein:AuthToken>'
      '<ein:GetInvoiceRequest>'
         '<OutputType>' lv_output_type'</OutputType>'
         '<UUIDType>DocumentUUID</UUIDType>'
        '<UUID>' is_document_numbers-duich '</UUID>'
         '<DocumentDirection>Incoming</DocumentDirection>'
         '<IncludeInvoiceBinaryData>true</IncludeInvoiceBinaryData>'
         '<CompressedBinaryData>true</CompressedBinaryData>'
         '<SetErpRecievedStatus>Received</SetErpRecievedStatus>'
         '<SetErpStatus>New</SetErpStatus>'
         '<MappingCode></MappingCode>'
         '<PdfContentType>Normal</PdfContentType>'
     '</ein:GetInvoiceRequest>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
      INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetInvoice'.
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
    IF sy-subrc EQ 0.
      IF ls_xml_line-cvalue EQ '1'.

        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'OutputDatas'.
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
    ENDIF.

  ENDMETHOD.


  METHOD incoming_invoice_get_status.
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
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:AuthToken></ein:AuthToken>'
      '<ein:GetInvoiceStatusRequest>'
         '<UUIDType>DocumentUUID</UUIDType>'
         '<UUID>' is_document_numbers-duich  '</UUID>'
         '<DocumentDirection>Incoming</DocumentDirection>'
      '</ein:GetInvoiceStatusRequest>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetInvoiceStatus'.
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
    IF sy-subrc EQ 0 and ls_xml_line-cvalue EQ '1'.
        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'StatusEnumValue'.
              lv_status_enum_value = ls_xml_line-cvalue.
              CASE ls_xml_line-cvalue.
                WHEN '100'.
                  rs_status-resst = 'X'.
                WHEN '110'.
                  rs_status-resst = '0'.
                WHEN '115' OR '120' OR '150'.
                  rs_status-resst = '2'.
                WHEN  '125' OR '130'.
                  rs_status-resst = '1'.
              ENDCASE.
            WHEN 'GibStatus'.
              rs_status-radsc = ls_xml_line-cvalue.
            WHEN 'GibStatusMessage'.
              rs_status-staex = ls_xml_line-cvalue.
          ENDCASE.
        ENDLOOP.
      ELSE.

        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
        IF sy-subrc EQ 0.
          lv_message = ls_xml_line-cvalue ..
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


  METHOD incoming_invoice_response.
    DATA: lv_invoice_base64 TYPE string,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_file_name      TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          ls_xml_line       TYPE smum_xmltb,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception,
          lv_token          TYPE string,
          lv_response_type  TYPE string,
          lv_message        TYPE bapi_msg.

    DATA: lt_binary   TYPE solix_tab,
          lv_length   TYPE i,
          lv_zip_hash TYPE md5_fields-hash.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CASE iv_response.
      WHEN 'KABUL'.
        lv_response_type = 'Accept'.
      WHEN 'RED'.
        lv_response_type = 'Reject'.
    ENDCASE.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.

    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:AuthToken>' lv_token '</ein:AuthToken>'
      '<ein:SendInvoiceResponseRequest>'
         '<SenderGbAlias>' ms_company_parameters-gb_alias '</SenderGbAlias>'
         '<ReceiverPkAlias>' iv_receiver_alias '</ReceiverPkAlias>'
         '<InvoiceUUID>' is_document_numbers-duich '</InvoiceUUID>'
         '<ResponseType>' lv_response_type '</ResponseType>'
         '<ResponseMessage>' iv_note '</ResponseMessage>'
      '</ein:SendInvoiceResponseRequest>'
   '</soapenv:Body>'
   '</soapenv:Envelope>'
    INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'SendInvoiceResponse'.
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
    IF sy-subrc EQ 0 and ls_xml_line-cvalue NE '1'.

        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
        IF sy-subrc EQ 0.
          lv_message = ls_xml_line-cvalue.
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


  method OUTGOING_INVOICE_CANCEL.
  endmethod.


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
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:AuthToken></ein:AuthToken>'
      '<ein:GetInvoiceRequest>'
         '<OutputType>' lv_output_type'</OutputType>'
         '<UUIDType>DocumentUUID</UUIDType>'
        '<UUID>' is_document_numbers-duich '</UUID>'
         '<DocumentDirection>Outgoing</DocumentDirection>'
         '<IncludeInvoiceBinaryData>true</IncludeInvoiceBinaryData>'
         '<CompressedBinaryData>true</CompressedBinaryData>'
         '<SetErpRecievedStatus>Received</SetErpRecievedStatus>'
         '<SetErpStatus>New</SetErpStatus>'
         '<MappingCode></MappingCode>'
         '<PdfContentType>Normal</PdfContentType>'
     '</ein:GetInvoiceRequest>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
      INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetInvoice'.
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
    IF sy-subrc EQ 0 and ls_xml_line-cvalue EQ '1'.

        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'OutputDatas'.
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


  METHOD outgoing_invoice_get_export.
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
          lv_day(2),
          lv_month(2),
          lv_year(4).
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    CALL METHOD me->get_token
      RECEIVING
        rv_token = lv_token.



    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:AuthToken></ein:AuthToken>'
      '<ein:GetInvoiceRequest>'
         '<OutputType>Ubl</OutputType>'
         '<UUIDType>DocumentUUID</UUIDType>'
        '<UUID>' is_document_numbers-duich '</UUID>'
         '<DocumentDirection>Outgoing</DocumentDirection>'
         '<IncludeInvoiceBinaryData>true</IncludeInvoiceBinaryData>'
         '<CompressedBinaryData>false</CompressedBinaryData>'
         '<SetErpRecievedStatus></SetErpRecievedStatus>'
         '<SetErpStatus></SetErpStatus>'
         '<MappingCode></MappingCode>'
         '<PdfContentType></PdfContentType>'
     '</ein:GetInvoiceRequest>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
      INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetInvoice'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusEnumValue'.
    IF sy-subrc EQ 0.
      IF ls_xml_line-cvalue EQ '1' OR ls_xml_line-cvalue EQ '2'.
        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'InvoiceUUID'.
              rs_status-invui = ls_xml_line-cvalue.
            WHEN 'StatusEnumValue'.
              lv_status_enum_value = ls_xml_line-cvalue.
            WHEN 'EnvelopeUUID'.
              rs_status-envui = ls_xml_line-cvalue.
            WHEN 'GTB_REFNO'.
              rs_status-radrn = ls_xml_line-cvalue.
            WHEN 'GTB_GCB_TESCILNO'.
              rs_status-cedrn = ls_xml_line-cvalue.
            WHEN 'GTB_FIILI_IHRACAT_TARIHI'.
              SPLIT ls_xml_line-cvalue AT '-' INTO lv_year lv_month lv_day.
              IF lv_day CO ' 0123456789' AND lv_month CO ' 0123456789' AND lv_year CO ' 0123456789'.
                rs_status-raded(4)   = lv_year.
                rs_status-raded+4(2) = lv_month.
                rs_status-raded+6(2) = lv_day.
              ENDIF.
            WHEN 'GibStatus'.
              rs_status-radsc = ls_xml_line-cvalue.
            WHEN 'GibStatusMessage'.
              rs_status-staex = ls_xml_line-cvalue.
          ENDCASE.
        ENDLOOP.

        IF rs_status-radsc IS NOT INITIAL.
          SELECT SINGLE *
            FROM /itetr/inv_inst
            INTO ls_int_status
            WHERE intid = 'SPR'
              AND radsc = rs_status-radsc.
          IF sy-subrc IS INITIAL.
            MOVE-CORRESPONDING ls_int_status TO rs_status.
            SELECT SINGLE bezei
              FROM /itetr/inv_instx
              INTO rs_status-staex
              WHERE spras = sy-langu
                AND intid = 'SPR'
                AND insta = ls_int_status-insta.
          ENDIF.
        ENDIF.

        CASE lv_status_enum_value .
          WHEN '100'.
            rs_status-resst = 'X'.
          WHEN '110'.
            rs_status-resst = '0'.
          WHEN '120' OR '150'.
            rs_status-resst = '2'.
          WHEN '130'.
            rs_status-resst = '1'.
        ENDCASE.

      ELSE.
        CONCATENATE  ls_xml_line-cvalue '-' INTO lv_message SEPARATED BY space.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Status'.
        IF sy-subrc EQ 0.
          CONCATENATE lv_message 'Status:' ls_xml_line-cvalue INTO lv_message SEPARATED BY space.
        ENDIF.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
        IF sy-subrc EQ 0.
          CONCATENATE lv_message '(' ls_xml_line-cvalue ')' INTO lv_message SEPARATED BY space.
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


  METHOD outgoing_invoice_get_status.

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
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:AuthToken></ein:AuthToken>'
      '<ein:GetInvoiceStatusRequest>'
         '<UUIDType>DocumentUUID</UUIDType>'
         '<UUID>' is_document_numbers-duich  '</UUID>'
         '<DocumentDirection>Outgoing</DocumentDirection>'
      '</ein:GetInvoiceStatusRequest>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'GetInvoiceStatus'.
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
    IF sy-subrc EQ 0 and ls_xml_line-cvalue EQ '1'.
        LOOP AT lt_xml_table INTO ls_xml_line.
          CASE ls_xml_line-cname.
            WHEN 'InvoiceUUID'.
              rs_status-invui = ls_xml_line-cvalue.
            WHEN 'InvoiceID'.
              rs_status-invno = ls_xml_line-cvalue.
            WHEN 'EnvelopeUUID'.
              rs_status-envui = ls_xml_line-cvalue.
            WHEN 'StatusEnumValue'.
              lv_status_enum_value = ls_xml_line-cvalue.
            WHEN 'GibStatus'.
              rs_status-radsc = ls_xml_line-cvalue.
            WHEN 'GibStatusMessage'.
              rs_status-staex = ls_xml_line-cvalue.
          ENDCASE.
        ENDLOOP.

        IF rs_status-radsc IS NOT INITIAL.
          SELECT SINGLE *
            FROM /itetr/inv_inst
            INTO ls_int_status
            WHERE intid = 'SPR'
              AND radsc = rs_status-radsc.
          IF sy-subrc IS INITIAL.
            MOVE-CORRESPONDING ls_int_status TO rs_status.
            SELECT SINGLE bezei
              FROM /itetr/inv_instx
              INTO rs_status-staex
              WHERE spras = sy-langu
                AND intid = 'SPR'
                AND insta = ls_int_status-insta.
          ENDIF.
        ENDIF.

        CASE lv_status_enum_value .
          WHEN '100'.
            rs_status-resst = 'X'.
          WHEN '110'.
            rs_status-resst = '0'.
          WHEN '120' OR '150'.
            rs_status-resst = '2'.
          WHEN '130'.
            rs_status-resst = '1'.
          WHEN '160'.
            rs_status-resst = 'K'.
            READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Status'.
            IF sy-subrc EQ 0.
              rs_status-staex = ls_xml_line-cvalue.
            ENDIF.
            READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
            IF sy-subrc EQ 0.
              CONCATENATE rs_status-staex ls_xml_line-cvalue INTO rs_status-staex SEPARATED BY space.
            ENDIF.
        ENDCASE.

      ELSE.
        CONCATENATE  ls_xml_line-cvalue '-' INTO lv_message SEPARATED BY space.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Status'.
        IF sy-subrc EQ 0.
          CONCATENATE lv_message 'Status:' ls_xml_line-cvalue INTO lv_message SEPARATED BY space.
        ENDIF.
        READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'StatusDescription'.
        IF sy-subrc EQ 0.
          CONCATENATE lv_message '(' ls_xml_line-cvalue ')' INTO lv_message SEPARATED BY space.
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


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  method OUTGOING_INVOICE_RESPONSE.
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
          lv_msg            TYPE /itetr/com_e_long_note.

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    "Dogrudan GIB gonderimi icin portal sirket ayarından parametre aktif edilmelidir

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

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
      '<soapenv:Header>'
        '<ein:Authorization>' lv_token '</ein:Authorization>'
        '</soapenv:Header>'
        '<soapenv:Body>'
        '<ein:AuthToken>' lv_token '</ein:AuthToken>'
        '<ein:SendInvoiceRequest>'
         '<SenderGbAlias>' ms_company_parameters-gb_alias  '</SenderGbAlias>'
         '<ReceiverPkAlias>' iv_receiver_alias '</ReceiverPkAlias>'
         '<InvoiceData>' lv_invoice_base64 '</InvoiceData>'
          '</ein:SendInvoiceRequest>'
          '</soapenv:Body>'
            '</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'SendInvoice'.
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
            WHEN 'EnvelopeUUID'.
              ev_integrator_uuid = ls_xml_line-cvalue.
              ev_envelope_uuid = ls_xml_line-cvalue.
          ENDCASE.
        ENDLOOP.

***        IF  lv_enum_value EQ '1' AND ev_invoice_uuid IS NOT INITIAL. "taslak olarak kaydedilen belge gönderimi
***          CALL METHOD me->outgoing_invoice_send_draft
***            EXPORTING
***              iv_invoice_uuid = ev_invoice_uuid
***            IMPORTING
***              ev_isapproved   = lv_isapproved
***              ev_message      = lv_msg.
***        ENDIF.

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


  METHOD outgoing_invoice_send_again.
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
            lv_msg            TYPE /itetr/com_e_long_note.

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

      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
        '<soapenv:Header>'
          '<ein:Authorization>' lv_token '</ein:Authorization>'
          '</soapenv:Header>'
          '<soapenv:Body>'
          '<ein:AuthToken>' lv_token '</ein:AuthToken>'
          '<ein:SendInvoiceRequest>'
           '<SenderGbAlias>' ms_company_parameters-gb_alias  '</SenderGbAlias>'
           '<ReceiverPkAlias>' iv_receiver_alias '</ReceiverPkAlias>'
           '<InvoiceData>' lv_invoice_base64 '</InvoiceData>'
            '</ein:SendInvoiceRequest>'
            '</soapenv:Body>'
              '</soapenv:Envelope>'
         INTO lv_request_xml.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name  = 'SOAPAction'.
      <ls_request_header>-value = 'SendInvoice'.
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
              WHEN 'EnvelopeUUID'.
                ev_envelope_uuid = ls_xml_line-cvalue.
            ENDCASE.
          ENDLOOP.
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
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ein="http://wsdl.superentegrator.com/einvoice">'
   '<soapenv:Header>'
      '<ein:Authorization>' lv_token '</ein:Authorization>'
   '</soapenv:Header>'
   '<soapenv:Body>'
      '<ein:ApproveDraftInvoiceReqType>'
         '<InvoiceUUIDList>' iv_invoice_uuid '</InvoiceUUIDList>'
      '</ein:ApproveDraftInvoiceReqType>'
      '<ein:AuthToken></ein:AuthToken>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
              INTO lv_request_xml.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name  = 'SOAPAction'.
    <ls_request_header>-value = 'ApproveDraftInvoice'.
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