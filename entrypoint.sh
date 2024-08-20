#!/bin/bash
set -ev

if [ -z ${PRINTER_USERNAME+x} ]; then echo 'ERROR: PRINTER_USERNAME is not defined.' && exit 1; fi
if [ -z ${PRINTER_PASSWORD+x} ]; then echo 'ERROR: PRINTER_PASSWORD is not defined.' && exit 1; fi
if [ -z ${OUTPUT_USERNAME+x} ]; then echo 'ERROR: OUTPUT_USERNAME is not defined.' && exit 1; fi
if [ -z ${PRINTER_ID+x} ]; then echo 'ERROR: PRINTER_ID is not defined.' && exit 1; fi
if [ -z ${PRINTER_NAME+x} ]; then echo 'ERROR: PRINTER_NAME is not defined.' && exit 1; fi

useradd -G lp,lpadmin -s /bin/bash -p "$(openssl passwd -1 $PRINTER_PASSWORD)" $OUTPUT_USERNAME

cat cups-pdf.conf | envsubst > /etc/cups/cups-pdf.conf
cat cupsd.conf | envsubst > /etc/cups/cupsd.conf
cat printers.conf | envsubst > /etc/cups/printers.conf
cat vprint.service | envsubst > /etc/avahi/services/vprint.service
cp /usr/share/ppd/cups-pdf/CUPS-PDF_noopt.ppd /etc/cups/ppd/${PRINTER_ID}.ppd

chown $OUTPUT_USERNAME /mnt/output/${OUTPUT_SUBPATH}

if [ -z ${DISABLE_AVAHI+x} ]; then /usr/sbin/avahi-daemon --daemonize; fi

exec /usr/sbin/cupsd -f
