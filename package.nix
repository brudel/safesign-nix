{
  lib,
  stdenv,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  openssl,
  pcsclite,
  gdbm,
  glib,
  gtk3,
  wxGTK32,
}:

stdenv.mkDerivation {
  pname = "safesign-identity-client";
  version = "4.7.0.0-AET.000";

  src = ./SafeSign.deb;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    pcsclite
    gdbm
    glib
    gtk3
    wxGTK32
    stdenv.cc.cc.lib
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a usr/lib usr/bin $out/
    cp -a usr/share $out/share
    substituteInPlace $out/share/applications/*.desktop \
      --replace-quiet "/usr/bin/" "$out/bin/"
    runHook postInstall
  '';

  meta = {
    description = "SafeSign Identity Client (PKCS#11 middleware for G&D StarSign tokens)";
    homepage = "https://www.aeteurope.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
