{ lib, ... }@args:
{
  options.debugArgs = lib.mkOption {
    type = lib.types.attrs;
    default = args;
    readOnly = true;
  };
}
