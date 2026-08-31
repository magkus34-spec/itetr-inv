class /ITETR/CL_EARCHIVE_WS_BIM definition
  public
  inheriting from /ITETR/CL_EARCHIVE_WS
  create public .

public section.

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
  PRIVATE SECTION.
ENDCLASS.



CLASS /ITETR/CL_EARCHIVE_WS_BIM IMPLEMENTATION.


  METHOD download_registered_taxpayers.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lt_request_header TYPE mty_service_header_tab.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<fat:EFaturaFirmalari>'
               '<fat:Girdi>'
                  '<fat:Kimlik>'
                     '<fat:Sistem></fat:Sistem>'
                     '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                     '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
                  '</fat:Kimlik>'
               '</fat:Girdi>'
            '</fat:EFaturaFirmalari>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'

    INTO lv_request_xml.
*    mv_request_url = '/EArchiveService.asmx'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/EFaturaFirmalari'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'text/xml;charset=UTF-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'EFaturaFirma'.
          APPEND INITIAL LINE TO rt_list ASSIGNING <ls_taxpayer>.
        WHEN 'Identifier'.
          <ls_taxpayer>-taxid = ls_xml_line-cvalue.
        WHEN 'Alias'.
          <ls_taxpayer>-aliass = ls_xml_line-cvalue.
        WHEN 'Title'.
          <ls_taxpayer>-title = ls_xml_line-cvalue.
        WHEN 'Type'.
          CASE ls_xml_line-cvalue.
            WHEN 'Özel'.
              <ls_taxpayer>-txpty = 'OZEL'.
            WHEN 'Kamu'.
              <ls_taxpayer>-txpty = 'KAMU'.
          ENDCASE.
        WHEN 'RegisterTime'.
          CONCATENATE ls_xml_line-cvalue(4)
                      ls_xml_line-cvalue+5(2)
                      ls_xml_line-cvalue+8(2)
                      INTO <ls_taxpayer>-regdt.
          CONCATENATE ls_xml_line-cvalue+11(2)
                      ls_xml_line-cvalue+14(2)
                      ls_xml_line-cvalue+17(2)
                      INTO <ls_taxpayer>-regtm.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  method GET_INCOMING_ARCHIVES.
  endmethod.


  METHOD incoming_archive_download.
  ENDMETHOD.


  METHOD outgoing_invoice_cancel.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lt_request_header TYPE mty_service_header_tab.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
            '<fat:EArsivIptalFaturasiKes>'
               '<fat:Girdi>'
                  '<fat:Kimlik>'
                     '<fat:Sistem></fat:Sistem>'
                     '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                     '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
                  '</fat:Kimlik>'
*                  '<fat:FaturaNo></fat:FaturaNo>'
*                  '<fat:FaturaETTN></fat:FaturaETTN>'
*                  '<fat:DuzenlemeTarihi></fat:DuzenlemeTarihi>'
                  '<fat:FaturayiEmailIleGonder>false</fat:FaturayiEmailIleGonder>'
                  '<fat:IptalFatura>'
                     '<fat:IptalFaturaETTN>' is_document_numbers-duich '</fat:IptalFaturaETTN>'
                  '</fat:IptalFatura>'
               '</fat:Girdi>'
            '</fat:EArsivIptalFaturasiKes>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'

    INTO lv_request_xml.
*    mv_request_url = '/EArchiveService.asmx'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/EArsivIptalFaturasiKes'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'text/xml;charset=UTF-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_taxpayers_raw  TYPE xstring,
          lv_taxpayers_xml  TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lv_content        TYPE string,
          lv_format         TYPE char1.
    DATA: lx_exception 	    TYPE REF TO /itetr/cx_regulative_exception.
    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header,
                   <ls_taxpayer>       TYPE /itetr/inv_taxp.


    lv_format = SWITCH char1( iv_content_type WHEN 'UBL'  THEN '1'
                                              WHEN 'PDF'  THEN '2'
                                              WHEN 'HTML' THEN '3'  ).

    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
         '<soapenv:Header/>'
         '<soapenv:Body>'
             '<fat:FaturaIndir>'
               '<fat:Girdi>'
                  '<fat:Kimlik>'
                     '<fat:Sistem></fat:Sistem>'
                     '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                     '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
                  '</fat:Kimlik>'
                  '<fat:FaturaETTN>' is_document_numbers-duich '</fat:FaturaETTN>'
                  '<fat:Format>' lv_format '</fat:Format>'
                  '<fat:Pozisyon>1</fat:Pozisyon>'
               '</fat:Girdi>'
            '</fat:FaturaIndir>'
         '</soapenv:Body>'
      '</soapenv:Envelope>'


    INTO lv_request_xml.
