* Mastering Host 2
* Sujet 2 Débugger et désassembler des programmes compilés

> install de "gdb" et "ghidra" sur ubuntu

Pour compiler j'ai fait :
```
gcc -g hw.c -o hw
```

execution de hw compilé
```bash
malory@malory-VirtualBox:~/Documents/masteringhost$ ./hw
Hello, World!
```

j'ai désassemblé "main"
```
(gdb) disass main
Dump of assembler code for function main:
   0x000000000000064a <+0>:	push   %rbp
   0x000000000000064b <+1>:	mov    %rsp,%rbp
   0x000000000000064e <+4>:	lea    0x9f(%rip),%rdi        # 0x6f4
   0x0000000000000655 <+11>:	mov    $0x0,%eax
   0x000000000000065a <+16>:	callq  0x520 <printf@plt>
   0x000000000000065f <+21>:	mov    $0x0,%eax
   0x0000000000000664 <+26>:	pop    %rbp
   0x0000000000000665 <+27>:	retq   
End of assembler dump.
```
Je pense que le "Hello, World!" est stocké dans "callq"
Elle est affichée en clair dans le terminal

> Je repasse sous windows ( j'ai pas réussi sur ubuntu )pour le crack de Winrar et j'install "resource hacker"

Sur resource hacker je fais:
Open WinRAR.exe > dialog > REMINDER clique droit delete > fichier save as
fini :)

* Sujet 4 Analyse de boot

> Pour ce sujet je travaille sur une vm ubuntu

- Les 5 programmes les plus long à démarrer sont :
    - apt-daily.service (~44s)
    - plymounth-quit-wait.service (~19s)
    - vboxadd.service (~9s)
    - dev-sda1.service (~6s)
    - dev-loop19.service (~3.8s)

- Analyser les logs de boot du noyau (avec la commande dmesg) :
    - cpu, bios physical ram, ramdisk
    - linux version 5.3.0-59.63~18.04.1-generic
    - 5 lignes qui me semblent importantes
        - mount-cache hash table entries : ram physique réservée
        - systemd : tout ce qui concerne le systeme
        - os product : qui à produit l'os
        - os release : l'identification du systeme ?
        - os version : la version de l'os
    - non le dernier log est "btrfs loaded"
