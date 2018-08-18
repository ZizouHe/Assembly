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

    db 21 dup('year summ ne ?? ')

table ends

codesg segment

start:

    mov ax, data             ; ds保存data
    mov ds, ax
    mov ax, table            ; es保存table
    mov es, ax
    mov bx, 0                ; bx保存年份和保存总收入
    mov si, 0                ; si保存雇员人数
    mov di, 0                ; di保存汇总
    mov cx, 21

s:  mov al, ds:[bx]          ; 保存年份
    mov es:[di], al
    mov al, ds:[bx+1]
    mov es:[di+1], al
    mov al, ds:[bx+2]
    mov es:[di+2], al
    mov al, ds:[bx+3]
    mov es:[di+3], al

    mov ax, ds:0a8h[si]      ; 保存雇员人数
    mov es:0ah[di], ax

    mov ax, ds:54h[bx]       ; 保存总收入
    mov dx, ds:56h[bx]
    mov es:5[di], ax
    mov es:7[di], dx

    div word ptr ds:0a8h[si] ; 计算并保存人均收入
    mov es:0dh[di], ax

    add bx, 4
    add si, 2
    add di, 16

    loop s

    mov ax, 4c00h
    int 21h

codesg ends

end start

