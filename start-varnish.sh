pkill varnishd
varnishd -f /etc/varnish/default.vcl -s malloc,200M -T 127.0.0.1:2000 -a 0.0.0.0:80 -p 'cc_command=exec cc -fpic -shared -Wl,-x -L/usr/include/GeoIP.h -lGeoIP -o %o %s'
