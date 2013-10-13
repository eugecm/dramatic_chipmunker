EXTRN get_position:far
EXTRN retardo:far
EXTRN hide_cursor:far
EXTRN write_let:far
public load_intro

data segment
        boton_up_click dw 0
        boton_down_click dw 0
        boton_left_click dw 0
        boton_right_click dw 0 

        boton_teclado dw 0

        tecla_code dw 0
        hay_click_flag dw 0


        raton_x dw 0
        raton_y dw 0
        raton_x_raw dw 0
        raton_y_raw dw 0
        click_boton dw 0
        click_boton_b dw 0
        divisor dw 8
        display_ins dw 0

        bt1_text db 'JUGAR$'
        bt2_text db 'INSTRUCCIONES$'

        cadena1 db 'ESTO ES UNA PRUEBA','$'
        cad_name db 'Dramatic Chipmunker$'
        cad_name2 db 'Eugenio Cano-Manuel M.$'
        cad_ins1 db 'El juego consiste en llegar hasta las fresas que$'
        cad_ins2 db 'se encuentra en la parte roja del bosque.$'
        cad_ins3 db 'Para llegar alli tienes que pasar la autovia$'
        cad_ins4 db 'sin que te pillen los coches, puedes usar el$'
        cad_ins5 db 'pulsador para agacharte y quedar debajo, esto$'
        cad_ins6 db 'se puede hacer 3 veces.$'
        cad_ins7 db 'Despues de los coches tienes que saltar entre$'
        cad_ins8 db 'los troncos pero cuidado! al saltar de un$'
        cad_ins9 db 'tronco a otro lleveras el impulso del anterior!$'
        cad_ins10 db 'Controles por defecto: flechas (direccion) ESC(salir).$'

        cad_tecla0 db 'Haz click en los cuadros$'
        cad_tecla0b db 'para seleccionar las teclas$'
        cad_tecla1 db 'Tecla ARRIBA [ ]$'
        cad_tecla2 db 'Tecla ABAJO [ ]$'
        cad_tecla3 db 'Tecla IZQUIERDA [ ]$'
        cad_tecla4 db 'Tecla DERECHA [ ]$'
data ends

code segment
        assume cs:code, ds:data

        load_intro proc far
                push bp
                mov bp, sp

                push ax
                push bx
                push cx
                push dx

                mov ax, data
                mov ds, ax

                mov ah, 06h
                mov al, 0
                mov bh, 7
                mov cx, 0
                mov dh, 24
                mov dl, 79
                int 10h

                mov ax, 1
                int 33h

;PONGO LOS NOMBRES

                mov ah, 02h
                mov bh, 1
                mov dh, 3      ;cargo Y
                mov dl, 30      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_name
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 4      ;cargo Y
                mov dl, 29      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_name2
                int 21h

;DIBUJO PARTE DE ARRIBA
                push 79
                push 205
                push 6
                push 0
                push 0
                call write_let_2

;DIBUJO PARTE DE ABAJO
                push 79
                push 205
                push 6
                push 0
                push 24
                call write_let_2
;DIBUJO LATERAL1
                mov cx, 25
ilat1buc:       loop lat1buc
                jmp fin_lat1buc

lat1buc:        dec cx
                push 1
                push 186
                push 6
                push 0
                push cx
                call write_let_2
                inc cx
                jmp ilat1buc

fin_lat1buc:

;DIBUJO LATERAL2
                mov cx, 25
ilat2buc:       loop lat2buc
                jmp fin_lat2buc

lat2buc:        dec cx
                push 1
                push 186
                push 6
                push 79
                push cx
                call write_let_2
                inc cx
                jmp ilat2buc

fin_lat2buc:
;ESQUINAS
                push 1
                push 201
                push 6
                push 0
                push 0
                call write_let_2

                push 1
                push 188
                push 6
                push 79
                push 24
                call write_let_2

                push 1
                push 200
                push 6
                push 0
                push 24
                call write_let_2

                push 1
                push 187
                push 6
                push 79
                push 0
                call write_let_2

;CREO EL BOTON 1
                push 20
                push 219
                push 7
                push 10
                push 6
                call write_let_2

                push 20
                push 219
                push 7
                push 10
                push 7
                call write_let_2

                push 20
                push 219
                push 7
                push 10
                push 8
                call write_let_2

