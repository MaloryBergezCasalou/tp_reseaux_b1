* Mastering Host 2
    * Sujet 2 

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

> Je repasse sous windows pour le crack de Winrar et j'install "resource hacker"

Sur resource hacker je fais:
Open WinRAR.exe > dialog > REMINDER clique droit delete > fichier save as
fini :)



