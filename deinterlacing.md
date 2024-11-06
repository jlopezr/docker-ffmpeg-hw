# Hardware deinterlacing comparison

https://forums.developer.nvidia.com/t/nvdec-in-ffmpeg-cuvid-drops-frames-when-using-deinterlacing-deint-2/65837?page=2

```bash
ffmpeg -i bbb_sunflower_1080p_60fps_normal.mp4 -vcodec libx264 -pix_fmt nv12 -preset ultrafast -crf 0 -g 1 -acodec copy -f mp4 original.mp4 -y
ffmpeg -i original.mp4 -vcodec libx264 -pix_fmt nv12 -preset ultrafast -crf 0 -g 1 -vf tinterlace=interleave_top,fieldorder=tff -flags ilme+ildct -f mp4 interlaced.mp4 -y
ffmpeg -i interlaced.mp4 -vcodec libx264 -pix_fmt nv12 -preset ultrafast -crf 0 -g 1 -acodec copy -vf yadif=1 -r 60 -f mp4 deinterlaced_yadif.mp4 -y
ffmpeg -init_hw_device cuda=0 -i interlaced.mp4 -vcodec h264_nvenc -pix_fmt cuda -preset lossless -filter_hw_device 0 -vf hwupload,yadif_cuda=1 -acodec copy -r 60 -f mp4 deinterlaced_yadif_cuda.mp4
ffmpeg -i interlaced.mp4 -vcodec libx264 -pix_fmt nv12 -preset ultrafast -crf 0 -g 1 -acodec copy -vf yadif=1,mcdeint=fast:tff:1 -r 60 -f mp4 deinterlaced_mcdeint.mp4 -y
ffmpeg -vcodec h264_cuvid -deint adaptive -i interlaced.mp4 -vcodec libx264 -pix_fmt nv12 -preset ultrafast -crf 0 -g 1 -acodec copy -r 60 -f mp4 deinterlaced_cuvid.mp4 -y
ffmpeg -i deinterlaced_yadif.mp4 -i original.mp4 -lavfi ssim -f null -
ffmpeg -i deinterlaced_yadif_cuda.mp4 -i original.mp4 -lavfi ssim -f null -
ffmpeg -i deinterlaced_mcdeint.mp4 -i original.mp4 -lavfi ssim -f null -
ffmpeg -i deinterlaced_cuvid.mp4 -i original.mp4 -lavfi ssim -f null -
```
---

# Fair comparison

```bash
ffmpeg -hwaccel nvdec -hwaccel_output_format cuda -i interlaced.mp4 -vf yadif_cuda=mode=1 -c:v h264_nvenc -preset lossless -f mp4 deinterlaced_yadif_cuda.mp4
ffmpeg -hwaccel nvdec -hwaccel_output_format cuda -i interlaced.mp4 -vf hwdownload,format=nv12,yadif=mode=1,hwupload_cuda -c:v h264_nvenc -preset lossless -f mp4 deinterlaced_yadif.mp4
ffmpeg -hwaccel cuda -c:v h264_cuvid -deint adaptive -i interlaced.mp4 -r 50 -c:v h264_nvenc -preset lossless -f mp4 deinterlaced_cuvid.mp4
```
