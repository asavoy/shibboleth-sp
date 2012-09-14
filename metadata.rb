maintainer        "The Wharton School - The University of Pennsylvania"
maintainer_email  "chef-admins@wharton.upenn.edu"
license           "Apache 2.0"
description       "Installs/Configures Shibboleth Service Provider"
version           "0.0.1"
recipe            "shibboleth-sp", "Installs and enables base Shibboleth Service Provider."
recipe            "shibboleth-sp::apache", "Base recipe and Apache handling."
recipe            "shibboleth-sp::iis", "Base recipe and IIS handling."
recipe            "shibboleth-sp::simple", "Base recipe and simple attribute-driven configuration."

%w{ apache2 windows yum }.each do |d|
  depends d
end

%w{ redhat ubuntu windows }.each do |os|
  supports os
end