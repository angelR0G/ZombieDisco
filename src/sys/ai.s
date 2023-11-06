;.include "cpctelera.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "sys/ai.h.s"

sys_ai_move_to::
    push ix
    pop iy

    xor a
    call man_entity_get
    ;enemy entity -> iy
    ;player entity -> ix
    ld c, #0
    ld a, e_x(ix)
    sub e_x(iy)
    jr nc, _posx_greater_or_equal
    _posx_lesser:
        ld e_vx(iy), #-1
        jr _endif_x
    _posx_greater_or_equal:
        jr z, _arrived_x
        ld e_vx(iy), #1
        jr _endif_x 
    _arrived_x:
        ld e_vx(iy), #0
        ld c, #1
    _endif_x:

    ld a, e_y(ix)
    sub e_y(iy)
    jr nc, _posy_greater_or_equal
    _posy_lesser:
        ld e_vx(iy), #-2
        jr _endif_y
    _posy_greater_or_equal:
        jr z, _arrived_y
        ld e_vy(iy), #2
        jr _endif_y 
    _arrived_y:
        ld e_vy(iy), #0
        ld a, c
        or a
        jr nz, _endif_y
            xor a
            ld e_vx(iy), a
            ld e_vy(iy), a
    _endif_y:
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia 
;;Input: ix: entidad
sys_ai_left_right::
    ld a, e_x(ix)
    cp #0
    jr nz, no_izq
        ld e_vx(ix), #1
    no_izq:
        ld a, e_x(ix)
        push af
        ld a, #80
        sub e_w(ix)
        ld b, a
        pop af
        cp b
        jr nz, end_if
            ld e_vx(ix), #-1
    end_if:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia 
;;Movimiento rebote
;;Input: ix: entidad
sys_ai_twist::
    ld a, e_x(ix)
    sub #B_LEFT
    jr nc, tw_no_izq
        ;Tope izquierda
        ;Moverse derecha
        ld e_vx(ix), #1
    tw_no_izq:
        ;No tope izquierda
        ld a, e_x(ix)
        sub #B_RIGHT
        add e_w(ix)
        jr nc, tw_end_if
            ;Tope derecha
            ;Moverse izquierda
            ld e_vx(ix), #-1
    tw_end_if:

    ld a, e_y(ix)
    sub #B_UP
    jr nc, tw_no_arr
        ;Tope arriba
        ;Moverse abajo
        ld e_vy(ix), #1
    tw_no_arr:
        ;No tope arriba
        ld a, e_y(ix)
        sub #B_DOWN
        add e_h(ix)
        jr nc, tw_end_if2
            ;Tope abajo
            ;Moverse arriba
            ld e_vy(ix), #-1
    tw_end_if2:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia 
