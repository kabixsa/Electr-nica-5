;---------Reloj de la Tiva--------------------------------
SYSCTL_RCGCGPIO_R 	   EQU 0x400FE608
	
;PUERTO B	
;---------Modo Analógico----------------------------------
GPIO_PORTB_AMSEL_R     EQU 0x40005528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTB_PCTL_R      EQU 0x4000552C;
;---------Especificación de dirección---------------------
GPIO_PORTB_DIR_R      EQU   0x40005400;
;---------Funciones Alternativas--------------------------
GPIO_PORTB_AFSEL_R    EQU   0x40005420;
;---------Habilita el modo digital------------------------
GPIO_PORTB_DEN_R      EQU   0x4000551C;
;---------PIN PB3-----------------------------------------
PB3                   EQU 0x40005020; Esta suma se realiza en hexadecimal

;PUERTO F
;---------Modo Analógico----------------------------------
GPIO_PORTF_AMSEL_R     EQU 0x40025528;
;---------Permite desactivarFuncion Alternativa-----------
GPIO_PORTF_PCTL_R      EQU 0x4002552C;
;---------Especificación de dirección---------------------
GPIO_PORTF_DIR_R      EQU   0x40025400;
;---------Funciones Alternativas--------------------------
GPIO_PORTF_AFSEL_R    EQU   0x40025420;
;---------Habilita el modo digital------------------------
GPIO_PORTF_DEN_R      EQU   0x4002551C;
;---------PIN PF2-----------------------------------------
PF2                   EQU 0x40025010

Cont				  EQU 45000000
		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start


Start
	BL Hola; Salto, guarda la dirección posterior en el Registro 14
	B  LedRojo ; Salto

Hola
;---------Reloj para el puerto B-------------------------
	LDR R1, =SYSCTL_RCGCGPIO_R; Asignación de valores de constante a un registro.
	LDR R0, [R1]
	ORR R0, R0, #0x02 ; Valor para activar el puerto F, si se quiere encender otro puerto, se debe cambiar.
	STR R0, [R1]
	NOP
	NOP

;---------Reloj para el puerto F-------------------------
	LDR R1, =SYSCTL_RCGCGPIO_R; Asignación de valores de constante a un registro.
	LDR R0, [R1]
	ORR R0, R0, #0x20 ; Valor para activar el puerto F, si se quiere encender otro puerto, se debe cambiar.
	STR R0, [R1]
	NOP
	NOP


;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTB_AMSEL_R;
	LDR R0, [R1]
	BIC R0, R0, #0x08; Valor segun el numero del puerto. Se realiza la suma de los valores en hexadecimal.
	STR R0, [R1]

;--------Desactiva la función analógica------------------
	LDR R1, =GPIO_PORTF_AMSEL_R;
	LDR R0, [R1]
	BIC R0, R0, #0x04; Valor segun el numero del puerto. Se realiza la suma de los valores en hexadecimal.
	STR R0, [R1]


;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTB_PCTL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x0000F000;  Configura el puerto como GPIO. 
	STR R0, [R1]

;--------Permite deshabilitar las funciones alternativas-
	LDR R1, =GPIO_PORTF_PCTL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x00000F00;  Configura el puerto como GPIO. 
	STR R0, [R1]



;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTB_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x08;  Output. Valor segun el numero del puerto.
	STR R0, [R1]


;--------Configuración como I/O--------------------------
	LDR R1, =GPIO_PORTF_DIR_R 
	LDR R0, [R1]
	ORR R0, R0, #0x04;  Output. Valor segun el numero del puerto.
	STR R0, [R1]
	

;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTB_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x08;  Desabilita las demas funciones. 
	STR R0, [R1]
	
;--------Deshabilita las funciones alternativas----------	
	LDR R1, =GPIO_PORTF_AFSEL_R 
	LDR R0, [R1]
	BIC R0, R0, #0x04;  Desabilita las demas funciones. 
	STR R0, [R1]


;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x08;		Activa el puerto digital.    
    STR R0, [R1]   


;--------Habilita el puerto como entrada y salida digital-
	LDR R1, =GPIO_PORTF_DEN_R       
    LDR R0, [R1]                    
    ORR	 R0,#0x04;		Activa el puerto digital.    
    STR R0, [R1] 
	
	
;--------Salto, regresa a la linea posterior al salto BL---
	BX LR
	
;--------Contador de iteraciones---------------------------

Contador
	SUB R10, #1
	CMP R10, #0
	BNE Contador
	BX LR



;--------Activar PB3 ----------------------------------
LedRojo
	LDR R1, =PB3
	MOV R0, #0x08; Encender el bit.
	STR R0, [R1];
	LDR R10, =Cont
	BL Contador

LedRojoLow
	LDR R1, =PB3
	MOV R0, #0x00; Apagar el bit.
	STR R0, [R1];
	LDR R10, =1
	BL Contador

LedAmarillo
	LDR R1, =PF2
	MOV R0, #0x04; Encender el bit.
	STR R0, [R1];
	LDR R10, =Cont
	BL Contador

LedAmarilloLow
	LDR R1, =PF2
	MOV R0, #0x00; Apagar el bit.
	STR R0, [R1];
	LDR R10, =1
	BL Contador
	BL LedRojo


	ALIGN
	END