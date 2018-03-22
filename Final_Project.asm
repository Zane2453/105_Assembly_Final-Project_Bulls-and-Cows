TITLE Final_Project (Final_Project.asm)
INCLUDE Irvine32.inc

main          EQU start@0

.stack 4096
ExitProcess proto, dwExitCode : dword

.data
    temp DWORD 10 DUP(0)        ;�s�üƪ�
    input dword 10 dup(0)       ;�s��J��
    Game_start BYTE "How many numbers you want to guess(non-numeric character to exit):",0dh,0ah,0
    Game_wstart BYTE "���~��J",0dh,0ah
                BYTE "�п�J�Ʀr1~9",0
    Game_error_Length BYTE "���~��J����",0
    Game_error_Input BYTE "���~��J",0
    Game_input BYTE "Your input is: ",0
    Game_ans BYTE "The correct answer is: ",0
    Game_win BYTE "Congratulations!!!!!",0dh,0ah
             BYTE "Do you want to play again ? ",0
    Game_bye BYTE "See you...",0dh,0ah,0
    count_a DWORD 0h            ;��m�M�ȬۦP���Ӽ�
    count_b DWORD 0h            ;�ȬۦP����m���P���Ӽ�
    exe_time DWORD 0h           ;�n��J�X�Ӽƪ��Ӽ�
    captionW BYTE "Warning",0   ;���~�����W��
    captionQ BYTE "Question",0  ;���D�����W��
    captionI BYTE "Rule",0      ;�W�h�����W��
    ;�W�h���e
    Game_rule BYTE "�h�h�h�h��              �h  �h                                      ���h�h�h��",0dh,0ah
              BYTE "�h      �h              �h  �h                                    ����",0dh,0ah
              BYTE "�h      �h              �h  �h                  �h���h�h��        �h",0dh,0ah
              BYTE "�h      ��              �h  �h                  �h��    �h        �h",0dh,0ah
              BYTE "�h�h�h�h     �h    �h   �h  �h  ���h�h��        �h      �h        �h            ���h�h��  �h            �h  ���h�h��",0dh,0ah
              BYTE "�h      ��   �h    �h   �h  �h  �h              �h      �h        �h            �h    �h  �h            �h  �h",0dh,0ah
              BYTE "�h      �h   �h    �h   �h  �h  ���h�h��        �h      �h        �h            �h    �h   �h   ����   �h   ���h�h��",0dh,0ah
              BYTE "�h      �h   �h    �h   �h  �h        �h                          ����          �h    �h   �h  �h  �h  �h         �h",0dh,0ah
              BYTE "�h�h�h�h��   ���h�h��   �h  �h  ���h�h��                          ���h�h�h��  ���h�h��    ����    ����    ���h�h��",0dh,0ah,0dh,0ah
              BYTE "1. ���M�w�n�q�X�ӼƦr�A�u��q1��10",0dh,0ah
              BYTE "2. �A�ӿ�J�Ʀr",0dh,0ah
              BYTE "   ��J���Ʀr���׭n��q�X�ӼƦr�ۦP",0dh,0ah
              BYTE "3. �����J�ۦP���Ʀr",0dh,0ah
              BYTE "4. ���Ʀr��H�~���䵲���C��",0
    ;��ӹϼ�
    win_word BYTE  " /---\                         |",0dh,0ah
             BYTE  "|                              |",0dh,0ah
             BYTE  "|                              |",0dh,0ah
             BYTE  "|   ---      /--\    /--\   /--\",0dh,0ah
             BYTE  "|     /\    |    |  |    |  |  |",0dh,0ah
             BYTE  " \---/  |    \--/    \--/   \--/",0dh,0ah,0


.code
main PROC
    mov eax, 0+(11*16)          ;�]�w�I���Φr���C��
    call SetTextColor
Rule:                           ;���X�W�h����
    INVOKE MessageBox, NULL, ADDR Game_rule, ADDR captionI, MB_OK+MB_ICONINFORMATION+MB_APPLMODAL+MB_SYSTEMMODAL
Initial:
    call Clrscr
    mov edx, OFFSET Game_start  ;�C���}�l����X
    call Writestring
    call ReadDec                ;Ū���n��J�X�Ӽ�
    cmp eax, 0                  ;�p�GŪ�������O�Ʀr�A�N����Endding
    je Endding
    cmp eax, 10                 ;�Y�p�󵥩�10
    jbe L0                      ;�h����L0
    ;�Y�j��h���X���~�����A��ܿ�J���~
    INVOKE MessageBox, NULL, ADDR Game_wstart, ADDR captionW, MB_OK+MB_ICONEXCLAMATION+MB_APPLMODAL+MB_SYSTEMMODAL
    jmp Initial                 ;���^Initial���s��J
L0:
    mov exe_time, eax
    mov ecx, exe_time
    mov esi, offset temp
L1:                             ;���Ͷü�
    mov eax, 10
    call RandomRange
    mov dword ptr [esi], eax
    add esi, 4
    loop L1

C1:                             ;�P�_temp�O�_���ۦP����
    mov esi, OFFSET temp
    mov ecx, exe_time
    dec ecx
