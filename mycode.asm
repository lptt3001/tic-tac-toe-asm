name "Tic Tac Toe"
org 100h               ; dia chi bat dau cua COM file

.DATA

    grid db '1','2','3'  
         db '4','5','6'
         db '7','8','9'

    player db ?         
    
    welcomeMsg db 'Chao mung den voi Tic Tac Toe! $'
    inputMsg db 'Nhap vi tri, luot cua nguoi choi: $'
    draw db 'Hoa nhau! $'
    won db 'Nguoi choi chien thang: $'
    playAgainMsg db 13,10,'Ban co muon choi lai? (y/n): $'
    
    ; Cac ky tu ve bang luoi
    topRow    db 201, 205, 205, 205, 203, 205, 205, 205, 203, 205, 205, 205, 187, '$'
    middleRow db 204, 205, 205, 205, 206, 205, 205, 205, 206, 205, 205, 205, 185, '$'
    bottomRow db 200, 205, 205, 205, 202, 205, 205, 205, 202, 205, 205, 205, 188, '$'
    vertBar   db 186, '$'

.CODE
main:

    mov cx, 9           ; choi toi da 9 luot (9 o tren ban co)

x:  call clearScreen    
    call printWelcomeMsg
    call printGrid      

    mov bx, cx
    and bx, 1           
    cmp bx, 0
    je isEven           
    mov player, 'X'     
    jmp endif

isEven:
    mov player, 'O'     

endif:
notValid:
    call printNewLine
    call printInputMsg  
    call readInput      

    push cx             
    mov cx, 9
    mov bx, 0           

y:
    cmp grid[bx], al
    je update
    inc bx
    loop y
    pop cx
    jmp notValid        ; neu khong co o nao khop, nhap lai

update:
    mov dl, player      
    mov grid[bx], dl    
    pop cx

    call checkwin       
    loop x

    call printDraw      
    call askReplay

programEnd:
    mov ah, 0
    int 16h             
    ret                 

; ====================
; CAC HAM HO TRO
; ====================

printGrid:
    push cx
    
    ; In dong tieu de tren cung
    lea dx, topRow
    call printString
    call printNewLine
    
    ; In hang dau tien
    call printVertBar
    call printSpace
    mov dl, grid[0]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printSpace
    mov dl, grid[1]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printSpace
    mov dl, grid[2]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printNewLine
    
    ; In hang ngang giua
    lea dx, middleRow
    call printString
    call printNewLine
    
    ; In hang thu hai
    call printVertBar
    call printSpace
    mov dl, grid[3]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printSpace
    mov dl, grid[4]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printSpace
    mov dl, grid[5]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printNewLine
    
    ; In hang ngang giua
    lea dx, middleRow
    call printString
    call printNewLine
    
    ; In hang thu ba
    call printVertBar
    call printSpace
    mov dl, grid[6]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printSpace
    mov dl, grid[7]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printSpace
    mov dl, grid[8]    
    call printColorChar
    call printSpace
    
    call printVertBar
    call printNewLine
    
    ; In dong cuoi cung
    lea dx, bottomRow
    call printString
    
    pop cx
    call printNewLine
    ret

printVertBar:
    lea dx, vertBar
    call printString
    ret

printColorChar:
    ; Don gian chi in ky tu ma khong co mau
    mov ah, 2
    int 21h
    ret

printString:
    mov ah, 9
    int 21h
    ret

printNewLine:
    mov dl, 0ah         
    mov ah, 2
    int 21h
    mov dl, 13          
    mov ah, 2
    int 21h
    ret

printSpace:
    mov dl, 32          
    mov ah, 2
    int 21h
    ret

readInput:
    mov ah, 1
    int 21h             

    ; kiem tra ky tu co tu 1 den 9 khong
    cmp al, '1'
    jb notValid
    cmp al, '9'
    ja notValid
    ret

printWelcomeMsg:
    lea dx, welcomeMsg
    mov ah, 9
    int 21h
    call printNewLine
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
    call askReplay
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
    mov ax, 3           
    int 10h
    ret

askReplay:
    call printNewLine
    lea dx, playAgainMsg
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h         ; nhap y hoac n
    cmp al, 'y'
    je resetGame
    cmp al, 'Y'
    je resetGame
    ret

resetGame:
    ; dat lai ban co nhu ban dau
    mov grid[0], '1'
    mov grid[1], '2'
    mov grid[2], '3'
    mov grid[3], '4'
    mov grid[4], '5'
    mov grid[5], '6'
    mov grid[6], '7'
    mov grid[7], '8'
    mov grid[8], '9'

    mov cx, 9
    jmp x

end main
