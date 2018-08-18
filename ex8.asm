assume cs:codesg

codesg segment

        mov ax,4c00h      ; 10
        int 21h           ; 11

start:  mov ax,0          ; 1

s:      nop               ; 2 and 9
        nop               ; 3
        mov di,offset s   ; 4 将s2处的指令复制到s
        mov si,offset s2  ; 5
        mov ax,cs:[si]    ; 6
        mov cs:[di],ax    ; 7

s0:     jmp short s       ; 8

s1:     mov ax,0
        int 21h
        mov ax,0

s2:     jmp short s1
        nop

codesg ends

end starts

; jmp short s1是相对位移，向上移动10个位移
; 因此从s直接跳转到mov ax, 4c00h，程序结束
