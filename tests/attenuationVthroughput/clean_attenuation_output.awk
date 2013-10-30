BEGIN { atten=30; print "|Attenuation Value: |Signal:  |MCS Level: |Throughput:|";}
/signal:/ { printf "|" atten "|" $2 " dBm|"; }
/tx bitrate:/ { printf $6 "|"; }
/MBytes/ { print $7 " Mbps|"; atten+=2;}
