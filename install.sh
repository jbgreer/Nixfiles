set -x

# parition root and boot
DISK=/dev/nvme0n1
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ROOTPART 512MB 100%
parted $DISK -- mkpart ESPPART fat32 1MB 512MB
parted $DISK -- set 2 esp on
parted $DISK -- set 2 boot on
parted $DISK -- print all

# /boot
mkfs.vfat -F 32 -n BOOTFS -v $DISK'p2'

# LUKS partition
cryptsetup --verify-passphrase -v luksFormat $DISK'p1'
# >>> YES; create passphrase for LUKS partition
cryptsetup open $DISK'p1' enc
# re-enter passphrase to open LUKS partition for more partition management

# setup LVN, with root & swap logical volumes
# Initialize volumegroup `pool`
vgcreate pool /dev/mapper/enc
lvcreate -n swap --size 32G pool
mkswap -L SWAPFS --verbose /dev/pool/swap
lvcreate -n root --extents 100%FREE pool
mkfs.btrfs -L ROOTFS --verbose /dev/pool/root

# Mount btrfs root partition to initialize subvolumes
mount -t btrfs /dev/pool/root /mnt

# Create subvolumes under btrfs root partition
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log

# Take an empty readonly snapshot of the btrfs root
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
umount /mnt

# mount paritions in preparation for installation
mount -o subvol=root,compress=zstd,noatime /dev/pool/root /mnt/

mkdir -p /mnt/{boot,home,nix,persist,var/log}
mount -o subvol=home,compress=zstd,noatime /dev/pool/root /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/pool/root /mnt/nix
mount -o subvol=persist,compress=zstd,noatime /dev/pool/root /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/pool/root /mnt/var/log
mount $DISK'p2' /mnt/boot