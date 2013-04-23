;/*
; * Test.asm
 ;*
; *  Created: 27/11/2012 01:38:35 p.m.
; *   Author: acer
 ;*/ 
	.DSEG
	.ORG	0x060
	MyReg : .BYTE 1
	Cant_ms : .Byte 2
	.EXIT

	.ORG 0x00
rjmp		main
;*******************	Vectores de interrupcion	***************

;******************************************************************

	.ORG 0x020
main:										
;***********************	Inciamos SP		**********************
ldi		R16,HIGH(0x045F)
out		SPH,R16
ldi		R16,LOW(0x045F)
out		SPL,R16
;******************************************************************

ldi		R16, 0xAA
sts		MyReg,R16
ser		R16								;Setea (pone en 1 R16)
out		DDRB,R16						;PORTB como salida
ser		R17
nop
Ciclo:
out		PORTB,R16						;Escribimos en PORTB

ldi		R16,LOW(1000)
sts		Cant_ms,R16
ldi		R16,HIGH(1000)
sts		Cant_ms+1,R16

rcall	delay_ms
nop
eor		R16,R17
rjmp	Ciclo

delay_ms:
ldi		R16,200
Ciclo_5us:
dec		R16
cpi		R16,0
breq	dms_P0
rjmp	Ciclo_5us
dms_P0:
lds		R16,Cant_ms
lds		R17,Cant_ms + 1
Ciclo_ms
dec		R16
tst		R16
breq	C_ms_H
rjmp	Ciclo_ms
C_ms_H:
dec		R17
tst		R17
breq	delay_ms_X
rjmp	Ciclo_ms
delay_ms_X:
ret

	.EXIT

