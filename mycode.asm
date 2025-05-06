name "Tic Tac Toe"
org 100h               ; dia chi bat dau cua COM file la 0100h

.DATA

    ; khai bao ban co 3x3 voi cac so tu 1 den 9 (dung de nhap vi tri)
    grid db '1','2','3'  
         db '4','5','6'
         db '7','8','9'

    player db ?         ; luu nguoi choi hien tai ('x' hoac 'o')
    
    welcomeMsg db 'Chao mung den voi Tic Tac Toe! $'
    inputMsg db 'Nhap vi tri, luot cua nguoi choi: $'
    draw db 'Hoa nhau! $'
    won db 'Nguoi choi chien thang: $'

.CODE
main:

    mov cx, 9           ; choi toi da 9 luot (9 o tren ban co)
    
x:  call clearScreen    ; xoa man hinh de lam moi
    call printWelcomeMsg
    call printGrid      ; hien thi ban co

    mov bx, cx
    and bx, 1           ; bx = cx & 1 de kiem tra chan/le
    cmp bx, 0
    je isEven           ; neu chan thi luot cua 'o'
    mov player, 'x'     ; neu le thi luot cua 'x'
    jmp endif

isEven:
    mov player, 'o'

endif:
notValid:
    call printNewLine
    call printInputMsg  ; thong bao luot choi va nhap vi tri
    call readInput      ; doc phim, ket qua nam trong AL (ky tu '1' den '9')

    push cx             ; luu cx vi sap dung vong lap
    mov cx, 9
    mov bx, 0           ; bx = chi so de duyet mang grid

y:  cmp grid[bx], al    ; kiem tra vi tri da duoc chon chua
    je update           ; neu dung thi cap nhat o do
    jmp continue

update:
    mov dl, player      ; luu gia tri nguoi choi vao DL
    mov grid[bx], dl    ; gan vao o tren ban co

continue:
    inc bx
    loop y              ; lap den het 9 o

    pop cx
    call checkwin       ; kiem tra dieu kien thang
loop x

    call printDraw      ; neu het 9 luot ma chua ai thang thi hoa

programEnd:
    mov ah, 0
    int 16h             ; doi nguoi dung nhan phim bat ky
    ret                 ; ket thuc chuong trinh

; ====================
; CAC HAM HO TRO
; ====================

printGrid:
    push cx
    mov bx, 0
    mov cx, 3           ; 3 hang

x1:
    call printNewLine
    push cx
    mov cx, 3           ; 3 cot

x2:
    mov dl, grid[bx]    ; lay ky tu tu o hien tai
    mov ah, 2h
    int 21h             ; in ky tu

    call printSpace     ; in dau cach
    inc bx
    loop x2
    pop cx
    loop x1
    pop cx
    call printNewLine
    ret

printNewLine:
    mov dl, 0ah         ; xuong dong
    mov ah, 2
    int 21h
    mov dl, 13          ; quay dau dong
    mov ah, 2
    int 21h
    ret

printSpace:
    mov dl, 32          ; ky tu dau cach
    mov ah, 2
    int 21h
    ret

readInput:
    mov ah, 1
    int 21h             ; nhap 1 ky tu vao AL

    ; kiem tra co hop le khong (1-9)
    cmp al, '1'
    je valid
    cmp al, '2'
    je valid
    cmp al, '3'
    je valid
    cmp al, '4'
    je valid
    cmp al, '5'
    je valid
    cmp al, '6'
    je valid
    cmp al, '7'
    je valid
    cmp al, '8'
    je valid
    cmp al, '9'
    je valid
    jmp notValid

valid:
    ret

printWelcomeMsg:
    lea dx, welcomeMsg
    mov ah, 9
    int 21h
    ret

printDraw:
    call printNewLine
    lea dx, draw
    mov ah, 9
    int 21h
    ret

printWon:
    call printNewLine
    call printGrid
    lea dx, won
    mov ah, 9
    int 21h
    mov dl, player
    mov ah, 2
    int 21h
    jmp programEnd
    ret

printInputMsg:
    lea dx, inputMsg
    mov ah, 9
    int 21h
    mov dl, player
    mov ah, 2
    int 21h
    call printSpace
    ret

checkwin:
    ; kiem tra 8 truong hop chien thang (3 hang, 3 cot, 2 duong cheo)

    mov bl, grid[0]
    cmp bl, grid[1]
    jne skip1
    cmp bl, grid[2]
    jne skip1
    call printWon
skip1:

    mov bl, grid[3]
    cmp bl, grid[4]
    jne skip2
    cmp bl, grid[5]
    jne skip2
    call printWon
skip2:

    mov bl, grid[6]
    cmp bl, grid[7]
    jne skip3
    cmp bl, grid[8]
    jne skip3
    call printWon
skip3:

    mov bl, grid[0]
    cmp bl, grid[3]
    jne skip4
    cmp bl, grid[6]
    jne skip4
    call printWon
skip4:

    mov bl, grid[1]
    cmp bl, grid[4]
    jne skip5
    cmp bl, grid[7]
    jne skip5
    call printWon
skip5:

    mov bl, grid[2]
    cmp bl, grid[5]
    jne skip6
    cmp bl, grid[8]
    jne skip6
    call printWon
skip6:

    mov bl, grid[0]
    cmp bl, grid[4]
    jne skip7
    cmp bl, grid[8]
    jne skip7
    call printWon
skip7:

    mov bl, grid[2]
    cmp bl, grid[4]
    jne skip8
    cmp bl, grid[6]
    jne skip8
    call printWon
skip8:
    ret

clearScreen:
    mov ax, 3           ; goi ngat 10h de xoa man hinh
    int 10h
    ret

end main
