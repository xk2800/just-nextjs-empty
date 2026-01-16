#!/bin/bash
# CONFIGURATION
PI_USER="admin"
PI_HOST="192.168.68.54"      # Use your Pi's Local IP
PI_PASS="admin" # <--- YOUR PASSWORD GOES HERE

echo "🚧 Building Next.js..."
bun run build

echo "🚀 Uploading files..."
# The "/" after 'standalone' is critical—it means "copy the contents of this folder"
sshpass -p "$PI_PASS" rsync -avz -e "ssh $SSH_OPTS" .next/standalone/ $PI_USER@$PI_HOST:/home/$PI_USER/test-app/

# These two copy the static assets into the internal .next folder where server.js expects them
sshpass -p "$PI_PASS" rsync -avz -e "ssh $SSH_OPTS" .next/static/ $PI_USER@$PI_HOST:/home/$PI_USER/test-app/.next/static/
sshpass -p "$PI_PASS" rsync -avz -e "ssh $SSH_OPTS" public/ $PI_USER@$PI_HOST:/home/$PI_USER/test-app/public/

echo "🔄 Restarting Service..."
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_HOST "cd /home/$PI_USER/test-app && pm2 restart next-app"

echo "✅ Deployment Complete!"