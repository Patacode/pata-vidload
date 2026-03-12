# pata-vidload

Utility to download various type of videos from web to local. Primary focus
on a ruby lib using playwright to simulate browser sessions, capture network
traffic and remux videos into .mp4 format.

Targeted video types:

- **mp2t** (MPEG-2 Transport Stream)

## setup

To setup mp2t downloader:

```bash
cd bin/vidload
bundle install
rake release_local
cd ../web
bundle install
rake setup_playwright
```

From there, you can configure and customize the downloader as you wish.

## usage

To make use of mp2t downloader:

```ruby
require "vidload"

mp2t_downloader = Vidload::Mp2t::Api::Downloader.from_argv
mp2t_downloader.display_calling_args

# the below optionally takes 'video_starter_callbacks' named arg to customize
# the actions needed to be done to start the video
mp2t_downloader.download_video
```
