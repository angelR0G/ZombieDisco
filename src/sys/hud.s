.include "cpctelera.h.s"
.include "man/game.h.s"
.include "sys/hud.h.s"
.include "man/entity.h.s"
.include "man/level.h.s"
.globl _spr_heart
.globl _spr_emptyheart

HEART_W = 3
HEART_H = 6

LIFE = 3

lifeCount: .db 0
lifePadding: .db 0
lifeCurrent: .db 0

score:: .dw 0x0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Hud player health
;;Input:
;;  -ix: pointer to the player
;;
sys_hud_health::
    ;Obtener jugador
    xor a
    call man_entity_get

    ;Entidad obtenida es jugador
    ld a ,e_type(ix)
    cp #e_type_player
    jr nz,is_not_player
        ld a, e_health(ix)
        ld (lifeCurrent), a
    is_not_player:

    ;Dibujar tantos corazones como vida maxima
    draw_hearts:
    ld a ,(lifeCount)
    cp #LIFE
    jr z,end_draw_hearts

        ld de, #CPCT_VMEM_START_ASM

        ld a,(lifePadding)
        add #12
        ld c,a

        ld b,#HUD_H
        call cpct_getScreenPtr_asm
        push hl
        pop de

        ;e_health(ix)<(lifeCount)+1
        ;vida del jugador menor a la del corazon a pintar+1
        ld a, (lifeCount)
        inc a
        ld b, a
        ld a, (lifeCurrent)
        cp b
        jr nc, fullheart
            ld hl, #_spr_emptyheart
            jr no_fullheart
        fullheart:
        ld hl, #_spr_heart
        no_fullheart:

        ld c, #HEART_W
        ld b, #HEART_H
        call cpct_drawSprite_asm

        ;Aumentar contador vida
        ld a ,(lifeCount)
        inc a
        ld (lifeCount), a

        ;Aumentar separador vida
        ld a ,(lifePadding)
        add #4
        ld (lifePadding), a

        jr draw_hearts
    end_draw_hearts:

    ;Reiniciar valores
    ld a ,#0
    ld (lifeCount), a
    ld (lifePadding), a
    ld (lifeCurrent), a
ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Initialize score
;;
sys_hud_init::
    ld h, #6    ;;Background
    ld l, #14   ;;foreground
    call cpct_setDrawCharM0_asm

    ld hl, #0x0000
    ld a, h
    ld (score), a
    ld a, l
    ld (score+1), a
    
ret

;;;;;;;;;;;;;;;;;;;;;;
;;Modify score
;;  Input: bc - Value
;;
sys_hud_score_modify::
    ;; Read score and save in hl
    ld a, (score  )
    ld h, a
    ld a, (score+1)
    ld l, a

    ld a, l
    add c
    daa
    ld l, a
    ld a, h
    adc b
    daa
    ld h, a
    ld a, h

    ;;Save new score
    ld (score    ), a
    ld a, l
    ld (score + 1), a
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Score render
;;
sys_hud_score_render::
    ;;Render high value byte 1
    ld a, (score  )
    ;;Rotate 4 bits 
    rra
    rra
    rra
    rra
    ;;Mask 0000 1111
    and #0x0F
    ;;Add 48 to transfor number into ascii
    add #48
    ;;Adjust number 0-9
    daa
    ;;Print first character
    ld e, a
    push de
    ld de, #0xC000
    ld c, #56
    ld b, #HUD_H
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render low value byte 1
    ld a, (score)
    and #0x0F
    add #48
    daa
    ld e, a
    push de
    ld de, #0xC000
    ld c, #60
    ld b, #HUD_H
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render high value byte 2
    ld a, (score+1)
    rra
    rra
    rra
    rra
    and #0x0F
    add #48
    ld e, a
    push de
    ld de, #0xC000
    ld c, #64
    ld b, #HUD_H
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render low value byte 2
    ld a, (score+1)
    and #0x0F
    add #48
    ld e, a
    push de
    ld de, #0xC000
    ld c, #68
    ld b, #HUD_H
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm
ret


round_text: .asciz "Round"



;;;;;;;;;;;;;;;;;;;;;;;
;;render round
;;
sys_hud_round_render::
    ;;Render text round
    ld de, #0xC000
    ld c, #30
    ld b, #HUD_H-4
    call cpct_getScreenPtr_asm
    ld iy, #round_text
    call cpct_drawStringM0_asm
    ;;Render zero
    ld de, #0xC000
    ld c, #34
    ld b, #HUD_H+4
    call cpct_getScreenPtr_asm
    ld e, #48
    call cpct_drawCharM0_asm

    ;;Render high value byte 1
    ld a, (num_level_round)
    ;;Rotate 4 bits 
    rra
    rra
    rra
    rra
    ;;Mask 0000 1111
    and #0x0F
    ;;Add 48 to transfor number into ascii
    add #48
    ;;Adjust number 0-9
    daa
    ;;Print first character
    ld e, a
    push de
    ld de, #0xC000
    ld c, #38
    ld b, #HUD_H+4
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm

    ;;Render low value byte 1
    ld a, (num_level_round)
    and #0x0F
    add #48
    daa
    ld e, a
    push de
    ld de, #0xC000
    ld c, #42
    ld b, #HUD_H+4
    call cpct_getScreenPtr_asm
    pop de
    call cpct_drawCharM0_asm
ret