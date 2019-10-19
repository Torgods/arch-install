#!/bin/bash
	loadkeys ru
	setfont cyr-sun16

echo "Форматирование и монтирование разделов[a1] "
	read -p "Ведите литиру и № раздела boot :" disk1
	read -p "Ведите литиру и № раздела root :" disk2
	read -p "Ведите литиру и № раздела home :" disk3
	read -p "Ведите литиру и № раздела swap :" disk4

	mkfs.ext2 /dev/sd$disk1 -L boot
	mkfs.ext4 /dev/sd$disk2 -L root
	mkfs.ext4 /dev/sd$disk3 -L home
	mkswap /dev/sd$disk4 -L swap

	mount /dev/sd$disk2 /mnt
	mkdir /mnt/{boot,home}
	mount /dev/sd$disk1 /mnt/boot
	mount /dev/sd$disk3 /mnt/home
	swapon /dev/sd$disk4
