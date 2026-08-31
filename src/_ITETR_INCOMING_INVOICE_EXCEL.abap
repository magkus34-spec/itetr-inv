*&---------------------------------------------------------------------*
*& Report /ITTR/IFT_IMPORT_EXCEL
*&---------------------------------------------------------------------*
*& Osman Umut Şişmanoğlu
*&---------------------------------------------------------------------*
REPORT /itetr/incoming_invoice_excel MESSAGE-ID /itetr/regulative.

INCLUDE /itetr/incoming_inv_excel_top.
INCLUDE /itetr/incoming_inv_excel_c01.
INCLUDE /itetr/incoming_inv_excel_mdl.

INITIALIZATION.
  go_main_controller = lcl_main_controller=>get_instance( ).
  go_main_controller->selscr_init( ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.
  go_main_controller->f4_filename( ).

AT SELECTION-SCREEN.
  go_main_controller->at_selection_screen( ).

START-OF-SELECTION.
  go_main_controller->upload_data( ).

END-OF-SELECTION.
  go_main_controller->display_data( ).