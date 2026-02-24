{ ... }:
{
  services.lact.enable = true;

  environment.etc."lact/config.yaml".text = ''
    version: 5
    daemon:
      log_level: info
      admin_group: wheel
      disable_clocks_cleanup: false
    apply_settings_timer: 5
    gpus:
      1002:15BF-17AA:231C-0000:c4:00.0:
        fan_control_enabled: false
        performance_level: high
    current_profile: null
    auto_switch_profiles: false
  '';
}
