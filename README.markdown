#openssl

####Table of Contents

1. [Overview - What is the openssl module?](#overview)
2. [Module Description - What does the openssl module do?](#module-description)
3. [Setup - The basics of getting started with openssl](#setup)
    * [What openssl affects](#what-openssl-affects)
    * [Beginning with openssl](#beginning-with-openssl)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [License](#license)

##Overview

Manages certificates using OpenSSL.

##Module Description

The `openssl` module adds a type that generates an RSA keypair and a
self-signed X.509 certificate using OpenSSL.

##Setup

The best way to install this module is by executing the following command on
your puppet master or local Puppet install:

    $ puppet module install [--modulepath <path>] rlenglet/openssl

The above command also includes the optional argument to specify your puppet
master's `modulepath` as the location to install the module.

###What openssl affects

* RSA keypairs in `/etc/ssl/private`.
* X.509 certificates in `/etc/ssl`.

###Beginning with openssl

Specify a resource of type `openssl::self_signed_certificate` to generate an
RSA keypair and self-signed X.509 certificate files of the same name.

For instance, a resource names `apache` creates files named
`/etc/ssl/private/apache.key` and `/etc/ssl/apache.pem`:

    openssl::self_signed_certificate { apache:
      key_bits => 2048,
      cert_days => 1095,
      cert_country => US,
      cert_state => California,
      cert_organization => Foobar,
      cert_common_names => ["www.foobar.com", "webmail.foobar.com"],
      cert_email_address => "admin@foobar.com",
    }

##Usage

###Defined Type: `openssl::self_signed_certificate`

####Parameters

#####`key_bits`

The number of bits of the RSA public key to generate.  If not specified,
defaults to `1024`.

#####`key_owner`

The user to whom the keypair file should belong.  Argument can be a user name
or a user ID.  If not specified, defaults to `root`.

#####`key_group`

The group to whom the keypair file should belong.  Argument can be a group
name or a group ID.  If not specified, defaults to `root`.

#####`key_mode`

The desired permissions mode for the keypair file, in symbolic or numeric
notation.  If not specified, defaults to `0600`.

#####`cert_days`

The validity period of the X.509 certificate, in days.  If not specified,
defaults to `365`.

#####`cert_country`

The country code part of the X.509 certificate's distinguished name.
Optional.

#####`cert_state`

The state / province part of the X.509 certificate's distinguished name.
Optional.

#####`cert_locality`

The locality part of the X.509 certificate's distinguished name.  Optional.

#####`cert_organization`

The organization part of the X.509 certificate's distinguished name.
Optional.

#####`cert_common_names`

The list of common names in the X.509 certificate's distinguished name.
Optional.

#####`cert_email_address`

The X.509 certificate's contact email address.  Optional.

##Limitations

The keypair file is created in `/etc/ssl/private`, and the certificate
is created in `/etc/ssl`, which are the standard directories on
Debian/Ubuntu.  The files are named after the resource:
`/etc/ssl/private/<name>.key` and `/etc/ssl/<name>.pem`.  Certificate
files are owned by `root:root`, and have permissions `0644`.

The generated keypair and certificate files are not protected: if any
parameter is changed, they are re-generated.

##Development

Feedback and contributions are appreciated, in the form of issues or
pull requests on [the Github project
page](https://github.com/rlenglet/puppet-openssl).

##License

Copyright 2014 Romain Lenglet

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License.  You may
obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.
