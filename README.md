CloudInit Userdata
==================

A Ruby client for parsing and validating CloudInit userdata.

[![Build Status](https://travis-ci.org/packethost/userdata-rb.svg)](https://travis-ci.org/packethost/userdata-rb)

Usage
-----

```ruby
require 'cloudinit_userdata'

userdata = CloudInit::Userdata.parse <<-USERDATA.strip
  #!/bin/bash

  echo "Hello world!"
USERDATA

userdata.class # CloudInit::Userdata::ShellScript
userdata.valid? # true
```

Currently understands all of the
[core CloudInit formats](http://cloudinit.readthedocs.org/en/latest/topics/format.html).
Mime Multipart and gzipped userdata are also supported.

An adapter is also included for JSON userdata (used by CoreOS/ignition), but it
is not loaded by default, since it is not part of the original implementation.
To include it, do the following somewhere:

```
require 'cloudinit_userdata/formats/json'
CloudInit::Userdata.register_format(CloudInit::Userdata::JSON)
```

Custom Adapters
---------------

You can implement formatters for your custom types of userdata. Formatters
should inherit from `CloudInit::Userdata`, and are expected to implement the
`.match?` method at minimum.

Formatters may also implement `#validate`, which will be called automatically
by `CloudInit::Userdata#valid?`.

Formatters may also implement `.mimetypes` and return an array of mimetype
strings that will be recognized for Mime Multipart userdata.

Finally, custom formatters must be registered with this library using the
`CloudInit::Userdata.register_format(<your format class>)`.

Known Limitations
-----------------

* This library does not validate the semantics of userdata, since the only way
  to do that accurately is to actually run the userdata on a machine, and we
  obviously can't do that. Rather, this library attempts to provide some basic
  intelligence and parse-checking around userdata formats.

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
