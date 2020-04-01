#Lesson 2 加载软盘中的内容到内存，并跳转执行
all: bootimg
	
	@#dd if=bootimg of=a.img bs=512 count=2 conv=notrunc

bootsect: bootsect.s
	@as -o bootsect.o bootsect.s
	@ld -Ttext 0 -o bootsect bootsect.o
	@objcopy -R .pdr -R .comment -R.note -S -O binary bootsect	
	@#objcopy截取纯代码内容,忽略elf文件头等信息

demo: demo.s
	@as -o demo.o demo.s
	@ld -Ttext 0 -o demo demo.o
	@objcopy -R .pdr -R .comment -R.note -S -O binary demo

bootimg: demo bootsect
	@dd if=bootsect of=bootimg bs=512 count=1
	@dd if=demo of=bootimg bs=512 count=4 seek=1

run_q: bootimg
	@qemu-system-i386 -boot a -fda bootimg

run_b:bochsrc
	@bochs -f bochsrc

clean:
	@rm -f bootimg bootsect demo *.o *~
