
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1/000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _year=R4
	.DEF _year_msb=R5
	.DEF _mounth=R6
	.DEF _mounth_msb=R7
	.DEF _day=R8
	.DEF _day_msb=R9
	.DEF _hour=R10
	.DEF _hour_msb=R11
	.DEF _minute=R12
	.DEF _minute_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F
_0x1F:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x74,0x65,0x6D,0x70,0x72,0x61,0x74,0x75
	.DB  0x72,0x65,0x20,0x69,0x73,0x3A,0x20,0x25
	.DB  0x64,0x0,0x44,0x61,0x74,0x65,0x3A,0x0
	.DB  0x79,0x65,0x61,0x72,0x3D,0x25,0x64,0x0
	.DB  0x6D,0x6F,0x6E,0x74,0x68,0x3D,0x25,0x64
	.DB  0x0,0x64,0x61,0x79,0x3D,0x25,0x64,0x0
	.DB  0x54,0x69,0x6D,0x65,0x3A,0x0,0x68,0x6F
	.DB  0x75,0x72,0x3D,0x25,0x64,0x0,0x6D,0x69
	.DB  0x6E,0x75,0x74,0x65,0x3D,0x25,0x64,0x0
	.DB  0x73,0x65,0x63,0x6F,0x6E,0x64,0x3D,0x25
	.DB  0x64,0x0,0x74,0x6F,0x20,0x65,0x6E,0x74
	.DB  0x65,0x72,0x20,0x6D,0x6F,0x74,0x6F,0x72
	.DB  0x73,0x27,0x20,0x73,0x65,0x74,0x74,0x69
	.DB  0x6E,0x67,0x73,0x20,0x70,0x72,0x65,0x73
	.DB  0x73,0x20,0x76,0x0,0x74,0x6F,0x20,0x65
	.DB  0x6E,0x74,0x65,0x72,0x20,0x74,0x69,0x6D
	.DB  0x65,0x20,0x73,0x65,0x74,0x74,0x69,0x6E
	.DB  0x67,0x73,0x20,0x70,0x72,0x65,0x73,0x73
	.DB  0x20,0x74,0x0,0x74,0x6F,0x20,0x65,0x6E
	.DB  0x74,0x65,0x72,0x20,0x37,0x73,0x65,0x67
	.DB  0x6D,0x65,0x6E,0x74,0x73,0x27,0x73,0x20
	.DB  0x73,0x65,0x74,0x74,0x69,0x6E,0x67,0x73
	.DB  0x20,0x70,0x72,0x65,0x73,0x73,0x20,0x67
	.DB  0x0,0x6D,0x6F,0x74,0x6F,0x72,0x27,0x73
	.DB  0x20,0x73,0x65,0x74,0x74,0x69,0x6E,0x67
	.DB  0x73,0x3A,0x0,0x73,0x65,0x74,0x20,0x6D
	.DB  0x6F,0x74,0x6F,0x72,0x73,0x20,0x76,0x65
	.DB  0x6C,0x6F,0x63,0x69,0x74,0x79,0x20,0x6F
	.DB  0x72,0x20,0x63,0x6F,0x6E,0x74,0x72,0x6F
	.DB  0x6C,0x20,0x69,0x74,0x20,0x62,0x79,0x20
	.DB  0x74,0x65,0x6D,0x70,0x72,0x61,0x74,0x75
	.DB  0x72,0x65,0x3F,0x20,0x70,0x72,0x65,0x73
	.DB  0x73,0x20,0x61,0x20,0x6F,0x72,0x20,0x62
	.DB  0x0,0x76,0x65,0x6C,0x6F,0x63,0x69,0x74
	.DB  0x79,0x3A,0x0,0x74,0x65,0x6D,0x70,0x65
	.DB  0x72,0x61,0x74,0x75,0x72,0x65,0x20,0x63
	.DB  0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x6F
	.DB  0x6B,0x0,0x74,0x69,0x6D,0x65,0x20,0x73
	.DB  0x65,0x74,0x74,0x69,0x6E,0x67,0x73,0x0
	.DB  0x20,0x20,0x79,0x65,0x61,0x72,0x3A,0x0
	.DB  0x20,0x20,0x4D,0x4F,0x4E,0x54,0x48,0x3A
	.DB  0x0,0x20,0x20,0x64,0x61,0x79,0x3A,0x0
	.DB  0x20,0x20,0x68,0x6F,0x75,0x72,0x3A,0x0
	.DB  0x20,0x20,0x6D,0x69,0x6E,0x75,0x74,0x65
	.DB  0x3A,0x0,0x20,0x20,0x73,0x65,0x63,0x6F
	.DB  0x6E,0x64,0x3A,0x0,0x74,0x6F,0x20,0x73
	.DB  0x68,0x6F,0x77,0x20,0x74,0x68,0x65,0x20
	.DB  0x74,0x69,0x6D,0x65,0x2C,0x64,0x61,0x74
	.DB  0x65,0x20,0x61,0x6E,0x64,0x20,0x74,0x65
	.DB  0x6D,0x70,0x72,0x61,0x74,0x75,0x72,0x65
	.DB  0x20,0x70,0x72,0x65,0x73,0x73,0x20,0x73
	.DB  0x0,0x37,0x73,0x65,0x67,0x6D,0x65,0x6E
	.DB  0x74,0x27,0x73,0x20,0x73,0x65,0x74,0x74
	.DB  0x69,0x6E,0x67,0x73,0x3A,0x0,0x57,0x6F
	.DB  0x75,0x6C,0x64,0x20,0x79,0x6F,0x75,0x20
	.DB  0x6C,0x69,0x6B,0x65,0x20,0x74,0x6F,0x20
	.DB  0x73,0x68,0x6F,0x77,0x20,0x61,0x6E,0x20
	.DB  0x61,0x72,0x62,0x69,0x74,0x72,0x61,0x72
	.DB  0x79,0x20,0x6E,0x75,0x6D,0x62,0x65,0x72
	.DB  0x20,0x6F,0x72,0x20,0x74,0x68,0x65,0x20
	.DB  0x73,0x65,0x6E,0x73,0x6F,0x72,0x73,0x20
	.DB  0x74,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
	.DB  0x75,0x72,0x65,0x20,0x6F,0x6E,0x20,0x37
	.DB  0x20,0x73,0x65,0x67,0x6D,0x65,0x6E,0x74
	.DB  0x20,0x3F,0x20,0x70,0x72,0x65,0x73,0x73
	.DB  0x20,0x61,0x20,0x6F,0x72,0x20,0x62,0x0
	.DB  0x65,0x6E,0x74,0x65,0x72,0x20,0x74,0x68
	.DB  0x65,0x20,0x6E,0x75,0x6D,0x62,0x65,0x72
	.DB  0x0,0x73,0x65,0x6E,0x73,0x6F,0x72,0x20
	.DB  0x74,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
	.DB  0x75,0x72,0x65,0x20,0x6F,0x6B,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x13
	.DW  _display
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/30/2018
;Author  : msi
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <delay.h>
;int year=0 , mounth=0 , day=0 , hour=0 , minute=0 , second=0;
;int display[10]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f};

	.DSEG
