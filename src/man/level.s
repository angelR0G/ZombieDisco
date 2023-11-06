.include "man/level.h.s"
.include "man/entity.h.s"
.include "sys/ai.h.s"
.include "man/entity_templates.h.s"
.include "man/game.h.s"
;.include "sprites/zombie.h.s"
.include "levels/levels.h.s"
.include "sprites/sprites.h.s"
.globl _spr_zombiedisco_0
.globl _spr_zombiedisco2_0
.globl _spr_zombiedisco3_0
.globl _spr_zombiedisco4_0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Types of enemies
;;sprite, width, height, ia, health
TAM_ENEMY = 9

enemy_type::
    ;ZOMBIE NORMAL ROW
    .dw #_spr_zombiedisco_0
    .db #SPR_ZOMBIE_0_W, #SPR_ZOMBIE_0_H
    .db 1, 0
    .dw #sys_ai_row
    .db 1
    ;------------------------------------
    ;ZOMBIE NORMAL COL
    .dw #_spr_zombiedisco2_0
    .db #SPR_ZOMBIE_0_W, #SPR_ZOMBIE_0_H
    .db 0, 2
    .dw #sys_ai_col
    .db 1
    ;------------------------------------
    ;ZOMBIE BOUNCE
    .dw #_spr_zombiedisco3_0
    .db #SPR_ZOMBIE_0_W, #SPR_ZOMBIE_0_H
    .db 1, 2
    .dw #sys_ai_twist
    .db 1
    ;------------------------------------
    ;ZOMBIE CHAINSAW
    .dw #_spr_zombiedisco4_0
    .db #SPR_ZOMBIE_0_W, #SPR_ZOMBIE_0_H
    .db 1, 0
    .dw #sys_ai_box
    .db 1
    ;------------------------------------
    ;ZOMBIE FOLLOW
    .dw #_spr_zombiedisco_0
    .db #SPR_ZOMBIE_0_W, #SPR_ZOMBIE_0_H
    .db 1, 2
    .dw #sys_ai_move_to
    .db 1
    ;------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;GAME LEVELS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TAM_ENEMY_LEVEL = 9

num_level_round:: .db 0
ref_num_enemies::   .dw 0x0000
ref_actual_level::  .dw 0x0000
actual_type_enemy::   .db 0
enemy_level0::
    .db #0, #1, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #1                              ;;Total enemies
    .dw #_level0                        ;;Tilemap

enemy_level1::
    .db #1, #0, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #1                              ;;Total enemies
    .dw #_level0                        ;;Tilemap

enemy_level2::
    .db #0, #1, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #1                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level3::
    .db #1, #1, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #2                              ;;Total enemies
    .dw #_level0                        ;;Tilemap

enemy_level4::
    .db #2, #0, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #2                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level5::
    .db #2, #1, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #3                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level6::
    .db #1, #2, #0, #0, #0, #0x00FF     ;;Cant type enemy
    .db #3                              ;;Total enemies
    .dw #_level0                        ;;Tilemap

enemy_level7::
    .db #0, #0, #1, #0, #0, #0x00FF     ;;Cant type enemy
    .db #1                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level8::
    .db #1, #0, #1, #0, #0, #0x00FF     ;;Cant type enemy
    .db #2                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level9::
    .db #2, #0, #1, #0, #0, #0x00FF     ;;Cant type enemy
    .db #3                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level10::
    .db #0, #0, #2, #0, #0, #0x00FF     ;;Cant type enemy
    .db #2                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level11::
    .db #0, #0, #0, #1, #0, #0x00FF     ;;Cant type enemy
    .db #1                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level12::
    .db #0, #1, #0, #1, #0, #0x00FF     ;;Cant type enemy
    .db #2                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level13::
    .db #1, #1, #0, #1, #0, #0x00FF     ;;Cant type enemy
    .db #3                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level14::
    .db #1, #1, #1, #1, #0, #0x00FF     ;;Cant type enemy
    .db #4                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level15::
    .db #2, #0, #0, #1, #0, #0x00FF     ;;Cant type enemy
    .db #3                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level16::
    .db #0, #0, #1, #1, #0, #0x00FF     ;;Cant type enemy
    .db #2                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level17::
    .db #1, #0, #1, #1, #0, #0x00FF     ;;Cant type enemy
    .db #3                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level18::
    .db #2, #0, #1, #1, #0, #0x00FF     ;;Cant type enemy
    .db #4                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level19::
    .db #2, #1, #1, #0, #0, #0x00FF     ;;Cant type enemy
    .db #4                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
enemy_level20::
    .db #1, #1, #2, #0, #0, #0x00FF     ;;Cant type enemy
    .db #4                              ;;Total enemies
    .dw #_level0                        ;;Tilemap
