class /ITETR/CL_EINVOICE_WS_EFN definition
  public
  inheriting from /ITETR/CL_EINVOICE_WS
  create public .

public section.

  types:
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
  types:
    BEGIN OF mty_user_alias,
        etiket                  TYPE String,
        etiketolusturulmazamani TYPE string,
      END OF mty_user_alias .
  types:
    mty_user_alias_t TYPE STANDARD TABLE OF mty_user_alias WITH DEFAULT KEY .
  types:
    BEGIN OF mty_users,
        tip         TYPE string,
        kayitzamani TYPE string,
        unvan       TYPE string,
        vkntckn     TYPE string,
        hesaptipi   TYPE string,
        aktifetiket TYPE mty_user_alias_t,
      END OF mty_users .
  types:
    mty_users_t TYPE STANDARD TABLE OF mty_users WITH DEFAULT KEY .
  types:
    BEGIN OF mty_user_list,
        efaturakayitlikullanici TYPE mty_users_t,
      END OF mty_user_list .
  types:
    BEGIN OF mty_fat1_ekbilgi,
        anahtar TYPE string,
        deger   TYPE string,
      END OF mty_fat1_ekbilgi .
  types:
    mty_fat1_ekbilgi_t TYPE STANDARD TABLE OF mty_fat1_ekbilgi WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_ekler,
        dosya_adi    TYPE string,
        mime_type    TYPE string,
        icerik       TYPE string,
        belge_turu   TYPE string,
        belge_tarihi TYPE string,
      END OF mty_fat1_ekler .
  types:
    mty_fat1_ekler_t TYPE STANDARD TABLE OF mty_fat1_ekler WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_iadeyekonu,
        fatura_no     TYPE string,
        fatura_tarihi TYPE string,
      END OF mty_fat1_iadeyekonu .
  types:
    mty_fat1_iadeyekonu_t TYPE STANDARD TABLE OF mty_fat1_iadeyekonu WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_vergi,
        ad              TYPE string,
        kod             TYPE string,
        matrah          TYPE string,
        oran            TYPE string,
        vergi_tutari    TYPE string,
        muafiyet_sebebi TYPE string,
      END OF mty_fat1_vergi .
  types:
    mty_fat1_vergi_t TYPE STANDARD TABLE OF mty_fat1_vergi WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_vergiler,
        toplam_vergi_tutari TYPE string,
        vergi               TYPE mty_fat1_vergi_t,
      END OF mty_fat1_vergiler .
  types:
    mty_fat1_vergiler_t TYPE STANDARD TABLE OF mty_fat1_vergiler WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_alicisatici,
        musteri_no    TYPE string,
        vergi_no      TYPE string,
        vergi_dairesi TYPE string,
        unvan         TYPE string,
        ulke          TYPE string,
        sehir         TYPE string,
        ilce          TYPE string,
        cadde_sokak   TYPE string,
        kasaba_koy    TYPE string,
        bina_adi      TYPE string,
        bina_no       TYPE string,
        kapi_no       TYPE string,
        posta_kodu    TYPE string,
        tel           TYPE string,
        fax           TYPE string,
        web_sitesi    TYPE string,
        eposta        TYPE string,
        sube_kodu     TYPE string,
        sube_adi      TYPE string,
        tapdk_no      TYPE string,
        adi           TYPE string,
        soyadi        TYPE string,
        etiket        TYPE string,
      END OF mty_fat1_alicisatici .
  types:
    BEGIN OF mty_fat1_siparis,
        siparis_no     TYPE string,
        siparis_tarihi TYPE string,
      END OF mty_fat1_siparis .
  types:
    BEGIN OF mty_fat1_irsaliye,
        irsaliye_no     TYPE string,
        irsaliye_tarihi TYPE string,
      END OF mty_fat1_irsaliye .
  types:
    mty_fat1_irsaliye_t TYPE STANDARD TABLE OF mty_fat1_irsaliye WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_malkabul,
        mal_kabul_no     TYPE string,
        mal_kabul_tarihi TYPE string,
      END OF mty_fat1_malkabul .
  types:
    mty_fat1_malkabul_t TYPE STANDARD TABLE OF mty_fat1_malkabul WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_satir,
        sira_no                TYPE string,
        alici_urun_kodu        TYPE string,
        satici_urun_kodu       TYPE string,
        uretici_urun_kodu      TYPE string,
        marka_adi              TYPE string,
        model_adi              TYPE string,
        urun_adi               TYPE string,
        tanim                  TYPE string,
        birim_kodu             TYPE string,
        birim_fiyat            TYPE string,
        miktar                 TYPE string,
        mal_hizmet_miktari     TYPE string,
        iskonto_artirim_nedeni TYPE string,
        iskonto_orani          TYPE string,
        iskonto_tutari         TYPE string,
        vergiler               TYPE mty_fat1_vergiler,
      END OF mty_fat1_satir .
  types:
    mty_fat1_satir_t TYPE STANDARD TABLE OF mty_fat1_satir WITH DEFAULT KEY .
  types:
    BEGIN OF mty_fat1_belge,
        fatura_id                      TYPE string,
        fatura_no                      TYPE string,
        fatura_tarihi                  TYPE string,
        fatura_zamani                  TYPE string,
        fatura_tipi                    TYPE string,
        fatura_turu                    TYPE string,
        siparis_bilgisi                TYPE mty_fat1_siparis,
        irsaliye_bilgisi               TYPE mty_fat1_irsaliye_t,
        mal_kabul_bilgisi              TYPE mty_fat1_malkabul_t,
        son_odeme_tarihi               TYPE string,
        para_birimi                    TYPE string,
        alici                          TYPE mty_fat1_alicisatici,
        satici                         TYPE mty_fat1_alicisatici,
        fatura_satir                   TYPE mty_fat1_satir_t,
        toplam_mal_hizmet_miktari      TYPE string,
        toplam_iskonto_tutari          TYPE string,
        toplam_artirim_tutari          TYPE string,
        vergi_haric_toplam             TYPE string,
        vergi_dahil_tutar              TYPE string,
        yuvarlama_tutari               TYPE string,
        odenecek_tutar                 TYPE string,
        vergiler                       TYPE mty_fat1_vergiler_t,
        fatura_not                     TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
        iadeye_konu_olan_fatura_bilgil TYPE mty_fat1_iadeyekonu_t,
        ekler                          TYPE mty_fat1_ekler_t,
        ek_bilgiler                    TYPE mty_fat1_ekbilgi_t,
      END OF mty_fat1_belge .

  constants MC_ERPCODE_PARAMETER type /ITETR/COM_E_CUSPA value 'ERPCODE' ##NO_TEXT.
  constants MC_DEFCON_PARAMETER type /ITETR/COM_E_CUSPA value 'DEFCON' ##NO_TEXT.

  methods INCOMING_INVOICE_RESPONSE_AGN
    importing
      !IS_DOCUMENT_NUMBERS type /ITETR/COM_S_DOCUMENT_NUMBERS optional
      !IV_RESPONSE type /ITETR/INV_E_APRES optional
      value(IV_NOTE) type /ITETR/COM_E_LNOTE optional
      !IV_RECEIVER_ALIAS type /ITETR/COM_E_ALIAS optional
      value(IV_RECEIVER_TAXID) type STCD2 optional
      !IV_DOCUMENT_UUID_CHAR type /ITETR/COM_E_DUICH optional
      !IV_BELGEOID type /ITETR/INV_E_BELGEOID optional .

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

  methods GET_INCOMING_INVOICES_INT
    importing
      !IV_DATE_FROM type BEGDA
      !IV_DATE_TO type ENDDA
    returning
      value(RT_INVOICES) type MTY_INCOMING_DOCUMENTS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_INCOMING_INVOICE_STAT_INT
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DUICH
    returning
      value(RS_STATUS) type MTY_DOCUMENT_STATUS
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods SET_INCOMING_INVOICE_RECEIVED
    importing
      !IV_DOCUMENT_UUID type /ITETR/COM_E_DUICH
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .
  methods GET_INCOMING_FROM_PORTAL
    importing
      !IV_ETTN type /ITETR/COM_E_ETTN
      !IV_CONTENT_TYPE type /ITETR/COM_E_CONTY
    returning
      value(RV_INVOICE_DATA) type /ITETR/COM_E_CONTN
    raising
      /ITETR/CX_REGULATIVE_EXCEPTION .

  methods BUILD_APPLICATION_RESPONSE
    redefinition .
