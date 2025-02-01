# Lenovo Yoga Pro 9i 16IMH9

Optimized hardware configuration for Lenovo Yoga Pro 9i (16IMH9).

______________________________________________________________________

## Audio

- **Workaround**: Bass speakers malfunction due to runtime power management bugs for TAS2781 amp (kernel 6.12.x+).
  - Blacklists `snd_hda_scodec_tas2781_i2c` kernel module.
  - Runs [`turn-on-speakers.sh`](turn-on-speakers.sh) to power on TAS2781 amp and bass speakers via I2C.
  - Unmutes headphones with `amixer`.
- Further enhances sound quality with EasyEffects preset: [`16IMH9.json`](./16IMH9.json).

______________________________________________________________________

## Graphics

- Hybrid NVIDIA PRIME setup with Render Offload:
  - Intel GPU: `intelBusId = "PCI:0:2:0"`.
  - NVIDIA GPU: `nvidiaBusId = "PCI:1:0:0"`.
- Includes specialisation `nvidia-sync` to enable PRIME Synchronization.
- **Workaround**: High power usage while watching videos.
  - Disables `hardware.nvidia.videoAcceleration` to allow NVIDIA GPU to sleep during video playback.
  - Uses integrated Intel Arc GPU for WebRender.

______________________________________________________________________
