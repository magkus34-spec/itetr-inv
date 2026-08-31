*&---------------------------------------------------------------------*
*& Report /itetr/outgoing_invoice_sag
*&---------------------------------------------------------------------*
*& MUstafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/outgoing_invoice_sag.

TABLES: /itetr/inv_oginv.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_bukrs FOR /itetr/inv_oginv-bukrs,
                s_belnr FOR /itetr/inv_oginv-belnr,
                s_gjahr FOR /itetr/inv_oginv-gjahr,
                s_awtyp FOR /itetr/inv_oginv-awtyp.
SELECTION-SCREEN END OF BLOCK b1.

TYPES BEGIN OF ty_company.
TYPES bukrs TYPE bukrs.
TYPES END OF ty_company.

TYPES BEGIN OF ty_invoices.
TYPES bukrs TYPE bukrs.
TYPES docui TYPE /itetr/com_e_docui.
TYPES END OF ty_invoices.

DATA: gt_resendable_invoices TYPE /itetr/com_tt_document_id,
      gs_resendable_invoice  TYPE /itetr/com_s_document_id,
      gt_invoices            TYPE SORTED TABLE OF ty_invoices WITH UNIQUE KEY bukrs docui,
      gs_invoice             TYPE ty_invoices,
      gt_company             TYPE TABLE OF ty_company,
      gs_company             TYPE ty_company.

START-OF-SELECTION.
  SELECT bukrs docui
    FROM /itetr/inv_oginv          "#EC CI_NOFIELD
    INTO TABLE gt_invoices
    WHERE bukrs IN s_bukrs
      AND belnr IN s_belnr
      AND gjahr IN s_gjahr
      AND awtyp IN s_awtyp
      AND rsend EQ abap_true
      AND revch EQ abap_false.
  CHECK sy-subrc IS INITIAL.

  MOVE-CORRESPONDING gt_invoices TO gt_company.
  LOOP AT gt_company INTO gs_company.
    CLEAR gt_resendable_invoices.
    LOOP AT gt_invoices INTO gs_invoice WHERE bukrs = gs_company-bukrs.
      MOVE-CORRESPONDING gs_invoice TO gs_resendable_invoice.
      APPEND gs_resendable_invoice TO gt_resendable_invoices.
      CLEAR gs_resendable_invoice.
    ENDLOOP.
    CHECK gt_resendable_invoices IS NOT INITIAL.
    CALL FUNCTION '/ITETR/INV_OUTINV_SEND_AGAIN'
      EXPORTING
        iv_company_code = gs_company-bukrs
        it_documents    = gt_resendable_invoices.
  ENDLOOP.