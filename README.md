# OC-ID cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/oc-id.svg?style=flat)][oc-id]
[![Build Status](http://img.shields.io/travis/kabisa-cookbooks/oc-id.svg?style=flat)][travis]

Installs Chef OC-ID oAuth 2.0 server

[oc-id]: https://supermarket.getchef.com/cookbooks/oc-id
[travis]: http://travis-ci.org/kabisa-cookbooks/oc-id

## Requirements

### Platforms

* Ubuntu (tested on 14.10)
* Debian (untested)

### Dependencies

* apt        `~> 2.6.0`
* runit      `~> 1.5.10`
* artifact   `~> 1.12.2`
* rubies     `~> 0.1.0`
* nodejs     `~> 2.1.0`
* postgresql `~> 3.4.2`
* database   `~> 2.3.0`
* nginx      `~> 2.7.4`

## Attributes

See the [default][] attribute file for configuration variables and
documentation.

[default]: attributes/default.rb

## Recipes

### Default

After setting the configuration variables, all that is left to do is to include
the default recipe:

```ruby
include_recipe 'oc-id::default'
```

You can visit the GUI on the `/` top level path.

## License and Author

Author:: Jean Mertz (<jean@mertz.fm>)

Copyright 2014, Kabisa ICT

Licensed under the MIT License (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://opensource.org/licenses/MIT

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
