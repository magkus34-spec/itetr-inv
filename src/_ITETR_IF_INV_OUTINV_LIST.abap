interface /ITETR/IF_INV_OUTINV_LIST
  public .


  types:
    /ITETR/COM_E_STAIC type C length 000004 .
  types:
    /ITETR/COM_E_DOCUI type X length 000016 .
  types:
    BELNR_D type C length 000010 .
  types:
    GJAHR type N length 000004 .
  types:
    /ITETR/INV_E_BELNR_FICA type C length 000020 .
  types:
    AWTYP type C length 000005 .
  types:
    /ITETR/INV_E_BELNR type C length 000010 .
  types:
    /ITETR/COM_E_AGENT type C length 000010 .
  types:
    WERKS_D type C length 000004 .
  types:
    GSBER type C length 000004 .
  types:
    KUNNR type C length 000010 .
  types:
    LIFNR type C length 000010 .
  types:
    GPART_KK type C length 000010 .
  types:
    /ITETR/COM_E_TITLE type C length 000255 .
  types:
    STCD2 type C length 000011 .
  types:
    /ITETR/COM_E_ALIAS type C length 000100 .
  types UZEIT type T .
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
    /ITETR/COM_E_TAXTY type C length 000004 .
  types:
    /ITETR/COM_E_TAXEX type C length 000003 .
  types:
    ABEKZ type C length 000001 .
  types:
    CO_STOKZ type C length 000001 .
  types:
    /ITETR/COM_E_APRVD type C length 000001 .
  types:
    /ITETR/COM_E_ARCHV type C length 000001 .
  types:
    /ITETR/COM_E_PRINT type C length 000001 .
  types:
    SO_SND_NAM type C length 000012 .
  types SO_TIM_SD type T .
  types:
    /ITETR/COM_E_DOCII type C length 000050 .
  types:
    /ITETR/INV_E_RPRID type C length 000036 .
  types:
    /ITETR/COM_E_ENVUI type C length 000036 .
  types:
    /ITETR/COM_E_DUICH type C length 000036 .
  types:
    /ITETR/COM_E_DOCNO type C length 000016 .
  types:
    INVOICED type C length 000001 .
  types:
    /ITETR/COM_E_RSEND type C length 000001 .
  types:
    /ITETR/COM_E_STACD type C length 000001 .
  types:
    /ITETR/COM_E_STAEX type C length 000255 .
  types:
    /ITETR/INV_E_RESST type C length 000001 .
  types:
    /ITETR/COM_E_RADSC type C length 000004 .
  types:
    /ITETR/INV_E_CEDRN type C length 000030 .
  types:
    /ITETR/INV_E_RADRN type C length 000030 .
  types:
    /ITETR/COM_E_SERPR type C length 000003 .
  types:
    /ITETR/COM_E_XSLTT type C length 000040 .
  types:
    FLAG_GROUP type C length 000001 .
  types:
    ERNAM type C length 000012 .
  types:
    VTWEG type C length 000002 .
  types:
    VKORG type C length 000004 .
  types:
    VKONT_KK type C length 000012 .
  types:
    /ITETR/INV_E_SRCTAID_KK type C length 000022 .
  types:
    XBLNR_KK type C length 000016 .
  types:
    begin of /ITETR/INV_S_OUTINV_DATA,
      STAIC type /ITETR/COM_E_STAIC,
      DOCUI type /ITETR/COM_E_DOCUI,
      BELNR type BELNR_D,
      GJAHR type GJAHR,
      BELNR_FICA type /ITETR/INV_E_BELNR_FICA,
      AWTYP type AWTYP,
      BELNR_FI type /ITETR/INV_E_BELNR,
      AGENT type /ITETR/COM_E_AGENT,
      WERKS type WERKS_D,
      GSBER type GSBER,
      KUNNR type KUNNR,
      LIFNR type LIFNR,
      GPART type GPART_KK,
      TITLE_SAP type /ITETR/COM_E_TITLE,
      TAXID type STCD2,
      TITLE type /ITETR/COM_E_TITLE,
      ALIASS type /ITETR/COM_E_ALIAS,
      BLDAT type DATS,
      UZEIT type UZEIT,
      WRBTR type /ITETR/COM_E_WRBTR,
      FWSTE type /ITETR/COM_E_FWSTE,
      WAERS type WAERS,
      PRFID type /ITETR/INV_E_PRFID,
      INVTY type /ITETR/INV_E_INVTY,
      TAXTY type /ITETR/COM_E_TAXTY,
      TAXEX type /ITETR/COM_E_TAXEX,
      TEXEX type ABEKZ,
      REVCH type CO_STOKZ,
      REVDT type DATS,
      APRVD type /ITETR/COM_E_APRVD,
      ARCHV type /ITETR/COM_E_ARCHV,
      PRNTD type /ITETR/COM_E_PRINT,
      SNDUS type SO_SND_NAM,
      SNDDT type DATS,
      SNDTM type SO_TIM_SD,
      INVII type /ITETR/COM_E_DOCII,
      RPRID type /ITETR/INV_E_RPRID,
      ENVUI type /ITETR/COM_E_ENVUI,
      INVUI type /ITETR/COM_E_DUICH,
      INVNO type /ITETR/COM_E_DOCNO,
      INIDS type INVOICED,
      RSEND type /ITETR/COM_E_RSEND,
      STACD type /ITETR/COM_E_STACD,
      STAEX type /ITETR/COM_E_STAEX,
      RESST type /ITETR/INV_E_RESST,
      RADSC type /ITETR/COM_E_RADSC,
      RADSC_TXT type /ITETR/COM_E_STAEX,
      RADED type DATS,
      CEDRN type /ITETR/INV_E_CEDRN,
      RADRN type /ITETR/INV_E_RADRN,
      SERPR type /ITETR/COM_E_SERPR,
      XSLTT type /ITETR/COM_E_XSLTT,
      ITMCL type FLAG_GROUP,
      STATS type /ITETR/COM_E_STAEX,
      ERNAM type ERNAM,
      VTWEG type VTWEG,
      VKORG type VKORG,
      VKONT type VKONT_KK,
      SRCTAID type /ITETR/INV_E_SRCTAID_KK,
      XBLNR_FICA type XBLNR_KK,
    end of /ITETR/INV_S_OUTINV_DATA .
  types:
    /ITETR/INV_TT_OUTINV_DATA      type standard table of /ITETR/INV_S_OUTINV_DATA       with non-unique default key .
  types:
    BUKRS type C length 000004 .
  types:
    /ITETR/COM_E_DGSTA type C length 000001 .
  types:
    DDSIGN type C length 000001 .
  types:
    DDOPTION type C length 000002 .
  types:
    begin of /ITETR/COM_S_AGENT_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/COM_E_AGENT,
      HIGH type /ITETR/COM_E_AGENT,
    end of /ITETR/COM_S_AGENT_RANGE .
  types:
    /ITETR/COM_TT_AGENT_RANGE      type standard table of /ITETR/COM_S_AGENT_RANGE       with non-unique default key .
  types:
    /ITETR/COM_E_SELEC type C length 000001 .
  types:
    begin of /ITETR/COM_S_SELEC_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/COM_E_SELEC,
      HIGH type /ITETR/COM_E_SELEC,
    end of /ITETR/COM_S_SELEC_RANGE .
  types:
    /ITETR/COM_TT_SELEC_RANGE      type standard table of /ITETR/COM_S_SELEC_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_AWTYP_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type AWTYP,
      HIGH type AWTYP,
    end of /ITETR/COM_S_AWTYP_RANGE .
  types:
    /ITETR/COM_TT_AWTYP_RANGE      type standard table of /ITETR/COM_S_AWTYP_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_BELNR_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type BELNR_D,
      HIGH type BELNR_D,
    end of /ITETR/COM_S_BELNR_RANGE .
  types:
    /ITETR/COM_TT_BELNR_RANGE      type standard table of /ITETR/COM_S_BELNR_RANGE       with non-unique default key .
  types:
    begin of /ITETR/INV_S_BELNR_FICA_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/INV_E_BELNR_FICA,
      HIGH type /ITETR/INV_E_BELNR_FICA,
    end of /ITETR/INV_S_BELNR_FICA_RANGE .
  types:
    /ITETR/INV_TT_BELNR_FICA_RANGE type standard table of /ITETR/INV_S_BELNR_FICA_RANGE  with non-unique default key .
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
    begin of /ITETR/COM_S_GJAHR_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type GJAHR,
      HIGH type GJAHR,
    end of /ITETR/COM_S_GJAHR_RANGE .
  types:
    /ITETR/COM_TT_GJAHR_RANGE      type standard table of /ITETR/COM_S_GJAHR_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_GSBER_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type GSBER,
      HIGH type GSBER,
    end of /ITETR/COM_S_GSBER_RANGE .
  types:
    /ITETR/COM_TT_GSBER_RANGE      type standard table of /ITETR/COM_S_GSBER_RANGE       with non-unique default key .
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
    XUBNAME type C length 000012 .
  types:
    begin of /ITETR/COM_S_UNAME_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type XUBNAME,
      HIGH type XUBNAME,
    end of /ITETR/COM_S_UNAME_RANGE .
  types:
    /ITETR/COM_TT_UNAME_RANGE      type standard table of /ITETR/COM_S_UNAME_RANGE       with non-unique default key .
  types:
    begin of /ITETR/INV_S_SRCTAID_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type /ITETR/INV_E_SRCTAID_KK,
      HIGH type /ITETR/INV_E_SRCTAID_KK,
    end of /ITETR/INV_S_SRCTAID_RANGE .
  types:
    /ITETR/INV_TT_SRCTAID_RANGE    type standard table of /ITETR/INV_S_SRCTAID_RANGE     with non-unique default key .
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
    begin of /ITETR/INV_S_VKONT_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type VKONT_KK,
      HIGH type VKONT_KK,
    end of /ITETR/INV_S_VKONT_RANGE .
  types:
    /ITETR/INV_TT_VKONT_RANGE      type standard table of /ITETR/INV_S_VKONT_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_VKORG_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type VKORG,
      HIGH type VKORG,
    end of /ITETR/COM_S_VKORG_RANGE .
  types:
    /ITETR/COM_TT_VKORG_RANGE      type standard table of /ITETR/COM_S_VKORG_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_VTWEG_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type VTWEG,
      HIGH type VTWEG,
    end of /ITETR/COM_S_VTWEG_RANGE .
  types:
    /ITETR/COM_TT_VTWEG_RANGE      type standard table of /ITETR/COM_S_VTWEG_RANGE       with non-unique default key .
  types:
    begin of /ITETR/COM_S_WERKS_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type WERKS_D,
      HIGH type WERKS_D,
    end of /ITETR/COM_S_WERKS_RANGE .
  types:
    /ITETR/COM_TT_WERKS_RANGE      type standard table of /ITETR/COM_S_WERKS_RANGE       with non-unique default key .
  types:
    XBLNR type C length 000016 .
  types:
    begin of /ITETR/INV_S_XBLNR_RANGE,
      SIGN type DDSIGN,
      OPTION type DDOPTION,
      LOW type XBLNR,
      HIGH type XBLNR,
    end of /ITETR/INV_S_XBLNR_RANGE .
  types:
    /ITETR/INV_TT_XBLNR_RANGE      type standard table of /ITETR/INV_S_XBLNR_RANGE       with non-unique default key .
endinterface.