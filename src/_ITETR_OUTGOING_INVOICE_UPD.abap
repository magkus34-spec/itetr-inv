*&---------------------------------------------------------------------*
*& Report /itetr/outgoing_invoice_upd
*&---------------------------------------------------------------------*
*& Mustafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoice_upd MESSAGE-ID /itetr/regulative.

TABLES: /itetr/inv_oginv.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bukrs FOR /itetr/inv_oginv-bukrs,
                  s_belnr FOR /itetr/inv_oginv-belnr,
                  s_gjahr FOR /itetr/inv_oginv-gjahr,
                  s_awtyp FOR /itetr/inv_oginv-awtyp,
                  s_snddt FOR /itetr/inv_oginv-snddt,
                  s_radsc FOR /itetr/inv_oginv-radsc,
                  s_stacd FOR /itetr/inv_oginv-stacd,
                  s_rched FOR /itetr/inv_oginv-reached."gkadioglu
SELECTION-SCREEN END OF BLOCK b1.

DATA gt_invoices TYPE TABLE OF /itetr/com_s_document_numbers.
DATA gt_export   TYPE TABLE OF /itetr/com_s_document_numbers.
DATA gs_invoice  TYPE /itetr/com_s_document_numbers.
DATA gs_export   TYPE /itetr/com_s_document_numbers.




DATA : ls_stacd LIKE LINE OF s_stacd.

INITIALIZATION.
  ls_stacd-sign = 'E'.
  ls_stacd-option = 'EQ'.
  APPEND ls_stacd TO s_stacd.
  ls_stacd-low  = '2'.
  APPEND ls_stacd TO s_stacd.
  ls_stacd-low  = 'X'.
  APPEND ls_stacd TO s_stacd.



START-OF-SELECTION.
  SELECT docui
         invii AS docii
         invui AS duich
         invno AS docno
         envui
    FROM /itetr/inv_oginv            "#EC CI_NOFIELD
    INTO TABLE gt_invoices
    WHERE bukrs IN s_bukrs
      AND belnr IN s_belnr
      AND gjahr IN s_gjahr
      AND awtyp IN s_awtyp
      AND snddt IN s_snddt
      AND radsc IN s_radsc
      AND stacd IN s_stacd
      AND reached IN s_rched.
*      AND stacd NOT IN ('','2','X').

  SELECT docui
         invii AS docii
         invui AS duich
         invno AS docno
         envui
    FROM /itetr/inv_oginv          "#EC CI_NOFIELD
    INTO TABLE gt_export
    WHERE bukrs IN s_bukrs
      AND belnr IN s_belnr
      AND gjahr IN s_gjahr
      AND awtyp IN s_awtyp
      AND prfid EQ 'IHRACAT'
      AND resst NOT IN ('1', 'R')
      AND raded EQ '00000000'.
***      AND reached IN s_rched."gkadioglu.

END-OF-SELECTION.

  IF gt_invoices IS NOT INITIAL.
    LOOP AT gt_invoices INTO gs_invoice.
      CALL FUNCTION '/ITETR/INV_OUTINV_UPDATE_STA'
        EXPORTING
          iv_document_uid = gs_invoice-docui.
    ENDLOOP.
  ENDIF.
  IF gt_export IS NOT INITIAL.
    LOOP AT gt_export INTO gs_export.
      CALL FUNCTION '/ITETR/INV_OUTINV_UPDATE_EXP'
        EXPORTING
          iv_document_uid = gs_export-docui.
    ENDLOOP.
  ENDIF.
  IF gt_invoices IS INITIAL AND gt_export IS INITIAL.
    MESSAGE s011 DISPLAY LIKE 'E'.
  ELSE.
    MESSAGE s003.
  ENDIF.