let
    moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
    ros_tar = (builtins.fetchTarball {
        name = "nix-ros-overlay";
        url = "https://github.com/lopsided98/nix-ros-overlay/archive/99f3f46f30549d6aee851b4ef0c341fbc36c1759.tar.gz";
    });
    ros_overlay = import (ros_tar + "/overlay.nix" );
    nixpkgs = import ros_tar { overlays = [ moz_overlay ]; };
    rust = (nixpkgs.rustChannelOf { channel = "stable"; }).rust.override {
        extensions = [ "rust-src" "rust-analysis" "rls-preview" ];
    };
in
    { pkgs ? nixpkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; with rosPackages.noetic; [
    gazebo
    rust
    gazebo-plugins
    gazebo-ros
    gazebo-ros-pkgs
    roslaunch
    rostopic
    rosbash
    python3
    catkin
    cmake
    glib 
    gtk3
    libGL
    ros-tutorials
    geometry-tutorials
    rqt-tf-tree
    rviz
  ];
  
  LD_LIBRARY_PATH = with pkgs.xlibs; "${pkgs.libGL}/lib";

  shellHook = "source '${pkgs.rosPackages.noetic.gazebo}/share/gazebo-11/setup.sh'
               source devel/setup.bash";
}
