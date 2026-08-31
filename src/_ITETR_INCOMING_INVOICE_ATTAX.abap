*&---------------------------------------------------------------------*
*& Report /ITETR/INCOMING_INVOICE_ATTAX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice_attax.

DATA: BEGIN OF ls_icinv,
        docui TYPE /itetr/com_e_docui,
        bukrs TYPE bukrs,
        awtyp TYPE awtyp,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
      END OF ls_icinv,
      lt_icinv      LIKE TABLE OF ls_icinv,
      lv_content    TYPE xstring,
      lt_solix      TYPE solix_tab,
      lv_objkey     TYPE swo_typeid,
      lv_objtype    TYPE swo_objtyp,
      lv_folderid   TYPE soodk,
      ls_docdata    TYPE sodocchgi1,
      ls_docinfo    TYPE sofolenti1,
      lt_objhdr     TYPE TABLE OF solisti1,
      ls_objhdr     TYPE solisti1,
      ls_bizojb     TYPE borident,
      ls_attachment TYPE borident.

SELECT docui bukrs awtyp belnr gjahr
  FROM /itetr/inv_icinv
  INTO TABLE lt_icinv
 WHERE belnr ne space
   AND attax EQ space.

LOOP AT lt_icinv INTO ls_icinv.
  REFRESH: lt_objhdr, lt_solix.
  CLEAR: ls_docinfo.

  CALL FUNCTION '/ITETR/INV_INCINV_DOWNLOAD'
    EXPORTING
      iv_document_uid = ls_icinv-docui
      iv_content_type = /itetr/cl_regulative_archive=>mc_content_types-pdf
    IMPORTING
      ev_document     = lv_content.
  CHECK lv_content IS NOT INITIAL.

  cl_bcs_convert=>xstring_to_solix(
    EXPORTING
      iv_xstring = lv_content
    RECEIVING
      et_solix   = lt_solix
  ).

  CASE ls_icinv-awtyp.
    WHEN 'VBRK'.
      lv_objkey  = ls_icinv-belnr.
      lv_objtype = ls_icinv-awtyp.
    WHEN 'RMRP'.
      CONCATENATE ls_icinv-belnr ls_icinv-gjahr INTO lv_objkey.
      lv_objtype = 'BUS2081'.
    WHEN 'BKPF' OR 'BKPFF' OR 'REACI'.
      CONCATENATE ls_icinv-bukrs ls_icinv-belnr ls_icinv-gjahr INTO lv_objkey.
      lv_objtype = 'BKPF'.
  ENDCASE.

  CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
    EXPORTING
      region                = 'B'
    IMPORTING
      folder_id             = lv_folderid
    EXCEPTIONS
      communication_failure = 1
      owner_not_exist       = 2
      system_failure        = 3
      x_error               = 4
      OTHERS                = 5.
  CHECK sy-subrc EQ 0.

  ls_docdata-obj_name  = 'MESSAGE'.
  CONCATENATE lv_objkey '.pdf' INTO ls_docdata-obj_descr.
  ls_docdata-obj_langu = sy-langu.

  CONCATENATE '&SO_FILENAME=' ls_docdata-obj_descr INTO ls_objhdr-line.
  APPEND ls_objhdr TO lt_objhdr.
  ls_objhdr-line = '&SO_FORMAT=PDF'.
  APPEND ls_objhdr TO lt_objhdr.

  CALL FUNCTION 'SO_DOCUMENT_INSERT_API1'
    EXPORTING
      folder_id                  = lv_folderid
      document_data              = ls_docdata
      document_type              = 'PDF'
    IMPORTING
      document_info              = ls_docinfo
    TABLES
      object_header              = lt_objhdr
      contents_hex               = lt_solix
    EXCEPTIONS
      folder_not_exist           = 1
      document_type_not_exist    = 2
      operation_no_authorization = 3
      parameter_error            = 4
      x_error                    = 5
      enqueue_error              = 6
      OTHERS                     = 7.
  CHECK sy-subrc EQ 0.

  ls_bizojb-objkey  = lv_objkey.
  ls_bizojb-objtype = lv_objtype.

  ls_attachment-objkey  = ls_docinfo-doc_id.
  ls_attachment-objtype = 'MESSAGE'.

  CALL FUNCTION 'BINARY_RELATION_CREATE'
    EXPORTING
      obj_rolea      = ls_bizojb
      obj_roleb      = ls_attachment
      relationtype   = 'ATTA'
    EXCEPTIONS
      no_model       = 1
      internal_error = 2
      unknown        = 3
      OTHERS         = 4.
  CHECK sy-subrc EQ 0.

  COMMIT WORK AND WAIT.

  UPDATE /itetr/inv_icinv SET attax = 'X' WHERE docui = ls_icinv-docui.
  COMMIT WORK AND WAIT.
ENDLOOP.