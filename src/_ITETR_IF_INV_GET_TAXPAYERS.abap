interface /ITETR/IF_INV_GET_TAXPAYERS
  public .


  types:
    STCD2 type C length 000011 .
  types:
    /ITETR/COM_E_ALIAS type C length 000100 .
  types:
    /ITETR/COM_E_TITLE type C length 000255 .
  types ERZET type T .
  types:
    /ITETR/COM_E_DEFAL type C length 000001 .
  types:
    /ITETR/COM_E_TXPTY type C length 000004 .
  types:
    KUNNR type C length 000010 .
  types:
    DEBNAME type C length 000035 .
  types:
    LIFNR type C length 000010 .
  types:
    MD4LI type C length 000035 .
  types:
    begin of /ITETR/INV_TAXPAYERS_LIST,
      TAXID type STCD2,
      ALIASS type /ITETR/COM_E_ALIAS,
      TITLE type /ITETR/COM_E_TITLE,
      REGDT type DATS,
      REGTM type ERZET,
      DEFAL type /ITETR/COM_E_DEFAL,
      TXPTY type /ITETR/COM_E_TXPTY,
      KUNNR type KUNNR,
      KUNNM type DEBNAME,
      LIFNR type LIFNR,
      LIFNM type MD4LI,
    end of /ITETR/INV_TAXPAYERS_LIST .
  types:
    /ITETR/INV_TAXPAYERS_LIST_TAB  type standard table of /ITETR/INV_TAXPAYERS_LIST      with non-unique default key .
  types:
    DDSIGN type C length 000001 .
  types:
    DDOPTION type C length 000002 .
  types:
    begin of /ITETR/COM_S_DATUM_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type DATS,
      HIGH type DATS,
    end of /ITETR/COM_S_DATUM_RANGE .
  types:
    /ITETR/COM_TT_DATUM_RANGE      type standard table of /ITETR/COM_S_DATUM_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_TAXID_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type STCD2,
      HIGH type STCD2,
    end of /ITETR/COM_S_TAXID_RANGE .
  types:
    /ITETR/COM_TT_TAXID_RANGE      type standard table of /ITETR/COM_S_TAXID_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_TITLE_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/COM_E_TITLE,
      HIGH type /ITETR/COM_E_TITLE,
    end of /ITETR/COM_S_TITLE_RANGE .
  types:
    /ITETR/COM_TT_TITLE_RANGE      type standard table of /ITETR/COM_S_TITLE_RANGE       with non-unique default key .
endinterface.