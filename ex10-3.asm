; 将word型数据转变为表示十进制数、用0结尾的字符串
; 参数, ax: word型数据; ds:si指向字符串首地址

assume cs:code,ds:data

data segment

    db 10 dup (0)

data ends

code segment

start:

    mov ax, 12666
    mov bx, data
    mov ds, bx
    mov si, 0
    call dtoc

    mov dh,8
    mov dl,3
    mov cl,0cah
    call show_str

    mov ax,4c00h
    int 21h

dtoc:

    push ax
    push bx
    push si
    push dx
    push cx
    mov bx, 0

s1: mov cx, 10
    mov dx, 0
    div cx
    mov cx, ax

    add dx, 30h
    push dx
    inc bx

    jcxz s2
    jmp short s1

s2: mov cx, bx
    mov si, 0

s3: pop ax
    mov [si], al
    inc si
    loop s3

    pop cx
    pop dx
    pop si
    pop bx
    pop ax
    ret

show_str:

    mov al, 0a0h   ; 计算显示开始的地址
    dec dh
    mul dh
    mov bx, ax
    mov ax, 2
    mul dl
    sub ax, 2
    add bx, ax
    mov ax, 0B800h
    mov es, ax

    mov di, 0     ; bx存放显示器位置
    mov dl, cl    ; dl存放颜色
    mov ch, 0

s:  mov cl, ds:[si]
    jcxz ok
    mov es:[bx+di], cl
    mov es:[bx+di+1], dl
    inc si
    add bx, 2
    jmp short s

ok: ret

code ends

end start
