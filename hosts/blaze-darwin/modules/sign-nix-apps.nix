## code signing set up like this:
# CERT_NAME="Nix Local Code Signing"
# install -d -m 700 /var/db/nix-codesign
# cd /var/db/nix-codesign
# cat > cert.cfg <<EOF
# [ req ]
# distinguished_name = req_dn
# [ req_dn ]
# CN = $CERT_NAME
# [ extensions ]
# keyUsage = digitalSignature
# extendedKeyUsage = codeSigning
# EOF
# openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -keyout dev.key -out dev.crt -config cert.cfg -extensions extensions -subj "/CN=$CERT_NAME"
# openssl pkcs12 -export -in dev.crt -inkey dev.key -out dev.p12 -password pass:nix
# KC=/var/db/nix-codesign/signing.keychain-db
# openssl rand -base64 24 > pass
# chmod 600 pass
# PW=$(cat pass)
# security create-keychain -p "$PW" "$KC"
# security import dev.p12 -k "$KC" -P nix -T /usr/bin/codesign
# security set-key-partition-list -S apple-tool:,apple: -s -k "$PW" "$KC"
# security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain dev.crt
# security list-keychains -d user -s "$KC" /Library/Keychains/System.keychain
# security default-keychain -d user -s "$KC"
# security find-identity -p codesigning /var/db/nix-codesign/signing.keychain-db

{ lib, ...}:
{
  system.activationScripts.applications.text = lib.mkAfter ''
    KC=/var/db/nix-codesign/signing.keychain-db
    security unlock-keychain -p "$(cat /var/db/nix-codesign/pass)" "$KC"
    security set-key-partition-list -S apple-tool:,apple:,codesign: -s \
      -k "$(cat /var/db/nix-codesign/pass)" "$KC" >/dev/null

    for app in "/Applications/Nix Apps"/*.app; do
      [ -d "$app" ] || continue
      codesign --force --keychain /var/db/nix-codesign/signing.keychain-db \
        --sign "Nix Local Code Signing" \
        --preserve-metadata=entitlements,flags,identifier \
        --timestamp=none "$app"
    done
  '';
}