;char key,c;
;char comparematch;
;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0052 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0053 char status,data;
; 0000 0054 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0055 data=UDR;
	IN   R16,12
; 0000 0056 key=data;
	STS  _key,R16
; 0000 0057 
; 0000 0058 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
; 0000 0059    {
; 0000 005A    rx_buffer[rx_wr_index++]=data;
	LDS  R30,_rx_wr_index
	SUBI R30,-LOW(1)
	STS  _rx_wr_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 005B #if RX_BUFFER_SIZE == 256
; 0000 005C    // special case for receiver buffer size=256
; 0000 005D    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 005E #else
; 0000 005F    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x5
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
; 0000 0060    if (++rx_counter == RX_BUFFER_SIZE)
_0x5:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x6
; 0000 0061       {
; 0000 0062       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 0063       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0064       }
; 0000 0065 #endif
; 0000 0066    }
_0x6:
; 0000 0067 }
_0x4:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x44
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006E {
_getchar:
; .FSTART _getchar
; 0000 006F char data;
; 0000 0070 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x7:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x7
; 0000 0071 data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0072 #if RX_BUFFER_SIZE != 256
; 0000 0073 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xA
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0000 0074 #endif
; 0000 0075 #asm("cli")
_0xA:
	cli
; 0000 0076 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0000 0077 #asm("sei")
	sei
; 0000 0078 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0079 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0089 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008A if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xB
; 0000 008B    {
; 0000 008C    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 008D    UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 008E #if TX_BUFFER_SIZE != 256
; 0000 008F    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xC
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 0090 #endif
; 0000 0091    }
_0xC:
; 0000 0092 }
_0xB:
_0x44:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0099 {
_putchar:
; .FSTART _putchar
; 0000 009A while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xD:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0xD
; 0000 009B #asm("cli")
	cli
; 0000 009C if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x11
	SBIC 0xB,5
	RJMP _0x10
_0x11:
; 0000 009D    {
; 0000 009E    tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 009F #if TX_BUFFER_SIZE != 256
; 0000 00A0    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x13
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 00A1 #endif
; 0000 00A2    ++tx_counter;
_0x13:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00A3    }
; 0000 00A4 else
	RJMP _0x14
_0x10:
; 0000 00A5    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A6 #asm("sei")
_0x14:
	sei
; 0000 00A7 }
	RJMP _0x20A0002
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 output compare interrupt service routine
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 00B0 {
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B1 
; 0000 00B2 comparematch++;
	LDS  R30,_comparematch
	SUBI R30,-LOW(1)
	STS  _comparematch,R30
; 0000 00B3 
; 0000 00B4  if(comparematch==4){
	LDS  R26,_comparematch
	CPI  R26,LOW(0x4)
	BREQ PC+2
	RJMP _0x15
; 0000 00B5         TCNT0=0X00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00B6         second++;
	LDI  R26,LOW(_second)
	LDI  R27,HIGH(_second)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00B7         comparematch=0;
	LDI  R30,LOW(0)
	STS  _comparematch,R30
; 0000 00B8         if(key=='s'){
	LDS  R26,_key
	CPI  R26,LOW(0x73)
	BREQ PC+2
	RJMP _0x16
; 0000 00B9         key=getchar();
	CALL SUBOPT_0x0
; 0000 00BA         if(second==60){second=0; minute++;}
	LDS  R26,_second
	LDS  R27,_second+1
	SBIW R26,60
	BRNE _0x17
	LDI  R30,LOW(0)
	STS  _second,R30
	STS  _second+1,R30
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00BB         if(minute==60){minute=0; hour++;}
_0x17:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x18
	CLR  R12
	CLR  R13
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00BC         if(hour==24){hour=0;day++;}
_0x18:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x19
	CLR  R10
	CLR  R11
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 00BD         if(day==31){day=0; mounth++;}
_0x19:
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x1A
	CLR  R8
	CLR  R9
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00BE         if(mounth==12){mounth=0; year++;}
_0x1A:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x1B
	CLR  R6
	CLR  R7
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00BF         //show temp
; 0000 00C0         printf("temprature is: %d" , c);
_0x1B:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_c
	CALL SUBOPT_0x1
; 0000 00C1         putchar('\n\r');
; 0000 00C2 
; 0000 00C3         //show Date
; 0000 00C4          putchar('\n\r');
	CALL SUBOPT_0x2
; 0000 00C5          putchar('\n\r');
; 0000 00C6 
; 0000 00C7         putsf("Date:");
	__POINTW2FN _0x0,18
	CALL _putsf
; 0000 00C8         printf("year=%d",year);
	__POINTW1FN _0x0,24
	CALL SUBOPT_0x3
; 0000 00C9         putchar('/');
	LDI  R26,LOW(47)
	RCALL _putchar
; 0000 00CA 
; 0000 00CB         printf("month=%d",mounth);
	__POINTW1FN _0x0,32
	CALL SUBOPT_0x4
; 0000 00CC         putchar('/');
	LDI  R26,LOW(47)
	RCALL _putchar
; 0000 00CD 
; 0000 00CE         printf("day=%d",day);
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x5
; 0000 00CF         putchar('\n\r');
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 00D0 
; 0000 00D1         //show Time
; 0000 00D2         putsf("Time:");
	__POINTW2FN _0x0,48
	CALL _putsf
; 0000 00D3         printf("hour=%d",hour);
	__POINTW1FN _0x0,54
	CALL SUBOPT_0x6
; 0000 00D4         putchar(':');
	LDI  R26,LOW(58)
	RCALL _putchar
; 0000 00D5 
; 0000 00D6         printf("minute=%d",minute);
	__POINTW1FN _0x0,62
	CALL SUBOPT_0x7
; 0000 00D7         putchar(':');
	LDI  R26,LOW(58)
	RCALL _putchar
; 0000 00D8 
; 0000 00D9         printf("second=%d",second);
	__POINTW1FN _0x0,72
	CALL SUBOPT_0x8
; 0000 00DA         putchar('\n\r');
	CALL SUBOPT_0x2
; 0000 00DB         putchar('\n\r');
; 0000 00DC         key='h';   }}
	LDI  R30,LOW(104)
	STS  _key,R30
_0x16:
; 0000 00DD }
_0x15:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;#define ADC_VREF_TYPE 0xC0
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 00E4 {
_read_adc:
; .FSTART _read_adc
; 0000 00E5 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 00E6 // Delay needed for the stabilization of the ADC input voltage
; 0000 00E7 delay_us(10);
	__DELAY_USB 3
; 0000 00E8 // Start the AD conversion
; 0000 00E9 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00EA // Wait for the AD conversion to complete
; 0000 00EB while ((ADCSRA & 0x10)==0);
_0x1C:
	SBIS 0x6,4
	RJMP _0x1C
; 0000 00EC ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00ED return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20A0002:
	ADIW R28,1
	RET
; 0000 00EE }
; .FEND
;
;// Declare your global variables here
;
;void main(void)
; 0000 00F3 {
_main:
; .FSTART _main
; 0000 00F4 int temp[3]={0,0,0};
; 0000 00F5 float n;
; 0000 00F6 int T;
; 0000 00F7 int k=0,i=0,j=0,l=0,p=0;
; 0000 00F8 char pd,v,A,B;
; 0000 00F9 
; 0000 00FA // Declare your local variables here
; 0000 00FB 
; 0000 00FC // Input/Output Ports initialization
; 0000 00FD // Port A initialization
; 0000 00FE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00FF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0100 PORTA=0x00;
	SBIW R28,20
	LDI  R24,16
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	LDI  R30,LOW(_0x1F*2)
	LDI  R31,HIGH(_0x1F*2)
	CALL __INITLOCB
;	temp -> Y+14
;	n -> Y+10
;	T -> R16,R17
;	k -> R18,R19
;	i -> R20,R21
;	j -> Y+8
;	l -> Y+6
;	p -> Y+4
;	pd -> Y+3
;	v -> Y+2
;	A -> Y+1
;	B -> Y+0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0101 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0102 
; 0000 0103 // Port B initialization
; 0000 0104 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0105 // State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1
; 0000 0106 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0107 DDRB=0xFF;
	OUT  0x17,R30
; 0000 0108 
; 0000 0109 // Port C initialization
; 0000 010A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 010B // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 010C PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 010D DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 010E 
; 0000 010F // Port D initialization
; 0000 0110 // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0111 // State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T
; 0000 0112 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0113 DDRD=0x20;
	LDI  R30,LOW(32)
	OUT  0x11,R30
; 0000 0114 
; 0000 0115 // Timer/Counter 0 initialization
; 0000 0116 // Clock source: System Clock
; 0000 0117 // Clock value: 0.977 kHz
; 0000 0118 // Mode: Normal top=0xFF
; 0000 0119 // OC0 output: Disconnected
; 0000 011A TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 011B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 011C OCR0=0xD1;
	LDI  R30,LOW(209)
	OUT  0x3C,R30
; 0000 011D 
; 0000 011E // Timer/Counter 1 initialization
; 0000 011F // Clock source: System Clock
; 0000 0120 // Clock value: 0.977 kHz
; 0000 0121 // Mode: Fast PWM top=ICR1
; 0000 0122 // OC1A output: Non-Inv.
; 0000 0123 // OC1B output: Discon.
; 0000 0124 // Noise Canceler: Off
; 0000 0125 // Input Capture on Falling Edge
; 0000 0126 // Timer1 Overflow Interrupt: Off
; 0000 0127 // Input Capture Interrupt: Off
; 0000 0128 // Compare A Match Interrupt: Off
; 0000 0129 // Compare B Match Interrupt: Off
; 0000 012A TCCR1A=0x82;
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 012B TCCR1B=0x1D;
	LDI  R30,LOW(29)
	OUT  0x2E,R30
; 0000 012C TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 012D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 012E ICR1H=0x00;
	OUT  0x27,R30
; 0000 012F ICR1L=0x5A;
	LDI  R30,LOW(90)
	OUT  0x26,R30
; 0000 0130 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0131 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0132 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0133 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0134 
; 0000 0135 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0136 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0137 
; 0000 0138 // USART initialization
; 0000 0139 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 013A // USART Receiver: On
; 0000 013B // USART Transmitter: On
; 0000 013C // USART Mode: Asynchronous
; 0000 013D // USART Baud Rate: 4800
; 0000 013E UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 013F UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0140 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0141 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0142 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 0143 
; 0000 0144 // ADC initialization
; 0000 0145 // ADC Clock frequency: 500.000 kHz
; 0000 0146 // ADC Voltage Reference: Int., cap. on AREF
; 0000 0147 // Only the 8 most significant bits of
; 0000 0148 // the AD conversion result are used
; 0000 0149 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 014A ADCSRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 014B 
; 0000 014C // Global enable interrupts
; 0000 014D #asm("sei")
	sei
; 0000 014E 
; 0000 014F while (1)
_0x20:
; 0000 0150       {
; 0000 0151       n=(float)read_adc(0)/4;   //n is a float variable
	LDI  R26,LOW(0)
	RCALL _read_adc
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40800000
	CALL __DIVF21
	__PUTD1S 10
; 0000 0152       c=read_adc(0)/4;   //c is a character variable
	LDI  R26,LOW(0)
	RCALL _read_adc
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	STS  _c,R30
; 0000 0153       if(k==0){
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x23
; 0000 0154       OCR1AL=c ; }
	OUT  0x2A,R30
; 0000 0155 
; 0000 0156 
; 0000 0157 
; 0000 0158 
; 0000 0159       if(l==0){
_0x23:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x24
; 0000 015A       T=(n*10);}
	CALL SUBOPT_0x9
; 0000 015B       temp[0]=T%10;
_0x24:
	MOVW R26,R16
	CALL SUBOPT_0xA
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 015C       temp[1]=(T/10)%10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	CALL SUBOPT_0xA
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 015D       temp[2]=(T/100)%10;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	CALL SUBOPT_0xA
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 015E 
; 0000 015F 
; 0000 0160       pd=0x01;
	LDI  R30,LOW(1)
	STD  Y+3,R30
; 0000 0161       for(i=0;i<3;i++){
	__GETWRN 20,21,0
_0x26:
	__CPWRN 20,21,3
	BRGE _0x27
; 0000 0162       PORTB=~pd;
	LDD  R30,Y+3
	COM  R30
	OUT  0x18,R30
; 0000 0163       PORTC=display[temp[i]];
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,14
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LDI  R26,LOW(_display)
	LDI  R27,HIGH(_display)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
; 0000 0164       if(i==1){PORTC+=0x80;}
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x28
	IN   R30,0x15
	SUBI R30,-LOW(128)
	OUT  0x15,R30
; 0000 0165       pd=pd<<1;
_0x28:
	LDD  R30,Y+3
	LSL  R30
	STD  Y+3,R30
; 0000 0166       delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0167        }
	__ADDWRN 20,21,1
	RJMP _0x26
_0x27:
; 0000 0168 
; 0000 0169       if(p==0){
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x29
; 0000 016A       putsf("to enter motors' settings press v");
	__POINTW2FN _0x0,82
	CALL SUBOPT_0xB
; 0000 016B       putchar('\n\r');
; 0000 016C       putsf("to enter time settings press t");
	__POINTW2FN _0x0,116
	CALL SUBOPT_0xB
; 0000 016D       putchar('\n\r');
; 0000 016E       putsf("to enter 7segments's settings press g");
	__POINTW2FN _0x0,147
	CALL _putsf
; 0000 016F       putchar('\n\r');
	CALL SUBOPT_0x2
; 0000 0170       putchar('\n\r');
; 0000 0171       p++;}
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0172 
; 0000 0173       //motors velocity
; 0000 0174       if(key=='v'){
_0x29:
	LDS  R26,_key
	CPI  R26,LOW(0x76)
	BRNE _0x2A
; 0000 0175       key=getchar();
	CALL SUBOPT_0x0
; 0000 0176 	  putsf("motor's settings:");
	__POINTW2FN _0x0,185
	CALL SUBOPT_0xB
; 0000 0177       putchar('\n\r');
; 0000 0178       putsf("set motors velocity or control it by temprature? press a or b");
	__POINTW2FN _0x0,203
	CALL SUBOPT_0xB
; 0000 0179       putchar('\n\r');
; 0000 017A       key=getchar();
	CALL SUBOPT_0x0
; 0000 017B 
; 0000 017C       if(key=='a'){
	LDS  R26,_key
	CPI  R26,LOW(0x61)
	BRNE _0x2B
; 0000 017D       putsf("velocity:");
	__POINTW2FN _0x0,265
	CALL SUBOPT_0xC
; 0000 017E       A=getchar();
; 0000 017F       B=getchar();
; 0000 0180       A=A-48;
; 0000 0181       B=B-48;
; 0000 0182       v=(A*10)+B;
	LDD  R30,Y+1
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R30,R26
	STD  Y+2,R30
; 0000 0183       printf("%d",v);
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	CALL SUBOPT_0x1
; 0000 0184       putchar('\n\r');
; 0000 0185       OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0186       OCR1AL=v ;}
	LDD  R30,Y+2
	OUT  0x2A,R30
; 0000 0187 
; 0000 0188       if(key=='b'){
_0x2B:
	LDS  R26,_key
	CPI  R26,LOW(0x62)
	BRNE _0x2C
; 0000 0189       OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 018A       OCR1AL=c ;
	LDS  R30,_c
	OUT  0x2A,R30
; 0000 018B       putsf("temperature control ok");
	__POINTW2FN _0x0,275
	CALL SUBOPT_0xB
; 0000 018C       putchar('\n\r');}
; 0000 018D 
; 0000 018E       k++;
_0x2C:
	__ADDWRN 18,19,1
; 0000 018F 
; 0000 0190       }
; 0000 0191 
; 0000 0192 
; 0000 0193        if(key=='t'){
_0x2A:
	LDS  R26,_key
	CPI  R26,LOW(0x74)
	BREQ PC+2
	RJMP _0x2D
; 0000 0194        getchar();
	RCALL _getchar
; 0000 0195 	   putsf("time settings");
	__POINTW2FN _0x0,298
	CALL _putsf
; 0000 0196          year=0;
	CLR  R4
	CLR  R5
; 0000 0197         putsf("  year:");
	__POINTW2FN _0x0,312
	CALL _putsf
; 0000 0198          for(j=0;j<4;j++){
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
_0x2F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,4
	BRGE _0x30
; 0000 0199          A=getchar();
	RCALL _getchar
	STD  Y+1,R30
; 0000 019A          A=A-48;
	SUBI R30,LOW(48)
	STD  Y+1,R30
; 0000 019B          year=10*year+A ;
	MOVW R30,R4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R4,R30
; 0000 019C          }
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x2F
_0x30:
; 0000 019D          printf("%d",year);
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x3
; 0000 019E 
; 0000 019F          putsf("  MONTH:");
	__POINTW2FN _0x0,320
	CALL SUBOPT_0xC
; 0000 01A0          A=getchar();
; 0000 01A1          B=getchar();
; 0000 01A2          A=A-48;
; 0000 01A3          B=B-48;
; 0000 01A4          mounth=(A*10)+B;
	CALL SUBOPT_0xD
; 0000 01A5          printf("%d",mounth);
; 0000 01A6 
; 0000 01A7          while(mounth>12){
_0x31:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x33
; 0000 01A8          putsf("  MONTH:");
	__POINTW2FN _0x0,320
	CALL SUBOPT_0xC
; 0000 01A9          A=getchar();
; 0000 01AA          B=getchar();
; 0000 01AB          A=A-48;
; 0000 01AC          B=B-48;
; 0000 01AD          mounth=(A*10)+B;
	CALL SUBOPT_0xD
; 0000 01AE          printf("%d",mounth);}
	RJMP _0x31
_0x33:
; 0000 01AF 
; 0000 01B0          putsf("  day:");
	__POINTW2FN _0x0,329
	CALL SUBOPT_0xC
; 0000 01B1          A=getchar();
; 0000 01B2          B=getchar();
; 0000 01B3          A=A-48;
; 0000 01B4          B=B-48;
; 0000 01B5          day=(A*10)+B;
	CALL SUBOPT_0xE
; 0000 01B6 
; 0000 01B7          while(day>31){
_0x34:
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x36
; 0000 01B8          putsf("  day:");
	__POINTW2FN _0x0,329
	CALL SUBOPT_0xC
; 0000 01B9          A=getchar();
; 0000 01BA          B=getchar();
; 0000 01BB          A=A-48;
; 0000 01BC          B=B-48;
; 0000 01BD          day=(A*10)+B;}
	CALL SUBOPT_0xE
	RJMP _0x34
_0x36:
; 0000 01BE 
; 0000 01BF          printf("%d",day);
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x5
; 0000 01C0 
; 0000 01C1          putsf("  hour:");
	__POINTW2FN _0x0,336
	CALL SUBOPT_0xC
; 0000 01C2 	   A=getchar();
; 0000 01C3          B=getchar();
; 0000 01C4          A=A-48;
; 0000 01C5          B=B-48;
; 0000 01C6          hour=(A*10)+B;
	CALL SUBOPT_0xF
	MOVW R10,R30
; 0000 01C7 
; 0000 01C8       while(hour>24){
_0x37:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x39
; 0000 01C9          putsf("  hour:");
	__POINTW2FN _0x0,336
	CALL SUBOPT_0xC
; 0000 01CA 	   A=getchar();
; 0000 01CB          B=getchar();
; 0000 01CC          A=A-48;
; 0000 01CD          B=B-48;}
	RJMP _0x37
_0x39:
; 0000 01CE          printf("%d",hour);
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x6
; 0000 01CF 
; 0000 01D0          putsf("  minute:");
	__POINTW2FN _0x0,344
	CALL SUBOPT_0xC
; 0000 01D1          A=getchar();
; 0000 01D2          B=getchar();
; 0000 01D3          A=A-48;
; 0000 01D4          B=B-48;
; 0000 01D5          minute=(A*10)+B;
	CALL SUBOPT_0xF
	MOVW R12,R30
; 0000 01D6          printf("%d",minute);
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x7
; 0000 01D7 
; 0000 01D8          while(minute>60){
_0x3A:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x3C
; 0000 01D9          putsf("  minute:");
	__POINTW2FN _0x0,344
	CALL SUBOPT_0xC
; 0000 01DA          A=getchar();
; 0000 01DB          B=getchar();
; 0000 01DC          A=A-48;
; 0000 01DD          B=B-48;
; 0000 01DE          minute=(A*10)+B;
	CALL SUBOPT_0xF
	MOVW R12,R30
; 0000 01DF          printf("%d",minute);}
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x7
	RJMP _0x3A
_0x3C:
; 0000 01E0 
; 0000 01E1          putsf("  second:");
	__POINTW2FN _0x0,354
	CALL SUBOPT_0xC
; 0000 01E2          A=getchar();
; 0000 01E3          B=getchar();
; 0000 01E4          A=A-48;
; 0000 01E5          B=B-48;
; 0000 01E6           second=(A*10)+B;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 01E7          printf("%d", second);
; 0000 01E8 
; 0000 01E9          while(second>60){
_0x3D:
	LDS  R26,_second
	LDS  R27,_second+1
	SBIW R26,61
	BRLT _0x3F
; 0000 01EA          putsf("  second:");
	__POINTW2FN _0x0,354
	CALL SUBOPT_0xC
; 0000 01EB          A=getchar();
; 0000 01EC          B=getchar();
; 0000 01ED          A=A-48;
; 0000 01EE          B=B-48;
; 0000 01EF           second=(A*10)+B;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
; 0000 01F0          printf("%d", second);}
	RJMP _0x3D
_0x3F:
; 0000 01F1          putchar('\n\r');
	CALL SUBOPT_0x2
; 0000 01F2          putchar('\n\r');
; 0000 01F3          putsf("to show the time,date and temprature press s");
	__POINTW2FN _0x0,364
	CALL _putsf
; 0000 01F4          putchar('\n\r');
	CALL SUBOPT_0x2
; 0000 01F5          putchar('\n\r');
; 0000 01F6 	    }
; 0000 01F7 
; 0000 01F8       if(key=='g'){
_0x2D:
	LDS  R26,_key
	CPI  R26,LOW(0x67)
	BRNE _0x40
; 0000 01F9       key=getchar();
	CALL SUBOPT_0x0
; 0000 01FA 	  putsf("7segment's settings:");
	__POINTW2FN _0x0,409
	CALL SUBOPT_0xB
; 0000 01FB       putchar('\n\r');
; 0000 01FC       putsf("Would you like to show an arbitrary number or the sensors temperature on 7 segment ? press a or b");
	__POINTW2FN _0x0,430
	CALL SUBOPT_0xB
; 0000 01FD       putchar('\n\r');
; 0000 01FE       key=getchar();
	CALL SUBOPT_0x0
; 0000 01FF 
; 0000 0200       if(key=='a'){
	LDS  R26,_key
	CPI  R26,LOW(0x61)
	BRNE _0x41
; 0000 0201       putsf("enter the number");
	__POINTW2FN _0x0,528
	CALL SUBOPT_0xC
; 0000 0202 
; 0000 0203       A=getchar();
; 0000 0204       B=getchar();
; 0000 0205       A=A-48;
; 0000 0206       B=B-48;
; 0000 0207       T=(A*10)+B;
	CALL SUBOPT_0xF
	MOVW R16,R30
; 0000 0208       printf("%d",T);
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 0209       putchar('\n\r');
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 020A       T=T*10;
	MOVW R30,R16
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R16,R30
; 0000 020B           }
; 0000 020C 
; 0000 020D       if(key=='b'){
_0x41:
	LDS  R26,_key
	CPI  R26,LOW(0x62)
	BRNE _0x42
; 0000 020E       T=(n*10);
	CALL SUBOPT_0x9
; 0000 020F       putsf("sensor temperature ok");
	__POINTW2FN _0x0,545
	CALL SUBOPT_0xB
; 0000 0210       putchar('\n\r');}
; 0000 0211 
; 0000 0212       l++;}
_0x42:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0213 
; 0000 0214       }
_0x40:
	RJMP _0x20
; 0000 0215 }
_0x43:
	RJMP _0x43
