#!/system/bin/sh

if [ "$(getprop ro.vendor.product.device)" == "HWBKL" ];then
      phh-su -c 'mount -o remount,rw /system'
      phh-su -c 'pm uninstall --user 0 com.android.camera2'
      phh-su -c 'mount -o remount,ro /system'
else 
      phh-su -c 'mount -o remount,rw /system'
      phh-su -c 'pm uninstall --user 0 com.huawei.camera'
      phh-su -c 'mount -o remount,ro /system'
fi

if [ -f /vendor/bin/mtkmal ];then
    if [ "$(getprop persist.mtk_ims_support)" == 1 ];then
        setprop persist.mtk_ims_support 0
        setprop persist.mtk_epdg_support 0
        reboot
    fi
fi

#Clear looping services
sleep 30
getprop | \
    grep restarting | \
    sed -nE -e 's/\[([^]]*).*/\1/g'  -e 's/init.svc.(.*)/\1/p' |
    while read svc ;do
        setprop ctl.stop $svc
    done

if grep -qF android.hardware.boot /vendor/manifest.xml;then
	bootctl mark-boot-successful
fi
