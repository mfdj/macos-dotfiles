# shellcheck disable=SC2148

<< DOC
  Usae:
    mage2_module_scaffold <vendor> <module>

  Note:
    This command is destructive — it will ovewrite app/code/<vendor>/<module>/etc/module.xml
DOC

mage2_module_scaffold() {
   local vendor=$1
   local module=$2
   local app_vendor_module=app/code/${vendor}/${module}

   mkdir -p "$app_vendor_module/etc"
   touch "$app_vendor_module"/{registration.php,etc/module.xml}

   cat << EOF > "${app_vendor_module}/registration.php"
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::MODULE,
    '${vendor}_${module}',
    __DIR__
);
EOF

   cat << EOF > "${app_vendor_module}/etc/module.xml"
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="${vendor}_${module}" setup_version="0.0.1" />
</config>
EOF

   cmd="bin/magento module:enable ${vendor}_${module} && bin/magento setup:upgrade && bin/magento setup:di:compile"
   echo -n "$cmd" | pbcopy
   echo "Enable with '$cmd' (in clipboard)"
}
