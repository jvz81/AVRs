/*
 * Test.asm
 *
 *  Created: 27/11/2012 01:38:35 p.m.
 *   Author: acer
 */ 

;*******************	Definicion de Constantes	*****************
;********************************************************************
.EQU	DIR_FIN_RAM	 =	0x045F
.EQU	var = 0x00
;********************************************************************

;***********************	Zona Internal SRAM 	*********************
;********************************************************************
.DSEG
.ORG	0x060
	MyReg : .BYTE 1
	Cant_ms : .BYTE 2
;********************************************************************

;*******************	Inicio Program Memory 	*********************
;********************************************************************
.CSEG
.ORG 0x00									;Vector de Reset

	rjmp		Inicio
;*******************	Vectores de interrupcion	*****************
;********************************************************************

.ORG 0x020
Inicio:										
;***********************	Inciamos SP		*************************
;********************************************************************
	ldi		R16,HIGH(DIR_FIN_RAM)			;R16 = HIGH(DIR_FIN_RAM)
	out		SPH,R16							;SPH = R16
	ldi		R16,LOW(DIR_FIN_RAM)			;R16 = LOW(DIR_FIN_RAM)
	out		SPL,R16							;SPL = R16
;********************************************************************

;*******************	Configuracion de E/S	*********************
;********************************************************************
	ser		R16								;Setea (pone en 1 R16)
	out		DDRB,R16						;PORTB como salida
;********************************************************************
	clr		R16								;R16 = 0
Ciclo:
	out		PORTB,R16						;PORTB = R16

	ldi		R18,LOW(2000)
	ldi		R19,HIGH(2000)					;R19:R18 = 1000
	rcall	delay_ms

	com		R16								;Negamos R16
	rjmp	Ciclo
;********************************************************************

delay_ms:
	ldi		R20,200
Ciclo_5us:
	dec		R20
	cpi		R20,0
	breq	dms_P0
	rcall	del_5u
	rjmp	Ciclo_5us
dms_P0:

Ciclo_ms:
	dec		R18
	tst		R18
	breq	C_ms_H
	rjmp	delay_ms	
C_ms_H:
	tst		R19
	breq	delay_ms_X
	dec		R19
	rjmp	delay_ms
delay_ms_X:
	ret

del_5u:
	ldi		R21,10
del_5u_C:
	dec		R21
	tst		R21
	breq	del_5u_X
	rjmp	del_5u_C
del_5u_X:
	ret

.EXIT

