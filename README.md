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
./release.sh
cd ../web
./setup.sh
```

From there, you can configure and customize the downloader as you wish

## todo

- [ ] enhance CLIs using thor gem
- [ ] setup proper ci/cd to deploy gem locally and on rubygems.org
- [ ] implement loading spinner for loading messages
- [ ] implement progress bar with segment infos instead of full ffmpeg output
- [ ] extend list of supported video downloaders
- [ ] add cli arg to output .mp4 video into some custom dir
- [ ] update release.sh script to output its built gems into separate dir
- [ ] implement way to auto-name a video if no name was given
- [ ] implement cli arg to provide video author name