private section.
ENDCLASS.



CLASS /ITETR/CL_EINVOICE_WS_EFN IMPLEMENTATION.


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
        "osmans 06.12.2022 e-finans osman çuhadar tarafından gelen maile istinaden eklendi
        <ls_signature>-digital_signature_attachment-external_reference-uri-base-base-content = '#Signature_DSB2022000000874'.
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


  METHOD download_registered_taxpayers.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          ls_user_list      TYPE mty_user_list,
          ls_user           TYPE mty_users,
          ls_alias          TYPE mty_user_alias,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp,
          lx_exception      TYPE REF TO /itetr/cx_regulative_exception.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
      '<soapenv:Body>'
        '<ser:kayitliKullaniciListeleExtended>'
          '<urun>EFATURA</urun>'
          '<gecmisEklensin></gecmisEklensin>'
        '</ser:kayitliKullaniciListeleExtended>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
          CONCATENATE lv_base64_content ls_xml_line-cvalue INTO lv_base64_content.
      ENDCASE.
    ENDLOOP.


    IF lv_base64_content IS INITIAL.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '002' ).
      RAISE EXCEPTION lx_exception.
    ENDIF.



    lv_zipped_file = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_base64_content ).

****    /itetr/cl_regulative_common=>unzip_file_single(
****      EXPORTING
****        iv_zipped_file_xstr = lv_zipped_file
****
****      IMPORTING
****        ev_output_data_str = lv_taxpayers_xml ).

    DATA: lo_zip           TYPE REF TO cl_abap_zip,
          lv_input_xstring TYPE xstring,
          ls_file          TYPE cl_abap_zip=>t_file,
          lv_file_name     TYPE string,
          lv_xml_xstring   TYPE xstring.

    lv_input_xstring = lv_zipped_file.

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

***    CALL TRANSFORMATION /itetr/inv_userlist_efn
***      SOURCE XML lv_taxpayers_xml
***      RESULT efaturakayitlikullaniciliste = ls_user_list.

    CLEAR: lv_response_xml,
           lt_xml_table[],
           lv_base64_content,
           lv_zipped_file,
           lv_input_xstring,
           ls_file.
    FREE lo_zip.

    CALL TRANSFORMATION /itetr/inv_userlist_efn
      SOURCE XML lv_xml_xstring
      RESULT efaturakayitlikullaniciliste = ls_user_list.

    CLEAR lv_xml_xstring.

    DATA : lt_default_allias TYPE TABLE OF /itetr/inv_allis.

    SELECT * FROM /itetr/inv_allis INTO TABLE lt_default_allias WHERE taxid NE space.


    SORT lt_default_allias BY taxid aliass.
    DATA: lv_tabix TYPE i.
    LOOP AT ls_user_list-efaturakayitlikullanici INTO ls_user.
      lv_tabix = sy-tabix.
      CLEAR ls_taxpayer.
      CASE ls_user-tip.
        WHEN 'Özel'.
          ls_taxpayer-txpty = 'OZEL'.
        WHEN OTHERS.
          ls_taxpayer-txpty = 'KAMU'.
      ENDCASE.
      IF ls_user-kayitzamani IS NOT INITIAL.
        ls_taxpayer-regdt = ls_user-kayitzamani(8).
        ls_taxpayer-regtm = ls_user-kayitzamani+8(6).
      ENDIF.
      ls_taxpayer-title = ls_user-unvan.
      ls_taxpayer-taxid = ls_user-vkntckn.

*******      READ TABLE lt_default_allias TRANSPORTING NO FIELDS WITH KEY taxid  = ls_taxpayer-taxid
*******                                                             aliass = ls_taxpayer-aliass  BINARY SEARCH.
*******      IF sy-subrc  IS INITIAL.
*******        ls_taxpayer-defal = 'X'.
*******      ENDIF.

      IF ls_user-aktifetiket IS NOT INITIAL.
        LOOP AT ls_user-aktifetiket INTO ls_alias.
          ls_taxpayer-aliass = ls_alias-etiket.

          READ TABLE lt_default_allias TRANSPORTING NO FIELDS WITH KEY taxid  = ls_taxpayer-taxid
                                                                       aliass = ls_taxpayer-aliass  BINARY SEARCH.
          IF sy-subrc  IS INITIAL.
            ls_taxpayer-defal = 'X'.
          ENDIF.

          APPEND ls_taxpayer TO rt_list.
          CLEAR: ls_taxpayer-defal.
        ENDLOOP.
      ELSE.
        READ TABLE lt_default_allias TRANSPORTING NO FIELDS WITH KEY taxid  = ls_taxpayer-taxid
                                                                     aliass = ls_taxpayer-aliass  BINARY SEARCH.
        IF sy-subrc  IS INITIAL.
          ls_taxpayer-defal = 'X'.
        ENDIF.
        APPEND ls_taxpayer TO rt_list.
        CLEAR: ls_taxpayer-defal.
      ENDIF.
      DELETE ls_user_list-efaturakayitlikullanici INDEX lv_tabix.
    ENDLOOP.

