; Program Description: A = 
; Author: Slider
; Creation Date: 2023/11/2
; Revisions: 
; Date:              Modified by:

INCLUDE Irvine32.inc
.data
    BOARD_SIZE equ 3
    players db "Player 1", 0  ; ���a1���W��
            db "Player 2", 0  ; ���a2���W��
    playerName1 db 'Player 1', 0
    playerName2 db 'Player 2', 0
    circle BYTE "O", 0dh, 0ah, 0
    forks BYTE "X", 0dh, 0ah, 0

    ; display_board
    row1 BYTE "   0   1   2 ", 0dh, 0ah, 0
    row20 BYTE "0  ", 0
    row21 BYTE " | ", 0 
    row22 BYTE " | ", 0
    row23 BYTE "  ", 0dh, 0ah, 0
    rowLine BYTE "  ---+---+---", 0dh, 0ah, 0
    row40 BYTE "1  ", 0
    row41 BYTE " | ", 0 
    row42 BYTE " | ", 0
    row43 BYTE "  ", 0dh, 0ah, 0
    row50 BYTE "2  ", 0
    row51 BYTE " | ", 0 
    row52 BYTE " | ", 0
    row53 BYTE "  ", 0dh, 0ah, 0

    ;��X�r��
    enter1 BYTE "Enter Player 1's name: ", 0
	enter2 BYTE "Enter Player 2's name: ", 0

    ;��Jname
	name1 BYTE 100 DUP(0) 
	name2 BYTE 100 DUP(0) 

    ;��X�r��
	pgofirst BYTE " goes first!", 0ah, 0dh, 0
    whos BYTE "It's ", 0
    turn BYTE " turn ,", 0
	plzenter BYTE "Please enter (row, col): ", 0

    ;��Jrow col
	row DWORD ? 
	col DWORD ? 

    ; reset_board
    board BYTE 100 DUP (0)

    ; whos_turn , make_move
    currentPlayer dd ?
    line DWORD 0

.code
main PROC
    mov edx, OFFSET enter1
	call WriteString

	mov edx,OFFSET name1 
	mov ecx,SIZEOF name1
	call ReadString 

	mov edx, OFFSET enter2
	call WriteString

	mov edx,OFFSET name2 
	mov ecx,SIZEOF name2 
	call ReadString 

	call Crlf                ;�L�ťզ�

	; ��X��go first
	; ��e���a����
    call random_player
    cmp eax, 1
    je L1
    mov edx, OFFSET name2
    call WriteString 
    jmp L2
    L1:
        mov edx, OFFSET name1
        call WriteString
    L2:
    mov edx, OFFSET pgofirst
    call WriteString
    mov currentPlayer, eax

    ;reset_board   �ݽT�{�O�_���T
    call reset_board


	; �L�@�ӴѽL
	;
	; ��ܷ�e���A
    call display_board
	;
	;
	
	call Crlf                ;�L�ťզ�

    

    mov edx, OFFSET whos
	call WriteString

    ; who's turn
    ; call whos_turn
    call make_move

    mov edx, OFFSET turn
	call WriteString

	mov edx, OFFSET plzenter
	call WriteString

    call Crlf                ;�L�ťզ�
              

    
main ENDP

reset_board PROC
    ; �N�s�x�ѽL�����s�M�s
    lea eax, board       ; ���J�s�x�ѽL�����s�a�}
    mov ecx, 9           ; �]�w�j��p�ƾ��� 9�]3x3 �ѽL���j�p�^
    xor edx, edx         ; �N edx �]�� 0�A�@���M�s����

clear_loop:
    mov [eax], dl
    inc eax
    loop clear_loop

    ret
reset_board ENDP


random_player PROC
    call Randomize
    call Random32
    ; call WriteDec 
    ; call Crlf
    ; �ΨӬݶüƥ��H
    mov ecx, 2
    mov edx, 0
    div ecx
    cmp edx, 0                       ; �l�Ʀbedx
    jne one
    mov eax, 0
    jmp quit

    one:
        mov eax, 1
    quit:

    ret
random_player ENDP

whos_turn PROC
    not currentPlayer

    ret
whos_turn ENDP


display_board PROC
    mov edx, OFFSET row1
    call WriteString
    mov edx, OFFSET row20
    call WriteString
    mov edx, OFFSET row21
    call WriteString
    mov edx, OFFSET row22
    call WriteString
    mov edx, OFFSET row23
    call WriteString

    mov edx, OFFSET rowLine
    call WriteString

    mov edx, OFFSET row40
    call WriteString
    mov edx, OFFSET row41
    call WriteString
    mov edx, OFFSET row42
    call WriteString
    mov edx, OFFSET row43
    call WriteString 

    mov edx, OFFSET rowLine
    call WriteString

    mov edx, OFFSET row50
    call WriteString
    mov edx, OFFSET row51
    call WriteString
    mov edx, OFFSET row52
    call WriteString
    mov edx, OFFSET row53
    call WriteString 
    ret
display_board ENDP


make_move PROC
    push eax
    mov eax, line
    cmp eax, 0
    je CmpPlayer
    not currentPlayer

    CmpPlayer:
    inc line
    pop eax
    ; ���y��X���a�W��
    push eax
    mov eax, currentPlayer
    cmp eax, 0
    je L1
    mov edx, OFFSET name1
    jmp L2
    L1:
        mov edx, OFFSET name2
    L2:
        call WriteString
    pop eax

    ; �ˬd��M�C�O�_�b���Ľd��
    cmp esi, 0
    jl  invalid_move
    cmp esi, BOARD_SIZE
    jge invalid_move

    cmp edi, 0
    jl  invalid_move
    cmp edi, BOARD_SIZE
    jge invalid_move

    ; �p��b�@���Ʋդ�������
    mov eax, esi            ; eax = row
    imul eax, BOARD_SIZE    ; eax = row * BOARD_SIZE
    add eax, edi            ; eax = row * BOARD_SIZE + col

    ; �ˬd�Ӧ�m�O�_���š]Player::NONE�^
    mov edx, [ecx + eax]    ; edx = current cell
    cmp edx, 0
    jne invalid_move        ; �D�šA�L�Ĳ���

    ; ��s�ѽL
    mov [ecx + eax], ebx    ; �N currentPlayer ��J���w��m

    jmp make_move_done


invalid_move:
    ; �L�Ĳ��ʪ��B�z

make_move_done:
    ret

make_move ENDP





END main