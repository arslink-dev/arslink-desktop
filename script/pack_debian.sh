#!/bin/bash
set -e

VERSION="$1"
ARCH="$2"

mkdir -p ArsLink/DEBIAN
mkdir -p ArsLink/opt
cp -r linux-$ARCH$([[ $3 == "systemqt" ]] && echo "-system-qt") ArsLink/opt
mv ArsLink/opt/linux-$ARCH$([[ $3 == "systemqt" ]] && echo "-system-qt") ArsLink/opt/ArsLink
rm ArsLink/opt/ArsLink/ArsLink.debug

# basic
cat >ArsLink/DEBIAN/control <<-EOF
Package: ArsLink
Version: $VERSION
Architecture: $ARCH
Maintainer: Mahdi Mahdi.zrei@gmail.com
Depends: desktop-file-utils$([[ $3 == "systemqt" ]] && echo ", libqt6core6, libqt6gui6, libqt6network6, libqt6widgets6, qt6-qpa-plugins, qt6-wayland, qt6-gtk-platformtheme, qt6-xdgdesktopportal-platformtheme, libxcb-cursor0, fonts-noto-color-emoji")
Description: Qt based cross-platform GUI proxy configuration manager (backend: sing-box)
EOF

cat >ArsLink/DEBIAN/postinst <<-EOF
cat >/usr/share/applications/ArsLink.desktop<<-END
[Desktop Entry]
Name=ArsLink
Comment=Qt based cross-platform GUI proxy configuration manager (backend: sing-box)
Exec=sh -c "PATH=/opt/ArsLink:\$PATH /opt/ArsLink/ArsLink -appdata"
Icon=/opt/ArsLink/Throne.png
Terminal=false
Type=Application
Categories=Network;Application;
END

update-desktop-database
EOF

sudo chmod 0755 ArsLink/DEBIAN/postinst

# desktop && PATH

sudo dpkg-deb --build ArsLink