*    lv_taxpayers_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_taxpayers_raw ).
*    CLEAR lt_xml_table.
*    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_taxpayers_xml ).
*    LOOP AT lt_xml_table INTO ls_xml_line.
*      CASE ls_xml_line-cname.
*        WHEN 'eFaturaKayitliKullanici'.
*          CLEAR ls_taxpayer.
*        WHEN 'tip'.
*          CASE ls_xml_line-cvalue.
*            WHEN 'Özel'.
*              ls_taxpayer-txpty = 'OZEL'.
*            WHEN OTHERS.
*              ls_taxpayer-txpty = 'KAMU'.
*          ENDCASE.
*        WHEN 'kayitZamani'.
*          ls_taxpayer-regdt = ls_xml_line-cvalue(8).
*          ls_taxpayer-regtm = ls_xml_line-cvalue+8(6).
*        WHEN 'unvan'.
*          ls_taxpayer-title = ls_xml_line-cvalue.
*        WHEN 'vknTckn'.
*          ls_taxpayer-taxid = ls_xml_line-cvalue.
*        WHEN 'etiket'.
*          ls_taxpayer-aliass = ls_xml_line-cvalue.
*          APPEND ls_taxpayer TO rt_list.
*      ENDCASE.
*    ENDLOOP.
  ENDMETHOD.


  METHOD download_registered_taxp_time.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lv_base64_content TYPE string,
          lv_zipped_file    TYPE xstring,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          ls_user_list      TYPE mty_user_list,
          ls_user           TYPE mty_users,
          ls_alias          TYPE mty_user_alias,
          lv_taxpayers_xml  TYPE string,
          ls_taxpayer       TYPE /itetr/inv_taxp.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
      '<soapenv:Body>'
        '<ser:kayitliKullaniciListeleExtendedTime>'
          '<urun>EFATURA</urun>'
           '<kayitZamani>' iv_date '</kayitZamani>'
          '<gecmisEklensin></gecmisEklensin>'
        '</ser:kayitliKullaniciListeleExtendedTime>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
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

    CALL TRANSFORMATION /itetr/inv_userlist_efn
      SOURCE XML lv_taxpayers_xml
      RESULT efaturakayitlikullaniciliste = ls_user_list.
    LOOP AT ls_user_list-efaturakayitlikullanici INTO ls_user.
      CLEAR ls_taxpayer.
      CASE ls_user-tip.
        WHEN 'Özel'.
          ls_taxpayer-txpty = 'OZEL'.
        WHEN OTHERS.
          ls_taxpayer-txpty = 'KAMU'.
      ENDCASE.
      IF ls_user-kayitzamani IS NOT INITIAL.
        ls_taxpayer-regdt = ls_user-kayitzamani(8).
        ls_taxpayer-regtm = ls_user-kayitzamani+8(6).
      ENDIF.
      ls_taxpayer-title = ls_user-unvan.
      ls_taxpayer-taxid = ls_user-vkntckn.
      IF ls_user-aktifetiket IS NOT INITIAL.
        LOOP AT ls_user-aktifetiket INTO ls_alias.
          ls_taxpayer-aliass = ls_alias-etiket.
          APPEND ls_taxpayer TO rt_list.
        ENDLOOP.
      ELSE.
        APPEND ls_taxpayer TO rt_list.
      ENDIF.
    ENDLOOP.

*    lv_taxpayers_xml = /itetr/cl_regulative_common=>convert_xstring_to_string( lv_taxpayers_raw ).
*    CLEAR lt_xml_table.
*    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_taxpayers_xml ).
*    LOOP AT lt_xml_table INTO ls_xml_line.
*      CASE ls_xml_line-cname.
*        WHEN 'eFaturaKayitliKullanici'.
*          CLEAR ls_taxpayer.
*        WHEN 'tip'.
*          CASE ls_xml_line-cvalue.
*            WHEN 'Özel'.
*              ls_taxpayer-txpty = 'OZEL'.
*            WHEN OTHERS.
*              ls_taxpayer-txpty = 'KAMU'.
*          ENDCASE.
*        WHEN 'kayitZamani'.
*          ls_taxpayer-regdt = ls_xml_line-cvalue(8).
*          ls_taxpayer-regtm = ls_xml_line-cvalue+8(6).
*        WHEN 'unvan'.
*          ls_taxpayer-title = ls_xml_line-cvalue.
*        WHEN 'vknTckn'.
*          ls_taxpayer-taxid = ls_xml_line-cvalue.
*        WHEN 'etiket'.
*          ls_taxpayer-aliass = ls_xml_line-cvalue.
*          APPEND ls_taxpayer TO rt_list.
*      ENDCASE.
*    ENDLOOP.
  ENDMETHOD.


  METHOD get_incoming_from_portal.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
    '<soapenv:Header>'
    '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
      '<wsse:UsernameToken>'
        '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
        '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
      '</wsse:UsernameToken>'
    '</wsse:Security>'
    '</soapenv:Header>'
      '<soapenv:Body>'
        '<ser:gelenTasinanBelgeleriIndir>'
          '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
          '<ettnler>' iv_ettn '</ettnler>'
          '<belgeFormati>' iv_content_type '</belgeFormati>'
        '</ser:gelenTasinanBelgeleriIndir>'
      '</soapenv:Body>'
    '</soapenv:Envelope>' INTO lv_request_xml.

    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
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

  ENDMETHOD.


  METHOD get_incoming_invoices.
    DATA: lt_xml_table         TYPE TABLE OF smum_xmltb,
          ls_xml_line          TYPE smum_xmltb,
          lt_service_return    TYPE mty_incoming_documents,
          lv_zipped_file       TYPE xstring,
          lv_xml_file          TYPE string,
          ls_invoice_status    TYPE mty_document_status,
          lv_attachment_count  TYPE i,
          ls_invoice           TYPE /itetr/com_message1,
          ls_return            TYPE bapiret2,
          lv_content           TYPE xstring,
          ls_document_numbers  TYPE /itetr/com_s_document_numbers,
          ls_doc_ref           TYPE /itetr/com_despatch_document_r,
          ls_tevkifat          TYPE /itetr/com_withholding_tax_tot,
          ls_despatch          TYPE /itetr/inv_icdes,
          ls_additional        TYPE /itetr/com_additional_document,
          ls_taxes             TYPE /itetr/com_tax_total,
          lv_invui             TYPE /itetr/com_e_duich,
          lv_message           TYPE string,
          lx_root              TYPE REF TO cx_root,
          lv_extension         TYPE string,
          lv_uri               TYPE string,
          lv_digest            TYPE string,
          lv_offset            TYPE i,
          ls_ublextension      TYPE /itetr/com_ublextension,
          ls_departmant        TYPE /itetr/com_cmpdp.

    FIELD-SYMBOLS: <ls_service_return> TYPE mty_incoming_document,
                   <ls_list>           TYPE /itetr/inv_icinv.

