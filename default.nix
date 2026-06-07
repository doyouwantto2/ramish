{
  pkgs ? import <nixpkgs> { },
}:

let
  runtimeLibs = with pkgs; [
    gtk3
    gdk-pixbuf
    cairo
    pango
    libsoup_3
    webkitgtk_4_1
    gvfs
    glib
    mesa
    dbus
    libglvnd
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    alsa-lib
    udev
  ];

  buildTools = with pkgs; [
    # rustup
    pkg-config
    git
    nodejs
    bun
    tailwindcss
    xdg-utils
    makeWrapper
  ];

in
pkgs.mkShell {
  nativeBuildInputs = buildTools;

  buildInputs = runtimeLibs;

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH"

    export PKG_CONFIG_PATH="${
      pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" runtimeLibs
    }:$PKG_CONFIG_PATH"

    export PATH="$PATH:${pkgs.xdg-utils}/bin"

    export WEBKIT_DISABLE_COMPOSITING_MODE=1
  '';
}
