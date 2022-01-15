;   Copyright(c) 2018 Renesas Electronics Corporation
;   RENESAS ELECTRONICS CONFIDENTIAL AND PROPRIETARY.
;   This program must be used solely for the purpose for which
;   it was furnished by Renesas Electronics Corporation. No part of this
;   program may be reproduced or disclosed to others, in any
;   form, without the prior written permission of Renesas Electronics
;   Corporation.

;   NOTE       : THIS IS A TYPICAL EXAMPLE for SC for RH850/F1KM.
;   DATE       : Thu, Apr 12, 2018

	; if using eiint as table reference method,
	; enable next line's macro.
						
	USE_TABLE_REFERENCE_METHOD .set 1

;-----------------------------------------------------------------------------
;	exception vector table
;-----------------------------------------------------------------------------
	.section "RESET", text
	.align	512
	jr32	__start ; RESET

	.align	16
	syncp
	jr32	_Dummy ; SYSERR

	.align	16
	jr32	_Dummy

	.align	16
	jr32	_Dummy ; FETRAP

	.align	16
	jr32	_vPortYield ; TRAP0

	.align	16
	jr32	_Dummy_EI ; TRAP1

	.align	16
	jr32	_Dummy ; RIE

	.align	16
	syncp
	jr32	_Dummy_EI ; FPP/FPI

	.align	16
	jr32	_Dummy ; UCPOP

	.align	16
	jr32	_Dummy ; MIP/MDP

	.align	16
	jr32	_Dummy ; PIE

	.align	16
	jr32	_Dummy

	.align	16
	jr32	_Dummy ; MAE

	.align	16
	jr32	_Dummy

	.align	16
	syncp
	jr32	_Dummy ; FENMI

	.align	16
	syncp
	jr32	_Dummy ; FEINT

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority0)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority1)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority2)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority3)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority4)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority5)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority6)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority7)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority8)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority9)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority10)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority11)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority12)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority13)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority14)

	.align	16
	syncp
	jr32	_Dummy_EI ; INTn(priority15)

;	.section "EIINTTBL", const
;	.align	512
;	.dw	#_Dummy_EI ; INT0
;	.dw	#_Dummy_EI ; INT1
;	.dw	#_Dummy_EI ; INT2
;	.rept	512 - 3
;	.dw	#_Dummy_EI ; INTn
;	.endm

	.section ".text", text
	.align	2
_Dummy:
	br	_Dummy

_Dummy_EI:
	br	_Dummy_EI

;-----------------------------------------------------------------------------
;	startup
;-----------------------------------------------------------------------------
	.section	".text", text
	.align	2
