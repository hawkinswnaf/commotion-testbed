#!/bin/bash

source ../ip_addrs.sh
source ../mac_addrs.sh
source ../ssh_options.sh
attenuation_start=30
attenuation_end=70

b_wireless=`ssh root@${NODE_B_IP} $extra_ssh_options '/sbin/ifconfig wlan0-1 | grep "inet addr" | awk -F ':' "{print \\$2;}" | awk "{print \\$1;}"'`

#Initialize the switch to full attenuation.
#cat 127.xml | nc 127.0.0.1 50050

#Kill any previously started iperfs
ssh root@${NODE_B_IP} $extra_ssh_options 'killall iperf; iperf -s &'
ssh root@${NODE_A_IP} $extra_ssh_options 'rm -f /tmp/iperf_output'

attenuation=$attenuation_start
while [ $attenuation -lt $attenuation_end ]; do
    echo "Setting attenuation to $attenuation"
    sed s/ATT/$attenuation/g signal_quality.xml | nc 127.0.0.1 50050
    sleep 10
    echo "Running iperf"
    ssh root@${NODE_A_IP} $extra_ssh_options "iw dev wlan0-1 station get 02:27:22:4e:96:32 >> /tmp/iperf_output"
    ssh root@${NODE_A_IP} $extra_ssh_options "iperf -c ${b_wireless} >> /tmp/iperf_output"
    (( attenuation = $attenuation + 2 ))
done
#end the iperf on the B node
ssh root@${NODE_B_IP} $extra_ssh_options 'killall iperf'
#get the output from the iperf commands.
scp $extra_ssh_options root@${NODE_A_IP}:/tmp/iperf_output ./attenuation_output.txt

awk -f clean_attenuation_output.awk < ./attenuation_output.txt
