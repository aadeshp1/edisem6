#!/bin/bash
sudoPW = "2NewUse$"
echo $sudoPW | sudo -S snort -q -l /var/log/snort -i wlo1 -A console -c /etc/snort/snort.conf > snort.log 2>&1