*    DO.
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
          <ls_list>-invui = <ls_service_return>-ettn.
          <ls_list>-invno = <ls_service_return>-belgeno.
          <ls_list>-invii = <ls_service_return>-belgesirano.
          <ls_list>-envui = <ls_service_return>-zarfid.
          <ls_list>-invno = <ls_service_return>-belgeno.
          <ls_list>-envui = <ls_service_return>-zarfid.
          <ls_list>-invii = <ls_service_return>-belgesirano.
          <ls_list>-invqi = <ls_service_return>-ettn.
          <ls_list>-bukrs = ms_company_parameters-bukrs.
          <ls_list>-taxid = <ls_service_return>-gonderenvkntckn.
          <ls_list>-bldat = <ls_service_return>-belgetarihi.
          <ls_list>-wrbtr = <ls_service_return>-odenecektutar.
          <ls_list>-waers = <ls_service_return>-odenecektutardovizcinsi.

          ls_invoice_status = get_incoming_invoice_stat_int( <ls_list>-invui ).
          <ls_list>-recdt = ls_invoice_status-alimtarihi(8).
          <ls_list>-staex = ls_invoice_status-yanitgonderimcevabidetayi.
          <ls_list>-radsc = ls_invoice_status-yanitgonderimcevabikodu.
          IF ls_invoice_status-kepdurum = '1'.
            <ls_list>-resst = 'K'.
          ELSEIF ls_invoice_status-gibiptaldurum = '1'.
            <ls_list>-resst = 'G'.
          ELSEIF ls_invoice_status-yanitdurumu = '-1'.
            <ls_list>-resst = 'X'.
          ELSE.
            <ls_list>-resst = ls_invoice_status-yanitdurumu.
          ENDIF.

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
          <ls_list>-allowance = ls_invoice-part1-legal_monetary_total-allowance_total_amount-base-content."Indirim Tutarını Okuma
          READ TABLE ls_invoice-part1-withholding_tax_total INTO ls_tevkifat INDEX 1."Tevkifat Tutarını Okuma
          IF sy-subrc EQ 0.
            <ls_list>-withholding = ls_tevkifat-tax_amount-base-content.
          ENDIF.
          READ TABLE ls_invoice-part1-despatch_document_reference INTO ls_doc_ref INDEX 1."AS Gelen irsaliye numarası okuma
          IF sy-subrc EQ 0. "AS Gelen irsaliye numarası okuma
            <ls_list>-despid = ls_doc_ref-id-base-base-content."AS Gelen irsaliye numarası okuma
          ENDIF."AS Gelen irsaliye numarası okuma
        CATCH cx_root INTO lx_root.
          CLEAR <ls_list>-docui.
          lv_message = lx_root->get_text( ).
          CONCATENATE <ls_service_return>-belgeno ' Hata: ' lv_message INTO ev_message.
          CONTINUE.
      ENDTRY.
      TRY.
          <ls_list>-kursf = ls_invoice-part1-pricing_exchange_rate-calculation_rate-base-base-content."Kur bilgisi eklemesi
        CATCH cx_root INTO lx_root.
          CLEAR <ls_list>-kursf.
      ENDTRY.

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
ENHANCEMENT-POINT edit_table SPOTS /itetr/inv_efn_get_incoming .
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

    "21.04.2025 - E-finans Portalden aktarılacak faturalar için
    DATA: lt_portal TYPE TABLE OF /itetr/inv_efni,
          ls_portal TYPE /itetr/inv_efni,
          lv_ettn   TYPE /itetr/com_e_duich.
    "get all viable invoices listed as portal incoming
    IF 1 = 2.
      SELECT *
        FROM /itetr/inv_efni
        INTO TABLE lt_portal
        WHERE bukrs = ms_company_parameters-bukrs.
      IF lt_portal[] IS NOT INITIAL.
        LOOP AT lt_portal INTO ls_portal.
          "if not exist
          SELECT SINGLE invui
            FROM /itetr/inv_icinv
            INTO lv_ettn
            WHERE bukrs = ls_portal-bukrs
              AND invui = ls_portal-ettn_id.
          IF sy-subrc NE 0.
            CLEAR: lv_content, ls_invoice.
            "call service
            lv_content = get_incoming_from_portal( iv_ettn = ls_portal-ettn_id
                                                   iv_content_type = 'UBL' ).

            "convert data to deep structure
            cl_proxy_xml_transform=>xml_xstring_to_abap(
            EXPORTING
              ddic_type                = '/ITETR/COM_MESSAGE1'
              xml                      = lv_content
              ext_xml                  = abap_true
            IMPORTING
              abap_data                = ls_invoice
                ).

            IF ls_invoice IS NOT INITIAL.
              "map fetched data
              APPEND INITIAL LINE TO rt_list ASSIGNING <ls_list>.
              <ls_list>-docui = /itetr/cl_regulative_common=>generate_document_uuid_x16( ).
              <ls_list>-invui = ls_portal-ettn_id.
              <ls_list>-invno = ls_invoice-part1-id-base-base-content.
              <ls_list>-invii = space.
              <ls_list>-envui = ls_portal-env_id.
              <ls_list>-bukrs = ms_company_parameters-bukrs.
              <ls_list>-wrbtr = ls_invoice-part1-legal_monetary_total-payable_amount-base-content.
              <ls_list>-waers = ls_invoice-part1-legal_monetary_total-payable_amount-base-currency_id.
              <ls_list>-staex = 'Eski sistem(Portal) üzerinden alındı. Servis = gelenTasinanBelgeleriIndir'.
              <ls_list>-radsc = '0'.
              <ls_list>-resst = 'X'.
              <ls_list>-orderid = ls_invoice-part1-order_reference-id-base-base-content.
              <ls_list>-dmbtr = ls_invoice-part1-legal_monetary_total-line_extension_amount-base-content.
              <ls_list>-allowance = ls_invoice-part1-legal_monetary_total-allowance_total_amount-base-content.

              READ TABLE ls_invoice-part1-accounting_supplier_party-party-party_identification INTO DATA(ls_partner) INDEX 1.
              IF sy-subrc EQ 0.
                <ls_list>-taxid = ls_partner-id-base-base-content.
              ENDIF.

              CONCATENATE ls_invoice-part1-issue_date-base-content(4) ls_invoice-part1-issue_date-base-content+5(2) ls_invoice-part1-issue_date-base-content+8(2)
                     INTO <ls_list>-bldat.

              CONCATENATE ls_invoice-part1-issue_date-base-content(4) ls_invoice-part1-issue_date-base-content+5(2) ls_invoice-part1-issue_date-base-content+8(2)
                     INTO <ls_list>-recdt.

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
              IF lv_attachment_count > 1.
                <ls_list>-attex = abap_true.
              ENDIF.

              LOOP AT ls_invoice-part1-tax_total INTO ls_taxes.
                <ls_list>-fwste = <ls_list>-fwste + ls_taxes-tax_amount-base-content.
              ENDLOOP.

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
              CLEAR: lv_uri, lv_digest, lv_offset , ls_ublextension, lv_extension.

              <ls_list>-aprvd = abap_true.
              IF <ls_list>-wrbtr IS INITIAL.
                <ls_list>-procs = abap_true.
              ENDIF.

              "table operations
              CLEAR: ls_despatch.
              LOOP AT ls_invoice-part1-despatch_document_reference INTO ls_doc_ref.
                ADD 1 TO ls_despatch-line.
                ls_despatch-despid = ls_doc_ref-id-base-base-content.
                ls_despatch-docui  = <ls_list>-docui.
                INSERT /itetr/inv_icdes FROM ls_despatch.
              ENDLOOP.

              INSERT /itetr/inv_icinv FROM <ls_list>.
