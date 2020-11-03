#!/bin/bash

inputdir=$1
scratchdir=$2
outdir=$3
resourcedir=$4

fatalerror() {
    echo "-----------------------------------------------------------------------" >&2
    echo "FATAL ERROR: $*" >&2
    echo "-----------------------------------------------------------------------" >&2
    rm $scratchdir/${file_id}.wav 2>/dev/null
    if [ ! -z "$target_dir" ]; then
        echo "PATH=$PATH" >&2
        echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH" >&2
        echo "KALDI_ROOT=$KALDI_ROOT" >&2
        echo "[Index of $target_dir]" >&2
        du -ah $target_dir >&2
        echo "[End of index]">&2
        echo "[Output of intermediate log]" >&2
        cat $target_dir/intermediate/log >&2
        echo "[End output of intermediate log]">&2
        echo "[Output of intermediate lium logs]" >&2
        cat $target_dir/intermediate/data/ALL/liumlog/*.log >&2
        echo "[End output of intermediate log]">&2
        echo "[Output of other intermediate logs]" >&2
        cat $target_dir/intermediate/data/ALL/log/*.log >&2
        echo "[End output of other intermediate log]">&2
        echo "[Output of kaldi decode logs]" >&2
        cat $target_dir/intermediate/decode//log/decode*log >&2
        echo "[End of kaldi decode logs]" >&2
        if [ ! -z "$debug" ]; then
            echo "(cleaning intermediate files after error)">&2
            rm -Rf $target_dir
        fi
    fi
    exit 2
}

cd $resourcedir
suffix=$(LC_CTYPE=C tr -d -c '[:alnum:]' </dev/urandom | head -c 15)
for inputfile in $inputdir/*; do
  filename=$(basename "$inputfile")
  echo "Processing $filename">&2
  extension="${filename##*.}"
  file_id=$(basename "$inputfile").$extension
  sox $inputfile -e signed-integer -c 1 -r 16000 -b 16 "$scratchdir/${file_id}.wav" || fatalerror "sox failed"
  recog_dir_name="${file_id}_${suffix}"
  target_dir="$scratchdir/${recog_dir_name}"
  mkdir -p "$target_dir"

  ./recognize.sh "$scratchdir/${file_id}.wav" "$target_dir" || fatalerror "Recognizer failed";
  cp "$target_dir/${recog_dir_name}.txt" "$outdir/${file_id}.txt" || fatalerror "expected txt output not found"
  cp "$target_dir/${recog_dir_name}.ctm" "$outdir/${file_id}.ctm" || fatalerror "expected ctm output not found"
  ./scripts/ctm2xml.py "$outdir" "$file_id" "$scratchdir" || fatalerror "ctm2xml failed"
  ./scripts/ctm2tg.py "$outdir/${file_id}.ctm" "$scratchdir/${file_id}.wav" || fatalerror "ctm2tg failed"
  rm -f "$scratchdir/${file_id}.wav"

done
cd -
