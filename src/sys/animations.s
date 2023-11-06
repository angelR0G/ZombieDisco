; .include "cpctelera.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "man/animations.h.s"
.include "sprites/sprites.h.s"
.globl _spr_zombiedisco_0
.globl _spr_zombiedisco_2
MAX_COOLDOWN = 10
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;Actualiza la animacion de una entidad
 ;;Input: ix-Entidad a actualizar
 sys_animations_update_one_entity_player::
    ;;Check if can update animation -> 0-yes
    ld a, e_updateAnim(ix)
    cp #0
    jr nz, end_if
    ld a, e_animCounter(ix)
     dec a
     ld e_animCounter(ix), a
     cp #0
     jr nz, end_if
         ld hl, (man_anim_nextFrame)
         ld bc, #3
         add hl, bc
         ld (man_anim_nextFrame), hl
         ld de, (man_anim_nextFrame)
         ld a, (de)
         cp #0
         jr nz, no_end_anim
             ld hl, (man_anim_nextFrame)
             inc hl
             ld a, (hl)
             ld (man_anim_nextFrame), a
             inc hl
             ld a, (hl)
             ld (man_anim_nextFrame+1), a
         no_end_anim:
         ;Cambia el sprite por el del siguiente frame de la animacion
         ld hl, (man_anim_nextFrame)
         inc hl
         ld a, (hl)
         ld e_sprite(ix), a
         inc hl
         ld a, (hl)
         ld e_sprite+1(ix), a
         ;Cambia el contador por el del siguiente frame de la animacion
         ld de, (man_anim_nextFrame)
         ld a, (de)
         ld e_animCounter(ix), a
     end_if:
    ret


 sys_animations_update_one_entity_enemy::
    ; ;;Check if can update animation -> 0-yes
    ; ld a, e_updateAnim(ix)
    ; cp #0
    ; jr nz, end_if
    ; ld a, e_animCounter(ix)
    ;  dec a
    ;  ld e_animCounter(ix), a
    ;  cp #0
    ;  jr nz, end_if
    ;      ld hl, (man_anim_nextFrame)
    ;      ld bc, #3
    ;      add hl, bc
    ;      ld (man_anim_nextFrame), hl
    ;      ld de, (man_anim_nextFrame)
    ;      ld a, (de)
    ;      cp #0
    ;      jr nz, no_end_anim
    ;          ld hl, (man_anim_nextFrame)
    ;          inc hl
    ;          ld a, (hl)
    ;          ld (man_anim_nextFrame), a
    ;          inc hl
    ;          ld a, (hl)
    ;          ld (man_anim_nextFrame+1), a
    ;      no_end_anim:
    ;      ;Cambia el sprite por el del siguiente frame de la animacion
    ;      ld hl, (man_anim_nextFrame)
    ;      inc hl
    ;      ld a, (hl)
    ;      ld e_sprite(ix), a
    ;      inc hl
    ;      ld a, (hl)
    ;      ld e_sprite+1(ix), a
    ;      ;Cambia el contador por el del siguiente frame de la animacion
    ;      ld de, (man_anim_nextFrame)
    ;      ld a, (de)
    ;      ld e_animCounter(ix), a
    ;  end_if:
    ret

sys_animations_update_one_entity::
    ld a, e_type(ix)
    cp #e_type_player
    jr nz, no_player
        call sys_animations_update_one_entity_player
        jr end_check
    no_player:
        ld a, e_type(ix)
        cp #e_type_enemigo
        jr nz, end_check
            call sys_animations_update_one_entity_enemy
    end_check:
ret

;;ix -entity
sys_animations_update_one_entity_type::
    ld a, e_hit(ix)
    cp #0
    jr nz, hit_enemy 
        ;;No hit
        ld a, e_cooldown_coll(ix)
        cp #0
        jr nz, dec_cooldown
            ld a, #MAX_COOLDOWN
            ld e_cooldown_coll(ix), a
            
            ld l, e_original_s(ix)
            ld h, e_original_s+1(ix)
            call man_anim_change_sprite
            jr end_upd_hit
        dec_cooldown:
            ld a, e_cooldown_coll(ix)
            dec a
            ld e_cooldown_coll(ix), a
            jr end_upd_hit
    hit_enemy:
        ld hl, #_spr_zombiedisco_2
        call man_anim_change_sprite
        xor a
        ld e_hit(ix), a
    end_upd_hit:
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Update animations
;;  Actualiza la animacion de las entidades
sys_animations_update::
    ld hl, #sys_animations_update_one_entity
    ld d, #(e_cmp_animated)
    call man_entity_forall_matching
    ret