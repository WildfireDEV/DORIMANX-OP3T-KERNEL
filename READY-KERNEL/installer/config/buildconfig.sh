#!/sbin/sh

# Script originaly created by flar2@github.com
# https://github.com/flar2/android_kernel_oneplus_msm8996

#Build config file
CONFIGFILE="/tmp/init.dorimanx.rc"
BACKUP="/sdcard/.dorimanx.backup"

echo "on boot" >> $CONFIGFILE
echo "" >> $CONFIGFILE

# fsync
FSYNC=`grep "item.0.1" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ $FSYNC = 1 ]; then
  echo "write /sys/module/sync/parameters/fsync_enabled 0" >> $CONFIGFILE
fi

# backlight dimmer
BLDIM=`grep "item.0.2" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ $BLDIM = 1 ]; then
  echo "write /sys/module/mdss_fb/parameters/backlight_dimmer 1" >> $CONFIGFILE
fi

# Tocuh Leds delay
TLCTL=`grep "item.0.3" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ $TLCTL = 1 ]; then
  echo "write /sys/class/misc/btk_control/btkc_mode 1" >> $CONFIGFILE
else
  echo "write /sys/class/misc/btk_control/btkc_mode 0" >> $CONFIGFILE
fi

TLTIME1=`grep item.0.4 /tmp/aroma/mods.prop | cut -d '=' -f2`
TLTIME2=`grep item.0.5 /tmp/aroma/mods.prop | cut -d '=' -f2`
TLTIME3=`grep item.0.6 /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ $TLTIME1 = 1 ]; then
  echo "write /sys/class/misc/btk_control/btkc_timeout 2000" >> $CONFIGFILE
fi
if [ $TLTIME2 = 1 ]; then
  echo "write /sys/class/misc/btk_control/btkc_timeout 5000" >> $CONFIGFILE
fi
if [ $TLTIME3 = 1 ]; then
  echo "write /sys/class/misc/btk_control/btkc_timeout 7000" >> $CONFIGFILE
fi

# S2W
SR=`grep "item.1.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
SL=`grep "item.1.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
SU=`grep "item.1.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
SD=`grep "item.1.4" /tmp/aroma/gest.prop | cut -d '=' -f2`

if [ $SL = 1 ]; then
  SL=2
fi
if [ $SU == 1 ]; then
  SU=4
fi
if [ $SD == 1 ]; then
  SD=8
fi  

S2W=$(( SL + SR + SU + SD ))
echo "write /sys/android_touch/sweep2wake " $S2W >> $CONFIGFILE

# DT2W
DT2W=`grep "item.1.5" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo "write /sys/android_touch/doubletap2wake " $DT2W >> $CONFIGFILE


# S2S
S2S=`grep selected.0 /tmp/aroma/s2s.prop | cut -d '=' -f2`
if [ $S2S = 2 ]; then
  echo "write /sys/sweep2sleep/sweep2sleep 1" >> $CONFIGFILE
elif [ $S2S = 3 ]; then
  echo "write /sys/sweep2sleep/sweep2sleep 2" >> $CONFIGFILE
elif [ $S2S = 4 ]; then
  echo "write /sys/sweep2sleep/sweep2sleep 3" >> $CONFIGFILE
else
  echo "write /sys/sweep2sleep/sweep2sleep 0" >> $CONFIGFILE
fi


# Wakelocks
WAKE1=`grep "item.0.1" /tmp/aroma/wakes.prop | cut -d '=' -f2`
WAKE2=`grep "item.0.2" /tmp/aroma/wakes.prop | cut -d '=' -f2`
WAKE3=`grep "item.0.3" /tmp/aroma/wakes.prop | cut -d '=' -f2`
WAKE4=`grep "item.0.4" /tmp/aroma/wakes.prop | cut -d '=' -f2`
WAKE5=`grep "item.0.5" /tmp/aroma/wakes.prop | cut -d '=' -f2`
WAKE6=`grep "item.0.6" /tmp/aroma/wakes.prop | cut -d '=' -f2`

if [ $WAKE1 = 1 ]; then
  echo "write /sys/module/wakeup/parameters/enable_ipa_ws N" >> $CONFIGFILE
