EXTRN init:far
EXTRN write_let:far
EXTRN draw_car:far
EXTRN draw_street:far
EXTRN draw_chipmunk:far
EXTRN retardo:far
EXTRN mod_array:far
EXTRN clear_street:far
EXTRN hide_cursor:far
EXTRN move_chipmunk:far
EXTRN draw_river:far
EXTRN get_position:far
EXTRN fix_array:far
EXTRN draw_tronco:far
EXTRN read_location:far
EXTRN draw_water:far
EXTRN draw_street_back:far
EXTRN draw_base:far
EXTRN load_intro:far
EXTRN limpia_msg:far

var segment
;//CALLES//
        acoche1_tam dw 3,4,3
        acoche1_pos dw 15,37,60
        acoche1_sent dw 0
        acoche1_speed dw -3
        acoche1_ncoches dw 3
        acoche1_y dw 20

        acoche2_tam dw 5,8,4,3
        acoche2_pos dw 10,21,47,63
        acoche2_sent dw 1
        acoche2_speed dw 2
        acoche2_ncoches dw 4
        acoche2_y dw 17

        acoche3_tam dw 3,4,3,4,3
        acoche3_pos dw 15,30,45,60,75
        acoche3_sent dw 0
        acoche3_speed dw -1
        acoche3_ncoches dw 5
        acoche3_y dw 14

;//RIOS
        atronco1_tam dw 7,7,7,5
        atronco1_pos dw 13,44,56,70
        atronco1_sent dw 1
        atronco1_speed dw 2
        atronco1_ntroncos dw 4
        atronco1_y dw 6

        atronco2_tam dw 4,4,4,4,4
        atronco2_pos dw 15,30,45,60,75
        atronco2_sent dw 0
        atronco2_speed dw -1
        atronco2_ntroncos dw 5
        atronco2_y dw 5

        atronco3_tam dw 4,4,4
        atronco3_pos dw 13,44,70
        atronco3_sent dw 1
        atronco3_speed dw 2
        atronco3_ntroncos dw 3
        atronco3_y dw 4
        
        chip_x dw 40
        chip_y dw 24
        move_code dw 4
        muerto dw 0
        vidas dw 3
        esta_en_tronco_flag dw 0
        block_code dw 0

        water_color dw 1
        street_color dw 3
        ha_ganado_flag dw 0
        inv_mode dw 0
        inv_coche_flag dw 0
        pulsador_contador dw 0

        off_ori dw 0
        seg_ori dw 0

        toff_ori dw 0
        tseg_ori dw 0

        conta dw 0
        usado dw 0

        ha_ganado_msg db 'HA GANADO$'
        ha_perdido_msg db 'HA PERDIDO$'

        key_up dw 72
        key_down dw 80
        key_left dw 75
        key_right dw 77

        ha_salido_en_menu dw 0
var ends
                        
pila segment stack
        dw 256 dup (0)
pila ends

code segment
        assume cs:code, ds:var
        main proc
                mov ax, var
                mov ds, ax
                ;call init
                mov ah, 5
                mov al, 1
                int 10h
                
                push SEG key_up
                push OFFSET key_up
                push SEG key_down
                push OFFSET key_down
                push SEG key_left
                push OFFSET key_left
                push SEG key_right
                push OFFSET key_right
                push SEG ha_salido_en_menu
                push OFFSET ha_salido_en_menu
                call load_intro
                
                mov ax, var
                mov ds, ax
                mov cx, 60
                
;VEO SI HA SALIDO EN EL MENU
                cmp ha_salido_en_menu, 1
                jne no_menu_exit
                jmp fuera_del_juego

;CARGO COSAS                            
no_menu_exit:
                mov ah, 06h
                mov al, 0
                mov bh, 7
                mov ch, 0
                mov cl, 0
                mov dh, 24
                mov dl, 79
                int 10h
                
                call cargar_pulsador
                call cargar_timer
redo:		call inicializar
;DIBUJO BASE
                call draw_base
;EXPERIMENTAL
                push ax
                push bx
                push cx
                push dx

                mov ah, 3
                mov al, 5
                mov bl, 1fh
                mov bh, 3
                int 16h

                pop dx
                pop cx
                pop bx
                pop ax

;DIBUJO CALLE 1

;                push acoche1_y
;               call draw_street_back

                push acoche1_y
                push acoche1_sent
                push acoche1_ncoches
                push SEG acoche1_tam
                push OFFSET acoche1_tam
                push SEG acoche1_pos
                push OFFSET acoche1_pos
                call draw_street

