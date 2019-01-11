# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=RaidenKernel by arunassain @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=karate
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
backup_file init.rc;
replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

grep "import /init.spectrum.rc" init.rc >/dev/null || sed -i '1,/.*import.*/s/.*import.*/import \/init.spectrum.rc\n&/' init.rc
insert_line init.rc "init.raid.rc" after "import /init.environ.rc" "import /init.raid.rc\n";

# Add empty profile locations
if [ ! -d /data/media/Spectrum ]; then
  ui_print " "; ui_print "Creating /data/media/0/Spectrum...";
  mkdir /data/media/0/Spectrum;
fi
if [ ! -d /data/media/Spectrum/profiles ]; then
  mkdir /data/media/0/Spectrum/profiles;
fi
if [ ! -d /data/media/Spectrum/profiles/*.profile ]; then
  ui_print " "; ui_print "Creating empty profile files...";
  touch /data/media/0/Spectrum/profiles/balance.profile;
  touch /data/media/0/Spectrum/profiles/performance.profile;
  touch /data/media/0/Spectrum/profiles/battery.profile;
  touch /data/media/0/Spectrum/profiles/gaming.profile;
fi

# end ramdisk changes

write_boot;

## end install
