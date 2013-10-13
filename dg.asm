;---DG.ASM (DRAMATIC GRAPHICS)
;---ESTE FICHERO CONTIENE LAS SUBRUTINAS CUYAS FUNCIONES
;---SON GESTIONAR LOS GRAFICOS DEL JUEGO
;----------------------------------------------------
;               ---SUBRUTINAS---
;--- init ---
;       Cambia a modo texto 80x25, pone el tamano del cursor
;       a 1 y e inicializa la posicion del cursor.
;       No acepta parametros
;
;--- write_let ---
;       Escribe un caracter en pantalla, el estado de la pila es
;       el siguiente:
;
;       ANTES DE CALL: LETRA bp+20, COLOR bp+18, X bp+16, Y bp+14
;       DESPUES DE CALL: CS bp+12, IP bp+10
;       REGISTROS GUARDADOS: ax bp+8, bx bp+6, cx bp+4, dx bp+2,
;        bp bp+0
;
;       No se hace uso de variables locales
;       Esta subrutina no escribe el caracter si la X o la Y se salen de rango
;
;--- draw_car ---
;       Dibuja un coche haciendo uso de write_let, el estado de la pila es:
;
;       ANTES DE CALL: X bp+20, Y bp+18, SENT bp+16, TAM bp+14
;       DESPUES DE CALL: CS bp+12, IP bp+10
;       REGISTROS GUARDADOS: ax bp+8, bx bp+6, cx bp+4, dx bp+2, bp bp+0
;
;       nota: SENT es 1 o 0 e indica si va a la izquierda o la derecha
;
;--- draw_street ---
;       Dibuja una calle de coches       
;       Hay que pasarle un puntero a un array de tama¤os y otro a un
;       array de posiciones
;
;       ANTES DE CALL: Y bp+18, SENT bp+16, NUM_COCHES bp+14
;       SEG_ARRAY_TAM bp+12, OFF_ARRAY_TAM bp+10
;       SEG_ARRAY_POS bp+8, OFF_ARRAY_POS bp+6
;       
;       DESPUES DE CALL: CS bp+4, IP bp+2, BP bp+0
;       VARIABLE LOCAL: INDICE_DEL_ARRAY bp-2
;       REGISTROS GUARDADOS: AX bp-4, BX bp-6, CX bp-8, DX bp-10, SI bp-12
;
;--- draw_chipmunk ---
;       Dibuja el chipmunk en una X e Y
;
;       ANTES DE CALL: X bp+8, Y bp+6
;       DESPUES DE CALL: CS bp+4, IP bp+2, BP bp+0
;       REGISTROS GUARDADOS: AX bp-2
;
;--- clear_street ---
;	Borra una calle dado una Y
;
;	ANTES DE CALL: Y bp+6
;	DESPUES DE CALL: CS bp+4, IP bp+2
;	REGISTROS GUARDADOS: BP bp+0, AX bp-2, BX bp-4, CX bp-6,
;	DX bp-8

public init
public write_let
public draw_car
public draw_street
public draw_chipmunk
public clear_street
public hide_cursor
public draw_river
public draw_tronco
public draw_water
public draw_street_back
public draw_base
public limpia_msg

code segment
        assume cs:code
        init proc far

                push ax
                push bx
                push cx
                push dx

                mov ah, 00
                mov al, 03h
                int 10h         ;modo texto 80x25

                mov ah, 02h
                mov bh, 1
                mov dh, 15
                mov dl, 15
                int 10h         ;muevo el cursor

;               mov ah, 01
;               mov ch, 0
;               mov cl, 0
;               int 10h         ;ajusto tamano cursor

                pop dx
                pop cx
                pop bx
                pop ax

                ret
         init endp

         write_let proc far

                push ax
                push bx
                push cx
                push dx
                push bp
                mov bp, sp

                mov ax, ss:[bp+16]
                cmp ax, 79
                jg exit                 ;salta si la X es mayor que 79

                mov ax, ss:[bp+16]
                cmp ax, 0
                jl exit                 ;salta si la X es menor que 0

                mov ax, ss:[bp+14]
                sub ax, 24
                jg exit                 ;salta si la Y es mayor que 39

                mov ax, ss:[bp+14]
                cmp ax, 0
                jl exit                 ;salta si la Y es menor que 0

                mov ah, 02h
                mov bh, 1
                mov dh, ss:[bp+14]      ;cargo Y
                mov dl, ss:[bp+16]      ;cargo X
                int 10h
                
                mov al, ss:[bp+20]
                mov bh, 1
                mov bl, ss:[bp+18]
                mov cx, 1
                mov ah, 09
                int 10h         ;escribo

