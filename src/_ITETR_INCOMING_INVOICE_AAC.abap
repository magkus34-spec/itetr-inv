*&---------------------------------------------------------------------*
*& Report /ITETR/INCOMING_INVOICE_AAC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice_aac MESSAGE-ID /itetr/regulative.
TABLES: /itetr/inv_icinv.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_bukrs FOR /itetr/inv_icinv-bukrs,
                s_invui FOR /itetr/inv_icinv-invui,
                s_invno FOR /itetr/inv_icinv-invno.
SELECTION-SCREEN END OF BLOCK b1.

TYPES: BEGIN OF ty_invoice,
         docui TYPE /itetr/com_e_docui,
         invno TYPE /itetr/com_e_docno,
       END OF ty_invoice.

DATA: gt_invoices     TYPE TABLE OF ty_invoice,
      gs_invoice      TYPE ty_invoice,
      gs_return       TYPE bapiret2,
      gt_return       TYPE bapiret2_tab,
      gv_error_exists TYPE char1,
      gv_index        TYPE i.

START-OF-SELECTION.
  SELECT docui invno
    FROM /itetr/inv_icinv
    INTO TABLE gt_invoices
    WHERE bukrs IN s_bukrs
      AND invui IN s_invui
      AND invno IN s_invno
      AND ( resst EQ '0' or  resst EQ 'Y' ) ."gkadioglu

END-OF-SELECTION.
  LOOP AT gt_invoices INTO gs_invoice.
    ADD 1 TO gv_index.
    gs_return-row = gv_index.
    gs_return-id = '/ITETR/REGULATIVE'.
    gs_return-type = 'W'.
    gs_return-number = '015'.
    gs_return-message_v1 = gs_invoice-invno.
    APPEND gs_return TO gt_return.
    CLEAR gs_return.

    CALL FUNCTION '/ITETR/INV_INCINV_UPDATE_STAT'
      EXPORTING
        iv_document_uid = gs_invoice-docui
      IMPORTING
        es_return       = gs_return.

    ADD 1 TO gv_index.
    gs_return-row = gv_index.
    APPEND gs_return TO gt_return.
    CLEAR gs_return.
  ENDLOOP.

  gv_error_exists = /itetr/cl_regulative_common=>check_if_error_exists_bapiret2( gt_return ).
  IF gv_error_exists = abap_true.
    /itetr/cl_regulative_common=>show_bapiret2( it_bapiret2 = gt_return ).
  ELSE.
    MESSAGE s003.
  ENDIF.