***              DELETE FROM /itetr/inv_efni
***                WHERE bukrs = ls_portal-bukrs
***                  AND ettn_id = ls_portal-ettn_id.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_incoming_invoices_int.
    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_zipped_file      TYPE xstring,
          lv_xml_file         TYPE string,
          ls_invoice_status   TYPE mty_document_status.

    FIELD-SYMBOLS: <ls_list>          TYPE mty_incoming_document,
                   <lv_invoice_field> TYPE any.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gelenBelgeleriAlExt>'
           '<parametreler>'
              '<belgeFormati>UBL</belgeFormati>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<belgeVersiyon></belgeVersiyon>'
              '<donusTipiVersiyon>3.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<gelisTarihiBaslangic>' iv_date_from '000000</gelisTarihiBaslangic>'
              '<gelisTarihiBitis>' iv_date_to '235959</gelisTarihiBitis>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:gelenBelgeleriAlExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
          APPEND INITIAL LINE TO rt_invoices ASSIGNING <ls_list>.
        WHEN 'belgeXmlZipped'.
          CONCATENATE <ls_list>-belgexmlzipped
                      ls_xml_line-cvalue
                      INTO <ls_list>-belgexmlzipped.
        WHEN OTHERS.
          TRANSLATE ls_xml_line-cname TO UPPER CASE.
          ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE <ls_list> TO <lv_invoice_field>.
          IF sy-subrc = 0.
            <lv_invoice_field> = ls_xml_line-cvalue.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_incoming_invoice_stat_int.
    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gelenBelgeDurumSorgulaExt>'
           '<parametreler>'
              '<ettn>' iv_document_uuid '</ettn>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<donusTipiVersiyon>5.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:gelenBelgeDurumSorgulaExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      TRANSLATE ls_xml_line-cname TO UPPER CASE.
      ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE rs_status TO <lv_return_field>.
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-cvalue.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD incoming_invoice_download.
    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_content          TYPE string,
          lv_zipped_file      TYPE xstring,
          lv_content_type     TYPE /itetr/com_e_conty,
          lv_fieldname        TYPE string.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    FIELD-SYMBOLS: <fs_var> TYPE any.
    ASSIGN ('(/ITETR/INCOMING_INVOICE)GV_FIELDNAME') TO <fs_var>.
    IF <fs_var> IS ASSIGNED.
      lv_fieldname = <fs_var>.
    ENDIF.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_defcon_parameter.
    IF sy-subrc EQ 0 AND iv_content_type EQ 'PDF' AND lv_fieldname EQ 'PREIC'.
      lv_content_type = ls_custom_parameter-value.
    ELSE.
      lv_content_type  = iv_content_type.
    ENDIF.
    CLEAR:ls_custom_parameter.


    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    "25.04.2025 - Portalden gelen faturalar farklı şekilde alınmalı!
    DATA: ls_portal TYPE /itetr/inv_efni.
    SELECT SINGLE bukrs ettn_id env_id
      FROM /itetr/inv_efni
      INTO ls_portal
      WHERE bukrs = ms_company_parameters-bukrs
        AND ettn_id = is_document_numbers-duich.
    IF sy-subrc NE 0.
      CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
        '<soapenv:Header>'
          '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
            '<wsse:UsernameToken>'
                  '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                  '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
            '</wsse:UsernameToken>'
          '</wsse:Security>'
        '</soapenv:Header>'
         '<soapenv:Body>'
         '<ser:gelenBelgeleriIndirExt>'
             '<parametreler>'
                '<ettn>' is_document_numbers-duich '</ettn>'
                '<belgeTuru>FATURA</belgeTuru>'
                '<belgeFormati>' lv_content_type '</belgeFormati>'
                '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
                '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
             '</parametreler>'
          '</ser:gelenBelgeleriIndirExt>'
        '</soapenv:Body>'
      '</soapenv:Envelope>'
      INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
      lv_response_xml = run_service( lv_request_xml ).

      lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
      LOOP AT lt_xml_table INTO ls_xml_line.
        CASE ls_xml_line-cname.
          WHEN 'return'.
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
      rv_invoice_data = get_incoming_from_portal( iv_ettn = is_document_numbers-duich
                                                  iv_content_type = iv_content_type ).
    ENDIF.
  ENDMETHOD.


  METHOD incoming_invoice_get_status.
    DATA: ls_invoice_status TYPE mty_document_status.
    ls_invoice_status = get_incoming_invoice_stat_int( is_document_numbers-duich ).

    rs_status-staex = ls_invoice_status-yanitgonderimcevabidetayi.
    rs_status-radsc = ls_invoice_status-yanitgonderimcevabikodu.
    IF ls_invoice_status-kepdurum = '1'.
      rs_status-resst = 'K'.
    ELSEIF ls_invoice_status-gibiptaldurum = '1'.
      rs_status-resst = 'G'.
    ELSEIF ls_invoice_status-yanitdurumu = '-1'.
      rs_status-resst = 'X'.
    ELSE.
      rs_status-resst = ls_invoice_status-yanitdurumu.
    ENDIF.
  ENDMETHOD.


  METHOD incoming_invoice_response.
    DATA: lv_appres_xml       TYPE xstring,
          lv_appres_hash      TYPE md5_fields-hash,
          lv_appres_base64    TYPE string,
          lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_custom_parameter TYPE /itetr/inv_eicp,
          lv_content          TYPE string,
          lv_zipped_file      TYPE xstring,
          lv_document_uuid    TYPE /itetr/com_e_duich.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    build_application_response(
      EXPORTING
        is_document_numbers = is_document_numbers
        iv_response      = iv_response
        iv_note          = iv_note
      IMPORTING
        ev_response_xml  = lv_appres_xml
        ev_response_hash = lv_appres_hash ).

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = lv_appres_xml
      IMPORTING
        output = lv_appres_base64.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:belgeGonderExt>'
           '<parametreler>'
              '<belgeHash>' lv_appres_hash '</belgeHash>'
              '<belgeNo>' is_document_numbers-duich '</belgeNo>'
              '<belgeVersiyon>2.1</belgeVersiyon>'
              '<belgeTuru>UYGULAMA_YANITI_UBL</belgeTuru>'
              '<mimeType>application/xml</mimeType>'
              '<veri>' lv_appres_base64 '</veri>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:belgeGonderExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    READ TABLE lt_xml_table INTO DATA(ls_xml_table) WITH KEY cname = 'belgeOid'.
    IF sy-subrc IS INITIAL.
      SELECT SINGLE *
        FROM /itetr/inv_icinv
        INTO @DATA(ls_icinv)
        WHERE docui EQ @is_document_numbers-docui.
      IF sy-subrc IS INITIAL.
        ls_icinv-belgeoid = ls_xml_table-cvalue.
        MODIFY /itetr/inv_icinv FROM ls_icinv.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.
    "Burda belgeooid yi kaydetmek lazım
  ENDMETHOD.


  METHOD incoming_invoice_response_agn.


    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring,
          lv_docui        TYPE string.
    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