__start:
$if 1	; initialize register
	$nowarning
	mov	r0, r1
	$warning
	mov	r0, r2
	mov	r0, r3
	mov	r0, r4
	mov	r0, r5
	mov	r0, r6
	mov	r0, r7
	mov	r0, r8
	mov	r0, r9
	mov	r0, r10
	mov	r0, r11
	mov	r0, r12
	mov	r0, r13
	mov	r0, r14
	mov	r0, r15
	mov	r0, r16
	mov	r0, r17
	mov	r0, r18
	mov	r0, r19
	mov	r0, r20
	mov	r0, r21
	mov	r0, r22
	mov	r0, r23
	mov	r0, r24
	mov	r0, r25
	mov	r0, r26
	mov	r0, r27
	mov	r0, r28
	mov	r0, r29
	mov	r0, r30
	mov	r0, r31
	ldsr	r0, 0, 0		;  EIPC
	ldsr	r0, 16, 0		;  CTPC
	;---------------------------------------------------------- Dinesh ----------------------------------------------
        ldsr    r0, 2, 0      ;FEPC
        ldsr    r0, 20, 0     ;CTBP
        ldsr    r0, 28, 0     ;EIWR
        ldsr    r0, 29, 0     ;FEWR
        ldsr    r0, 3, 1      ;EBASE
        ldsr    r0, 4, 1      ;INTBP
        ldsr    r0, 11, 1     ;SCCFG
        ldsr    r0, 12, 1     ;SCBP
        ldsr    r0, 6, 2      ;MEA
        ldsr    r0, 7, 2      ;ASID
        ldsr    r0, 8, 2      ;MEI
        ;PSW set -- CU0=1
        ;CU0 bit 16: FPU : These bits indicate the coprocessor use permissions. When the bit
                           ;corresponding to the coprocessor is 0, a coprocessor unusable exception
                           ;occurs if an instruction for the coprocessor is executed or a coprocessor
                           ;resource (system register) is accessed.
        ;PSW : (regID, selID) : 5,0 :SR5, 0
        stsr 5, r10, 0
        mov  0x00010000, r11
        or   r11, r10
        ldsr r10, 5, 0
        ;.set BOOT_MASK_FPSR             0x00020000        -- FS=1
        ;FPU : CU : related register
        mov  0x00020000, r11
        ldsr    r11, 6, 0    ;FPSR
        ldsr    r0,  7, 0    ;FPEPC
        ldsr    r0,  8, 0    ;FPST
        ldsr    r0,  9, 0    ;FPCC
        ldsr    r0,  10, 0   ;FPCFG
        ldsr    r0,  11,0    ;FPEC
        ;   -- First set EBASE register address
        mov #__sRESET, r10
        ;-- set 0x0 or 0x1 to EBASE.RINT for reduced interrupt
        ;-- ori  1, r10
        ldsr r10, 3, 1   ;EBASE = 3,1
        ;-- then set 1 to PSW.EBV -> RBASE!=EBASE
        stsr 5, r10, 0  ; PSW = 5,0
        mov  0x8000, r11    ; .set   EBV,  0x8000
        or   r11, r10
        ldsr r10, 5, 0  ; PSW = 5,0
        ; clear r10 & r11 register
        mov	r0, r10
        mov	r0, r11
        ;-- MPU Function registers
        ;ldsr    r0,     MCA, 5
        ;---------------------------------------------------------- Dinesh ----------------------------------------------
$endif

	jarl	_hdwinit, lp	; initialize hardware
$ifdef USE_TABLE_REFERENCE_METHOD
	mov	#__sEIINTTBL.const, r6
	jarl	_set_table_reference_method, lp ; set table reference method
$endif
	jr32	__cstart

;-----------------------------------------------------------------------------
;	hdwinit
; Specify RAM addresses suitable to your system if needed.
;-----------------------------------------------------------------------------
	GLOBAL_RAM_ADDR	.set	0
	GLOBAL_RAM_END	.set	0
	LOCAL_RAM_ADDR	.set	0xFEBF0000
	LOCAL_RAM_END	.set	0xFEBF7FFF

	.align	2
_hdwinit:
	mov	lp, r14			; save return address

	; clear Global RAM
	mov	GLOBAL_RAM_ADDR, r6
	mov	GLOBAL_RAM_END, r7
	jarl	_zeroclr4, lp

	; clear Local RAM
	mov	LOCAL_RAM_ADDR, r6
	mov	LOCAL_RAM_END, r7
	jarl	_zeroclr4, lp

	mov	r14, lp
	jmp	[lp]

;-----------------------------------------------------------------------------
;	zeroclr4
;-----------------------------------------------------------------------------
	.align	2
_zeroclr4:
	br	.L.zeroclr4.2
.L.zeroclr4.1:
	st.w	r0, [r6]
	add	4, r6
.L.zeroclr4.2:
	cmp	r6, r7
	bh	.L.zeroclr4.1
	jmp	[lp]

$ifdef USE_TABLE_REFERENCE_METHOD
;-----------------------------------------------------------------------------
;	set table reference method
;-----------------------------------------------------------------------------
	; interrupt control register address
	ICBASE	.set	0xfffeea00

	.align	2
_set_table_reference_method:
	ldsr	r6, 4, 1		; set INTBP

	; Some interrupt channels use the table reference method.
;	mov	ICBASE, r10		; get interrupt control register address
;	set1	6, 0[r10]		; set INT0 as table reference
;	set1	6, 2[r10]		; set INT1 as table reference
;	set1	6, 4[r10]		; set INT2 as table reference

	jmp	[lp]
$endif
;-------------------- end of start up module -------------------;
