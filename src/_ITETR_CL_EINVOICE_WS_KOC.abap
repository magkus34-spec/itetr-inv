class /ITETR/CL_EINVOICE_WS_KOC definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
  create public .

public section.

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
  PRIVATE SECTION.
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS_KOC IMPLEMENTATION.


  METHOD download_registered_taxpayers.
    DATA: BEGIN OF ls_list,
            Identifier   TYPE string,
            Alias        TYPE string,
            Type         TYPE string,
            Title        TYPE string,
            RegisterTime TYPE string,
          END OF ls_list,
          lt_list           LIKE TABLE OF ls_list,
          lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_item_number    TYPE buzei,
          lv_taxnumber      TYPE stcd2.
    FIELD-SYMBOLS <ls_taxpayer> TYPE /itetr/inv_taxp.

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
         '<soapenv:Header>'
            '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
            '</efat:UserCredentials>'
         '</soapenv:Header>'
         '<soapenv:Body>'
            '<efat:getUserListZip/>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'getUserListZipResult'.
          CONCATENATE lv_base64_content ls_xml_line-cvalue INTO lv_base64_content.
      ENDCASE.
    ENDLOOP.
    lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).
    /itetr/cl_regulative_common=>unzip_file_single(
      EXPORTING
        iv_zipped_file_xstr = lv_zipped_file
        iv_get_rawstring    = 'X'
      IMPORTING
        ev_output_data_str = lv_taxpayers_xml ).

    /ui2/cl_json=>deserialize( EXPORTING json        = lv_taxpayers_xml
                                         pretty_name = 'X'
                              CHANGING data = lt_list ).

    LOOP AT lt_list INTO ls_list.
      APPEND INITIAL LINE TO rt_list ASSIGNING <ls_taxpayer>.
      <ls_taxpayer>-taxid  = ls_list-identifier.
      <ls_taxpayer>-aliass = ls_list-alias.
      <ls_taxpayer>-title  = ls_list-title.
      <ls_taxpayer>-txpty  = ls_list-type.
      CONCATENATE ls_list-registertime(4)
                  ls_list-registertime+5(2)
                  ls_list-registertime+8(2)
                  INTO <ls_taxpayer>-regdt.
      CONCATENATE ls_list-registertime+11(2)
                  ls_list-registertime+14(2)
                  ls_list-registertime+17(2)
                  INTO <ls_taxpayer>-regtm.
    ENDLOOP.
  ENDMETHOD.


  METHOD DOWNLOAD_REGISTERED_TAXP_TIME.

  ENDMETHOD.


  METHOD get_incoming_invoices.
    DATA: lv_request_xml     TYPE string,
          lv_response_xml    TYPE string,
          lv_tmp             TYPE string,
          lv_new_date        TYPE string,
          lv_dumy            TYPE string,
          lv_date            TYPE string,
          lt_xml_table       TYPE TABLE OF smum_xmltb,
          ls_xml_line        TYPE smum_xmltb,
          lv_invoice_uuid    TYPE /itetr/com_e_docqi,
          lv_ubl_xml         TYPE xstring,
          ls_invoice         TYPE /itetr/com_message1,
          lv_content         TYPE string,
          lv_env_content     TYPE string,
          lv_decoded_content TYPE xstring,
          lv_difference      TYPE i,
          lx_root            TYPE REF TO cx_root,
          lo_etr_exception   TYPE REF TO /itetr/cx_regulative_exception,
          lt_result_start    TYPE match_result_tab,
          lt_result_end      TYPE match_result_tab,
          ls_result_start    TYPE match_result,
          ls_result_end      TYPE match_result,
          lv_invoice         TYPE string,
          lv_offset          TYPE i,
          ls_despatch        TYPE /itetr/inv_icdes,
          ls_doc_ref         TYPE /itetr/com_despatch_document_r,
          ls_tevkifat        TYPE /itetr/com_withholding_tax_tot,
          lv_invui           TYPE /itetr/com_e_duich,
          lv_extension       TYPE string,
          lv_uri             TYPE string,
          lv_digest          TYPE string,
          ls_ublextension    TYPE /itetr/com_ublextension,
          ls_departmant      TYPE /itetr/com_cmpdp.

    FIELD-SYMBOLS: <ls_list> TYPE /itetr/inv_icinv.

    DO.
      TRY.
          CONCATENATE
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
               '<soapenv:Header>'
                  '<efat:UserCredentials>'
                     '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
                     '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
                  '</efat:UserCredentials>'
               '</soapenv:Header>'
             '<soapenv:Body>'
              '<efat:getDocument/>'
             '</soapenv:Body>'
            '</soapenv:Envelope>'
            INTO lv_request_xml.
          lv_response_xml = run_service( lv_request_xml ).
          lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
          CLEAR lv_content.
          LOOP AT lt_xml_table INTO ls_xml_line.
            CASE ls_xml_line-cname.
              WHEN 'binaryData'.
                CONCATENATE lv_content
                            ls_xml_line-cvalue
                  INTO lv_content.
            ENDCASE.
          ENDLOOP.
          IF lv_content IS INITIAL.
            RETURN.
          ENDIF.
          lv_decoded_content = /itetr/cl_regulative_common=>decode_base64( lv_content ).
          lv_content = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_decoded_content ).
          lv_decoded_content = /itetr/cl_regulative_common=>decode_base64( lv_content ).
          /itetr/cl_regulative_common=>unzip_file_single(
            EXPORTING
              iv_zipped_file_xstr = lv_decoded_content
               iv_get_rawstring    = 'X'
            IMPORTING
              ev_output_data_str = lv_content ).
          lv_env_content = lv_content.
          REPLACE FIRST OCCURRENCE OF REGEX '<Invoice.*</Invoice>' IN lv_env_content WITH ``.
          REPLACE FIRST OCCURRENCE OF REGEX '<sh:Receiver.*</sh:Receiver>' IN lv_env_content WITH ``.
          lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_env_content ).

          FIND ALL OCCURRENCES OF '<Invoice' IN lv_content RESULTS lt_result_start.
          IF sy-subrc EQ 0 .
            FIND ALL OCCURRENCES OF '</Invoice>' IN lv_content RESULTS lt_result_end.
          ELSE.
            FIND ALL OCCURRENCES OF '<q1:Invoice' IN lv_content RESULTS lt_result_start.
            FIND ALL OCCURRENCES OF '</q1:Invoice>' IN lv_content RESULTS lt_result_end.
            IF sy-subrc EQ 4.
              FIND ALL OCCURRENCES OF '<ns11:Invoice' IN lv_content RESULTS lt_result_start. "AS 08.06.2022
              FIND ALL OCCURRENCES OF '</ns11:Invoice>' IN lv_content RESULTS lt_result_end.  "AS 08.06.2022
              IF sy-subrc EQ 4.
                FIND ALL OCCURRENCES OF '<ns4:Invoice' IN lv_content RESULTS lt_result_start. "AS 12.10.2022
                FIND ALL OCCURRENCES OF '</ns4:Invoice>' IN lv_content RESULTS lt_result_end.  "AS 12.10.2022
              ENDIF.
            ENDIF.
          ENDIF.

          SELECT SINGLE * FROM /itetr/com_cmpdp INTO ls_departmant WHERE defal = 'X'.

          LOOP AT lt_result_start INTO ls_result_start.
            CLEAR: lv_invoice, lv_ubl_xml, ls_invoice.
            READ TABLE lt_result_end INTO ls_result_end INDEX sy-tabix.
            CHECK sy-subrc = 0.
            lv_offset = ls_result_end-offset + ls_result_end-length - ls_result_start-offset.
            CONCATENATE '<?xml version="1.0" encoding="utf-8"?>' ` ` lv_content+ls_result_start-offset(lv_offset) INTO lv_invoice.
            "add begin gilgar 08.01.2022 koc sistemden gelen format sorunu için eklendi
