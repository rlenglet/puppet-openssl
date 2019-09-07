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

class openssl::setup {
  package { openssl:
    ensure => present,
  }

  file { "${::puppet_vardir}/openssl":
    ensure => directory,
    purge  => true,
    owner  => root,
    group  => root,
    mode   => '0700',
  }

  file { "/etc/ssl/private":
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0700',
  }

}
