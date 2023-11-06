
PLAYER_DIR_RIGHT    = 0
PLAYER_DIR_LEFT     = 1
PLAYER_DIR_UP       = 2
PLAYER_DIR_DOWN     = 3

V_SHOT_MAX_X        = 1
V_SHOT_MAX_Y        = 2

SHOT_CD_COUNT = 50
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Functions
;;
.globl man_game_init
.globl man_game_play
.globl man_game_shot_cd
.globl man_game_entity_shot
.globl man_game_entity_destroy
.globl man_game_create_template_entity
.globl man_game_destroy_bullet
.globl man_game_enemy_dead
.globl man_game_loop_main_menu
.globl man_game_exit_game

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Storage
;;
.globl m_player_shot
.globl m_player_direccion
.globl m_can_shot
.globl m_ingame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;CPCT Functions
;;
.globl cpct_waitHalts_asm
.globl cpct_waitVSYNC_asm



.macro BRK
    .db 0xED, 0xFF
.endm
