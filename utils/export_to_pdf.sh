#!/usr/bin/env sh

# output directory to place PDF to
output_dir="./"

# maximum number of lines-per-image
max_lines=50

if [[ $# -lt 1 ]]; then
  echo "usage: export_to_pdf.sh filename [output_dir]"
  exit
elif [[ $# == 2 ]]; then
  output_dir="$2/"
fi

file_path=$1
filename=$(basename ${file_path})
if [[ ! -f ${file_path} ]]; then
  echo "[!] file ${file_path} does not exist!"
  exit
fi
if [[ ! -d ${output_dir} ]]; then
  echo "[*] directory ${output_dir} does not exist!"
  exit
fi

lines=$( wc -l "${file_path}" | awk '{print $1}' )
images=$(( lines / max_lines ))
echo "[*] lines: ${lines}, images: $(( ${images}+1 ))"

tempdir=$(mktemp -d)
echo "[*] tempdir: ${tempdir}"

for i in $( seq 0 ${images} ); do
  head -$(( (i+1) * max_lines )) ${file_path} | \
  tail -${max_lines} | \
  silicon \
    --theme GitHub \
    --language Rust \
    --no-round-corner \
    --no-window-controls \
    --line-offset $(( i*max_lines + 1 ))\
    --window-title ${filename} \
    -o ${tempdir}/output${i}.png
done

prev_wd=$( pwd )
cd ${tempdir}
docker \
  run \
  --entrypoint=magick \
  -v ${tempdir}/:/imgs \
  dpokidov/imagemagick \
    -quality 100 \
    * \
    ${filename}.pdf

cd ${prev_wd}
mv ${tempdir}/${filename}.pdf ${output_dir}
