{ mkDerivation
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kdecoration
, plasma-workspace
, qt6
, frameworkintegration
, kcmutils
, kcolorscheme
, kconfig
, kcoreaddons
, kguiaddons
, ki18n
, kiconthemes
, kirigami
, kwidgetsaddons
, kwindowsystem
, kcmutils5
, frameworkintegration5
, kconfigwidgets5
, kiconthemes5
, kirigami2
, kwindowsystem5
}:

mkDerivation rec {
  pname = "klassy";
  version = "6.1.breeze6.0.3";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    rev = "${version}";
    sha256 = "0qkjzgjplgwczhk6959iah4ilvazpprv7yb809jy75kkp1jw8mwk";
  };

  buildInputs = [
    kdecoration
    plasma-workspace
    frameworkintegration
    libgcc
    glibc 
    kcmutils
    kcolorscheme 
    kconfig 
    kcoreaddons 
    kguiaddons 
    ki18n 
    kiconthemes 
    kirigami 
    kwidgetsaddons
    kwindowsystem 
    qt6.base
    qt6.declarative 
    qt6.svg
    xdg-utils
    extra-cmake-modules
    kcmutils5
    frameworkintegration5
    kconfigwidgets5
    kiconthemes5
    kirigami2
    kwindowsystem5
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "A fork of breeze theme style that aims to be visually modern and minimalistic";
    homepage = "https://github.com/paulmcauley/klassy";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.paulmcauley ];
    platforms = platforms.all;
  };
}


# sudo pacman -S cmake extra-cmake-modules kdecoration qt5-declarative qt5-x11extras

# sudo pacman -S git frameworkintegration gcc-libs glibc kcmutils kcolorscheme kconfig kcoreaddons kdecoration kguiaddons ki18n kiconthemes kirigami kwidgetsaddons kwindowsystem qt6-base qt6-declarative qt6-svg xdg-utils extra-cmake-modules kcmutils5 frameworkintegration5 kconfigwidgets5 kiconthemes5 kirigami2 kwindowsystem5