     H DftActgrp(*No) Option(*SrcStmt:*NoDebugIO)
      *-------------------------------------------------------------------------
      *
      *   Label Name:    ACMR001
      *   Description:   Get program information for compiling list of pgms
      *
      *   Created By:    LEC
      *   Creation Date: 09/27/2022
      *
      *-------------------------------------------------------------------------
     FPGMLIST   IF   E             DISK        RENAME(PGMLIST:PGMLISTR)
     FACMPP001  UF A E           K DISK

     DRtvPgmInfo       pr                  ExtPgm('QCLRPGMI')
     D OutputData                 32767a   Options(*varsize)
     D Len                           10i 0 Const
     D Format                         8a   Const
     D PgmName                       20a   Const
     D ErrorCode                           LikeDS(ErrorDS)

     DPGMI0100         DS                  Qualified
     D BytesReturned                 10i 0
     D BytesAvailable                10i 0
     D Name                          10a
     D Library                       10a
     D Owner                         10a
     D Attribute                     10a
     D CrtDateTime                   13a
     D SrcFile                       10a
     D SrcFileLib                    10a
     D SrcMbr                        10a
     D SrcUpdDateTime                13a
     D Observable                     1a
     D UsrPrfOption                   1a
     D UseAdpAut                      1a
     D LogCmd                         1a
     D AlwRTVCLSRC                    1a
     D FixDec                         1a
     D Text                          50a
     D PgmType                        1a
     D TeraspaceEnabled...
     D                                1a
     D                               58a
     D MinParms                      10i 0
     D MaxParms                      10i 0
     D Size                          10i 0
     D AssocSpcSize                  10i 0
     D StaticStgSize                 10i 0
     D AutoStgSize                   10i 0
     D MICount                       10i 0
     d State                          1a
     d CompilerID                    14a
     d OSCanRunOn                     6a
     d SrtSeqTbl                     10a
     d SrtSeqTblLib                  10a
     d LangID                        10a
     d Domain                         1a
     d ConvRequired                   1a
     d                               20a
     D Optimized                      1a
     D PagingPool                     1a
     D UpdPASA                        1a
     D ClrPASA                        1a
     D PagingAmt                      1a
     D                               18a
     D PEPMod                        10a
     D PEPModLib                     10a
     D ActGrpAttr                    30a
     D ObservInfoCompressed...
     D                                1a
     D RuntimeInfoCompressed...
     D                                1a
     D OSCrtOn                        6a
     D SharedActGrp                   1a
     D AlwUpd                         1a
     D CCSID                         10i 0
     D ModCount                      10i 0
     D SrvPgmCount                   10i 0
     D CopyrightCount                10i 0
     D UnresolveRefCount...
     D                               10i 0
     D OSCrtFor                       6a
     D AlwStaticReinit...
     D                                1a
     D CrtDta                         1a
     D AlwBndSrvPgmLibUpd...
     D                                1a
     D ProfilingData                 10a
     D TeraspaceEnabledModules...
     D                                1a
     D StgMdl                         1a
     D                               87a
     DErrorDS          DS                  Qualified
     D BytesProvided                 10i 0 Inz(%Size(ErrorDS))
     D BytesAvailable                10i 0
     D MsgID                          7a
     D                                1a
     D Text                         500a   Varying
     DwrkQualPgm       S             20a



      /free

       DoW not %eof(PGMLIST);

       Read PGMLIST;

         If %eof(PGMLIST);
            Leave;
         EndIf;

         Chain (WHPNAM) ACMPP001;
         If %found;
            Iter;
         EndIf;

         WrkQualPgm = WHPNAM + WHLIB;
         RtvPgmInfo (pgmi0100: 540: 'PGMI0100': wrkQualPgm: ErrorDS);

         If ErrorDS.BytesAvailable = 0;
             Clear ACMPP0011;

             A1NAME = PGMI0100.Name;
             A1LIBR = PGMI0100.Library;
             A1OWNR = PGMI0100.Owner;
             A1ATTR = PGMI0100.Attribute;
             A1CRDT = PGMI0100.CrtDateTime;
             A1SRCF = PGMI0100.SrcFile;
             A1SRCL = PGMI0100.SrcFileLib;
             A1SRCM = PGMI0100.SrcMbr;
             A1UPDT = PGMI0100.SrcUpdDateTime;
             A1OBFL = PGMI0100.Observable;
             A1USAA = PGMI0100.UseAdpAut;

             Write ACMPP0011;

         EndIf;

       EndDo;

       *InLR = *On;
       Return;
