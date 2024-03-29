#!/bin/bash

loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true

echo "Если размечали диск только на один раздел "
echo "то нажмите (1)"
echo "Если на 2 boot и root"
echo "то нажмите (2)"
echo "Если создовали оделные разделы под boot root и home"
echo "то нажмите (3)"
echo "Если создовали разделы boot root home и swap"
echo "то нажмине (4)"

read -p "Вводим нужное чесло:" var
if   [[ $var == 1 ]]; then
	echo "Форматирование и монтирование раздела  "
	read -p "Ведите литиру и № раздела например(a1):" disk1
	mkfs.ext4 /dev/sd$disk1 -L root
	mount /dev/sd$disk2 /mnt
elif [[ $var == 2 ]]; then
	echo "Форматирование и монтирование разделов  "
	read -p "Ведите литиру и № раздела boot например(a1):" disk1
	read -p "Ведите литиру и № раздела root например(a1):" disk2
	mkfs.ext2 /dev/sd$disk1 -L boot
	mkfs.ext4 /dev/sd$disk2 -L root
	mount /dev/sd$disk2 /mnt
	mkdir /mnt/boot
elif [[ $var == 3 ]]; then
	echo "Форматирование и монтирование разделов "
	read -p "Ведите литиру и № раздела boot например(a1):" disk1
	read -p "Ведите литиру и № раздела root например(a1):" disk2
	read -p "Ведите литиру и № раздела home например(a1):" disk3
	mkfs.ext2 /dev/sd$disk1 -L boot
	mkfs.ext4 /dev/sd$disk2 -L root
	mkfs.ext4 /dev/sd$disk3 -L home
	mount /dev/sd$disk2 /mnt
	mkdir /mnt/{boot,home}
	mount /dev/sd$disk1 /mnt/boot
	mount /dev/sd$disk3 /mnt/home
elif [[ $var == 4 ]]; then
	echo "Форматирование и монтирование разделов "
	read -p "Ведите литиру и № раздела boot например(a1):" disk1
	read -p "Ведите литиру и № раздела root например(a1):" disk2
	read -p "Ведите литиру и № раздела home например(a1):" disk3
	read -p "Ведите литиру и № раздела swap например(a1):" disk4
	mkfs.ext2 /dev/sd$disk1 -L boot
	mkfs.ext4 /dev/sd$disk2 -L root
	mkfs.ext4 /dev/sd$disk3 -L home
	mkswap /dev/sd$disk4 -L swap
	mount /dev/sd$disk2 /mnt
	mkdir /mnt/{boot,home}
	mount /dev/sd$disk1 /mnt/boot
	mount /dev/sd$disk3 /mnt/home
	swapon /dev/sd$disk4
fi

echo "Установка зеркала yandex"
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo "Установка базовых пакетов"
pacstrap /mnt base base-devel

echo "Генерация таблици fstab"
genfstab -pU /mnt >> /mnt/etc/fstab


arch-chroot /mnt sh -c "$(curl -fsSL git.io/a2.sh)"