;DIBUJO CALLE 2

;                push acoche2_y
;                call draw_street_back

                push acoche2_y
                push acoche2_sent
                push acoche2_ncoches
                push SEG acoche2_tam
                push OFFSET acoche2_tam
                push SEG acoche2_pos
                push OFFSET acoche2_pos
                call draw_street
                
;DIBUJO CALLE 3
;                push acoche3_y
;                call draw_street_back

                push acoche3_y
                push acoche3_sent
                push acoche3_ncoches
                push SEG acoche3_tam
                push OFFSET acoche3_tam
                push SEG acoche3_pos
                push OFFSET acoche3_pos
                call draw_street

;DIBUJO RIO 1
                push atronco1_y
                call draw_water

                push atronco1_y
                push atronco1_ntroncos
                push SEG atronco1_tam
                push OFFSET atronco1_tam
                push SEG atronco1_pos
                push OFFSET atronco1_pos
                call draw_river

;DIBUJO RIO 2

                push atronco2_y
                call draw_water

                push atronco2_y
                push atronco2_ntroncos
                push SEG atronco2_tam
                push OFFSET atronco2_tam
                push SEG atronco2_pos
                push OFFSET atronco2_pos
                call draw_river

;DIBUJO RIO 3
                push atronco3_y
                call draw_water

                push atronco3_y
                push atronco3_ntroncos
                push SEG atronco3_tam
                push OFFSET atronco3_tam
                push SEG atronco3_pos
                push OFFSET atronco3_pos
                call draw_river

ini_buc:        cmp muerto, 0
                je buc1
                jmp fin_juego

buc1:           cmp move_code, 7
                jne sasasa
                jmp fuera_del_juego
sasasa:         cmp move_code, 5
                jne buc2
                jmp fin_juego
buc2:

;LIMPIO CALLES
                push acoche1_y
                call clear_street
                push acoche2_y
                call clear_street
                push acoche3_y
                call clear_street

;LIMPIO RIOS
                push atronco1_y
                call clear_street
                push atronco2_y
                call clear_street
                push atronco3_y
                call clear_street

;LIMPIO LA TRAZA DEL CHIPMUNK
                push ' '
                push 0
                push chip_x
                push chip_y
                call write_let

;LEO LO QUE HAY EN EL BUFFER DE TECLADO, LO ANALIZO Y LO DEVUELVO POR MOVE_CODE
                push key_up
                push key_down
                push key_left
                push key_right
                push SEG move_code                      ;aqui empiezo a tratar el chipmunk
                push OFFSET move_code
                call get_position                       ;busca que hay en el teclado

;COMPRUEBO SI ESTA EN MODO PULSADOR
                cmp pulsador_contador, 3
                jge no_se_ha_pulsado
                cmp move_code, 6
                je se_ha_pulsado
                jmp no_se_ha_pulsado

se_ha_pulsado:  inc pulsador_contador
                mov inv_mode, 1
                jmp no_se_ha_pulsado

no_se_ha_pulsado:
;MUEVO EL CHIPMUNK EN FUNCION DEL MOVE_CODE
                push inv_mode
                push 1
                push SEG chip_x
                push OFFSET chip_x
                push SEG chip_y
                push OFFSET chip_y
                push move_code
                call move_chipmunk


;DIBUJO CALLE 1
;                push acoche1_y
;                call draw_street_back

                push acoche1_y
                push acoche1_sent
                push acoche1_ncoches
                push SEG acoche1_tam
                push OFFSET acoche1_tam
                push SEG acoche1_pos
                push OFFSET acoche1_pos
                call draw_street

;DIBUJO CALLE 2
;                push acoche2_y
;                call draw_street_back

                push acoche2_y
                push acoche2_sent
                push acoche2_ncoches
                push SEG acoche2_tam
                push OFFSET acoche2_tam
                push SEG acoche2_pos
                push OFFSET acoche2_pos
                call draw_street

;DIBUJO CALLE 3
;                push acoche3_y
;                call draw_street_back

                push acoche3_y
                push acoche3_sent
                push acoche3_ncoches
                push SEG acoche3_tam
                push OFFSET acoche3_tam
                push SEG acoche3_pos
                push OFFSET acoche3_pos
                call draw_street

