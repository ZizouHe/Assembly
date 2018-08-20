; 编写并安装int 7ch中断例程，功能为完成loop指令的功能
; 参数: (cx)=循环次数，(dl)=位移

assume cs:code

code segment

start:

    mov ax, cs
    mov ds, ax
    mov si, offset do0

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset do0end - offset do0

    cld
    rep movsb

    mov ax, 0
    mov ds, ax
    mov word ptr ds:[124*4], 200h
    mov word ptr ds:[124*4+2], 0

    mov ax, 4c00h
    int 21h

do0:

    push bp
    mov bp, sp
    dec cx
    jcxz do0ret
    add ss:[bp+2], bx

do0ret:

    pop bp
    iret

do0end:

    nop


code ends

end start
