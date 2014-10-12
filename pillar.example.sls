pam:
  lookup:
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
