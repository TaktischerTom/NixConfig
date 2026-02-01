{
  lib,
  ...
}: {
  options = {
    mainUser = lib.mkOption {
      default = "tom";
      type = lib.types.str;
    };
  }
}