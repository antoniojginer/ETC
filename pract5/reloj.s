                ##########################################################
                # Segmento de datos
                ##########################################################

                .data 0x10000000
reloj:          .word 0                # HH:MM:SS (3 bytes de menor peso)

cad_asteriscos: .asciiz "\n  **************************************"
cad_horas:      .asciiz "\n   Horas: "
cad_minutos:    .asciiz " Minutos: "
cad_segundos:   .asciiz " Segundos: "
cad_reloj_en_s: .asciiz "\n   Reloj en segundos: "

                ##########################################################
                # Segmento de código
                ##########################################################

                .globl __start
                .text 0x00400000

__start:        la $a0, reloj
		li $a1, 66765
		jal inicializa_reloj_en_s
		
		la $a0, reloj
		jal imprime_reloj		
		
             
salir:          li $v0, 10              # Código de exit (10)
                syscall                 # Última instrucción ejecutada
                .end


                ########################################################## 
                # Subrutina que imprime el valor del reloj
                # Entrada: $a0 con la dirección de la variable reloj
                ########################################################## 

imprime_reloj:  move $t0, $a0
                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                la $a0, cad_horas       # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                lbu $a0, 2($t0)         # Lee el campo HH
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_minutos     # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                lbu $a0, 1($t0)         # Lee el campo MM
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_segundos    # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                lbu $a0, 0($t0)         # Lee el campo SS
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall
                jr $ra

                ########################################################## 
                # Subrutina que imprime los segundos calculados
                # Entrada: $a0 con los segundos a imprimir
                ########################################################## 

imprime_s:      move $t0, $a0
                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall


                la $a0, cad_reloj_en_s  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                move $a0, $t0           # Valor entero a imprimir
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall
                jr $ra
                
                ########################################################## 
                # Subrutina que incrementa el reloj en una hora
                # Entrada: $a0 con la dirección del reloj
                # Salida: reloj incrementado en memoria
                # Nota: 23:MM:SS -> 00:MM:SS
                ########################################################## 
                
pasa_hora:      lbu $t0, 2($a0)         # $t0 = HH
                addiu $t0, $t0, 1       # $t0 = HH++
                li $t1, 24
                beq $t0, $t1, H24       # Si HH==24 se pone HH a cero
                sb $t0, 2($a0)          # Escribe HH++
                j fin_pasa_hora
H24:            sb $zero, 2($a0)        # Escribe HH a 0
fin_pasa_hora:  jr $ra

inicializa_reloj:
		sw $a1, 0($a0)
		jr $ra

inicializa_reloj_alt:
		sb $a1, 2($a0)
		sb $a2, 1($a0)
		sb $a3, 0($a0) 
		jr $ra

inicializa_reloj_hh:
		sb $a1, 2($a0)
		jr $ra
	
inicializa_reloj_mm:
		sb $a1, 1($a0)
		jr $ra

inicializa_reloj_ss:
		sb $a1, 0($a0)
		jr $ra	

devuelve_reloj_en_s:
		lbu $t0, 2($a0)
		li $t1, 3600
		mult $t0, $t1
		mflo $t0		# h=s
		lbu $t1, 1($a0)
		li $t2, 60
		mult $t1, $t2
		mflo $t1		# m=s	
		add $t0, $t0, $t1	# h+s
		lbu $t1, 0($a0)
		add $v0, $t0, $t1	# v0=total
		jr $ra

inicializa_reloj_en_s:
		li $a2, 60
		div $a1, $a2
		mflo $t1		
		mfhi $t2		# segundos
		div $t1, $a2
		mflo $t4		# horas
		mfhi $t3		# minutos			
		sb $t2, 0($a0)
		sb $t3, 1($a0)
		sb $t4, 2($a0)
		jr $ra	
		