;DIBUJO RIO 1
                push atronco1_y
                call draw_water

                push atronco1_y
                push atronco1_ntroncos
                push SEG atronco1_tam
                push OFFSET atronco1_tam
                push SEG atronco1_pos
                push OFFSET atronco1_pos
                call draw_river

;DIBUJO RIO 2
                push atronco2_y
                call draw_water

                push atronco2_y
                push atronco2_ntroncos
                push SEG atronco2_tam
                push OFFSET atronco2_tam
                push SEG atronco2_pos
                push OFFSET atronco2_pos
                call draw_river

;DIBUJO RIO 3
                push atronco3_y
                call draw_water

                push atronco3_y
                push atronco3_ntroncos
                push SEG atronco3_tam
                push OFFSET atronco3_tam
                push SEG atronco3_pos
                push OFFSET atronco3_pos
                call draw_river

;DIBUJO LA BASE
                call draw_base

;AJUSTO LAS POSICIONES DE LOS COCHES
                push acoche1_speed
                push SEG acoche1_pos
                push OFFSET acoche1_pos
                push acoche1_ncoches
                call mod_array

                push acoche2_speed
                push SEG acoche2_pos
                push OFFSET acoche2_pos
                push acoche2_ncoches
                call mod_array

                push acoche3_speed
                push SEG acoche3_pos
                push OFFSET acoche3_pos
                push acoche3_ncoches
                call mod_array

;AJUSTO LAS POSICIONES DE LOS TRONCOS
                push atronco1_speed
                push SEG atronco1_pos
                push OFFSET atronco1_pos
                push atronco1_ntroncos
                call mod_array

                push atronco2_speed
                push SEG atronco2_pos
                push OFFSET atronco2_pos
                push atronco2_ntroncos
                call mod_array

                push atronco3_speed
                push SEG atronco3_pos
                push OFFSET atronco3_pos
                push atronco3_ntroncos
                call mod_array

;ARREGLO LAS POSICIONES DE LOS COCHES EN CASO DE QUE SALGAN DE LA PANTALLA
                push acoche1_sent
                push SEG acoche1_pos
                push OFFSET acoche1_pos
                push SEG acoche1_tam
                push OFFSET acoche1_tam
                push acoche1_ncoches
                call fix_array

                push acoche2_sent
                push SEG acoche2_pos
                push OFFSET acoche2_pos
                push SEG acoche2_tam
                push OFFSET acoche2_tam
                push acoche2_ncoches
                call fix_array

                push acoche3_sent
                push SEG acoche3_pos
                push OFFSET acoche3_pos
                push SEG acoche3_tam
                push OFFSET acoche3_tam
                push acoche3_ncoches
                call fix_array

;ARREGLO LAS POSICIONES DE LOS TRONCOS EN CASO DE QUE SE SALGAN DE LA PANTALLA
                push atronco1_sent
                push SEG atronco1_pos
                push OFFSET atronco1_pos
                push SEG atronco1_tam
                push OFFSET atronco1_tam
                push atronco1_ntroncos
                call fix_array

                push atronco2_sent
                push SEG atronco2_pos
                push OFFSET atronco2_pos
                push SEG atronco2_tam
                push OFFSET atronco2_tam
                push atronco2_ntroncos
                call fix_array

                push atronco3_sent
                push SEG atronco3_pos
                push OFFSET atronco3_pos
                push SEG atronco3_tam
                push OFFSET atronco3_tam
                push atronco3_ntroncos
                call fix_array



;VEO DONDE ESTA EL CHIPMUNK Y LO DEVUELVO POR BLOCK_CODE
                push chip_x
                push chip_y
                push SEG block_code
                push OFFSET block_code
                call read_location                      ;con esto veo que hay encima del chipmunk

;ESTO ENSE¥A EL TABLERO

;ESTE ES EL CORAZON
                push 3
                push 4
                push 0
                push 24
                call write_let

;ESTO ES EL NUMERO DE VIDAS QUE QUEDAN

                push dx
                mov dx, vidas
                add dx, 48
                push dx
                push 3
                push 1
                push 24
                call write_let
                pop dx

                
                
;ESTO ES EL ICONO DE LA FUNCION DE AGACHAR
                
                push 4
                push 1
                push 3
                push 24
                call write_let

;ESTO ES EL NUMERO DE PULSADORES QUE QUEDAN

                mov ax, pulsador_contador
                mov bx, 3
                sub bx, ax
                add bx, 48
                push bx
                push 3
                push 4
                push 24
                call write_let

