;---LOGIC.ASM
;---ESTE FICHERO CONTIENE LAS SUBRUTINAS CUYAS FUNCIONES
;---SON GESTIONAR LA LOGICA DEL JUEGO
;----------------------------------------------------
;               ---SUBRUTINAS---
MAX_VAL EQU 79
MIN_VAL EQU 0

EXTRN draw_chipmunk:far
EXTRN write_let:far

public mod_array
public move_chipmunk
public get_position
public fix_array
public read_location

code segment
        assume cs:code

        mod_array proc far
                push bp
                mov bp, sp
                sub sp, 2

                push ax
                push bx
                push cx
                push dx
                push si

                mov cx, ss:[bp+6]       ;cargo el numero de coches
                inc cx                  ;lo ajusto para el bucle
                mov WORD PTR ss:[bp-2], 0       ;inic el offset que usare

barray:         loop ini_barray
                jmp fin_barray

ini_barray:     les si, ss:[bp+8]
                add si, ss:[bp-2]
                
                mov ax, es:[si]
                add ax, ss:[bp+12]      
                mov WORD PTR es:[si], ax
                add WORD PTR ss:[bp-2], 2

                jmp barray

fin_barray:     pop si
                pop dx
                pop cx
                pop bx
                pop ax
                add sp, 2
                pop bp
                
                ret 8
        mod_array endp

        move_chipmunk proc far
;a este proc se le pueden hacer mejoras de rendimiento
                push bp
                mov bp, sp

                push ax
                push bx
                push cx
                push dx
                push si

                mov ax, ss:[bp+6]               ;cargo el code
                cmp ax, 3                       ;si es 4 entonces no se mueve
                jg fin_mov


;borro la traza en este bloque  (PUEDE QUE NO HAGA FALTA CON EL CAMBIO DE ORDEN EN EL MAIN)

;               push ' '
;               push 0          
;               les si, ss:[bp+12]              ;cargo posX
;               mov bx, es:[si]
;               push bx                         ;meto posX en pila
;               les si, ss:[bp+8]               ;cargo posY
;               mov bx, es:[si]                 
;               push bx                         ;meto posY en pila
;               call write_let                  ;al escribir este char se borra la traza
;

;en este bloque analizo el code

                mov dx, WORD PTR ss:[bp+16]
                cmp dx, 0
                jl es_negativo
                jmp siguexx
es_negativo:    neg dx
                mov WORD PTR ss:[bp+16], dx
siguexx:        cmp ax, 0
                je mov_arriba
                cmp ax, 1
                je mov_derecha
                cmp ax, 2
                je mov_abajo
                cmp ax, 3
                je mov_izquierda

mov_arriba:     
                les si, ss:[bp+8]               ;ahora posy esta en es:[si]
                mov cx, es:[si]                 ;ahora posy esta en cx
                sub cx, WORD PTR ss:[bp+16]
                mov WORD PTR es:[si], cx
                jmp fin_mov
mov_derecha:    
                les si, ss:[bp+12]              ;ahora posx esta en es:[si]
                mov cx, es:[si]                 ;ahora posx esta en bx
                add cx, WORD PTR ss:[bp+16]
                mov WORD PTR es:[si], cx
                jmp fin_mov
mov_abajo:      
                les si, ss:[bp+8]               ;ahora posy esta en es:[si]
                mov cx, es:[si]                 ;ahora posy esta en cx
                add cx, WORD PTR ss:[bp+16]
                mov WORD PTR es:[si], cx
                jmp fin_mov
mov_izquierda:  
                les si, ss:[bp+12]              ;ahora posx esta en es:[si]
                mov cx, es:[si]                 ;ahora posx esta en bx
                sub cx, WORD PTR ss:[bp+16]
                mov WORD PTR es:[si], cx
                jmp fin_mov

fin_mov:        

;imprimo el chipmunk con su nueva posicion

                les si, ss:[bp+12]              ;cargo posX
                mov bx, es:[si]
                mov ax, WORD PTR ss:[bp+18]
                push ax
                push bx                         ;meto posX en pila
                les si, ss:[bp+8]               ;cargo posY
                mov bx, es:[si]                 
                push bx                         ;meto posY en pila
                call draw_chipmunk

                pop si
                pop dx
                pop cx
                pop bx
                pop ax

                pop bp

                ret 14

        move_chipmunk endp

        get_position proc far

                push bp
                mov bp, sp

                push ax
                push bx                 ;bx lo utilizare para almacenar el code
                push dx
                push si

                mov al, 0
                mov ah, 1
                mov bx, 4               ;si no hay nada en teclado no lo muevo
                int 16h
                jnz hay_char
                jmp no_char

