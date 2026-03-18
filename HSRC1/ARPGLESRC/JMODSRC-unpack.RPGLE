00000**COPYRIGHT 2002 Sterling Commerce
00000**_________________________________________________________________________
00000**PROGRAM: @MODSRC002
00000**CREATED: 04/16/2002
00000**  AUTHOR: Mike Fiorillo, STERLING COMMERCE"
00000** PURPOSE: Support for command UNPACK, called by CL program @UNPACK.  This
00000**         a DDS source member created by RTVDDSSRC so that packed numeric
00000**         redefined as zoned (unpacked)
00000**_________________________________________________________________________
00000** Parameters used in this program:
00000**    FILNM  - Name of file for which DDS is being modified to unpack numer
00000**_________________________________________________________________________
00000**INDICATOR  DESCRIPTION
00000**    LR     LAST RECORD (signal END-OF-PROGRAM)
00000**_________________________________________________________________________
00000**MODIFICATION HISTORY
00000**  Date       Name               Description
00000** ----------  -----------------  ------------------------------
00000**_________________________________________________________________________
00000**
00000FSRCF      UF   F   92        DISK
00000**
00000D SrcSeq          S              6  2
00000**
00000D Record          DS
00000D   RcdType              29     29
00000D   FieldSize            42     46  0
00000D   DtaType              47     47
00000D   Decimal              48     49
00000**                               29   29  RcdType
00000ISRCF      NS
00000I                                  1   92  Record
00000**
00000C     *ENTRY        PLIST
00000C                   PARM                    FILNM            10
00000**
00000C                   exsr      $Fields
00000C                   eval      *InLR = *ON
00000**
00000C     $Fields       BEGSR
00000C     1             setll     SRCF
00000C                   read      SRCF
00000C                   dow       NOT(%EOF(SRCF))
00000** If not R or K record (record format or key) and if field is packed (blan
00000** then process to change to unpacked.
00000C                   if        RcdType = ' '
00000C                               AND
00000C                             Decimal <> *BLANKS
00000C                               AND  (
00000C                                   DtaType = ' '
00000C                                     OR
00000C                                   DtaType = 'P'
00000C                                    )
00000** redefine data type
00000C                   eval      DtaType = 'S'
00000** and expand field to equivalent zoned size
00000C                   eval      FieldSize = (FieldSize * 2) - 1
00000C                   update    SRCF          record
00000C                   endif
00000C                   read      SRCF
00000C                   enddo
00000C                   endsr
00000**
