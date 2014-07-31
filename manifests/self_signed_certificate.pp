# == Define: openssl::self_signed_certificate
#
# Generates an RSA keypair and a self-signed X.509 certificate using OpenSSL.
#
# The keypair file is created in /etc/ssl/private, and the certificate is
# created in /etc/ssl, which are the standard directories on
# Debian/Ubuntu.  The files are named after the resource:
# /etc/ssl/private/<name>.key and /etc/ssl/<name>.pem.  Certificate files are
# owned by root:root, and have permissions 0644.
#
# The generated keypair and certificate files are not protected: if any
# parameter is changed, they are re-generated.
#
# === Parameters
#
# [*key_bits*]
#   The number of bits of the RSA public key to generate.  If not specified,
#   defaults to 1024.
#
# [*key_owner*]
#   The user to whom the keypair file should belong.  Argument can be a user
# name or a user ID.  If not specified, defaults to "root".
#
# [*key_group*]
#   The group to whom the keypair file should belong.  Argument can be a group
#   name or a group ID.  If not specified, defaults to "root".
#
# [*key_mode*]
#   The desired permissions mode for the keypair file, in symbolic or numeric
#   notation.  If not specified, defaults to "0600".
#
# [*cert_days*]
#   The validity period of the X.509 certificate, in days.  If not specified,
#   defaults to 365.
#
# [*cert_country*]
#   The country code part of the X.509 certificate's distinguished name.
#   Optional.
#
# [*cert_state*]
#   The state / province part of the X.509 certificate's distinguished name.
#   Optional.
#
# [*cert_locality*]
#   The locality part of the X.509 certificate's distinguished name. Optional.
#
# [*cert_organization*]
#   The organization part of the X.509 certificate's distinguished name.
#   Optional.
#
# [*cert_common_names*]
#   The list of common names in the X.509 certificate's distinguished name.
#   Optional.
#
# [*cert_email_address*]
#   The X.509 certificate's contact email address.  Optional.
#
# === Examples
#
#  openssl::self_signed_certificate { apache:
#    key_bits => 2048,
#    cert_days => 1095,
#    cert_country => US,
#    cert_state => California,
#    cert_organization => Foobar,
#    cert_common_names => ["www.foobar.com", "webmail.foobar.com"],
#    cert_email_address => "admin@foobar.com",
#  }
#
# === Authors
#
# Romain Lenglet <romain.lenglet@berabera.info>
#
# === Copyright
#
# Copyright 2014 Romain Lenglet
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

define openssl::self_signed_certificate (
  $key_bits=1024,
  $key_owner="root",
  $key_group="root",
  $key_mode="0600",
  $cert_days=365,
  $cert_country=undef,
  $cert_state=undef,
  $cert_locality=undef,
  $cert_organization=undef,
  $cert_common_names=[],
  $cert_email_address=undef) {
  include openssl::setup

  $openssl_cnf = "${::puppet_vardir}/openssl/${name}.cnf"
  $key = "/etc/ssl/private/${name}.key"
  $cert = "/etc/ssl/${name}.pem"

  file { $openssl_cnf:
    content => template("${module_name}/openssl.cnf.erb"),
    owner => root,
    group => root,
    mode => "0600",
  }

  # Generate an RSA private key in /etc/ssl/private, with the right mode.
  # Re-generate the private key when the config changes, esp. the number of
  # bits.
  exec { "openssl gen-private-key ${key}":
    command => "/usr/bin/openssl genrsa -out ${key} ${key_bits}",
    onlyif => "/usr/bin/test ${key} -ot ${openssl_cnf}",
    require => [Package["openssl"], File[$openssl_cnf]],
    subscribe => File[$openssl_cnf],
    user => root,
    group => root,
  }
  file { $key:
    require => Exec["openssl gen-private-key ${key}"],
    owner => $key_owner,
    group => $key_group,
    mode => $key_mode,
  }

  # Generate a self-signed X.509 certificate using the private key.
  exec { "openssl req-self-signed-x509 ${cert}":
    command => "/usr/bin/openssl req -config ${openssl_cnf} -new -batch -x509 -nodes -days ${cert_days} -out ${cert} -key ${key}",
    onlyif => "/usr/bin/test ${cert} -ot ${openssl_cnf} -o ${cert} -ot ${key}",
    require => [Package["openssl"], File[$openssl_cnf], File[$key]],
    subscribe => [File[$openssl_cnf], File[$key]],
    user => root,
    group => root,
  }
  file { $cert:
    require => Exec["openssl req-self-signed-x509 ${cert}"],
    owner => root,
    group => root,
    mode => "0644",
  }
}