.module ENTITY_TEMPLATES

.include "man/entity_templates.h.s"
.include "man/entity.h.s"
.include "man/game.h.s"
.include "man/animations.h.s"
.include "sys/render.h.s"
.include "sys/physics.h.s"
.include "sys/ai.h.s"
.include "sys/animations.h.s"

;.include "sprites/zombie.h.s"
;.include "sprites/player.h.s"
.include "sprites/bullet.h.s"
.include "sprites/sprites.h.s"
.globl _spr_playerdisco_00
.globl _spr_zombiedisco_0



_bullet_tmpl::
    .db e_type_shot                                 ;Tipo de entidad
    .db e_cmp_render | e_cmp_movable | e_cmp_border | e_cmp_collider;Componentes de la entidad
    .db #0                                          ;x
    .db #0                                          ;y
    .db #SPR_BULLET_W                               ;Ancho
    .db #SPR_BULLET_H                               ;Alto
    .db #0                                          ;Velocidad x
    .db #0                                          ;Velocidad y
    .dw _spr_bullet                                 ;Sprite
    .dw sys_ai_destroy_time                         ;Comportamiento ia
    .db #0                                          ;Contador ia
    .dw 0x0000                                      ;Animaciones
    .db #0                                          ;Contador animaciones
    .dw 0x0000                                      ;Next frame
    .db 0                                           ;Update Animations 0->Update, 1-> no update
    .dw man_game_destroy_bullet                     ;Comportamiento colision tilemap
    .db e_type_enemigo                              ;Entidad colisionada
    .db #1                                          ;Vida
    .db #1                                          ;Danyo
    .db 0                                           ;Count cooldown enemy
    .db 0                                           ;Hit
    .dw _spr_bullet                                 ;Original sprite
ret

_bullet_enemy_tmpl::
    .db e_type_shot_enemy                                 ;Tipo de entidad
    .db e_cmp_render | e_cmp_movable | e_cmp_border | e_cmp_collider;Componentes de la entidad
    .db #0                                          ;x
    .db #0                                          ;y
    .db #SPR_BULLET_W                               ;Ancho
    .db #SPR_BULLET_H                               ;Alto
    .db #0                                          ;Velocidad x
    .db #0                                          ;Velocidad y
    .dw _spr_bullet                                 ;Sprite
    .dw 0x0000                                      ;Comportamiento ia
    .db #0                                          ;Contador ia
    .dw 0x0000                                      ;Animaciones
    .db #0                                          ;Contador animaciones
    .dw 0x0000                                      ;Next frame
    .db 0                                           ;Update Animations 0->Update, 1-> no update
    .dw man_game_destroy_bullet                     ;Comportamiento colision tilemap
    .db e_type_player                               ;Entidad colisionada
    .db #1                                          ;Vida
    .db #1                                          ;Danyo
    .db 0                                           ;Count cooldown enemy
    .db 0                                           ;Hit
    .dw _spr_bullet                                 ;Original sprite
ret


_player_tmpl::
    .db e_type_player                                                               ;Tipo de entidad
    .db e_cmp_render | e_cmp_movable | e_cmp_input | e_cmp_collider | e_cmp_border | e_cmp_animated  ;Componentes de la entidad
    .db #5                                                                          ;x
    .db #18                                                                         ;y
    .db #SPR_PLAYER_0_W                                                             ;Ancho
    .db #SPR_PLAYER_0_H                                                             ;Alto
    .db #0                                                                          ;Velocidad x
    .db #0                                                                          ;Velocidad y
    .dw _spr_playerdisco_00                                                         ;Sprite
    .dw 0x0000                                                                      ;Comportamiento ia
    .db #0                                                                          ;Contador ia
    .dw man_anim_player                                                             ;Animaciones
    .db #12                                                                         ;Contador animaciones
    .dw 0x0000                                                                      ;Next frame
    .db 0                                                                           ;Update Animations 0->Update, 1-> no update
    .dw sys_physics_undo_move                                                       ;Comportamiento colision tilemap
    .db #0                                                                          ;Entidad colisionada
    .db #3                                                                          ;Vida
    .db #0                                                                          ;Danyo
    .db 0                                                                           ;Count cooldown enemy
    .db 0                                                                           ;Hit
    .dw _spr_playerdisco_00                                                         ;Original sprite
ret

_enemy_zombie_tmpl::
    .db e_type_enemigo                                  ;Tipo de entidad
    .db e_cmp_render | e_cmp_movable | e_cmp_ai | e_cmp_collider;Componentes de la entidad
    .db #25                                             ;x
    .db #100                                             ;y
    .db #SPR_ZOMBIE_0_W                                 ;Ancho
    .db #SPR_ZOMBIE_0_H                                 ;Alto
    .db #0                                              ;Velocidad x
    .db #0                                              ;Velocidad y
    .dw _spr_zombiedisco_0                              ;Sprite
    .dw sys_ai_row                                      ;Comportamiento ia
    .db #0xFF                                           ;Contador ia
    .dw man_anim_enemy                                  ;Animaciones
    .db #12                                             ;Contador animaciones
    .dw 0x0000                                          ;Next frame
    .db 0                                               ;Update Animations 0->Update, 1-> no update
    .dw 0x0000                                          ;Comportamiento borde
    .db e_type_player                                   ;Entidad colisionada
    .db #2                                              ;Vida
    .db #1                                              ;Danyo
    .db 0x50                                            ;Count cooldown enemy
    .db 0                                               ;Hit
    .dw _spr_zombiedisco_0                              ;Original sprite
ret