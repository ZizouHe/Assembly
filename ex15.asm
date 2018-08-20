; 安装一个int 9中断例程
; 功能：在DOS下，按下'A'键后，除非不再松开
; 如果松开，就显示满屏的'A'，其他的键照常处理

assume cs:code

code segment

start:

    mov ax, cs        ; 复制新int9例程地址
    mov ds, ax
    mov si, offset int9

    mov ax, 0
    mov es, ax
    mov di, 204h

    mov cx, offset int9end - offset int9

    cld
    rep movsb

    push es:[9*4]     ; 保存原有int9例程地址
    push es:[9*4+2]
    pop es:[202h]
    pop es:[200h]

    cli               ; 改写中断向量表
    mov word ptr es:[9*4], 204h
    mov word ptr es:[9*4+2], 0
    sti

    mov ax, 4c00h
    int 21h

int9:

    push ax
    push bx
    push cx
    push es

    pushf   ; 必须调用原来的int 9
    call dword ptr cs:[200h]

    in al, 60h
    cmp al, 9eh
    jne int9ret

    mov ax, 0b800h ; 放开a显示
    mov es, ax
    mov bx, 0
    mov cx, 2000

s:  mov byte ptr es:[bx], 41h
    inc bx
    inc bx
    loop s

int9ret:

    pop es
    pop cx
    pop bx
    pop ax
    iret

int9end:

    nop


code ends

end start
