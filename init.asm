namespace init

sprite_1:
    ; custom getDrawInfo.
    ; ----------------
    ; $00-$01 <- (garbage)
    ; ----------------
    ; adapted from code by akaginite.
    ; ----------------
    stz !186C,x
    lda !14E0,x
    sta !oamie_pos_x_hi
    xba
    lda !E4,x
    sta !oamie_pos_x_lo
    rep #$20
    sec
    sbc $1a
    sta $00
    clc
    adc #$0040
    cmp #$0180
    sep #$20
    lda $01
    beq +
    lda #$01
    +
    sta !15A0,x
    tdc
    rol
    sta !15C4,x
    bne ++
    lda !14D4,x
    sta !oamie_pos_y_hi
    xba
    lda !190F,x
    and #$20
    beq +
    lda !D8,x
    sta !oamie_pos_y_lo
    rep #$21
    adc #$0020
    sec
    sbc $1c
    sep #$20
    lda !14D4,x
    xba
    beq +
    lda #$02
    +
    sta !186C,x
    lda !D8,x
    sta !oamie_pos_y_lo
    rep #$21
    adc #$0010
    sec
    sbc $1c
    sep #$21
    sbc #$10
    sta $01
    xba
    bne +
    clc
    lda #$20
    sta !oamie_buffer
    rtl
    +
    inc !186C,x
    ++
    sec
    rtl
    
sprite_2:
    ; sets true visual position (y-1), without offscreen checks.
    ; ----------------
    lda !E4,x
    sta !oamie_pos_x_lo
    lda !14E0,x
    sta !oamie_pos_x_hi
    lda !14D4,x
    xba
    lda !D8,x
    rep #$20
    dec
    sta !oamie_pos_y_lo
    sep #$20
    rtl
    
namespace off