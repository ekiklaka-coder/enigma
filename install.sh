#!/bin/bash
set -e

PANEL_DIR="/var/www/pterodactyl"
ASSET_DIR="$PANEL_DIR/public/assets"
VIEW_FILE="$PANEL_DIR/resources/views/layouts/admin.blade.php"
CSS_FILE="$ASSET_DIR/enigma-theme.css"

echo "== INSTALL THEME: ENIGMA =="

if [ ! -d "$PANEL_DIR" ]; then
  echo "❌ Panel Pterodactyl tidak ditemukan"
  exit 1
fi

echo "🔒 Backup assets..."
cp -r "$ASSET_DIR" "$ASSET_DIR.backup.enigma.$(date +%s)"

echo "🎨 Pasang CSS Enigma..."
cat <<EOF > "$CSS_FILE"
body {
  background-color: #0f172a !important;
}
.sidebar {
  background: linear-gradient(180deg, #020617, #020617) !important;
}
.card, .bg-gray-800 {
  background-color: #020617 !important;
  border-radius: 12px;
}
button {
  border-radius: 10px !important;
}
EOF

echo "🧩 Inject CSS ke panel..."
grep -q "enigma-theme.css" "$VIEW_FILE" || \
sed -i '/<\/head>/i <link rel="stylesheet" href="\/assets\/enigma-theme.css">' "$VIEW_FILE"

echo "🧹 Clear cache..."
cd "$PANEL_DIR"
php artisan view:clear
php artisan optimize:clear

echo "✅ THEME ENIGMA BERHASIL DIPASANG"
