{
  # ********************************************************************************
  # Smoothfox
  # "Faber est suae quisque fortunae"
  # priority: better scrolling
  # version: 137
  # url: https://github.com/yokoffing/Betterfox
  # ********************************************************************************

  #############################################################
  # OPTION: SHARPEN SCROLLING
  #############################################################

  # # DEFAULT NON-LINUX: apz.overscroll.enabled = true;
  # "apz.overscroll.enabled" = true;

  # # DEFAULT: general.smoothScroll = true;
  # "general.smoothScroll" = true;

  # # default=5
  # "mousewheel.min_line_scroll_amount" = 10;

  # # default=50
  # "general.smoothScroll.mouseWheel.durationMinMS" = 80;

  # # default=.25
  # "general.smoothScroll.currentVelocityWeighting" = "0.15";

  # # default=.4
  # "general.smoothScroll.stopDecelerationWeighting" = "0.6";

  # # [FF122+ Nightly default]=true
  # "general.smoothScroll.msdPhysics.enabled" = false;

  #############################################################
  # OPTION: INSTANT SCROLLING (SIMPLE ADJUSTMENT)
  #############################################################

  # # DEFAULT NON-LINUX: apz.overscroll.enabled = true;
  # "apz.overscroll.enabled" = true;

  # # DEFAULT: general.smoothScroll = true;
  # "general.smoothScroll" = true;

  # # 250–400; adjust to your liking
  # "mousewheel.default.delta_multiplier_y" = 275;

  # # [FF122+ Nightly default]=true
  # "general.smoothScroll.msdPhysics.enabled" = false;

  #############################################################
  # OPTION: SMOOTH SCROLLING
  #############################################################

  # # DEFAULT NON-LINUX: apz.overscroll.enabled = true;
  # "apz.overscroll.enabled" = true;

  # # DEFAULT: general.smoothScroll = true;
  # "general.smoothScroll" = true;

  # # [FF122+ Nightly default]=true
  # "general.smoothScroll.msdPhysics.enabled" = true;

  # # 250–400; adjust to your liking
  # "mousewheel.default.delta_multiplier_y" = 300;

  #############################################################
  # OPTION: NATURAL SMOOTH SCROLLING V3 [MODIFIED]
  #############################################################

  # DEFAULT NON-LINUX: apz.overscroll.enabled = true;
  "apz.overscroll.enabled" = true;

  # DEFAULT: general.smoothScroll = true;
  "general.smoothScroll" = true;

  # control rate of continuous-motion updates
  "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;

  # [FF122+ Nightly default]=true
  "general.smoothScroll.msdPhysics.enabled" = true;

  "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
  "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
  "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
  # ratio; default undefined
  "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
  "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;

  # default=.25
  "general.smoothScroll.currentVelocityWeighting" = "1";
  # default=.4
  "general.smoothScroll.stopDecelerationWeighting" = "1";

  # 250–400; adjust to your liking
  "mousewheel.default.delta_multiplier_y" = 300;
}
