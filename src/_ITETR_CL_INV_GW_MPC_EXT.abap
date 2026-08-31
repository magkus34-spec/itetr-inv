class /ITETR/CL_INV_GW_MPC_EXT definition
  public
  inheriting from /ITETR/CL_INV_GW_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /ITETR/CL_INV_GW_MPC_EXT IMPLEMENTATION.


METHOD DEFINE.

  super->define( ).
  DATA: lo_entity   TYPE REF TO /iwbep/if_mgw_odata_entity_typ,
        lo_property TYPE REF TO /iwbep/if_mgw_odata_property.

  lo_entity = model->get_entity_type( iv_entity_name = 'Attachment' ).

  IF lo_entity IS BOUND.
    lo_property = lo_entity->get_property( iv_property_name = 'MimeType' ).
    lo_property->set_as_content_type( ).
  ENDIF.

  " Disable Conversion.
  lo_entity = model->get_entity_type( iv_entity_name = 'IncInvoHeader' ).
  lo_property = lo_entity->get_property( iv_property_name = 'Kursf' ).
  lo_property->disable_conversion( ).

  " Disable Conversion.
  lo_entity = model->get_entity_type( iv_entity_name = 'IncInvoInvItems' ).
  lo_property = lo_entity->get_property( iv_property_name = 'Kursf' ).
  lo_property->disable_conversion( ).

ENDMETHOD.
ENDCLASS.