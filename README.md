# Ad Crusher

This script is for crushin' ads. Feed it one or more folders containing assets
related to display ads (banners), and it'll do its best to get that size down
to a minimum. It will output a .zip in the same directory that should be ready
to upload to an ad server (like Flashtalking).

## Dependencies
This script requires you have a few things available in your path:
- `pngquant`, available via `brew`
- `jpegoptim`, also available via `brew`
- `svgo`, installed globally via `npm` (`npm install --global svgo`)
- `uglifyjs`, also an `npm` package (`npm install --global uglify-js`)
- `html-minifier`, also an `npm` package (`npm install --global html-minifier`)

It should complain if you're missing these.

## Bugs
If this script makes things broken, open up an issue and I'll take a look!

## Roadmap
I'm considering rewriting this as a node module, to allow for more
configuration and an easier installation process. Other possible additions
include the ability to automatically load ad server components, and verifying
or automatically generating the `manifest.js` file required by Flashtalking. Or
anything else, really, the possibilities are endless!

One thing that could be implemented quickly would be switch options for
controlling the desired JPEG optimization level (currently set to 70).
