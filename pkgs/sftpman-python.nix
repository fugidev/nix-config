{
  lib,
  python3Packages,
  fetchFromGitHub,
  stdenv,
  mountPath ? null,
}:

python3Packages.buildPythonApplication rec {
  pname = "sftpman-python";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spantaleev";
    repo = "sftpman-python";
    tag = version;
    hash = "sha256-Zw3COfA1vM/5xnM/od6cNZuTlDT4yKwgUV/FAk1akpU=";
  };

  build-system = with python3Packages; [ setuptools ];

  postPatch =
    lib.optionalString (mountPath != null) ''
      substituteInPlace sftpman/model.py \
        --replace-fail '/mnt/sshfs/' '${mountPath}' \

    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace sftpman/model.py \
        --replace-fail 'fusermount -u' 'umount' \
        --replace-fail 'mount -l' 'mount' \
        --replace-fail 'type fuse\\.sshfs' '.*macfuse'
    '';

  checkPhase = ''
    $out/bin/sftpman help
  '';

  pythonImportsCheck = [ "sftpman" ];

  meta.mainProgram = "sftpman";
}
