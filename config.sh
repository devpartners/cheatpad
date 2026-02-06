# ── Config ──
SUB="Your Azure Subscription"
SUB="EffAz-Prod"
STORAGE="yourstorageaccount"
STORAGE="stcheatpad"
RG="your-resource-group"
RG="rg-cheatpad"

SOURCE="./topics"  # local folder with your HTML files

# ── Get connection string (supports --subscription) ──
CONN=$(az storage account show-connection-string \
  -n "$STORAGE" \
  -g "$RG" \
  --subscription "$SUB" \
  --output tsv)

# ── Enable static website hosting ──
az storage blob service-properties update \
  --connection-string "$CONN" \
  --static-website \
  --index-document index.html \
  --404-document 404.html

# ── Upload files to $web container ──
az storage blob upload-batch \
  -s "$SOURCE" \
  -d '$web' \
  --connection-string "$CONN" \
  --overwrite

# ── Show the public URL ──
az storage account show \
  -n "$STORAGE" \
  -g "$RG" \
  --subscription "$SUB" \
  --query "primaryEndpoints.web" \
  --output tsv
