!--------------------------------------------------
!- Wednesday, July 19, 2017 11:57:42 AM
!- Import of : 
!- c:\src\zimodem\cbm8bit\src\ftp64-128.prg
!- Commodore 64
!--------------------------------------------------
1 REM FTP64/128  1200B 2.0+
2 REM UPDATED 08/14/2017 02:39A
5 POKE254,8:IFPEEK(186)>7THENPOKE254,PEEK(186)
10 SY=PEEK(65532):IFSY=61THENPOKE58,254:CLR
12 IFSY=34THENX=23777:POKEX,170:IFPEEK(X)<>170THENPRINT"<16k":STOP
15 OPEN5,2,0,CHR$(8):IFPEEK(65532)=34THENPOKE56,87:POKE54,87:POKE52,87
17 DIMPP$(25):P$="ok":POKE186,PEEK(254):BA=1200:XB=1200
20 CR$=CHR$(13):PRINTCHR$(14);:SY=PEEK(65532):POKE53280,254:POKE53281,246
30 CO$="{light blue}":IFSY=226THENML=49152:POKE665,73-(PEEK(678)*30):UM=ML+2048:XB=9600
35 IFSY=34THENML=22273:IFPEEK(ML)<>76THENCLOSE5:LOAD"pmlvic.bin",peek(254),1:RUN
38 IFSY=34THENPOKE36879,27:CO$=CHR$(31)
40 IFSY=226ANDPEEK(ML+1)<>209THENCLOSE5:LOAD"pml64.bin",PEEK(254),1:RUN
45 IFSY=226ANDUM>0ANDPEEK(UM+1)<>24THENCLOSE5:LOAD"up9600.bin",PEEK(254),1:RUN
50 S8=0:IFSY=61THENML=4864:POKE981,15:S8=PEEK(215)AND128:IFS8=128THENSYS30643
60 IFSY=61ANDPEEK(ML+1)<>217THENCLOSE5:LOAD"pml128.bin",PEEK(254),1:RUN
70 IFSY=61ANDS8=128THENXB=2400:CO$=CHR$(159)
80 IFSY=226ANDUM>0THENSYSUM:SYSUM+3:X=PEEK(789):SYSUM+9:IFX=234THENXB=1200
90 IFSY<>34THENPOKE56579,0:REM WHY DOES THIS WORK
100 MV=ML+18:POKEMV+14,8:REM FIX BUFAP
101 REM
102 REM
110 REM
120 PRINTCO$;"{clear}{down*2}FTP v1.6":PRINT"Requires C64Net WiFi firmware 2.0+"
140 PRINT"By Bo Zimmerman (bo@zimmers.net)":PRINT:PRINT
197 REM --------------------------------
198 REM GET STARTED                    !
199 REM -------------------------------
200 UN=PEEK(254):IP$="":CR$=CHR$(13)+CHR$(10)
201 PH=0:PT=0:MV=ML+18
202 PRINT "Initializing modem..."
203 GET#5,A$:IFA$<>""THEN203
205 PRINT#5,CR$;"athz0f0e0";CR$;:GOSUB900:IFP$<>"ok"THEN203
208 GET#5,A$:IFA$<>""THEN208
210 PRINT#5,CR$;"ate0n0r0v1q0";CR$;
220 GOSUB900:IFP$<>"ok"THEN208
230 PRINT#5,"ate0v1x1f3q0s40=248s0=1s41=0";CR$;CHR$(19);:L9=248
240 GOSUB900:IFP$<>"ok"THENPRINT"Zimodem init failed: ";P$:STOP
245 GET#5,A$:IFA$<>""THEN245
250 PRINT#5,"ati2";CR$;:GOSUB900:IP$=P$:IFP$="ok"ORLEN(P$)<8THEN245
260 P$="":FORI=1TOLEN(IP$)
263 REMIFMID$(IP$,I,1)="."THENIP$=LEFT$(IP$,I-1)+","+MID$(IP$,I+1)
265 NEXTI:PRINT"Your ip address is: ";IP$
298 HO$="ftp.zimmers.net":PO=21:UN$="anonymous":PA$="my@email.com"
299 REMHO$="192.168.1.112":PO=21
300 REM GET INFO
310 PRINT:PRINT"{down}Request Parms:"
321 PRINT " 1) Url        : ftp://";HO$
322 PRINT " 2) Username   : ";UN$
323 PRINT " 3) Password   : ";PA$
324 PRINT " 4) Disk Device:";UN
329 LH=4
370 IFHO$=""THENPRINT:P$="1":GOTO400
380 PRINT:PRINT"Type a number or RETURN{sh space}to connect:";
390 GOSUB5000:IFP$=""THEN1000
400 X=VAL(P$):IFX<1ORX>LHTHEN300
410 IFX=1THENPRINT"Enter URL: ftp://";:GOSUB5000:HO$=P$:GOTO300
413 IFX=2THENPRINT"Enter Username: ";:GOSUB5000:UN$=P$:GOTO300
416 IFX=3THENPRINT"Enter Password: ";:GOSUB5000:PA$=P$:GOTO300
420 IFX=4THENPRINT"Enter output device/unit: ";:GOSUB5000:UN=VAL(P$):GOTO300
470 GOTO 300
597 REM --------------------------------
598 REM TRANSMIT P$ TO THE OPEN SOCKET !
599 REM -------------------------------
600 OP$=P$:SYSML+9:C8$=MID$(STR$(PEEK(MV+8)),2)
610 PRINT#5,"ats42=";C8$;"tp";QU$;P$;QU$
620 E$="ok":SYSML:IFP$<>"ok"THENP$=OP$:PRINT"{reverse on}{red}xmit fail:{reverse off}";CO$;OP$:GOTO600
630 RETURN
650 OP$=P$:SYSML+9:C8$=MID$(STR$(PEEK(MV+8)),2):PN$=MID$(STR$(LEN(P$)),2)
660 PRINT#5,"ats42=";C8$;"t";PN$:PRINT#5,P$
670 E$="ok":SYSML:IFP$<>"ok"THENP$=OP$:PRINT"xmit fail";CC$:GOTO650
680 RETURN
697 REM --------------------------------
698 REM GET NEXT FROM SOCKET INTO PP   !
699 REM -------------------------------
700 GOSUB930:IFP0<>PANDP0<0THENPRINT"Unexpected packet id: ";P0;"/";P:STOP
710 IFP0=0THENRETURN
720 PP$(PE)=P$:PE=PE+1:IFPE>=25THENPE=0
790 P$="":RETURN
797 REM --------------------------------
798 REM GET P$ FROM SOCKET P           !
799 REM -------------------------------
800 P$="":E=0:IFPH>=25THENPH=0
810 IFPH<>PETHENP$=PP$(PH):PH=PH+1:RETURN
820 GOSUB700:IFP0=0THENE=1:RETURN:REM FAIL
830 IFPH<>PETHENP$=PP$(PH):PH=PH+1:RETURN
840 E=1:RETURN
850 PC=0
860 PC=PC+1:GOSUB800:IFP$=""ORE=1THENIFPC<60THEN860
870 IFLEN(P$)<4ORMID$(P$,4,1)<>"-"THENRETURN
880 EC$=LEFT$(P$,3):EC=VAL(EC$)
881 PC=0
882 GOSUB800:IFP$=""ORE=1THENIFPC<60THEN882
883 IFP$=""ORE=1THEN870
884 IFLEFT$(P$,3)<>EC$THENPRINTP$:GOTO881
885 IFMID$(P$,4,1)="-"THEN881
886 RETURN
897 REM --------------------------------
898 REM GET E$ FROM MODEM, OR ERROR    !
899 REM -------------------------------
900 E$=""
910 SYSML
920 IFE$<>""ANDP$<>E$THENPRINT"{reverse on}{red}Comm error. Expected ";E$;", Got ";P$;CO$;"{reverse off}"
925 RETURN
927 REM --------------------------------
928 REM GET PACKET HEADER, SETS P0,P1,P2, RETURNS P0=0 IF NADA
929 REM -------------------------------
930 PR=0:GET#5,P$:IFP$<>""THEN930
940 PRINT#5,CHR$(17);
945 SYSML+6:P0=PEEK(MV+2):P1=PEEK(MV+4):P2=PEEK(MV+6)
950 PL=PEEK(MV+0):CR=PEEK(MV+1):C8=PEEK(MV+8)
960 IFP0>0ANDP2<>C8THENPRINT#5,"atl0":GOTO945
970 IFP1=0THENP$=""
980 IFCR=255THENP$="":P0=0:P1=0:P2=0:PL=0:PRINT"{reverse on}{yellow}Timeout-Retry{reverse off}";CO$:RETURN
990 RETURN
995 PRINT"Expected ";E$;", got ";A$:STOP
997 REM --------------------------------
998 REM THE MAIN LOOP                  !
999 REM -------------------------------
1000 QU$=CHR$(34):REM BEGIN!
1010 AT$="":IFXB>0ANDBA>0ANDXB<>BATHENAT$="s43="+MID$(STR$(XB),2)
1020 GET#5,A$:IFA$<>""THEN1020
1100 PRINT#5,"ath"+AT$+"&d10&m13&m10cp";QU$;HO$;":";MID$(STR$(PO),2);QU$
1105 GOSUB900:SP=0:IFP$="ok"THEN1020
1110 IFLEN(P$)>8ANDLEFT$(P$,8)="connect "THENP=VAL(MID$(P$,9)):GOTO1200
1115 PRINT"{pink}{reverse on}Unable to connect to ";HO$;" port";PO;"{reverse off}";CO$:GOTO300
1120 IT=TI+40
1130 P9=0:GOSUB800:IFP$<>""THENIT=TI+10
1140 IFTI<ITTHEN1130
1200 PRINT"{reverse on}{light green}Connected to ";HO$;" on channel";P;", Standby...{reverse off}";CO$
1201 IFXB<>9600THEN1205
1202 SYSUM:SYSUM+3:IFPEEK(789)=234THENSYSUM+9:GOTO1210
1203 BA=XB:POKEUM+19,1:PRINT#5,"at":GOSUB9000:GOSUB9000
1205 IFXB<>2400THEN1210
1206 NP=0:IFPEEK(2614)>0THENNP=20
1207 BA=XB:POKE2576,10:POKE2578,PEEK(59490+NP):POKE2579,PEEK(59491+NP)
1208 POKE2582,170:POKE2583,1:IFNP>0THENPOKE2582,154
1210 PRINT#5,"at":GOSUB9000:GOSUB9000
1220 GOSUB850:IFP$=""THEN1240
1225 PRINTP$
1230 IFUN$=""THENPRINT"Username: ";:GOSUB5000:UN$=P$:IFP$=""THEN1230
1240 P$="USER "+UN$:GOSUB600:GOSUB850:IFP$=""THEN1240
1250 PRINTP$:IFLEFT$(P$,3)<>"331"THENPRINT"{reverse on}{red}Username rejected?!{reverse off}";CO$:CLOSE5:END
1260 IFPA$=""THENPRINT"Password: ";:GOSUB5000:PA$=P$:IFP$=""THEN1260
1270 P$="PASS "+PA$:GOSUB600:GOSUB850:IFP$=""THEN1270
1280 PRINTP$:IFLEFT$(P$,3)="230"THEN2000
1290 UN$="":PA$="":GOTO1230
1300 GET#5,A$:IFA$<>""THEN1300
1302 P$="PASV":GOSUB600:A=0
1305 A=A+1:GOSUB850:IFP$=""ANDA<60THEN1305
1307 IFP$=""THEN1300
1310 PRINTP$:PRINT:IFLEFT$(P$,3)<>"227"THEN1300
1320 A=ASC(RIGHT$(P$,1)):IFA<48ORA>57THENP$=LEFT$(P$,LEN(P$)-1):GOTO1320
1330 X0=LEN(P$)
1340 A=ASC(MID$(P$,X0,1)):IFA>47ANDA<58THENX0=X0-1:GOTO1340
1350 X2=VAL(MID$(P$,X0+1)):P$=LEFT$(P$,X0-1):X0=LEN(P$)
1360 A=ASC(MID$(P$,X0,1)):IFA>47ANDA<58THENX0=X0-1:GOTO1360
1370 X1=VAL(MID$(P$,X0+1)):P$=LEFT$(P$,X0-1):H2$=":"+MID$(STR$((X1*256)+X2),2)
1375 P$=MID$(P$,5)
1380 A=ASC(LEFT$(P$,1)):IFA<48ORA>57THENP$=MID$(P$,2):GOTO1380
1390 FORI=1TOLEN(P$):IFMID$(P$,I,1)=","THENP$=LEFT$(P$,I-1)+"."+MID$(P$,I+1)
1395 NEXT:H0$=P$+H2$:R0=0
1400 GET#5,P$:IFP$<>""THEN1400
1405 PRINT#5,"at";CC$;QU$;H0$;QU$:GOSUB900
1410 IFLEN(P$)>8ANDLEFT$(P$,8)="connect "THENSP=VAL(MID$(P$,9)):GOTO 1420
1412 IFR0>1THEN1300
1415 R0=R0+1:PRINT"{red}Error: ";P$:PRINT"{pink}{reverse on}Retry to connect to ";H0$;"{reverse off}";CO$:GOTO1400
1420 GET#5,A$:IFA$<>""THEN1420
1425 PRINT#5,"atc";MID$(STR$(P),2):GOSUB900:IFP$="ok"THENE=0:RETURN
1430 PRINT"{pink}{reverse on}Retry to change back to ";H0$;"{reverse off}";CO$:GOTO1420
2000 PRINT"Command (?): ";:GOSUB5000
2010 IFP$=""THENGOSUB800:PRINTP$:GOTO2000
2020 IFP$="ls"ORLEFT$(P$,3)="ls "THENGOSUB4000:GOTO2000
2030 IFP$="dir"ORLEFT$(P$,4)="dir "THENGOSUB4000:GOTO2000
2040 IFP$="exit"ORP$="quit"THENPRINT#5,"atz":GOSUB900:CLOSE5:END
2045 IFLEFT$(P$,4)="del "THENP$="dele"+MID$(P$,4)
2050 IFLEFT$(P$,3)="cd "THENP$="CWD "+MID$(P$,4)
2055 IFLEFT$(P$,4)="lcd "THEN8000
2056 IFLEFT$(P$,5)="ldel "THEN8100
2057 IFLEFT$(P$,4)="ldir"THEN8200
2060 IFLEFT$(P$,4)="get "THENF$=MID$(P$,5):GOSUB6000:GOTO2000
2070 IFLEFT$(P$,4)="put "THENF$=MID$(P$,5):GOSUB7000:GOTO2000
2075 IFP$="?"THENP$="help"
2080 IFP$="help"THENPRINT"{light green}{reverse on}get put ls cd dir del"
2081 IFP$="help"THENPRINT"{light green}{reverse on}lcd ldir ldel quit"
2082 IFP$="help"THENPRINT"{light green}{reverse on}Use ,s and ,p in get/put filenames!"
2083 IFP$="help"THENPRINT"{light green}{reverse on}Below are server commands:{reverse off}";CO$
2100 GOSUB600:GOSUB850:PRINTP$:GOTO2000
2999 STOP
4000 P$="TYPE A":GOSUB600:GOSUB850:IFP$=""THEN4000
4005 PRINTP$:CC$="&m10&d10&m13cp":GOSUB1300:IFE=1THENRETURN
4010 P$="PWD":GOSUB600:GOSUB850:IFP$=""THEN4010
4020 REMPRINTP$:P$="PORT "+IP$+",198,76":GOSUB600:GOSUB850:IFP$=""THEN4020
4025 GET#5,A$:IFST=0ANDA$<>""THENGOSUB900:GOTO4025
4030 PRINTP$:P$="LIST":GOSUB600
4040 REMGOSUB900:IFLEFT$(P$,5)="ring "THEN4040
4050 Y=0:Y$="":Y1=0:Y2=0:Y3=5:IFBA>4800THENY3=10
4100 REMGET#5,A$:IFST=0ANDA$<>""THENGOSUB900:GOTO4100
4110 GETA$:IFA$=" "ORA$="{ct c}"THENPRINT:PRINT"Aborted.":GOTO4250
4150 GOSUB800
4200 IFP0=PANDY=1ANDP$<>""THENY$=P$:GOTO4100
4210 IFP0=PANDP$=""THEN4100
4220 IFP0=PANDLEFT$(P$,4)="226 "THENY=1:Y$=P$:GOTO4100
4225 IFP0=PANDLEFT$(P$,4)="150 "THEN4100:REMPRINTP$:GOTO4100
4230 IFP0<>SPORP$=""THEN4235
4231 Y2=0:Y1=Y1+1:IFS8=0THENPRINTMID$(P$,34):GOTO4100
4232 PRINTP$:GOTO4100
4235 IFP0=PTHEN4100
4240 Y2=Y2+1:IFY=0AND(Y1>2ORY2<Y3)THEN4100
4242 PRINTY$
4244 GET#5,A$:IFA$<>""ANDST=0THEN4244
4245 GOSUB800:IFP$<>""THENPRINTP$:GOTO4245
4250 PRINT#5,"ath"+MID$(STR$(SP),2):GOSUB900:IFP$<>"ok"THEN4250
4299 RETURN
5000 P$=""
5005 PRINT"{reverse on} {reverse off}{left}";
5010 GETA$:IFA$=""THEN5010
5020 IFA$=CHR$(13)THENPRINT" {left}":RETURN
5030 IFA$<>CHR$(20)THENPRINTA$;"{reverse on} {reverse off}{left}";:P$=P$+A$:GOTO5010
5040 IFP$=""THEN5010
5050 P$=LEFT$(P$,LEN(P$)-1):PRINT" {left*2} {left}{reverse on} {reverse off}{left}";:GOTO5010
6000 FX=0:X$=",p,w":P$="TYPE I":GOSUB600:GOSUB850:IFP$=""THEN6000
6005 PRINTP$:CC$="c":GOSUB1300:IFE=1THENRETURN
6010 FX$=RIGHT$(F$,2)
6015 IFLEFT$(F$,1)=" "THENF$=MID$(F$,2):GOTO6015
6020 IFFX$=",p"ORFX$=",s"THENF$=LEFT$(F$,LEN(F$)-2):X$=FX$+",w"
6025 IFF$=""THENRETURN
6030 P$="RETR "+F$:GOSUB600
6050 Y=0:Y$="":TB=0:TT=0:Y0=0:Y1=10
6100 GET#5,A$:IFST=0ANDA$<>""THENGOSUB900:GOTO6100
6150 GOSUB800
6160 IFFX>0ORP0<>SPORP1=0THEN6200
6170 OPEN1,UN,15:OPEN8,UN,8,"@0:"+F$+X$
6180 INPUT#1,E:IFE<>0THENCLOSE8:CLOSE1:PRINT"{reverse on}{red}Failed to open "+F$+"{reverse off}";CO$:GOTO6250
6190 FX=1
6200 PL=LEN(P$):IFP0<>PTHEN6230
6205 IFPL=0THEN6100
6210 Y0=0:IFY=1ANDPL>0THENY$=P$:GOTO6100
6215 LP$=LEFT$(P$,4):IFLP$="550 "THENPRINTP$:GOTO6250
6220 IFLP$="226 "THENY=1:Y$=P$:GOTO6100
6225 IFLP$="150 "THENPRINTLEFT$("{up}",SGN(TT))+P$:PRINT:GOSUB6400:GOTO6100
6230 IFP0=SPANDPL>0THENPRINT#8,P$;:TT=TT+PL:GOSUB6500:Y0=0:GOTO6100
6235 IFP0=PTHEN6100
6240 Y0=Y0+1:IFY=0THENIFY0<Y1ORTT<TBTHEN6100
6245 GET#5,A$:IFST=0ANDA$<>""THENGOSUB900:GOTO6245
6247 PRINTY$:PRINT "{reverse on}{light green}";MID$(STR$(TT),2);" bytes transferred.{reverse off}";CO$
6250 CLOSE8:CLOSE1:PRINT#5,"ath"+MID$(STR$(SP),2):GOSUB900:IFP$<>"ok"THEN6250
6260 GOSUB800:IFP$<>""THENPRINTP$:GOTO6260
6299 RETURN
6400 I=LEN(P$)-1:I0=0:TB=0
6410 A$=MID$(P$,I,1):IFA$="("THEN6450
6420 IFA$=" "THENI0=I
6430 I=I-1:IFI>0THEN6410
6440 RETURN
6450 IFI0=0THENRETURN
6460 IFLEFT$(MID$(P$,I0+1),4)<>"byte"THENRETURN
6470 TB=VAL(MID$(P$,I+1,I0-I)):Y1=TB+10:RETURN
6500 PRINT"{up}               {left*15}"+STR$(TT):RETURN
7000 FX=0:X$=",p,r":P$="TYPE I":GOSUB600:GOSUB850:IFP$=""THEN7000
7010 FX$=RIGHT$(F$,2)
7015 IFLEFT$(F$,1)=" "THENF$=MID$(F$,2):GOTO7015
7020 IFFX$=",p"ORFX$=",s"THENF$=LEFT$(F$,LEN(F$)-2):X$=FX$+",r"
7025 IFF$=""THENRETURN
7027 OPEN1,UN,15:OPEN8,UN,8,F$+X$
7028 INPUT#1,E:IFE<>0THENCLOSE8:CLOSE1:PRINT"{reverse on}{red}Failed to open "+F$+"{reverse off}";CO$:RETURN
7029 PRINTP$:PRINT:CC$="c":GOSUB1300:IFE=1THENRETURN
7030 P$="STOR "+F$:GOSUB600
7040 PRINT#5,"atc";MID$(STR$(SP),2):GOSUB900:IFP$<>"ok"THEN7040
7050 Y=0:Y$="":TT=0
7100 GET#5,A$:IFST=0ANDA$<>""THENGOSUB900:GOTO7100
7110 SYSML+12:X=PEEK(MV):XE=PEEK(MV+1)
7120 IFLEN(P$)=0THEN7100
7130 TT=TT+LEN(P$):GOSUB6500:GOSUB650:IFXE>0THEN7250
7150 GOSUB800
7200 IFP0=PANDLEFT$(P$,3)="550"THENPRINTP$:GOTO7250
7210 IFP0=PANDP$=""THEN7100
7215 IFP0=PANDLEFT$(P$,4)="150 "THENPRINTLEFT$("{up}",SGN(TT))+P$:PRINT:GOTO7100
7220 IFP0=PTHENPRINTP$:PRINT:GOTO7100
7230 IFP0=SPTHENPRINT"?!":GOTO7100
7240 GOTO7100
7250 GET#5,A$:IFST=0ANDA$<>""THENGOSUB900:GOTO7250
7260 PRINT "{reverse on}{light green}";MID$(STR$(TT),2);" bytes transferred.{reverse off}";CO$
7265 GET#5,A$:IFA$<>""THEN7265
7270 CLOSE8:CLOSE1:PRINT#5,"ath"+MID$(STR$(SP),2):GOSUB900:IFP$<>"ok"THEN7265
7272 TT=TI+200
7275 GOSUB800:IFP$=""ANDTI<TTTHEN7275
7280 PRINTP$:GOSUB800:IFP$<>""THEN7280
7290 PRINT#5,"atc";MID$(STR$(P),2):GOSUB900:IFP$<>"ok"THEN7290
7299 RETURN
8000 P$=MID$(P$,5):IFVAL(P$)<8ORVAL(P$)>16THEN8020
8010 UN=VAL(P$):PRINT"Current drive is now";UN:GOTO2000
8020 OPEN1,UN,15,"cd "+P$:INPUT#1,E,E$,E1,E2:PRINTE,E$,E1,E2:CLOSE1:GOTO2000
8100 P$=MID$(P$,6)
8120 OPEN1,UN,15,"s0:"+P$:INPUT#1,E,E$,E1,E2:PRINTE,E$,E1,E2:CLOSE1:GOTO2000
8200 P$=MID$(P$,6):IFLEN(P$)>0THENP$=":"+P$
8210 OPEN8,UN,0,"$"+P$
8220 GET#8,A$,A$
8230 GET#8,A$,A$:IFST>0THENX=FRE(0):CLOSE8:PRINT:GOTO2000
8240 GET#8,A$,B$:X=ASC(A$+CHR$(0))+256*ASC(B$+CHR$(0)):PRINTX;
8250 GET#8,A$:IFA$=""THENPRINTCHR$(13);:GOTO8230
8260 GETB$:IFB$=" "THENCLOSE8:PRINT:GOTO2000
8270 PRINTA$;:GOTO8250
9000 TT=TI+100
9010 SYSML+12:IFTI<TTTHEN9010
9020 RETURN
50000 OPEN5,2,0,CHR$(8)
50010 GET#5,A$:IFA$<>""THENPRINTA$;
50020 GETA$:IFA$<>""THENPRINT#5,A$;
50030 GOTO 50010
55555 U=8:F$="ftp":OPEN1,U,15,"s0:"+F$:CLOSE1:SAVE(F$),U:VERIFY(F$),U