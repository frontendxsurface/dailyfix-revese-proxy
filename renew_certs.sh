#!/bin/bash

# URL ของ Discord Webhook
WEBHOOK_URL="https://discord.com/api/webhooks/1304340167565512725/6ijsVMXDXh-q7vF4c1r8DVsXUCko-rZCyYmA92Q_FI404ejJTfC53VmCMToqAmqszGAn"

# พยายามต่ออายุใบรับรอง SSL
RENEW_OUTPUT=$(certbot renew 2>&1)
RENEW_STATUS=$?

# ตรวจสอบสถานะของการต่ออายุใบรับรอง
if [ $RENEW_STATUS -eq 0 ]; then
    # แจ้งเตือนเมื่อการต่ออายุสำเร็จ
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"✅ SSL certificates have been successfully renewed!\"}" \
         $WEBHOOK_URL
    
    # รีโหลด Nginx หลังต่ออายุสำเร็จ
    nginx -s reload
else
    # แจ้งเตือนเมื่อการต่ออายุล้มเหลว
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"⚠️ SSL certificate renewal failed! Check logs for details.\nOutput: $RENEW_OUTPUT\"}" \
         $WEBHOOK_URL
fi