*            CLEAR:lv_date,lv_dumy,lv_tmp,lv_new_date.
*            FIND REGEX '(<cbc:IssueTime.*</cbc:IssueTime>)' IN lv_invoice SUBMATCHES lv_date.
*            SPLIT lv_date AT '<cbc:IssueTime>'  INTO lv_dumy lv_tmp.
*            SPLIT lv_tmp  AT '</cbc:IssueTime>' INTO lv_new_date lv_dumy.
*            lv_new_date = '<cbc:IssueTime>' && lv_new_date+0(8) && '</cbc:IssueTime>'.
*            REPLACE ALL OCCURRENCES OF lv_date IN lv_invoice WITH lv_new_date.
            "add end gilgar 08.01.2022 koc sistemden gelen format sorunu için eklendi

            lv_ubl_xml = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_invoice ).
            cl_proxy_xml_transform=>xml_xstring_to_abap(
              EXPORTING
                ddic_type               = '/ITETR/COM_MESSAGE1'
                xml                     = lv_ubl_xml
                ext_xml                 = abap_true
              IMPORTING
                abap_data               = ls_invoice ).
            APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.
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
            <ls_list>-withholding = ls_tevkifat-tax_amount-base-content.
            READ TABLE ls_invoice-part1-despatch_document_reference INTO ls_doc_ref INDEX 1."AS Gelen irsaliye numarası okuma
            IF sy-subrc EQ 0. "AS Gelen irsaliye numarası okuma
              <ls_list>-despid = ls_doc_ref-id-base-base-content."AS Gelen irsaliye numarası okuma
            ENDIF."AS Gelen irsaliye numarası okuma
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
                  IF <ls_list>-taxid IS INITIAL AND ls_xml_line-cvalue CA '0123456789'  "AS
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
        CATCH cx_root INTO lx_root.
          EXIT.
      ENDTRY.
    ENDDO.
  ENDMETHOD.


  METHOD incoming_invoice_download.
    DATA: lv_request_xml     TYPE string,
          lv_response_xml    TYPE string,
          lt_xml_table       TYPE TABLE OF smum_xmltb,
          ls_xml_line        TYPE smum_xmltb,
          lv_content         TYPE string,
          lv_decoded_content TYPE xstring,
          lt_request_header  TYPE mty_service_header_tab,
          lv_xslt_template   TYPE /itetr/inv_oginv-xsltt.
    FIELD-SYMBOLS: <ls_request_header> TYPE /itetr/cl_einvoice_ws=>mty_service_header.

    IF iv_content_type <> /itetr/cl_regulative_archive=>mc_content_types-pdf.
      CONCATENATE
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
           '<soapenv:Header>'
              '<efat:UserCredentials>'
                 '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
                 '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
              '</efat:UserCredentials>'
           '</soapenv:Header>'
         '<soapenv:Body>'
          '<efat:getDocumentByUUID>'
             '<efat:invoiceUUID>' is_document_numbers-duich '</efat:invoiceUUID>'
          '</efat:getDocumentByUUID>'
         '</soapenv:Body>'
        '</soapenv:Envelope>'
        INTO lv_request_xml.
      lv_response_xml = run_service( lv_request_xml ).
      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'binaryData'.
            CONCATENATE lv_content
                        ls_xml_line-cvalue
              INTO lv_content.
        ENDCASE.
      ENDLOOP.
      CHECK lv_content IS NOT INITIAL.
      lv_decoded_content = /itetr/cl_regulative_common=>decode_base64( lv_content ).
      CHECK lv_decoded_content IS NOT INITIAL.
      CLEAR lv_content.
      lv_content = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_decoded_content ).
      lv_decoded_content = /itetr/cl_regulative_common=>decode_base64( lv_content ).
      /itetr/cl_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_decoded_content
          iv_get_rawstring    = 'X'
        IMPORTING
          ev_output_data_str  = lv_content ).
      FIND REGEX '(<Invoice.*</Invoice>)' IN lv_content SUBMATCHES lv_content.
      CONCATENATE '<?xml version="1.0" encoding="utf-8"?>' ` ` lv_content INTO lv_content.
      rv_invoice_data = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_content ).
      IF iv_content_type = /itetr/cl_regulative_archive=>mc_content_types-html.
        rv_invoice_data = /itetr/cl_regulative_common=>xslt_trnasformation_html(
           EXPORTING
             iv_input_xml         = rv_invoice_data
             iv_xslt_name         = '/ITETR/INV_INVOICE_GENERAL'
             iv_preview_watermark = abap_false ).
      ENDIF.
    ELSE.
      CONCATENATE
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
           '<soapenv:Header/>'
           '<soapenv:Body>'
              '<tem:GetInboundPdfInvoiceByUUID>'
                 '<tem:UUID>' is_document_numbers-duich '</tem:UUID>'
              '</tem:GetInboundPdfInvoiceByUUID>'
           '</soapenv:Body>'
        '</soapenv:Envelope>'
        INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Authorization'.
      CONCATENATE ms_company_parameters-wsusr ':' ms_company_parameters-wspwd INTO lv_content.
      lv_content = /itetr/cl_regulative_common=>encode_base64( EXPORTING iv_input_string = lv_content ).
      CONCATENATE 'Basic' ` ` lv_content INTO <ls_request_header>-value.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Accept-Encoding'.
      <ls_request_header>-value = 'gzip,deflate'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Content-Type'.
      <ls_request_header>-value = 'text/xml;charset=UTF-8'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'SOAPAction'.
      <ls_request_header>-value = 'http://tempuri.org/IPdfService/GetInboundPdfInvoiceByUUID'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Connection'.
      <ls_request_header>-value = 'Keep-Alive'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_use_alternative_endpoint = abap_true
                                     it_request_header = lt_request_header ).
      FIND REGEX '<GetInboundPdfInvoiceByUUIDResult>(.*)</GetInboundPdfInvoiceByUUIDResult>' IN lv_response_xml SUBMATCHES lv_content.
      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_content ).
    ENDIF.
  ENDMETHOD.


  METHOD incoming_invoice_get_status.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          ls_int_status   TYPE /itetr/inv_inst.

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
         '<soapenv:Header>'
            '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
            '</efat:UserCredentials>'
         '</soapenv:Header>'
       '<soapenv:Body>'
        '<efat:getDocumentStatus>'
           '<efat:getAppRespRequest>'
              '<instanceIdentifier>' is_document_numbers-duich '</instanceIdentifier>'
           '</efat:getAppRespRequest>'
        '</efat:getDocumentStatus>'
       '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'applicationResponse'.
    IF sy-subrc = 0.
      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_int_status
        WHERE intid = 'KOC'
          AND insta = ls_xml_line-cvalue.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_int_status TO rs_status.
        SELECT SINGLE bezei
          FROM /itetr/inv_instx
          INTO rs_status-staex
          WHERE spras = sy-langu
            AND intid = 'KOC'
            AND insta = ls_xml_line-cvalue.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD incoming_invoice_response.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lx_exception    TYPE REF TO /itetr/cx_regulative_exception.

    CONCATENATE
        '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
           '<soap:Header>'
              '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
              '</efat:UserCredentials>'
           '</soap:Header>'
           '<soap:Body>'
              '<efat:setAcceptanceStatusAndDescriptionByUUID>'
                 '<efat:uuid>' is_document_numbers-duich '</efat:uuid>'
                 '<efat:acceptanceStatus>' iv_response '</efat:acceptanceStatus>'
                 '<efat:description>' iv_note '</efat:description>'
              '</efat:setAcceptanceStatusAndDescriptionByUUID>'
           '</soap:Body>'
        '</soap:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'ErrorMessage'.
    IF sy-subrc = 0.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = ls_xml_line-cvalue(50)
                                                                        iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                        iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                        iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

