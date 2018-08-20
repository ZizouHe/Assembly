; 编写并安装int 7ch中断例程，功能为显示一个用0结束的字符串，
; 中断例程安装在0:200h处
; 参数: (dh)=行号，(dl)=列号，(cl)=颜色，ds:si指向字符串首地址

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

    push ax
    push bx
    push cx
    push dx
    push si
    push es

    mov al, cl
    dec dh
    mul dh
    mov bx, ax
    mov ax, 2
    mul dl
    sub ax, 2
    add bx, ax
    mov ax, 0B800h
    mov es, ax

    mov dl, cl
    mov ch, 0

s0: mov cl, ds:[si]
    jcxz ok
    mov es:[bx], cl
    mov es:[bx+1], dl
    inc si
    add bx, 2
    jmp short s0

ok:

    pop es
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret

do0end:

    nop


code ends

end start