;ANALIZO EL BLOCK_CODE PARA SABER QUE HACER
                cmp block_code, 4
                je debajo_coche
                cmp block_code, 5
                je debajo_coche
                cmp block_code, 15
                je debajo_coche
                cmp block_code, 1
                je dentro_rio
                cmp block_code, 6
                je encima_tronco
                cmp block_code, 12
                je ha_ganado_pass
                jne nada_pass

;SI ESTA DEBAJO DE UN COCHE
debajo_coche:   mov inv_coche_flag, 1
                cmp inv_mode, 1
                jne debajo2                 ;si esta debajo de un coche y esta en modo inv, no pasa nada
                mov inv_coche_flag, 1
                jmp nada
debajo2:        dec vidas
                mov chip_x, 40
                mov chip_y, 24
                mov inv_coche_flag, 0
                jmp nada

;SI ESTA DENTRO DEL RIO
dentro_rio:     dec vidas
                mov chip_x, 40
                mov chip_y, 24
                mov inv_coche_flag, 0
                jmp nada

;SI ESTA ENCIMA DE UN TRONCO
encima_tronco:  mov ax, chip_y
                cmp ax, atronco1_y
                je es_tronco1
                cmp ax, atronco2_y
                je es_tronco2
                jmp es_tronco3

es_tronco1:     push inv_mode
                push chip_x
                push chip_y
                call draw_chipmunk
                push ax
                mov ax, chip_x
                add ax, atronco1_speed
                mov chip_x, ax
                pop ax

                jmp nada


ha_ganado_pass: jmp ha_ganado                   ;ESTO ES PARA QUE LOS SALTOS RELATIVOS
nada_pass:      jmp nada2                        ;PUEDAN LLEGAR A HA_GANADO Y NADA


es_tronco2:     push inv_mode
                push chip_x
                push chip_y
                call draw_chipmunk
                push ax
                mov ax, chip_x
                add ax, atronco2_speed
                mov chip_x, ax
                pop ax

                jmp nada

es_tronco3:     push inv_mode
                push chip_x
                push chip_y
                call draw_chipmunk
                push ax
                mov ax, chip_x
                add ax, atronco3_speed
                mov chip_x, ax
                pop ax
                jmp nada

ha_ganado:      mov ha_ganado_flag, 1
                jmp fin_juego

;aqui actualizo el inv_mode en caso de que salga o no de un coche
nada2:          cmp inv_mode, 1                 ;ESTA MODO INV?
                jne nada
                cmp inv_coche_flag, 1           ;ESTABA DEBAJO DE UN COCHE?
                jne nada
                mov inv_mode, 0
                mov inv_coche_flag, 0
                jmp nada

nada:           cmp vidas, 0
                jne no_ha_muerto
                mov muerto, 1

no_ha_muerto:
                call hide_cursor

;ME ASEGURO QUE EL CHIPMUNK NO SALE DE LA PANTALLA
                cmp chip_x, 79
                jg se_sale_der
                cmp chip_x, 0
                jl se_sale_izq
                cmp chip_y, 0
                jl se_sale_arriba
                cmp chip_y, 24
                jg se_sale_abajo
                jmp nosale

se_sale_der:    mov chip_x, 79
                jmp nosale
se_sale_izq:    mov chip_x, 0
                jmp nosale
se_sale_arriba: mov chip_y, 0
                jmp nosale
se_sale_abajo:  mov chip_y, 24
                jmp nosale

nosale:
                push ax
                push dx

                mov dx, 378h
                cmp vidas, 3
                jne tendra_2
                mov al, 00000111b
                jmp ready
tendra_2:       cmp vidas, 2
                jne tendra_1
                mov al, 00000011b
                jmp ready
tendra_1:       mov al, 00000001b
ready:          out dx, al
                
                pop dx
                pop ax
                mov bx, 1                       ;ARREGLAR ESTO
ibuctimer:      cmp conta, bx
                jg sale_del_b
                jmp ibuctimer
sale_del_b:     mov conta, 0           
                mov usado, 0
                jmp ini_buc

fin_juego:      cmp ha_ganado_flag, 1
                jne ha_p
                call limpia_msg

                push ' '
                push 7
                push 35
                push 10
                call write_let

                mov ah, 9
                mov dx, OFFSET ha_ganado_msg
                int 21h

                jmp fuera