exit:           pop bp
                pop dx
                pop cx
                pop bx
                pop ax

                ret 8
         write_let endp
	
        draw_car proc far
		push ax
		push bx
		push cx
		push dx
		push bp
		mov bp, sp

                mov ax, ss:[bp+20]      ;guardo la var X
                mov bx, ss:[bp+18]      ;guardo la var Y 
		mov cx, ss:[bp+14]	;guardo el tam     
		inc cx
bloque_for:	loop bloque
                test cx, 0
                jz fin_bloque

bloque:         mov dx, 178
                push dx                 ;meto el caracter usado para el chasis
		mov dx, 4		
		push dx			;meto el color
		push ax
		push bx

                test WORD PTR ss:[bp+16], 1
                jz sent1                ;si sent = 1, incrementa la X
                dec ax                  ;si no, decrementa la X
                jmp sent0

sent1:          inc ax

sent0:          call write_let          ;dibuja
                jmp bloque_for		;fin del bucle
		
fin_bloque:	dec bx			;aqui empiezo a poner las ruedas
		mov dx, 'o'
		push dx
		mov dx, 5
		push dx
		push ax
		push bx
		call write_let		;escribo rueda 1

                inc bx
                mov dx, '='
                push dx
		mov dx, 4
		push dx
		push ax
		push bx
                call write_let          ;escribo tubo de escape-D 

		inc bx
		mov dx, 'o'		
		push dx
		mov dx, 5
		push dx
		push ax
		push bx
		call write_let		;escribo rueda 2

                mov ax, ss:[bp+20]
		mov bx, ss:[bp+18]
		dec bx
		mov dx, 'o'
		push dx
		mov dx, 5
		push dx
		push ax
		push bx
		call write_let		;escribo rueda 3

		add bx, 2
		mov dx, 'o'
		push dx
		mov dx, 5
		push dx
		push ax
		push bx
		call write_let		;escribo rueda 4

		dec bx

                test WORD PTR ss:[bp+16],1
                jz sent1d
                mov dx, 'D'
                inc ax
                jmp sent0d

sent1d:         mov dx, '('
                dec ax
sent0d:         push dx
		mov dx, 4
		push dx
		push ax
		push bx
		call write_let		;escribo el '('

		pop bp
		pop dx
		pop cx
		pop bx
		pop ax

                ret 8
		
	draw_car endp

        draw_street proc far

                push bp
                mov bp, sp
                sub sp, 2

                push ax
                push bx
                push cx
                push dx
                push si

                mov cx, ss:[bp+14]      ;cargo el numero de coches
                inc cx
                mov WORD PTR ss:[bp-2], 0        ;inicializo el offset

bcoche:         loop ini_bcoche
                test cx, 0
                jz fin_bcoche

ini_bcoche:     les si, ss:[bp+6]       ;si apunta al principio del tam_array
                add si, ss:[bp-2]       ;ajusto para que apunte al coche_act
                mov ax, es:[si]         ;cargo en ax la pos X
                les si, ss:[bp+10]
                add si, ss:[bp-2]
                mov bx, es:[si]         ;cargo en bx el tam

                push ax                 ;meto la X
                push ss:[bp+18]         ;meto la Y
                push ss:[bp+16]         ;meto el sentido
                push bx                 ;meto el tam
                call draw_car

                add WORD PTR ss:[bp-2], 2        ;el offset apuntara a otro coche
                jmp bcoche

fin_bcoche:     
                pop si
                pop dx
                pop cx
                pop bx
                pop ax
                add sp, 2
                pop bp

                ret 14

        draw_street endp

        draw_chipmunk proc far

                push bp
                mov bp, sp
                push ax
                push bx

                mov bx, ss:[bp+10]
                cmp bx,0
                je agach
                mov ax, 220
                jmp noagach
agach:          mov ax, 4
noagach:        push ax
                mov ax, 10               ;color
                push ax
                mov ax, ss:[bp+8]
                push ax
                mov ax, ss:[bp+6]
                push ax
                call write_let

                pop bx
                pop ax
                pop bp
                ret 6

        draw_chipmunk endp

        draw_water proc far

                push bp
		mov bp, sp
		push ax
		push bx
		push cx
		push dx

                mov ah, 02h
                mov bh, 1
                mov dx, ss:[bp+6]
                mov dh, dl
                mov dl, 0
                int 10h

                mov ah, 09h
                mov al, 219
                mov bh, 1
                mov bl, 1
                mov cx, 80
                int 10h

