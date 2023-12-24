set -x

# Set up partitions as desired. At least one fat32 for /boot or /boot/efi is needed along a main LUKS partition.
parted /dev/nvme0n1

# /boot
mkfs.vfat -F32 /dev/nvme0n1p1

# LUKS partition
cryptsetup --verify-passphrase -v luksFormat /dev/nvme0n1p2
# >>> YES; create passphrase for LUKS partition
cryptsetup open /dev/nvme0n1p2 enc
# re-enter passphrase to open LUKS partition for more partition management

# Optionally, if you want to use LVM and set up additional partitions like swap, you can do the following, otherwise skip this block
# Initialize volumegroup `pool`
vgcreate pool /dev/mapper/enc
# Create individual logical volumes
lvcreate -n swap --size 32G pool
mkswap /dev/pool/swap
lvcreate -n root --extents 100%FREE pool
mkfs.btrfs /dev/pool/root

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

# Aliasing function to simplify typing if need be:
# function pm { mount -o subvol=$1,compress=zstd,noatime /dev/pool/root /mnt/$2 ; }
# `pm root`
# `pm home home`
# `pm log var/log`

mount -o subvol=root,compress=zstd,noatime /dev/pool/root /mnt/

mkdir -p /mnt/{boot,home,nix,persist,var/log}
mount -o subvol=home,compress=zstd,noatime /dev/pool/root /mnt/home
mount -o subvol=nix,compress=zstd,noatime /dev/pool/root /mnt/nix
mount -o subvol=persist,compress=zstd,noatime /dev/pool/root /mnt/persist
mount -o subvol=log,compress=zstd,noatime /dev/pool/root /mnt/var/log
mount /dev/nvme0n1p1 /mnt/boot

