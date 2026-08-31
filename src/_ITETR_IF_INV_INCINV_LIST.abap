interface /ITETR/IF_INV_INCINV_LIST
  public .


  types:
    /ITETR/COM_E_STAIC type C length 000004 .
  types:
    /ITETR/COM_E_DOCNO type C length 000016 .
  types:
    /ITETR/COM_E_DUICH type C length 000036 .
  types:
    /ITETR/COM_E_DOCUI type X length 000016 .
  types:
    LIFNR type C length 000010 .
  types:
    KUNNR type C length 000010 .
  types:
    /ITETR/INV_E_TAXID type C length 000011 .
  types:
    /ITETR/INV_E_VKNID type C length 000011 .
  types:
    /ITETR/COM_E_TITLE type C length 000255 .
  types:
    /ITETR/COM_E_DMBTR type P length 7  decimals 000002 .
  types:
    /ITETR/COM_E_WRBTR type P length 9  decimals 000002 .
  types:
    /ITETR/COM_E_FWSTE type P length 7  decimals 000002 .
  types:
    WAERS type C length 000005 .
  types:
    /ITETR/INV_E_PRFID type C length 000020 .
  types:
    /ITETR/INV_E_INVTY type C length 000020 .
  types:
    /ITETR/COM_E_ATTEX type C length 000001 .
  types:
    /ITETR/COM_E_PRINT type C length 000001 .
  types:
    /ITETR/COM_E_APRVD type C length 000001 .
  types:
    /ITETR/COM_E_PROCS type C length 000001 .
  types:
    AWTYP type C length 000005 .
  types:
    BELNR_D type C length 000010 .
  types:
    GJAHR type N length 000004 .
  types:
    /ITETR/COM_E_ARCHV type C length 000001 .
  types:
    /ITETR/INV_E_RESST type C length 000001 .
  types:
    /ITETR/INV_E_RESST_TXT type C length 000060 .
  types:
    /ITETR/COM_E_RADSC type C length 000004 .
  types:
    /ITETR/COM_E_STAEX type C length 000255 .
  types:
    /ITETR/COM_E_LNOTE type C length 000255 .
  types:
    /ITETR/COM_E_LOGIC type C length 000004 .
  types:
    /ITETR/COM_E_IRSNO type C length 000016 .
  types:
    /ITETR/COM_E_ORDERID type C length 000255 .
  types:
    /ITETR/COM_E_WITHHOLDING type P length 7  decimals 000002 .
  types:
    /ITETR/COM_E_ALLOWANCE type P length 7  decimals 000002 .
  types:
    /ITETR/COM_E_DRAFT type C length 000001 .
  types:
    /ITETR/INV_E_STATU type C length 000100 .
  types:
    begin of /ITETR/INV_S_INCINV_DATA,
      STAIC type /ITETR/COM_E_STAIC,
      INVNO type /ITETR/COM_E_DOCNO,
      INVUI type /ITETR/COM_E_DUICH,
      DOCUI type /ITETR/COM_E_DOCUI,
      LIFNR type LIFNR,
      KUNNR type KUNNR,
      TAXID type /ITETR/INV_E_TAXID,
      VKNID type /ITETR/INV_E_VKNID,
      TITLE type /ITETR/COM_E_TITLE,
      BLDAT type DATS,
      RECDT type DATS,
      RDAYS type INT4,
      DMBTR type /ITETR/COM_E_DMBTR,
      WRBTR type /ITETR/COM_E_WRBTR,
      FWSTE type /ITETR/COM_E_FWSTE,
      WAERS type WAERS,
      PRFID type /ITETR/INV_E_PRFID,
      INVTY type /ITETR/INV_E_INVTY,
      ATTEX type /ITETR/COM_E_ATTEX,
      PRNTD type /ITETR/COM_E_PRINT,
      APRVD type /ITETR/COM_E_APRVD,
      PROCS type /ITETR/COM_E_PROCS,
      AWTYP type AWTYP,
      BELNR type BELNR_D,
      GJAHR type GJAHR,
      ARCHV type /ITETR/COM_E_ARCHV,
      RESST type /ITETR/INV_E_RESST,
      RESST_TXT type /ITETR/INV_E_RESST_TXT,
      RADSC type /ITETR/COM_E_RADSC,
      STAEX type /ITETR/COM_E_STAEX,
      STATS type /ITETR/COM_E_STAEX,
      LNOTE type /ITETR/COM_E_LNOTE,
      LOGIC type /ITETR/COM_E_LOGIC,
      DESPID type /ITETR/COM_E_IRSNO,
      ORDERID type /ITETR/COM_E_ORDERID,
      WITHHOLDING type /ITETR/COM_E_WITHHOLDING,
      ALLOWANCE type /ITETR/COM_E_ALLOWANCE,
      DRAFT type /ITETR/COM_E_DRAFT,
      STATU type /ITETR/INV_E_STATU,
      STATU_DATE type DATS,
    end of /ITETR/INV_S_INCINV_DATA .
  types:
    /ITETR/INV_TT_INCINV_DATA      type standard table of /ITETR/INV_S_INCINV_DATA       with non-unique default key .
  types:
    BUKRS type C length 000004 .
  types:
    DDSIGN type C length 000001 .
  types:
    DDOPTION type C length 000002 .
  types:
    XFELD type C length 000001 .
  types:
    begin of /ITETR/COM_S_XFELD_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type XFELD,
      HIGH type XFELD,
    end of /ITETR/COM_S_XFELD_RANGE .
  types:
    /ITETR/COM_TT_XFELD_RANGE      type standard table of /ITETR/COM_S_XFELD_RANGE       with non-unique default key .
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
    begin of /ITETR/COM_S_DOCNO_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/COM_E_DOCNO,
      HIGH type /ITETR/COM_E_DOCNO,
    end of /ITETR/COM_S_DOCNO_RANGE .
  types:
    /ITETR/COM_TT_DOCNO_RANGE      type standard table of /ITETR/COM_S_DOCNO_RANGE       with non-unique default key .
  types:
    begin of /ITETR/INV_S_INVTY_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/INV_E_INVTY,
      HIGH type /ITETR/INV_E_INVTY,
    end of /ITETR/INV_S_INVTY_RANGE .
  types:
    /ITETR/INV_TT_INVTY_RANGE      type standard table of /ITETR/INV_S_INVTY_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_DUICH_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/COM_E_DUICH,
      HIGH type /ITETR/COM_E_DUICH,
    end of /ITETR/COM_S_DUICH_RANGE .
  types:
    /ITETR/COM_TT_DUICH_RANGE      type standard table of /ITETR/COM_S_DUICH_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_KUNNR_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type KUNNR,
      HIGH type KUNNR,
    end of /ITETR/COM_S_KUNNR_RANGE .
  types:
    /ITETR/COM_TT_KUNNR_RANGE      type standard table of /ITETR/COM_S_KUNNR_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_LIFNR_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type LIFNR,
      HIGH type LIFNR,
    end of /ITETR/COM_S_LIFNR_RANGE .
  types:
    /ITETR/COM_TT_LIFNR_RANGE      type standard table of /ITETR/COM_S_LIFNR_RANGE       with non-unique default key .
  types:
    begin of /ITETR/INV_S_PRFID_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/INV_E_PRFID,
      HIGH type /ITETR/INV_E_PRFID,
    end of /ITETR/INV_S_PRFID_RANGE .
  types:
    /ITETR/INV_TT_PRFID_RANGE      type standard table of /ITETR/INV_S_PRFID_RANGE       with non-unique default key .
  types:
    begin of /ITETR/INV_S_RESST_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/INV_E_RESST,
      HIGH type /ITETR/INV_E_RESST,
    end of /ITETR/INV_S_RESST_RANGE .
  types:
    /ITETR/INV_TT_RESST_RANGE      type standard table of /ITETR/INV_S_RESST_RANGE       with non-unique default key .
  types:
    STCD2 type C length 000011 .
  types:
    begin of /ITETR/COM_S_TAXID_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type STCD2,
      HIGH type STCD2,
    end of /ITETR/COM_S_TAXID_RANGE .
  types:
    /ITETR/COM_TT_TAXID_RANGE      type standard table of /ITETR/COM_S_TAXID_RANGE       with non-unique default key .
endinterface.