fin_irecta:     pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 2

        draw_water endp

        clear_street proc far		;se podria hacer mas eficiente
	
		push bp
		mov bp, sp
		push ax
		push bx
		push cx
		push dx

		mov cx, ss:[bp+6]	;cargo Y en cx
                dec cx                  ;ajusto para que sea el borde
                mov ch, cl              ;cargo en ch el principio
                mov dx, ss:[bp+6]
                inc dx                  ;ajusto para que este en el borde
		mov dh, dl		;cargo en dh el fin
		mov cl, 0
		mov dl, 79
                mov bh, 7
		mov al, 0
		mov ah, 06h
		int 10h

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

                ret 2

	clear_street endp	

        hide_cursor proc far
                push ax
                push bx
                push cx
                push dx

                mov ah, 02
                mov bh, 1
                mov dh, 25
                mov dl, 0
                int 10h

                pop dx
                pop cx
                pop bx
                pop ax

                ret
        hide_cursor endp

	draw_tronco proc far
		push bp
		mov bp, sp

		push ax
		push bx
		push cx
		push dx
		
		mov ax, ss:[bp+8]		;guardo la X
		mov bx, ss:[bp+6]		;guardo la Y

		mov cx, ss:[bp+10]		;guardo el tam del tronco
		inc cx				;la ajusto para el loop
		
ini_bdtronco:	loop bdtronco
		jmp fin_bdtronco

bdtronco:	push 219			;el char que uso para el tronco
		push 6				;color el tronco
		push ax
		push bx
		call write_let
		inc ax
		jmp ini_bdtronco

fin_bdtronco:	pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 6
	draw_tronco endp

	draw_river proc far
		push bp
		mov bp, sp
		sub sp, 2
		
		push ax
		push bx
		push cx
		push dx
		push si

                mov cx, ss:[bp+14]      ;cargo el numero de troncos
                inc cx
                mov WORD PTR ss:[bp-2], 0        ;inicializo el offset

btronco:        loop ini_btronco
                jmp fin_btronco

ini_btronco:    les si, ss:[bp+6]       ;si apunta al principio del tam_array
                add si, ss:[bp-2]       ;ajusto para que apunte al tronco_act
                mov ax, es:[si]         ;cargo en ax la pos X
                les si, ss:[bp+10]
                add si, ss:[bp-2]
                mov bx, es:[si]         ;cargo en bx el tam

                push bx                 ;meto el tam
                push ax                 ;meto la X
                push ss:[bp+16]         ;meto la Y
                call draw_tronco

                add WORD PTR ss:[bp-2], 2        ;el offset apuntara a otro tronco
                jmp btronco

fin_btronco:     
                pop si
                pop dx
                pop cx
                pop bx
                pop ax
                add sp, 2
                pop bp

                ret 12
		
	draw_river endp

        draw_street_back proc far           ;se podria hacer mas eficiente
	
		push bp
		mov bp, sp
		push ax
		push bx
		push cx
		push dx

		mov cx, ss:[bp+6]	;cargo Y en cx
                dec cx                  ;ajusto para que sea el borde
                mov ch, cl              ;cargo en ch el principio
                mov dx, ss:[bp+6]
                inc dx                  ;ajusto para que este en el borde
		mov dh, dl		;cargo en dh el fin
		mov cl, 0
		mov dl, 79
                mov bh, 1
		mov al, 0
		mov ah, 06h
		int 10h

		pop dx
		pop cx
		pop bx
		pop ax
		pop bp

		ret 2

        draw_street_back endp 

        draw_base proc far

                push ax
                push bx
                push cx
                push dx

                mov cx, 4
i1base:         loop lineax
                jmp fin_base

lineax:         dec cx
                mov bx, cx
                inc cx
                push cx
                mov cx, 81
i2base:         loop lineay
                jmp fin_b

lineay:         push 127
                push 3
                dec cx
                push cx
                inc cx
                push bx
                call write_let

                jmp i2base
fin_b:          pop cx
                jmp i1base

fin_base:
                push 127
                push 12
                push 40
                push 0
                call write_let

                push 127
                push 12
                push 39
                push 0
                call write_let

                push 127
                push 12
                push 38
                push 0
                call write_let

                push 127
                push 12
                push 41
                push 0
                call write_let

                push 127
                push 12
                push 42
                push 0
                call write_let

                push 127
                push 12
                push 40
                push 2
                call write_let

                push 127
                push 12
                push 40
                push 1
                call write_let

                push 127
                push 12
                push 39
                push 1
                call write_let

                push 127
                push 12
                push 41
                push 1
                call write_let

                pop dx
                pop cx
                pop bx
                pop ax

                ret

        draw_base endp

        limpia_msg proc far

                push ax
                push bx
                push cx
                push dx

                mov ch, 10       ;cargo Y en cx
                mov cl, 0              ;cargo en ch el principio

                mov dh, 15
                mov dl, 79
                mov bh, 7
		mov al, 0
		mov ah, 06h
		int 10h

                pop dx
                pop cx
                pop bx
                pop ax

                ret
        limpia_msg endp
code ends
end
