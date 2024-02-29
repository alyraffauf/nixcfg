{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./qmk
      ./steam
      ./sound
    ];

}