ha_p:           call limpia_msg

                push ' '
                push 7
                push 35
                push 10
                call write_let

                mov ah, 9
                mov dx, OFFSET ha_perdido_msg
                int 21h

                jmp fuera
fuera:          call hide_cursor

                mov dx, 378h
                mov al, 0
                out dx, al

                mov bx, 55
ibuctimer2:     cmp conta, bx
                jg sale_del_b2
                jmp ibuctimer2
sale_del_b2:    mov conta, 0 
                call limpia_msg
                jmp redo
                
fuera_del_juego:
;LIMPIO LA PANTALLA
                mov ah, 06h
                mov al, 0
                mov bh, 7
                mov ch, 0
                mov cl, 0
                mov dh, 24
                mov dl, 79
                int 10h
                cmp ha_salido_en_menu, 1
                je no_devuelve_nada
                call devolver_timer
                call devolver_pulsador
no_devuelve_nada:
                mov ah, 5
                mov al, 0
                int 10h
;ADIOS          
                mov ax, 4c00h
                int 21h
        main endp

        devolver_pulsador proc
                
                push ax
                push bx
                push cx
                push dx

                mov ax, 0
                mov es, ax

                mov dx, 37ah
                in al, dx
                and al, 11101111b
                out dx, al

                in al, 21h
                or al, 10000000b
                out 21h, al

                mov dx, off_ori
                mov ax, seg_ori

                cli
                mov es:[3ch], dx
                mov es:[3ch+2], ax
                sti

                pop dx
                pop cx
                pop bx
                pop ax

                ret
                
        devolver_pulsador endp

        cargar_pulsador proc
                push ax
                push bx
                push cx
                push dx
                push es

                mov ax, 0
                mov es, ax

                mov bx, es:[3ch]
                mov off_ori, bx
                mov bx, es:[3ch+2]
                mov seg_ori, bx

                
                mov bx, OFFSET pulsado
                mov cx, SEG pulsado

                cli
                mov es:[3ch], bx
                mov es:[3ch+2], cx
                sti

                mov dx, 37ah
                in al, dx
                or al, 00011001b        ;CONECTO CON IRQ7 y DEJO QUE LEA PARA LOS LEDS
                out dx, al

                in al, 21h
                and al, 01111111b
                out 21h, al

                pop es
                pop dx
                pop cx
                pop bx
                pop ax

                ret
        cargar_pulsador endp

        proc pulsado

                push ax
                push ds

                mov ax, var
                mov ds, ax
                
                cmp usado, 0
                jne no_se_puede_usar
                mov usado, 1                
                cmp pulsador_contador, 2
                jg no_se_puede_usar
                mov inv_mode, 1
                inc pulsador_contador
no_se_puede_usar:
                mov al, 00100000b
                out 20h, al                     ;EOI

                pop ds
                pop ax

                iret
                
        endp pulsado
        cargar_timer proc
                               
                push ax
                push bx
                push cx
                push dx

                mov ax, 0
                mov es, ax

                mov ax, es:[1ch*4]
                mov dx, es:[1ch*4+2]

                mov toff_ori, ax
                mov tseg_ori, dx

                mov ax, offset mi_timer
                mov dx, seg mi_timer

                cli
                mov es:[1ch*4], ax
                mov es:[1ch*4+2], dx
                sti

                pop dx
                pop cx
                pop bx
                pop ax

                ret

        cargar_timer endp

        mi_timer proc
                push ax
                push ds

                mov ax, var
                mov ds, ax

                inc conta

                pop ds
                pop ax

                iret

        mi_timer endp
        devolver_timer proc

                push ax
                push bx
                push cx
                push dx

                mov ax, 0
                mov es, ax

                mov ax, toff_ori
                mov bx, tseg_ori

                cli
                mov es:[1ch*4], ax
                mov es:[1ch*4+2], bx
                sti

                pop dx
                pop cx
                pop bx
                pop ax

                ret
                     
            devolver_timer endp
	inicializar proc

		mov chip_x, 40
       		mov chip_y, 24
        	mov move_code, 4
        	mov muerto, 0
        	mov vidas, 3
        	mov esta_en_tronco_flag, 0
        	mov block_code, 0

        	mov water_color, 1
        	mov street_color, 3
        	mov ha_ganado_flag, 0
        	mov inv_mode, 0
        	mov inv_coche_flag, 0
        	mov pulsador_contador, 0

        	mov conta, 0
        	mov usado, 0

		ret

	inicializar endp
code ends
end main
