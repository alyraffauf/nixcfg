{
  lib,
  pkgs,
  ...
}: {
  config = {
    # Adapted from https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/common/audio.nix
    services.pipewire.wireplumber.configPackages = let
      outputName = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink";
      prettyName = "ThinkPad Speakers";

      # Pre-converted dB ➜ linear values (10 ** (dB / 20))
      db = {
        "-36" = 1.5848931924611134e-2;
        "-18.1" = 0.1244514611771385;
        "-12.0" = 0.2511886431509580;
        "-5.48" = 0.5321082592667942;
        "-4.76" = 0.5780960474057181;
        "-2.0" = 0.7943282347242815;
        "0.0" = 1.0;
        "8.1" = 2.5409727055493048;
        "10.0" = 3.1622776601683795;
      };

      json = pkgs.formats.json {};

      # ──────────────────────────────────────────────────────────
      #  Filter-chain JSON (now with a post-gain stage)
      # ──────────────────────────────────────────────────────────
      filter-chain = json.generate "filter-chain.json" {
        "node.description" = prettyName;
        "media.name" = prettyName;

        "filter.graph" = {
          nodes = [
            # ── Loudness compensation ──
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/loud_comp_stereo";
              name = "el";
              control = {
                enabled = 1;
                input = 1.0;
                fft = 4;
              };
            }

            # ── 8-band EQ ──
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/para_equalizer_x8_lr";
              name = "x1ceq";
              control = {
                mode = 0;
                react = 0.2;
                zoom = db."-36";
                # (full per-band settings unchanged)
                fl_0 = 101.0;
                fml_0 = 0;
                ftl_0 = 5;
                gl_0 = db."-12.0";
                huel_0 = 0.0;
                ql_0 = 4.36;
                sl_0 = 0;
                wl_0 = 4.0;
                fl_1 = 451.0;
                fml_1 = 0;
                ftl_1 = 1;
                gl_1 = db."-5.48";
                huel_1 = 0.03125;
                ql_1 = 2.46;
                sl_1 = 0;
                wl_1 = 4.0;
                fl_2 = 918.0;
                fml_2 = 0;
                ftl_2 = 1;
                gl_2 = db."-4.76";
                huel_2 = 0.0625;
                ql_2 = 2.44;
                sl_2 = 0;
                wl_2 = 4.0;
                fl_3 = 9700.0;
                fml_3 = 0;
                ftl_3 = 1;
                gl_3 = db."0.0";
                huel_3 = 0.09375;
                ql_3 = 2.0;
                sl_3 = 0;
                wl_3 = 4.0;

                fr_0 = 101.0;
                fmr_0 = 0;
                ftr_0 = 5;
                gr_0 = db."-12.0";
                huer_0 = 0.0;
                qr_0 = 4.36;
                sr_0 = 0;
                wr_0 = 4.0;
                fr_1 = 451.0;
                fmr_1 = 0;
                ftr_1 = 1;
                gr_1 = db."-5.48";
                huer_1 = 0.03125;
                qr_1 = 2.46;
                sr_1 = 0;
                wr_1 = 4.0;
                fr_2 = 918.0;
                fmr_2 = 0;
                ftr_2 = 1;
                gr_2 = db."-4.76";
                huer_2 = 0.0625;
                qr_2 = 2.44;
                sr_2 = 0;
                wr_2 = 4.0;
                fr_3 = 9700.0;
                fmr_3 = 0;
                ftr_3 = 1;
                gr_3 = db."0.0";
                huer_3 = 0.09375;
                qr_3 = 2.0;
                sr_3 = 0;
                wr_3 = 4.0;
              };
            }

            # ── Multiband compressor (woofer_bp) ──
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/mb_compressor_stereo";
              name = "woofer_bp";
              control = {
                mode = 0;
                ce_0 = 1;
                sla_0 = 5.0;
                cr_0 = 1.75;
                al_0 = 0.725;
                at_0 = 1.0;
                rt_0 = 100;
                kn_0 = 0.125;
                cbe_1 = 1;
                sf_1 = 200.0;
              };
            }

            # ── Limiter (woofer_lim) ──
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/compressor_stereo";
              name = "woofer_lim";
              control = {
                sla = 5.0;
                al = 1.0;
                at = 1.0;
                rt = 100.0;
                cr = 15.0;
                kn = 0.5;
              };
            }

            # ── NEW post-gain stage ──
            {
              type = "lv2";
              plugin = "http://lsp-plug.in/plugins/lv2/gain_stereo";
              name = "post_gain";
              control = {
                gain = db."8.1"; # +8 dB starting point
              };
            }
          ];

          # ── Wiring ──
          links = [
            {
              output = "el:out_l";
              input = "x1ceq:in_l";
            }
            {
              output = "el:out_r";
              input = "x1ceq:in_r";
            }

            {
              output = "x1ceq:out_l";
              input = "woofer_bp:in_l";
            }
            {
              output = "x1ceq:out_r";
              input = "woofer_bp:in_r";
            }

            {
              output = "woofer_bp:out_l";
              input = "woofer_lim:in_l";
            }
            {
              output = "woofer_bp:out_r";
              input = "woofer_lim:in_r";
            }

            # send limiter → post-gain
            {
              output = "woofer_lim:out_l";
              input = "post_gain:in_l";
            }
            {
              output = "woofer_lim:out_r";
              input = "post_gain:in_r";
            }
          ];

          # Final audio leaves the post-gain node
          outputs = [
            "post_gain:out_l"
            "post_gain:out_r"
          ];

          # Desktop volume control now drives post_gain
          "capture.volumes" = [
            {
              control = "post_gain:gain";
              min = -20.0;
              max = 10.0;
              scale = "cubic";
            }
          ];
        };

        # ── Device props (unchanged except default-volume removed) ──
        "capture.props" = {
          "node.name" = "audio_effect.laptop-convolver";
          "media.class" = "Audio/Sink";
          "audio.channels" = "2";
          "audio.position" = ["FL" "FR"];
          "audio.allowed-rates" = [44100 48000 88200 96000 176400 192000];
          "device.api" = "dsp";
          "node.virtual" = "false";
          "priority.session" = 1500;
          "priority.driver" = 1500;
          "device.icon-name" = "audio-card-analog-pci";
        };

        "playback.props" = {
          "node.name" = "audio_effect.laptop-convolver";
          "target.object" = outputName;
          "node.passive" = "true";
          "audio.channels" = "2";
          "audio.allowed-rates" = [44100 48000 88200 96000 176400 192000];
          "audio.position" = ["FL" "FR"];
          "device.icon-name" = "audio-card-analog-pci";
        };
      };

      # ──────────────────────────────────────────────────────────
      #  WirePlumber rule set
      # ──────────────────────────────────────────────────────────
      configPackage =
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-x1c.conf" ''
          monitor.alsa.rules = [
            {
              matches = [{ node.name = "${outputName}" }]
              actions = {
                update-props = { audio.allowed-rates = [44100, 48000, 88200, 96000, 176400, 192000] }
              }
            }
          ]

          node.software-dsp.rules = [
            {
              matches = [{ node.name = "${outputName}" }]
              actions = {
                create-filter = {
                  filter-path  = "${filter-chain}"
                  hide-parent  = ${lib.boolToString true}
                }
              }
            }
          ]

          wireplumber.profiles = {
            main = { node.software-dsp = "required"; }
          }
        '')
        // {
          passthru.requiredLv2Packages = with pkgs; [
            lsp-plugins
            bankstown-lv2
          ];
        };
    in [configPackage];
  };
}