;;Movimiento rebote con contador de muerte
;;Input: ix: entidad
sys_ai_twist_time::
    call sys_ai_twist
    call sys_ai_destroy_time
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia
;;Girar en forma de cuadrado (der-abj-izq-arr)
;;Input: ix: entidad
sys_ai_box::
    ld a, e_x(ix)
    sub #B_LEFT
    jr nc, box_no_izq
        ;Tope izquierda
        ld a, e_y(ix)
        sub #B_DOWN
        add e_h(ix)
        jr nc, box_no_abj
            ;Tope abajo
            ;Moverse arriba
            ld e_vx(ix), #0
            ld e_vy(ix), #-1
        box_no_abj:
            ;No tope abajo
            ld a, e_y(ix)
            sub #B_UP
            jr nc, box_end_if
                ;Tope arriba
                ;Moverse derecha
                ld e_vx(ix), #1
                ld e_vy(ix), #0
    box_no_izq:
        ;No tope izquierda
        ld a, e_x(ix)
        sub #B_RIGHT
        add e_w(ix)
        jr nc, box_no_der
            ;Tope derecha
            ;Moverse abajo
            ld e_vx(ix), #0
            ld e_vy(ix), #1
        box_no_der:
            ;No tope derecha
            ld a, e_y(ix)
            sub #B_DOWN
            add e_h(ix)
            jr nc, box_end_if
                ;Tope abajo
                ;Moverse izquierda
                ld e_vx(ix), #-1
                ld e_vy(ix), #0
    box_end_if:

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia 
;;Movimiento en una columna
;;Input: ix: entidad
sys_ai_col::
    ld a, e_y(ix)
    sub #B_UP
    jr nc, col_noarriba
        ;Tope arriba
        ;Moverse abajo
        ld e_vy(ix), #1
    col_noarriba:
    ld a, e_y(ix)
    sub #B_DOWN
    add e_h(ix)
    jr nc, col_noabajo
        ;Tope abajo
        ;Moverse arriba
        ld e_vy(ix), #-1
    col_noabajo:

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia 
;;Movimiento en una fila
;;Input: ix: entidad
sys_ai_row::
    ld a, e_x(ix)
    sub #B_LEFT
    jr nc, row_noizq
        ;Tope izquierda
        ;Moverse derecha
        ld e_vx(ix), #1
    row_noizq:
    ld a, e_x(ix)
    sub #B_RIGHT
    add e_w(ix)
    jr nc, row_noder
        ;Tope derecha
        ;Moverse izquierda
        ld e_vx(ix), #-1
    row_noder:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia 
;;Movimiento en una fila a fila
;;Input: ix: entidad
sys_ai_row2::
    ld a, e_x(ix)
    cp #B_LEFT
    jr nc, no_izq4
        ;Tope izquierda
        ld a, e_y(ix)
        cp #B_UP
        jr nc, no_arr2
            ;Tope arriba
            ld e_vx(ix), #1
            jr end_if5
        no_arr2:
            ;No tope arriba
            ld a, e_vy(ix)
            cp #2
            jr nz, no_para
                ;Velocidad 2 en y
                ld e_vy(ix), #0
                ld e_vx(ix), #1
                jr end_if5
            no_para:
                ;No velocidad 2 en y
                inc e_vy(ix)
                ld e_vx(ix), #0
                jr end_if5
    no_izq4:
        ;No tope izquierda
        ld a, e_y(ix)
        push af
        ld a, #B_DOWN
        sub e_h(ix)
        ld b, a
        pop af
        cp b
        jr nc, no_abj3
            ;Tope abajo
            ld e_vx(ix), #-1
            jr end_if5
        no_abj3:
            ;No tope abajo
            ld a, e_x(ix)
            push af
            ld a, #B_RIGHT
            sub e_w(ix)
            ld b, a
            pop af
            cp b
            jr nc, end_if5
                ;Tope derecha
                ld a, e_vy(ix)
                cp #2
                jr nz, no_para2
                    ;Velocidad 2 en y
                    ld e_vy(ix), #0
                    ld e_vx(ix), #-1
                    jr end_if5
                no_para2:
                    ;No velocidad 2 en y
                    inc e_vy(ix)
                    ld e_vx(ix), #0
    end_if5:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Ia del enemigo
;;Input: ix: entidad
; sys_ai_nave_enemiga:
;     ld e_x(ix)
; ret

sys_ai_destroy_time::
    ld a, e_aiCounter(ix)
    dec a
    ld e_aiCounter(ix), a
    cp #0
    jr nz, no_destroy
        push ix
        pop hl
        call man_game_entity_destroy
        call man_game_enemy_dead
    no_destroy:
ret


sys_ai_update_one_entity::
    ld l, e_ai_funct(ix)
    ld h, e_ai_funct+1(ix)
    ld (ptrFunc+1), hl
    ptrFunc:
        call end_a
    end_a:
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Update ai
;;  Actualiza la ai de las entidades
sys_ai_update::
    ld hl, #sys_ai_update_one_entity
    ld d, #(e_cmp_ai | e_cmp_movable)
    call man_entity_forall_matching
    ret