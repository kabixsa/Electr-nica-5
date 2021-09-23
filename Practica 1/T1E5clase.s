		AREA    codigo, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start

Start
    VLDR.F32 S0, =30    ;Valor del numero factorial a operar n! 
    VLDR.F32 S1, =1     ;Registro para guardar el valor del factorial
    VLDR.F32 S2, =3.33  ; Valor x del argumento a operar en cos(x)
    VLDR.F32 S4, =2        ;Constante 2
    VLDR.F32 S5, =-1    ;Valor de n
    VLDR.F32 S30, =1    ;Constante 1

Constantes
    VMOV.F32 S3, S0        ;Limite superior de la serie
    VMUL.F32 S6, S3, S4 ;2n para el factorial y el exponente de x
    VLDR.F32 S7, =1        ;registro para guardar el resultado de (-1)^n
    VLDR.F32 S8, =1        ;registro para guardar el resultado del factorial
    VMOV.F32 S9, #1        ;registro para guardar el resultado de x^2n
    ;VMOV.F32 S12, S3    ;registro para n de factor (-1)^n

Factor1 ; rutina para obtener el signo de (-1)^n
    VCMP.F32 S3, #0 ;
    VMRS APSR_nzcv, FPSCR
    BEQ Factorial
    VMUL.F32 S7, S5
    VSUB.F32 S3, S1
    B Factor1

Factorial ; rutina para obtener el factorial de (2n)! y la potencia x^2n
    ;Multiplicar el valor de n y el resultado acumulado
    VCMP.F32 S6, #0     ;Verificar si se ha llegado a 1 (ya no quedarian numeros por multiplicar)
    VMRS APSR_nzcv, FPSCR; trasladar bandera APSR a FPSCR
    BEQ Sumatoria
    VMUL.F32 S8, S6 ;factorial (n)(n-1)(n-2)...
    VMUL.F32 S9, S2 ;potencia xxxx... n veces
    VSUB.F32 S6, S30 ;Sustraer uno al valor actual de n
    B Factorial; si n no es igual a 1 seguir operando

Sumatoria
    VDIV.F32 S10, S9, S8 ;se divide a = (x^2n)/(2n)!
    VMUL.F32 S10, S7 ; se multiplica a*(-1)^n
    VADD.F32 S11, S10 ; se guarda el resultado de este valor de n
    VCMP.F32 S0, #0 ; ;se compara si n ya llego a 0
    VMRS APSR_nzcv, FPSCR
    BEQ done
    VSUB.F32 S0, S1; Se resta 1 al n
    B Constantes

done B done

    ALIGN
    END