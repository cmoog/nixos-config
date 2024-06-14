{ writeShellApplication, bc }:
writeShellApplication {
  name = "machineinfo";
  runtimeInputs = [ bc ];
  text = builtins.readFile ./machineinfo.sh;
  bashOptions = [ ];
  excludeShellChecks = [ "SC1091" ];
}
