00000**COPYRIGHT 2002 Sterling Commerce
00000**_________________________________________________________________________
00000**PROGRAM: @CRTSRC002
00000**CREATED: 04/16/2002
00000**  AUTHOR: Mike Fiorillo, STERLING COMMERCE"
00000** PURPOSE: Support for command RTVDDSSRC, called by CL program @RTVDDS.  T
00000**         a DDS source member based on outfiles created by DSPFFD and DSPF
00000**_________________________________________________________________________
00000** Parameters used in this program:
00000**    FILNM  - Name of file for which DDS is being retrieved and for which
00000**             being created
00000**_________________________________________________________________________
00000**INDICATOR  DESCRIPTION
00000**    LR     LAST RECORD (signal END-OF-PROGRAM)
00000**_________________________________________________________________________
00000**MODIFICATION HISTORY
00000**  Date       Name               Description
00000** ----------  -----------------  ------------------------------
00000**_________________________________________________________________________
00000**
00000FSRCF      O    F  112        DISK
00000FDSPFFD    IF   E             DISK
00000FDSPFD     IF   E             DISK
00000**
00000DQuote1           C                   CONST(X'7D')
00000**
00000D SrcSeq          S              6  2
00000**
00000D Record          DS
00000D   Filler                      15
00000D   RecType                      1
00000D   Name                        10
00000D   Length                       5  0
00000D   DtaType                      1
00000D   Decimal                      2  0
00000D   DecimalA                     2    OVERLAY(DECIMAL)
00000D   Text                        36
00000**
00000C     *ENTRY        PLIST
00000C                   PARM                    FILNM            10
00000**
00000C                   exsr      $Record
00000C                   exsr      $Fields
00000C                   exsr      $Keys
00000C                   eval      *InLR = *ON
00000**
00000***************************************************************************
00000**Subroutine $Record -- creates R-spec
00000***************************************************************************
00000**
00000C     $Record       BEGSR
00000**
00000C                   clear                   Record
00000**R-spec will be SEU sequence # 1
00000C                   eval      SrcSeq = 1
00000**Create record format name
00000C                   if        %SUBST(FilNm:10:1) = ' '
00000C                   eval      Name = %TRIM(FilNm) + 'F'
00000C                   else
00000C                   eval      Name = %Subst(FilNm:1:9) + 'F'
00000C                   endif
00000C                   except    #Record
00000C                   endsr
00000**
00000***************************************************************************
00000**Subroutine $Fields -- creates field specification records based on file D
00000***************************************************************************
00000**
00000C     $Fields       BEGSR
00000**Process fields from file DspFFD
00000C     1             setll     DspFFD
00000C                   read      DspFFD
00000C                   dow       NOT(%EOF(DspFFD))
00000C                   clear                   Record
00000**increment SEU source sequence number by one
00000C                   eval      SrcSeq = SrcSeq + 1
00000**populate field specs
00000C                   eval      Name = WhFldI
00000C                   eval      Length = WhFldB
00000** if not alphanunmeric field, write decimal places info, else suppress dec
00000C                   if        WhFldT  <> 'A'
00000C                   eval      Decimal = WhFldP
00000C                   else
00000C                   clear                   DecimalA
00000C                   endif
00000**create field text description
00000C                   eval      Text = 'TEXT(' + Quote1 + %TRIM(WhFTxt)
00000C                                   +Quote1 +')'
00000C                   eval      DtaType = WhFldT
00000C                   except    #Field
00000C                   read      DspFFD
00000C                   enddo
00000C                   endsr
00000**
00000***************************************************************************
00000**Subroutine $Keys -- creates key field specification records based on file
00000***************************************************************************
00000**
00000C     $Keys         BEGSR
00000**Process fields from file DspFFD
00000C     1             setll     DspFD
00000C                   read      DspFD
00000C                   dow       NOT(%EOF(DspFD))
00000**if this is a key field
00000C                   if        ApKeyF <> *BLANK
00000C                   clear                   Record
00000**increment SEU source sequence number by one
00000C                   eval      SrcSeq = SrcSeq + 1
00000C                   eval      Name = ApKeyF
00000** if descending key sequence, write keyword"
00000C                   if        ApKSeq  = 'D'
00000C                   eval      Text = 'DESCEND'
00000C                   endif
00000**
00000C                   except    #Key
00000C                   endif
00000C                   read      DspFD
00000C                   enddo
00000C                   endsr
00000**
00000***************************************************************************
00000**Output Specifications
00000***************************************************************************
00000**
00000**#Record -- outputs R spec
00000OSRCF      E            #Record
00000O                       SrcSeq               6
00000O                       Filler              27
00000O                                           29 'R'
00000O                       Name                40
00000O                       Text                92
00000**
00000**#Field -- outputs field records
00000OSRCF      E            #Field
00000O                       SrcSeq               6
00000O                       Filler              27
00000O                                           29 ' '
00000O                       Name                40
00000O                       Length              46 '    0'
00000O                       DtaType             47
00000O                       DecimalA            49
00000O                       Text                92
00000**
00000**#Key -- outputs K specs
00000OSRCF      E            #Key
00000O                       SrcSeq               6
00000O                       Filler              27
00000O                                           29 'K'
00000O                       Name                40
00000**
