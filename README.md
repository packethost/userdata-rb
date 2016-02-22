CloudInit Userdata
==================

A Ruby client for parsing and validating CloudInit userdata.

[![Build Status](https://travis-ci.org/packethost/userdata-rb.svg)](https://travis-ci.org/packethost/userdata-rb)

Usage
-----

```ruby
require 'cloudinit_userdata'

userdata = CloudInit::Userdata.new <<-USERDATA.strip
  #!/bin/bash

  echo "Hello world!"
USERDATA

userdata.script? # true
userdata.cloud_config? # false
userdata.json? # false
userdata.valid? # true
```

Understand userdata scripts (begin with `#!`), JSON (used by CoreOS/ignition),
and all of the [core CloudInit formats](http://cloudinit.readthedocs.org/en/latest/topics/format.html).

Known Limitations
-----------------

* Currently, this library does not support [mime-multi part files](http://cloudinit.readthedocs.org/en/latest/topics/format.html#mime-multi-part-archive). We plan to eventually support this feature, but it is currently low priority.

Contributing
------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so we don't break it in a future version unintentionally. You can run the test suite with `bundle exec rake`.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so we can cherry-pick around it.

Copyright
---------

Copyright (c) 2016 Packet Host. See `LICENSE` for further details.
