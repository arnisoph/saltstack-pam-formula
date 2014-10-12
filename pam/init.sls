#!jinja|yaml

{% from 'pam/defaults.yaml' import rawmap_osfam with context %}
{% set datamap = salt['grains.filter_by'](rawmap_osfam, merge=salt['grains.filter_by'](rawmap_os|default({}), grain='os', merge=salt['pillar.get']('pam:lookup'))) %}

include: {{ datamap.sls_include|default([]) }}
extend: {{ datamap.sls_extend|default({}) }}

pam_modules:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}

{% for k, v in datamap.component_config|default({})|dictsort %}
pam_comp_config_{{ k }}:
  file:
    - {{ v.ensure|default('managed') }}
    - name: {{ v.path|default('/etc/pam.d/' ~ k) }}
    - source: {{ v.source|default('salt://pam/files/component_config') }}
    - mode: {{ v.mode|default(644) }}
    - user: {{ v.user|default('root') }}
    - group: {{ v.group|default('root') }}
    - template: jinja
    - context:
      component_config: {{ v }}
{% endfor %}