; .FEND

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putsf:
; .FSTART _putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020008
	MOV  R26,R17
	CALL _putchar
	RJMP _0x2020006
_0x2020008:
	LDI  R26,LOW(10)
	CALL _putchar
	LDD  R17,Y+0
	RJMP _0x20A0001
; .FEND
_put_usart_G101:
; .FSTART _put_usart_G101
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0001:
	ADIW R28,3
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x11
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x11
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x12
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x13
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x12
	CALL SUBOPT_0x14
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x11
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x13
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x11
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x13
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_second:
	.BYTE 0x2
_display:
	.BYTE 0x14
_key:
	.BYTE 0x1
_c:
	.BYTE 0x1
_comparematch:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0x8
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL _getchar
	STS  _key,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	LDI  R26,LOW(13)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(13)
	CALL _putchar
	LDI  R26,LOW(13)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_second
	LDS  R31,_second+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	__GETD2S 10
	__GETD1N 0x41200000
	CALL __MULF12
	CALL __CFD1
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	CALL _putsf
	LDI  R26,LOW(13)
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:129 WORDS
SUBOPT_0xC:
	CALL _putsf
	CALL _getchar
	STD  Y+1,R30
	CALL _getchar
	ST   Y,R30
	LDD  R30,Y+1
	SUBI R30,LOW(48)
	STD  Y+1,R30
	LD   R30,Y
	SUBI R30,LOW(48)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R6,R30
	__POINTW1FN _0x0,15
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0xF:
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	STS  _second,R30
	STS  _second+1,R31
	__POINTW1FN _0x0,15
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
