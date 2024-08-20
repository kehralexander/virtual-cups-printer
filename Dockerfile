FROM debian:bullseye-slim

ENV \
    PRINTER_ID=Paperless_Printer \
    PRINTER_NAME=Paperless\ Printer \
    OUTPUT_USERNAME=cups \
    HOSTNAME=127.0.0.1 \
    OUTPUT_SUBPATH=vprint

RUN apt-get update && \
    apt-get install -y --no-install-recommends cups printer-driver-cups-pdf gettext && \
    apt-get install -y avahi-daemon && \
    sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf && \
    apt-get clean

# Copy configs
WORKDIR /opt/vp
COPY . .

CMD ["./entrypoint.sh"]
