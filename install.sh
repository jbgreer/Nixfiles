set -x

# parition root and boot
DISK=/dev/nvme0n1
sudo parted $DISK -- mklabel gpt
sudo parted $DISK -- mkpart ROOTPART 512MB 100%
sudo parted $DISK -- mkpart ESPPART fat32 1MB 512MB
sudo parted $DISK -- set 2 esp on
sudo parted $DISK -- set 2 boot on
sudo parted $DISK -- print all

# /boot
sudo mkfs.vfat -F 32 -n BOOTFS -v $DISK'p2'

# LUKS partition
sudo cryptsetup --verify-passphrase -v luksFormat $DISK'p1'
# >>> YES; create passphrase for LUKS partition
sudo cryptsetup open $DISK'p1' enc
# re-enter passphrase to open LUKS partition for more partition management

# setup LVN, with root & swap logical volumes
# Initialize volumegroup `pool`
sudo vgcreate pool /dev/mapper/enc
sudo lvcreate -n swap --size 32G pool
sudo mkswap -L SWAPFS --verbose /dev/pool/swap
sudo lvcreate -n root --extents 100%FREE pool
sudo mkfs.btrfs -L ROOTFS --verbose /dev/pool/root

# Mount btrfs root partition to initialize subvolumes
sudo mount -t btrfs /dev/pool/root /mnt

# Create subvolumes under btrfs root partition
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/log

# Take an empty readonly snapshot of the btrfs root
sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
sudo umount /mnt

# mount paritions in preparation for installation
sudo mount -o subvol=root,compress=zstd,noatime /dev/pool/root /mnt/

sudo mkdir -p /mnt/{boot,home,nix,persist,var/log}
sudo mount -o subvol=home,compress=zstd,noatime /dev/pool/root /mnt/home
sudo mount -o subvol=nix,compress=zstd,noatime /dev/pool/root /mnt/nix
sudo mount -o subvol=persist,compress=zstd,noatime /dev/pool/root /mnt/persist
sudo mount -o subvol=log,compress=zstd,noatime /dev/pool/root /mnt/var/log
sudo mount $DISK'p2' /mnt/boot

sudo nixos-generate-config --root /mnt