*    mv_request_url = '/EArchiveService.asmx'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/FaturaIndir'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'text/xml;charset=UTF-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).



    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
    IF ls_xml_line-cvalue  EQ '1'.

      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'Icerik'.
            CONCATENATE lv_content
                ls_xml_line-cvalue
                INTO lv_content.
        ENDCASE.
      ENDLOOP.
      IF lv_content IS NOT INITIAL.
        rv_invoice_data = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
      ENDIF.

    ELSE.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_xml_line-cvalue(50)
                                                                       iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                       iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                       iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
    rs_status-stacd = '5'.
  ENDMETHOD.


  method OUTGOING_INVOICE_PREVIEW.
  endmethod.


  METHOD outgoing_invoice_send.

    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_invoice_base64 TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_ubl_raw        TYPE xstring,
          lv_submatch       TYPE string,
          lv_file_name      TYPE string,
          lv_ubl_xml        TYPE string,
          lt_request_header TYPE mty_service_header_tab,
          lx_exception 	    TYPE REF TO /itetr/cx_regulative_exception,
          lv_true(4).

    FIELD-SYMBOLS: <ls_request_header> TYPE mty_service_header.

    lv_ubl_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( iv_ubl_xstring ).
    REPLACE FIRST OCCURRENCE OF '<?xml version="1.0"?>' IN lv_ubl_xml WITH ``.
    lv_submatch = '<ext:UBLExtensions><ext:UBLExtension><ext:ExtensionContent></ext:ExtensionContent></ext:UBLExtension></ext:UBLExtensions><cbc:UBLVersionID>'.
    REPLACE REGEX '<cbc:UBLVersionID>' IN lv_ubl_xml WITH lv_submatch.
    REPLACE FIRST OCCURRENCE OF 'Gönderim Şekli' IN lv_ubl_xml WITH `GONDERIMSEKLI`.
    REPLACE REGEX '<cbc:Note>GONDERIMSEKLI' IN lv_ubl_xml WITH '<cbc:Note>FATURATIPI:EARSIV</cbc:Note><cbc:Note>GONDERIMSEKLI'.
    lv_ubl_raw = /itetr/cl_regulative_common=>convert_string_to_xstring( lv_ubl_xml ).

    lv_file_name = iv_document_uuid.
    lv_zipped_file = /itetr/cl_regulative_common=>zip_file_single( iv_input_data = lv_ubl_raw
                                                                   iv_input_name = lv_file_name ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_zipped_file
      IMPORTING
        output = lv_invoice_base64.

*    IF is_ubl_structure-part1-accounting_customer_party-party-postal_address-country-name-base-base-content EQ 'Türkiye'.
    IF is_ubl_structure-part1-accounting_customer_party-party-contact-electronic_mail-base-base-content IS NOT INITIAL.
      lv_true = 'true'.
    ENDIF.

    CONCATENATE
        '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fat="http://fatura.edoksis.net">'
           '<soapenv:Header/>'
           '<soapenv:Body>'
              '<fat:EArsivFaturaGonderUBLTR>'
                 '<fat:Girdi>'
                    '<fat:Kimlik>'
                       '<fat:Sistem></fat:Sistem>'
                       '<fat:Kullanici>' ms_company_parameters-wsusr '</fat:Kullanici>'
                       '<fat:Sifre>' ms_company_parameters-wspwd '</fat:Sifre>'
                    '</fat:Kimlik>'
                    '<fat:FaturaIcerik>' lv_invoice_base64 '</fat:FaturaIcerik>'
                    '<fat:FaturayiEmailIleGonder>' lv_true '</fat:FaturayiEmailIleGonder>'
                    '<fat:XSLTRumuzu></fat:XSLTRumuzu>'
                 '</fat:Girdi>'
              '</fat:EArsivFaturaGonderUBLTR>'
           '</soapenv:Body>'
        '</soapenv:Envelope>'

    INTO lv_request_xml.
*    mv_request_url = '/EArchiveService.asmx'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'SOAPAction'.
    <ls_request_header>-value = 'http://fatura.edoksis.net/EArsivFaturaGonderUBLTR'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Content-Type'.
    <ls_request_header>-value = 'text/xml; charset=utf-8'.
    APPEND INITIAL LINE TO lt_request_header ASSIGNING <ls_request_header>.
    <ls_request_header>-name = 'Accept-Encoding'.
    <ls_request_header>-value = 'gzip,deflate,br'.

    lv_response_xml = run_service( iv_request = lv_request_xml
                                   it_request_header = lt_request_header ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Sonuc'.
    IF ls_xml_line-cvalue  EQ '1'.
      ev_invoice_uuid = is_ubl_structure-part1-uuid-base-base-content.
    ELSE.
      CLEAR ls_xml_line.
      READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'Mesaj'.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                       iv_msgv1 = ls_xml_line-cvalue(50)
                                                                       iv_msgv2 = ls_xml_line-cvalue+50(50)
                                                                       iv_msgv3 = ls_xml_line-cvalue+100(50)
                                                                       iv_msgv4 = ls_xml_line-cvalue+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.
ENDCLASS.