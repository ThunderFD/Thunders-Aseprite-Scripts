# Thunders Aseprite Scripts
Scripts that I've written to help me automate repetitive tasks in Aseprite.

you can find more useful scripts and instructions on how to install/use them [in this thread (link)](https://community.aseprite.org/t/aseprite-scripts-collection/3599)


## save_tags_as_gifs.lua

saves tags as gifs and appends "\_tagname" to each exported gif.

special cases:
- if the tag starts with "!" it's ignored (not exported)
- if the tag starts with "#" the sprite is cropped before export

## clean_dainapp_output.lua

THIS SCRIPT IS A WORK IN PROGRESS

tries to clean up the result of interpolating an animated sprite with DAINapp to remove some artifacts.
before interpolating the sprite has to be upscaled 4x

after running the script:
- load original palette
- set image color mode to indexed
- resize image back to original scale (0.25x)

## Contributing
Feel free to open issues if there's any bugs / you want to contribute some changes.