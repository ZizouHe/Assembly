; 将a段和b段数据分别相加，结果存在c段

assume cs:code

a segment

    db 1, 2, 3, 4, 5, 6, 7, 8

a ends

b segment

    db 1, 2, 3, 4, 5, 6, 7, 8

b ends

c segment

    db 0, 0, 0, 0, 0, 0, 0, 0

c ends

code segment

start: mov ax, a
       mov ds, ax
       mov ax, b
       mov es, ax
       mov ax, c
       mov ss, ax
       mov cx, 8
       mov bx, 0

s:     mov al, [bx]
       add al, es:[bx]
       mov ss:[bx], al
       add bx, 1

       loop s

       mov ax, 4c00h
       int 21h

code ends

end start
