*&---------------------------------------------------------------------*
*& Report /itetr/outgoing_invoice_usi
*&---------------------------------------------------------------------*
*& Mustafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoice_usi MESSAGE-ID /itetr/regulative.

TABLES: vbrk, rbkp, bkpf.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_bukrs TYPE bukrs OBLIGATORY.
SELECTION-SCREEN SKIP.
PARAMETERS: p_vbrk RADIOBUTTON GROUP g1 USER-COMMAND dummy,
            p_rmrp RADIOBUTTON GROUP g1,
            p_bkpf RADIOBUTTON GROUP g1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: s_vbeln FOR vbrk-vbeln MODIF ID sd,
                s_fkdat FOR vbrk-fkdat MODIF ID sd,
                s_fkart FOR vbrk-fkart MODIF ID sd.

SELECT-OPTIONS: s_belnm FOR rbkp-belnr MODIF ID mm,
                s_gjahm FOR rbkp-gjahr MODIF ID mm,
                s_bldam FOR rbkp-bldat MODIF ID mm,
                s_blarm FOR rbkp-blart MODIF ID mm.

SELECT-OPTIONS: s_belnf FOR bkpf-belnr MODIF ID fi,
                s_gjahf FOR bkpf-gjahr MODIF ID fi,
                s_bldaf FOR bkpf-bldat MODIF ID fi,
                s_blarf FOR bkpf-blart MODIF ID fi.
SELECTION-SCREEN END OF BLOCK b2.

TYPES BEGIN OF ty_invoices.
TYPES awtyp TYPE bkpf-awtyp.
TYPES belnr TYPE bkpf-belnr.
TYPES bldat TYPE bkpf-bldat.
TYPES gjahr TYPE bkpf-gjahr.
TYPES END OF ty_invoices.

DATA gt_documents TYPE TABLE OF /itetr/inv_oginv.
DATA gt_invoices TYPE TABLE OF ty_invoices.

INITIALIZATION.
  GET PARAMETER ID 'BUK' FIELD p_bukrs.
  p_vbrk = abap_true.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'SD'.
        screen-active = COND #( WHEN p_vbrk = abap_true THEN 1 ELSE 0 ).
        MODIFY SCREEN.
      WHEN 'MM'.
        screen-active = COND #( WHEN p_rmrp = abap_true THEN 1 ELSE 0 ).
        MODIFY SCREEN.
      WHEN 'FI'.
        screen-active = COND #( WHEN p_bkpf = abap_true THEN 1 ELSE 0 ).
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.

START-OF-SELECTION.
  PERFORM get_invoices.

END-OF-SELECTION.
  PERFORM display_invoices.

FORM get_invoices.
  DATA ls_document TYPE /itetr/inv_oginv.
  FIELD-SYMBOLS <ls_invoice> TYPE ty_invoices.
  CASE abap_true.
    WHEN p_bkpf.
      SELECT awtyp
             belnr
             bldat
             gjahr
        FROM bkpf
        INTO TABLE gt_invoices
        WHERE bukrs EQ p_bukrs
          AND belnr IN s_belnf
          AND gjahr IN s_gjahf
          AND blart IN s_blarf
          AND bldat IN s_bldaf
          AND awtyp IN ('BKPF','BKPFF','REACI', 'IDOC')
          AND xreversal EQ space.
    WHEN p_vbrk.
      SELECT vbeln AS belnr
             fkdat AS bldat
        FROM vbrk
        INTO CORRESPONDING FIELDS OF TABLE gt_invoices
        WHERE vbeln IN s_vbeln
          AND fkdat IN s_fkdat
          AND fkart IN s_fkart
          AND bukrs EQ p_bukrs
          AND fksto EQ space
          AND sfakn EQ space.
    WHEN p_rmrp.
      SELECT belnr
             bldat
             gjahr
        FROM rbkp
        INTO CORRESPONDING FIELDS OF TABLE gt_invoices
        WHERE bukrs EQ p_bukrs
          AND belnr IN s_belnm
          AND gjahr IN s_gjahm
          AND blart IN s_blarm
          AND bldat IN s_bldam
          AND stblg EQ space.
  ENDCASE.
  CHECK sy-subrc IS INITIAL.
  LOOP AT gt_invoices ASSIGNING <ls_invoice>.
    CLEAR ls_document.
    IF <ls_invoice>-awtyp IS INITIAL.
      CASE abap_true.
        WHEN p_vbrk.
          <ls_invoice>-awtyp = 'VBRK'.
        WHEN p_rmrp."staskan 24.12
          <ls_invoice>-awtyp = 'RMRP'.
      ENDCASE.
    ENDIF.
    IF <ls_invoice>-gjahr IS INITIAL.
      <ls_invoice>-gjahr = <ls_invoice>-bldat(4).
    ENDIF.
    CALL FUNCTION '/ITETR/INV_INVOICE_CHECK_SAVE'
      EXPORTING
        iv_awtyp    = <ls_invoice>-awtyp
        iv_bukrs    = p_bukrs
        iv_belnr    = <ls_invoice>-belnr
        iv_gjahr    = <ls_invoice>-gjahr
      IMPORTING
        es_document = ls_document.
    CHECK ls_document IS NOT INITIAL.
    APPEND ls_document TO gt_documents.
  ENDLOOP.
ENDFORM.

FORM display_invoices.
  DATA ls_layout TYPE lvc_s_layo.
  DATA lv_title TYPE lvc_title.
  DATA lv_count TYPE i.

  IF gt_documents IS NOT INITIAL.
    DESCRIBE TABLE gt_documents LINES lv_count.
    WRITE lv_count TO lv_title LEFT-JUSTIFIED.
    CONCATENATE TEXT-003 lv_title INTO lv_title.
    ls_layout-cwidth_opt = abap_true.
    ls_layout-sel_mode = 'A'.
    ls_layout-zebra = abap_true.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_structure_name = '/ITETR/INV_OGINV'
        is_layout_lvc    = ls_layout
        i_grid_title     = lv_title
      TABLES
        t_outtab         = gt_documents
      EXCEPTIONS
        program_error    = 1
        OTHERS           = 2.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid
              TYPE 'A'
              NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ELSE.
    MESSAGE s011 DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.