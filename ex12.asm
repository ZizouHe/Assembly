; 编写0号中断的处理程序，使得在除法溢出发生时
; 在屏幕中间显示字符串'divide error!'，并返回DOS

assume cs:code

code segment

start:

    mov ax, cs           ; ds:si do0程序
    mov ds, ax
    mov si, offset do0

    mov ax, 0            ; es:di 中断向量表程序位置
    mov es, ax
    mov di, 200h

    mov cx, offset do0end - offset do0
                         ; 写入向量表
    cld
    rep movsb

    mov ax, 0            ; 设置中断向量表
    mov es, ax
    mov word ptr es:[0], 200h
    mov word ptr es:[2], 0

    mov ax, 4c00h
    int 21h

do0:

    jmp short s0
    db 'divide error!', 0

s0:

    mov ax, 4
    mov dh, al
    mov dl, 3
    mov cl, 0cah
    mov ax, 0
    mov es, ax
    mov di, 202h
    call far ptr show_str

    mov ax, 4c00h
    int 21h

do0end:

    nop

show_str:

    push ax
    push bx
    push cx
    push dx
    push di
    push ds

    mov al, 0a0h
    dec dh
    mul dh
    mov bx, ax
    mov ax, 2
    mul dl
    sub ax, 2
    add bx, ax
    mov ax, 0B800h
    mov ds, ax

    mov dl, cl
    mov ch, 0

s5: mov cl, es:[di]
    jcxz ok
    mov ds:[bx], cl
    mov ds:[bx+1], dl
    inc di
    add bx, 2
    jmp short s5

ok:

    pop ds
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    retf


code ends

end start
