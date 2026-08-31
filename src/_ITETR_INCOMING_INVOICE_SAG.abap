*&---------------------------------------------------------------------*
*& Report /itetr/outgoing_invoice_sag
*&---------------------------------------------------------------------*
*& MUstafa Sadık
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice_sag.

TABLES: /itetr/inv_icinv.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_bukrs FOR /itetr/inv_icinv-bukrs,
                  s_invno FOR /itetr/inv_icinv-invno,
                  s_gjahr FOR /itetr/inv_icinv-gjahr.
*                s_awtyp FOR /itetr/inv_icinv-awtyp.
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
    FROM /itetr/inv_icinv                               "#EC CI_NOFIELD
    INTO TABLE gt_invoices
    WHERE bukrs IN s_bukrs
      AND invno IN s_invno
      AND gjahr IN s_gjahr
*      AND resst IN ( '1','2' )
*      AND radsc IN ( '1215' ,'1195' )
    .
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

    CALL FUNCTION '/ITETR/INV_INCINV_SEND_AGAIN'
      EXPORTING
        iv_company_code = gs_company-bukrs
        it_documents    = gt_resendable_invoices.
  ENDLOOP.