*       '<ser:belgeleriTekrarGonder>'
       '<ser:belgeleriTekrarGonderBelgeOid>'
*           '<parametreler>'
*              '<ettn>' iv_document_uuid_char '</ettn>'
              '<belgeOid>' iv_belgeoid '</belgeOid>'
              '<belgeTuru>UYGULAMA_YANITI</belgeTuru>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
              '<alanEtiket>' '</alanEtiket>'
              '<gonderenEtike>' '</gonderenEtike>'
*           '</parametreler>'
*        '</ser:belgeleriTekrarGonder>'
        '</ser:belgeleriTekrarGonderBelgeOid>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).


  ENDMETHOD.


  METHOD outgoing_invoice_cancel.
    DATA: lv_request_xml TYPE string.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
              '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
              '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
          '<ser:yolcuBeraberFaturaIptalEt>'
             '<pusulaTarihi>' iv_document_date '</pusulaTarihi>'
             '<ettn>' is_document_numbers-duich '</ettn>'
             '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
          '</ser:yolcuBeraberFaturaIptalEt>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    run_service( lv_request_xml ).
  ENDMETHOD.


  METHOD outgoing_invoice_download.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gidenBelgeleriIndirEttn>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
              '<belgeEttnListesi>' is_document_numbers-duich '</belgeEttnListesi>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<belgeFormati>' iv_content_type '</belgeFormati>'
        '</ser:gidenBelgeleriIndirEttn>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
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
  ENDMETHOD.


  METHOD outgoing_invoice_get_export.

    TYPES: BEGIN OF ty_status,
             aciklama                TYPE string,
             alimtarihi              TYPE string,
             belgeno                 TYPE string,
             durum                   TYPE string,
             ettn                    TYPE string,
             gonderimcevabidetayi    TYPE string,
             gonderimcevabikodu      TYPE string,
             gonderimdurumu          TYPE string,
             gonderimtarihi          TYPE string,
             olusturulmatarihi       TYPE string,
             yanitdetayi             TYPE string,
             yanitdurumu             TYPE string,
             ulastimi                TYPE string,
             yenidengonderilebilirmi TYPE string,
             yerelbelgeoid           TYPE string,
             gtbfiiliihracattarihi   TYPE string,
             gtbgcbtescilno          TYPE string,
             gtbrefno                TYPE string,
             kepdurum                TYPE string,
           END OF ty_status.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          ls_status       TYPE ty_status,
          lv_day(2),
          lv_month(2),
          lv_year(4).

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gidenBelgeDurumSorgulaExt>'
           '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '<parametreler>'
              '<belgeNo>' is_document_numbers-docii '</belgeNo>'
              '<belgeNoTipi>OID</belgeNoTipi>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<donusTipiVersiyon>4.0</donusTipiVersiyon>'
           '</parametreler>'
        '</ser:gidenBelgeDurumSorgulaExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      TRANSLATE ls_xml_line-cname TO UPPER CASE.
      ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE ls_status TO <lv_return_field>.
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-cvalue.
      ENDIF.
    ENDLOOP.

    IF  lt_xml_table[] IS NOT INITIAL."gkadioglu

*****      IF ls_status-durum = 1 OR ls_status-durum = 2.
*****        rs_status-stacd = ls_status-durum.
*****      ELSEIF ls_status-gonderimdurumu = 0.
*****        rs_status-stacd = '3'.
*****      ELSEIF ls_status-gonderimdurumu = -1 OR ls_status-gonderimdurumu = 1.
*****        rs_status-stacd = '4'.
*****      ELSEIF ls_status-gonderimdurumu = 2.
*****        rs_status-stacd = '5'.
*****      ELSEIF ls_status-gonderimdurumu = 3.
*****        rs_status-stacd = '6'.
*****      ELSEIF ls_status-gonderimdurumu = 4.
*****        IF ls_status-yanitdurumu = 0.
*****          rs_status-stacd = '7'.
*****        ELSE.
*****          rs_status-stacd = 'X'.
*****        ENDIF.
*****      ENDIF.

      "e-finans
      " 1 durum kodu belge gönderildi ama kuyrukta
      " 2 işlendi ama validasyon hatası aldı tekrar belge ubl i gönder
      " 3 belge validasyondan geçti ve durumunu sorgula

      IF ls_status-durum = 1 OR ls_status-durum = 2.
        rs_status-stacd = ls_status-durum.
      ENDIF.

      IF ls_status-durum = 3.
        IF ls_status-gonderimdurumu = -1 OR ls_status-gonderimdurumu = 1.
          rs_status-stacd = '4'.
        ELSEIF ls_status-gonderimdurumu = 2.
          rs_status-stacd = '5'.
        ELSEIF ls_status-gonderimdurumu = 3.
          rs_status-stacd = '6'.
        ELSEIF ls_status-gonderimdurumu = 4.
          IF ls_status-yanitdurumu = 0.
            rs_status-stacd = '7'.
          ELSE.
            rs_status-stacd = 'X'.
          ENDIF.
        ENDIF.
      ENDIF.

      IF ls_status-aciklama IS NOT INITIAL.
        rs_status-staex = ls_status-aciklama.
      ELSE.
        rs_status-staex = ls_status-gonderimcevabidetayi.
      ENDIF.

      CASE ls_status-yanitdurumu.
        WHEN '-1'.
          rs_status-resst = 'X'.
        WHEN OTHERS.
          rs_status-resst = ls_status-yanitdurumu.
      ENDCASE.
      IF ls_status-yenidengonderilebilirmi = 'true'.
        rs_status-rsend = abap_true.
      ELSE.
        rs_status-radsc = abap_false.
      ENDIF.
      rs_status-radsc = ls_status-gonderimcevabikodu.