*    DATA: lv_response_ubl       TYPE xstring,
*          lv_response_hash      TYPE md5_fields-hash,
*          ls_response_structure TYPE /itetr/com_message11.
*    build_application_response(
*      EXPORTING
*        is_document_numbers = is_document_numbers
*        iv_response         = iv_response
*        iv_note             = iv_note
*      IMPORTING
*        ev_response_xml     = lv_response_ubl
*        ev_response_hash    = lv_response_hash
*        es_response_structure = ls_response_structure ).
*
*    DATA: lv_request_xml    TYPE string,
*          lv_response_xml   TYPE string,
*          lt_xml_table      TYPE TABLE OF smum_xmltb,
*          ls_xml_line       TYPE smum_xmltb,
**          lv_invoice_uuid   TYPE /itetr/com_e_docqi,
*          lv_ubl_xml        TYPE string,
*          lv_envelope_xml   TYPE string,
*          lv_envelope_raw   TYPE xstring,
*          lv_file_name      TYPE string,
*          lv_envelope_uuid  TYPE /itetr/com_e_envui,
*          ls_invoice        TYPE /itetr/com_message1,
*          lt_request_header TYPE mty_service_header_tab,
*          lx_root           TYPE REF TO cx_root,
*          lo_etr_exception  TYPE REF TO /itetr/cx_regulative_exception,
*          lv_hash           TYPE hash160,
*          lo_zip            TYPE REF TO cl_abap_zip,
*          lv_submatch       TYPE string,
*          lv_alias          TYPE /itetr/com_e_alias.
*    FIELD-SYMBOLS: <ls_list>           TYPE /itetr/inv_icinv,
*                   <ls_request_header> TYPE /itetr/cl_einvoice_ws=>mty_service_header.
*
*    lv_ubl_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_response_ubl ).
*    REPLACE FIRST OCCURRENCE OF '<?xml version="1.0"?>' IN lv_ubl_xml WITH ``.
*    REPLACE FIRST OCCURRENCE OF '<?xml version="1.0" encoding="utf-8"?>' IN lv_ubl_xml WITH ``.
*    FIND REGEX '(<n\w:UBLVersionID>)' IN lv_ubl_xml SUBMATCHES lv_submatch.
*    CONCATENATE '<n3:UBLExtensions><n3:UBLExtension><n3:ExtensionContent></n3:ExtensionContent></n3:UBLExtension></n3:UBLExtensions>' lv_submatch INTO lv_submatch.
*    REPLACE REGEX '<n\w:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n0:ApplicationResponse' IN lv_ubl_xml WITH 'ApplicationResponse'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n1' IN lv_ubl_xml WITH 'cac'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n2' IN lv_ubl_xml WITH 'cbc'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n3' IN lv_ubl_xml WITH 'ext'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n3="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:prx="urn:sap.com:proxy.*:752"' IN lv_ubl_xml WITH ``.
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:prx="urn:sap.com:proxy.*:750"' IN lv_ubl_xml WITH ``.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n2="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n1="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n0="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"'
*    IN lv_ubl_xml WITH 'xmlns="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"'.
*
*    lv_envelope_uuid = /itetr/cl_regulative_common=>generate_document_uuid_c36( ).
*    lv_alias = iv_receiver_alias.
*    REPLACE FIRST OCCURRENCE OF 'gb@' IN lv_alias WITH 'pk@'.
*    CONCATENATE
*        '<sh:StandardBusinessDocument xsi:schemaLocation="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader PackageProxy_1_2.xsd"'
*                                     ` ` 'xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"'
*                                     ` ` 'xmlns:ef="http://www.efatura.gov.tr/package-namespace"'
*                                     ` ` 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
*            '<sh:StandardBusinessDocumentHeader>'
*                '<sh:HeaderVersion>1.2</sh:HeaderVersion>'
*                '<sh:Sender>'
*                    '<sh:Identifier>' ms_company_parameters-aliass '</sh:Identifier>'
*                    '<sh:ContactInformation>'
*                        '<sh:Contact>' mv_company_taxid '</sh:Contact>'
*                        '<sh:ContactTypeIdentifier>VKN_TCKN</sh:ContactTypeIdentifier>'
*                    '</sh:ContactInformation>'
*                    '<sh:ContactInformation>'
*                        '<sh:Contact>' ls_response_structure-part1-sender_party-party_name-name-base-base-content '</sh:Contact>'
*                        '<sh:ContactTypeIdentifier>UNVAN</sh:ContactTypeIdentifier>'
*                    '</sh:ContactInformation>'
*                '</sh:Sender>'
*                '<sh:Receiver>'
*                    '<sh:Identifier>' lv_alias '</sh:Identifier>'
*                    '<sh:ContactInformation>'
*                        '<sh:Contact>' iv_receiver_taxid '</sh:Contact>'
*                        '<sh:ContactTypeIdentifier>VKN_TCKN</sh:ContactTypeIdentifier>'
*                    '</sh:ContactInformation>'
*                    '<sh:ContactInformation>'
*                        '<sh:Contact>' ls_response_structure-part1-receiver_party-party_name-name-base-base-content '</sh:Contact>'
*                        '<sh:ContactTypeIdentifier>UNVAN</sh:ContactTypeIdentifier>'
*                    '</sh:ContactInformation>'
*                '</sh:Receiver>'
*                '<sh:DocumentIdentification>'
*                    '<sh:Standard>UBLTR</sh:Standard>'
*                    '<sh:TypeVersion>1.2</sh:TypeVersion>'
*                    '<sh:InstanceIdentifier>' lv_envelope_uuid '</sh:InstanceIdentifier>'
*                    '<sh:Type>POSTBOXENVELOPE</sh:Type>'
*                    '<sh:CreationDateAndTime>' sy-datum+0(4) '-'
*                                               sy-datum+4(2) '-'
*                                               sy-datum+6(2) 'T'
*                                               sy-uzeit+0(2) ':'
*                                               sy-uzeit+2(2) ':'
*                                               sy-uzeit+4(2)
*                                               '</sh:CreationDateAndTime>'
*                '</sh:DocumentIdentification>'
*            '</sh:StandardBusinessDocumentHeader>'
*            '<ef:Package>'
*                '<Elements>'
*                    '<ElementType>APPLICATIONRESPONSE</ElementType>'
*                    '<ElementCount>1</ElementCount>'
*                    '<ElementList>'
*                    lv_ubl_xml
*                    '</ElementList>'
*                '</Elements>'
*            '</ef:Package>'
*        '</sh:StandardBusinessDocument>'
*      INTO lv_envelope_xml.
*
*    lo_zip = NEW cl_abap_zip( ).
*    CONCATENATE lv_envelope_uuid '.xml' INTO lv_file_name.
*    lv_envelope_raw = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_envelope_xml ).
*    lo_zip->add( name    = lv_file_name
*                 content = lv_envelope_raw ).
*    lv_envelope_raw = lo_zip->save( ).
*    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
*      EXPORTING
*        input  = lv_envelope_raw
*      IMPORTING
*        output = lv_envelope_xml.
*
*    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
*      EXPORTING
*        alg            = 'MD5'
*        data           = lv_envelope_raw
*      IMPORTING
*        hash           = lv_hash
*      EXCEPTIONS
*        unknown_alg    = 1
*        param_error    = 2
*        internal_error = 3
*        OTHERS         = 4.
*
**    lv_invoice_uuid = iv_document_uuid.
*    CONCATENATE
*      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
*         '<soapenv:Header>'
*            '<efat:UserCredentials>'
*               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
*               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
*            '</efat:UserCredentials>'
*         '</soapenv:Header>'
*       '<soapenv:Body>'
*      '<efat:sendDocument>'
*         '<efat:documentRequest>'
*            '<fileName>' lv_envelope_uuid '.zip</fileName>'
*            '<binaryData contentType="application/zip">' lv_envelope_xml '</binaryData>'
**            '<binaryData d5p1:contentType="application/zip" xmlns:d5p1="http://www.w3.org/2005/05/xmlmime">' lv_envelope_xml '</binaryData>'
*            '<hash>' lv_hash '</hash>'
*         '</efat:documentRequest>'
*      '</efat:sendDocument>'
*       '</soapenv:Body>'
*      '</soapenv:Envelope>'
*      INTO lv_request_xml.
**    mv_request_url = '/Connector.asmx'.
*
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name = 'Accept-Encoding'.
*    <ls_request_header>-value = 'gzip,deflate'.
*    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
*    <ls_request_header>-name = 'Content-Type'.
*    <ls_request_header>-value = 'text/xml;charset=UTF-8'.
*
*    lv_response_xml = run_service( lv_request_xml ).
  ENDMETHOD.


  METHOD outgoing_invoice_cancel.

  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml     TYPE string,
          lv_response_xml    TYPE string,
          lt_xml_table       TYPE TABLE OF smum_xmltb,
          ls_xml_line        TYPE smum_xmltb,
          lv_content         TYPE string,
          lv_decoded_content TYPE xstring,
          lt_request_header  TYPE mty_service_header_tab,
          lv_xslt_template   TYPE /itetr/inv_oginv-xsltt.
    FIELD-SYMBOLS: <ls_request_header> TYPE /itetr/cl_einvoice_ws=>mty_service_header.

    IF iv_content_type <> /itetr/cl_regulative_archive=>mc_content_types-pdf.
      CONCATENATE
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
           '<soapenv:Header>'
              '<efat:UserCredentials>'
                 '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
                 '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
              '</efat:UserCredentials>'
           '</soapenv:Header>'
         '<soapenv:Body>'
          '<efat:getDocumentByUUID>'
             '<efat:invoiceUUID>' is_document_numbers-duich '</efat:invoiceUUID>'
          '</efat:getDocumentByUUID>'
         '</soapenv:Body>'
        '</soapenv:Envelope>'
        INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.
      lv_response_xml = run_service( lv_request_xml ).
      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'binaryData'.
            CONCATENATE lv_content
                        ls_xml_line-cvalue
              INTO lv_content.
        ENDCASE.
      ENDLOOP.
      CHECK lv_content IS NOT INITIAL.
      lv_decoded_content = /itetr/cl_regulative_common=>decode_base64( lv_content ).
      CHECK lv_decoded_content IS NOT INITIAL.
      CLEAR lv_content.
      lv_content = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_decoded_content ).
      lv_decoded_content = /itetr/cl_regulative_common=>decode_base64( lv_content ).
      /itetr/cl_regulative_common=>unzip_file_single(
        EXPORTING
          iv_zipped_file_xstr = lv_decoded_content
          iv_get_rawstring    = 'X'
        IMPORTING
          ev_output_data_str  = lv_content ).
      FIND REGEX '(<Invoice.*</Invoice>)' IN lv_content SUBMATCHES lv_content.
      CONCATENATE '<?xml version="1.0" encoding="utf-8"?>' ` ` lv_content INTO lv_content.
      rv_invoice_data = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_content ).
      IF iv_content_type = /itetr/cl_regulative_archive=>mc_content_types-html.
        SELECT SINGLE xsltt
          FROM /itetr/inv_oginv
          INTO lv_xslt_template
          WHERE docui = is_document_numbers-docui.
        rv_invoice_data = /itetr/cl_regulative_common=>xslt_trnasformation_html(
           EXPORTING
             iv_input_xml         = rv_invoice_data
             iv_xslt_name         = lv_xslt_template
             iv_preview_watermark = abap_false ).
      ENDIF.
    ELSE.
      CONCATENATE
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
           '<soapenv:Header/>'
           '<soapenv:Body>'
              '<tem:GetOutboundPdfInvoiceByUUID>'
                 '<tem:UUID>' is_document_numbers-duich '</tem:UUID>'
              '</tem:GetOutboundPdfInvoiceByUUID>'
           '</soapenv:Body>'
        '</soapenv:Envelope>'
        INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.

      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Authorization'.
      CONCATENATE ms_company_parameters-wsusr ':' ms_company_parameters-wspwd INTO lv_content.
      lv_content = /itetr/cl_regulative_common=>encode_base64( EXPORTING iv_input_string = lv_content ).
      CONCATENATE 'Basic' ` ` lv_content INTO <ls_request_header>-value.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Accept-Encoding'.
      <ls_request_header>-value = 'gzip,deflate'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Content-Type'.
      <ls_request_header>-value = 'text/xml;charset=UTF-8'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'SOAPAction'.
      <ls_request_header>-value = 'http://tempuri.org/IPdfService/GetOutboundPdfInvoiceByUUID'.
      APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
      <ls_request_header>-name = 'Connection'.
      <ls_request_header>-value = 'Keep-Alive'.

      lv_response_xml = run_service( iv_request = lv_request_xml
                                     iv_use_alternative_endpoint = abap_true
                                     it_request_header = lt_request_header ).
      FIND REGEX '<GetOutboundPdfInvoiceByUUIDResult>(.*)</GetOutboundPdfInvoiceByUUIDResult>' IN lv_response_xml SUBMATCHES lv_content.
      rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( lv_content ).
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_get_export.

    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          ls_int_status   TYPE /itetr/inv_inst,
          lv_day(2),
          lv_month(2),
          lv_year(4).

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
         '<soapenv:Header>'
            '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
            '</efat:UserCredentials>'
         '</soapenv:Header>'
       '<soapenv:Body>'
        '<efat:getGtbNo>'
              '<efat:invoiceUuid>' is_document_numbers-duich '</efat:invoiceUuid>'
        '</efat:getGtbNo>'
       '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'GtbRefno'.
          rs_status-radrn = ls_xml_line-cvalue.
        WHEN 'GtbGcbTescilno'.
          rs_status-cedrn = ls_xml_line-cvalue.
        WHEN 'GtbExportDate'.
          SPLIT ls_xml_line-cvalue AT '.' INTO lv_day lv_month lv_year.
          IF lv_day CO ' 0123456789' AND lv_month CO ' 0123456789' AND lv_year CO ' 0123456789'.
            rs_status-raded(4)   = lv_year.
            rs_status-raded+4(2) = lv_month.
            rs_status-raded+6(2) = lv_day.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          ls_int_status   TYPE /itetr/inv_inst.

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
         '<soapenv:Header>'
            '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
            '</efat:UserCredentials>'
         '</soapenv:Header>'
       '<soapenv:Body>'
        '<efat:getDocumentStatus>'
           '<efat:getAppRespRequest>'
              '<instanceIdentifier>' is_document_numbers-duich '</instanceIdentifier>'
           '</efat:getAppRespRequest>'
        '</efat:getDocumentStatus>'
       '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'applicationResponse'.
    IF sy-subrc = 0.
      SELECT SINGLE *
        FROM /itetr/inv_inst
        INTO ls_int_status
        WHERE intid = 'KOC'
          AND insta = ls_xml_line-cvalue.
      IF sy-subrc = 0.
        MOVE-CORRESPONDING ls_int_status TO rs_status.
        SELECT SINGLE bezei
          FROM /itetr/inv_instx
          INTO rs_status-staex
          WHERE spras = sy-langu
            AND intid = 'KOC'
            AND insta = ls_xml_line-cvalue.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  method OUTGOING_INVOICE_RESPONSE.
  endmethod.


  METHOD outgoing_invoice_send.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_invoice_uuid   TYPE /itetr/com_e_docqi,
          lv_ubl_xml        TYPE string,
          lv_envelope_xml   TYPE string,
          lv_envelope_raw   TYPE xstring,
          lv_file_name      TYPE string,
          lv_envelope_uuid  TYPE /itetr/com_e_envui,
          ls_invoice        TYPE /itetr/com_message1,
          lt_request_header TYPE mty_service_header_tab,
          lx_root           TYPE REF TO cx_root,
          lo_etr_exception  TYPE REF TO /itetr/cx_regulative_exception,
          lv_hash           TYPE hash160,
          lo_zip            TYPE REF TO cl_abap_zip,
          lv_submatch       TYPE string.
    FIELD-SYMBOLS: <ls_list>           TYPE /itetr/inv_icinv,
                   <ls_request_header> TYPE /itetr/cl_einvoice_ws=>mty_service_header.

    lv_ubl_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_ubl_xstring ).
    REPLACE FIRST OCCURRENCE OF '<?xml version="1.0"?>' IN lv_ubl_xml WITH ``.
