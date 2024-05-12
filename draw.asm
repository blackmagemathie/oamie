namespace draw

a1:
    ; draws 1 tile, using absolute positioning.
    ; ----------------
    ; !oamie_buffer    <- buffer to use. ($00 to $30)
    ; !oamie_pos_x_sub <- pos x.
    ; !oamie_pos_y_sub <- pos y.
    ; !oamie_num       <- tile number.
    ; !oamie_props     <- yxppccct properties.
    ; !oamie_size9     <- tile size and x pos 9th bit.
    ; ----------------
    phx
    rep #$20
    ldx !oamie_buffer
    lda $400180,x
    cmp $400188,x
    bne +
    sec
    bra .end
    +
    rep #$10
    tax
    sep #$20
    
    lda !oamie_pos_x_sub
    sta $400000,x
    lda !oamie_pos_y_sub
    sta $400001,x
    lda !oamie_num
    sta $400002,x
    lda !oamie_props
    sta $400003,x
    
    dex #4
    rep #$20
    txa
    sep #$10
    ldx !oamie_buffer
    sta $400180,x
    
    lda $400182,x
    rep #$10
    tax
    sep #$20
    lda !oamie_size9
    and #$03
    sta $400000,x
    dex
    rep #$20
    txa
    sep #$10
    ldx !oamie_buffer
    sta $400182,x
    
    clc
    
    .end:
    sep #$30
    plx
    rtl
    
r1:
    ; draws 1 tile, using relative positioning.
    ; ----------------
    ; !oamie_buffer    <- buffer to use. ($00 to $30)
    ; !oamie_pos_x (2) <- pos x.
    ; !oamie_pos_x_sub <- pos x offset.
    ; !oamie_pos_y (2) <- pos y.
    ; !oamie_pos_y_sub <- pos y offset.
    ; !oamie_num       <- tile number.
    ; !oamie_props     <- yxppccct properties.
    ; !oamie_size9     <- tile size and x pos 9th bit.
    ; ----------------
    ; $3100-$3105 <- (garbage)
    ; ----------------
    phx
    rep #$20
    ldx !oamie_buffer
    lda $400180,x
    cmp $400188,x
    bne +
    sec
    jmp .end
    +
    rep #$10
    tax
    
    lda !oamie_size9
    and #$0002
    bne +
    lda #$0008
    bra ++
    +
    lda #$0010
    ++
    sta $3104
    
    lda !oamie_pos_x_sub
    and #$00ff
    bit #$0080
    beq +
    ora #$ff00
    +
    clc
    adc !oamie_pos_x_lo
    sec
    sbc $1a
    sta $3100
    
    cmp #$0100
    bcc +
    dec
    clc
    adc $3104
    bcs +
    jmp .end
    +
    
    lda !oamie_pos_y_sub
    and #$00ff
    bit #$0080
    beq +
    ora #$ff00
    +
    clc
    adc !oamie_pos_y_lo
    sec
    sbc $1c
    sta $3102
    
    cmp #$00e0
    bcc +
    dec
    clc
    adc $3104
    bcs +
    jmp .end
    +
    
    sep #$20
    lda $3101
    bpl +
    lda #$01
    tsb !oamie_size9
    bra ++
    +
    lda #$01
    trb !oamie_size9
    ++
    
    lda $3100
    sta $400000,x
    lda $3102
    sta $400001,x
    lda !oamie_num
    sta $400002,x
    lda !oamie_props
    sta $400003,x
    
    dex #4
    rep #$20
    txa
    sep #$10
    ldx !oamie_buffer
    sta $400180,x

    lda $400182,x
    rep #$10
    tax
    sep #$20
    lda !oamie_size9
    sta $400000,x
    
    dex
    rep #$20
    txa
    sep #$10
    ldx !oamie_buffer
    sta $400182,x
    
    clc
    
    .end:
    sep #$30
    plx
    rtl

namespace off