*    rs_status-raded = ls_status-gtbfiiliihracattarihi.
      SPLIT ls_status-gtbfiiliihracattarihi AT '-' INTO lv_year lv_month lv_day.
      IF lv_day CO ' 0123456789' AND lv_month CO ' 0123456789' AND lv_year CO ' 0123456789'.
        rs_status-raded(4)   = lv_year.
        rs_status-raded+4(2) = lv_month.
        rs_status-raded+6(2) = lv_day.
      ENDIF.
      rs_status-cedrn = ls_status-gtbgcbtescilno.
      rs_status-radrn = ls_status-gtbrefno.
      rs_status-invno = ls_status-belgeno.
      rs_status-invui = ls_status-ettn.
      rs_status-invqi = ls_status-ettn.

      "gkadioglu
      IF ls_status-yanitdetayi IS NOT INITIAL.
        rs_status-yanit_detay = ls_status-yanitdetayi.
      ENDIF.

      "gkadioglu ulasti mi?
      IF ls_status-ulastimi EQ 'true'.
        rs_status-reached = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_get_status.
    TYPES: BEGIN OF ty_status,
             aciklama                TYPE string,
             alimtarihi              TYPE string,
             belgeno                 TYPE string,
             durum                   TYPE string,
             ettn                    TYPE string,
             gonderimcevabidetayi    TYPE string,
             gonderimcevabikodu      TYPE string,
             gonderimdurumu          TYPE string,
             gonderimtarihi          TYPE string,
             olusturulmatarihi       TYPE string,
             yanitdetayi             TYPE string,
             yanitdurumu             TYPE string,
             ulastimi                TYPE string,
             yenidengonderilebilirmi TYPE string,
             yerelbelgeoid           TYPE string,
             gtbfiiliihracattarihi   TYPE string,
             gtbgcbtescilno          TYPE string,
             gtbrefno                TYPE string,
             kepdurum                TYPE string,
           END OF ty_status.
    DATA: lv_request_xml      TYPE string,
          lv_response_xml     TYPE string,
          lt_xml_table        TYPE TABLE OF smum_xmltb,
          ls_xml_line         TYPE smum_xmltb,
          ls_status           TYPE ty_status,
          lv_docii            TYPE string,
          lv_doctype          TYPE string,
          ls_document_numbers TYPE /itetr/com_s_document_numbers.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    IF is_document_numbers-docii IS INITIAL.
      lv_doctype = 'YEREL'.
      lv_docii   = is_document_numbers-docui.
    ELSE.
      lv_doctype = 'OID'.
      lv_docii   = is_document_numbers-docii.
    ENDIF.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
            '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
            '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:gidenBelgeDurumSorgulaExt>'
           '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '<parametreler>'
              '<belgeNo>' lv_docii '</belgeNo>'
              '<belgeNoTipi>' lv_doctype '</belgeNoTipi>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<donusTipiVersiyon>6.0</donusTipiVersiyon>'
           '</parametreler>'
        '</ser:gidenBelgeDurumSorgulaExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    LOOP AT lt_xml_table INTO ls_xml_line.
      TRANSLATE ls_xml_line-cname TO UPPER CASE.
      ASSIGN COMPONENT ls_xml_line-cname OF STRUCTURE ls_status TO <lv_return_field>.
      IF sy-subrc = 0.
        <lv_return_field> = ls_xml_line-cvalue.
      ENDIF.
    ENDLOOP.

    IF  lt_xml_table[] IS NOT INITIAL."gkadioglu

      IF is_document_numbers-docii IS INITIAL AND ls_status-yerelbelgeoid IS NOT INITIAL.
        CLEAR ls_document_numbers.
        ls_document_numbers-docii = ls_status-yerelbelgeoid.
        rs_status = outgoing_invoice_get_status( is_document_numbers = ls_document_numbers ).
        rs_status-invii = ls_status-yerelbelgeoid.
        EXIT.
      ENDIF.