*    FIND REGEX '(<n\w:UBLVersionID>)' IN lv_ubl_xml SUBMATCHES lv_submatch.
    lv_submatch = '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.
*    CONCATENATE '<n3:UBLExtensions><n3:UBLExtension><n3:ExtensionContent></n3:ExtensionContent></n3:UBLExtension></n3:UBLExtensions>' lv_submatch INTO lv_submatch.
    REPLACE REGEX '<cbc:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.
*    REPLACE REGEX '<n\w:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n0:Invoice' IN lv_ubl_xml WITH 'Invoice'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n1' IN lv_ubl_xml WITH 'cac'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n2' IN lv_ubl_xml WITH 'cbc'.
*    REPLACE ALL OCCURRENCES OF REGEX '\<n3' IN lv_ubl_xml WITH 'ext'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:prx="urn:sap.com:proxy:SE7:/1SAI/TASBAECC1700EB7C150E310:750"' IN lv_ubl_xml WITH ``.
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n3="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n2="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n1="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'
*    IN lv_ubl_xml WITH 'xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"'.
*
*    REPLACE ALL OCCURRENCES OF REGEX 'xmlns:n0="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"'
*    IN lv_ubl_xml WITH 'xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"'.

    lv_envelope_uuid = /itetr/cl_regulative_common=>generate_document_uuid_c36( ).
    CONCATENATE
        '<sh:StandardBusinessDocument xsi:schemaLocation="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader PackageProxy_1_2.xsd"'
                                     ` ` 'xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"'
                                     ` ` 'xmlns:ef="http://www.efatura.gov.tr/package-namespace"'
                                     ` ` 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
            '<sh:StandardBusinessDocumentHeader>'
                '<sh:HeaderVersion>1.2</sh:HeaderVersion>'
                '<sh:Sender>'
                    '<sh:Identifier>' ms_company_parameters-aliass '</sh:Identifier>'
                    '<sh:ContactInformation>'
                        '<sh:Contact>' mv_company_taxid '</sh:Contact>'
                        '<sh:ContactTypeIdentifier>VKN_TCKN</sh:ContactTypeIdentifier>'
                    '</sh:ContactInformation>'
                    '<sh:ContactInformation>'
                        '<sh:Contact>' is_ubl_structure-part1-accounting_supplier_party-party-party_name-name-base-base-content '</sh:Contact>'
                        '<sh:ContactTypeIdentifier>UNVAN</sh:ContactTypeIdentifier>'
                    '</sh:ContactInformation>'
                '</sh:Sender>'
                '<sh:Receiver>'
                    '<sh:Identifier>' iv_receiver_alias '</sh:Identifier>'
                    '<sh:ContactInformation>'
                        '<sh:Contact>' iv_receiver_taxid '</sh:Contact>'
                        '<sh:ContactTypeIdentifier>VKN_TCKN</sh:ContactTypeIdentifier>'
                    '</sh:ContactInformation>'
                    '<sh:ContactInformation>'
                        '<sh:Contact>' is_ubl_structure-part1-accounting_customer_party-party-party_name-name-base-base-content '</sh:Contact>'
                        '<sh:ContactTypeIdentifier>UNVAN</sh:ContactTypeIdentifier>'
                    '</sh:ContactInformation>'
                '</sh:Receiver>'
                '<sh:DocumentIdentification>'
                    '<sh:Standard>UBLTR</sh:Standard>'
                    '<sh:TypeVersion>1.2</sh:TypeVersion>'
                    '<sh:InstanceIdentifier>' lv_envelope_uuid '</sh:InstanceIdentifier>'
                    '<sh:Type>SENDERENVELOPE</sh:Type>'
                    '<sh:CreationDateAndTime>' sy-datum+0(4) '-'
                                               sy-datum+4(2) '-'
                                               sy-datum+6(2) 'T'
                                               sy-uzeit+0(2) ':'
                                               sy-uzeit+2(2) ':'
                                               sy-uzeit+4(2)
                                               '</sh:CreationDateAndTime>'
                '</sh:DocumentIdentification>'
            '</sh:StandardBusinessDocumentHeader>'
            '<ef:Package>'
                '<Elements>'
                    '<ElementType>INVOICE</ElementType>'
                    '<ElementCount>1</ElementCount>'
                    '<ElementList>'
                    lv_ubl_xml
                    '</ElementList>'
                '</Elements>'
            '</ef:Package>'
        '</sh:StandardBusinessDocument>'
      INTO lv_envelope_xml.

    lo_zip = NEW cl_abap_zip( ).
    CONCATENATE lv_envelope_uuid '.xml' INTO lv_file_name.
    lv_envelope_raw = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_envelope_xml ).
    lo_zip->add( name    = lv_file_name
                 content = lv_envelope_raw ).
    lv_envelope_raw = lo_zip->save( ).
    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_envelope_raw
      IMPORTING
        output = lv_envelope_xml.

    CALL FUNCTION 'CALCULATE_HASH_FOR_RAW'
      EXPORTING
        alg            = 'MD5'
        data           = lv_envelope_raw
      IMPORTING
        hash           = lv_hash
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.

    lv_invoice_uuid = iv_document_uuid.
    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
         '<soapenv:Header>'
            '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
            '</efat:UserCredentials>'
         '</soapenv:Header>'
       '<soapenv:Body>'
      '<efat:sendDocument>'
         '<efat:documentRequest>'
            '<fileName>' lv_envelope_uuid '.zip</fileName>'
            '<binaryData contentType="application/zip">' lv_envelope_xml '</binaryData>'
