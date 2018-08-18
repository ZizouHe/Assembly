assume cs:codesg,ds:data,es:table

data segment

    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上是表示 21 年的 21 个字符串

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示 21 年公司总收的 21 个 dword 型数据

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,45257,17800
    ;以上是表示 21 年公司雇员人数的 21 个 word 型数据

data ends

table segment

    db 21 dup('year                           ', 0)
    ; 位置0,5,16,22,27 共32字节

table ends

codesg segment

start:

    mov ax, data
    mov ds, ax
    mov ax, table
    mov es, ax
    mov bx, 0
    mov bp, 0
    mov si, 0
    mov di, 0
    mov cx, 21

s:  mov al, ds:[bx]       ; 保存年份信息到table段
    mov es:[di], al
    mov al, ds:[bx+1]
    mov es:[di+1], al
    mov al, ds:[bx+2]
    mov es:[di+2], al
    mov al, ds:[bx+3]
    mov es:[di+3], al

    mov di, 16            ; 保存人数信息
    mov ax, ds:0a8h[si]
    call far ptr dtoc     ; 段间转移

    mov di, 5             ; 保存总收入信息
    mov ax, ds:54h[bx]
    mov dx, ds:56h[bx]
    call far ptr dwtoc    ; 将双字整数转化为字符串

    mov di, 22            ; 保存人均收入信息
    div word ptr ds:0a8h[si]
    call far ptr dtoc

    mov ax, 1             ; 显示在屏幕上
    add ax, bp
    mov dh, al
    mov dl, 3
    mov cl, 04ah
    call far ptr show_str


    mov ax, es
    add ax, 2
    mov es, ax
    add bx, 4
    add si, 2
    inc bp
    mov di, 0

    loop s

    mov ax, 4c00h
    int 21h


dwtoc:

    push ax
    push bx
    push cx
    push dx
    push di
    mov bx, 0

d1: mov cx, 10
    call divdw
    add cx, 30h
    push cx

    inc bx
    mov cx, dx
    add cx, ax
    jcxz d2
    jmp short d1

d2: mov cx, bx

d3: pop ax
    mov es:[di], al
    inc di
    loop d3

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    retf

divdw:         ; 解决除法溢出，ax/dx为被除数低位/高位，
               ; ax/dx为结果低位/高位，cx为余数

    push bx
    push ax

    mov ax, dx
    mov dx, 0
    div cx
    mov bx, ax
    pop ax
    div cx
    mov cx, dx
    mov dx, bx

    pop bx
    ret

dtoc:

    push ax
    push bx
    push cx
    push dx
    push di
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

s3: pop ax
    mov es:[di], al
    inc di
    loop s3

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    retf


show_str:

    push ax
    push bx
    push cx
    push dx
    push di
    push ds

    mov al, 0a0h   ; 计算显示开始的地址
    dec dh
    mul dh
    mov bx, ax
    mov ax, 2
    mul dl
    sub ax, 2
    add bx, ax
    mov ax, 0B800h
    mov ds, ax

    mov di, 0     ; bx存放显示器位置
    mov dl, cl    ; dl存放颜色
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

codesg ends

end start