;CREO EL BOTON 2
                push 20
                push 219
                push 7
                push 50
                push 6
                call write_let_2

                push 20
                push 219
                push 7
                push 50
                push 7
                call write_let_2

                push 20
                push 219
                push 7
                push 50
                push 8
                call write_let_2

                mov ah, 02h
                mov bh, 1
                mov dh, 7      ;cargo Y
                mov dl, 17      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET bt1_text
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 7      ;cargo Y
                mov dl, 53      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET bt2_text
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 13
                mov dl, 50
                int 10h
                
                mov ah, 9
                mov dx, OFFSET cad_tecla0
                int 21h               
                
                mov ah, 02h
                mov bh, 1
                mov dh, 14
                mov dl, 50
                int 10h
                
                mov ah, 9
                mov dx, OFFSET cad_tecla0b
                int 21h               
                

                mov ah, 02h
                mov bh, 1
                mov dh, 15
                mov dl, 50
                int 10h
                
                mov ah, 9
                mov dx, OFFSET cad_tecla1
                int 21h               

                mov ah, 02h
                mov bh, 1
                mov dh, 16
                mov dl, 50
                int 10h
                
                mov ah, 9
                mov dx, OFFSET cad_tecla2
                int 21h               

                mov ah, 02h
                mov bh, 1
                mov dh, 17
                mov dl, 50
                int 10h
                
                mov ah, 9
                mov dx, OFFSET cad_tecla3
                int 21h               

                mov ah, 02h
                mov bh, 1
                mov dh, 18
                mov dl, 50
                int 10h
                
                mov ah, 9
                mov dx, OFFSET cad_tecla4
                int 21h               

                                                                                                
                call hide_cursor ;DE PRUEBA

ibucin:         cmp tecla_code, 7
                jne nonono
                les si, ss:[bp+6]
                mov WORD PTR es:[si], 1
                jmp fin_intro
                jmp nonono
nonono:         cmp click_boton, 1
                je fin_intro_gate
                jmp sigo_1

fin_intro_gate: jmp fin_intro

sigo_1:
;VEO SI EL RATON SE HA PRESIONADO, EN ESE CASO VEO SU POSICION
                push ax
                push bx
                push cx
                push dx

                mov ax, 3
                int 33h

                mov raton_x_raw, cx
                mov raton_y_raw, dx

                and bx, 1
                cmp bx, 1
                je hay_boton
                mov hay_click_flag, 0
                jmp no_hay_boton

hay_boton:      mov hay_click_flag, 1                

no_hay_boton:   pop dx
                pop cx
                pop bx
                pop ax


;VEO SI SE HA PRESIONADO EL ESCAPE
                cmp boton_teclado, 1
                je salta_leer_tecla

empieza:        push 62
                push 62
                push 62
                push 62
                push SEG tecla_code
                push OFFSET tecla_code
                call get_position               

salta_leer_tecla:
;ANALIZO SI LE HA DADO AL BOTON O NO

                mov ax, raton_x_raw
                mov dx, 0
                div divisor
                mov raton_x, ax
                mov ax, raton_y_raw
                mov dx, 0
                div divisor
                mov raton_y, ax

                cmp hay_click_flag, 1
                je si_hay
                jmp le_dio_nada

si_hay:         mov hay_click_flag, 0
                cmp raton_y, 6
                jge ebt_y1
                jmp no_hayb
ebt_y1:         cmp raton_y, 8
                jle ebt_y_bien
                jmp no_hayb
ebt_y_bien:     cmp raton_x, 10
                jge ebt_x1
                jmp no_hayb
ebt_x1:         cmp raton_x, 30
                jle ebt_x_bien
                jmp no_hayb
ebt_x_bien:     mov click_boton, 1
                jmp no_hayb


no_hayb:         cmp raton_y, 6
                jge ebt_y1b
                jmp no_hay
ebt_y1b:         cmp raton_y, 8
                jle ebt_y_bienb
                jmp no_hay
ebt_y_bienb:     cmp raton_x, 50
                jge ebt_x1b
                jmp no_hay
ebt_x1b:         cmp raton_x, 70
                jle ebt_x_bienb
                jmp no_hay
ebt_x_bienb:     mov click_boton_b, 1
                jmp no_hay


no_hay:         
;AQUI VEO SI HA PRESIONADO LOS CUADROS DE LAS TECLAS
                
                cmp raton_x, 64
                je puede_1
                cmp raton_x, 63
                je puede_2
                cmp raton_x, 67
                je puede_3
                cmp raton_x, 65
                je puede_4
                jmp le_dio_nada

puede_1:        cmp raton_y, 15
                jne le_dio_nada
                mov boton_up_click, 1
                mov boton_teclado, 1
                mov ah, 02h
                mov bh, 1
                mov dh, 15
                mov dl, 64
                int 10h
                jmp le_dio_nada
puede_2:        cmp raton_y, 16
                jne le_dio_nada
                mov boton_down_click, 1
                mov boton_teclado, 1
                mov ah, 02h
                mov bh, 1
                mov dh, 16
                mov dl, 63
                int 10h
                jmp le_dio_nada
