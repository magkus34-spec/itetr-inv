
*&---------------------------------------------------------------------*
*& Report /ITETR/INCOMING_INVOICE_GET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice_get.

PARAMETERS: p_bukrs TYPE bukrs OBLIGATORY,
            p_begda TYPE begda DEFAULT sy-datum,
            p_endda TYPE endda DEFAULT sy-datum.
DATA: gs_return TYPE bapiret2,
      gt_list   TYPE /itetr/inv_tt_icinv,
      gv_count  TYPE i,
      gv_title  TYPE lvc_title,
      gs_layout TYPE lvc_s_layo.

INITIALIZATION.
  GET PARAMETER ID 'BUK' FIELD p_bukrs.

START-OF-SELECTION.
  CALL FUNCTION '/ITETR/INV_INCINV_GET_LIST'
    EXPORTING
      iv_company   = p_bukrs
      iv_date_from = p_begda
      iv_date_to   = p_endda
    IMPORTING
      es_return    = gs_return
      et_list      = gt_list.

END-OF-SELECTION.
  IF gs_return-type CA 'AEX'.
    IF sy-batch EQ abap_false.
      MESSAGE ID gs_return-id
              TYPE gs_return-type
              NUMBER gs_return-number
              WITH gs_return-message_v1
                   gs_return-message_v2
                   gs_return-message_v3
                   gs_return-message_v4.
    ELSE.
      WRITE:/ 'HATA:'.
      WRITE:/  gs_return-message_v1.
      WRITE:/  gs_return-message_v2.
      WRITE:/  gs_return-message_v3.
      WRITE:/  gs_return-message_v4.
    ENDIF.
  ELSE.
    DESCRIBE TABLE gt_list LINES gv_count.
    WRITE gv_count TO gv_title LEFT-JUSTIFIED.
    CONCATENATE TEXT-001 ` ` gv_title INTO gv_title.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-sel_mode = 'A'.
    gs_layout-zebra = abap_true.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_structure_name = '/ITETR/INV_ICINV'
        i_grid_title     = gv_title
        is_layout_lvc    = gs_layout
      TABLES
        t_outtab         = gt_list
      EXCEPTIONS
        program_error    = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.