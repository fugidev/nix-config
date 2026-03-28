{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  fetchPypi,
  buildPythonPackage,

  setuptools,
  versioningit,
  aiohttp,
  xmltodict,
  pycryptodome,
}:

let
  homeconnect-websocket = buildPythonPackage rec {
    pname = "homeconnect_websocket";
    version = "1.5.2";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-y5Efstx0+ZZzw+sQQFKVCM7lPHRVl3qKAnLIvDRbzF8=";
    };

    build-system = [
      setuptools
      versioningit
    ];

    dependencies = [
      aiohttp
      xmltodict
      pycryptodome
    ];
  };
in

buildHomeAssistantComponent {
  owner = "chris-mc1";
  domain = "homeconnect_ws";
  version = "1.0.5b10-unstable-2026-03-21";

  src = fetchFromGitHub {
    owner = "chris-mc1";
    repo = "homeconnect_local_hass";
    rev = "cc5143b7333adac51c1fc757512eae10b226c4dd";
    hash = "sha256-MYDZ3Nxz6Hc69DioXlBH5Sq8hB9NCNljSRO5sjdSsbY=";
  };

  patches = [ ./fix-homeconnect-local.patch ];

  dependencies = [
    homeconnect-websocket
  ];
}