fi
if [ $WAKE2 = 1 ]; then
  echo "write /sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws N" >> $CONFIGFILE
fi
if [ $WAKE3 = 1 ]; then
  echo "write /sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws N" >> $CONFIGFILE
fi
if [ $WAKE4 = 1 ]; then
  echo "write /sys/module/wakeup/parameters/enable_wlan_ws N" >> $CONFIGFILE
fi
if [ $WAKE5 = 1 ]; then
  echo "write /sys/module/wakeup/parameters/enable_timerfd_ws N" >> $CONFIGFILE
fi
if [ $WAKE6 = 1 ]; then
  echo "write /sys/module/wakeup/parameters/enable_netlink_ws N" >> $CONFIGFILE
fi


echo "" >> $CONFIGFILE
echo "on property:sys.boot_completed=1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

# i/o scheduler
SCHED=`grep selected.1 /tmp/aroma/disk.prop | cut -d '=' -f2`
if [ $SCHED = 1 ]; then
  echo "write /sys/block/dm-0/queue/scheduler cfq"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler cfq"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler cfq"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler cfq"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler cfq"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler cfq"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler cfq"  >> $CONFIGFILE
elif [ $SCHED = 2 ]; then
  echo "write /sys/block/dm-0/queue/scheduler deadline"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler deadline"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler deadline"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler deadline"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler deadline"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler deadline"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler deadline"  >> $CONFIGFILE
elif [ $SCHED = 3 ]; then
  echo "write /sys/block/dm-0/queue/scheduler fiops"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler fiops"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler fiops"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler fiops"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler fiops"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler fiops"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler fiops"  >> $CONFIGFILE
elif [ $SCHED = 4 ]; then
  echo "write /sys/block/dm-0/queue/scheduler sio"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler sio"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler sio"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler sio"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler sio"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler sio"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler sio"  >> $CONFIGFILE
elif [ $SCHED = 5 ]; then
  echo "write /sys/block/dm-0/queue/scheduler bfq"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler bfq"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler bfq"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler bfq"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler bfq"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler bfq"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler bfq"  >> $CONFIGFILE
elif [ $SCHED = 6 ]; then
  echo "write /sys/block/dm-0/queue/scheduler noop"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler noop"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler noop"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler noop"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler noop"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler noop"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler noop"  >> $CONFIGFILE
elif [ $SCHED = 7 ]; then
  echo "write /sys/block/dm-0/queue/scheduler zen"  >> $CONFIGFILE
  echo "write /sys/block/sda/queue/scheduler zen"  >> $CONFIGFILE
  echo "write /sys/block/sdb/queue/scheduler zen"  >> $CONFIGFILE
  echo "write /sys/block/sdc/queue/scheduler zen"  >> $CONFIGFILE
  echo "write /sys/block/sdd/queue/scheduler zen"  >> $CONFIGFILE
  echo "write /sys/block/sde/queue/scheduler zen"  >> $CONFIGFILE
  echo "write /sys/block/sdf/queue/scheduler zen"  >> $CONFIGFILE
fi

# set readahead to 128
# With SSD, there are no mechanical rotational latency issues so the SSD storage uses a small 4k read-ahead. but i will set 128 for now.
echo "write /sys/block/sda/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sdb/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sdc/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sdd/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sde/queue/read_ahead_kb 128" >> $CONFIGFILE
echo "write /sys/block/sdf/queue/read_ahead_kb 128" >> $CONFIGFILE

# Enable force Fast Charge
echo "write /sys/kernel/fast_charge/force_fast_charge 1" >> $CONFIGFILE

# Make Sure touch boost is enabled.
echo "write /sys/module/cpu_boost/parameters/input_boost_enabled 1" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_ms 40" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_freq 0:1286400 1:1286400 2:1440000 3:1440000" >> $CONFIGFILE

# reinstall options
echo -e "##### Reinstall Options #####" > $BACKUP
echo -e "# These settings are only applied if you run the express installer" >> $BACKUP