*            '<binaryData d5p1:contentType="application/zip" xmlns:d5p1="http://www.w3.org/2005/05/xmlmime">' lv_envelope_xml '</binaryData>'
            '<hash>' lv_hash '</hash>'
         '</efat:documentRequest>'
      '</efat:sendDocument>'
       '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/Connector.asmx'.

    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'text/xml;charset=UTF-8'.

    lv_response_xml = run_service( lv_request_xml ).
    ev_envelope_uuid = lv_envelope_uuid.
  ENDMETHOD.


  METHOD outgoing_invoice_send_again.
    outgoing_invoice_send(
      EXPORTING
        iv_document_uuid     = iv_document_uuid
        is_ubl_structure     = is_ubl_structure
        iv_ubl_xstring       = iv_ubl_xstring
        iv_ubl_hash          = iv_ubl_hash
        iv_receiver_alias    = iv_receiver_alias
        iv_receiver_taxid    = iv_receiver_taxid
        it_custom_parameters = it_custom_parameters
      IMPORTING
        ev_envelope_uuid     = ev_envelope_uuid
    ).
  ENDMETHOD.


  METHOD set_incoming_invoice_received.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb.

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:efat="http://gib.gov.tr/vedop3/eFatura">'
         '<soapenv:Header>'
            '<efat:UserCredentials>'
               '<efat:UserName>' ms_company_parameters-wsusr '</efat:UserName>'
               '<efat:Password>' ms_company_parameters-wspwd '</efat:Password>'
            '</efat:UserCredentials>'
         '</soapenv:Header>'
       '<soapenv:Body>'
          '<efat:setDocumentResponse>'
             '<efat:invoiceUUID>' iv_document_uuid '</efat:invoiceUUID>'
          '</efat:setDocumentResponse>'
       '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
  ENDMETHOD.
ENDCLASS.