hay_char:       mov ah, 0
                int 16h
                mov dx, ss:[bp+12]
                cmp ah, dl
                je char_izq
                mov dx, ss:[bp+10]
                cmp ah, dl
                je char_der
                mov dx, ss:[bp+16]
                cmp ah, dl
                je char_up
                mov dx, ss:[bp+14]
                cmp ah, dl
                je char_down
                cmp al, 'q'
                je char_quit
                cmp al, 'p'
                je char_pul
                cmp ah, 1
                je char_esc
                cmp ah, 28
                je char_ent
                jmp no_char

char_izq:       mov bx, 3
                jmp no_char

char_der:       mov bx, 1
                jmp no_char

char_up:        mov bx, 0
                jmp no_char

char_down:      mov bx, 2
                jmp no_char

char_quit:      mov bx, 5
                jmp no_char

char_pul:       mov bx, 6
                jmp no_char

char_esc:       mov bx, 7
                jmp no_char

char_ent:       mov bx, 8
                jmp no_char
no_char:        
                les si, ss:[bp+6]
                mov WORD PTR es:[si], bx

                pop si
                pop dx
                pop bx
                pop ax
                pop bp

                ret 12

        get_position endp

        fix_array proc far
                push bp
                mov bp, sp
                sub sp, 2

                push ax
                push bx
                push cx
                push dx
                push si

                mov WORD PTR ss:[bp-2], 0       ;inicializo el futuro indice
                mov cx, ss:[bp+6]
                inc cx                          ;lo ajusto para el loop

ibucle_item:    loop b_item
                jmp b_enditem

b_item:         les si, ss:[bp+12]              ;cargo la posicion
                add si, ss:[bp-2]               ;ajusto el indice
                mov ax, es:[si]                 ;en ax tengo la pos
                les si, ss:[bp+8]               ;cargo el tam
                add si, ss:[bp-2]               ;ajusto el indice
                mov bx, es:[si]                 ;en bx tengo el tam

                mov dx, 0                       ;para usar luego el cmp

                shr bx, 1                       ;divido el tam entre 2
                cmp WORD PTR ss:[bp+16], 1
                je otro_sent
                add ax, bx                      ;le sumo a la pos el tam/2
                jmp sigo
otro_sent:      sub ax, bx
                jmp sigo

sigo:           cmp dx, ax
                jg sale_izquierda
                cmp ax, 79
                jg sale_derecha
                jmp no_sale

sale_izquierda: cmp WORD PTR ss:[bp+16], 1      ;si sale por la izq pero
                je no_sale                      ;se mueve a der, no pasa nada
                les si, ss:[bp+12]
                add si, ss:[bp-2]
                neg ax
                add ax, 79                      ;lo ajusto para que salga por la der 
                mov WORD PTR es:[si], ax        ;la nueva posicion
                jmp no_sale

sale_derecha:   cmp WORD PTR ss:[bp+16], 0
                je no_sale
                les si, ss:[bp+12]
                add si, ss:[bp-2]
                sub ax, 78
                neg ax
                mov WORD PTR es:[si], ax        ;la nueva posicion
                jmp no_sale

no_sale:        add WORD PTR ss:[bp-2], 2
                jmp ibucle_item

b_enditem:      pop si
                pop dx
                pop cx
                pop bx
                pop ax

                add sp, 2
                pop bp  

                ret 12

        fix_array endp

        read_location proc far
                push bp
                mov bp, sp

                push ax
                push bx
                push cx
                push dx
                push si

                mov dl, ss:[bp+12]              ;cargo la pos X
                mov dh, ss:[bp+10]              ;cargo la pos Y
                mov ah, 02h                     ;para mover el cursor con int 10h
                mov bh, 1                       ;para que 10h(2) se haga en pagina 0
                int 10h                         ;muevo el cursor

                mov ah, 08h
                int 10h                         ;leo lo que hay

                mov al, ah
                mov ah, 0

                cmp al, 7
                je no_hay_nada
                jmp hay_algo

no_hay_nada:
                mov dl, ss:[bp+12]
                mov dh, ss:[bp+10]
                mov ah, 02h
                mov bh, 1
                dec dl
                int 10h

                mov ah, 08h
                int 10h

                mov al, ah
                mov ah, 0

                cmp al, 5
                je hay_rueda
                jmp hay_algo

hay_rueda:      mov dl, ss:[bp+12]
                mov dh, ss:[bp+10]
                mov ah, 02h
                mov bh, 1
                dec dh
                int 10h

                mov ah, 08h
                int 10h

                mov al, ah
                mov ah, 0

                cmp al, 4
                jne hay_algo
                mov al, 15

hay_algo:

                les si, ss:[bp+6]
                mov WORD PTR es:[si], ax        ;ahora la var externa tiene el valor del codigo
                                
next_center:    pop si
                pop dx
                pop cx
                pop bx
                pop ax
                pop bp

                ret 8
        read_location endp
code ends
end
