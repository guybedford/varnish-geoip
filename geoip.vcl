C{

/*
 * Varnish-powered Geo IP lookup
 * Simplification made for Geo IP Country.
 *
 * Usage:
 * 
 * 
 * Guy Bedford 14/05/2012, from the below version::
 * 
 * ---
 * https://github.com/cosimo/varnish-geoip
 *
 * Varnish-powered Geo IP lookup
 *
 * Idea and GeoIP code taken from
 * http://svn.wikia-code.com/utils/varnishhtcpd/wikia.vcl
 *
 * Cosimo, 01/12/2011
 * ---
 */

#include <stdlib.h>
#include <GeoIP.h>
#include <pthread.h>

pthread_mutex_t geoip_mutex = PTHREAD_MUTEX_INITIALIZER;
GeoIP* gi;

/* Init GeoIP code */
void geoip_init () {
    if (!gi) {
        //UPDATE THE PATH BELOW TO THE GEOIP FOLDER
        gi = GeoIP_open("/var/GeoIP-1.4.8/data/GeoIP.dat", GEOIP_MEMORY_CACHE);
    }
}

/* Simplified version: sets "X-Geo-IP" header with the country only */
void vcl_geoip_country_set_header(const struct sess *sp) {
    pthread_mutex_lock(&geoip_mutex);

    if (!gi) {
        geoip_init();
    }
 
    char *ip = VRT_IP_string(sp, VRT_r_client_ip(sp));
    char buff[2];

    sprintf(buff, "%s", GeoIP_country_code_by_addr(gi, ip));

    pthread_mutex_unlock(&geoip_mutex);
    VRT_SetHdr(sp, HDR_REQ, "\011X-Geo-IP:", buff, vrt_magic_string_end);
}

}C