end_levels:: .db #0xFF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Initialize game level
;;Input:
;;  - hl: level to load
sys_level_init::
    ;Save current level
    ld a, l
    ld (ref_actual_level), a
    ld a, h
    ld (ref_actual_level+1), a

    ;Save num enemies reference
    ld a, l
    ld (ref_num_enemies), a
    ld a, h
    ld (ref_num_enemies+1), a

    ;Initialize next spawn timer
    ld a, #TIME_NEXT_ENEMY_SPAWN
    ld (temp_next_enemy), a
    ;
    ld a, (hl)
    ld (cont_number_enemy), a

    xor a
    ld (actual_type_enemy), a
    ld a, #1
    ld (num_level_round), a
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Change the game level to the next 
;;
sys_level_next::
    ;;Reset timer   
    ld a, #TIME_NEXT_ENEMY_SPAWN
    ld (temp_next_enemy), a
    ;;Increment level number
    call sys_level_round_modify
    ;Change to the new level direcction
    ld a, (ref_actual_level)
    ld l, a                         ;;Save in L actual level upper bit 
    ld a, (ref_actual_level+1)
    ld h, a                         ;;Save in L actual level lower bit

    ld bc, #TAM_ENEMY_LEVEL
    add hl, bc                      ;;Increase memory direction
    ;;Check levels end              
    ld a, (hl)
    cp #0xFF
    jr nz, change_next_level
        ;;Change to the main menu
        call man_game_exit_game
        ret
    change_next_level:
        ld a, l                         ;;Save new direcction
        ld (ref_actual_level), a        ;;Save in L new level upper bit
        ld a, h
        ld (ref_actual_level+1), a      ;;Save in L new level lower bit

        ;Save num enemies reference
        ld a, l
        ld (ref_num_enemies), a
        ld a, h
        ld (ref_num_enemies+1), a
        
        ;Reset 
        ld a, (hl)
        ld (cont_number_enemy), a
        ;;Reset type enemy increase
        xor a
        ld (actual_type_enemy), a
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Generate enemies
;;Input:
;;      hl - level to load
;;      iy - enemy types
;;
sys_level_generate_enemy::
    loop_enemy_generation:
        ;;Check end of level
        ld a, (cont_number_enemy)
        cp #0xFF
        ret z
        ;; Check the number of enemies to generate
        cp #0
        jr z, next_type
            loop_gen:
                ;;timer
                ld a, (temp_next_enemy)
                checkTimer:
                cp #0
                jr nz, decrease_temp
                    call generate_enemy
                    ;;reset timer
                    ld a, #TIME_NEXT_ENEMY_SPAWN
                    ld (temp_next_enemy), a

                    ;;Decrease the number of enemies to generate
                    ld a, (cont_number_enemy)
                    dec a
                    ld (cont_number_enemy), a
                    cp #0
                    jr z, next_type
                decrease_temp:
                    ld a, (temp_next_enemy)
                    dec a
                    ld (temp_next_enemy), a
                    ret
    next_type:
        ;;Increase to the next enemy type
        ld a, (ref_num_enemies)
        ld l, a
        ld a, (ref_num_enemies+1)
        ld h, a
        inc hl
        ld a, l
        ld (ref_num_enemies), a
        ld a, h
        ld (ref_num_enemies+1), a
        ld a, (hl)
        ld (cont_number_enemy), a

        ;;Calculate pos new type of enemy
        ld b, #TAM_ENEMY
        ld a, (actual_type_enemy)
        add a, b
        ld (actual_type_enemy), a

        jr loop_enemy_generation
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Generates an enemy
generate_enemy:
    ;;Create new enemy
    ld hl, #_enemy_zombie_tmpl
    call man_game_create_template_entity

    call select_random_door
    ld bc, (actual_type_enemy)
    add iy, bc
    ;;Rest of data
    ;Sprite
    ld l, en_gen_sprite  (iy)
    ld h, en_gen_sprite+1(iy)
    ld e_sprite  (ix), l
    ld e_sprite+1(ix), h
    ld e_original_s  (ix), l
    ld e_original_s+1(ix), h

    ;Vel sprite
    ld a,en_gen_vx(iy)
    ld e_vx(ix), a

    ld a,en_gen_vy(iy)
    ld e_vy(ix), a

    ;Tam sprite
    ld a,en_gen_w(iy)
    ld e_w(ix), a

    ld a,en_gen_h(iy)
    ld e_h(ix), a

    ;IA
    ld l, en_gen_ia  (iy)
    ld h, en_gen_ia+1(iy)
    ld e_ai_funct  (ix), l
    ld e_ai_funct+1(ix), h

    ;Health
    ld a, en_gen_health(iy)
    ld e_health(ix), a
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Select random door
;;Generates a random number and selects a door to generate an enemy
;;  - 0:Up; 1:Right; 2:Down; 3:Left
;;Input:
;;  - ix: enemy entity
select_random_door:
    ;Dandom number
    call cpct_getRandom_mxor_u8_asm
    ld a,l
	and #4
    ;Select a door
    cp #0
    jr nz, door_right
        ld b, #POS_ZERO_Y
        ld c, #POS_X
        call set_coordinates
        jr end_door
    door_right:
        cp #1
        jr nz, door_down
            ld b, #POS_Y
            ld c, #POS_FIN_X
            call set_coordinates
            jr end_door
    door_down:
        cp #2
        jr nz, door_left
            ld b, #POS_FIN_Y
            ld c, #POS_X
            call set_coordinates
            jr end_door
    door_left:
        cp #3
        jr nz, end_door
            ld b, #POS_Y
            ld c, #POS_ZERO_X
            call set_coordinates
            jr end_door
    end_door:

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Set the coordinates for an entity
;;Input:
;;  -ix: entity
;;  - b: y coordinate
;;  - c: x coordinate
set_coordinates:
    ld e_y(ix), b
    ld e_x(ix), c
ret

;;;;;;;;;;;;;;;;;;;;;;;
;;modify round
;;Increment current level
sys_level_round_modify::
    ld a, (num_level_round)
    inc a
    daa
    ld (num_level_round), a
ret