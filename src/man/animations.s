.include "game.h.s"
.include "entity.h.s"
.include "animations.h.s"
;.include "sprites/zombie.h.s"
; .include "sprites/player.h.s"
.include "sprites/sprites.h.s"
.globl _spr_playerdisco_00
.globl _spr_playerdisco_01
.globl _spr_playerdisco_02
.globl _spr_playerdisco_03
.globl _spr_playerdisco_04
.globl _spr_playerdisco_05
.globl _spr_playerdisco_06
.globl _spr_playerdisco_07
.globl _spr_playerdisco_08
.globl _spr_playerdisco_09
.globl _spr_playerdisco_10
.globl _spr_playerdisco_11
.globl _spr_playerdisco_12
.globl _spr_playerdisco_13
.globl _spr_playerdisco_14
.globl _spr_playerdisco_15

.globl _spr_zombiedisco_0
.globl _spr_zombiedisco_1
.globl _spr_zombiedisco_2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Structura de AnimFrame
_m_animFrame::
    .db 0
    .dw 0x0000
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Animacion enemigo
;;
man_anim_enemy: .ds 3*_m_animFrame_tam
man_anim_player:: .ds 3*_m_animFrame_tam
man_anim_nextFrame: .dw 0x0000
man_anim_nextFrameEnemy: .dw 0x0000

_init_anim_enemy:
   
     ld hl, #man_anim_enemy
     ld (man_anim_nextFrameEnemy), hl
     ld (hl),#12
     inc hl
     ld bc, #_spr_zombiedisco_0
     ld (hl), c
     inc hl
     ld (hl), b
   
     inc hl
     ld (hl),#12
     inc hl
     ld bc, #_spr_zombiedisco_1
     ld (hl), c
     inc hl
     ld (hl), b
     inc hl
     ld (hl),#0
     inc hl
     ld bc, #man_anim_enemy
     ld (hl),c
     inc hl
     ld (hl),b
 ret

_init_anim_player:
    ld hl, #man_anim_player
    ld (man_anim_nextFrame), hl
    ld (hl),#12
    ld hl, #man_anim_player
    inc hl
    ld bc, #_spr_playerdisco_01
    ld (hl), c
    inc hl
    ld (hl), b

    inc hl
    ld (hl),#12
    inc hl
    ld bc, #_spr_playerdisco_02
    ld (hl), c
    inc hl
    ld (hl), b
    inc hl
    ld (hl),#0
    inc hl
    ld bc, #man_anim_player
    ld (hl),c
    inc hl
    ld (hl),b
 ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Change sprite animation
;;Change sprite for animation frames with the enity direction
man_anim_change_sprite_anim::
    ld a, (m_player_direccion)
    cp #PLAYER_DIR_UP
    jr nz, no_up_animation
        ld hl, #_spr_playerdisco_04
        call man_anim_change_sprite
        ld bc, #_spr_playerdisco_05
        ld de, #_spr_playerdisco_06
        call change_frame_anim
        jr end_cambio
    no_up_animation:
    ld a, (m_player_direccion)
    cp #PLAYER_DIR_LEFT
    jr nz, no_up_left
        ld hl, #_spr_playerdisco_08
        call man_anim_change_sprite
        ld bc, #_spr_playerdisco_09
        ld de, #_spr_playerdisco_10
        call change_frame_anim
        jr end_cambio
    no_up_left:
        ld a, (m_player_direccion)
        cp #PLAYER_DIR_RIGHT 
        jr nz, no_up_right
            ld hl, #_spr_playerdisco_12
            call man_anim_change_sprite
            ld bc, #_spr_playerdisco_13
            ld de, #_spr_playerdisco_14
            call change_frame_anim
            jr end_cambio
    no_up_right:
        ld a, (m_player_direccion)
        cp #PLAYER_DIR_DOWN 
        jr nz, end_cambio
            ld hl, #_spr_playerdisco_00
            call man_anim_change_sprite
            ld bc, #_spr_playerdisco_01
            ld de, #_spr_playerdisco_02
            call change_frame_anim

    end_cambio:
ret


change_frame_anim::
    ld hl, #man_anim_player
    ld (man_anim_nextFrame), hl
    ld (hl),#12
    ld hl, #man_anim_player
    inc hl
    ld (hl), c
    inc hl
    ld (hl), b

    inc hl
    ld (hl),#12
    inc hl
    ld (hl), e
    inc hl
    ld (hl), d
    inc hl
    ld (hl),#0
    inc hl
    ld bc, #man_anim_player
    ld (hl),c
    inc hl
    ld (hl),b
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Change entity sprite
;;Input:
;;     -hl: new sprite
;;     -ix: entity
man_anim_change_sprite::
    ld e_sprite(ix), l
    ld e_sprite+1(ix), h
ret