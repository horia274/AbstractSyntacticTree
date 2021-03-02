
struc node
    info resd 1
    left resd 1
    right resd 1
endstruc

section .data
    delim db " ", 0
    format db "%s", 13, 10, 0

section .bss
    input resd 1

section .text

extern calloc
extern strtok
extern strlen
extern strdup

global create_tree
global iocla_atoi


iocla_atoi:
    push    ebp                             ; creez cadrul de stiva
    mov     ebp, esp
    push    ebx                             ; salvez registrul ebx

    mov     esi, [ebp + 8]                  ; pun parametrul (string-ul) in esi
    xor     eax, eax                        ; eax -> numarul format
    xor     ebx, ebx                        ; ebx -> caracterul curent (bl)
    xor     ecx, ecx                        ; ecx -> indicele din esi

    cmp     byte [esi], '-'                 ; verific daca am numar negativ
    jne     compute_digit                   ; daca nu parcurg sirul de la inceput
    inc     ecx                             ; daca da, parcurg de la pozitia 1

compute_digit:
    mov     bl, byte [esi + ecx]            ; iau caracterul curent
    inc     ecx                             ; merg la urmatorul
    test    bl, bl                          ; verific daca am ajuns la '\0'
    je      check_sign

    sub     bl, '0'                         ; formez cifra corespunzatoare
    mov     edx, 10
    mul     edx                             ; inmultesc numarul curent cu 10
    add     eax, ebx                        ; si adun cifra curenta
    jmp     compute_digit                   ; reiau procedeul

check_sign:
    cmp     byte [esi], '-'                 ; dupa ce termin string-ul, verific 
    jne     exit_atoi                       ; daca numarul era negativ
    neg     eax                             ; daca da, il neg

exit_atoi:
    pop     ebx                             ; refac ebx-ul salvat la inceput
    leave
    ret


create_node:                                ; creez un nod din arbore si pun string-ul
    push    ebp                             ; dat ca parametru la valoarea nodului
    mov     ebp, esp
    mov     esi, [ebp + 8]                  ; salvez parametrul in esi

    push    esi                             ; aloc memorie pentru valoarea nodului
    call    strdup                          ; duplicand esi-ul
    mov     edi, eax
    add     esp, 4

    push    dword 12                        ; aloc memorie pentru nodul propriu-zis
    push    dword 1                         ; folosesc calloc pentru a pune 0 (NULL)
    call    calloc                          ; pe ambii fii ai nodului
    add     esp, 8

    mov     dword [eax + info], edi         ; pun string-ul alocat la locul lui in nod

    leave
    ret


create_tree:
    push    ebp                             ; creez cadrul de stiva
    mov     ebp, esp
    push    ebx                             ; salvez registrul ebx

    mov     esi, [ebp + 8]                  ; pun string-ul dat ca parametru in esi
    cmp     byte [esi], 0                   ; verific daca am ajuns la final,
    je      exit_tree                       ; caz in care opresc functia

    cmp     byte [esi], ' '                 ; daca am ajuns la spatiu, sar peste el
    jne     not_space
    inc     esi

not_space:
    push    esi                             ; duplic string-ul si il pun in variabila
    call    strdup                          ; input, intrucat urmeaza sa apelez strtok
    mov     [input], eax                    ; care va strica sirul dat ca parametru
    add     esp, 4

    push    dword delim                     ; apelez strtok pentru a obtine string-ul
    push    esi                             ; pana la primul spatiu
    call    strtok
    add     esp, 8

    push    esi                             ; creez un nod ce are ca info, string-ul
    call    create_node                     ; obtinut din apelare lui strtok
    add     esp, 4
    push    eax                             ; pun nodul creat pe stiva

    push    esi                             ; calculez lungimea substring-ului
    call    strlen                          ; obtinut
    add     esp, 4
    add     dword [input], eax              ; sar in string-ul initial peste substring

    cmp     eax, 1                          ; daca lungimea substring-ului este > 1
    ja      exit_tree                       ; am gasit un numar si opresc apelul curent

    cmp     byte [esi], '0'                 ; daca are are lungimea 1, verific daca
    jb      operator                        ; este operator

exit_tree:
    pop     eax                             ; scot nodul curent de pe stiva
    pop     ebx                             ; si il intorc
    leave
    ret

operator:
    push    dword [input]                   ; daca am dat de un operator, apelez
    call    create_tree                     ; functia recursiv, pentru fiul stang
    add     esp, 4

    pop     ebx                             ; nodul creat in cadrul apelului curent
    mov     dword [ebx + left], eax         ; leg in stanga, nodul obtinut in urma
    push    ebx                             ; apelului trecut (fiul stang)

    push    dword [input]                   ; fac acelasi lucru si pentru fiul drept
    call    create_tree
    add     esp, 4

    pop     ebx
    mov     dword [ebx + right], eax
    push    ebx

    jmp     exit_tree                       ; legaturile s-au creat si returnez nodul
