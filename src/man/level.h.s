.globl cpct_getRandom_mxor_u8_asm
.globl sys_level_init
.globl sys_level_generate_enemy
.globl sys_level_next
.globl sys_level_round_modify

.globl enemy_type
.globl enemy_level0
.globl ref_actual_level
.globl num_level_round

TIME_NEXT_ENEMY_SPAWN = 0x80
TYPES_ENEMIES = 6
temp_next_enemy: .db 0
cont_number_enemy: .db 0


en_gen_sprite      = 0
en_gen_w           = 2
en_gen_h           = 3
en_gen_vx          = 4
en_gen_vy          = 5
en_gen_ia          = 6
en_gen_health      = 8

POS_ZERO_X = 4
POS_FIN_X  = 71
POS_X      = 39
POS_ZERO_Y = 16
POS_FIN_Y  = 130
POS_Y      = 75