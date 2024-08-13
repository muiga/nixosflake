{ stdenv, lib, fetchFromGitHub, cmake,  gcc, 
  xdg-utils, extra-cmake-modules, qt6, callPackage, wrapQtAppsHook }:

let
  # Import the KDE Frameworks 5 (kf5) set
  kf5 = callPackage <nixpkgs> {};
  make = callPackage <nixpkgs> {};
in

stdenv.mkDerivation rec {
  pname = "klassy";
  version = "6.1.breeze6.0.3"; # Replace with the correct version

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-D8vjc8LT+pn6Qzn9cSRL/TihrLZN4Y+M3YiNLPrrREc=";  # Replace with the correct SHA256
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [
    gcc
    xdg-utils

    # Qt6 libraries
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg

    # KDE Frameworks 5 libraries
    # kf5.kcmutils
    # kf5.kcolorscheme
    # kf5.kconfig
    # kf5.kcoreaddons
    # kf5.kdecoration
    # kf5.kguiaddons
    # kf5.ki18n
    # kf5.kiconthemes
    # kf5.kirigami2
    # kf5.kwidgetsaddons
    # kf5.kwindowsystem
    # kf5
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  installPhase = ''
    make install
  '';

  meta = with lib; {
    description = "Klassy C++ project";
    homepage = "https://github.com/paulmcauley/${pname}";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
