# rv-match_testing

## Setup

```
cd rv-match_testing
chmod +x run_all.sh && chmod +x tests/*/test.sh
./run_all.sh
```

## Folder Structure

- log/
  - 2017-11-22-14:52:25.log
  - 2017-11-19-14:37:16.log
  - ...
- tests/
  - <test_name>/
    - build/  
      _Downloaded files are put in here and compiled._
    - log/
      - 2017-11-22-14:52:25.log
      - 2017-11-19-14:37:16.log
      - ...
    - test.sh
- extract_output.sh
- prepare.sh  
  _This script will be put at the beginning of each test script passing the test name. This should be non-executable._
- project_testing.sh
- run_all.sh

## Gource
December 6, 2017
https://youtu.be/kAirik81ANs
`gource -a .4 -c 4.0 -1280x720 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 gource.mp4`
