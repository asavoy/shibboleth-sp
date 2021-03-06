name              "shibboleth-sp"
maintainer        ""
maintainer_email  ""
license           "Apache 2.0"
description       "Installs/Configures Shibboleth Service Provider"
version           "2.0.2"
recipe            "shibboleth-sp", "Installs and enables base Shibboleth Service Provider."
recipe            "shibboleth-sp::apache", "Base recipe and Apache handling."
recipe            "shibboleth-sp::iis", "Base recipe and IIS handling."
recipe            "shibboleth-sp::simple", "Base recipe and simple attribute-driven configuration."
recipe            "shibboleth-sp::sp_cert_key", "Recipe to configure sp cert and key using databags or node attributes."

%w{ apache2 windows yum }.each do |d|
  depends d
end

%w{ centos redhat ubuntu windows }.each do |os|
  supports os
end
