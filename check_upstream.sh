#!/bin/bash

# URL ของ Discord Webhook
WEBHOOK_URL="https://discord.com/api/webhooks/1304340167565512725/6ijsVMXDXh-q7vF4c1r8DVsXUCko-rZCyYmA92Q_FI404ejJTfC53VmCMToqAmqszGAn"

# รายชื่อของ upstream servers
UPSTREAM_SERVERS=("ec2-18-136-193-186.ap-southeast-1.compute.amazonaws.com:5000" "ec2-13-213-56-253.ap-southeast-1.compute.amazonaws.com:5000")

# วนลูปตรวจสอบแต่ละ upstream
for SERVER in "${UPSTREAM_SERVERS[@]}"; do
    # ตรวจสอบสถานะของแต่ละ upstream
    UPSTREAM_STATUS=$(curl --write-out "%{http_code}" --silent --output /dev/null "http://$SERVER")

    # ถ้าค่าที่ได้จากการตรวจสอบเป็น 5xx หรือ 4xx หมายถึง upstream ล่ม
    if [[ "$UPSTREAM_STATUS" -ge 500 ]] || [[ "$UPSTREAM_STATUS" -ge 400 && "$UPSTREAM_STATUS" -lt 500 ]]; then
        # แจ้งเตือนผ่าน Discord
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"⚠️ Nginx upstream $SERVER is down! Status code: $UPSTREAM_STATUS\"}" \
             $WEBHOOK_URL
    else
        # ถ้า upstream ทำงานปกติ
        echo "$SERVER is up and running with status code $UPSTREAM_STATUS"
    fi
done