C2:
    mov edi, esi
    add edi, 4
    push ecx
C3:
    mov ebx, dword ptr [esi]
    cmp ebx, dword ptr [edi]
    jz Change                   ;�p�G���ۦP���A�h����Change
    add edi, 4
    loop C3

    pop ecx
    add esi, 4
    loop C2
    jmp Continue                ;�p�G���S���ۦP���A�h����Continue

Change:                         ;���ܬۦP���Ʀr
    mov eax, 10
    call RandomRange
    mov dword ptr [edi], eax
    jmp C1

Continue:                       ;�]�����S���ۦP���A�h�~�����
    mov esi, offset temp
    mov ecx, exe_time
    mov edx, OFFSET Game_ans    ;�L�Xtemp
    call WriteString
line1:
    mov eax, dword ptr [esi]
    call writedec
    add esi, 4
    loop line1
    call crlf

Start:                          ;���s��J�@��Ʀr
    mov count_a, 0
    mov count_b, 0
    mov ecx, exe_time           ;Ū����J����
    mov eax, 4
    mul ecx
    mov esi, offset input
    add esi, eax
    sub esi, 4
    mov ebx, 10
    call ReadDec
    cmp eax, 0                  ;�p�GŪ�������O�Ʀr�A�N����Endding
    je Endding
L2:                             ;�NŪ�����ƨ̷Ӷ��Ǧs����input
    mov edx, 0
    div ebx
    mov dword ptr [esi], edx
    sub esi, 4
    loop L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Check1:
    cmp eax, 0                  ;�Y��J�Ʀr�S���W�L�n��J������
    jz Check2                   ;�h����Check2
Err:                            ;�Y�W�L���׫h����Err
    ;���Xĵ�i�����A��ܿ�J���׿��~
    INVOKE MessageBox, NULL, ADDR Game_error_Length, ADDR captionW, MB_OK+MB_ICONEXCLAMATION+MB_APPLMODAL+MB_SYSTEMMODAL
    jmp Start                   ;����Start���s��J

Check2:
    cmp edx, 0                  ;�Y��J�Ʀr�u��n�ƤJ������
    jz Err                      ;����Err
                                ;�Y��J�Ʀr���׭�n�h�~�����

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C4:                             ;�P�_input�O�_���ۦP����
    mov esi, OFFSET input
    mov ecx, exe_time
    dec ecx
C5:
    mov edi, esi
    add edi, 4
    push ecx
C6:
    mov ebx, dword ptr [esi]
    cmp ebx, dword ptr [edi]
    jz Input_error              ;�p�G���ۦP���A�h����Input_error
    add edi, 4
    loop C6

    pop ecx
    add esi, 4
    loop C5
    jmp Correct                 ;�p�G���S���ۦP���A�h����Correct

Input_error:                    ;��ܿ�J���~
    ;���Xĵ�i�����A��ܿ�J���~
    INVOKE MessageBox, NULL, ADDR Game_error_Input, ADDR captionW, MB_OK+MB_ICONEXCLAMATION+MB_APPLMODAL+MB_SYSTEMMODAL
    jmp Start                   ;����Start���s��J

Correct:                        ;input�S���ۦP���Ʀr
    mov esi, offset temp        ;���A���Ӽ�
    mov edi, offset input
    mov ecx, exe_time
    mov eax, 0
L3:
    mov ebx, dword ptr [esi]
    cmp ebx, dword ptr [edi]
    jne L4
    inc count_a
L4:
    add esi, 4
    add edi, 4
    loop L3

    mov esi, offset temp        ;���B���Ӽ�
    mov ecx, exe_time
L5:
    mov edi, offset input
    push ecx
    mov ecx, exe_time
L6:
    mov ebx, [esi]
    cmp ebx, [edi]
    jne L7
    inc count_b
L7:
    add edi, 4
    loop L6

    pop ecx
    add esi, 4
    loop L5

Print:                          ;�L�X���G
    mov edx, OFFSET Game_input
    call WriteString
    mov eax, count_a
    call writedec
    mov al, "A"
    call writechar
    mov eax, count_b
    sub eax, count_a
    call writedec
    mov al, "B"
    call writechar
    call crlf

Restart:                        ;�P�_�O�_�����Ʀr���ۦP
    mov ebx, count_a
    cmp ebx, exe_time
    jnz Start                   ;�Y�S�������ۦP�A�h����Start

Win:                            ;�Y��J���T�A�h�L�Xwin_word
    mov edx, OFFSET win_word
    call WriteString
    ;���X�߰ݵ����A�ݬO�_�n���s�}�l
    INVOKE MessageBox, NULL, ADDR Game_win, ADDR captionQ, MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON1+MB_APPLMODAL+MB_SYSTEMMODAL
    cmp eax, IDYES              ;�p�G���U�~��C���A�h����Initial
    je Initial
Endding:                        ;�p�G���~��C���A�h�L�XGame_bye
    mov edx, OFFSET Game_bye
    call WriteString
    call waitmsg

    INVOKE ExitProcess,0
    exit
main ENDP
END main