puede_3:        cmp raton_y, 17
                jne le_dio_nada
                mov boton_left_click, 1
                mov boton_teclado, 1
                mov ah, 02h
                mov bh, 1
                mov dh, 17
                mov dl, 67
                int 10h
                jmp le_dio_nada
puede_4:        cmp raton_y, 18
                jne le_dio_nada
                mov boton_right_click, 1
                mov boton_teclado, 1
                mov ah, 02h
                mov bh, 1
                mov dh, 18
                mov dl, 65
                int 10h
                jmp le_dio_nada

le_dio_nada:    cmp click_boton_b, 1
                je rutina_b
                jmp pre_fin

rutina_b:       cmp display_ins, 0
                je vale_guay
                jmp pre_fin
vale_guay:
                mov click_boton_b, 0
;AQUI VA LO QUE QUIERAS QUE OCURRA CUANDO SE PRESIONA EL BOTON 2

                mov ah, 02h
                mov bh, 1
                mov dh, 11      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins1
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 12      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins2
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 13      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins3
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 14      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins4
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 15      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins5
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 16      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins6
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 17      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins7
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 18      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins8
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 19      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins9
                int 21h

                mov ah, 02h
                mov bh, 1
                mov dh, 20      ;cargo Y
                mov dl, 2      ;cargo X
                int 10h

                mov ah, 9
                mov dx, OFFSET cad_ins10
                int 21h


                call hide_cursor
                
;AQUI TERMINA Xd
                mov display_ins, 1
                jmp pre_fin

pre_fin:        cmp tecla_code, 8
                jne no_es_enter2
                jmp fin_intro
no_es_enter2:   
                cmp boton_teclado, 1
                je okok2
                jmp no_es_enter

okok2:          mov boton_teclado, 0
                mov ah, 00h
                int 16h
                
                cmp boton_up_click, 1
                je r_boton1
                cmp boton_down_click, 1
                je r_boton2
                cmp boton_left_click, 1
                je r_boton3
                cmp boton_right_click, 1
                jmp r_boton4
                
r_boton1:       mov boton_up_click, 0
                mov bh, ah
                mov ah, 0
                push ax
                push 7
                push 64
                push 15
                call write_let
                les si, ss:[bp+22]
                mov bl, bh
                mov bh, 0
                mov es:[si], bx
                jmp no_quiere_input

r_boton2:       mov boton_down_click, 0
                mov bh, ah
                mov ah, 0
                push ax
                push 7
                push 63
                push 16
                call write_let
                les si, ss:[bp+18]
                mov bl, bh
                mov bh, 0
                mov es:[si], bx
                jmp no_quiere_input

r_boton3:       mov boton_left_click, 0
                mov bh, ah
                mov ah, 0
                push ax
                push 7
                push 67
                push 17
                call write_let
                les si, ss:[bp+14]
                mov bl, bh
                mov bh, 0
                mov es:[si], bx
                jmp no_quiere_input

r_boton4:       mov boton_right_click, 0
                mov bh, ah
                mov ah, 0
                push ax
                push 7
                push 65
                push 18
                call write_let
                les si, ss:[bp+10]
                mov bl, bh
                mov bh, 0
                mov es:[si], bx
                jmp no_quiere_input

no_quiere_input:
no_es_enter:    jmp ibucin

fin_intro:      mov ax, 2
                int 33h

                pop dx
                pop cx
                pop bx
                pop ax
                pop bp
                
                ret 20
        load_intro endp

        write_let_2 proc
                push ax
                push bx
                push cx
                push dx
                push bp
                mov bp, sp

                mov ax, ss:[bp+14]
                cmp ax, 79
                jg exit                 ;salta si la X es mayor que 79

                mov ax, ss:[bp+14]
                cmp ax, 0
                jl exit                 ;salta si la X es menor que 0

                mov ax, ss:[bp+12]
                sub ax, 24
                jg exit                 ;salta si la Y es mayor que 39

                mov ax, ss:[bp+12]
                cmp ax, 0
                jl exit                 ;salta si la Y es menor que 0

                mov ah, 02h
                mov bh, 1
                mov dh, ss:[bp+12]      ;cargo Y
                mov dl, ss:[bp+14]      ;cargo X
                int 10h
                
                mov al, ss:[bp+18]
                mov bh, 1
                mov bl, ss:[bp+16]
                mov cx, ss:[bp+20]
                mov ah, 09
                int 10h         ;escribo

exit:           pop bp
                pop dx
                pop cx
                pop bx
                pop ax

                ret 10
        write_let_2 endp
code ends
end
