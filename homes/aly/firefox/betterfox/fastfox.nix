{
  # ****************************************************************************
  # Fastfox
  # "Non ducor duco"
  # priority: speedy browsing
  # version: 137
  # url: https://github.com/yokoffing/Betterfox
  # ****************************************************************************

  #############################################################
  # SECTION: GENERAL
  #############################################################

  # "nglayout.initialpaint.delay" = 5;                    # DEFAULT; formerly 250
  # "nglayout.initialpaint.delay_in_oopif" = 5;           # DEFAULT
  # "content.notify.ontimer" = true;                      # DEFAULT
  "content.notify.interval" = 100000; # (.10s); default=120000 (.12s)

  # "browser.newtab.preload" = true;                       # DEFAULT
  # "dom.ipc.processPriorityManager.backgroundUsesEcoQoS" = false;
  # "browser.sessionstore.restore_on_demand" = true;       # DEFAULT
  # "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
  # "browser.sessionstore.restore_tabs_lazily" = true;     # DEFAULT
  # "browser.startup.preXulSkeletonUI" = false;
  # "dom.iframe_lazy_loading.enabled" = true;              # DEFAULT [FF121+]

  #############################################################
  # SECTION: GFX RENDERING TWEAKS
  #############################################################

  # "gfx.webrender.all" = true;
  # "gfx.webrender.precache-shaders" = true;
  # "gfx.webrender.compositor" = true;
  # "gfx.webrender.compositor.force-enabled" = true;
  # "gfx.webrender.software" = true;
  # "gfx.webrender.software.opengl" = true;
  # "gfx.canvas.accelerated" = true;
  # "gfx.canvas.accelerated.cache-items" = 8192;
  "gfx.canvas.accelerated.cache-size" = 512; # default=256; Chrome=512
  "gfx.content.skia-font-cache-size" = 20; # default=5; Chrome=20

  # "layers.gpu-process.enabled" = true;                   # DEFAULT WINDOWS
  # "layers.gpu-process.force-enabled" = true;
  # "layers.mlgpu.enabled" = true;                         # LINUX
  # "media.hardware-video-decoding.enabled" = true;        # DEFAULT WINDOWS macOS
  # "media.hardware-video-decoding.force-enabled" = true;
  # "media.gpu-process-decoder" = true;                    # DEFAULT WINDOWS
  # "media.ffmpeg.vaapi.enabled" = true;                   # LINUX

  #############################################################
  # SECTION: DISK CACHE
  #############################################################

  "browser.cache.disk.enable" = false;
  # "browser.cache.disk.smart_size.enabled" = false;
  # "browser.cache.disk.capacity" = 512000;
  # "browser.cache.disk.max_entry_size" = 51200;

  # "network.http.rcwn.enabled" = false;
  # "network.http.rcwn.small_resource_size_kb" = 256;

  # "browser.cache.disk.metadata_memory_limit" = 500;
  # "browser.cache.disk.preload_chunk_count" = 4;
  # "browser.cache.frecency_half_life_hours" = 6;
  # "browser.cache.disk.max_chunks_memory_usage" = 40960;
  # "browser.cache.disk.max_priority_chunks_memory_usage" = 40960;
  # "browser.cache.check_doc_frequency" = 3;
  # "browser.cache.disk.free_space_soft_limit" = 10240;
  # "browser.cache.disk.free_space_hard_limit" = 2048;
  # "browser.cache.jsbc_compression_level" = 3;
  # "dom.script_loader.bytecode_cache.enabled" = true;
  # "dom.script_loader.bytecode_cache.strategy" = 0;

  #############################################################
  # SECTION: MEMORY CACHE
  #############################################################

  # "browser.cache.memory.capacity" = -1;
  # "browser.cache.memory.max_entry_size" = 10240;
  # "browser.sessionhistory.max_total_viewers" = 4;

  #############################################################
  # SECTION: MEDIA CACHE
  #############################################################

  "media.memory_cache_max_size" = 65536; # default=8192; AF=65536; alt=131072
  # "media.memory_caches_combined_limit_kb" = 524288;
  # "media.memory_caches_combined_limit_pc_sysmem" = 5;
  # "media.mediasource.enabled" = true;
  "media.cache_readahead_limit" = 7200; # 120 min; default=60
  "media.cache_resume_threshold" = 3600; # 60 min; default=30

  #############################################################
  # SECTION: IMAGE CACHE
  #############################################################

  # "image.cache.size" = 5242880;
  "image.mem.decode_bytes_at_a_time" = 32768; # default=16384; alt=65536
  # "image.mem.shared.unmap.min_expiration_ms" = 120000;

  #############################################################
  # SECTION: NETWORK
  #############################################################

  # "network.buffer.cache.size" = 65535;
  # "network.buffer.cache.count" = 48;
  "network.http.max-connections" = 1800; # default=900
  "network.http.max-persistent-connections-per-server" = 10; # default=6
  "network.http.max-urgent-start-excessive-connections-per-host" = 5; # default=3
  # "network.http.max-persistent-connections-per-proxy" = 48;
  # "network.websocket.max-connections" = 200;

  "network.http.pacing.requests.enabled" = false;
  # "network.http.pacing.requests.min-parallelism" = 10;
  # "network.http.pacing.requests.burst" = 14;

  # "network.dnsCacheEntries" = 1000;
  "network.dnsCacheExpiration" = 3600;
  # "network.dnsCacheExpirationGracePeriod" = 240;
  # "network.dns.max_high_priority_threads" = 40;
  # "network.dns.max_any_priority_threads" = 24;

  "network.ssl_tokens_cache_capacity" = 10240; # default=2048

  #############################################################
  # SECTION: SPECULATIVE LOADING
  #############################################################

  "network.dns.disablePrefetch" = true;
  "network.dns.disablePrefetchFromHTTPS" = true; # [FF127+ false]
  # "network.preconnect" = true;
  # "browser.urlbar.speculativeConnect.enabled" = false;
  # "browser.places.speculativeConnect.enabled" = false;
  # "network.modulepreload" = true;
  "network.prefetch-next" = false;
  # "network.fetchpriority.enabled" = true;
  # "network.early-hints.enabled" = true;
  # "network.early-hints.preconnect.enabled" = true;
  # "network.early-hints.preconnect.max_connections" = 10;
  "network.predictor.enabled" = false;
  # "network.predictor.enable-prefetch" = false;
  # "network.predictor.enable-hover-on-ssl" = false;
  # "network.predictor.preresolve-min-confidence" = 60;
  # "network.predictor.preconnect-min-confidence" = 90;
  # "network.predictor.prefetch-min-confidence" = 100;
  # "network.predictor.prefetch-force-valid-for" = 10;
  # "network.predictor.prefetch-rolling-load-count" = 10;
  # "network.predictor.max-resources-per-entry" = 250;
  # "network.predictor.max-uri-length" = 1000;

  #############################################################
  # SECTION: EXPERIMENTAL
  #############################################################

  "layout.css.grid-template-masonry-value.enabled" = true;
  # "dom.enable_web_task_scheduling" = true;

  #############################################################
  # SECTION: TAB UNLOAD
  #############################################################

  # "browser.tabs.unloadOnLowMemory" = true;
  # "browser.low_commit_space_threshold_mb" = 3276;
  # "browser.low_commit_space_threshold_percent" = 20;
  # "browser.tabs.min_inactive_duration_before_unload" = 300000;

  #############################################################
  # SECTION: PROCESS COUNT
  #############################################################

  # "dom.ipc.processCount" = 8;
  # "dom.ipc.processCount.webIsolated" = 1;
  # "dom.ipc.processPrelaunch.fission.number" = 1;
  # "fission.webContentIsolationStrategy" = 1;
  # "browser.preferences.defaultPerformanceSettings.enabled" = true;
}
