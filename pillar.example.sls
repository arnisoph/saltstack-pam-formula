pam:
  lookup:
{% if salt['grains.get']('os_family') == 'Debian' %}
    pkgs:
      - libpam-modules
      - libpam-yubico
    component_config:
      sudo:
        - plain:
          - '#%PAM-1.0'
          - '@include common-auth'
          - '@include common-account'
          - '@include common-session-noninteractive'
        - facility: auth
          control: sufficient
          module: pam_yubico.so
          args:
            - id=16
            - authfile=/etc/yubico/authorized_yubikeys
            - debug
{% elif salt['grains.get']('os_family') == 'RedHat' %}
    pkgs:
      - pam
      - libyubikey
      - pam_yubico
    component_config:
      sudo:
        - plain:
          - '#%PAM-1.0'
        - facility: auth
          control: include
          module: system-auth
        - facility: account
          control: include
          module: system-auth
        - facility: password
          control: include
          module: system-auth
        - facility: session
          control: optional
          module: pam_keyinit.so
          args:
            - revoke
        - facility: session
          control: required
          module: pam_limits.so
        - facility: auth
          control: sufficient
          module: pam_yubico.so
          args:
            - id=16
            - authfile=/etc/yubico/authorized_yubikeys
            - debug
{% endif %}