***      IF ls_status-durum = 1 OR ls_status-durum = 2.
***        rs_status-stacd = ls_status-durum.
***      ELSEIF ls_status-gonderimdurumu = 0.
***        rs_status-stacd = '3'.
***      ELSEIF ls_status-gonderimdurumu = -1 OR ls_status-gonderimdurumu = 1.
***        rs_status-stacd = '4'.
***      ELSEIF ls_status-gonderimdurumu = 2.
***        rs_status-stacd = '5'.
***      ELSEIF ls_status-gonderimdurumu = 3.
***        rs_status-stacd = '6'.
***      ELSEIF ls_status-gonderimdurumu = 4.
***        IF ls_status-yanitdurumu = 0.
***          rs_status-stacd = '7'.
***        ELSE.
***          rs_status-stacd = 'X'.
***        ENDIF.
***      ENDIF.

      "e-finans
      " 1 durum kodu belge gönderildi ama kuyrukta
      " 2 işlendi ama validasyon hatası aldı tekrar belge ubl i gönder
      " 3 belge validasyondan geçti ve durumunu sorgula

      IF ls_status-durum = 1 OR ls_status-durum = 2.
        rs_status-stacd = ls_status-durum.
      ENDIF.

      IF ls_status-durum = 3.
        IF ls_status-gonderimdurumu = -1 OR ls_status-gonderimdurumu = 1.
          rs_status-stacd = '4'.
        ELSEIF ls_status-gonderimdurumu = 2.
          rs_status-stacd = '5'.
        ELSEIF ls_status-gonderimdurumu = 3.
          rs_status-stacd = '6'.
        ELSEIF ls_status-gonderimdurumu = 4.
          IF ls_status-yanitdurumu = 0.
            rs_status-stacd = '7'.
          ELSE.
            rs_status-stacd = 'X'.
          ENDIF.
        ENDIF.
      ENDIF.

      IF ls_status-aciklama IS NOT INITIAL.
        rs_status-staex = ls_status-aciklama.
      ELSE.
        rs_status-staex = ls_status-gonderimcevabidetayi.
      ENDIF.

      CASE ls_status-yanitdurumu.
        WHEN '-1'.
          rs_status-resst = 'X'.
        WHEN '-2'.
          rs_status-resst = '0'.
        WHEN OTHERS.
          rs_status-resst = ls_status-yanitdurumu.
      ENDCASE.
      "Kep Reddi
      IF ls_status-kepdurum EQ '1'.
        rs_status-resst = 'K'.
      ENDIF.

      IF ls_status-yenidengonderilebilirmi = 'true'.
        rs_status-rsend = abap_true.
      ELSE.
        rs_status-radsc = abap_false.
      ENDIF.
      rs_status-radsc = ls_status-gonderimcevabikodu.
      rs_status-raded = ls_status-gtbfiiliihracattarihi.
      rs_status-cedrn = ls_status-gtbgcbtescilno.
      rs_status-radrn = ls_status-gtbrefno.
      rs_status-invno = ls_status-belgeno.
      rs_status-invui = ls_status-ettn.
      rs_status-invqi = ls_status-ettn.
      IF rs_status-radsc = '1195'.
        CLEAR  rs_status-stacd.
      ENDIF.

      "gkadioglu
      IF ls_status-yanitdetayi IS NOT INITIAL.
        rs_status-yanit_detay = ls_status-yanitdetayi.
      ENDIF.

      "ulasti mi?
      IF ls_status-ulastimi EQ 'true'.
        rs_status-reached = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD outgoing_invoice_preview.
    DATA: lv_request_xml    TYPE string,
          lv_response_xml   TYPE string,
          lt_xml_table      TYPE TABLE OF smum_xmltb,
          ls_xml_line       TYPE smum_xmltb,
          lv_content        TYPE string,
          lv_zipped_file    TYPE xstring,
          lv_invoice_base64 TYPE string.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = iv_ubl_xstring
      IMPORTING
        output = lv_invoice_base64.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
      '<ser:ublOnizleme>'
         '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
         '<veri>' lv_invoice_base64 '</veri>'
     '<belgeFormati>' iv_content_type '</belgeFormati>'
         '<belgeTuru>FATURA</belgeTuru>'
      '</ser:ublOnizleme>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).

    LOOP AT lt_xml_table INTO ls_xml_line.
      CASE ls_xml_line-cname.
        WHEN 'return'.
          CONCATENATE lv_content
              ls_xml_line-cvalue
              INTO lv_content.
      ENDCASE.
    ENDLOOP.

    IF lv_content IS NOT INITIAL.
      rv_invoice_data  = /itetr/cl_regulative_common=>decode_base64( iv_input = lv_content ).
    ENDIF.
  ENDMETHOD.


  method OUTGOING_INVOICE_RESPONSE.
  endmethod.


  METHOD outgoing_invoice_send.
    DATA: lv_invoice_base64   TYPE string,
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
          lx_exception        TYPE REF TO /itetr/cx_regulative_exception.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
      EXPORTING
        input  = iv_ubl_xstring
      IMPORTING
        output = lv_invoice_base64.

    READ TABLE mt_custom_parameters INTO ls_custom_parameter WITH TABLE KEY by_cuspa COMPONENTS cuspa = mc_erpcode_parameter.

    IF iv_receiver_alias IS NOT INITIAL.
      CONCATENATE '<alanEtiket>' iv_receiver_alias '</alanEtiket>' INTO lv_alliass.
    ENDIF.

    lv_document_uuid = iv_document_uuid.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:belgeGonderExt>'
           '<parametreler>'
              lv_alliass
              '<belgeHash>' iv_ubl_hash '</belgeHash>'
              '<belgeNo>' lv_document_uuid '</belgeNo>'
              '<belgeVersiyon>2.1</belgeVersiyon>'
              '<belgeTuru>FATURA_UBL</belgeTuru>'
              '<mimeType>application/xml</mimeType>'
              '<veri>' lv_invoice_base64 '</veri>'
              '<donusTipiVersiyon>2.0</donusTipiVersiyon>'
              '<erpKodu>' ls_custom_parameter-value '</erpKodu>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
           '</parametreler>'
        '</ser:belgeGonderExt>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).
    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
    READ TABLE lt_xml_table INTO ls_xml_line WITH KEY cname = 'belgeOid'.
    IF sy-subrc = 0.
      ev_integrator_uuid = ls_xml_line-cvalue.
    ELSE.
      lv_message = TEXT-001.
      lx_exception = /itetr/cx_regulative_exception=>create_by_message( iv_msgno = '004'
                                                                        iv_msgv1 = lv_message(50)
                                                                        iv_msgv2 = lv_message+50(50)
                                                                        iv_msgv3 = lv_message+100(50)
                                                                        iv_msgv4 = lv_message+150(50) ).
      RAISE EXCEPTION lx_exception.
    ENDIF.

  ENDMETHOD.


  METHOD outgoing_invoice_send_again.
    DATA: lv_request_xml  TYPE string,
          lv_response_xml TYPE string,
          lt_xml_table    TYPE TABLE OF smum_xmltb,
          ls_xml_line     TYPE smum_xmltb,
          lv_content      TYPE string,
          lv_zipped_file  TYPE xstring.

    FIELD-SYMBOLS: <lv_return_field> TYPE any.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
                '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
                '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
       '<ser:belgeleriTekrarGonder>'
*           '<parametreler>'
              '<ettn>' iv_document_uuid_char '</ettn>'
              '<belgeTuru>FATURA</belgeTuru>'
              '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
*           '</parametreler>'
        '</ser:belgeleriTekrarGonder>'
      '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    lv_response_xml = run_service( lv_request_xml ).

    lt_xml_table = /itetr/cl_regulative_common=>parse_xml_as_table( lv_response_xml ).
  ENDMETHOD.


  METHOD set_incoming_invoice_received.
    DATA: lv_request_xml TYPE string.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.connector.uut.cs.com.tr/">'
      '<soapenv:Header>'
        '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'
          '<wsse:UsernameToken>'
              '<wsse:Username>' ms_company_parameters-wsusr '</wsse:Username>'
              '<wsse:Password>' ms_company_parameters-wspwd '</wsse:Password>'
          '</wsse:UsernameToken>'
        '</wsse:Security>'
      '</soapenv:Header>'
       '<soapenv:Body>'
          '<ser:belgelerAlindi>'
             '<belgeTuru>FATURA</belgeTuru>'
             '<ettn>' iv_document_uuid '</ettn>'
             '<vergiTcKimlikNo>' mv_company_taxid '</vergiTcKimlikNo>'
          '</ser:belgelerAlindi>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'
    INTO lv_request_xml.
*    mv_request_url = '/efatura/ws/connectorService'.
    run_service( lv_request_xml ).
  ENDMETHOD.
ENDCLASS.