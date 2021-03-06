include libMakefile/C.make
TARGET = BOOTX64.EFI
ALSO = img run
CFLAGS = $(C-GCC-WFLAGS)
USE_GCC = 1
SRCS = src/uefi.c
OUTDIR = int/
include uefi/Makefile

EFIPARTNUM   = 1
EFIPARTSTART = 34
EFIPARTEND   = 2846

img: doswarn
	dd if=/dev/zero of=hdimage.iso bs=1k count=1440
	./fdisk.sh $(EFIPARTNUM) $(EFIPARTSTART) $(EFIPARTEND)
	dd if=hdimage.iso of=int/efipart.iso skip=$(EFIPARTSTART) bs=512 count=$$(( ( $(EFIPARTEND) - $(EFIPARTSTART) ) + 1))
	mformat -i int/efipart.iso -T 524216 -F :: -v "lizardOS   "
	mmd -i int/efipart.iso ::/EFI
	mmd -i int/efipart.iso ::/EFI/BOOT
	mcopy -i int/efipart.iso int/BOOTX64.EFI ::/EFI/BOOT
	dd if=int/efipart.iso of=hdimage.iso bs=512 seek=34 conv=notrunc
	dd if=int/dosmain.bin of=hdimage.iso conv=notrunc
	dd if=int/dossign.bin of=hdimage.iso bs=1 seek=510 conv=notrunc
run: img
	qemu-system-x86_64 -bios /usr/share/ovmf/OVMF.fd -hda hdimage.iso
doswarn: dosmain dossign
dosmain:
	as src/doswarn/main.asm -o $(OUTDIR)dosmain.o
	ld -o $(OUTDIR)dosmain.bin $(OUTDIR)dosmain.o -e start --oformat binary -Ttext 0x7c00
dossign:
	as src/doswarn/sign.asm -o $(OUTDIR)dossign.o
	ld -o $(OUTDIR)dossign.bin $(OUTDIR)dossign.o --oformat binary
gitignore:
	pastaignore -i .gitignore.pastaignore -o .gitignore --verbose --remove-duplicates

