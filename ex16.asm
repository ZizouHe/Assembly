; 安装新的int 7ch中断例程，为显示输出提供如下功能子程序
; 1. 清屏; 2. 设置前景色; 3. 设置背景色; 4. 向上滚动一行
; 入口参数：ah传递功能号0~3; 用al传递1~2功能的颜色值(0~7)

assume cs:code

stack segment

    db 128 dup(0)

stack ends

code segment

start:

    mov ax, stack
    mov ss, ax
    mov sp, 128

    push cs  ; 安装程序
    pop ds
    mov si, offset int7cstart
    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx,  offset int7cend - offset int7cstart
    cld
    rep movsb

    mov word ptr es:[4*7ch], 200h ; 设置中断向量表
    mov word ptr es:[4*7ch+2], 0

    mov ax, 4c00h
    int 21h

int7cstart:

    jmp short s0
    table dw offset sub0 - offset int7cstart + 200h,
             offset sub1 - offset int7cstart + 200h,
             offset sub2 - offset int7cstart + 200h,
             offset sub3 - offset int7cstart + 200h

s0:

    cmp ah, 3
    ja ok

    push bx
    push si
    mov bl, ah
    mov bh, 0
    add bx, bx
    mov si, offset start - offset int7cstart
    call word ptr table[bx+si+200h]

    pop si
    pop bx
    jmp ok

sub0:

    push cx
    push es
    push di

    mov cx, 0b800h
    mov es, cx
    mov di, 0
    mov cx, 2000

sub0s: ; 清屏

    mov byte ptr es:[di], ' '
    add di, 2
    loop sclear

    pop di
    pop es
    pop cx
    ret

sub1: ; 设置前景色

    push cx
    push es
    push di

    mov cx, 0b800h
    mov es, cx
    mov di, 1
    mov cx, 2000

sub1s:

    and byte ptr es:[di], 11111000b
    or es:[di], al
    add di, 2
    loop sub1s

    pop di
    pop es
    pop cx
    ret

sub2: ; 设置背景色

    push cx
    push es
    push di

    mov cx, 0b800h
    mov es, cx
    mov di, 1
    mov cx, 2000

sub2s:

    and byte ptr es:[di], 10001111b
    or es:[di], al
    add di, 2
    loop sub2s

    pop di
    pop es
    pop cx
    ret

sub3:

    push cx
    push es
    push di
    push ds
    push si

    mov cx, 0b800h
    mov es, cx
    mov ds, cx
    mov di, 0
    mov si, 160
    cld
    mov cx, 24

sub3s:

    push cx
    mov cx, 160
    rep movsb

    pop cx
    loop sub3s

    mov cx, 80

sub3s2:

    mov byte ptr es:[di], ' '
    add di, 2
    loop sub3s2

    pop si
    pop ds
    pop di
    pop es
    pop cx
    ret

ok:

    iret

int7cend:

    nop

code ends
end start
